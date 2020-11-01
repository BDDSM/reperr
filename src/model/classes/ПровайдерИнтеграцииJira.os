#Использовать 1connector

Перем URL;
Перем Логин;
Перем Пароль;
Перем Токен;
Перем КлючПроекта;
Перем ИдТипаЗадачи;
Перем ТемаЗадачи;

Процедура ПриСозданииОбъекта()
	
КонецПроцедуры

Функция URL(вхURL) Экспорт
	
	URL = вхURL;
	
	Возврат ЭтотОбъект;
	
КонецФункции

Функция Логин(вхЛогин) Экспорт
	
	Логин = вхЛогин;
	
	Возврат ЭтотОбъект;
	
КонецФункции

Функция Токен(вхТокен) Экспорт
	
	Токен = вхТокен;
	
	Возврат ЭтотОбъект;
	
КонецФункции

Функция КлючПроекта(вхКлючПроекта) Экспорт
	
	КлючПроекта = вхКлючПроекта;
	
	Возврат ЭтотОбъект;
	
КонецФункции

Функция ИдТипаЗадачи(вхИдТипаЗадачи) Экспорт
	
	ИдТипаЗадачи = вхИдТипаЗадачи;
	
	Возврат ЭтотОбъект;
	
КонецФункции

Функция ТемаЗадачи(вхТемаЗадачи) Экспорт
	
	ТемаЗадачи = вхТемаЗадачи;
	
	Возврат ЭтотОбъект;
	
КонецФункции

Процедура ЗарегистрироватьОшибку(ДанныеОтчетаОбОшибке) Экспорт
	
	URLIssues = URL + "/issue";

	ТелоЗапроса = СформироватьТелоЗапроса(ДанныеОтчетаОбОшибке);
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");

	Аутентификация = Новый Структура();
	Аутентификация.Вставить("Пользователь", Логин);
	Аутентификация.Вставить("Пароль", Токен);

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Заголовки", Заголовки);
	ДополнительныеПараметры.Вставить("Аутентификация", Аутентификация);

	РезультатЗапроса = КоннекторHTTP.Post(URLIssues, ТелоЗапроса, , ДополнительныеПараметры);

	Если РезультатЗапроса.КодСостояния <> 201 Тогда
		ВызватьИсключение("Не удалось зарегистрировать ошибку");
	КонецЕсли;

	РезультатЗапросаJSON = РезультатЗапроса.JSON();

	СсылкаНаОшибку = РезультатЗапросаJSON["self"];
	URLAttachments = СсылкаНаОшибку + "/attachments";

	Для Каждого ПутьКПрикрепляемомуФайлу Из ДанныеОтчетаОбОшибке.Файлы Цикл

		ПрикрепляемыйФайл = Новый Файл(ПутьКПрикрепляемомуФайлу);
		Если Не ПрикрепляемыйФайл.Существует() Тогда
			Продолжить;
		КонецЕсли;

		ПрикрепитьФайлКЗадаче(URLAttachments, ПрикрепляемыйФайл);
		
	КонецЦикла;

	Если ЗначениеЗаполнено(ДанныеОтчетаОбОшибке.Скриншот) Тогда

		ПрикрепляемыйФайл = Новый Файл(ДанныеОтчетаОбОшибке.Скриншот);
		Если ПрикрепляемыйФайл.Существует() Тогда
			ПрикрепитьФайлКЗадаче(URLAttachments, ПрикрепляемыйФайл);;
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

Процедура ПрикрепитьФайлКЗадаче(URL, ПрикрепляемыйФайл)

	Аутентификация = Новый Структура();
	Аутентификация.Вставить("Пользователь", Логин);
	Аутентификация.Вставить("Пароль", Токен);

	Заголовки = Новый Соответствие;
	Заголовки.Вставить("X-Atlassian-Token", "no-check");

	Файлы = Новый Структура;
	Файлы.Вставить("Имя", "file");
	Файлы.Вставить("ИмяФайла", ПрикрепляемыйФайл.Имя);
	Файлы.Вставить("Данные", Новый ДвоичныеДанные(ПрикрепляемыйФайл.ПолноеИмя));
	Если ПрикрепляемыйФайл.Расширение = ".png" Тогда
		Файлы.Вставить("Тип", "image/png");
	Иначе
		Файлы.Вставить("Тип", "application/octet-stream");
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Аутентификация", Аутентификация);
	ДополнительныеПараметры.Вставить("Заголовки", Заголовки);
	ДополнительныеПараметры.Вставить("Файлы", Файлы);

	РезультатЗапроса = КоннекторHTTP.Post(URL, Неопределено, Неопределено, ДополнительныеПараметры);
	Если РезультатЗапроса.КодСостояния <> 200 Тогда
		Сообщить("Не удалось прикрепить файл");
	КонецЕсли;

КонецПроцедуры

Функция СформироватьТелоЗапроса(ДанныеОтчетаОбОшибке) Экспорт

	Issue = Новый Структура;
	Issue.Вставить("project", Новый Структура("key", КлючПроекта));
	Issue.Вставить("issuetype", Новый Структура("id", ИдТипаЗадачи));
	Issue.Вставить("summary", ТемаЗадачи);
	
	Описание = ОбработкаОшибок.СформироватьОписаниеОшибки(ДанныеОтчетаОбОшибке);
	Issue.Вставить("description", Описание);
	
	ТелоЗапросаJSON = Новый Структура;
	ТелоЗапросаJSON.Вставить("fields", Issue);
	
	ПарсерJSON = Новый ПарсерJSON();
	ТелоЗапроса = ПарсерJSON.ЗаписатьJSON(ТелоЗапросаJSON);

	Возврат ТелоЗапроса;

КонецФункции
