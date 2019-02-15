﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Логирование"
//
//
//
////////////////////////////////////////////////////////////////////////////////



#Область ПрограммныйИнтерфейс


// ВыполнитьЗаписьЛогаСервер
// Выполняет подготовку запроса и запись лога в базу данных на сервере.
//
// Параметры:
//	СтруктураЛога			- ФиксированнаяСтруктура	- Коллекция обязательных полей лога.
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
//	ТекстОшибки				- Строка	- Содержит описание ошибки, в случае возникновения оной.
//	Отказ					- Булево	- Признак возникновения ошибки выполнения.
//
// Возвращаемое значение:
//	Структура				- Результат выполнения HTTP запроса 
//		* Результат				- Булево		- Флаг успешности выполнения запроса.
//		* КодСостояния			- Число			- Код состояния выполнения запроса, возвращенный сервером.
//		* РезультатВыполнения	- Соответствие	- Сериализованный в Соответствие ответ сервера.
//								- Неопределено	- В случае возникновения ошибки.	
//		* ТекстОшибки			- Строка		- Представление ошибки выполнения запроса.
//
Функция ВыполнитьЗаписьЛогаСервер(СтруктураЛога, ТекстОшибки = "", Отказ = Ложь)Экспорт 
	
	// Получение параметров подключения к ELK
	СтруктураПараметровПодключения = ПараметрыСеанса.ПараметрыПодключенияКELK_Запись;
	
	// Получение строки данных в JSON
	ДанныеЛогаВJSON 			= СериализоватьСтруктуруВJSON(СтруктураЛога, ТекстОшибки, Отказ);
	
	// Получение текста запроса на добавление лога в ELK
	АдресРесурса				= СформироватьАдресРесурса_ДобавлениеЛога(СтруктураПараметровПодключения.Индекс, СтруктураПараметровПодключения.Тип);
	
	// Создание запроса на добавление лога в ELK
	HTTPЗапрос					= КонструкторHTTPЗапросаELK(АдресРесурса, ДанныеЛогаВJSON);
	
	// Отправка запроса в ELK
	СтруктураОтвета				= ЗапросPostELK(СтруктураПараметровПодключения, HTTPЗапрос, ТекстОшибки, Отказ);
	
	Возврат СтруктураОтвета;
КонецФункции

// ВыполнитьПоискЛоговСервер
// Выполняет подготовку запроса и поиск логов в базе данных на Сервер.
//
// Параметры:
//	СтруктураПоискаЛогов	- Структура	- Структура параметров поиска. 
//							Формируется в ЛогированиеКлиентСервер.КонструкторСтруктурыПоискаЛогов
//	ТекстОшибки				- Строка	- Содержит описание ошибки, в случае возникновения оной.
//	Отказ					- Булево	- Признак возникновения ошибки выполнения.
//
// Возвращаемое значение:
//	Структура				- Результат выполнения HTTP запроса 
//		* Результат				- Булево		- Флаг успешности выполнения запроса.
//		* КодСостояния			- Число			- Код состояния выполнения запроса, возвращенный сервером.
//		* РезультатВыполнения	- Соответствие	- Сериализованный в Соответствие ответ сервера, в данном случае результаты поиска логов.
//								- Неопределено	- В случае возникновения ошибки.	
//		* ТекстОшибки			- Строка		- Представление ошибки выполнения запроса.
//
Функция ВыполнитьПоискЛоговСервер(СтруктураПоискаЛогов, ТекстОшибки = "", Отказ = Ложь)Экспорт 
	
	// Получение параметров подключения к ELK
	СтруктураПараметровПодключения = ПараметрыСеанса.ПараметрыПодключенияКELK_Чтение;
	
	// Получение строки данных в JSON
	ДанныеПоискаЛогаВJSON 		= СериализоватьСтруктуруВJSON(СтруктураПоискаЛогов, ТекстОшибки, Отказ);
	
	// Получение текста запроса на поиск логов в ELK
	АдресРесурса				= СформироватьАдресРесурса_ПоискЛогов(СтруктураПараметровПодключения.Индекс, СтруктураПараметровПодключения.Тип);
	
	// Создание запроса на поиск логов в ELK
	HTTPЗапрос					= КонструкторHTTPЗапросаELK(АдресРесурса, ДанныеПоискаЛогаВJSON);
	
	// Отправка запроса в ELK
	СтруктураОтвета				= ЗапросPostELK(СтруктураПараметровПодключения, HTTPЗапрос, ТекстОшибки, Отказ);
	
	Возврат СтруктураОтвета;
КонецФункции

// ВыполнитьПолучениеСостоянияКластераСервер
// Выполняет подготовку и выполнение запроса для получения состояния Кластера и Индексов (Баз данных).
//
// Параметры:
//	ТекстОшибки				- Строка	- Содержит описание ошибки, в случае возникновения оной.
//	Отказ					- Булево	- Признак возникновения ошибки выполнения.
//
// Возвращаемое значение:
//	Структура				- Результат выполнения HTTP запроса 
//		* Результат				- Булево		- Флаг успешности выполнения запроса.
//		* КодСостояния			- Число			- Код состояния выполнения запроса, возвращенный сервером.
//		* РезультатВыполнения	- Соответствие	- Сериализованный в Соответствие ответ сервера, в данном случае состояние Кластера и Индексов.
//								- Неопределено	- В случае возникновения ошибки.	
//		* ТекстОшибки			- Строка		- Представление ошибки выполнения запроса.
//
Функция ВыполнитьПолучениеСостоянияКластераСервер(ТекстОшибки = "", Отказ = Ложь)Экспорт 
	
	// Получение параметров подключения к ELK
	СтруктураПараметровПодключения = ПараметрыСеанса.ПараметрыПодключенияКELK_Чтение;
	
	// Получение строки данных в JSON
	ДанныеЛогаВJSON 			= "";
	
	// Получение текста запроса на добавление лога в ELK
	АдресРесурса				= СформироватьАдресРесурса_СостояниеКластера();
	
	// Создание запроса на добавление лога в ELK
	HTTPЗапрос					= КонструкторHTTPЗапросаELK(АдресРесурса, ДанныеЛогаВJSON);
	
	// Отправка запроса в ELK
	СтруктураОтвета				= ЗапросGetELK(СтруктураПараметровПодключения, HTTPЗапрос, ТекстОшибки, Отказ);
	
	Возврат СтруктураОтвета;
КонецФункции	

// ВыполнитьПолучениеМаппингаИндексовСервер
// Выполняет подготовку и выполнение запроса для получения структуры полей Типов (таблиц) Индексов (Баз данных).
//
// Параметры:
//	ТекстОшибки				- Строка	- Содержит описание ошибки, в случае возникновения оной.
//	Отказ					- Булево	- Признак возникновения ошибки выполнения.
//
// Возвращаемое значение:
//	Структура				- Результат выполнения HTTP запроса 
//		* Результат				- Булево		- Флаг успешности выполнения запроса.
//		* КодСостояния			- Число			- Код состояния выполнения запроса, возвращенный сервером.
//		* РезультатВыполнения	- Соответствие	- Сериализованный в Соответствие ответ сервера, в данном случае структуры полей Типов.
//								- Неопределено	- В случае возникновения ошибки.	
//		* ТекстОшибки			- Строка		- Представление ошибки выполнения запроса.
//
Функция ВыполнитьПолучениеМаппингаИндексовСервер(Индекс = "", ТекстОшибки = "", Отказ = Ложь)Экспорт 
	
	// Получение параметров подключения к ELK
	СтруктураПараметровПодключения = ПараметрыСеанса.ПараметрыПодключенияКELK_Чтение;
	
	// Получение строки данных в JSON
	ДанныеЛогаВJSON 			= "";
	
	// Получение текста запроса на добавление лога в ELK
	АдресРесурса				= СформироватьАдресРесурса_МаппингИндексов(Индекс);
	
	// Создание запроса на добавление лога в ELK
	HTTPЗапрос					= КонструкторHTTPЗапросаELK(АдресРесурса, ДанныеЛогаВJSON);
	
	// Отправка запроса в ELK
	СтруктураОтвета				= ЗапросGetELK(СтруктураПараметровПодключения, HTTPЗапрос, ТекстОшибки, Отказ);
	
	Возврат СтруктураОтвета;
КонецФункции


#КонецОбласти



#Область СлужебныйПрограммныйИнтерфейс


// СериализоватьСтруктуруВJSON
// Сериализует переданную структуру в строку JSON.
//
// Параметры:
//	Структура	- Произвольная коллекция Ключей и Значений для сериализации в формат JSON.
//	ТекстОшибки	- Строка	- Содержит описание ошибки, в случае возникновения оной.
//	Отказ		- Булево	- Признак возникновения ошибки выполнения.
//
// Возвращаемое значение:
//	Строка		- Сериализованная строка в формате JSON.
//				- Пустая строка в случае возникновения ошибки.
//
Функция СериализоватьСтруктуруВJSON(Структура, ТекстОшибки = "", Отказ = Ложь)Экспорт 
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	Попытка
		ЗаписатьJSON(ЗаписьJSON, Структура);
		СтрокаJSON = ЗаписьJSON.Закрыть();
	Исключение
		Отказ		= Истина;
		ТекстОшибки = "Не удалось сформировать сообщение JSON: " + ОписаниеОшибки();
		СтрокаJSON = "";
	КонецПопытки;
	
	Возврат СтрокаJSON;
	
КонецФункции

// ПолучитьНомерСеансаИнформационнойБазыСервер
// Возвращает номера текущего сеанса.
//
// Возвращаемое значение:
//	Число	- Номер текущего сеанса информационной базы.
//
Функция ПолучитьНомерСеансаИнформационнойБазыСервер() Экспорт 
	Возврат НомерСеансаИнформационнойБазы();
КонецФункции

// ЗаполнитьПараметрыПодключенияКELKСервер
// Выполняет чтение настроек подключения из регистра и заполняет структуру параметров.
//
// Параметры:
//	СтруктураПараметровПодключения	- Структура	- Параметры подключения к ELK.
//		* Сервер	- Строка	- Сервер ELK.
//		* Порт		- Число		- Порт ELK.
//		* Индекс	- Строка	- Индекс в ElasticSearch (аналог БД).
//		* Тип		- Строка	- Тип в ElasticSearch (аналог Таблицы).
//		* Таймаут	- Число		- Ожидание выполнения запроса.
//	ТипНастройкиПодключенияКELK		- ПеречислениеСсылка.ТипыНастроекПодключенияКELK - Тип настройки (Для чтения или для записи).
//
// Возвращаемое значение:
//	Структура	- СтруктураПараметровПодключения, заполненная, в случае существования записи с соответствующим типом настройки.
//
Функция ЗаполнитьПараметрыПодключенияКELKСервер(СтруктураПараметровПодключения, ТипНастройкиПодключенияКELK)Экспорт 
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПараметрыПодключенияКELK.Сервер КАК Сервер,
		|	ПараметрыПодключенияКELK.Порт КАК Порт,
		|	ПараметрыПодключенияКELK.Индекс КАК Индекс,
		|	ПараметрыПодключенияКELK.Тип КАК Тип,
		|	ПараметрыПодключенияКELK.Таймаут КАК Таймаут
		|ИЗ
		|	РегистрСведений.ПараметрыПодключенияКELK КАК ПараметрыПодключенияКELK
		|ГДЕ
		|	ПараметрыПодключенияКELK.ТипНастройки = &ТипНастройки";
	
	Запрос.УстановитьПараметр("ТипНастройки", ТипНастройкиПодключенияКELK);
	ВыборкаНастроекПодключенияКELK = Запрос.Выполнить().Выбрать();
		
	Если ВыборкаНастроекПодключенияКELK.Следующий() Тогда 
		ЗаполнитьЗначенияСвойств(СтруктураПараметровПодключения, ВыборкаНастроекПодключенияКELK);	
	КонецЕсли;
	
	Возврат СтруктураПараметровПодключения;
	
КонецФункции

// ЗаписатьПараметрыПодключенияКELKСервер
// Выполняет запись настроек подключения в регистр.
//
// Параметры:
//	СтруктураПараметровПодключения	- Структура	- Параметры подключения к ELK.
//		* ТипНастройки	- ПеречислениеСсылка.ТипыНастроекПодключенияКELK - Тип настройки (Для чтения или для записи).
//		* Сервер	- Строка	- Сервер ELK.
//		* Порт		- Число		- Порт ELK.
//		* Индекс	- Строка	- Индекс в ElasticSearch (аналог БД).
//		* Тип		- Строка	- Тип в ElasticSearch (аналог Таблицы).
//		* Таймаут	- Число		- Ожидание выполнения запроса.
//	ТипНастройкиПодключенияКELK		- ПеречислениеСсылка.ТипыНастроекПодключенияКELK - Тип настройки (Для чтения или для записи).
//	ТекстОшибки	- Строка	- Содержит описание ошибки, в случае возникновения оной.
//	Отказ		- Булево	- Признак возникновения ошибки выполнения.
//
Процедура ЗаписатьПараметрыПодключенияКELKСервер(СтруктураПараметровПодключения, ТекстОшибки = "", Отказ = Ложь)Экспорт 
	
	МенеджерЗаписи = РегистрыСведений.ПараметрыПодключенияКELK.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, СтруктураПараметровПодключения);
	
	Попытка
		МенеджерЗаписи.Записать(Истина);
	Исключение
		ТекстОшибки	= ОписаниеОшибки();
		Отказ		= Истина;
	КонецПопытки;
	
	Если СтруктураПараметровПодключения.ТипНастройки = Перечисления.ТипыНастроекПодключенияКELK.Чтение Тогда 
		ПараметрыСеанса.ПараметрыПодключенияКELK_Чтение = ЛогированиеКлиентСервер.КонструкторСтруктурыПараметровПодключенияКELK(Перечисления.ТипыНастроекПодключенияКELK.Чтение);
	ИначеЕсли СтруктураПараметровПодключения.ТипНастройки = Перечисления.ТипыНастроекПодключенияКELK.Запись Тогда 
		ПараметрыСеанса.ПараметрыПодключенияКELK_Запись = ЛогированиеКлиентСервер.КонструкторСтруктурыПараметровПодключенияКELK(Перечисления.ТипыНастроекПодключенияКELK.Запись);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти



#Область СлужебныеПроцедурыИФункции


// Генерация Адресов запросов

// СформироватьАдресРесурса_ДобавлениеЛога
// Формирует строку адреса для выполнения запроса добавления лога.
//
// Параметры:
//	Индекс	- Строка	- Наименование Индекса (Базы данных).
//	Тип		- Строка	- Наименование Типа (Таблицы).
//
// Возвращаемое значение:
//	Строка	- Адрес ресурса для выполнения HTTP запроса добавления лога.
//
Функция СформироватьАдресРесурса_ДобавлениеЛога(Индекс, Тип)
	
	// Адрес запроса
	АдресРесурса = "/" + Индекс + "/" + Тип + "/"; // тут был свой ГУИД
	// Если необходимо обновить имеющийся документ, дополним команду
	//СтрокаЗапроса = ?(Обновлять = Истина, СтрокаЗапроса + "/_update", СтрокаЗапроса);
	
	
	Возврат АдресРесурса;
	
КонецФункции

// СформироватьАдресРесурса_ПоискЛогов
// Формирует строку адреса для выполнения запроса поиска логов.
//
// Параметры:
//	Индекс	- Строка	- Наименование Индекса (Базы данных).
//	Тип		- Строка	- Наименование Типа (Таблицы).
//
// Возвращаемое значение:
//	Строка	- Адрес ресурса для выполнения HTTP запроса поиска логов.
//
Функция СформироватьАдресРесурса_ПоискЛогов(Индекс, Тип)
	
	// Адрес запроса
	СтрокаАдресаЗапроса = "/" + Индекс + "/" + Тип + "/_search";
	
	Возврат СтрокаАдресаЗапроса;
	
КонецФункции

// СформироватьАдресРесурса_СостояниеКластера
// Формирует строку адреса для выполнения запроса получения состояния кластера.
//
// Возвращаемое значение:
//	Строка	- Адрес ресурса для выполнения HTTP запроса получения состояния кластера.
//
Функция СформироватьАдресРесурса_СостояниеКластера()
	
	// Адрес запроса
	СтрокаАдресаЗапроса = "/_cluster/health?level=indices";
	
	Возврат СтрокаАдресаЗапроса;
	
КонецФункции

// СформироватьАдресРесурса_МаппингИндексов
// Формирует строку адреса для выполнения запроса получения структуры полей Типов (Таблиц) Индексов (Базы данных).
//
// Параметры:
//	Индекс	- Строка	- Наименование Индекса (Базы данных).
//
// Возвращаемое значение:
//	Строка	- Адрес ресурса для выполнения HTTP запроса получения структуры полей Типов Индексов.
//
Функция СформироватьАдресРесурса_МаппингИндексов(Индекс = "")
	
	// Адрес запроса
	
	Если ЗначениеЗаполнено(Индекс) Тогда 
		// По индексу
		СтрокаАдресаЗапроса = "/" + Индекс + "/_mapping?pretty=true";
	Иначе
		// По всем
		СтрокаАдресаЗапроса = "/_mapping?pretty=true";
	КонецЕсли;
	
	Возврат СтрокаАдресаЗапроса;
	
КонецФункции

//// Генерация Адресов запросов


// Выполнение запросов

// КонструкторHTTPЗапросаELK
// Создает HTTPЗапрос по полученным параметрам.
//
// Параметры:
//	АдресРесурса	- Строка	- Адрес ресурса для выполнения HTTP запроса.
//	ДанныеЛогаВJSON	- Строка	- Сериализованная строка в формате JSON.
//
// Возвращаемое значение:
//	HTTPЗапрос	- Сформированный запрос для выполнения.
//
Функция КонструкторHTTPЗапросаELK(АдресРесурса, ДанныеЛогаВJSON)
	
	Запрос = Новый HTTPЗапрос(АдресРесурса);
	Запрос.Заголовки.Вставить("Content-Type", "application/json");
	// Необходимо убрать BOM символ. Такой вариант самый простой.
	Запрос.УстановитьТелоИзСтроки(ДанныеЛогаВJSON, "UTF8", ИспользованиеByteOrderMark.НеИспользовать);
	
	Возврат Запрос;
	
КонецФункции

// ЗапросPostELK
// Выполняет POST запрос к HTTP серверу.
//
// Параметры:
//	СтруктураПараметровПодключения	- ФиксированнаяСтруктура	- Параметры подключения к ELK
//		* Индекс			- Строка	- Индекс в ElasticSearch (аналог БД).
//		* Тип				- Строка	- Тип в ElasticSearch (аналог Таблицы).
//		* АдресПодключения	- Строка	- Сервер ELK.
//		* ПортПодключения	- Число		- Порт ELK.
//		* Таймаут			- Число		- Ожидание выполнения запроса.
//	HTTPЗапрос				- HTTPЗапрос- Сформированный запрос для выполнения.
//	ТекстОшибки				- Строка	- Содержит описание ошибки, в случае возникновения оной.
//	Отказ					- Булево	- Признак возникновения ошибки выполнения.
//
// Возвращаемое значение:
//	ФиксированнаяСтруктура		- Результат выполнения HTTP запроса 
//		* Результат				- Булево		- Флаг успешности выполнения запроса.
//		* КодСостояния			- Число			- Код состояния выполнения запроса, возвращенный сервером.
//		* РезультатВыполнения	- Соответствие	- Сериализованный в Соответствие ответ сервера.
//								- Неопределено	- В случае возникновения ошибки.	
//		* ТекстОшибки			- Строка		- Представление ошибки выполнения запроса.
//
Функция ЗапросPostELK(СтруктураПараметровПодключения, HTTPЗапрос, ТекстОшибки = "", Отказ = Ложь) 
	
	// Установка соединения
	Соединение = УстановитьСоединениеСELK(СтруктураПараметровПодключения, ТекстОшибки, Отказ);
	
	Попытка
		ОтветСервера = Соединение.ОтправитьДляОбработки(HTTPЗапрос);
	Исключение
		ОтветСервера	= Неопределено;
		Отказ			= Истина;
		ТекстОшибки 	= "Не удалось выполнить POST запрос: " + ОписаниеОшибки();		
	КонецПопытки;	
	
	Возврат ПарсингОтвета(ОтветСервера, ТекстОшибки);
	
КонецФункции

// ЗапросGetELK
// Выполняет Get запрос к HTTP серверу.
//
// Параметры:
//	СтруктураПараметровПодключения	- ФиксированнаяСтруктура	- Параметры подключения к ELK
//		* Индекс			- Строка	- Индекс в ElasticSearch (аналог БД).
//		* Тип				- Строка	- Тип в ElasticSearch (аналог Таблицы).
//		* АдресПодключения	- Строка	- Сервер ELK.
//		* ПортПодключения	- Число		- Порт ELK.
//		* Таймаут			- Число		- Ожидание выполнения запроса.
//	HTTPЗапрос				- HTTPЗапрос- Сформированный запрос для выполнения.
//	ТекстОшибки				- Строка	- Содержит описание ошибки, в случае возникновения оной.
//	Отказ					- Булево	- Признак возникновения ошибки выполнения.
//
// Возвращаемое значение:
//	ФиксированнаяСтруктура		- Результат выполнения HTTP запроса 
//		* Результат				- Булево		- Флаг успешности выполнения запроса.
//		* КодСостояния			- Число			- Код состояния выполнения запроса, возвращенный сервером.
//		* РезультатВыполнения	- Соответствие	- Сериализованный в Соответствие ответ сервера.
//								- Неопределено	- В случае возникновения ошибки.	
//		* ТекстОшибки			- Строка		- Представление ошибки выполнения запроса.
//
Функция ЗапросGetELK(СтруктураПараметровПодключения, HTTPЗапрос, ТекстОшибки = "", Отказ = Ложь) 
	
	ОтветСервера	= Неопределено;
	
	// Установка соединения
	Соединение = УстановитьСоединениеСELK(СтруктураПараметровПодключения, ТекстОшибки, Отказ);
	
	Если Отказ Тогда 
		Возврат ПарсингОтвета(ОтветСервера, ТекстОшибки);
	КонецЕсли;
	
	Попытка
		ОтветСервера = Соединение.Получить(HTTPЗапрос);
	Исключение
		Отказ			= Истина;
		ТекстОшибки 	= "Не удалось выполнить GET  запрос: " + ОписаниеОшибки();		
	КонецПопытки;	
	
	Возврат ПарсингОтвета(ОтветСервера, ТекстОшибки);
	
КонецФункции

// ПарсингОтвета
// Функция преобразует результат выполнения HTTP запроса в структуру для дальнейшей обработки.
//
// Параметры:
//	ОтветСервера	- HTTPОтвет		- Ответ сервера после выполнения HTTP запроса.
//					- Неопределено  - В случае возникновения ошибки при выполнении запроса.
//	ТекстОшибки		- Строка		- Содержит описание ошибки, в случае возникновения оной.
//
// Возвращаемое значение:
//	ФиксированнаяСтруктура		- Результат выполнения HTTP запроса 
//		* Результат				- Булево		- Флаг успешности выполнения запроса.
//		* КодСостояния			- Число			- Код состояния выполнения запроса, возвращенный сервером.
//		* РезультатВыполнения	- Соответствие	- Сериализованный в Соответствие ответ сервера.
//								- Строка		- В случае ошибки преобразования в Соответствие.
//								- Неопределено	- В случае возникновения прочих ошибок.
//		* ТекстОшибки			- Строка		- Представление ошибки выполнения запроса.
//
Функция ПарсингОтвета(ОтветСервера, ТекстОшибки = "") 
	
	СтруктураРезультатаВыполненияЗапроса = Новый Структура();
	
	СтруктураРезультатаВыполненияЗапроса.Вставить("Результат",				Ложь);
	СтруктураРезультатаВыполненияЗапроса.Вставить("КодСостояния",			0);
	СтруктураРезультатаВыполненияЗапроса.Вставить("РезультатВыполнения",	Неопределено);
	СтруктураРезультатаВыполненияЗапроса.Вставить("ТекстОшибки",			"");
	
	
	Если ОтветСервера = Неопределено Тогда 
		
		СтруктураРезультатаВыполненияЗапроса.Результат				= Ложь;
		СтруктураРезультатаВыполненияЗапроса.КодСостояния			= 0;
		СтруктураРезультатаВыполненияЗапроса.РезультатВыполнения	= Неопределено;
		СтруктураРезультатаВыполненияЗапроса.ТекстОшибки			= ТекстОшибки;
		
	ИначеЕсли ОтветСервера.КодСостояния >= 200 И ОтветСервера.КодСостояния < 300  Тогда 
		
		ЧтениеJSONОтвета = Новый ЧтениеJSON;
		ТелоОтвета = ОтветСервера.ПолучитьТелоКакСтроку("UTF8");
		ЧтениеJSONОтвета.УстановитьСтроку(ТелоОтвета);
		// TODO Разобраться с преобразованием даты в поле timestamp (Для запроса структуры полей там лежит не дата а описание поля)
		//РезультатВыполнения = ПрочитатьJSON(ЧтениеJSONОтвета, Истина, "timestamp");
		Попытка
			РезультатВыполнения = ПрочитатьJSON(ЧтениеJSONОтвета, Истина);
		Исключение
			РезультатВыполнения = Строка(ТелоОтвета);
		КонецПопытки;
		
		ЧтениеJSONОтвета.Закрыть();
		
		СтруктураРезультатаВыполненияЗапроса.Результат				= Истина;
		СтруктураРезультатаВыполненияЗапроса.КодСостояния			= ОтветСервера.КодСостояния;
		СтруктураРезультатаВыполненияЗапроса.РезультатВыполнения	= РезультатВыполнения;
		СтруктураРезультатаВыполненияЗапроса.ТекстОшибки			= "";
		
	Иначе
		
		СтруктураРезультатаВыполненияЗапроса.Результат				= Ложь;
		СтруктураРезультатаВыполненияЗапроса.КодСостояния			= ОтветСервера.КодСостояния;
		СтруктураРезультатаВыполненияЗапроса.РезультатВыполнения	= Неопределено;
		СтруктураРезультатаВыполненияЗапроса.ТекстОшибки			= "Ошибка отправки HTTP запроса: " + ОтветСервера.КодСостояния;
		
	КонецЕсли;
	
	Возврат Новый ФиксированнаяСтруктура(СтруктураРезультатаВыполненияЗапроса);
	
КонецФункции

//// Выполнение запросов


// Работа с соединениями

// УстановитьСоединениеСELK
// Создает HTTP соединение по указанным параметрам.
//
// Параметры:
//	СтруктураПараметровПодключения	- ФиксированнаяСтруктура	- Параметры подключения к ELK
//		* Индекс			- Строка	- Индекс в ElasticSearch (аналог БД).
//		* Тип				- Строка	- Тип в ElasticSearch (аналог Таблицы).
//		* АдресПодключения	- Строка	- Сервер ELK.
//		* ПортПодключения	- Число		- Порт ELK.
//		* Таймаут			- Число		- Ожидание выполнения запроса.
//	ТекстОшибки				- Строка	- Содержит описание ошибки, в случае возникновения оной.
//	Отказ					- Булево	- Признак возникновения ошибки выполнения.
//
// Возвращаемое значение:
//	HTTPСоединение	- Соединение с HTTP сервером.
//	Неопределено	- В случае возникновения ошибки.
Функция УстановитьСоединениеСELK(СтруктураПараметровПодключения, ТекстОшибки = "", Отказ = Ложь) 
	
	Попытка
		Соединение = Новый HTTPСоединение(СтруктураПараметровПодключения.Сервер, СтруктураПараметровПодключения.Порт,,,,СтруктураПараметровПодключения.Таймаут);		
	Исключение
		Соединение	= Неопределено;
		Отказ		= Истина;
		ТекстОшибки	= "Не удалось установить соединение с ElasticSearch по причине: " + ОписаниеОшибки();
	КонецПопытки;
	
	Возврат Соединение;
	
КонецФункции

// ЗакрытьСоединениеСElasticSearch
// Закрывает HTTP соединение.
//
// Параметры:
//	Соединение	- HTTPСоединение	- Соединение с HTTP сервером.
//
Процедура ЗакрытьСоединениеСElasticSearch(Соединение)Экспорт 
	
	Соединение = Неопределено;
	
КонецПроцедуры

//// Работа с соединениями


#КонецОбласти
