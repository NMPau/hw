import csv
import sys
from collections import Counter, defaultdict
csv.field_size_limit(sys.maxsize)
file_path = 'vacancy.csv'
vacs = list(csv.DictReader(open(file_path)))

# За какие периоды эти вакансии?
a = {row['created_at'] for row in vacs}
print(a)

# Сколько вакансий с такими позициями, на которых вы работаете?
b = [row for row in vacs if row['vactitle'] == 'Главный экономист']
print(len(b))

# Сколько вакансий для аналитика данных?
c = [row for row in vacs if row['vactitle'] == 'Аналитик данных']
print(len(c))
top = Counter(row['vacdescription'] for row in c)
print(top.most_common(5))

# Сколько вакансий для аналитика данных с использованием Python?

p = [row['vacdescription'] for row in c]
p[1].split('-')
m = [n[:n.find('Навыки работы с Python')] for n in p]
print(len(m))





