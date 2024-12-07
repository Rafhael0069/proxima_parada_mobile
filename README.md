# Próxima Parada

**Próxima Parada** é um aplicativo mobile desenvolvido em Flutter, focado em facilitar o compartilhamento de caronas entre usuários. Este projeto foi desenvolvido como parte de um trabalho acadêmico entre os meses de junho e outubro de 2024. O objetivo principal foi implementar um sistema funcional e simplificado utilizando Firebase como back-end.

---

## **Funcionalidades**

### **Usuário Geral**
- **Cadastro e Login:**
  - Criação de conta com autenticação via Firebase.
  - Login seguro para acesso ao aplicativo.

- **Feed de Caronas:**
  - Visualização de todas as caronas disponíveis.
  - Expansão de detalhes ao clicar em uma carona, com informações completas e botão para entrar em contato com o responsável pela carona.

### **Perfil do Usuário**
- Modificação de informações pessoais.
- Adição de informações de veículo.
- Solicitação de autorização para oferecer caronas.

### **Usuário Autorizado (Administração)**
- Uma vez autorizado pelos administradores:
  - **Criação de Caronas:**
    - O usuário pode criar caronas que deseja oferecer.
  - **Gerenciamento de Caronas:**
    - Visualizar, editar ou excluir caronas já criadas.

---

## **Tecnologias Utilizadas**

### **Frontend:**
- Flutter 3.10.5

### **Backend:**
- Firebase Authentication
- Firebase Firestore

### **Outras Bibliotecas:**
- [provider](https://pub.dev/packages/provider): Gerenciamento de estado.
- [fluttertoast](https://pub.dev/packages/fluttertoast): Exibição de mensagens temporárias.
- [firebase_core](https://pub.dev/packages/firebase_core): Integração Firebase.

---

## **Screenshots**
![Tela de boas vidas](https://github.com/user-attachments/assets/2e32bd7c-58a6-4244-b90c-b68f0254671c)
![Feed principal](https://github.com/user-attachments/assets/a5b56268-c1c6-4ac8-8ab5-c361d43e306d)
![Perfil](https://github.com/user-attachments/assets/3483f40b-dafc-4cf7-af88-c88f5f984835)
![Perfil de motorista](https://github.com/user-attachments/assets/ef5ac8fb-7318-4f55-a284-c34a659baa7a)
![Feed de minhas caronas](https://github.com/user-attachments/assets/7d43a409-164b-4c3f-92e9-79236a6b89a9)

---

## **Como Rodar o Projeto**

### **Pré-requisitos:**
1. [Flutter](https://flutter.dev/docs/get-started/install) instalado.
2. Acesso a um projeto Firebase configurado.

### **Passos:**
1. Clone o repositório:
   ```bash
   git clone https://github.com/seu-usuario/caronas-app.git
   ```
2. Navegue até o diretório do projeto:
   ```bash
   cd caronas-app
   ```
3. Instale as dependências:
   ```bash
   flutter pub get
   ```
4. Configure o Firebase:
   - Substitua o arquivo `google-services.json` (Android) pelo arquivo correspondente ao seu projeto Firebase.
5. Execute o aplicativo:
   ```bash
   flutter run
   ```

---

## **Contribuições**
Este projeto foi desenvolvido como parte de um trabalho acadêmico.

---

## **Licença**
Este projeto é de uso livre para fins acadêmicos e estudos. Não é recomendado utilizá-lo em produção sem ajustes e melhorias adicionais.

---

## **Contato**
Para dúvidas ou sugestões, entre em contato:
- **Email:** rafhael.gaspar.dev@gmail.com
- **LinkedIn:** [Rafhael Gaspar](https://www.linkedin.com/in/rafhael-gaspar-da-silva-9b090124a/)

