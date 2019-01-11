﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Логирование"
//
// 
// 
////////////////////////////////////////////////////////////////////////////////



#Область ПрограммныйИнтерфейс


// СтруктураЛогаGELF
// Повторного использования. Генерация структуры служебных полей формата GELF.
//
// Возвращаемое значение:
//	Структура	- Уровни лога.
//		* version	- Строка - Версия используемого формата GELF.
//
Функция СтруктураЛогаGELF()Экспорт
	Возврат ЛогированиеПереопределяемый.КонструкторСтруктурыЛогаGELF();
КонецФункции

// СтруктураУровнейЛога
// Повторного использования. Генерация структуры возможных уровней лога и их наименований.
//
// Возвращаемое значение:
//	Структура	- Уровни лога.
//		* ALL	- Число - Общее. 
//		* FATAL - Число - Критическая ошибка.
//		* ERROR - Число - Ошибка.
//		* WARN	- Число - Предупреждение.
//		* TRACE - Число - Трассировка.
//		* INFO	- Число - Информация.
//		* DEBUG - Число - Отладка.
//
Функция СтруктураУровнейЛога() Экспорт
	Возврат ЛогированиеПереопределяемый.КонструкторСтруктурыУровнейЛога();	
КонецФункции

// СтруктураСлужебныхПолейЛога
// Повторного использования. Генерация структуры служебных полей лога для Информационной базы.
//
// Возвращаемое значение:
//	Структура	- Служебные поля лога.
//		* host		- Строка - Сервер.
//		* app		- Строка - Имя приложения.
//		* node		- Строка - Экземпляр ИБ (Применительно к СПО "Пегас" - Узел обмена)
//		* branch	- Строка - Структурная единица ИБ (Применительно к СПО "Пегас" - Филиал ИБ).
//
Функция СтруктураСлужебныхПолейЛога() Экспорт
	Возврат ЛогированиеКлиентСервер.КонструкторСтруктурыСлужебныхПолейЛога();
КонецФункции

// СтруктураСеансовыхПолейЛога
// Повторного использования. Генерация структуры сеансовых данных пользователя.
//
// Возвращаемое значение:
//	Структура	- Сеансовые данные.
//		* ИмяПользователя	- Строка - Полное имя пользователя ИБ.
//		* НомерСеанса		- Строка - Номер сеанса.
//
Функция СтруктураСеансовыхПолейЛога()Экспорт 
	Возврат ЛогированиеКлиентСервер.КонструкторСтруктурыСеансовыхПолейЛога();	
КонецФункции


#КонецОбласти



#Область СлужебныйПрограммныйИнтерфейс



#КонецОбласти



#Область СлужебныеПроцедурыИФункции

#КонецОбласти





