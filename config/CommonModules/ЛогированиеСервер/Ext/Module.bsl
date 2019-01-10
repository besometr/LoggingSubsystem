﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Логирование"
//
// Глобальный модуль.
// Содержит точки входа для работы с логами.
////////////////////////////////////////////////////////////////////////////////



#Область ПрограммныйИнтерфейс


Функция ВыполнитьЗаписьЛогаСервер(СтруктураЛога, ТекстОшибки = "", Отказ = Ложь)Экспорт 
	
	//Получение параметров подключения к ELK
	СтруктураПараметровПодключения = ПараметрыСеанса.ПараметровПодключенияКELK;
	
	//Получение строки данных в JSON
	ДанныеЛогаВJSON 			= СериализоватьСтруктуруВВJSON(СтруктураЛога, ТекстОшибки, Отказ);
	
	//Получение текста запроса на добавление лога в ELK
	АдресРесурса				= СформироватьАдресРесурса_ДобавлениеЛога(СтруктураПараметровПодключения.Индекс, СтруктураПараметровПодключения.Тип);
	
	//Создание запроса на добавление лога в ELK
	HTTPЗапрос					= КонструкторHTTPЗапросаELK(АдресРесурса, ДанныеЛогаВJSON);
	
	//Отправка запроса в ELK
	СтруктураОтвета				= ЗапросPostELK(СтруктураПараметровПодключения, HTTPЗапрос, ТекстОшибки, Отказ);
	
	Возврат СтруктураОтвета;
КонецФункции

Функция ВыполнитьПоискЛоговСервер(СтруктураПоискаЛогов, ТекстОшибки = "", Отказ = Ложь)Экспорт 
	
	//Получение параметров подключения к ELK
	СтруктураПараметровПодключения = ПараметрыСеанса.ПараметровПодключенияКELK;
	
	//Получение строки данных в JSON
	ДанныеПоискаЛогаВJSON 		= СериализоватьСтруктуруВВJSON(СтруктураПоискаЛогов, ТекстОшибки, Отказ);
	
	//Получение текста запроса на добавление лога в ELK
	АдресРесурса				= СформироватьАдресРесурса_ПоискЛогов(СтруктураПараметровПодключения.Индекс, СтруктураПараметровПодключения.Тип);
	
	//Создание запроса на добавление лога в ELK
	HTTPЗапрос					= КонструкторHTTPЗапросаELK(АдресРесурса, ДанныеПоискаЛогаВJSON);
	
	//Отправка запроса в ELK
	СтруктураОтвета				= ЗапросPostELK(СтруктураПараметровПодключения, HTTPЗапрос, ТекстОшибки, Отказ);
	
	Возврат СтруктураОтвета;
КонецФункции


Функция ВыполнитьПолучениеСостоянияКластераСервер(ТекстОшибки = "", Отказ = Ложь)Экспорт 
	
	//Получение параметров подключения к ELK
	СтруктураПараметровПодключения = ПараметрыСеанса.ПараметровПодключенияКELK;
	
	//Получение строки данных в JSON
	ДанныеЛогаВJSON 			= "";
	
	//Получение текста запроса на добавление лога в ELK
	АдресРесурса				= СформироватьАдресРесурса_СостояниеКластера();
	
	//Создание запроса на добавление лога в ELK
	HTTPЗапрос					= КонструкторHTTPЗапросаELK(АдресРесурса, ДанныеЛогаВJSON);
	
	//Отправка запроса в ELK
	СтруктураОтвета				= ЗапросGetELK(СтруктураПараметровПодключения, HTTPЗапрос, ТекстОшибки, Отказ);
	
	Возврат СтруктураОтвета;
КонецФункции	


Функция ВыполнитьПолучениеМаппингаИндексовСервер(Индекс = "", ТекстОшибки = "", Отказ = Ложь)Экспорт 
	
	//Получение параметров подключения к ELK
	СтруктураПараметровПодключения = ПараметрыСеанса.ПараметровПодключенияКELK;
	
	//Получение строки данных в JSON
	ДанныеЛогаВJSON 			= "";
	
	//Получение текста запроса на добавление лога в ELK
	АдресРесурса				= СформироватьАдресРесурса_МаппингИндексов(Индекс);
	
	//Создание запроса на добавление лога в ELK
	HTTPЗапрос					= КонструкторHTTPЗапросаELK(АдресРесурса, ДанныеЛогаВJSON);
	
	//Отправка запроса в ELK
	СтруктураОтвета				= ЗапросGetELK(СтруктураПараметровПодключения, HTTPЗапрос, ТекстОшибки, Отказ);
	
	Возврат СтруктураОтвета;
КонецФункции




#КонецОбласти



#Область СлужебныйПрограммныйИнтерфейс


Функция СериализоватьСтруктуруВВJSON(СтруктураЛога, ТекстОшибки = "", Отказ = Ложь)Экспорт 
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	Попытка
		ЗаписатьJSON(ЗаписьJSON, СтруктураЛога);
		СтрокаJSON = ЗаписьJSON.Закрыть();
	Исключение
		Отказ		= Истина;
		ТекстОшибки = "Не удалось сформировать сообщение JSON: " + ОписаниеОшибки();
		СтрокаJSON = "";
	КонецПопытки;
	
	Возврат СтрокаJSON;
	
КонецФункции


#КонецОбласти



#Область СлужебныеПроцедурыИФункции

// Генерация Адресов запросов

Функция СформироватьАдресРесурса_ДобавлениеЛога(Индекс, Тип)
	
	//Адрес запроса
	СтрокаАдресаЗапроса = "/" + Индекс + "/" + Тип + "/"; // тут был свой ГУИД
	//Если необходимо обновить имеющийся документ, дополним команду
	//СтрокаЗапроса = ?(Обновлять = Истина, СтрокаЗапроса + "/_update", СтрокаЗапроса);
	
	
	Возврат СтрокаАдресаЗапроса;
	
КонецФункции

Функция СформироватьАдресРесурса_ПоискЛогов(Индекс, Тип)
	
	//Адрес запроса
	СтрокаАдресаЗапроса = "/" + Индекс + "/" + Тип + "/_search";
	
	Возврат СтрокаАдресаЗапроса;
	
КонецФункции

Функция СформироватьАдресРесурса_СостояниеКластера()
	
	//Адрес запроса
	СтрокаАдресаЗапроса = "/_cluster/health?level=indices";
	
	Возврат СтрокаАдресаЗапроса;
	
КонецФункции

Функция СформироватьАдресРесурса_МаппингИндексов(Индекс = "")
	
	//Адрес запроса
	
	Если ЗначениеЗаполнено(Индекс) Тогда 
		//По индексу
		СтрокаАдресаЗапроса = "/" + Индекс + "/_mapping?pretty=true";
	Иначе
		//По всем
		СтрокаАдресаЗапроса = "/_mapping?pretty=true";
	КонецЕсли;
	
	Возврат СтрокаАдресаЗапроса;
	
КонецФункции

//// Генерация Адресов запросов



Функция КонструкторHTTPЗапросаELK(АдресРесурса, ДанныеЛогаВJSON)
	
	Запрос = Новый HTTPЗапрос(АдресРесурса);
	Запрос.Заголовки.Вставить("Content-Type", "application/json");
	//необходимо убрать BOM символ. Такой вариант самый простой.
	Запрос.УстановитьТелоИзСтроки(ДанныеЛогаВJSON, "UTF8", ИспользованиеByteOrderMark.НеИспользовать);
	
	Возврат Запрос;
	
КонецФункции


Функция ЗапросPostELK(СтруктураПараметровПодключения, HTTPЗапрос, ТекстОшибки = "", Отказ = Ложь) 
	
	//Установка соединения
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

Функция ЗапросGetELK(СтруктураПараметровПодключения, HTTPЗапрос, ТекстОшибки = "", Отказ = Ложь) 
	
	ОтветСервера	= Неопределено;
	
	//Установка соединения
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
		ЧтениеJSONОтвета.УстановитьСтроку(ОтветСервера.ПолучитьТелоКакСтроку("UTF8"));
		//TODO Разобраться с преобразованием даты в поле timestamp (Для запроса структуры полей там лежит не дата а описание поля)
		//РезультатВыполнения = ПрочитатьJSON(ЧтениеJSONОтвета, Истина, "timestamp");
		РезультатВыполнения = ПрочитатьJSON(ЧтениеJSONОтвета, Истина);
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



//Работа с соединениями

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

Процедура ЗакрытьСоединениеСElasticSearch(Соединение)Экспорт 
	
	Соединение = Неопределено;
	
КонецПроцедуры

////Работа с соединениями


Функция СоответствиеКодовОшибкиHTTP()
	
	
	
КонецФункции

#КонецОбласти
