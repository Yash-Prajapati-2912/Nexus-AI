# Nexus AI Backend - Database Indexing Strategy & Optimization

**Document Version:** 1.0.0  
**Author:** Principal Database Architect & Senior Backend Engineer  
**Last Updated:** July 25, 2026  

---

## Table of Contents
1. [Document Purpose](#1-document-purpose)
2. [Document Scope](#2-document-scope)
3. [Indexing Taxonomy & Types](#3-indexing-taxonomy--types)
   - [3.1 Primary B-Tree Indexes](#31-primary-b-tree-indexes)
   - [3.2 Secondary Foreign Key Indexes](#32-secondary-foreign-key-indexes)
   - [3.3 Composite Multi-Column Indexes](#33-composite-multi-column-indexes)
   - [3.4 Partial / Conditional Indexes](#34-partial--conditional-indexes)
   - [3.5 GIN Indexes for JSONB & Array Data](#35-gin-indexes-for-jsonb--array-data)
   - [3.6 Full-Text Search Indexes (`tsvector`)](#36-full-text-search-indexes-tsvector)
   - [3.7 Vector Similarity Indexes (`pgvector` HNSW)](#37-vector-similarity-indexes-pgvector-hnsw)
4. [Query-Driven Index Mapping Matrix](#4-query-driven-index-mapping-matrix)
5. [Sorting, Filtering & Pagination Optimization](#5-sorting-filtering--pagination-optimization)
6. [Index Sizing, Maintenance & Write Overhead](#6-index-sizing-maintenance--write-overhead)
7. [Architectural Rationale & Trade-Off Analysis](#7-architectural-rationale--trade-off-analysis)
8. [Enterprise Best Practices](#8-enterprise-best-practices)
9. [Anti-Patterns & Common Mistakes](#9-anti-patterns--common-mistakes)
10. [Cross References](#10-cross-references)

---

## 1. Document Purpose

This document defines the database indexing strategy, query acceleration patterns, composite index orders, GIN/JSONB index rules, and full-text search indexing guidelines for the Nexus AI PostgreSQL database.

---

## 2. Document Scope

This specification applies to all database indexes, primary keys, foreign key constraints, partial filters, and vector search structures across all tables.

---

## 3. Indexing Taxonomy & Types

```mermaid
graph TD
    Table[PostgreSQL Table Query] --> Type{Query Category?}
    
    Type -- Primary Key Lookup --> BTreePK[B-Tree Primary Index (id UUID)]
    Type -- Foreign Key Join --> BTreeFK[B-Tree Secondary Index (user_id)]
    Type -- Multi-Filter Query --> BTreeComp[Compound Index (user_id, due_date, status)]
    Type -- JSONB / Array Attribute --> GIN[GIN Index (skill_tags, notif_prefs)]
    Type -- Full-Text Search --> GINSearch[GIN Index on tsvector(title)]
    Type -- AI Vector RAG --> HNSW[HNSW Vector Index (embedding vector)]
```

### 3.1 Primary B-Tree Indexes
* Automatically created on the UUID v4 `id` column of every table. Ensures `O(log N)` primary key lookup performance.

### 3.2 Secondary Foreign Key Indexes
* Mandatory B-Tree indexes created on every foreign key column (`user_id`, `category_id`, `budget_id`) to accelerate join queries and cascade integrity checks.

### 3.3 Composite Multi-Column Indexes
* Designed for frequent multi-attribute filter and sort queries.
* **Order Rule (Left-Most Prefix Rule):** Equality columns first, range/sort columns second.
* **Example:** `idx_planner_tasks_user_due_status` on `planner_tasks(user_id, status, due_date ASC)`.

### 3.4 Partial / Conditional Indexes
* Reduces index storage footprint by indexing only active, non-deleted rows:
* **Example:** `CREATE INDEX idx_active_tasks ON planner_tasks(user_id, due_date) WHERE deleted_at IS NULL AND status = 'PENDING'`.

### 3.5 GIN Indexes for JSONB & Array Data
* Generalized Inverted Index (GIN) applied to PostgreSQL `JSONB` documents and text arrays (`TEXT[]`):
* **Example:** `CREATE INDEX idx_user_skills_tags ON user_profiles USING GIN (skill_tags)`.

### 3.6 Full-Text Search Indexes (`tsvector`)
* Enables high-speed text search across assignment titles and course descriptions without requiring external search engines for initial scale:
* **Example:** `CREATE INDEX idx_planner_tasks_search ON planner_tasks USING GIN (to_tsvector('english', title))`.

### 3.7 Vector Similarity Indexes (`pgvector` HNSW)
* Pre-planned for AI RAG embeddings: Hierarchical Navigable Small World (HNSW) vector index over 768-dimensional embeddings for sub-10ms cosine similarity search.

---

## 4. Query-Driven Index Mapping Matrix

| Table Name | Targeted API Endpoint / Query | Mandatory Index Specification | Index Type |
| :--- | :--- | :--- | :--- |
| `auth_users` | Login lookup (`WHERE email = ?`) | `idx_auth_users_email` ON `(email)` | Unique B-Tree |
| `planner_tasks` | Fetch today's urgent tasks | `idx_tasks_user_status_due` ON `(user_id, status, due_date)` | Compound B-Tree |
| `finance_expenses`| Fetch monthly category spend | `idx_expenses_user_spent_cat` ON `(user_id, spent_at, category_id)` | Compound B-Tree |
| `user_profiles` | Search students by skill tag | `idx_profiles_skill_tags` ON `(skill_tags)` | GIN |
| `ai_messages` | Full-text message transcript search | `idx_ai_messages_fts` ON `(to_tsvector('english', content))` | GIN tsvector |

---

## 5. Sorting, Filtering & Pagination Optimization

### Cursor-Based Pagination Indexing
For high-performance endless scrolling feeds (e.g., activity timeline or expenses):
* **Query Pattern:** `WHERE user_id = ? AND (created_at, id) < (?, ?) ORDER BY created_at DESC, id DESC LIMIT 20`
* **Optimal Index:** Compound B-Tree index on `(user_id, created_at DESC, id DESC)`. Ensures PostgreSQL executes an Index Scan without performing slow in-memory sort operations.

---

## 6. Index Sizing, Maintenance & Write Overhead

* **Write Amplification Trade-Off:** Every index added speeds up read queries but introduces write latency overhead during `INSERT`, `UPDATE`, and `DELETE` operations as PostgreSQL updates index pages.
* **Maintenance Policy:** Run automated `REINDEX CONCURRENTLY` during low-traffic maintenance windows (Sundays 03:00 UTC) to defragment index pages.

---

## 7. Architectural Rationale & Trade-Off Analysis

### Decision: Compound B-Tree Indexes vs Multiple Single-Column Indexes

| Evaluation Vector | Multiple Single-Column Indexes | Compound Multi-Column Index |
| :--- | :--- | :--- |
| **Architectural Rationale** | PostgreSQL must merge multiple indexes at runtime (Bitmap Index Scan). | Chosen for Nexus AI. Single compound index satisfies filter and sort in a single index pass. |
| **Advantages** | Flexibly covers diverse query patterns. | Maximum read speed; eliminates runtime index merge overhead; satisfies `ORDER BY` without sorting. |
| **Disadvantages** | Higher total index storage footprint; slower runtime execution. | Rigid column ordering; index only triggered if left-most column is present in query. |
| **Performance Impact** | Moderate read acceleration (~50ms). | Sub-millisecond read execution (<5ms). |
| **Scalability Impact** | High memory consumption. | High efficiency under massive read concurrency. |
| **Maintainability Impact**| Medium. | Extremely High. |

---

## 8. Enterprise Best Practices

1. **Follow Left-Most Prefix Rule:** Structure composite indexes with equality columns first, followed by range/sort columns.
2. **Use Partial Indexes for Soft Deletes:** Append `WHERE deleted_at IS NULL` to exclude deleted records from index trees.

---

## 9. Anti-Patterns & Common Mistakes

* ❌ **Over-Indexing:** Creating 15 indexes on a high-velocity write table, crippling `INSERT` performance.
* ❌ **Indexing Low-Cardinality Columns:** Creating a single-column B-Tree index on a boolean `is_active` column (PostgreSQL query planner will ignore it).

---

## 10. Cross References

* [21-database-overview.md](file:///d:/Nexus-AI/backend/docs/21-database-overview.md)
* [23-table-design-guidelines.md](file:///d:/Nexus-AI/backend/docs/23-table-design-guidelines.md)
* [26-database-performance.md](file:///d:/Nexus-AI/backend/docs/26-database-performance.md)
