import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/card_track_widget.dart';
import 'package:songswipe/services/api/internal_api.dart';

/// Vista para la pantalla de descubrimiento <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class DiscoverView extends StatefulWidget {
  const DiscoverView({super.key});

  @override
  State<DiscoverView> createState() => _DiscoverViewState();
}

class _DiscoverViewState extends State<DiscoverView> {
  // Obtenemos el usuario actual
  final User _user = FirebaseAuth.instance.currentUser!;

  // Variable que almacena el uid del usuario
  late String _uid;

  // Variable que almacena el usersettings
  UserSettings _userSettings = UserSettings.empty();
  
  @override
  void initState() {
    super.initState();
    // Almacenamos el uid del usuario
    _uid = _user.uid;
    
    // Obtenemos los datos del usuario
    _getUserSettings();
  }

  // Este método será llamado desde HomeScreen para comprobar si hay cambios en los ajustes del usuario
  void refresh() {
    _getUserSettings();
  }

  // Función que obtiene los datos del usuario de la api
  void _getUserSettings() async {
    UserSettings settings = await getUserSettings(uid: _uid);
    if (mounted) {
      setState(() {
        _userSettings = settings;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    Track track = Track.fromJson({
    "id": 3335952911,
    "readable": true,
    "title": "RAMEN PARA DOS",
    "title_short": "RAMEN PARA DOS",
    "title_version": "",
    "isrc": "USWL12501332",
    "link": "https://www.deezer.com/track/3335952911",
    "share": "https://www.deezer.com/track/3335952911?utm_source=deezer&utm_content=track-3335952911&utm_term=0_1746974882&utm_medium=web",
    "duration": 231,
    "track_position": 1,
    "disk_number": 1,
    "rank": 671303,
    "release_date": "2025-05-08",
    "explicit_lyrics": true,
    "explicit_content_lyrics": 1,
    "explicit_content_cover": 2,
    "preview": "https://cdnt-preview.dzcdn.net/api/1/1/9/6/e/0/96e4644aa86a3d32dd7909e66d8c2894.mp3?hdnea=exp=1746975782~acl=/api/1/1/9/6/e/0/96e4644aa86a3d32dd7909e66d8c2894.mp3*~data=user_id=0,application_id=42~hmac=b82aae2b893e3cea63cb0e3c8a58aa7a8c70d284823555e1045b64ed3113b351",
    "bpm": 0,
    "gain": -7.4,
    "available_countries": [
        "AE",
        "AF",
        "AG",
        "AI",
        "AL",
        "AM",
        "AO",
        "AQ",
        "AR",
        "AS",
        "AT",
        "AU",
        "AZ",
        "BA",
        "BB",
        "BD",
        "BE",
        "BF",
        "BG",
        "BH",
        "BI",
        "BJ",
        "BN",
        "BO",
        "BQ",
        "BR",
        "BT",
        "BV",
        "BW",
        "CA",
        "CC",
        "CD",
        "CF",
        "CG",
        "CH",
        "CI",
        "CK",
        "CL",
        "CM",
        "CN",
        "CO",
        "CR",
        "CV",
        "CW",
        "CX",
        "CY",
        "CZ",
        "DE",
        "DJ",
        "DK",
        "DM",
        "DO",
        "DZ",
        "EC",
        "EE",
        "EG",
        "EH",
        "ER",
        "ES",
        "ET",
        "FI",
        "FJ",
        "FK",
        "FM",
        "FR",
        "GA",
        "GB",
        "GD",
        "GE",
        "GH",
        "GM",
        "GN",
        "GQ",
        "GR",
        "GS",
        "GT",
        "GU",
        "GW",
        "HK",
        "HM",
        "HN",
        "HR",
        "HU",
        "ID",
        "IE",
        "IL",
        "IN",
        "IO",
        "IQ",
        "IS",
        "IT",
        "JM",
        "JO",
        "JP",
        "KE",
        "KG",
        "KH",
        "KI",
        "KM",
        "KN",
        "KR",
        "KW",
        "KY",
        "KZ",
        "LA",
        "LB",
        "LC",
        "LK",
        "LR",
        "LS",
        "LT",
        "LU",
        "LV",
        "LY",
        "MA",
        "MD",
        "ME",
        "MG",
        "MH",
        "MK",
        "ML",
        "MM",
        "MN",
        "MP",
        "MR",
        "MS",
        "MT",
        "MU",
        "MV",
        "MW",
        "MX",
        "MY",
        "MZ",
        "NA",
        "NE",
        "NF",
        "NG",
        "NI",
        "NL",
        "NO",
        "NP",
        "NR",
        "NU",
        "NZ",
        "OM",
        "PA",
        "PE",
        "PG",
        "PH",
        "PK",
        "PL",
        "PN",
        "PS",
        "PT",
        "PW",
        "PY",
        "QA",
        "RO",
        "RS",
        "RW",
        "SA",
        "SB",
        "SC",
        "SD",
        "SE",
        "SG",
        "SI",
        "SJ",
        "SK",
        "SL",
        "SN",
        "SO",
        "SS",
        "ST",
        "SV",
        "SX",
        "SZ",
        "TC",
        "TD",
        "TG",
        "TH",
        "TJ",
        "TK",
        "TL",
        "TM",
        "TN",
        "TO",
        "TR",
        "TV",
        "TW",
        "TZ",
        "UA",
        "UG",
        "US",
        "UY",
        "UZ",
        "VC",
        "VE",
        "VG",
        "VI",
        "VN",
        "VU",
        "WS",
        "YE",
        "ZA",
        "ZM",
        "ZW"
    ],
    "contributors": [
        {
            "id": 14343187,
            "name": "Maria Becerra",
            "link": "https://www.deezer.com/artist/14343187",
            "share": "https://www.deezer.com/artist/14343187?utm_source=deezer&utm_content=artist-14343187&utm_term=0_1746974882&utm_medium=web",
            "picture": "https://api.deezer.com/artist/14343187/image",
            "picture_small": "https://cdn-images.dzcdn.net/images/artist/022b53ec2020238407549a708e068e86/56x56-000000-80-0-0.jpg",
            "picture_medium": "https://cdn-images.dzcdn.net/images/artist/022b53ec2020238407549a708e068e86/250x250-000000-80-0-0.jpg",
            "picture_big": "https://cdn-images.dzcdn.net/images/artist/022b53ec2020238407549a708e068e86/500x500-000000-80-0-0.jpg",
            "picture_xl": "https://cdn-images.dzcdn.net/images/artist/022b53ec2020238407549a708e068e86/1000x1000-000000-80-0-0.jpg",
            "radio": true,
            "tracklist": "https://api.deezer.com/artist/14343187/top?limit=50",
            "type": "artist",
            "role": "Main"
        },
        {
            "id": 12637039,
            "name": "Paulo Londra",
            "link": "https://www.deezer.com/artist/12637039",
            "share": "https://www.deezer.com/artist/12637039?utm_source=deezer&utm_content=artist-12637039&utm_term=0_1746974882&utm_medium=web",
            "picture": "https://api.deezer.com/artist/12637039/image",
            "picture_small": "https://cdn-images.dzcdn.net/images/artist/26fbc79599d2ed0f3629fa74df3e489a/56x56-000000-80-0-0.jpg",
            "picture_medium": "https://cdn-images.dzcdn.net/images/artist/26fbc79599d2ed0f3629fa74df3e489a/250x250-000000-80-0-0.jpg",
            "picture_big": "https://cdn-images.dzcdn.net/images/artist/26fbc79599d2ed0f3629fa74df3e489a/500x500-000000-80-0-0.jpg",
            "picture_xl": "https://cdn-images.dzcdn.net/images/artist/26fbc79599d2ed0f3629fa74df3e489a/1000x1000-000000-80-0-0.jpg",
            "radio": true,
            "tracklist": "https://api.deezer.com/artist/12637039/top?limit=50",
            "type": "artist",
            "role": "Main"
        },
        {
            "id": 101049,
            "name": "Xross",
            "link": "https://www.deezer.com/artist/101049",
            "share": "https://www.deezer.com/artist/101049?utm_source=deezer&utm_content=artist-101049&utm_term=0_1746974882&utm_medium=web",
            "picture": "https://api.deezer.com/artist/101049/image",
            "picture_small": "https://cdn-images.dzcdn.net/images/artist/8882647ff745a327a3f118500511c276/56x56-000000-80-0-0.jpg",
            "picture_medium": "https://cdn-images.dzcdn.net/images/artist/8882647ff745a327a3f118500511c276/250x250-000000-80-0-0.jpg",
            "picture_big": "https://cdn-images.dzcdn.net/images/artist/8882647ff745a327a3f118500511c276/500x500-000000-80-0-0.jpg",
            "picture_xl": "https://cdn-images.dzcdn.net/images/artist/8882647ff745a327a3f118500511c276/1000x1000-000000-80-0-0.jpg",
            "radio": true,
            "tracklist": "https://api.deezer.com/artist/101049/top?limit=50",
            "type": "artist",
            "role": "Main"
        }
    ],
    "md5_image": "8882647ff745a327a3f118500511c276",
    "track_token": "AAAAAWgguKJoIdHijd52JHokSTrVuz019WCjBQXQRrFMytjS7RcY1Aiwn6jhaC_-JWXGJ2VPdp4rvLN-8luCxhhPx2M6YH0x-wPt60tIDPfmyubjz3HHUuCyfstb115omcFYAkwHVlu00Q0VBWYj5u8UzZoE6Y5gpuzB8i8RLHzQK_0uSzpBfGeZqPcd5Imyt0PVrQB2sJLt3WhQLFJrmFlW0BZpFLwsi3dlAor-LOHb_EnXwoeB79V8OwGf04YE4YhzzOoFhhnIwNrqQCWZxZxvE1TINcm_Q8b-OESFIdKwiK3HDviao8ePK-ED6mlNraIlqYYW_C2FLdKc1DSPQhf7emnh_U6OYus",
    "artist": {
        "id": 14343187,
        "name": "Maria Becerra",
        "link": "https://www.deezer.com/artist/14343187",
        "share": "https://www.deezer.com/artist/14343187?utm_source=deezer&utm_content=artist-14343187&utm_term=0_1746974882&utm_medium=web",
        "picture": "https://api.deezer.com/artist/14343187/image",
        "picture_small": "https://cdn-images.dzcdn.net/images/artist/022b53ec2020238407549a708e068e86/56x56-000000-80-0-0.jpg",
        "picture_medium": "https://cdn-images.dzcdn.net/images/artist/022b53ec2020238407549a708e068e86/250x250-000000-80-0-0.jpg",
        "picture_big": "https://cdn-images.dzcdn.net/images/artist/022b53ec2020238407549a708e068e86/500x500-000000-80-0-0.jpg",
        "picture_xl": "https://cdn-images.dzcdn.net/images/artist/022b53ec2020238407549a708e068e86/1000x1000-000000-80-0-0.jpg",
        "radio": true,
        "tracklist": "https://api.deezer.com/artist/14343187/top?limit=50",
        "type": "artist"
    },
    "album": {
        "id": 746313281,
        "title": "RAMEN PARA DOS",
        "link": "https://www.deezer.com/album/746313281",
        "cover": "https://api.deezer.com/album/746313281/image",
        "cover_small": "https://cdn-images.dzcdn.net/images/cover/8882647ff745a327a3f118500511c276/56x56-000000-80-0-0.jpg",
        "cover_medium": "https://cdn-images.dzcdn.net/images/cover/8882647ff745a327a3f118500511c276/250x250-000000-80-0-0.jpg",
        "cover_big": "https://cdn-images.dzcdn.net/images/cover/8882647ff745a327a3f118500511c276/500x500-000000-80-0-0.jpg",
        "cover_xl": "https://cdn-images.dzcdn.net/images/cover/8882647ff745a327a3f118500511c276/1000x1000-000000-80-0-0.jpg",
        "md5_image": "8882647ff745a327a3f118500511c276",
        "release_date": "2025-05-08",
        "tracklist": "https://api.deezer.com/album/746313281/tracks",
        "type": "album"
    },
    "type": "track"
});

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: Center(child: CardTrackWidget(track: track, animatedCover: _userSettings.cardAnimatedCover,)),
      ),
    );
  }
}
