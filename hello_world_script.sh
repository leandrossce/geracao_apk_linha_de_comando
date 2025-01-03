#!/bin/bash

# ------------------------------------------------------------
# 0. Perguntar ao usuário o nome do aplicativo
# ------------------------------------------------------------
read -p "Informe o nome do aplicativo (padrão: MyApp): " INPUT_APP_NAME
if [ -z "$INPUT_APP_NAME" ]; then
    PROJECT_NAME="MyApp"
else
    PROJECT_NAME="$INPUT_APP_NAME"
fi

# ------------------------------------------------------------
# Variáveis de configuração
# ------------------------------------------------------------
PACKAGE_NAME="com.example.myapp"           # Fixo, mas você pode adaptar
PROJECT_DIR="$PWD/$PROJECT_NAME"

# ------------------------------------------------------------
# Limpeza de diretório anterior (use com cautela!)
# ------------------------------------------------------------
if [ -d "$PROJECT_DIR" ]; then
    echo "Removendo diretório antigo do projeto..."
    rm -rf "$PROJECT_DIR"
fi

# ------------------------------------------------------------
# 1. Criar estrutura de diretórios
# ------------------------------------------------------------
echo "Criando estrutura básica do projeto Android..."
mkdir -p "$PROJECT_DIR/app/src/main/java/$(echo $PACKAGE_NAME | tr '.' '/')"
mkdir -p "$PROJECT_DIR/app/src/main/res/layout"
mkdir -p "$PROJECT_DIR/app/src/main/res/values"

# ------------------------------------------------------------
# 2. Criar AndroidManifest.xml
#    - Sem atributo package="..." e com android:exported="true"
# ------------------------------------------------------------
cat > "$PROJECT_DIR/app/src/main/AndroidManifest.xml" <<EOL
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <application
        android:label="$PROJECT_NAME"
        android:theme="@style/Theme.AppCompat.Light.NoActionBar">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

    </application>
</manifest>
EOL

# ------------------------------------------------------------
# 3. Criar MainActivity.java
# ------------------------------------------------------------
cat > "$PROJECT_DIR/app/src/main/java/$(echo $PACKAGE_NAME | tr '.' '/')/MainActivity.java" <<EOL
package $PACKAGE_NAME;

import android.os.Bundle;
import android.widget.Button;
import android.widget.Toast;
import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Button button = findViewById(R.id.button_hello);
        button.setOnClickListener(v ->
            Toast.makeText(MainActivity.this, "Hello World", Toast.LENGTH_SHORT).show()
        );
    }
}
EOL

# ------------------------------------------------------------
# 4. Criar layout activity_main.xml
# ------------------------------------------------------------
cat > "$PROJECT_DIR/app/src/main/res/layout/activity_main.xml" <<EOL
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:gravity="center">

    <Button
        android:id="@+id/button_hello"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Click Me" />
</LinearLayout>
EOL

# ------------------------------------------------------------
# 5. Criar strings.xml
# ------------------------------------------------------------
cat > "$PROJECT_DIR/app/src/main/res/values/strings.xml" <<EOL
<resources>
    <string name="app_name">$PROJECT_NAME</string>
</resources>
EOL

# ------------------------------------------------------------
# 6. Criar build.gradle do módulo app (namespace, sem package no Manifest)
# ------------------------------------------------------------
cat > "$PROJECT_DIR/app/build.gradle" <<EOL
apply plugin: 'com.android.application'

android {
    namespace "$PACKAGE_NAME"
    compileSdkVersion 33
    defaultConfig {
        applicationId "$PACKAGE_NAME"
        minSdkVersion 21
        targetSdkVersion 33
        versionCode 1
        versionName "1.0"
    }
    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}

dependencies {
    implementation 'androidx.appcompat:appcompat:1.6.1'
}
EOL

# ------------------------------------------------------------
# 7. Criar build.gradle do projeto
# ------------------------------------------------------------
cat > "$PROJECT_DIR/build.gradle" <<EOL
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:8.1.0'
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
EOL

# ------------------------------------------------------------
# 8. Criar settings.gradle
# ------------------------------------------------------------
cat > "$PROJECT_DIR/settings.gradle" <<EOL
rootProject.name = "$PROJECT_NAME"
include ':app'
EOL

# ------------------------------------------------------------
# 9. Criar gradle.properties (Habilita AndroidX)
# ------------------------------------------------------------
cat > "$PROJECT_DIR/gradle.properties" <<EOL
android.useAndroidX=true
android.enableJetifier=true
EOL

# ------------------------------------------------------------
# Entrar no diretório do projeto
# ------------------------------------------------------------
cd "$PROJECT_DIR" || exit

# ------------------------------------------------------------
# 10. Verificar se o Gradle está instalado
# ------------------------------------------------------------
if ! command -v gradle &> /dev/null; then
    echo "Gradle não está instalado no sistema."
    echo "Instale o Gradle ou copie manualmente o Gradle Wrapper para este projeto."
    # Descomente para instalar automaticamente (Debian/Ubuntu):
    # sudo apt-get update && sudo apt-get install gradle -y
    exit 1
fi

# ------------------------------------------------------------
# 11. Gerar Gradle Wrapper
# ------------------------------------------------------------
echo "Gerando Gradle Wrapper..."
gradle wrapper

# Se o arquivo gradlew não foi criado, abortar
if [ ! -f "gradlew" ]; then
    echo "Falha ao criar o Gradle Wrapper. Verifique se o Gradle está funcionando corretamente."
    exit 1
fi

chmod +x gradlew

# ------------------------------------------------------------
# 12. Compilar (assembleDebug)
# ------------------------------------------------------------
echo "Compilando APK em modo debug..."
./gradlew assembleDebug

# Caminho final do APK
APK_PATH="app/build/outputs/apk/debug/app-debug.apk"

if [ -f "$APK_PATH" ]; then
    echo "APK gerado com sucesso em: $PROJECT_DIR/$APK_PATH"
else
    echo "Falha ao gerar o APK. Verifique se há erros no log acima."
fi

echo "Estrutura do projeto Android criada e (se tudo correu bem) APK (debug) compilado com sucesso!"
