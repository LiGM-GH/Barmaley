# Barmaley
## Make tables _fast_
 - Class Table makes tables from Hash:
```{key1: value1, key2: value2}```
and automatically makes columns.
 - Class Parser gets file or string and makes Hashes. 
 - `main.rb` is now history. 
## Usage
 - Run `bundle install` in repo directory to get all gems needed.
 - Then, if all gems installed, place something like **this** in the lab file
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
 - Then run `rake parse_table_from #{your file}` there
 - Then get your table in the terminal
