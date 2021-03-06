Функция ДобавитьОписание(МассивОписаний, ИмяКомпонента, НастройкиДиаграммы = Неопределено, РодительЭлемента = Неопределено, ПередЭлементом = Неопределено, Параметры = Неопределено, Действия = Неопределено) Экспорт
	Если А1Э_Общее.Свойство(Параметры, "АдресСкрипта") Тогда
		АдресСкрипта = Параметры.АдресСкрипта;
	Иначе
		АдресСкрипта = Неопределено;
		А1Э_Механизмы.ВыполнитьМеханизмыОбработчика("А1Русалка_ПриОпределенииАдресаСкрипта", АдресСкрипта);
		Если АдресСкрипта = Неопределено Тогда
			АдресСкрипта = "https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js";
		КонецЕсли;
	КонецЕсли;
	НастройкиКомпонента = А1Э_Структуры.Создать(
	"НастройкиДиаграммы", НастройкиДиаграммы,
	"АдресСкрипта", АдресСкрипта,
	);
	А1Э_УниверсальнаяФорма.ДобавитьОписаниеНастроекКомпонента(МассивОписаний, ИмяКомпонента, НастройкиКомпонента);
	РабочиеПараметры = А1Э_Структуры.СкопироватьВШаблон(Параметры,
	"Вид", ВидПоляФормы.ПолеHTMLДокумента,
	"ЗначениеРеквизита", ТекстНТМЛ(НастройкиКомпонента),
	);
	Возврат А1Э_Формы.ДобавитьОписаниеРеквизитаИЭлемента(МассивОписаний, ИмяКомпонента, "Строка", , , РодительЭлемента, ПередЭлементом, РабочиеПараметры, Действия);
КонецФункции

Функция Обновить(Форма, ИмяКомпонента, НастройкиДиаграммы) Экспорт 
	НастройкиКомпонента = А1Э_УниверсальнаяФорма.НастройкиКомпонента(Форма, ИмяКомпонента);
	НастройкиКомпонента.НастройкиДиаграммы = НастройкиДиаграммы;
	Форма[ИмяКомпонента] = ТекстНТМЛ(НастройкиКомпонента);
КонецФункции

Функция НовыйНастройкиДиаграммы() Экспорт
	Возврат А1Э_Структуры.Создать(
	"Вершины", Новый Массив,
	"Ребра", Новый Массив,
	)
КонецФункции

Функция НовыйОписаниеРебра(НачальнаяВершина, КонечнаяВершина) Экспорт
	Возврат А1Э_Структуры.Создать(
	"НачальнаяВершина", НачальнаяВершина,
	"КонечнаяВершина", КонечнаяВершина,
	);
КонецФункции

Функция НовыйОписаниеВершины(Идентификатор, Текст) Экспорт 
	Возврат А1Э_Структуры.Создать(
	"Идентификатор", Идентификатор,
	"Текст", Текст,
	); 
КонецФункции

Функция ТекстНТМЛ(Настройки) Экспорт
	Возврат СтрЗаменить(Шаблон(Настройки), "&ТекстРусалки", ТекстРусалки(Настройки.НастройкиДиаграммы));
КонецФункции

Функция Шаблон(Настройки) Экспорт
	Текст =  
	"<!doctype html>
	|<html lang=en>
	|<head>
	|<meta charset=utf-8>
	|<title>A1Mermaid</title>
	|</head>
	|<body>
	|<script src=""&АдресСкрипта""></script>
	|<div class=""mermaid"">
	|	&ТекстРусалки
	|</div>
	|<script>mermaid.initialize({startOnLoad:true});</script>
	|</body>
	|</html>";
	А1Э_Строки.Подставить(Текст, "&АдресСкрипта", Настройки.АдресСкрипта);
	Возврат Текст;
КонецФункции

Функция ТекстРусалки(Настройки) Экспорт
	Если Настройки = Неопределено Тогда Возврат "graph TD"; КонецЕсли;
	Если ТипЗнч(Настройки) = Тип("Строка") Тогда Возврат Настройки; КонецЕсли;
	
	СоответствиеВершин = Новый Соответствие;
	Для Каждого Вершина Из Настройки.Вершины Цикл
		СоответствиеВершин.Вставить(А1Э_Строки.ВСтроку(Вершина.Идентификатор), А1Э_Структуры.Создать(
		"Вершина", Вершина,
		"Выведена", Ложь,
		));
	КонецЦикла;
	МассивЧастей = Новый Массив;
	МассивЧастей.Добавить("graph TD");
	Для Каждого Ребро Из Настройки.Ребра Цикл
		Строка = СтрокаВершины(Ребро.НачальнаяВершина, СоответствиеВершин) + "-->" + СтрокаВершины(Ребро.КонечнаяВершина, СоответствиеВершин);
		МассивЧастей.Добавить(Строка);
	КонецЦикла;
	Возврат СтрСоединить(МассивЧастей, Символы.ПС);
КонецФункции

Функция СтрокаВершины(Идентификатор, СоответствиеВершин)
	ИдентификаторСтрока = А1Э_Строки.ВСтроку(Идентификатор);
	ДанныеВершины = СоответствиеВершин[ИдентификаторСтрока];
	Если ДанныеВершины = Неопределено Или ДанныеВершины.Выведена Тогда Возврат ИдентификаторСтрока; КонецЕсли;
	
	ДанныеВершины.Выведена = Истина;
	Возврат ИдентификаторСтрока + "[" + ДанныеВершины.Вершина.Текст + "]";
КонецФункции

Функция ИмяМодуля() Экспорт
	Возврат "А1Русалка";
КонецФункции 