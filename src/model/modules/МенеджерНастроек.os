#Использовать json

Перем мКаталогДанных;
Перем мХранилищеДанных;
Перем мПровайдерИнтеграции;

Функция КаталогДанных() Экспорт
	
	Возврат мКаталогДанных;
	
КонецФункции

Функция ХранилищеДанных() Экспорт
	
	Возврат мХранилищеДанных;
	
КонецФункции

Функция ПровайдерИнтеграции() Экспорт
	
	Возврат мПровайдерИнтеграции;
	
КонецФункции

Процедура Инициализировать() Экспорт
	
	ПутьКФайлуНастроек = "appsettings.json";
	Настройки = ПрочитатьФайлНастроекПриложения(ПутьКФайлуНастроек);
	
	ВидыХранилищ = Настройки["DataStorage"];
	
	Для Каждого ВидХранилища Из ВидыХранилищ Цикл
		
		ВидХранилищаНастройки = ВидХранилища.Значение;
		
		Если ВидХранилищаНастройки["enabled"] Тогда
			
			Если ВидХранилища.Ключ = "file" Тогда
				мКаталогДанных = ВидХранилищаНастройки["path"];	
				мХранилищеДанных = Новый ФайловоеХранилище(мКаталогДанных);
			Иначе
				ВызватьИсключение("Неизвестный тип хранения данных, проверьте файл настроек appsettings.json");
			КонецЕсли;
			
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Интеграции = Настройки["Integrations"];
	
	Для Каждого Интеграция Из Интеграции Цикл

		ИнтеграцияНастройки = Интеграция.Значение;
	
		Если ИнтеграцияНастройки["enabled"] Тогда
	
			Если Интеграция.Ключ = "redmine" Тогда

				ПровайдерИнтеграцииRedmine = Новый ПровайдерИнтеграцииRedmine()
												.URLRedmine(ИнтеграцияНастройки["url"])
												.КлючAPI(ИнтеграцияНастройки["APIKey"])
												.ИдПроекта(ИнтеграцияНастройки["project-id"])
												.ИдТрекера(ИнтеграцияНастройки["tracker-id"])
												.ИдПриоритета(ИнтеграцияНастройки["priority-id"])
												.ИдСтатуса(ИнтеграцияНастройки["status-id"])
												.Тема(ИнтеграцияНастройки["topic"])
												.КоличествоЧасов(ИнтеграцияНастройки["hours"]);

				мПровайдерИнтеграции = ПровайдерИнтеграцииRedmine;

			ИначеЕсли Интеграция.Ключ = "jira" Тогда

				ПровайдерИнтеграцииJira = Новый ПровайдерИнтеграцииJira()
												.URL(ИнтеграцияНастройки["url"])
												.Логин(ИнтеграцияНастройки["login"])
												.Токен(ИнтеграцияНастройки["token"])
												.КлючПроекта(ИнтеграцияНастройки["project-key"])
												.ИдТипаЗадачи(ИнтеграцияНастройки["issuetype-id"])
												.ТемаЗадачи(ИнтеграцияНастройки["summary"]);

				мПровайдерИнтеграции = ПровайдерИнтеграцииJira;

			Иначе
				ВызватьИсключение("Неизвестный тип интеграции");
			КонецЕсли;

			Прервать;

		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

Функция ПрочитатьФайлНастроекПриложения(ПутьКФайлу)
	
	ЧтениеТекста = Новый ЧтениеТекста(ПутьКФайлу, "utf-8");
	СодержимоеФайлаНастроек = ЧтениеТекста.Прочитать();
	ЧтениеТекста.Закрыть();
	
	ПарсерJSON = Новый ПарсерJSON();
	Настройки = ПарсерJSON.ПрочитатьJSON(СодержимоеФайлаНастроек);
	
	Возврат Настройки["reperrSettings"];
	
КонецФункции
