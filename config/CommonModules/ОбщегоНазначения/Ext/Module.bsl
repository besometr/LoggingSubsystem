﻿////////////////////////////////////////////////////////////////////////////////
// Дополнительные процедуры и функции, необходимые для работы подсистемы "Общие методы объектов".
// Подразумевается наличие этих методов в конфигурации.
// 
// 
////////////////////////////////////////////////////////////////////////////////



#Область ПрограммныйИнтерфейс


// КонструкторСтруктурыПараметровПодключения
// Формирует структуры параметров подключения ИБ на основе строки подключения.
//	
// Возвращаемое значение:
//	Структура	- Параметры подключения к ИБ.
//		* Тип		- Строка - Файл / Сервер.
//		* Сервер	- Строка - Наименование Сервера или путь к файловой ИБ.
//		* База		- Строка - Наименование ИБ на сервере.
//		* Строка	- Строка - Строка соединения с информационной базой.
//
Функция КонструкторСтруктурыПараметровПодключения()Экспорт 
	
	Структура = Новый Структура("Тип, Сервер, База, Строка");

    СтрокаСоединения = СтрокаСоединенияИнформационнойБазы();
    Структура.Строка = СтрокаСоединения;

    СтрокаСоединения = СтрЗаменить(СтрокаСоединения, ";", Символы.ПС);

    Стр1 = СтрПолучитьСтроку(СтрокаСоединения, 1);
    Стр2 = СтрПолучитьСтроку(СтрокаСоединения, 2);

    Если Лев(Стр1, 4) = "Srvr" Тогда
        Структура.Тип = "Сервер";
        Структура.Сервер = Сред(Стр1, 7, СтрДлина(Стр1) - 7);
        Структура.База = Сред(СтрПолучитьСтроку(СтрокаСоединения, 2), 6, СтрДлина(Стр2) - 6);
    Иначе
        Структура.Тип = "Файл";
        Структура.Сервер = Сред(Стр1, 6, СтрДлина(Стр1) - 6);
    КонецЕсли;    

	Возврат Новый ФиксированнаяСтруктура(Структура);   
	
КонецФункции

// ДополнитьСтруктуру
// Добавляет свойства и их значения из структуры источника в структуру приемника.
//
// Параметры:
//	СтруктураПриемник	- Структура - Целевая структура, которая будет дополнена свойствами и значениями структуры источника.
//	СтруктураИсточник	- Структура - Свойства и значения будут скопированы в структуру приемник.
//
Процедура ДополнитьСтруктуру(СтруктураПриемник, СтруктураИсточник) Экспорт
	
	Для Каждого КлючИЗначение Из СтруктураИсточник Цикл
		СтруктураПриемник.Вставить(КлючИЗначение.Ключ, СкопироватьРекурсивно(КлючИЗначение.Значение));
	КонецЦикла;
		
КонецПроцедуры

//СкопироватьРекурсивно
// Создает копию экземпляра указанного объекта.
// Функцию нельзя использовать для объектных типов (СправочникОбъект, ДокументОбъект и т.п.).
//
// Параметры:
//	Источник	- Произвольный - объект, который необходимо скопировать.
//
// Возвращаемое значение:
//	Произвольный	- копия объекта, переданного в параметре Источник.
//
Функция СкопироватьРекурсивно(Источник) Экспорт
	
	Перем Приемник;
	
	ТипИсточника = ТипЗнч(Источник);
	Если ТипИсточника = Тип("Структура") Тогда
		Приемник = СкопироватьСтруктуру(Источник);
	ИначеЕсли ТипИсточника = Тип("Соответствие") Тогда
		Приемник = СкопироватьСоответствие(Источник);
	ИначеЕсли ТипИсточника = Тип("Массив") Тогда
		Приемник = СкопироватьМассив(Источник);
	ИначеЕсли ТипИсточника = Тип("СписокЗначений") Тогда
		Приемник = СкопироватьСписокЗначений(Источник);
		#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		ИначеЕсли ТипИсточника = Тип("ТаблицаЗначений") Тогда
			Приемник = Источник.Скопировать();
		#КонецЕсли
	Иначе
		Приемник = Источник;
	КонецЕсли;
	
	Возврат Приемник;
	
КонецФункции

// СкопироватьСтруктуру
// Создает копию значения типа Структура.
//
// Параметры:
//	СтруктураИсточник	- Структура - копируемая структура.
// 
// Возвращаемое значение:
//	Структура	- копия исходной структуры.
//
Функция СкопироватьСтруктуру(СтруктураИсточник) Экспорт
	
	СтруктураРезультат = Новый Структура;
	
	Для Каждого КлючИЗначение Из СтруктураИсточник Цикл
		СтруктураРезультат.Вставить(КлючИЗначение.Ключ, СкопироватьРекурсивно(КлючИЗначение.Значение));
	КонецЦикла;
	
	Возврат СтруктураРезультат;
	
КонецФункции

// СкопироватьСоответствие
// Создает копию значения типа Соответствие.
//
// Параметры:
//	СоответствиеИсточник	- Соответствие - соответствие, копию которого необходимо получить.
// 
// Возвращаемое значение:
//	Соответствие	- копия исходного соответствия.
//
Функция СкопироватьСоответствие(СоответствиеИсточник) Экспорт
	
	СоответствиеРезультат = Новый Соответствие;
	
	Для Каждого КлючИЗначение Из СоответствиеИсточник Цикл
		СоответствиеРезультат.Вставить(КлючИЗначение.Ключ, СкопироватьРекурсивно(КлючИЗначение.Значение));
	КонецЦикла;
	
	Возврат СоответствиеРезультат;

КонецФункции

// СкопироватьМассив
// Создает копию значения типа Массив.
//
// Параметры:
//	МассивИсточник	- Массив - массив, копию которого необходимо получить.
// 
// Возвращаемое значение:
//	Массив	- копия исходного массива.
//
Функция СкопироватьМассив(МассивИсточник) Экспорт
	
	МассивРезультат = Новый Массив;
	
	Для Каждого Элемент Из МассивИсточник Цикл
		МассивРезультат.Добавить(СкопироватьРекурсивно(Элемент));
	КонецЦикла;
	
	Возврат МассивРезультат;
	
КонецФункции

// СкопироватьСписокЗначений
// Создает копию значения типа СписокЗначений.
//
// Параметры:
//	СписокИсточник	- СписокЗначений - список значений, копию которого необходимо получить.
// 
// Возвращаемое значение:
//	СписокЗначений	- копия исходного списка значений.
//
Функция СкопироватьСписокЗначений(СписокИсточник) Экспорт
	
	СписокРезультат = Новый СписокЗначений;
	
	Для Каждого ЭлементСписка Из СписокИсточник Цикл
		СписокРезультат.Добавить(
			СкопироватьРекурсивно(ЭлементСписка.Значение), 
			ЭлементСписка.Представление, 
			ЭлементСписка.Пометка, 
			ЭлементСписка.Картинка);
	КонецЦикла;
	
	Возврат СписокРезультат;
	
КонецФункции


#КонецОбласти



#Область СлужебныйПрограммныйИнтерфейс


Функция ЭтоЧисло(Знач Стр) Экспорт
	
	Стр = СокрЛП(Стр);
	
	Для к = 1 По СтрДлина(Стр) Цикл
		Если Найти("0123456789", Сред(Стр, к, 1)) = 0 Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;

	Возврат Истина;

КонецФункции


#КонецОбласти



#Область СлужебныеПроцедурыИФункции

#КонецОбласти
