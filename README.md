# 💊 MedBox — Lembrete Inteligente de Remédios

> Projeto Final do programa **HackaTruck** — aplicativo iOS integrado a hardware Arduino para gerenciamento e lembretes de medicamentos.

---

## 📋 Sobre o Projeto

O **MedBox** é um aplicativo iOS desenvolvido em SwiftUI que permite ao usuário cadastrar, acompanhar e gerenciar seus remédios de forma simples e intuitiva. O app se comunica com um backend Node-RED que persiste os dados em um banco de dados **IBM Cloudant (CouchDB)**, e pode ser integrado a um dispositivo **Arduino** para acionamento físico de alertas.

---

## 🚀 Funcionalidades

- 🏠 **Home** — Visualização semanal dos remédios do dia, com indicadores de status (a tomar, tomado, esquecido)
- 📅 **Calendário** — Navegação mensal com exibição dos remédios por dia
- 📦 **Estoque** — Gerenciamento de quantidade de cada remédio com adição, edição e remoção
- ⚙️ **Configurações** — Perfil do usuário, notificações, modo escuro e controle de áudio

---

## 🏗️ Arquitetura

```
iOS App (SwiftUI)
       │
       ▼
Node-RED (http://127.0.0.1:1880)
       │
       ▼
IBM Cloudant (CouchDB)
```

A comunicação entre o app e o banco é feita via **Node-RED**, que expõe uma API REST local. O app iOS consome essa API com chamadas HTTP nativas (`URLSession`).

---

## 📁 Estrutura de Arquivos

```
ProjetoFINAL/
├── ProjetoFINAL/
│   ├── ProjetoFINALApp.swift        # Entry point do app
│   ├── ContentView.swift            # TabView principal (4 abas)
│   ├── HomeView.swift               # Aba Home — slider semanal e lista de eventos
│   ├── CalenderView.swift           # Aba Calendário — grade mensal
│   ├── StorageView.swift            # Aba Estoque — CRUD de remédios
│   ├── RemediosDayView.swift        # Sheet com remédios de um dia específico
│   ├── SettingView.swift            # Aba Configurações
│   ├── Profile.swift                # Tela de perfil do usuário
│   ├── Notifications.swift          # Tela de configurações de notificações
│   ├── Audio.swift                  # Tela de configurações de áudio
│   ├── apiGET.swift                 # Requisição GET — busca remédios
│   ├── apiPOST.swift                # Requisição POST — cadastra remédio
│   ├── apiPUT.swift                 # Requisição PUT — atualiza remédio
│   ├── apiDELETE.swift              # Requisição DELETE — remove remédio
│   ├── apiGETARDUINO.swift          # Requisição GET para integração Arduino
│   └── apiDELETEARDUINO.swift       # Requisição DELETE para integração Arduino
└── flows jordao.json                # Flows Node-RED para importação
```

---

## 🔌 API (Node-RED)

Os flows do Node-RED expõem os seguintes endpoints na porta `1880`:

| Método   | Rota             | Descrição                     |
| -------- | ---------------- | ----------------------------- |
| `GET`    | `/remedioGET`    | Retorna todos os remédios     |
| `POST`   | `/remedioPOST`   | Cadastra um novo remédio      |
| `POST`   | `/remedioPUT`    | Atualiza um remédio existente |
| `DELETE` | `/remedioDELETE` | Remove um remédio             |

> O arquivo `flows jordao.json` contém os flows prontos para importar no Node-RED.

---

## 🗄️ Modelo de Dados

```swift
struct Remedio: Codable, Identifiable {
    var _id: String         // ID do documento no Cloudant
    var _rev: String?       // Revisão do documento (necessária para DELETE/PUT)
    let nome: String        // Nome do medicamento
    let descricao: String   // Descrição ou observações
    var qtd: Int            // Quantidade em estoque
    let dias: [DiaSemana]   // Dias da semana para tomar
    let horario: Date       // Horário de administração
}
```

Dias da semana disponíveis: `segunda`, `terca`, `quarta`, `quinta`, `sexta`, `sabado`, `domingo`.

---

## 🛠️ Pré-requisitos

- **Xcode 15+**
- **iOS 17+** (target do projeto)
- **Node-RED** instalado e rodando localmente na porta `1880`
- Conta **IBM Cloud** com serviço **Cloudant** configurado
- (Opcional) Placa **Arduino** para integração de hardware

---

## ⚙️ Como Executar

### 1. Configurar o Node-RED

1. Instale o Node-RED:
   ```bash
   npm install -g --unsafe-perm node-red
   ```
2. Instale o node do Cloudant:
   ```bash
   cd ~/.node-red
   npm install node-red-contrib-cloudantplus
   ```
3. Inicie o Node-RED:
   ```bash
   node-red
   ```
4. Acesse `http://localhost:1880`, vá em **Menu → Import** e importe o arquivo `flows jordao.json`.
5. Configure suas credenciais do Cloudant no nó `cloudantplus` e faça o **Deploy**.

### 2. Executar o App iOS

1. Abra `ProjetoFINAL.xcodeproj` no Xcode.
2. Selecione um simulador ou dispositivo físico com iOS 17+.
3. Pressione **⌘ + R** para compilar e executar.

> **Nota:** Certifique-se de que o Node-RED está rodando antes de iniciar o app, pois as chamadas de API apontam para `http://127.0.0.1:1880`.

---

## 📄 Licença

Este projeto foi desenvolvido para fins educacionais no contexto do HackaTruck.
