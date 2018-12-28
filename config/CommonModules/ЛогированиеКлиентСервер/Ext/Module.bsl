﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Логирование"
//
// 
//
////////////////////////////////////////////////////////////////////////////////



#Область ПрограммныйИнтерфейс


// КонструкторСтруктурыЛога
// Конструктор полной структуры данных для записи лога.
// Формирует структуру лога, заполняет обязательные служебные свойства и,
// в случае наличия, пользовательские
//
// Параметры:
//	СтруктураПользовательскихПолей	- Структура		- Коллекция пользовательских полей, 
//													которые будут перенесены в общую структуру лога.
//
// Возвращаемое значение:
//	ФиксированнаяСтруктура	- Набор обязательных свойств лога.
//		* version			- Версия используемого формата GELF.
//		* host				- Сервер.
//		* short_message		- Короткое представление сообщения.
//		* full_message		- Полное сообщение.
//		* timestamp			- Дата и время события UTC 0.
//		* level				- Уровень лога (ALL=1,FATAL=2,ERROR=3,WARN =4 ,INFO=6,DEBUG=7,TRACE=5).
//		* _app				- Имя приложения, владельца лога.
//		* _node				- Экземпляр ИБ (Применительно к СПО "Пегас" - Узел обмена).
//		* _branch			- Структурная единица ИБ (Применительно к СПО "Пегас" - Филиал ИБ).
//		* _user				- Представление пользователя.
//		* _session			- Номер сеанса пользователя.
//		* _subsystem		- Представление подсистемы, владельца лога.
//		* _metadataObject	- Представление имени объекта метаданных.
//		* _method			- Представление метода.
//		* _tracepoint		- Идентификатор конкретной выполняемой операции.
//		* _object			- Представление объекта данных ИБ.
//		* _extid			- Представление уникального идентификатора объекта ИБ.
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
	СтруктураЛога.Вставить("level",				СтруктураУровнейЛога.ALL);
	
	//Служебные поля лога СПО "Пегас"
	СтруктураЛога.Вставить("_app",				СтруктураСлужебныхПолейЛога._app);
	СтруктураЛога.Вставить("_node",				СтруктураСлужебныхПолейЛога._node);
	СтруктураЛога.Вставить("_branch",			СтруктураСлужебныхПолейЛога._branch);
	
	//Сеансовые поля
	СтруктураЛога.Вставить("_user",				СтруктураСеансовыхПолейЛога.ИмяПользователя);
	СтруктураЛога.Вставить("_session",			СтруктураСеансовыхПолейЛога.НомерСеанса);
	
	//Пользовательские поля
	СтруктураЛога.Вставить("_subsystem",		?(СтруктураПользовательскихПолей.Свойство("Подсистема"), СтруктураПользовательскихПолей.Подсистема, ""));
	СтруктураЛога.Вставить("_metadataObject",	?(СтруктураПользовательскихПолей.Свойство("МетаданныеОбъекта"), СтруктураПользовательскихПолей.МетаданныеОбъекта, ""));
	СтруктураЛога.Вставить("_method",			?(СтруктураПользовательскихПолей.Свойство("Метод"), СтруктураПользовательскихПолей.Метод, ""));
	СтруктураЛога.Вставить("_tracepoint",		?(СтруктураПользовательскихПолей.Свойство("Операция"), СтруктураПользовательскихПолей.Операция, ""));
	СтруктураЛога.Вставить("_object",			?(СтруктураПользовательскихПолей.Свойство("ПредставлениеОбъекта"), СтруктураПользовательскихПолей.ПредставлениеОбъекта, ""));
	СтруктураЛога.Вставить("_extid",			?(СтруктураПользовательскихПолей.Свойство("ГУИДОбъекта"), СтруктураПользовательскихПолей.ГУИДОбъекта, ""));
	
	//
	ФиксированнаяСтруктураЛога = Новый ФиксированнаяСтруктура(СтруктураЛога);
		
	Возврат ФиксированнаяСтруктураЛога;
	
КонецФункции

// КонструкторСтруктурыПользовательскихПолейЛога
// Конструктор структуры пользовательских данных для записи лога.
// Заполнят соответствующие параметрам свойства структуры пользовательских полей лога.
//
// Параметры:
//	КороткоеСообщение	- Строка - Короткое представление сообщения.
//	ПолноеСообщение		- Строка - Полное сообщение.
//	ДатаСобытия			- Строка - Дата и время события UTC 0.
//	Подсистема			- Строка - Представление подсистемы, владельца лога.
//	МетаданныеОбъекта	- Строка - Представление имени объекта метаданных.
//	Метод				- Строка - Представление метода.
//	Операция			- Строка - Идентификатор конкретной выполняемой операции.
//	ПредставлениеОбъекта- Строка - Представление объекта данных ИБ.
//	ГУИДОбъекта			- Строка - редставление уникального идентификатора объекта ИБ.
//
// Возвращаемое значение:
//	ФиксированнаяСтруктура	-  Структура пользовательских даннных лога, заполненная по значениями соответствующих полей.
//
Функция КонструкторСтруктурыПользовательскихПолейЛога(КороткоеСообщение = "", 
														ПолноеСообщение = "", 
														Знач ДатаСобытия = "",
														Подсистема = "", 
														МетаданныеОбъекта = "", 
														Метод = "", 
														Операция = "",
														ПредставлениеОбъекта = "",
														ГУИДОбъекта = "")Экспорт
	
	//Проверим дату
	Если Не ТипЗнч(ДатаСобытия) = Тип("Дата") Тогда 
		ДатаСобытия = УниверсальноеВремя(ТекущаяДата());
	КонецЕсли;
	
	СтруктураПользовательскихПолейЛога = Новый Структура();
	
	СтруктураПользовательскихПолейЛога.Вставить("КороткоеСообщение",	Строка(КороткоеСообщение));
	СтруктураПользовательскихПолейЛога.Вставить("ПолноеСообщение",		Строка(ПолноеСообщение));
	СтруктураПользовательскихПолейЛога.Вставить("ДатаСобытия",			ДатаСобытия);
	СтруктураПользовательскихПолейЛога.Вставить("Подсистема",			Строка(Подсистема));
	СтруктураПользовательскихПолейЛога.Вставить("МетаданныеОбъекта",	Строка(МетаданныеОбъекта));
	СтруктураПользовательскихПолейЛога.Вставить("Метод",				Строка(Метод));
	СтруктураПользовательскихПолейЛога.Вставить("Операция",				Строка(Операция));
	СтруктураПользовательскихПолейЛога.Вставить("ПредставлениеОбъекта",	Строка(ПредставлениеОбъекта));
	СтруктураПользовательскихПолейЛога.Вставить("ГУИДОбъекта",			Строка(ГУИДОбъекта));
	
	//
	Возврат СтруктураПользовательскихПолейЛога;
	
КонецФункции

// КонструкторСтруктурыПараметровПодключенияКELK
//
// Возвращаемое значение:
//	Структура	- Параметры подключения.
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
//	Структура	- Служебные поля лога.
//		* host		- Строка - Сервер.
//		* _app		- Строка - Имя приложения.
//		* _node		- Строка - Экземпляр ИБ (Применительно к СПО "Пегас" - Узел обмена).
//		* _branch	- Строка - Структурная единица ИБ (Применительно к СПО "Пегас" - Филиал ИБ).
//
Функция КонструкторСтруктурыСлужебныхПолейЛога() Экспорт
	
	//Служебные полей ИБ
	СтруктураСлужебныхПолейЛога = Новый Структура();
		
	СтруктураСлужебныхПолейЛога.Вставить("host",	ЛогированиеВызовСервера.ПолучитьСтруктуруПараметровПодключенияКИБ().Сервер);
	СтруктураСлужебныхПолейЛога.Вставить("_app",	ЛогированиеВызовСервера.ПолучитьСиноноимКонфигурации());
	СтруктураСлужебныхПолейЛога.Вставить("_node",	"Подсистема логирования ELK: Demo"); //рсжBCP_ТекущийУзел
	СтруктураСлужебныхПолейЛога.Вставить("_branch",	"Москва Восток"); //споГородПоУмолчанию
	
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

Функция КонструкторСтруктурыПоискаЛогов(СтруктураПолейТочногоПоиска, СтруктураПолейПоискаВхождений, КоличествоЗаписей = 100)Экспорт 
	
	СтруктураПоиска			= Новый Структура;
	СтруктураQuery			= Новый Структура;
	СтруктураBool			= Новый Структура;
	МассивMust				= Новый Массив;
	МассивNotMust			= Новый Массив;
	
	//Набор условий И
	Для Каждого КлючИЗначение Из СтруктураПолейТочногоПоиска Цикл 
		
	КонецЦикла;
	
	//Формирование результирующей структуры
	Если Не КоличествоЗаписей = 0 Тогда 
		СтруктураПоиска.Вставить("size", КоличествоЗаписей);
	КонецЕсли;
	СтруктураПоиска.Вставить("query", СтруктураQuery);
	
	
	
КонецФункции

#КонецОбласти



#Область СлужебныйПрограммныйИнтерфейс


#КонецОбласти



#Область СлужебныеПроцедурыИФункции


#КонецОбласти