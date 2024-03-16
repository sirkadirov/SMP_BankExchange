
////////////////////////////////////////////////////////////////////////////////
// ЭлектронноеВзаимодействиеКлиентПереопределяемый: общий механизм обмена электронными документами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Переопределяет сообщение о нехватке прав доступа.
//
// Параметры:
//  ТекстСообщения - Строка - текст сообщения.
//
Процедура ПодготовитьТекстСообщенияОНарушенииПравДоступа(ТекстСообщения) Экспорт
	
	// При необходимости можно переопределить или дополнить текст сообщения
	
КонецПроцедуры

// Выполняет интерактивное проведение документов перед формированием ЭД.
// Если есть непроведенные документы, предлагает выполнить проведение. Спрашивает
// пользователя о продолжении, если какие-то из документов не провелись и имеются проведенные.
//
// Параметры:
//  ДокументыМассив - Массив - Ссылки на документы, которые требуется провести перед печатью.
//                             После выполнения функции из массива исключаются непроведенные документы.
//  ОбработкаПродолжения - ОписаниеОповещения - содержит описание процедуры,
//                         которая будет вызвана после завершения проверки документов.
//  ФормаИсточник - УправляемаяФорма - форма, из которой была вызвана команда.
//
Процедура ВыполнитьПроверкуПроведенияДокументов(ДокументыМассив, ОбработкаПродолжения, ФормаИсточник = Неопределено, СтандартнаяОбработка = Истина) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ОчиститьСообщения();
	
	ДокументыТребующиеПроведение = ОбщегоНазначенияВызовСервера.ПроверитьПроведенностьДокументов(ДокументыМассив);
	КоличествоНепроведенныхДокументов = ДокументыТребующиеПроведение.Количество();
	
	Если КоличествоНепроведенныхДокументов > 0 Тогда
		
		Если КоличествоНепроведенныхДокументов = 1 Тогда
			ТекстВопроса = НСтр("ru = 'Для того чтобы сформировать электронную версию документа, его необходимо предварительно провести.
                                 |Выполнить проведение документа и продолжить?'; uk = 'Для того щоб сформувати електронну версію документа, його необхідно попередньо провести.
                                 |Виконати проведення документа і продовжити?'");
		Иначе
			ТекстВопроса = НСтр("ru = 'Для того чтобы сформировать электронные версии документов, их необходимо предварительно провести.
                                 |Выполнить проведение документов и продолжить?'; uk = 'Для того щоб сформувати електронні версії документів, їх необхідно попередньо провести.
                                 |Виконати проведення документів і продовжити?'");
		КонецЕсли;
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ОбработкаПродолжения", ОбработкаПродолжения);
		ДополнительныеПараметры.Вставить("ДокументыТребующиеПроведение", ДокументыТребующиеПроведение);
		ДополнительныеПараметры.Вставить("ФормаИсточник", ФормаИсточник);
		ДополнительныеПараметры.Вставить("ДокументыМассив", ДокументыМассив);
		Обработчик = Новый ОписаниеОповещения("ВыполнитьПроверкуПроведенияДокументовПродолжить", ЭтотОбъект, ДополнительныеПараметры);
		
		ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ВыполнитьОбработкуОповещения(ОбработкаПродолжения, ДокументыМассив);
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму обращения в службу технической поддержки
//
// Параметры:
//  ДанныеДляТехПоддержки                     - Структура - с ключами:
//     * АдресФайлаДляТехПоддержки            - Строка - адрес во временном хранилище файла с технической информацией.
//     * ТелефонСлужбыПоддержки               - Строка - телефон службы технической поддержки.
//     * АдресЭлектроннойПочтыСлужбыПоддержки - Строка - email службы технической поддержки.
//     * ТекстОбращения                       - Строка - текст обращения в службу технической поддержки.
//  СтандартнаяОбработка                      - Булево - если метод реализован, то необходимо установить значение Ложь.
//
Процедура ОткрытьФормуОбращенияВТехПоддержку(ДанныеДляТехПоддержки, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

#Область ПереопределениеФормПодсистемы

// Общие замечания для методов области "ПереопределениеФормПодсистемы".
// Поддерживается переопределение форм со следующим назначением и стандартными элементами:
// * "СопоставлениеНоменклатуры" - форма сопоставления номенклатуры.
//  ** "Характеристика" - колонка характеристики ИБ таблицы сопоставления.
//  ** "Упаковка" - колонка упаковки ИБ таблицы сопоставления.
// Описание параметра "Контекст" для всех методов области:
//  * Назначение - Строка - назначение формы (см. выше).
//  * Форма - ФормаКлиентскогоПриложения - форма, для которой вызвано событие.
//  * Префикс - Строка - префикс имен для новых реквизитов, команд и элементов формы.
//  * СтандартныйЭлемент - Строка - идентификатор стандартного элемента (см. выше), для которого вызвано событие.
//                       - Неопределено - событие вызвано для элемента, добавленного в переопределяемой части.

// Выполняется при открытии формы подсистемы.
// Позволяет выполнить дополнительные действия с формой на клиенте.
//
// Параметры:
//  Контекст - ФиксированнаяСтруктура - контекст создания формы. См. общие замечания области "ПереопределениеФормПодсистемы".
//  Отказ - Булево - аналогичен параметру обработчика события "ПриОткрытии" управляемой формы.
//
// Пример:
//  Если ВРег(Контекст.Назначение) = ВРег("СопоставлениеНоменклатуры") Тогда
//  	// действия с формой на клиенте...
//  КонецЕсли;
//
Процедура ПриОткрытииФормыПодсистемы(Контекст, Отказ) Экспорт
	
КонецПроцедуры

// Обработчик события ПриИзменении элемента формы подсистемы.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода. См. общие замечания области "ПереопределениеФормПодсистемы".
//  Элемент - ЭлементФормы - см. описание параметра события элемента формы.
//
Процедура ЭлементФормыПодсистемыПриИзменении(Контекст, Элемент) Экспорт
	
КонецПроцедуры

// Обработчик события НачалоВыбора элемента формы подсистемы.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода. См. общие замечания области "ПереопределениеФормПодсистемы".
//  Элемент - ЭлементФормы - см. описание параметра события элемента формы.
//  ДанныеВыбора - СписокЗначений - см. описание параметра события элемента формы.
//  СтандартнаяОбработка - Булево - см. описание параметра события элемента формы.
//
Процедура ЭлементФормыПодсистемыНачалоВыбора(Контекст, Элемент, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
	Если Элемент.Имя = "СопоставлениеУпаковка" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ОчиститьСообщения();
		
		ТД = Контекст.Форма.Элементы.Сопоставление.ТекущиеДанные;
		Если ТД = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ТД.Номенклатура) Тогда
			ТекстСообщения = НСтр("ru = 'Для выбора единицы измерения номенклатура должна быть заполнена.'; uk = 'Для вибору одиниці виміру номенклатура повинна бути заповнена.'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
			Возврат;
		КонецЕсли;
		
		СтруктураОтбора = Новый Структура;
		СтруктураОтбора.Вставить("Владелец", ТД.Номенклатура);
		
		ПараметрыВыборка = Новый Структура;
		ПараметрыВыборка.Вставить("Отбор", СтруктураОтбора);
		
		ДанныеВыбора = УправлениеНебольшойФирмойЭлектронныеДокументыВызовСервера.ДанныеВыбораУпаковки(ПараметрыВыборка);
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события НачалоВыбораИзСписка элемента формы подсистемы.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода. См. общие замечания области "ПереопределениеФормПодсистемы".
//  Элемент - ЭлементФормы - см. описание параметра события элемента формы.
//  СтандартнаяОбработка - Булево - см. описание параметра события элемента формы.
//
Процедура ЭлементФормыПодсистемыНачалоВыбораИзСписка(Контекст, Элемент, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Обработчик события Очистка элемента формы подсистемы.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода. См. общие замечания области "ПереопределениеФормПодсистемы".
//  Элемент - ЭлементФормы - см. описание параметра события элемента формы.
//  СтандартнаяОбработка - Булево - см. описание параметра события элемента формы.
//
Процедура ЭлементФормыПодсистемыОчистка(Контекст, Элемент, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Обработчик события Создание элемента формы подсистемы.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода. См. общие замечания области "ПереопределениеФормПодсистемы".
//  Элемент - ЭлементФормы - см. описание параметра события элемента формы.
//  СтандартнаяОбработка - Булево - см. описание параметра события элемента формы.
//
Процедура ЭлементФормыПодсистемыСоздание(Контекст, Элемент, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Обработчик события ОбработкаВыбора элемента формы подсистемы.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода. См. общие замечания области "ПереопределениеФормПодсистемы".
//  Элемент - ЭлементФормы - см. описание параметра события элемента формы.
//  ВыбранноеЗначение - Произвольный - см. описание параметра события элемента формы.
//  СтандартнаяОбработка - Булево - см. описание параметра события элемента формы.
//
Процедура ЭлементФормыПодсистемыОбработкаВыбора(Контекст, Элемент, ВыбранноеЗначение, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Обработчик события ИзменениеТекстаРедактирования элемента формы подсистемы.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода. См. общие замечания области "ПереопределениеФормПодсистемы".
//  Элемент - ЭлементФормы - см. описание параметра события элемента формы.
//  Текст - Строка - см. описание параметра события элемента формы.
//  СтандартнаяОбработка - Булево - см. описание параметра события элемента формы.
//
Процедура ЭлементФормыПодсистемыИзменениеТекстаРедактирования(Контекст, Элемент, Текст, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Обработчик события АвтоПодбор элемента формы подсистемы.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода. См. общие замечания области "ПереопределениеФормПодсистемы".
//  Элемент - ЭлементФормы - см. описание параметра события элемента формы.
//  Текст - Строка - см. описание параметра события элемента формы.
//  ДанныеВыбора - СписокЗначений  - см. описание параметра события элемента формы.
//  ПараметрыПолученияДанных - Структура, Неопределено - см. описание параметра события элемента формы.
//  Ожидание - Число - см. описание параметра события элемента формы.
//  СтандартнаяОбработка - Булево - см. описание параметра события элемента формы.
//
Процедура ЭлементФормыПодсистемыАвтоПодбор(Контекст, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Обработчик события ОкончаниеВводаТекста элемента формы подсистемы.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода. См. общие замечания области "ПереопределениеФормПодсистемы".
//  Элемент - ЭлементФормы - см. описание параметра события элемента формы.
//  Текст - Строка - см. описание параметра события элемента формы.
//  ДанныеВыбора - СписокЗначений  - см. описание параметра события элемента формы.
//  ПараметрыПолученияДанных - Структура, Неопределено - см. описание параметра события элемента формы.
//  СтандартнаяОбработка - Булево - см. описание параметра события элемента формы.
//
Процедура ЭлементФормыПодсистемыОкончаниеВводаТекста(Контекст, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Обработчик события Нажатие элемента формы подсистемы.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода. См. общие замечания области "ПереопределениеФормПодсистемы".
//  Элемент - ЭлементФормы - см. описание параметра события элемента формы.
//
Процедура ЭлементФормыПодсистемыНажатие(Контекст, Элемент) Экспорт
	
КонецПроцедуры

// Обработчик события ОбработкаНавигационнойСсылки элемента формы подсистемы.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода. См. общие замечания области "ПереопределениеФормПодсистемы".
//  Элемент - ЭлементФормы - см. описание параметра события элемента формы.
//  НавигационнаяСсылкаФорматированнойСтроки - Строка - см. описание параметра события элемента формы.
//  СтандартнаяОбработка - Булево - см. описание параметра события элемента формы.
//
Процедура ЭлементФормыПодсистемыОбработкаНавигационнойСсылки(Контекст, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Выполняет действие команды формы подсистемы.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода. См. общие замечания области "ПереопределениеФормПодсистемы".
//  Команда - КомандаФормы - см. описание параметра действия команды формы.
//
Процедура КомандаФормыПодсистемыДействие(Контекст, Команда) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ВыполнитьПроверкуПроведенияДокументовПродолжить(Знач Результат, Знач ДополнительныеПараметры) Экспорт
	
	ДокументыМассив = Неопределено;
	ОбработкаПродолжения = Неопределено;
	ДокументыТребующиеПроведение = Неопределено;
	Если Результат = КодВозвратаДиалога.Да
		И ТипЗнч(ДополнительныеПараметры) = Тип("Структура")
		И ДополнительныеПараметры.Свойство("ДокументыМассив", ДокументыМассив)
		И ДополнительныеПараметры.Свойство("ОбработкаПродолжения", ОбработкаПродолжения)
		И ДополнительныеПараметры.Свойство("ДокументыТребующиеПроведение", ДокументыТребующиеПроведение) Тогда
		
		ФормаИсточник = Неопределено;
		ДополнительныеПараметры.Свойство("ФормаИсточник", ФормаИсточник);
		
		ДанныеОНепроведенныхДокументах = ОбщегоНазначенияВызовСервера.ПровестиДокументы(ДокументыТребующиеПроведение);
		
		// Cообщаем о документах, которые не провелись.
		ШаблонСообщения = НСтр("ru = 'Документ %1 не проведен: %2 Формирование ЭД невозможно.'; uk = 'Документ %1 не проведено: %2 Формування ЕД неможливе.'");
		НепроведенныеДокументы = Новый Массив;
		Для Каждого ИнформацияОДокументе Из ДанныеОНепроведенныхДокументах Цикл
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
																	ШаблонСообщения,
																	Строка(ИнформацияОДокументе.Ссылка),
																	ИнформацияОДокументе.ОписаниеОшибки);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ИнформацияОДокументе.Ссылка);
			НепроведенныеДокументы.Добавить(ИнформацияОДокументе.Ссылка);
		КонецЦикла;
		
		КоличествоНепроведенныхДокументов = НепроведенныеДокументы.Количество();
		
		// Оповещаем открытые формы о том, что были проведены документы.
		ПроведенныеДокументы = ОбщегоНазначенияКлиентСервер.РазностьМассивов(ДокументыТребующиеПроведение,
																			НепроведенныеДокументы);
		ТипыПроведенныхДокументов = Новый Соответствие;
		Для Каждого ПроведенныйДокумент Из ПроведенныеДокументы Цикл
			ТипыПроведенныхДокументов.Вставить(ТипЗнч(ПроведенныйДокумент));
		КонецЦикла;
		Для Каждого Тип Из ТипыПроведенныхДокументов Цикл
			ОповеститьОбИзменении(Тип.Ключ);
		КонецЦикла;
		
		Оповестить("ОбновитьДокументИБПослеЗаполнения", ПроведенныеДокументы);
		
		// Обновляем исходный массив документов.
		ДокументыМассив = ОбщегоНазначенияКлиентСервер.РазностьМассивов(ДокументыМассив, НепроведенныеДокументы);
		ЕстьДокументыГотовыеДляФормированияЭД = ДокументыМассив.Количество() > 0;
		Если КоличествоНепроведенныхДокументов > 0 Тогда
			
			// Спрашиваем пользователя о необходимости продолжения печати при наличии непроведенных документов.
			ТекстВопроса = НСтр("ru = 'Не удалось провести один или несколько документов.'; uk = 'Не вдалося провести один або кілька документів.'");
			КнопкиДиалога = Новый СписокЗначений;
			
			Если ЕстьДокументыГотовыеДляФормированияЭД Тогда
				ТекстВопроса = ТекстВопроса + " " + НСтр("ru = 'Продолжить?'; uk = 'Продовжити?'");
				КнопкиДиалога.Добавить(КодВозвратаДиалога.Пропустить, НСтр("ru = 'Продолжить'; uk = 'Продовжити'"));
				КнопкиДиалога.Добавить(КодВозвратаДиалога.Отмена);
			Иначе
				КнопкиДиалога.Добавить(КодВозвратаДиалога.ОК);
			КонецЕсли;
			ДопПараметры = Новый Структура("ОбработкаПродолжения, ДокументыМассив", ОбработкаПродолжения, ДокументыМассив);
			Обработчик = Новый ОписаниеОповещения("ВыполнитьПроверкуПроведенияДокументовЗавершить", ЭтотОбъект, ДопПараметры);
			ПоказатьВопрос(Обработчик, ТекстВопроса, КнопкиДиалога);
		Иначе
			ВыполнитьОбработкуОповещения(ОбработкаПродолжения, ДокументыМассив);
		КонецЕсли;
		Оповестить("ОбновитьСостояниеЭД");
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьПроверкуПроведенияДокументовЗавершить(Знач Результат, Знач ДополнительныеПараметры) Экспорт
	
	ДокументыМассив = Неопределено;
	
	ОбработкаПродолжения = Неопределено;
	Если Результат = КодВозвратаДиалога.Пропустить
		И ТипЗнч(ДополнительныеПараметры) = Тип("Структура")
		И ДополнительныеПараметры.Свойство("ДокументыМассив", ДокументыМассив)
		И ДополнительныеПараметры.Свойство("ОбработкаПродолжения", ОбработкаПродолжения) Тогда
		
		ВыполнитьОбработкуОповещения(ОбработкаПродолжения, ДокументыМассив);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти