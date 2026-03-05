# 🔧 FIX FACEBOOK LOGIN - Android Key Hash

## ✅ TON KEY HASH

**SHA1:** `15:C6:BD:F4:96:33:06:23:92:C9:32:50:80:8A:30:7A:BD:B8:DD:DB`

## 📝 ÉTAPES À SUIVRE

### 1. Aller sur Facebook Developer Console
https://developers.facebook.com/apps/1863011741067181/

### 2. Aller dans Settings → Basic

### 3. Scroller jusqu'à "Android"

### 4. Ajouter le Key Hash

**Convertir SHA1 en Key Hash:**

Utilise cet outil en ligne:
https://tomeko.net/online_tools/hex_to_base64.php

**Input (SHA1 en hex - sans les ":"):**
```
15C6BDF49633062392C9325080 8A307ABDB8DDDB
```

**OU utilise cette commande:**
```bash
echo 15C6BDF49633062392C9325080 8A307ABDB8DDDB | xxd -r -p | openssl base64
```

**Key Hash attendu:** `FcbfSWYzBiOSyTJQgIower242ds=`

### 5. Ajouter dans Facebook Console

Dans la section "Key Hashes", ajoute:
```
FcbfSWYzBiOSyTJQgIower242ds=
```

### 6. Sauvegarder

Clique sur "Save Changes" en bas de la page.

### 7. Tester

Relance l'app et teste le login Facebook.

---

## 🚀 SOLUTION RAPIDE (SI ÇA NE MARCHE PAS)

### Méthode Alternative: Générer depuis l'app

Ajoute ce code temporaire dans `MainActivity.kt`:

```kotlin
import android.util.Base64
import android.util.Log
import java.security.MessageDigest

// Dans onCreate()
try {
    val info = packageManager.getPackageInfo(
        packageName,
        PackageManager.GET_SIGNATURES
    )
    for (signature in info.signatures) {
        val md = MessageDigest.getInstance("SHA")
        md.update(signature.toByteArray())
        val keyHash = Base64.encodeToString(md.digest(), Base64.DEFAULT)
        Log.d("KeyHash", "Key Hash: $keyHash")
    }
} catch (e: Exception) {
    Log.e("KeyHash", "Error: ${e.message}")
}
```

Lance l'app et regarde les logs Android Studio pour voir le Key Hash.

---

## ✅ VÉRIFICATION

Après avoir ajouté le Key Hash:
1. Ferme complètement l'app
2. Relance l'app
3. Teste Facebook Login
4. Ça devrait fonctionner!

---

## 📌 NOTES

- **Debug Key Hash**: Utilisé en développement
- **Release Key Hash**: Nécessaire pour production (différent)
- **Validité**: Jusqu'au 8 décembre 2055

Pour production, tu devras générer un nouveau Key Hash avec ton keystore de release.
