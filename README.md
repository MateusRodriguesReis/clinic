# 🏥 ClínicaDB — Sistema de Gestão Médica

Um sistema web moderno de clínica médica desenvolvido com **HTML, CSS e JavaScript puro** (sem dependências externas). 

Funciona **100% no navegador** usando `localStorage` para persistência de dados. Perfeito para portfólio, demonstração e prototipagem rápida.

---

## 🚀 Como Usar

### 1️⃣ **Abrir o Sistema**

1. Clone ou baixe este repositório
2. Abra `index.html` no navegador (Desktop/Admin)
3. Para o portal do paciente, abra `login.html`

**Não precisa de servidor!** Tudo funciona localmente no navegador.

---

## 👥 Credenciais de Teste

O sistema vem com 4 pacientes de teste pré-carregados. Use qualquer um para fazer login:

| Email | Senha | Nome |
|-------|-------|------|
| `joao@email.com` | `senha123` | João Silva |
| `maria@email.com` | `senha123` | Maria Oliveira |
| `pedro@email.com` | `senha123` | Pedro Santos |
| `luciana@email.com` | `senha123` | Luciana Rocha |

**Ou crie sua própria conta** pelo botão "Criar Conta" no login.

---

## 📊 Funcionalidades

### 📋 **Painel Administrativo** (`index.html`)
- **Dashboard** com estatísticas em tempo real
- **Cadastro de Pacientes** — CRUD completo
- **Cadastro de Médicos** — Gerenciamento com especialidades
- **Especialidades** — Criar e gerenciar especialidades médicas
- **Agendamentos** — Criar e gerenciar consultas
- **Prontuários** — Registrar diagnósticos e prescrições
- **Relatórios** — 6 tipos diferentes de relatórios
- **Admin Console** — Exportar/importar/resetar dados

### 👤 **Portal do Paciente** (`paciente.html`)
- **Meu Perfil** — Ver dados pessoais e histórico
- **Agendar Consulta** — Wizard com 4 passos
- **Meu Histórico** — Ver todas as consultas (filtráveis)
- **Prontuários** — Acessar histórico médico
- **Gerenciar Senh** — Alteração de senha segura

### 🔐 **Sistema de Autenticação** (`login.html`)
- Login e Registro de pacientes
- Senhas hasheadas com Base64 (demo)
- Validação de CPF unique
- Validação de e-mail unique

---

## 📂 Estrutura do Projeto

```
clinic/
├── index.html           ← Admin dashboard (gestão clínica)
├── login.html           ← Tela de login e registro
├── paciente.html        ← Portal do paciente
├── schema.sql           ← Design do banco de dados (referência)
├── README.md            ← Este arquivo
│
└── css/
    ├── index.css        ← Estilos do admin
    ├── login.css        ← Estilos do login
    └── paciente.css     ← Estilos do portal
```

---

## 💾 Dados e Armazenamento

### Como Funciona?
- Todos os dados são salvos em **localStorage do navegador**
- Persistem entre sessões (até limpar cache do navegador)
- Cada navegador tem sua própria cópia dos dados

### Operações com Dados

#### **Exportar Dados** 📥
No painel Admin, clique em **⚙️ Admin → 📥 Exportar Dados**
- Baixa um arquivo JSON com backup
- Use para compartilhar dados ou arquivar

#### **Importar Dados** 📤
No painel Admin, clique em **⚙️ Admin → 📤 Importar Dados**
- Suba um arquivo JSON salvo anteriormente
- Restaura dados completamente

#### **Limpar Dados** 🗑️
No painel Admin, clique em **⚙️ Admin → 🗑️ Limpar Todos os Dados**
- ⚠️ **Irreversível!** Deleta tudo
- Sistema volta ao estado inicial com dados de teste

---

## 🔧 Tecnologias

- **HTML5** — Semântica e estrutura
- **CSS3** — Design responsivo (mobile-first)
- **JavaScript (ES6+)** — Lógica e interatividade
- **localStorage API** — Persistência de dados
- **Sem dependências externas** — Vanilla JS puro

---

## 📱 Responsivo?

✅ **Sim!** O sistema é totalmente responsivo:
- ✅ Desktop (1920px+)
- ✅ Tablet (768px - 1024px)
- ✅ Mobile (< 768px)

Teste redimensionando o navegador ou acessando em um celular.

---

## ⚙️ Estrutura de Dados

### Pacientes
```json
{
  "id": 1,
  "nome": "João Silva",
  "cpf": "111.222.333-44",
  "email": "joao@email.com",
  "data_nascimento": "1990-03-15",
  "sexo": "M",
  "telefone": "(21) 98000-0001",
  "endereco": "Rua das Flores, 100",
  "cep": "21300-000",
  "data_cadastro": "2025-01-10"
}
```

### Médicos
```json
{
  "id": 1,
  "nome": "Dr. Carlos Lima",
  "crm": "CRM/RJ-12345",
  "id_especialidade": 1,
  "email": "carlos@clinica.com",
  "telefone": "(21) 99001-1111",
  "ativo": 1
}
```

### Consultas
```json
{
  "id": 1,
  "id_paciente": 1,
  "id_medico": 1,
  "data_consulta": "2025-07-10",
  "hora_consulta": "09:00",
  "status": "REALIZADA",
  "motivo": "Dor de cabeça frequente",
  "valor": 150
}
```

### Prontuários
```json
{
  "id": 1,
  "id_consulta": 1,
  "diagnostico": "G43 — Enxaqueca sem aura",
  "prescricao": "Dipirona 500mg — 1 comprimido a cada 6h",
  "observacoes": "Paciente orientado a reduzir cafeína",
  "data_registro": "2025-07-10"
}
```

---

## 🎨 Design System

- **Cores principais:** Azul (#1a73e8), Teal (#00897b), Verde (#2e7d32)
- **Tipografia:** Segoe UI / System fonts (sem web fonts)
- **Border-radius:** 12px (componentes), 8px-9px (botões)
- **Sombras:** Subtis (0-4px)

---

## 📝 Notas Importantes

1. **Senhas** — O sistema usa Base64 para hash demo. **Não usar em produção!** Use bcrypt/Argon2.
2. **Dados de Teste** — Os 4 pacientes são fixtures para demonstração.
3. **localStorage Limite** — Máximo ~5-10MB por domínio. Esse projeto usa <100KB.
4. **Navegadores** — Funciona em todos os navegadores modernos (Chrome, Firefox, Safari, Edge).

---

## 🚀 Próximas Melhorias Possíveis

- [ ] Backend Node.js/Express com SQLite
- [ ] Autenticação JWT
- [ ] Hash de senha com bcrypt
- [ ] Filtros e buscas avançadas
- [ ] Notificações por email
- [ ] Dark mode
- [ ] Exportar relatórios em PDF

---

## 📄 Licença

MIT — Use livremente! 

---

## 👨‍💻 Autor

Mateus Rodrigues Reis  
📧 Contato: mateusccontatoprofissional@gmail.com

---

## ❓ FAQ

**P: Posso usar em produção?**  
R: Com as melhorias mencionadas (autenticação real, banco de dados, HTTPS). Atualmente é bom para demos e portfólio.

**P: Os dados persistem eternamente?**  
R: Até você limpar o cache do navegador ou usar a função "Limpar Dados".

**P: Como faço backup?**  
R: Use a função "Exportar Dados" no Admin para salvar um JSON.

**P: Funciona offline?**  
R: Sim! Totalmente offline. localStorage não precisa de internet.

---

**Aproveite! 🎉**
