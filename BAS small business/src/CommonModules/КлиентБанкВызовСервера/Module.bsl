
&ИзменениеИКонтроль("ЗагрузитьНастройкиОбменаСБанком")
Процедура СМП_ЗагрузитьНастройкиОбменаСБанком(БанковскийСчет, СтруктураПрямогоОбмена)

	Настройки = ХранилищеСистемныхНастроек.Загрузить("Обработка.КлиентБанк.Форма.ОсновнаяФорма/" + ?(ЗначениеЗаполнено(БанковскийСчет), ПолучитьНавигационнуюСсылку(БанковскийСчет), "БанковскийСчетНеУказан"), "ВыгрузкаВСбербанк");

	Если Настройки <> Неопределено Тогда
		СтруктураПрямогоОбмена.Вставить("ФайлВыгрузки", Настройки.Получить("ФайлВыгрузки"));
		СтруктураПрямогоОбмена.Вставить("ФайлЗагрузки", Настройки.Получить("ФайлЗагрузки"));
		СтруктураПрямогоОбмена.Вставить("Программа", Настройки.Получить("Программа"));
		
		#Вставка
		// СМП_РаботаСБанками +++
		Обработка = СМП_ПолучитьОбработкуПротокола(БанковскийСчет);
		СтруктураПрямогоОбмена.Вставить("ОбработкаПротокола", Обработка);
		// СМП_РаботаСБанками ---
		#КонецВставки
		
		СтруктураПрямогоОбмена.Вставить("СтатьяДДСИсходящий", Настройки.Получить("СтатьяДДСИсходящий"));
		СтруктураПрямогоОбмена.Вставить("СтатьяДДСВходящий", Настройки.Получить("СтатьяДДСВходящий"));
		СтруктураПрямогоОбмена.Вставить("ПроводитьЗагружаемые", Настройки.Получить("ПроводитьЗагружаемые"));
		Если Настройки.Получить("ЗаполнятьДолгиАвтоматически") = Неопределено Тогда
			СтруктураПрямогоОбмена.Вставить("ЗаполнятьДолгиАвтоматически", Истина);
		Иначе
			СтруктураПрямогоОбмена.Вставить("ЗаполнятьДолгиАвтоматически", Настройки.Получить("ЗаполнятьДолгиАвтоматически"));
		КонецЕсли;
		СтруктураПрямогоОбмена.Вставить("Кодировка", Настройки.Получить("Кодировка"));
		Если НЕ ЗначениеЗаполнено(СтруктураПрямогоОбмена.Кодировка) Тогда
			СтруктураПрямогоОбмена.Вставить("Кодировка", "Windows");
		КонецЕсли;
		СтруктураПрямогоОбмена.Вставить("ВерсияФормата", Настройки.Получить("ВерсияФормата"));
		Если НЕ ЗначениеЗаполнено(СтруктураПрямогоОбмена.ВерсияФормата) Тогда
			СтруктураПрямогоОбмена.Вставить("ВерсияФормата", "1.02");
		КонецЕсли;
		Если Настройки.Получить("АвтоматическиПодставлятьДокументы") = Неопределено Тогда
			СтруктураПрямогоОбмена.Вставить("АвтоматическиПодставлятьДокументы", Истина);
		Иначе
			СтруктураПрямогоОбмена.Вставить("АвтоматическиПодставлятьДокументы", Настройки.Получить("АвтоматическиПодставлятьДокументы"));
		КонецЕсли;
		Если Настройки.Получить("НеУдалятьДокументыКоторыхНетВВыписке") = Неопределено Тогда
			СтруктураПрямогоОбмена.Вставить("НеУдалятьДокументыКоторыхНетВВыписке", Ложь);
		Иначе
			СтруктураПрямогоОбмена.Вставить("НеУдалятьДокументыКоторыхНетВВыписке", Настройки.Получить("НеУдалятьДокументыКоторыхНетВВыписке"));
		КонецЕсли;
		Если Настройки.Получить("АнализироватьИсториюВыбораЗначенийРеквизитов") = Неопределено Тогда
			СтруктураПрямогоОбмена.Вставить("АнализироватьИсториюВыбораЗначенийРеквизитов", Истина);
		Иначе
			СтруктураПрямогоОбмена.Вставить("АнализироватьИсториюВыбораЗначенийРеквизитов", Настройки.Получить("АнализироватьИсториюВыбораЗначенийРеквизитов"));
		КонецЕсли;
		Если Настройки.Получить("КонтролироватьБезопасностьОбменаСБанком") = Неопределено Тогда
			СтруктураПрямогоОбмена.Вставить("КонтролироватьБезопасностьОбменаСБанком", Истина);
		Иначе
			СтруктураПрямогоОбмена.Вставить("КонтролироватьБезопасностьОбменаСБанком", Настройки.Получить("КонтролироватьБезопасностьОбменаСБанком"));
		КонецЕсли;
		СтруктураПрямогоОбмена.Вставить("СпособЗачета", Настройки.Получить("СпособЗачета"));
	Иначе
		СтруктураПрямогоОбмена.Вставить("ФайлВыгрузки", "");
		СтруктураПрямогоОбмена.Вставить("ФайлЗагрузки", "");
		СтруктураПрямогоОбмена.Вставить("Программа", "");
		
		#Вставка
		// СМП_РаботаСБанками +++
		СтруктураПрямогоОбмена.Вставить("ОбработкаПротокола", Неопределено);
		// СМП_РаботаСБанками ---
		#КонецВставки
		
		СтруктураПрямогоОбмена.Вставить("СтатьяДДСИсходящий", Справочники.СтатьиДвиженияДенежныхСредств.ОплатаПоставщикам);
		СтруктураПрямогоОбмена.Вставить("СтатьяДДСВходящий", Справочники.СтатьиДвиженияДенежныхСредств.ОплатаОтПокупателей);
		СтруктураПрямогоОбмена.Вставить("ПроводитьЗагружаемые", Ложь);
		СтруктураПрямогоОбмена.Вставить("ЗаполнятьДолгиАвтоматически", Ложь); // Настройка устарела. Теперь используется значение из договора
		СтруктураПрямогоОбмена.Вставить("Кодировка", "Windows");
		СтруктураПрямогоОбмена.Вставить("ВерсияФормата", "1.02");
		СтруктураПрямогоОбмена.Вставить("АвтоматическиПодставлятьДокументы", Истина);
		СтруктураПрямогоОбмена.Вставить("НеУдалятьДокументыКоторыхНетВВыписке", Ложь);
		СтруктураПрямогоОбмена.Вставить("АнализироватьИсториюВыбораЗначенийРеквизитов", Истина);
		СтруктураПрямогоОбмена.Вставить("КонтролироватьБезопасностьОбменаСБанком", Истина);
		СтруктураПрямогоОбмена.Вставить("СпособЗачета", Неопределено);
	КонецЕсли;

КонецПроцедуры

&ИзменениеИКонтроль("ЗагрузитьНастройкиОбменаСБанкомЧерезФайлы")
Процедура СМП_ЗагрузитьНастройкиОбменаСБанкомЧерезФайлы(БанковскийСчет, ДополнительныеПараметры)

	Настройки = ХранилищеСистемныхНастроек.Загрузить("Обработка.КлиентБанк.Форма.ОсновнаяФорма/" + ?(ЗначениеЗаполнено(БанковскийСчет), ПолучитьНавигационнуюСсылку(БанковскийСчет), "БанковскийСчетНеУказан"), "ВыгрузкаВСбербанк");

	Если Настройки <> Неопределено Тогда
		ДополнительныеПараметры.Вставить("ФайлВыгрузки", Настройки.Получить("ФайлВыгрузки"));
		ДополнительныеПараметры.Вставить("ФайлЗагрузки", Настройки.Получить("ФайлЗагрузки"));
		ДополнительныеПараметры.Вставить("Программа", Настройки.Получить("Программа"));
		
		#Вставка
		// СМП_РаботаСБанками +++
		ДополнительныеПараметры.Вставить("ОбработкаПротокола", СМП_ПолучитьОбработкуПротокола(БанковскийСчет));
		// СМП_РаботаСБанками ---
		#КонецВставки
		
		ДополнительныеПараметры.Вставить("СтатьяДДСИсходящий", Настройки.Получить("СтатьяДДСИсходящий"));
		ДополнительныеПараметры.Вставить("СтатьяДДСВходящий", Настройки.Получить("СтатьяДДСВходящий"));
		ДополнительныеПараметры.Вставить("ПроводитьЗагружаемые", Настройки.Получить("ПроводитьЗагружаемые"));
		Если Настройки.Получить("ЗаполнятьДолгиАвтоматически") = Неопределено Тогда
			ДополнительныеПараметры.Вставить("ЗаполнятьДолгиАвтоматически", Истина);
		Иначе
			ДополнительныеПараметры.Вставить("ЗаполнятьДолгиАвтоматически", Настройки.Получить("ЗаполнятьДолгиАвтоматически"));
		КонецЕсли;
		ДополнительныеПараметры.Вставить("Кодировка", Настройки.Получить("Кодировка"));
		Если НЕ ЗначениеЗаполнено(ДополнительныеПараметры.Кодировка) Тогда
			ДополнительныеПараметры.Вставить("Кодировка", "Авто");
		КонецЕсли;
		ДополнительныеПараметры.Вставить("ВерсияФормата", Настройки.Получить("ВерсияФормата"));
		Если НЕ ЗначениеЗаполнено(ДополнительныеПараметры.ВерсияФормата) Тогда
			ДополнительныеПараметры.Вставить("ВерсияФормата", "1.02");
		КонецЕсли;
		Если Настройки.Получить("АвтоматическиПодставлятьДокументы") = Неопределено Тогда
			ДополнительныеПараметры.Вставить("АвтоматическиПодставлятьДокументы", Истина);
		Иначе
			ДополнительныеПараметры.Вставить("АвтоматическиПодставлятьДокументы", Настройки.Получить("АвтоматическиПодставлятьДокументы"));
		КонецЕсли;
		Если Настройки.Получить("НеУдалятьДокументыКоторыхНетВВыписке") = Неопределено Тогда
			ДополнительныеПараметры.Вставить("НеУдалятьДокументыКоторыхНетВВыписке", Ложь);
		Иначе
			ДополнительныеПараметры.Вставить("НеУдалятьДокументыКоторыхНетВВыписке", Настройки.Получить("НеУдалятьДокументыКоторыхНетВВыписке"));
		КонецЕсли;
		Если Настройки.Получить("АнализироватьИсториюВыбораЗначенийРеквизитов") = Неопределено Тогда
			ДополнительныеПараметры.Вставить("АнализироватьИсториюВыбораЗначенийРеквизитов", Истина);
		Иначе
			ДополнительныеПараметры.Вставить("АнализироватьИсториюВыбораЗначенийРеквизитов", Настройки.Получить("АнализироватьИсториюВыбораЗначенийРеквизитов"));
		КонецЕсли;
		Если Настройки.Получить("КонтролироватьБезопасностьОбменаСБанком") = Неопределено Тогда
			ДополнительныеПараметры.Вставить("КонтролироватьБезопасностьОбменаСБанком", Ложь);
		Иначе
			ДополнительныеПараметры.Вставить("КонтролироватьБезопасностьОбменаСБанком", Настройки.Получить("КонтролироватьБезопасностьОбменаСБанком"));
		КонецЕсли;
		ДополнительныеПараметры.Вставить("СпособЗачета", Настройки.Получить("СпособЗачета"));
	Иначе
		ДополнительныеПараметры.Вставить("ФайлВыгрузки", "");
		ДополнительныеПараметры.Вставить("ФайлЗагрузки", "");
		ДополнительныеПараметры.Вставить("Программа", "");
		
		#Вставка
		// СМП_РаботаСБанками +++
		ДополнительныеПараметры.Вставить("ОбработкаПротокола", Неопределено);
		// СМП_РаботаСБанками ---
		#КонецВставки
		
		ДополнительныеПараметры.Вставить("СтатьяДДСИсходящий", Справочники.СтатьиДвиженияДенежныхСредств.ОплатаПоставщикам);
		ДополнительныеПараметры.Вставить("СтатьяДДСВходящий", Справочники.СтатьиДвиженияДенежныхСредств.ОплатаОтПокупателей);
		ДополнительныеПараметры.Вставить("ПроводитьЗагружаемые", Ложь);
		ДополнительныеПараметры.Вставить("ЗаполнятьДолгиАвтоматически", Ложь); // Настройка устарела. Теперь используется значение из договора
		ДополнительныеПараметры.Вставить("Кодировка", "Авто");
		ДополнительныеПараметры.Вставить("ВерсияФормата", "1.02");
		ДополнительныеПараметры.Вставить("АвтоматическиПодставлятьДокументы", Истина);
		ДополнительныеПараметры.Вставить("НеУдалятьДокументыКоторыхНетВВыписке", Ложь);
		ДополнительныеПараметры.Вставить("АнализироватьИсториюВыбораЗначенийРеквизитов", Истина);
		ДополнительныеПараметры.Вставить("КонтролироватьБезопасностьОбменаСБанком", Истина);
		ДополнительныеПараметры.Вставить("СпособЗачета", Неопределено);
	КонецЕсли;

КонецПроцедуры

// СМП_РаботаСБанками
Функция СМП_ПолучитьОбработкуПротокола(БанковскийСчет) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	СМП_УчетныеЗаписиБанков.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СМП_УчетныеЗаписиБанков КАК СМП_УчетныеЗаписиБанков
	|ГДЕ
	|	СМП_УчетныеЗаписиБанков.ПометкаУдаления = ЛОЖЬ
	|	И СМП_УчетныеЗаписиБанков.БанковскийСчет = &БанковскийСчет";
	Запрос.УстановитьПараметр("БанковскийСчет", БанковскийСчет);
	Результат = Запрос.Выполнить().Выбрать();
	Если Результат.Следующий() тогда
		Если СМП_РаботаСБанкамиСервер.ФункционалБанкаПодключен(Результат.Ссылка.Банк, "ПодключаемаяОбработка") Тогда
			Возврат Результат.Ссылка.ПодключаемаяОбработка;
		Иначе
			Возврат Результат.Ссылка;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции
