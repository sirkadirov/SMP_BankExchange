#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если СМП_РаботаСБанкамиСервер.ФункционалБанкаПодключен(Банк, "ПриватБанк") Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ПодключаемаяОбработка");
		
	ИначеЕсли СМП_РаботаСБанкамиСервер.ФункционалБанкаПодключен(Банк, "МОНОБанк") Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ПодключаемаяОбработка");
		МассивНепроверяемыхРеквизитов.Добавить("ИД");
		
	ИначеЕсли СМП_РаботаСБанкамиСервер.ФункционалБанкаПодключен(Банк, "ПУМБ") Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ПодключаемаяОбработка");
		МассивНепроверяемыхРеквизитов.Добавить("ИД");
		МассивНепроверяемыхРеквизитов.Добавить("Токен");
		
		
	ИначеЕсли СМП_РаботаСБанкамиСервер.ФункционалБанкаПодключен(Банк, "ПодключаемаяОбработка") Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ИД");
		МассивНепроверяемыхРеквизитов.Добавить("Токен");
		
	КонецЕсли;
	
	Если Банк <> Перечисления.СМП_ПоддерживаемыеИнтеграцииСБанками.ПУМБ Тогда
	
		МассивНепроверяемыхРеквизитов.Добавить("Username");
		МассивНепроверяемыхРеквизитов.Добавить("password");
		МассивНепроверяемыхРеквизитов.Добавить("client_id");
		МассивНепроверяемыхРеквизитов.Добавить("client_secret");
	
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

Процедура ПриКопировании(ОбъектКопирования)
	
	ПодключаемаяОбработка = Неопределено;
	ИД = "";
	Токен = "";
	ГруппаДоступаДляНовыхКонтрагентов = Неопределено;
	СоздатьНовогоКонтрагентаПриЗагрузкеВыписки = Ложь;
	ИспользоватьРегламентныеЗадания = Ложь;
	ИдентификаторРегламентногоЗадания = Неопределено;
	АдресДляWebHook = "";
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли