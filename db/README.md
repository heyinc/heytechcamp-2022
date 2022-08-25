# Database Schema Management

Database schema management powered by sqldef <https://github.com/k0kubun/sqldef>.

## Setup
Download and copy the single-binary executable for your environment from: <https://github.com/k0kubun/sqldef/releases>.

## Usage
### Export
```console
$ mysqldef --export stores > schema.sql
```

### Dry-run
```console
$ mysqldef --dry-run stores < schema.sql
```

### Apply
```console
$ mysqldef stores < schema.sql
```
