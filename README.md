# Guia de Instalação e Configuração

Este guia detalha os passos para configurar o ambiente de desenvolvimento Android com ferramentas essenciais como OpenJDK, Android SDK, e Gradle.

---

1. Atualização do Sistema
```bash
sudo apt update && sudo apt upgrade -y

Descrição: Atualiza a lista de pacotes e realiza a atualização do sistema para garantir que os pacotes estão na versão mais recente.


---

2. Instalação do OpenJDK 11

sudo apt install openjdk-11-jdk -y

Descrição: Instala o OpenJDK 11, necessário para compilar e executar projetos Android e Gradle.


---

3. Instalação do unzip

sudo apt install unzip -y

Descrição: Ferramenta necessária para descompactar os arquivos .zip.


---

4. Download do Android Command Line Tools

wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O cmdline-tools.zip

Descrição: Faz o download das ferramentas de linha de comando do Android SDK.


---

5. Configuração do Android Command Line Tools

mkdir -p ~/Android/Sdk/cmdline-tools
unzip cmdline-tools.zip -d ~/Android/Sdk/cmdline-tools
mv ~/Android/Sdk/cmdline-tools/cmdline-tools ~/Android/Sdk/cmdline-tools/latest

Descrição: Cria o diretório para o Android SDK, descompacta o pacote de ferramentas e organiza o diretório.


---

6. Configuração do ambiente no .bashrc

Abra o arquivo para edição:

nano ~/.bashrc

Adicione ao final do arquivo:

export PATH=/opt/gradle/gradle-8.2.1/bin:$PATH
export ANDROID_HOME=~/Android/Sdk
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH

Ative as mudanças:

source ~/.bashrc


---

7. Aceitar Licenças do SDK Manager

sdkmanager --licenses

Descrição: Aceita as licenças necessárias para utilizar o Android SDK.


---

8. Instalar ferramentas do Android SDK

sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0"

Descrição: Instala ferramentas de plataforma, API 33 e ferramentas de build.


---

9. Download e Configuração do Gradle

wget https://services.gradle.org/distributions/gradle-8.2.1-bin.zip -O gradle.zip
sudo mkdir /opt/gradle
sudo unzip gradle.zip -d /opt/gradle

Descrição: Faz o download do Gradle versão 8.2.1 e descompacta no diretório /opt/gradle.


---

10. Listar Ferramentas Instaladas

sdkmanager --list

Descrição: Verifica as ferramentas instaladas e disponíveis no Android SDK.

