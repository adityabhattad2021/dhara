# Data Storage Strategy

## Local Storage (Floor Database)
- Draft transactions before user confirmation
- Cached user preferences (theme, settings)  
- Offline transaction queue for when network unavailable
- Recent chat history for quick access



## Cloud Storage (Firebase Firestore)
- Confirmed transactions after user approval
- User profile & authentication data
- Expense categories and budgets
- Cross-device sync data

## Hybrid (Both Local + Cloud)
- Recent transactions (local for speed, cloud for backup)
- User settings (local cache, cloud sync)


## Cloud Functions Only  
- Natural language parsing
- Message analysis/parsing
- AI chat with passbook

