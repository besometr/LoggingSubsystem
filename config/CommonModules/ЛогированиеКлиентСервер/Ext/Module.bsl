﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Логирование"
//
//  
//
////////////////////////////////////////////////////////////////////////////////



#Область ПрограммныйИнтерфейс




#КонецОбласти



#Область СлужебныйПрограммныйИнтерфейс


// КонструкторСтруктурыЛога
// Конструктор полной структуры данных для записи лога.
// Формирует структуру лога, заполняет обязательные служебные свойства и,
// в случае наличия, пользовательские
//
// Параметры:
//	СтруктураПользовательскихПолей	- ФиксированнаяСтруктура - пользовательских даннных лога, заполненная по значениями соответствующих полей.
//		* КороткоеСообщение			- Строка	- Короткое представление сообщения.
//		* ПолноеСообщение			- Строка	- Полное сообщение.
//		* ДатаСобытия				- Строка	- Дата и время события UTC 0.
//		* Уровень					- Число		- Уровень лога (ALL=1,FATAL=2,ERROR=3,WARN =4 ,INFO=6,DEBUG=7,TRACE=5).
//									Определяется в ЛогированиеПереопределяемый.КонструкторСтруктураУровнейЛога
//		* Подсистема				- Строка	- Представление подсистемы, владельца лога.
//		* МетаданныеОбъекта			- Строка	- Представление имени объекта метаданных.
//		* Метод						- Строка	- Представление метода.
//		* Операция					- Строка	- Идентификатор конкретной выполняемой операции.
//		* ПредставлениеОбъекта		- Строка	- Представление объекта данных ИБ.
//		* ГУИДОбъекта				- Строка	- редставление уникального идентификатора объекта ИБ.
//
// Возвращаемое значение:
//	ФиксированнаяСтруктура	- Набор обязательных свойств лога.
//		* version			- Версия используемого формата GELF.
//		* host				- Сервер.
//		* short_message		- Короткое представление сообщения.
//		* full_message		- Полное сообщение.
//		* timestamp			- Дата и время события UTC 0.
//		* level				- Уровень лога (ALL=1,FATAL=2,ERROR=3,WARN =4 ,INFO=6,DEBUG=7,TRACE=5).
//		* app				- Имя приложения, владельца лога.
//		* node				- Экземпляр ИБ (Применительно к СПО "Пегас" - Узел обмена).
//		* branch			- Структурная единица ИБ (Применительно к СПО "Пегас" - Филиал ИБ).
//		* user				- Представление пользователя.
//		* session			- Номер сеанса пользователя.
//		* subsystem			- Представление подсистемы, владельца лога.
//		* metadataObject	- Представление имени объекта метаданных.
//		* method			- Представление метода.
//		* tracepoint		- Идентификатор конкретной выполняемой операции.
//		* object			- Представление объекта данных ИБ.
//		* extid				- Представление уникального идентификатора объекта ИБ.
//
Функция КонструкторСтруктурыЛога(СтруктураПользовательскихПолей)Экспорт 
	
	//Сбор служебных данных лога
	СтруктураЛогаGELF			= ЛогированиеПовторногоИспользования.СтруктураЛогаGELF();
	СтруктураУровнейЛога		= ЛогированиеПовторногоИспользования.СтруктураУровнейЛога();
	СтруктураСлужебныхПолейЛога = ЛогированиеПовторногоИспользования.СтруктураСлужебныхПолейЛога();
	СтруктураСеансовыхПолейЛога	= ЛогированиеПовторногоИспользования.СтруктураСеансовыхПолейЛога();
	
	//Проверка наличия пользовательских данных лога
	Если Не (ТипЗнч(СтруктураПользовательскихПолей) = Тип("Структура")
		Или ТипЗнч(СтруктураПользовательскихПолей) = Тип("ФиксированнаяСтруктура")) Тогда 
		
		СтруктураПользовательскихПолей = Новый Структура();
	КонецЕсли;

	СтруктураЛога = Новый Структура();
	
	//Служебные поля формата GELF
	СтруктураЛога.Вставить("version",			СтруктураЛогаGELF.version);
	СтруктураЛога.Вставить("host",				СтруктураСлужебныхПолейЛога.host);
	СтруктураЛога.Вставить("short_message",		?(СтруктураПользовательскихПолей.Свойство("КороткоеСообщение"), СтруктураПользовательскихПолей.КороткоеСообщение, ""));
	СтруктураЛога.Вставить("full_message",		?(СтруктураПользовательскихПолей.Свойство("ПолноеСообщение"), СтруктураПользовательскихПолей.ПолноеСообщение, ""));
	СтруктураЛога.Вставить("timestamp",			?(СтруктураПользовательскихПолей.Свойство("ДатаСобытия"), СтруктураПользовательскихПолей.ДатаСобытия, УниверсальноеВремя(ТекущаяДата())));
	СтруктураЛога.Вставить("level",				?(СтруктураПользовательскихПолей.Свойство("Уровень"), СтруктураПользовательскихПолей.Уровень, СтруктураУровнейЛога.ALL));
	
	//Служебные поля лога СПО "Пегас"
	СтруктураЛога.Вставить("app",				СтруктураСлужебныхПолейЛога.app);
	СтруктураЛога.Вставить("node",				СтруктураСлужебныхПолейЛога.node);
	СтруктураЛога.Вставить("branch",			СтруктураСлужебныхПолейЛога.branch);
	
	//Сеансовые поля
	СтруктураЛога.Вставить("user",				СтруктураСеансовыхПолейЛога.ИмяПользователя);
	СтруктураЛога.Вставить("session",			СтруктураСеансовыхПолейЛога.НомерСеанса);
	
	//Пользовательские поля
	СтруктураЛога.Вставить("subsystem",		?(СтруктураПользовательскихПолей.Свойство("Подсистема"), СтруктураПользовательскихПолей.Подсистема, ""));
	СтруктураЛога.Вставить("metadataObject",	?(СтруктураПользовательскихПолей.Свойство("МетаданныеОбъекта"), СтруктураПользовательскихПолей.МетаданныеОбъекта, ""));
	СтруктураЛога.Вставить("method",			?(СтруктураПользовательскихПолей.Свойство("Метод"), СтруктураПользовательскихПолей.Метод, ""));
	СтруктураЛога.Вставить("tracepoint",		?(СтруктураПользовательскихПолей.Свойство("Операция"), СтруктураПользовательскихПолей.Операция, ""));
	СтруктураЛога.Вставить("object",			?(СтруктураПользовательскихПолей.Свойство("ПредставлениеОбъекта"), СтруктураПользовательскихПолей.ПредставлениеОбъекта, ""));
	СтруктураЛога.Вставить("extid",			?(СтруктураПользовательскихПолей.Свойство("ГУИДОбъекта"), СтруктураПользовательскихПолей.ГУИДОбъекта, ""));
	
	//
	ФиксированнаяСтруктураЛога = Новый ФиксированнаяСтруктура(СтруктураЛога);
		
	Возврат ФиксированнаяСтруктураЛога;
	
КонецФункции

// КонструкторСтруктурыПользовательскихПолейЛога
// Конструктор структуры пользовательских данных для записи лога.
// Заполнят соответствующие параметрам свойства структуры пользовательских полей лога.
//
// Параметры:
//	КороткоеСообщение	- Строка	- Короткое представление сообщения.
//	ПолноеСообщение		- Строка	- Полное сообщение.
//	ДатаСобытия			- Строка	- Дата и время события UTC 0.
//	Уровень				- Число		- Уровень лога (ALL=1,FATAL=2,ERROR=3,WARN =4 ,INFO=6,DEBUG=7,TRACE=5).
//						Определяется в ЛогированиеПереопределяемый.КонструкторСтруктураУровнейЛога
//	Подсистема			- Строка	- Представление подсистемы, владельца лога.
//	МетаданныеОбъекта	- Строка	- Представление имени объекта метаданных.
//	Метод				- Строка	- Представление метода.
//	Операция			- Строка	- Идентификатор конкретной выполняемой операции.
//	ПредставлениеОбъекта- Строка	- Представление объекта данных ИБ.
//	ГУИДОбъекта			- Строка	- Представление уникального идентификатора объекта ИБ.
//
// Возвращаемое значение:
//	ФиксированнаяСтруктура			- Структура пользовательских даннных лога, заполненная по значениями соответствующих полей.
//		* КороткоеСообщение			- Строка	- Короткое представление сообщения.
//		* ПолноеСообщение			- Строка	- Полное сообщение.
//		* ДатаСобытия				- Строка	- Дата и время события UTC 0.
//		* Уровень					- Число		- Уровень лога (ALL=1,FATAL=2,ERROR=3,WARN =4 ,INFO=6,DEBUG=7,TRACE=5).
//									Определяется в ЛогированиеПереопределяемый.КонструкторСтруктураУровнейЛога
//		* Подсистема				- Строка	- Представление подсистемы, владельца лога.
//		* МетаданныеОбъекта			- Строка	- Представление имени объекта метаданных.
//		* Метод						- Строка	- Представление метода.
//		* Операция					- Строка	- Идентификатор конкретной выполняемой операции.
//		* ПредставлениеОбъекта		- Строка	- Представление объекта данных ИБ.
//		* ГУИДОбъекта				- Строка	- Представление уникального идентификатора объекта ИБ.
//
Функция КонструкторСтруктурыПользовательскихПолейЛога(КороткоеСообщение = "", 
														ПолноеСообщение = "", 
														Знач ДатаСобытия = "",
														Уровень = 1,
														Подсистема = "", 
														МетаданныеОбъекта = "", 
														Метод = "", 
														Операция = "",
														ПредставлениеОбъекта = "",
														ГУИДОбъекта = "")Экспорт
	
	//Проверим дату
	Если Не ТипЗнч(ДатаСобытия) = Тип("Дата") 
		Или ДатаСобытия = Дата(1,1,1) Тогда 
		ДатаСобытия = УниверсальноеВремя(ТекущаяДата());
	КонецЕсли;
	
	СтруктураПользовательскихПолейЛога = Новый Структура();
	
	СтруктураПользовательскихПолейЛога.Вставить("КороткоеСообщение",	Строка(КороткоеСообщение));
	СтруктураПользовательскихПолейЛога.Вставить("ПолноеСообщение",		Строка(ПолноеСообщение));
	СтруктураПользовательскихПолейЛога.Вставить("ДатаСобытия",			ДатаСобытия);
	СтруктураПользовательскихПолейЛога.Вставить("Уровень",				Уровень);
	СтруктураПользовательскихПолейЛога.Вставить("Подсистема",			Строка(Подсистема));
	СтруктураПользовательскихПолейЛога.Вставить("МетаданныеОбъекта",	Строка(МетаданныеОбъекта));
	СтруктураПользовательскихПолейЛога.Вставить("Метод",				Строка(Метод));
	СтруктураПользовательскихПолейЛога.Вставить("Операция",				Строка(Операция));
	СтруктураПользовательскихПолейЛога.Вставить("ПредставлениеОбъекта",	Строка(ПредставлениеОбъекта));
	СтруктураПользовательскихПолейЛога.Вставить("ГУИДОбъекта",			Строка(ГУИДОбъекта));
	
	//
	Возврат Новый ФиксированнаяСтруктура(СтруктураПользовательскихПолейЛога);
	
КонецФункции

// КонструкторСтруктурыПараметровПодключенияКELK
// Формирует структуру параметров для подключения к базе хранения логов.
//
// Возвращаемое значение:
//	ФиксированнаяСтруктура	- Параметры подключения.
//		* Индекс			- Строка	- Индекс в ElasticSearch (аналог БД).
//		* Тип				- Строка	- Тип в ElasticSearch (аналог Таблицы).
//		* АдресПодключения	- Строка	- Сервер ELK.
//		* ПортПодключения	- Число		- Порт ELK.
//		* Тамаут			- Число		- Ожидание выполнения запроса.
//
Функция КонструкторСтруктурыПараметровПодключенияКELK()Экспорт
	
	СтруктураПараметровПодключения = Новый Структура;
	
	СтруктураПараметровПодключения.Вставить("Индекс", 			ЛогированиеВызовСервера.ПолучитьЗначениеКонстанты("ELK_Индекс"));
	СтруктураПараметровПодключения.Вставить("Тип",				ЛогированиеВызовСервера.ПолучитьЗначениеКонстанты("ELK_Тип"));
	СтруктураПараметровПодключения.Вставить("Сервер",			ЛогированиеВызовСервера.ПолучитьЗначениеКонстанты("ELK_Сервер"));
	СтруктураПараметровПодключения.Вставить("Порт",				ЛогированиеВызовСервера.ПолучитьЗначениеКонстанты("ELK_Порт"));
	СтруктураПараметровПодключения.Вставить("Таймаут", 			ЛогированиеВызовСервера.ПолучитьЗначениеКонстанты("ELK_Таймаут"));
	
	Возврат Новый ФиксированнаяСтруктура(СтруктураПараметровПодключения);
	
КонецФункции

// КонструкторСтруктурыСлужебныхПолейЛога
// Формирует структуру служебных полей лога для Информационной базы.
//
// Возвращаемое значение:
//	ФиксированнаяСтруктура	- Служебные поля лога.
//		* host		- Строка - Сервер.
//		* app		- Строка - Имя приложения.
//		* node		- Строка - Экземпляр ИБ (Применительно к СПО "Пегас" - Узел обмена).
//		* branch	- Строка - Структурная единица ИБ (Применительно к СПО "Пегас" - Филиал ИБ).
//
Функция КонструкторСтруктурыСлужебныхПолейЛога() Экспорт
	
	//Служебные полей ИБ
	СтруктураСлужебныхПолейЛога = Новый Структура();
		
	СтруктураСлужебныхПолейЛога.Вставить("host",	ЛогированиеВызовСервера.ПолучитьСтруктуруПараметровПодключенияКИБ().Сервер);
	СтруктураСлужебныхПолейЛога.Вставить("app",		ЛогированиеВызовСервера.ПолучитьСиноноимКонфигурации());
	СтруктураСлужебныхПолейЛога.Вставить("node",	"Подсистема логирования ELK: Demo"); //рсжBCP_ТекущийУзел
	СтруктураСлужебныхПолейЛога.Вставить("branch",	"Москва Восток"); //споГородПоУмолчанию
	
	Возврат Новый ФиксированнаяСтруктура(СтруктураСлужебныхПолейЛога);
	
КонецФункции

// КонструкторСтруктурыСеансовыхПолейЛога
// Формирует структуру сеансовых данных пользователя.
//
// Возвращаемое значение:
//	Структура	- Сеансовые данные.
//		* ИмяПользователя	- Строка - Полное имя пользователя ИБ.
//		* НомерСеанса		- Строка - Номер сеанса.
//
Функция КонструкторСтруктурыСеансовыхПолейЛога() Экспорт 

	СтруктураСеансовыхПолейЛога = Новый Структура();
	
	СтруктураСеансовыхПолейЛога.Вставить("ИмяПользователя",	ЛогированиеВызовСервера.ПолучитьПолноеИмяТекущегоПользователяИБ());
	СтруктураСеансовыхПолейЛога.Вставить("НомерСеанса",		ЛогированиеВызовСервера.НомерСеансаИнформационнойБазыСтрокой());
	
	Возврат Новый ФиксированнаяСтруктура(СтруктураСеансовыхПолейЛога);	

КонецФункции

// КонструкторСтруктурыПоискаЛогов
// Формирует структуру запроса для поиска логов,
// Примеры запросов в Elasticsearch можно посмотреть здесь: https://codedzen.ru/elasticsearch-urok-6-3-poisk/
//
// Параметры:
//	МассивВыбранныхПолей		- Массив	- Массив строк, имен полей для выбора данных.
//	СтруктураТочногоПоиска		- Структура	- Ключ - Имя поля, по которому будет осуществляться точный поиск, 
//								Значение - Критерий поиска.
//	СтруктураПоискаВхождений	- Структура	- Ключ - Имя поля, по которому будет осуществляться поиск вхождений, 
//								Значение - Критерий поиска.
//	СтруктураБольшеИлиРавно		- Структура	- Ключ - Имя поля, по которому будет осуществляться поиск,
//								Значение - Критерий поиска.		
//	СтруктураМеньшеИлиРавно		- Структура	- Ключ - Имя поля, по которому будет осуществляться поиск, 
//								Значение - Критерий поиска.
//	СтруктураСортировки			- Структура	- Ключ - Имя поля, по которому будет осуществлятьсясортировака, 
//								Значение - Направление сортировки.
//	КоличествоЗаписей			- Число		- Количество записей в выборке.
//
// Возвращаемое значение:
//	Структура	- Структура, которая после сериализации в JSON будет запросом для поиска данных в Elasticsearch
//
Функция КонструкторСтруктурыПоискаЛогов(МассивВыбранныхПолей,
										СтруктураТочногоПоиска, 
										СтруктураПоискаВхождений, 
										СтруктураБольшеИлиРавно,
										СтруктураМеньшеИлиРавно,
										СтруктураСортировки, 
										КоличествоЗаписей = 100)Экспорт 
	
	СтруктураПоиска			= Новый Структура;
	СтруктураQuery			= Новый Структура;
	СтруктураBool			= Новый Структура;
	МассивMust				= Новый Массив;
	МассивNotMust			= Новый Массив;
	СтруктураSort			= Новый Структура;
	
	//Выбор полей
	СтруктураПоиска.Вставить("_source", МассивВыбранныхПолей);
	
	//Набор условий И для четкого поиска
	Для Каждого КлючИЗначение Из СтруктураТочногоПоиска Цикл 
		СоответствиеТипаОтбора	= Новый Соответствие;
		СоответствиеОтбораПоПолю= Новый Соответствие;

		Поле = ?(ТипЗнч(КлючИЗначение.Значение) = Тип("Строка"), КлючИЗначение.Ключ + ".keyword", КлючИЗначение.Ключ);
		СоответствиеОтбораПоПолю.Вставить(Поле, КлючИЗначение.Значение);

		СоответствиеТипаОтбора.Вставить("term", СоответствиеОтбораПоПолю); 

		МассивMust.Добавить(СоответствиеТипаОтбора)	
	КонецЦикла;

	//Набор условий И для поиска вхождений
	Для Каждого КлючИЗначение Из СтруктураПоискаВхождений Цикл 
		СоответствиеТипаОтбора	= Новый Соответствие;
		СоответствиеОтбораПоПолю= Новый Соответствие;
		СоответствиеЗапроса		= Новый Соответствие;
		
		СоответствиеЗапроса.Вставить("query", КлючИЗначение.Значение);
		СоответствиеЗапроса.Вставить("operator", "and");
		
		СоответствиеОтбораПоПолю.Вставить(КлючИЗначение.Ключ, СоответствиеЗапроса);
		
		СоответствиеТипаОтбора.Вставить("match", СоответствиеОтбораПоПолю); 
		
		
		МассивMust.Добавить(СоответствиеТипаОтбора)	
	КонецЦикла;
	
	//Набор условий И Больше или равно
	Для Каждого КлючИЗначение Из СтруктураБольшеИлиРавно Цикл 
		СоответствиеТипаОтбора			= Новый Соответствие;
		СоответствиеОтбораПоПолю		= Новый Соответствие;
		СоответствиеОтбораБольщеИлиРавно= Новый Соответствие;
		
		СоответствиеОтбораБольщеИлиРавно.Вставить("gte", КлючИЗначение.Значение);
		
		СоответствиеОтбораПоПолю.Вставить(КлючИЗначение.Ключ, СоответствиеОтбораБольщеИлиРавно);
		
		СоответствиеТипаОтбора.Вставить("range", СоответствиеОтбораПоПолю); 
		
		МассивMust.Добавить(СоответствиеТипаОтбора)	
	КонецЦикла;
	
	//Набор условий И Меньше или равно
	Для Каждого КлючИЗначение Из СтруктураМеньшеИлиРавно Цикл 
		СоответствиеТипаОтбора			= Новый Соответствие;
		СоответствиеОтбораПоПолю		= Новый Соответствие;
		СоответствиеОтбораМеньщеИлиРавно= Новый Соответствие;
		
		СоответствиеОтбораМеньщеИлиРавно.Вставить("lte", КлючИЗначение.Значение);
		
		СоответствиеОтбораПоПолю.Вставить(КлючИЗначение.Ключ, СоответствиеОтбораМеньщеИлиРавно);
		
		СоответствиеТипаОтбора.Вставить("range", СоответствиеОтбораПоПолю); 
		
		МассивMust.Добавить(СоответствиеТипаОтбора)	
	КонецЦикла;
	
	//Сортировка
	Для Каждого КлючИЗначение Из СтруктураСортировки Цикл 
		СтруктураПараметровСортировки = Новый Структура;
		СтруктураПараметровСортировки.Вставить("order", КлючИЗначение.Значение);
		
		СтруктураSort.Вставить(КлючИЗначение.Ключ, СтруктураПараметровСортировки);
	КонецЦикла;
	
	СтруктураBool.Вставить("must", МассивMust);
	СтруктураQuery.Вставить("bool", СтруктураBool);
		
	//Количество записей в результирующем запросе
	Если ТипЗнч(КоличествоЗаписей) = Тип("Число") Тогда 
		КоличествоЗаписейСтрокой = Формат(КоличествоЗаписей, "ЧГ=0; ЧН=0");
	ИначеЕсли ТипЗнч(КоличествоЗаписей) = Тип("Строка")
		И ОбщегоНазначения.ЭтоЧисло(КоличествоЗаписей) Тогда 
		КоличествоЗаписейСтрокой = СокрЛП(КоличествоЗаписей);
	Иначе
		КоличествоЗаписейСтрокой = "100";		
	КонецЕсли;
	
	//Формирование результирующей структуры
	СтруктураПоиска.Вставить("size", КоличествоЗаписейСтрокой);
	
	СтруктураПоиска.Вставить("query", СтруктураQuery);
	СтруктураПоиска.Вставить("sort", СтруктураSort);
	
	Возврат СтруктураПоиска;
	
КонецФункции


#КонецОбласти



#Область СлужебныеПроцедурыИФункции


#КонецОбласти