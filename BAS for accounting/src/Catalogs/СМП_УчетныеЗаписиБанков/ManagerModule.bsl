#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Загрузка данных с банка.
//
// Параметры:
//   пСтруктураПараметров - структура - настройки для получения данных.
//   пУчетнаяЗаписьБанка - СправочникСсылка.СМП_УчетныеЗаписиБанков - Учетная запись дял получения данных.
//
Процедура Загрузить(пСтруктураПараметров, пУчетнаяЗаписьБанка, ЭтоРеглЗадание = Ложь) Экспорт
	
	сПараметры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(пУчетнаяЗаписьБанка, "Банк, ИД, Токен");
	
	Если сПараметры.Банк = Перечисления.СМП_ПоддерживаемыеИнтеграцииСБанками.ПриватБанк Тогда
		МодульИнтеграцииСБанкомПриватБанк = ОбщегоНазначения.ОбщийМодуль("СМП_РаботаСБанкамиПриватБанкAPIСервер");
		МодульИнтеграцииСБанкомПриватБанк.Прочитать(пСтруктураПараметров, сПараметры.ИД, сПараметры.Токен, ЭтоРеглЗадание);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли