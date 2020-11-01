
#Использовать json

Функция СохранитьОтчет(ФайлОтчета) Экспорт

	ИдОтчетаОбОшибке = Строка(Новый УникальныйИдентификатор());
	ХранилищеДанных = МенеджерНастроек.ХранилищеДанных();

	Попытка
		ХранилищеДанных.СохранитьФайлОтчета(ИдОтчетаОбОшибке, ФайлОтчета);
	Исключение
		ВызватьИсключение("Не удалось сохранить отчет
		|" + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;

	Возврат ИдОтчетаОбОшибке;

КонецФункции

Процедура ЗаполнитьОтчетОбОшибке(СтруктураОтчета, ИмяФайла) Экспорт

	ЧтениеТекста = Новый ЧтениеТекста(ИмяФайла, КодировкаТекста.UTF8NoBOM);
	ОтчетОбОшибкеJSON = ЧтениеТекста.Прочитать();
	ЧтениеТекста.Закрыть();

	ПарсерJSON = Новый ПарсерJSON;
	ДанныеОтчетаОбОшибке = ПарсерJSON.ПрочитатьJSON(ОтчетОбОшибкеJSON, , , Истина);

	Инфо = СтруктураОтчета.Информация;

	Инфо.Вставить("Дата", ДанныеОтчетаОбОшибке.time);
	Инфо.Вставить("ИнформационнаяБаза", ДанныеОтчетаОбОшибке.configInfo.name);
	Инфо.Вставить("ИмяКонфигурации", "Не предоставляется платформой");
	Инфо.Вставить("ВерсияКонфигурации", ДанныеОтчетаОбОшибке.configInfo.version);
	Инфо.Вставить("ПлатформаКлиент", ДанныеОтчетаОбОшибке.clientInfo.platformType);
	Инфо.Вставить("ВерсияПлатформы1C", ДанныеОтчетаОбОшибке.clientInfo.appVersion);
	Инфо.Вставить("СУБД", ДанныеОтчетаОбОшибке.serverInfo.dbms);
	ПредставлениеСтека = СформироватьПредставлениеСтека(ДанныеОтчетаОбОшибке.errorInfo.applicationErrorInfo.stack[0]);
	Инфо.Вставить("Стек", ПредставлениеСтека);

КонецПроцедуры

Функция СформироватьПредставлениеСтека(Стек)

	Результат = "";

	Для Каждого ЭлементСтека Из Стек Цикл

		Результат = Результат + Символы.ПС + ЭлементСтека;

	КонецЦикла;

	Возврат Результат;

КонецФункции

Функция СтруктураДанныхОтчетаОбОшибке() Экспорт

	Результат = Новый Структура();
	Результат.Вставить("Информация", Новый Структура());
	Результат.Вставить("Файлы", Новый Массив());
	Результат.Вставить("Скриншот", "");

	Возврат Результат;

КонецФункции
