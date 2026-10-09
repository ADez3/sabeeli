"""Build assets/quran/translations_catalog.json from fawazahmed0/quran-api editions.json
and verify each chosen edition downloads with 6236 verses."""
import json, os, urllib.request
HERE = os.path.dirname(os.path.abspath(__file__))
ed = json.load(urllib.request.urlopen('https://cdn.jsdelivr.net/gh/fawazahmed0/quran-api@1/editions.json'))
PICK = [('fr','fra-muhammadhamidul'),('ur','urd-muhammadjunagar'),('id','ind-indonesianislam'),
 ('tr','tur-diyanetisleri'),('ms','msa-abdullahmuhamma'),('bn','ben-abubakrzakaria'),('fa','fas-drhussientagi'),
 ('de','deu-frankbubenheima'),('es','spa-muhammadisagarc'),('ru','rus-elmirkuliev'),('ha','hau-abubakarmahmoud'),
 ('sw','swa-alimuhsinalbarw'),('so','som-mahmudmuhammada'),('ps','pus-zakariaabulsala'),('uz','uzb-muhammadsodikmu'),
 ('az','aze-alikhanmusayev'),('sq','sqi-sherifahmeti'),('bs','bos-besimkorkut'),('hi','hin-maulanaazizulha'),
 ('zh','zho-majian'),('ja','jpn-ryoichimita'),('ko','kor-hamidchoi'),('it','ita-hamzarobertopic'),
 ('nl','nld-sofianssiregar'),('pt','por-helminasr'),('ta','tam-janturstfoundat'),('ml','mal-abdulhameedmada'),
 ('th','tha-kingfahadquranc'),
 ('en','eng-mustafakhattaba'),('ar','ara-jalaladdinalmah'),('ar','ara-sirajtafseer')]
by_name = {v['name']: v for v in ed.values()}
out = []
for lang, eid in PICK:
    v = by_name[eid]
    url = v['linkmin']
    d = json.load(urllib.request.urlopen(url))
    n = len(d['quran'])
    assert n == 6236, (eid, n)
    kind = 'tafsir' if eid.startswith('ara-') else 'translation'
    out.append({'lang': lang, 'id': eid, 'name': v['author'], 'language': v['language'], 'dir': v['direction'],
                'kind': kind, 'source': v.get('source', ''), 'url': url,
                'fallbackUrl': 'https://raw.githubusercontent.com/fawazahmed0/quran-api/1/editions/' + eid + '.min.json'})
    print(lang, eid, n, d['quran'][0]['text'][:50].encode('unicode_escape')[:60])
json.dump(out, open(os.path.join(HERE, '..', '..', 'assets', 'quran', 'translations_catalog.json'), 'w', encoding='utf-8', newline='\n'), ensure_ascii=False, indent=1)
