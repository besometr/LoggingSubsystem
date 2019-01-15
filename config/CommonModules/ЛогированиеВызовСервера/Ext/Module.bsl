﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Логирование"
//
// 
// 
////////////////////////////////////////////////////////////////////////////////



#Область ПрограммныйИнтерфейс


// ВыполнитьЗаписьЛога
// Переадресация записи лога в базу данных на Сервер.
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
Функция ВыполнитьЗаписьЛога(СтруктураЛога, ТекстОшибки = "", Отказ = Ложь)Экспорт 
	
	Возврат ЛогированиеСервер.ВыполнитьЗаписьЛогаСервер(СтруктураЛога, ТекстОшибки, Отказ);
		
КонецФункции

// ВыполнитьПоискЛогов
// Переадресация поиска логов в базе данных на Сервер.
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
Функция ВыполнитьПоискЛогов(СтруктураПоискаЛогов, ТекстОшибки = "", Отказ = Ложь)Экспорт 
	
	Возврат ЛогированиеСервер.ВыполнитьПоискЛоговСервер(СтруктураПоискаЛогов, ТекстОшибки, Отказ);
		
КонецФункции


#КонецОбласти



#Область СлужебныйПрограммныйИнтерфейс


// ПолучитьЗначениеКонстанту
// TODO Заменить на имеющийся аналог
Функция ПолучитьЗначениеКонстанты(Имя)Экспорт 
	
	Попытка
		ЗначениеКонстанты = Константы[Имя].Получить()
	Исключение
		ЗначениеКонстанты = Неопределено;
	КонецПопытки;
	
	Возврат ЗначениеКонстанты;
	
КонецФункции

// СтруктураПараметровПодключенияКИБ
Функция СтруктураПараметровПодключенияКИБ()Экспорт 
	Возврат ОбщегоНазначенияВызовСервера.КонструкторСтруктурыПараметровПодключения();
КонецФункции

// СинонимКонфигурации
Функция СинонимКонфигурации()Экспорт 
	Возврат Метаданные.Синоним;
КонецФункции

// ПолноеИмяТекущегоПользователяИБ
Функция ПолноеИмяТекущегоПользователяИБ()Экспорт 
	Возврат ПользователиИнформационнойБазы.ТекущийПользователь().ПолноеИмя;
КонецФункции

// НомерСеансаИнформационнойБазыСтрокой
Функция НомерСеансаИнформационнойБазыСтрокой()Экспорт 
	Возврат Формат(ПолучитьНомерСеансаИнформационнойБазы(), "ЧГ=0");
КонецФункции


#КонецОбласти



#Область СлужебныеПроцедурыИФункции


//НомерСеансаИнформационнойБазы
Функция ПолучитьНомерСеансаИнформационнойБазы() 
	Возврат НомерСеансаИнформационнойБазы();
КонецФункции


#КонецОбласти
