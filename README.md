## Initialize

```
bundle install --path=vendor/bundle
mkdir [this project path]/sql
# copy target sql files
cp *.sql [this project path]/sql
```
## ReGenerate Parser (If you rewrite ddl.treetop)

```
gem install treetop # first process only
tt ddl.treetop
```

## Launch parser

```
./mysql2psql_ddl > target.sql
```
