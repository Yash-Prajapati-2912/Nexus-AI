# Nexus AI — Offline-First Architecture & Sync Engine

## 🛰 Offline Architecture Overview

Nexus AI implements an **Offline-First Repository Pattern**. When offline, mutations are queued locally and UI states update optimistically.

```mermaid
sequenceDiagram
    participant UI as Flutter BLoC UI
    participant Repo as OfflineRepository
    participant Queue as OfflineQueueManager
    participant Network as ConnectivityService
    participant Sync as SyncManager
    participant Remote as NestJS REST API

    UI->>Repo: Perform Action (e.g. Create Task)
    alt Network Disconnected
        Repo->>Queue: Enqueue Mutation [QueueItem]
        Repo-->>UI: Return Optimistic Entity State
    else Network Connected
        Repo->>Remote: Execute REST Request
        Remote-->>Repo: Return 200 OK Response
        Repo-->>UI: Return Verified Entity State
    end

    Note over Network,Sync: Network Connection Restored
    Network->>Sync: Connectivity Stream Event (Online)
    Sync->>Queue: Process Queue Items
    Queue->>Remote: Replay Mutation
    Remote-->>Sync: Synchronized Successfully
```

## ⚔️ Conflict Resolution Strategies

- **Server-Wins**: Remote server state overwrites local state.
- **Client-Wins**: Local modifications overwrite remote state.
- **Timestamp-Based**: Whichever entity has the higher ISO-8601 `updatedAt` timestamp prevails.
- **Manual Merge**: Merges missing fields dynamically.
