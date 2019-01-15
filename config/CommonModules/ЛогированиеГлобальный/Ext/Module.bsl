﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Логирование"
//
// Глобальный модуль.
// Содержит точки входа для работы с логами.
////////////////////////////////////////////////////////////////////////////////



#Область ПрограммныйИнтерфейс


// ЗаписатьЛог
// Единая точка входа для функций записи логов.
// Выполняет попытку записи лога в базу данных.
//
// Параметры:
//	СтруктураПользовательскихПолей	- ФиксированнаяСтруктура	- Коллекция пользовательских полей лога.
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
//	ТекстОшибки						- Строка	- Содержит описание ошибки, в случае возникновения оной.
//	Отказ							- Булево	- Признак возникновения ошибки выполнения.
//
// Возвращаемое значение:
//	Структура				- Результат выполнения HTTP запроса 
//		* Результат				- Булево		- Флаг успешности выполнения запроса.
//		* КодСостояния			- Число			- Код состояния выполнения запроса, возвращенный сервером.
//		* РезультатВыполнения	- Соответствие	- Сериализованный в Соответствие ответ сервера.
//								- Неопределено	- В случае возникновения ошибки.	
//		* ТекстОшибки			- Строка		- Представление ошибки выполнения запроса.
//
Функция ЗаписатьЛог(СтруктураПользовательскихПолей, ТекстОшибки = "", Отказ = Ложь)Экспорт 
	
	СтруктураЛога = ЛогированиеКлиентСервер.КонструкторСтруктурыЛога(СтруктураПользовательскихПолей);
	
	Возврат ЛогированиеВызовСервера.ВыполнитьЗаписьЛога(СтруктураЛога, ТекстОшибки, Отказ);
	
КонецФункции

// ПрочитатьЛоги
// Единая точка входа для поиска логов.
// Осуществляет поиск в базе данных по переданным критериям.
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
Функция ПрочитатьЛоги(СтруктураПоискаЛогов, ТекстОшибки = "", Отказ = Ложь)Экспорт 
			
	Возврат ЛогированиеВызовСервера.ВыполнитьПоискЛогов(СтруктураПоискаЛогов, ТекстОшибки, Отказ);
	
КонецФункции


#КонецОбласти



#Область СлужебныйПрограммныйИнтерфейс

#КонецОбласти



#Область СлужебныеПроцедурыИФункции

#КонецОбласти
