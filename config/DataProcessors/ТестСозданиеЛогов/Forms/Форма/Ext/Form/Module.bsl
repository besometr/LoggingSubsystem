﻿
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Логирование"
//
// 
// 
////////////////////////////////////////////////////////////////////////////////



#Область ОбработчикиСобытийФормы



&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	КороткоеСообщение	= "Тестовый лог";
	ПолноеСообщение		= "Проверка записи тестового лога из обработки ТестСозданиеЛогов";
	ДатаСобытия			= Дата(1,1,1);
	Подсистема			= "Логирование.НастройкиПодключения";
	МетаданныеОбъекта	= ЭтотОбъект.ИмяФормы;
	Метод				= "ОтправитьКастомныйЛог";
	Операция			= "Тестовая запись лога";
	ПредставлениеОбъекта= "Тестовый объект";
	ГУИДОбъекта			= Новый УникальныйИдентификатор();
	
	//Уровни лога
	СтруктураУровнейЛога = ЛогированиеПовторногоИспользования.СтруктураУровнейЛога();
	Для Каждого КлючИЗначение Из СтруктураУровнейЛога Цикл 
		Элементы.Уровень.СписокВыбора.Добавить(КлючИЗначение.Значение, КлючИЗначение.Ключ);
	КонецЦикла;
	Уровень = 1;
		
КонецПроцедуры


#КонецОбласти



#Область ОбработчикиКомандФормы


&НаСервере
Процедура СтруктураЛогаНаСервере()
	
	// Структуры пользовательских полей лога
	// Пустая
	СППЛ_Пустая = ЛогированиеКлиентСервер.КонструкторСтруктурыПользовательскихПолейЛога();
	// Несколько полей, дата по умолчанию
	СППЛ_БезДаты = ЛогированиеКлиентСервер.КонструкторСтруктурыПользовательскихПолейЛога("Все гут", "Все вообще хорошо");
	// Несколько полей, дата указана в ручную
	СППЛ_СДатой = ЛогированиеКлиентСервер.КонструкторСтруктурыПользовательскихПолейЛога("Все гут", "Все вообще хорошо", ТекущаяДатаСеанса());
	
	// Структуры лога
	// Пустая
	СЛ_Пустая = ЛогированиеКлиентСервер.КонструкторСтруктурыЛога("");
	
	// Несколько полей, дата по умолчанию
	СЛ_БезДаты = ЛогированиеКлиентСервер.КонструкторСтруктурыЛога(СППЛ_БезДаты);
	// Несколько полей, заменена относительно структуры
	СППЛ_БезДаты.ДатаСобытия = ТекущаяДатаСеанса();
	СЛ_БезДаты_СДатой = ЛогированиеКлиентСервер.КонструкторСтруктурыЛога(СППЛ_БезДаты);
	
	// Несколько полей, дата указана в ручную
	СЛ_СДатой = ЛогированиеКлиентСервер.КонструкторСтруктурыЛога(СППЛ_СДатой);
	
КонецПроцедуры

&НаКлиенте
Процедура СтруктураЛога(Команда)
	
	// Структуры пользовательских полей лога
	// Пустая
	СППЛ_Пустая = ЛогированиеКлиентСервер.КонструкторСтруктурыПользовательскихПолейЛога();
	// Несколько полей, дата по умолчанию
	СППЛ_БезДаты = ЛогированиеКлиентСервер.КонструкторСтруктурыПользовательскихПолейЛога("Все гут", "Все вообще хорошо");
	// Несколько полей, дата указана в ручную
	СППЛ_СДатой = ЛогированиеКлиентСервер.КонструкторСтруктурыПользовательскихПолейЛога("Все гут", "Все вообще хорошо", ТекущаяДатаСеансаСервер());
	
	// Структуры лога
	// Пустая
	СЛ_Пустая = ЛогированиеКлиентСервер.КонструкторСтруктурыЛога("");
	
	// Несколько полей, дата по умолчанию
	СЛ_БезДаты = ЛогированиеКлиентСервер.КонструкторСтруктурыЛога(СППЛ_БезДаты);
	// Несколько полей, заменена относительно структуры
	СППЛ_БезДаты.ДатаСобытия = ТекущаяДатаСеансаСервер();
	СЛ_БезДаты_СДатой = ЛогированиеКлиентСервер.КонструкторСтруктурыЛога(СППЛ_БезДаты);
	
	// Несколько полей, дата указана в ручную
	СЛ_СДатой = ЛогированиеКлиентСервер.КонструкторСтруктурыЛога(СППЛ_СДатой);
	
	// Теперь на сервере
	СтруктураЛогаНаСервере();
КонецПроцедуры


&НаСервере
Процедура ОтправитьТиповойЛогНаСервере()
	
	ТекстОшибки = "";
	Отказ		= Ложь;
	
	// Структуры пользовательских полей лога
	// Пустая
	СППЛ_Пустая = ЛогированиеКлиентСервер.КонструкторСтруктурыПользовательскихПолейЛога();
	ОтправитьЛогСОбработкойСервер(СППЛ_Пустая, ТекстОшибки, Отказ);
	
	// Несколько полей, дата по умолчанию
	СППЛ_БезДаты = ЛогированиеКлиентСервер.КонструкторСтруктурыПользовательскихПолейЛога("Все гут", "Все вообще хорошо");
	ОтправитьЛогСОбработкойСервер(СППЛ_БезДаты, ТекстОшибки, Отказ);
	
	// Несколько полей, дата указана в ручную
	СППЛ_СДатой = ЛогированиеКлиентСервер.КонструкторСтруктурыПользовательскихПолейЛога("Все гут", "Все вообще хорошо", ТекущаяДатаСеанса());
	ОтправитьЛогСОбработкойСервер(СППЛ_СДатой, ТекстОшибки, Отказ);
	
	// Структуры лога
	// Пустая
	СЛ_Пустая = ЛогированиеКлиентСервер.КонструкторСтруктурыЛога("");
	ОтправитьЛогСОбработкойСервер(СЛ_Пустая, ТекстОшибки, Отказ);
	
	// Несколько полей, дата по умолчанию
	СЛ_БезДаты = ЛогированиеКлиентСервер.КонструкторСтруктурыЛога(СППЛ_БезДаты);
	ОтправитьЛогСОбработкойСервер(СЛ_БезДаты, ТекстОшибки, Отказ);
	
	// Несколько полей, заменена относительно структуры
	СППЛ_БезДаты.ДатаСобытия = ТекущаяДатаСеанса();
	СЛ_БезДаты_СДатой = ЛогированиеКлиентСервер.КонструкторСтруктурыЛога(СППЛ_БезДаты);
	ОтправитьЛогСОбработкойСервер(СЛ_БезДаты_СДатой, ТекстОшибки, Отказ);
	
	// Несколько полей, дата указана в ручную
	СЛ_СДатой = ЛогированиеКлиентСервер.КонструкторСтруктурыЛога(СППЛ_СДатой);
	ОтправитьЛогСОбработкойСервер(СЛ_СДатой, ТекстОшибки, Отказ);

КонецПроцедуры

&НаКлиенте
Процедура ОтправитьТиповойЛог(Команда)
	
	ТекстОшибки = "";
	Отказ		= Ложь;
	
	// Структуры пользовательских полей лога
	// Пустая
	СППЛ_Пустая = ЛогированиеКлиентСервер.КонструкторСтруктурыПользовательскихПолейЛога();
		
	// Несколько полей, дата по умолчанию
	СППЛ_БезДаты = ЛогированиеКлиентСервер.КонструкторСтруктурыПользовательскихПолейЛога("Все гут", "Все вообще хорошо");
	ОтправитьЛогСОбработкой(СППЛ_БезДаты, ТекстОшибки, Отказ);
	
	// Несколько полей, дата указана в ручную
	СППЛ_СДатой = ЛогированиеКлиентСервер.КонструкторСтруктурыПользовательскихПолейЛога("Все гут", "Все вообще хорошо", ТекущаяДатаСеансаСервер());
	ОтправитьЛогСОбработкой(СППЛ_СДатой, ТекстОшибки, Отказ);
	
	// Структуры лога
	// Пустая
	СЛ_Пустая = ЛогированиеКлиентСервер.КонструкторСтруктурыЛога("");
	ОтправитьЛогСОбработкой(СЛ_Пустая, ТекстОшибки, Отказ);
	
	//Несколько полей, дата по умолчанию
	СЛ_БезДаты = ЛогированиеКлиентСервер.КонструкторСтруктурыЛога(СППЛ_БезДаты);
	ОтправитьЛогСОбработкой(СЛ_БезДаты, ТекстОшибки, Отказ);
	
	// Несколько полей, заменена относительно структуры
	СППЛ_БезДаты.ДатаСобытия = ТекущаяДатаСеансаСервер();
	СЛ_БезДаты_СДатой = ЛогированиеКлиентСервер.КонструкторСтруктурыЛога(СППЛ_БезДаты);
	ОтправитьЛогСОбработкой(СЛ_БезДаты_СДатой, ТекстОшибки, Отказ);
	
	// Несколько полей, дата указана в ручную
	СЛ_СДатой = ЛогированиеКлиентСервер.КонструкторСтруктурыЛога(СППЛ_СДатой);
	ОтправитьЛогСОбработкой(СЛ_СДатой, ТекстОшибки, Отказ);
	
	// Теперь на сервере
	ОтправитьТиповойЛогНаСервере();
	
КонецПроцедуры


&НаКлиенте
Процедура ОтправитьКастомныйЛог(Команда)
	
	ТекстОшибки = "";
	Отказ		= Ложь;
				
	// Несколько полей, дата по умолчанию
	СтруктураЛога = ЛогированиеКлиентСервер.КонструкторСтруктурыПользовательскихПолейЛога(КороткоеСообщение, 
																							ПолноеСообщение, 
																							ДатаСобытия,
																							Уровень, 
																							Подсистема, 
																							МетаданныеОбъекта, 
																							Метод, 
																							Операция, 
																							ПредставлениеОбъекта, 
																							ГУИДОбъекта);
	ОтправитьЛогСОбработкой(СтруктураЛога, ТекстОшибки, Отказ);
	
	ОтправитьКастомныйЛогНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОтправитьКастомныйЛогНаСервере()
	
	ТекстОшибки = "";
	Отказ		= Ложь;
				
	// Несколько полей, дата по умолчанию
	СтруктураЛога = ЛогированиеКлиентСервер.КонструкторСтруктурыПользовательскихПолейЛога(КороткоеСообщение, 
																							ПолноеСообщение, 
																							ДатаСобытия,
																							Уровень, 
																							Подсистема, 
																							МетаданныеОбъекта, 
																							Метод, 
																							Операция, 
																							ПредставлениеОбъекта, 
																							ГУИДОбъекта);
	ОтправитьЛогСОбработкойСервер(СтруктураЛога, ТекстОшибки, Отказ);
	
КонецПроцедуры


#КонецОбласти



#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ТекущаяДатаСеансаСервер()
	Возврат ТекущаяДатаСеанса();
КонецФункции

&НаКлиенте
Процедура ОтправитьЛогСОбработкой(СППЛ, ТекстОшибки, Отказ)
	
	Ответ = ЗаписатьЛог(СППЛ, ТекстОшибки, Отказ);
	Если Не Ответ.Результат = Истина Тогда 
		ЛогированиеКлиентСервер.СообщитьПользователю("Лог не записан: " + Ответ.ТекстОшибки);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОтправитьЛогСОбработкойСервер(СППЛ, ТекстОшибки, Отказ)
	
	Ответ = ЗаписатьЛог(СППЛ, ТекстОшибки, Отказ);
	Если Не Ответ.Результат = Истина Тогда 
		ЛогированиеКлиентСервер.СообщитьПользователю("Лог не записан: " + Ответ.ТекстОшибки);
	КонецЕсли;
КонецПроцедуры



#КонецОбласти
















