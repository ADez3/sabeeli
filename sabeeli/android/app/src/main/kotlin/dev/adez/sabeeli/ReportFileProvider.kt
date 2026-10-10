package dev.adez.sabeeli

import android.content.ContentProvider
import android.content.ContentValues
import android.database.Cursor
import android.database.MatrixCursor
import android.net.Uri
import android.os.ParcelFileDescriptor
import android.provider.OpenableColumns
import java.io.File

/**
 * Lends the problem-report screenshot to the mail app, read-only. Serves one
 * folder of the cache (reports/) and nothing else; written here rather than
 * pulling in a support library for a single file.
 */
class ReportFileProvider : ContentProvider() {

    override fun onCreate() = true

    private fun fileFor(uri: Uri): File? {
        val dir = File(context!!.cacheDir, "reports")
        val file = File(dir, uri.lastPathSegment ?: return null)
        // Never outside reports/.
        return if (file.canonicalPath.startsWith(dir.canonicalPath) && file.exists()) file else null
    }

    override fun openFile(uri: Uri, mode: String): ParcelFileDescriptor? {
        val file = fileFor(uri) ?: return null
        return ParcelFileDescriptor.open(file, ParcelFileDescriptor.MODE_READ_ONLY)
    }

    override fun getType(uri: Uri) = "image/png"

    override fun query(
        uri: Uri,
        projection: Array<out String>?,
        selection: String?,
        selectionArgs: Array<out String>?,
        sortOrder: String?,
    ): Cursor? {
        val file = fileFor(uri) ?: return null
        val cursor = MatrixCursor(arrayOf(OpenableColumns.DISPLAY_NAME, OpenableColumns.SIZE))
        cursor.addRow(arrayOf<Any>(file.name, file.length()))
        return cursor
    }

    override fun insert(uri: Uri, values: ContentValues?): Uri? = null

    override fun delete(uri: Uri, selection: String?, selectionArgs: Array<out String>?) = 0

    override fun update(
        uri: Uri,
        values: ContentValues?,
        selection: String?,
        selectionArgs: Array<out String>?,
    ) = 0

    companion object {
        fun uriFor(packageName: String, file: File): Uri =
            Uri.parse("content://$packageName.reports/${file.name}")
    }
}
