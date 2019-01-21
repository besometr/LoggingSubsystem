﻿
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Логирование"
//
// 
// 
////////////////////////////////////////////////////////////////////////////////



#Область ОбработчикиСобытийФормы


&НаСервере
Процедура ПриЗагрузкеВариантаНаСервере(Настройки)
	
	ИзменениеВидимостиКолонокРезультата(Настройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗакрытиеФормыВарианта" Тогда 
		ИзменениеВидимостиКолонокРезультата(Параметр);
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти



#Область ОбработчикиСобытийЭлементовТаблицыФормы_Результат


#КонецОбласти



#Область ОбработчикиКомандФормы


#КонецОбласти



#Область СлужебныеПроцедурыИФункции


&НаСервере
Процедура ИзменениеВидимостиКолонокРезультата(Настройки)
		
	//Поля
	Для Каждого мВыбранноеПоле Из Настройки.Выбор.Элементы Цикл 
		Элементы["тзРезультат" + Строка(мВыбранноеПоле.Поле)].Видимость = мВыбранноеПоле.Использование;		
	КонецЦикла;
	
КонецПроцедуры


#КонецОбласти




