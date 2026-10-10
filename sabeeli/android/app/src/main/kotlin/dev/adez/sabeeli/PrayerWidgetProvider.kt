package dev.adez.sabeeli

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import org.json.JSONArray

/**
 * The next prayer on the home screen.
 *
 * The app writes the coming prayers (names and times already localized) with
 * [save]; the widget only picks the next one. To stay current it sets one
 * non-waking alarm for the moment that prayer begins: a handful of updates a
 * day, no polling, no exact-alarm permission.
 */
class PrayerWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        render(context, manager, ids)
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == ACTION_REFRESH ||
            intent.action == Intent.ACTION_TIME_CHANGED ||
            intent.action == Intent.ACTION_TIMEZONE_CHANGED
        ) {
            refresh(context)
        }
    }

    companion object {
        private const val PREFS = "sabeeli_widget"
        private const val ACTION_REFRESH = "dev.adez.sabeeli.WIDGET_REFRESH"

        fun save(context: Context, entries: String, caption: String, empty: String) {
            context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).edit()
                .putString("entries", entries)
                .putString("caption", caption)
                .putString("empty", empty)
                .apply()
            refresh(context)
        }

        fun refresh(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(
                ComponentName(context, PrayerWidgetProvider::class.java),
            )
            render(context, manager, ids)
        }

        private fun render(context: Context, manager: AppWidgetManager, ids: IntArray) {
            if (ids.isEmpty()) return
            val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            val now = System.currentTimeMillis()
            val entries = try {
                JSONArray(prefs.getString("entries", "[]"))
            } catch (e: Exception) {
                JSONArray()
            }
            // The first prayer still to come.
            var next = -1
            for (i in 0 until entries.length()) {
                if (entries.getJSONObject(i).getLong("t") > now) {
                    next = i
                    break
                }
            }

            val views = RemoteViews(context.packageName, R.layout.prayer_widget)
            if (next == -1) {
                views.setTextViewText(R.id.widget_caption, "")
                views.setTextViewText(R.id.widget_name, prefs.getString("empty", "Sabeeli"))
                views.setViewVisibility(R.id.widget_time, View.GONE)
                views.setViewVisibility(R.id.widget_then, View.GONE)
            } else {
                val entry = entries.getJSONObject(next)
                views.setTextViewText(R.id.widget_caption, prefs.getString("caption", ""))
                views.setTextViewText(R.id.widget_name, entry.getString("n"))
                views.setViewVisibility(R.id.widget_time, View.VISIBLE)
                views.setTextViewText(R.id.widget_time, entry.getString("l"))
                if (next + 1 < entries.length()) {
                    val then = entries.getJSONObject(next + 1)
                    views.setViewVisibility(R.id.widget_then, View.VISIBLE)
                    views.setTextViewText(
                        R.id.widget_then,
                        then.getString("n") + "  " + then.getString("l"),
                    )
                } else {
                    views.setViewVisibility(R.id.widget_then, View.GONE)
                }
                scheduleRefresh(context, entry.getLong("t") + 1000)
            }

            // A tap opens the day.
            val open = Intent(Intent.ACTION_VIEW, Uri.parse("sabeeli://today/day"))
                .setPackage(context.packageName)
            views.setOnClickPendingIntent(
                R.id.widget_root,
                PendingIntent.getActivity(
                    context, 0, open,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
                ),
            )
            manager.updateAppWidget(ids, views)
        }

        /** One non-waking alarm: if the phone sleeps, the widget updates when it wakes. */
        private fun scheduleRefresh(context: Context, at: Long) {
            val intent = Intent(context, PrayerWidgetProvider::class.java).setAction(ACTION_REFRESH)
            val pending = PendingIntent.getBroadcast(
                context, 0, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )
            val alarms = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            alarms.set(AlarmManager.RTC, at, pending)
        }
    }
}
