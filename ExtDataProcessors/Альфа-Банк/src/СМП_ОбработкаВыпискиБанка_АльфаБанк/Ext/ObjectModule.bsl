﻿
Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке();
	
	ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка();
	ПараметрыРегистрации.Наименование = НСтр("ru='Обработка выписки банка Альфа-Банк';uk='Обробка виписки банка Альфа-Банк'");
	ПараметрыРегистрации.Информация = НСтр("ru='Обработка формата загрузки данных украинского банка Альфа-Банк';uk='Обробка формату завантаження даних українського банка Альфа-Банк'");
	ПараметрыРегистрации.Версия = "1.7";
	ПараметрыРегистрации.БезопасныйРежим = Ложь;
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

&НаСервере
Процедура Загрузить_УНФ(Элемент, ФайлЗагрузки, ТаблицаТаблицДокументов, ТаблицаКонтрагентов) Экспорт
	
	Элемент.ТаблицаКонтрагентов.ПолучитьЭлементы().Очистить();
	// Подготавливаем структуры обработки данных.
	ДокументыКИмпорту = Элемент.Объект.Загрузка.Выгрузить();
	ДокументыКИмпорту.Колонки.Добавить("КодНазПлатежа", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(1)));

	ИмпортЗагружаемые = Обработки.КлиентБанк.СформироватьСоответствиеЗагружаемых();
	ИмпортНеПустые = Неопределено;
	ИмпортНеПустыеПлатежноеПоручение = Неопределено;
	ИмпортНеПустыеПлатежноеПоручениеБюджет = Неопределено;
	РасчетныеСчетаКИмпорту = Элемент.Объект.ИмпортРасчетныеСчета.Выгрузить();
	
	Обработки.КлиентБанк.СформироватьСоответствияНеПустыхПриИмпорте(
	ИмпортНеПустые,
	ИмпортНеПустыеПлатежноеПоручение,
	ИмпортНеПустыеПлатежноеПоручениеБюджет
	);
	ТегиРасчетногоСчета = Обработки.КлиентБанк.СоздатьСоответствиеИзСтроки(
	ВРег("ДатаНачала,ДатаКонца,РасчСчетОрг,НачальныйОстаток,ВсегоПоступило,ВсегоСписано,КонечныйОстаток,КонецРасчСчет")
	);
	ТегиЗаголовка = Обработки.КлиентБанк.СоздатьСоответствиеИзСтроки(
	ВРег("ВерсияФормата,Кодировка,Отправитель,Получатель,ДатаСоздания,ВремяСоздания,ДатаНачала,ДатаКонца")
	);
	СтруктураЗаголовок = Новый Структура(
	ВРег("ВерсияФормата,Кодировка,Отправитель,Получатель,ДатаСоздания,ВремяСоздания,ДатаНачала,ДатаКонца")
	);
	Элемент.ИмпортЗаголовок = СтруктураЗаголовок;
	ИмпортПризнакОбмена = Ложь;
	НайденКонецФайла = Ложь;
	ИмпортВидыДокументов = Новый Массив;
	РасчетныеСчетаКИмпорту.Очистить();
	ДокументыКИмпорту.Очистить();
	
	ФайлTXT	= Новый ТекстовыйДокумент;
	ФайлTXT.Прочитать(ФайлЗагрузки, КодировкаТекста.ANSI); //Windows
	
	Результат = Новый Массив;
	
	Разделитель = ";";
	
	Если НЕ ФайлTXT.КоличествоСтрок() Тогда 
		Возврат;
	КонецЕсли;
	
	КонтекстФормы = Новый Структура;
	КонтекстФормы.Вставить("ИмпортТекстДляРазбора", ФайлЗагрузки);
	КонтекстФормы.Вставить("ПослеЗагрузкиВыписокВ1С", Элемент.ПослеЗагрузкиВыписокВ1С);
	КонтекстФормы.Вставить("ИскатьВСправочникеСоответствий", Элемент.ИскатьВСправочникеСоответствий);
	КонтекстФормы.Вставить("ТаблицаКонтрагентов", ТаблицаКонтрагентов);
	КонтекстФормы.Вставить("РасчетныеСчетаКИмпорту", РасчетныеСчетаКИмпорту);
	КонтекстФормы.Вставить("ДокументыКИмпорту", ДокументыКИмпорту);
	КонтекстФормы.Вставить("ТаблицаТаблицДокументов", ТаблицаТаблицДокументов);
	Если Элемент.ПослеЗагрузкиВыписокВ1С Тогда
		КонтекстФормы.Вставить("СтруктураДанныхЗагрузки", Элемент.СтруктураДанныхЗагрузки);
	КонецЕсли;
	
	ВременнаяСтрока = Элемент.ТаблицаТаблицДокументов.Добавить();
	КонтекстФормы.Вставить("ТаблицаНайденныхДокументов", ВременнаяСтрока.ТаблицаНайденныхДокументов.Выгрузить());
	Элемент.ТаблицаТаблицДокументов.Удалить(0);
	
	КонтекстФормы.Вставить("ЕстьОтборПоБанковскомуСчету", Элемент.ЕстьОтборПоБанковскомуСчету);
	КонтекстФормы.Вставить("ВыдаватьСообщенияОНеверныхРеквизитахИСекциях", Элемент.ВыдаватьСообщенияОНеверныхРеквизитахИСекциях);
	
	СтруктураОбъекта = Новый Структура;
	СтруктураОбъекта.Вставить("Организация", Элемент.Объект.Организация);
	СтруктураОбъекта.Вставить("БанковскийСчет", Элемент.Объект.БанковскийСчет);
	СтруктураОбъекта.Вставить("АвтоматическиПодставлятьДокументы", Элемент.Объект.АвтоматическиПодставлятьДокументы);
	СтруктураОбъекта.Вставить("АнализироватьИсториюВыбораЗначенийРеквизитов", Элемент.Объект.АнализироватьИсториюВыбораЗначенийРеквизитов);
	СтруктураОбъекта.Вставить("СтатьяДДСИсходящий", Элемент.Объект.СтатьяДДСИсходящий);
	СтруктураОбъекта.Вставить("СтатьяДДСВходящий", Элемент.Объект.СтатьяДДСВходящий);
	СтруктураОбъекта.Вставить("СпособЗачета", Элемент.Объект.СпособЗачета);
	
	КонтекстФормы.Вставить("Объект", СтруктураОбъекта);

	
	Для НомерСтроки = 2 По ФайлTXT.КоличествоСтрок() Цикл
		
		Результат.Очистить();
		
		ТекСтрока = ФайлTXT.ПолучитьСтроку(НомерСтроки);
		
		Строки = СтрЗаменить(ТекСтрока, Разделитель, Символы.ПС);
		Строка = "";
		Продолжение = Ложь;
		
		Для Индекс = 1 По СтрЧислоСтрок(Строки) Цикл
			
			Если Продолжение тогда
				Строка = Строка + СтрПолучитьСтроку(Строки, Индекс);
			Иначе
				Строка = СтрПолучитьСтроку(Строки, Индекс);
			КонецЕсли;
			
			Если Лев(СтрПолучитьСтроку(Строки, Индекс),1) = """" и Прав(СтрПолучитьСтроку(Строки, Индекс),1) <> """" тогда
				Продолжение = Истина;
			КонецЕсли;
						
			Если Продолжение и Прав(СтрПолучитьСтроку(Строки, Индекс),1) = """" Тогда
				Продолжение = Ложь;
			КонецЕсли;
			
			Если Не Продолжение Тогда
				Результат.Добавить(Строка);
			КонецЕсли;
			
		КонецЦикла;
		
		
		
		ЗаполнитьСтроку(ДокументыКИмпорту, Результат, ИмпортЗагружаемые); 		
		
	КонецЦикла;
	
	НомерСтроки = 0;
	
	КоличествоНеНайденныхКонтрагентов = 0;
	КоличествоНеНайденныхРСчетов = 0;
	
	ПараметрыВыделенияКолонок = Новый Структура("ВыделитьКолонкуДокумент, ВыделитьКолонкуСуммаСписано, ВыделитьКолонкуСуммаПоступило, 
	|ВыделитьКолонкуКонтрагент, ВыделитьКолонкуДоговор, ВыделитьКолонкуРСКонтрагента, ВыделитьКолонкуВидОперации", 
	Ложь, Ложь, Ложь, Ложь, Ложь, Ложь, Ложь);
	
	Для каждого СтрокаДокумента Из ДокументыКИмпорту Цикл
		Если (СтрокаДокумента.ПлательщикСчет = Элемент.Объект.БанковскийСчет.НомерСчета
			ИЛИ СтрокаДокумента.ПолучательСчет  = Элемент.Объект.БанковскийСчет.НомерСчета) 
			И ЗначениеЗаполнено(Элемент.Объект.БанковскийСчет.ВалютаДенежныхСредств)
			Тогда
			
			Элемент.БанковскийСчетНомер = Элемент.Объект.БанковскийСчет.НомерСчета;
			Элемент.БанковскийСчетВалюта = Элемент.Объект.БанковскийСчет.ВалютаДенежныхСредств;
			
			Обработки.КлиентБанк.РаспознатьДанныеВСтрокеДокумента(СтрокаДокумента, Неопределено,ПараметрыВыделенияКолонок, Элемент.Объект, ТаблицаТаблицДокументов, КонтекстФормы, Элемент.ПослеЗагрузкиВыписокВ1С);
			НомерСтроки = НомерСтроки + 1;
			СтрокаДокумента.НомерСтроки = НомерСтроки;
			
			Для каждого КолонкаИмпорта из ДокументыКИмпорту.Колонки Цикл
				Обработки.КлиентБанк.ПроверитьНаПустоеЗначениеИмпорта(СтрокаДокумента, КолонкаИмпорта.Имя, КолонкаИмпорта.Заголовок, ИмпортНеПустые);
			КонецЦикла;
			
			Если ТипЗнч(СтрокаДокумента.Контрагент)=Тип("Строка") ИЛИ
				ТипЗнч(СтрокаДокумента.СчетКонтрагента)=Тип("Строка") ИЛИ
				ТипЗнч(СтрокаДокумента.Договор)=Тип("Строка") Тогда
				
				Обработки.КлиентБанк.СписокНенайденных(СтрокаДокумента, Элемент.Объект.БанковскийСчет, ТаблицаКонтрагентов, КоличествоНеНайденныхКонтрагентов, КоличествоНеНайденныхРСчетов);
			КонецЕсли;
		Иначе
			//остальные помечаем для последующего удаления
			СтрокаДокумента.НомерСтроки = 0;
		КонецЕсли;
	КонецЦикла;
	
	//Удалим не нужные строки из таблицы
	Количество = ДокументыКИмпорту.количество()-1;
	Для й=0 по Количество Цикл
		Если ДокументыКИмпорту[Количество-й].НомерСтроки = 0 Тогда
			ДокументыКИмпорту.Удалить(Количество-й);
		КонецЕсли;
	КонецЦикла;
	
	Для каждого СтрокаДокумента Из ДокументыКИмпорту Цикл
		СтрокаДокумента.Загружать = ПустаяСтрока(СтрокаДокумента.ОписаниеОшибок);
		СтрокаДокумента.НазначениеПлатежа = СокрЛП(СтрокаДокумента.НазначениеПлатежа);
		СтрокаДокумента.НомерКартинки = ?(ПустаяСтрока(СтрокаДокумента.ОписаниеОшибок), 0, 1);
	КонецЦикла;
	
	Элемент.Объект.Загрузка.Очистить();
	Элемент.Объект.Загрузка.Загрузить(ДокументыКИмпорту);
	
	Элемент.Объект.ИмпортРасчетныеСчета.Очистить();
	Элемент.Объект.ИмпортРасчетныеСчета.Загрузить(РасчетныеСчетаКИмпорту);
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьСтроку(ДокументыДляИмпорта, СтрокаФайла, ИмпортЗагружаемые)
	
	НоваяСтрокаДокументов = ДокументыДляИмпорта.Добавить();
	
	Если СТРДлина(СокрЛП(СтрокаФайла[0])) > 10 тогда  // для Юр. лица
		
		НоваяСтрокаДокументов.Номер				= СокрЛП(СтрокаФайла[10]);
		НоваяСтрокаДокументов.Дата				= Сред(СокрЛП(СтрокаФайла[14]), 1, 2) + "." + Сред(СокрЛП(СтрокаФайла[14]), 4, 2) + "." + Сред(СокрЛП(СтрокаФайла[14]), 7, 4) + " " + СокрЛП(СтрокаФайла[13]);
		НоваяСтрокаДокументов.СуммаДокумента	= Число(СтрЗаменить(СтрЗаменить(СокрЛП(СтрокаФайла[11]),".",",")," ",""));
		НоваяСтрокаДокументов.Сумма				= СтрЗаменить(Формат(НоваяСтрокаДокументов.СуммаДокумента, "ЧРГ=&"), "&", "");
		Если СокрЛП(СтрокаФайла[2]) <> "Кредит" Тогда // исходящий
			
			ВидДокумента	= "ПлатежноеПоручение";
			НоваяСтрокаДокументов.СуммаПоступило	= 0;
			НоваяСтрокаДокументов.ДатаСписано 		= НоваяСтрокаДокументов.Дата;
			НоваяСтрокаДокументов.СуммаСписано		= НоваяСтрокаДокументов.СуммаДокумента;
			НоваяСтрокаДокументов.ПлательщикСчет	= СокрЛП(СтрокаФайла[1]);
			НоваяСтрокаДокументов.ПлательщикКПП		= СокрЛП(СтрокаФайла[16]);
			НоваяСтрокаДокументов.ПлательщикБИК		= СокрЛП(СтрокаФайла[18]);
			НоваяСтрокаДокументов.Получатель		= СокрЛП(СтрокаФайла[6]);
			НоваяСтрокаДокументов.ПолучательСчет	= СокрЛП(СтрокаФайла[4]);
			НоваяСтрокаДокументов.ПолучательКПП		= СокрЛП(СтрокаФайла[7]);
			НоваяСтрокаДокументов.ПолучательБИК		= СокрЛП(СтрокаФайла[5]);
			//НоваяСтрокаДокументов.ПолучательБанк1	= "";
		Иначе
			ВидДокумента	= "ПлатежноеТребование";
			НоваяСтрокаДокументов.СуммаПоступило	= НоваяСтрокаДокументов.СуммаДокумента;
			НоваяСтрокаДокументов.ДатаПоступило 	= НоваяСтрокаДокументов.Дата;
			НоваяСтрокаДокументов.СуммаСписано		= 0;
			НоваяСтрокаДокументов.ПолучательСчет	= СокрЛП(СтрокаФайла[1]);
			НоваяСтрокаДокументов.ПолучательКПП		= СокрЛП(СтрокаФайла[16]);
			НоваяСтрокаДокументов.ПолучательБИК		= СокрЛП(СтрокаФайла[18]);
			НоваяСтрокаДокументов.Плательщик		= СокрЛП(СтрокаФайла[6]);
			НоваяСтрокаДокументов.ПлательщикСчет	= СокрЛП(СтрокаФайла[4]);
			НоваяСтрокаДокументов.ПлательщикКПП		= СокрЛП(СтрокаФайла[7]);
			НоваяСтрокаДокументов.ПлательщикБИК		= СокрЛП(СтрокаФайла[5]);
			//НоваяСтрокаДокументов.ПлательщикБанк1	= "";
		КонецЕсли;
		
		НоваяСтрокаДокументов.КодВалюты				= СокрЛП(СтрокаФайла[12]);
		НоваяСтрокаДокументов.НазначениеПлатежа		= СокрЛП(СтрокаФайла[8]);
		
	Иначе   // для ФОП
		
		НоваяСтрокаДокументов.Номер				= СокрЛП(СтрокаФайла[11]);
		НоваяСтрокаДокументов.Дата				= Сред(СокрЛП(СтрокаФайла[0]), 1, 2) + "." + Сред(СокрЛП(СтрокаФайла[0]), 4, 2) + "." + Сред(СокрЛП(СтрокаФайла[0]), 7, 4);
		НоваяСтрокаДокументов.СуммаДокумента	= ?(СокрЛП(СтрокаФайла[13]) <> "0",Число(СокрЛП(СтрокаФайла[13])), Число(СокрЛП(СтрокаФайла[14])));
		НоваяСтрокаДокументов.Сумма				= СтрЗаменить(Формат(НоваяСтрокаДокументов.СуммаДокумента, "ЧРГ=&"), "&", "");
		
		Если СокрЛП(СтрокаФайла[13]) <> "0" Тогда // исходящий
			
			ВидДокумента	= "ПлатежноеПоручение";
			НоваяСтрокаДокументов.СуммаПоступило	= 0;
			НоваяСтрокаДокументов.ДатаСписано 		= Дата( Сред(СокрЛП(СтрокаФайла[0]), 7, 4) + Сред(СокрЛП(СтрокаФайла[0]), 4, 2)  + Сред(СокрЛП(СтрокаФайла[0]), 1, 2));
			НоваяСтрокаДокументов.СуммаСписано		= НоваяСтрокаДокументов.СуммаДокумента;
			НоваяСтрокаДокументов.ПлательщикСчет	= СокрЛП(СтрокаФайла[4]);
			НоваяСтрокаДокументов.ПлательщикКПП		= СокрЛП(СтрокаФайла[1]);
			НоваяСтрокаДокументов.ПлательщикБИК		= СокрЛП(СтрокаФайла[3]);
			НоваяСтрокаДокументов.Получатель		= СокрЛП(СтрокаФайла[10]);
			НоваяСтрокаДокументов.ПолучательСчет	= СокрЛП(СтрокаФайла[8]);
			НоваяСтрокаДокументов.ПолучательКПП		= СокрЛП(СтрокаФайла[9]);
			НоваяСтрокаДокументов.ПолучательБИК		= СокрЛП(СтрокаФайла[6]);
			НоваяСтрокаДокументов.ПолучательБанк1	= СокрЛП(СтрокаФайла[7]);
		Иначе
			ВидДокумента	= "ПлатежноеТребование";
			НоваяСтрокаДокументов.СуммаПоступило	= НоваяСтрокаДокументов.СуммаДокумента;
			НоваяСтрокаДокументов.ДатаПоступило 	= Дата( Сред(СокрЛП(СтрокаФайла[0]), 7, 4) + Сред(СокрЛП(СтрокаФайла[0]), 4, 2)  + Сред(СокрЛП(СтрокаФайла[0]), 1, 2));
			НоваяСтрокаДокументов.СуммаСписано		= 0;
			НоваяСтрокаДокументов.ПолучательСчет	= СокрЛП(СтрокаФайла[4]);
			НоваяСтрокаДокументов.ПолучательКПП		= СокрЛП(СтрокаФайла[1]);
			НоваяСтрокаДокументов.ПолучательБИК		= СокрЛП(СтрокаФайла[3]);
			НоваяСтрокаДокументов.Плательщик		= СокрЛП(СтрокаФайла[10]);
			НоваяСтрокаДокументов.ПлательщикСчет	= СокрЛП(СтрокаФайла[8]);
			НоваяСтрокаДокументов.ПлательщикКПП		= СокрЛП(СтрокаФайла[9]);
			НоваяСтрокаДокументов.ПлательщикБИК		= СокрЛП(СтрокаФайла[6]);
			НоваяСтрокаДокументов.ПлательщикБанк1	= СокрЛП(СтрокаФайла[7]);
		КонецЕсли;
		
		НоваяСтрокаДокументов.КодВалюты				= СокрЛП(СтрокаФайла[3]);
		НоваяСтрокаДокументов.НазначениеПлатежа		= СокрЛП(СтрокаФайла[15]);
		
	КонецЕсли;
	
	
	Если ВидДокумента <> Неопределено Тогда
		НоваяСтрокаДокументов.Операция = ВидДокумента;
		
	Иначе // по умолчанию: "Платежное поручение"
		
		ВидДокумента = "ПлатежноеПоручение";
		НоваяСтрокаДокументов.Операция = ВидДокумента;
		
	КонецЕсли;	
	
	Возврат Истина;
	
КонецФункции

Функция ФорматФайла() Экспорт
	Возврат "csv";
КонецФункции