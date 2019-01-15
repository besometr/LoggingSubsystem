﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Логирование"
//
// 
// 
////////////////////////////////////////////////////////////////////////////////



#Область ОбработчикиСобытийФормы


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьДанныеИндексовНаСервере();
КонецПроцедуры


#КонецОбласти



#Область ОбработчикиСобытийЭлементовШапкиФормы
//Код процедур и функций
#КонецОбласти



#Область ОбработчикиСобытийЭлементовТаблицыФормы_дзСвойстваИндексов

&НаКлиенте
Процедура дзСвойстваИндексовПриАктивизацииСтроки(Элемент)
	
	Если Не Элемент.ТекущиеДанные = Неопределено
		И ЗначениеЗаполнено(Элемент.ТекущиеДанные.Индекс)
		И ЗначениеЗаполнено(Элемент.ТекущиеДанные.Тип) Тогда 
		Элементы.дзСвойстваИндексовУстановитьИндексИТипПоУмолчанию.Доступность = Истина;
	Иначе 
	    Элементы.дзСвойстваИндексовУстановитьИндексИТипПоУмолчанию.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура УстановитьИндексИТипПоУмолчанию(Команда)
	
	ТекущиеДанные = Элементы.ДеревоСвойствИндексов.ТекущиеДанные;
	
	Если Не ТекущиеДанные = Неопределено
		И ЗначениеЗаполнено(ТекущиеДанные.Индекс)
		И ЗначениеЗаполнено(ТекущиеДанные.Тип) Тогда 
		
		Индекс	= ТекущиеДанные.Индекс;
		Тип		= ТекущиеДанные.Тип;
	
	КонецЕсли;
	
	СохранитьНастройкиПодключенияНаСервере();
	
КонецПроцедуры


#КонецОбласти



#Область ОбработчикиКомандФормы


&НаКлиенте
Процедура ОбновитьДанныеИндексов(Команда)
	ОбновитьДанныеИндексовНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеИндексовНаСервере()

	//
	ЗаполнитьДанныеФормыПоУмолчанию();
	
	//Состояние кластера
	ОтветСостояниеКластера = ЛогированиеСервер.ВыполнитьПолучениеСостоянияКластераСервер();
	Если Не (ТипЗнч(ОтветСостояниеКластера) = Тип("ФиксированнаяСтруктура") И ТипЗнч(ОтветСостояниеКластера.РезультатВыполнения) = Тип("Соответствие")) Тогда 
		Сообщить("Не удалось получить состояние кластера по причине: 
					| " + ОтветСостояниеКластера.ТекстОшибки);
		Возврат
	КонецЕсли;
	//
	
	//Свойства индексов
	ОтветСвойстваИндексов = ЛогированиеСервер.ВыполнитьПолучениеМаппингаИндексовСервер();	
	Если Не (ТипЗнч(ОтветСвойстваИндексов) = Тип("ФиксированнаяСтруктура") И ТипЗнч(ОтветСвойстваИндексов.РезультатВыполнения) = Тип("Соответствие")) Тогда 
		Сообщить("Не удалось получить состояние кластера по причине: 
					| " + ОтветСвойстваИндексов.ТекстОшибки);
		Возврат
	КонецЕсли;
	//
	
	//Заполнение
	СостояниеКластера	= ОтветСостояниеКластера.РезультатВыполнения;
	СвойстваИндексов	= ОтветСвойстваИндексов.РезультатВыполнения;
	ЗаполнитьДанныеФормыНаОсновеРезультатаЗапрос(СостояниеКластера, СвойстваИндексов);
	//
	
КонецПроцедуры


&НаКлиенте
Процедура СохранитьНастройкиПодключения(Команда)
	СохранитьНастройкиПодключенияНаСервере();
КонецПроцедуры


&НаСервере
Процедура СохранитьНастройкиПодключенияНаСервере()
	
	Константы.ELK_Индекс.Установить(Индекс); 
	Константы.ELK_Тип.Установить(Тип);
	Константы.ELK_Сервер.Установить(Сервер);
	Константы.ELK_Порт.Установить(Порт);
	Константы.ELK_Таймаут.Установить(Таймаут);
	
	ПараметрыСеанса.ПараметровПодключенияКELK = ЛогированиеКлиентСервер.КонструкторСтруктурыПараметровПодключенияКELK();
	
КонецПроцедуры



#КонецОбласти



#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДанныеФормыПоУмолчанию()
	
	СтруктураПараметровПодключения = ПараметрыСеанса.ПараметровПодключенияКELK;
	Индекс				= СтруктураПараметровПодключения.Индекс;
	Тип					= СтруктураПараметровПодключения.Тип;
	Сервер				= СтруктураПараметровПодключения.Сервер;
	Порт				= СтруктураПараметровПодключения.Порт;
	Таймаут				= СтруктураПараметровПодключения.Таймаут;
	
	ИмяКластера = "";
	Статус		= "";
	
	ДеревоСвойствИндексов.ПолучитьЭлементы().Очистить();
КонецПроцедуры


&НаСервере
Процедура ЗаполнитьДанныеФормыНаОсновеРезультатаЗапрос(СостояниеКластера, СвойстваИндексов)
	
	ИмяКластера	= СостояниеКластера["cluster_name"];
	Статус		= СостояниеКластера["status"];
	
	//Индексы
	Индексы = ДеревоСвойствИндексов.ПолучитьЭлементы();
	Для Каждого сИндексы Из СвойстваИндексов Цикл 
		нСтрокаИдекса		= Индексы.Добавить();
		
		нСтрокаИдекса.Индекс= сИндексы.Ключ;
		
		сМаппинг			= сИндексы.Значение["mappings"];
		
		//Типы
		Типы = нСтрокаИдекса.ПолучитьЭлементы();
		Для Каждого сТипы Из сМаппинг Цикл 
			нСтрокаТипа 		= Типы.Добавить();
			
			нСтрокаТипа.Индекс	= сИндексы.Ключ;
			нСтрокаТипа.Тип 	= сТипы.Ключ;
			      			
			сСвойства = сТипы.Значение["properties"];
			//Поля
			Поля = нСтрокаТипа.ПолучитьЭлементы();
			Для Каждого сПоля Из сСвойства Цикл
				нСтрокаПоля			= Поля.Добавить();
				
				нСтрокаПоля.Индекс	= сИндексы.Ключ;
				нСтрокаПоля.Тип 	= сТипы.Ключ;
				нСтрокаПоля.Поле 	= сПоля.Ключ;
				нСтрокаПоля.ТипПоля	= сПоля.Значение["type"]
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;

КонецПроцедуры





#КонецОбласти







