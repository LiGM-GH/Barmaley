# Barmaley
## Make tables _fast_
 - Class Table makes tables from Hash:
```{key1: value1, key2: value2}```
and automatically makes columns.
 - Class Parser gets file or string and makes Hashes. 
 - `main.rb` is now history. 
## Usage
 - Place something like **this** in the lab file
```
{
     Класс:      Промежуточные данные,
     Имя:        a,
     Смысл:      тестовые данные,
     Тип:
     Структура:
     Диапазон:
     Формат:     [5..600]
}
```
 - Then run `rake parse_table_from #{your file}` in repo directory
 - Then get your table in the terminal
