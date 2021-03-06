﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Логирование"
//
// 
// 
////////////////////////////////////////////////////////////////////////////////



#Область ОбработчикиСобытийФормы


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	//Получение значений основного отбора	
	СтруктураСлужебныхПолейЛога = ЛогированиеПовторногоИспользования.СтруктураСлужебныхПолейЛога();
	Отбор_host	= СтруктураСлужебныхПолейЛога.host;
	Отбор_app	= СтруктураСлужебныхПолейЛога._app;
	Отбор_node	= СтруктураСлужебныхПолейЛога._node;
	Отбор_branch= СтруктураСлужебныхПолейЛога._branch;
	
	//Уровни лога
	СтруктураУровнейЛога = ЛогированиеПовторногоИспользования.СтруктураУровнейЛога();
	Элементы.Отбор_level.СписокВыбора.Добавить(0, "Все");
	Для Каждого КлючИЗначение Из СтруктураУровнейЛога Цикл 
		Элементы.Отбор_level.СписокВыбора.Добавить(КлючИЗначение.Значение, КлючИЗначение.Ключ);
	КонецЦикла;
	Отбор_level = 0;
	
	Отбор_КоличествоЗаписей = 100;
	
КонецПроцедуры


#КонецОбласти



#Область ОбработчикиСобытийЭлементовШапкиФормы
//Код процедур и функций
#КонецОбласти



#Область ОбработчикиСобытийЭлементовТаблицыФормы_ИмяТаблицы



#КонецОбласти



#Область ОбработчикиКомандФормы


&НаСервере
Процедура ОбновитьЛогиНаСервере()
	
	ТекстОшибки	= "";
	Отказ		= "";
	
	ОтветСостояниеКластера = ПолучитьЛогиНаСервере();
	
	тзЛоги.Очистить();
	
	//Добираемся до логов
	Если Не ОтветСостояниеКластера.Результат Тогда
		Сообщить(ОтветСостояниеКластера.ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	СвойстваЛогов = ОтветСостояниеКластера.РезультатВыполнения["hits"];
	Если СвойстваЛогов = Неопределено Тогда 
		Сообщить("Свойства логов ""hits"" не найдена!");
		Возврат;
	КонецЕсли;
	
	МассивЛогов = СвойстваЛогов["hits"];
	
	Для Каждого СоответствиеЛога Из МассивЛогов Цикл 
		нСтрока = тзЛоги.Добавить();
		
		ГУИДЛога = СоответствиеЛога["_id"];
		СоответствиеПолейЛога = СоответствиеЛога["_source"];
		
		Для Каждого ПолеЛога Из СоответствиеПолейЛога Цикл 
			нСтрока[ПолеЛога.Ключ] = ПолеЛога.Значение;
		КонецЦикла;
			
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьЛогиНаСервере(ТекстОшибки = "", Отказ = Ложь)
	
	СтруктураПолейТочногоПоиска		= Новый Структура();
	СтруктураПолейПоискаВхождений	= Новый Структура();
	СтруктураСортировки				= Новый Структура();
	
	//Отборы
	Если ЗначениеЗаполнено(Отбор_host) Тогда 
		СтруктураПолейТочногоПоиска.Вставить("host", Отбор_host);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Отбор_app) Тогда 
		СтруктураПолейТочногоПоиска.Вставить("_app", Отбор_app);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Отбор_node) Тогда 
		СтруктураПолейТочногоПоиска.Вставить("_node", Отбор_node);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Отбор_level) Тогда 
		СтруктураПолейТочногоПоиска.Вставить("_level", Отбор_level);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Отбор_branch) Тогда 
		СтруктураПолейТочногоПоиска.Вставить("_branch", Отбор_branch);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПОтбор_user) Тогда 
		СтруктураПолейТочногоПоиска.Вставить("_user", ПОтбор_user);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПОтбор_session) Тогда 
		СтруктураПолейТочногоПоиска.Вставить("_session", ПОтбор_session);
	КонецЕсли;
	
	
	//Сортировка
	СтруктураСортировки.Вставить("timestamp", "desc");
	СтруктураПоискаЛогов = ЛогированиеКлиентСервер.КонструкторСтруктурыПоискаЛогов(СтруктураПолейТочногоПоиска, СтруктураПолейПоискаВхождений, СтруктураСортировки, Отбор_КоличествоЗаписей);
	
	Возврат ПрочитатьЛоги(СтруктураПоискаЛогов, ТекстОшибки, Отказ);
	
КонецФункции

&НаКлиенте
Процедура ОбновитьЛоги(Команда)
	ОбновитьЛогиНаСервере();
КонецПроцедуры



#КонецОбласти



#Область СлужебныеПроцедурыИФункции




#КонецОбласти