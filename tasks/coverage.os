#Использовать 1commands
#Использовать fs
#Использовать coverage

СистемнаяИнформация = Новый СистемнаяИнформация;
ЭтоWindows = Найти(НРег(СистемнаяИнформация.ВерсияОС), "windows") > 0;

КаталогРезультатов = ОбъединитьПути("out", "coverage");
ФС.ОбеспечитьПустойКаталог(КаталогРезультатов);
ПутьКФайлуСтатистики = ОбъединитьПути(КаталогРезультатов, "stat.json");

Команда = Новый Команда;
Команда.УстановитьКоманду("oscript");
Если НЕ ЭтоWindows Тогда
	Команда.ДобавитьПараметр("-encoding=utf-8");
КонецЕсли;
Команда.ДобавитьПараметр(СтрШаблон("-codestat=%1", ПутьКФайлуСтатистики));
Команда.ДобавитьПараметр(ОбъединитьПути("tasks", "test.os"));
Команда.ПоказыватьВыводНемедленно(Истина);

КодВозврата = Команда.Исполнить();

ФайлСтатистики = Новый Файл(ПутьКФайлуСтатистики);

ПроцессорГенерации = Новый ГенераторОтчетаПокрытия();

ПроцессорГенерации.ОтносительныеПути()
				.РабочийКаталог(КаталогРезультатов)
				.ФайлСтатистики(ПутьКФайлуСтатистики)
				.GenericCoverage()
				.Cobertura()
				.Сформировать();

ЗавершитьРаботу(КодВозврата);
