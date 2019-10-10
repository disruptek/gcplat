
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Books
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Searches for books and manages your Google Books library.
## 
## https://developers.google.com/books/docs/v1/getting_started
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_588466 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588466](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588466): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "books"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BooksCloudloadingAddBook_588734 = ref object of OpenApiRestCall_588466
proc url_BooksCloudloadingAddBook_588736(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksCloudloadingAddBook_588735(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   mime_type: JString
  ##            : The document MIME type. It can be set only if the drive_document_id is set.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   drive_document_id: JString
  ##                    : A drive document id. The upload_client_token must not be set.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: JString
  ##       : The document name. It can be set only if the drive_document_id is set.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   upload_client_token: JString
  section = newJObject()
  var valid_588848 = query.getOrDefault("fields")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = nil)
  if valid_588848 != nil:
    section.add "fields", valid_588848
  var valid_588849 = query.getOrDefault("quotaUser")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = nil)
  if valid_588849 != nil:
    section.add "quotaUser", valid_588849
  var valid_588863 = query.getOrDefault("alt")
  valid_588863 = validateParameter(valid_588863, JString, required = false,
                                 default = newJString("json"))
  if valid_588863 != nil:
    section.add "alt", valid_588863
  var valid_588864 = query.getOrDefault("mime_type")
  valid_588864 = validateParameter(valid_588864, JString, required = false,
                                 default = nil)
  if valid_588864 != nil:
    section.add "mime_type", valid_588864
  var valid_588865 = query.getOrDefault("oauth_token")
  valid_588865 = validateParameter(valid_588865, JString, required = false,
                                 default = nil)
  if valid_588865 != nil:
    section.add "oauth_token", valid_588865
  var valid_588866 = query.getOrDefault("userIp")
  valid_588866 = validateParameter(valid_588866, JString, required = false,
                                 default = nil)
  if valid_588866 != nil:
    section.add "userIp", valid_588866
  var valid_588867 = query.getOrDefault("drive_document_id")
  valid_588867 = validateParameter(valid_588867, JString, required = false,
                                 default = nil)
  if valid_588867 != nil:
    section.add "drive_document_id", valid_588867
  var valid_588868 = query.getOrDefault("key")
  valid_588868 = validateParameter(valid_588868, JString, required = false,
                                 default = nil)
  if valid_588868 != nil:
    section.add "key", valid_588868
  var valid_588869 = query.getOrDefault("name")
  valid_588869 = validateParameter(valid_588869, JString, required = false,
                                 default = nil)
  if valid_588869 != nil:
    section.add "name", valid_588869
  var valid_588870 = query.getOrDefault("prettyPrint")
  valid_588870 = validateParameter(valid_588870, JBool, required = false,
                                 default = newJBool(true))
  if valid_588870 != nil:
    section.add "prettyPrint", valid_588870
  var valid_588871 = query.getOrDefault("upload_client_token")
  valid_588871 = validateParameter(valid_588871, JString, required = false,
                                 default = nil)
  if valid_588871 != nil:
    section.add "upload_client_token", valid_588871
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588894: Call_BooksCloudloadingAddBook_588734; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_588894.validator(path, query, header, formData, body)
  let scheme = call_588894.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588894.url(scheme.get, call_588894.host, call_588894.base,
                         call_588894.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588894, url, valid)

proc call*(call_588965: Call_BooksCloudloadingAddBook_588734; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; mimeType: string = "";
          oauthToken: string = ""; userIp: string = ""; driveDocumentId: string = "";
          key: string = ""; name: string = ""; prettyPrint: bool = true;
          uploadClientToken: string = ""): Recallable =
  ## booksCloudloadingAddBook
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   mimeType: string
  ##           : The document MIME type. It can be set only if the drive_document_id is set.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   driveDocumentId: string
  ##                  : A drive document id. The upload_client_token must not be set.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : The document name. It can be set only if the drive_document_id is set.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   uploadClientToken: string
  var query_588966 = newJObject()
  add(query_588966, "fields", newJString(fields))
  add(query_588966, "quotaUser", newJString(quotaUser))
  add(query_588966, "alt", newJString(alt))
  add(query_588966, "mime_type", newJString(mimeType))
  add(query_588966, "oauth_token", newJString(oauthToken))
  add(query_588966, "userIp", newJString(userIp))
  add(query_588966, "drive_document_id", newJString(driveDocumentId))
  add(query_588966, "key", newJString(key))
  add(query_588966, "name", newJString(name))
  add(query_588966, "prettyPrint", newJBool(prettyPrint))
  add(query_588966, "upload_client_token", newJString(uploadClientToken))
  result = call_588965.call(nil, query_588966, nil, nil, nil)

var booksCloudloadingAddBook* = Call_BooksCloudloadingAddBook_588734(
    name: "booksCloudloadingAddBook", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/cloudloading/addBook",
    validator: validate_BooksCloudloadingAddBook_588735, base: "/books/v1",
    url: url_BooksCloudloadingAddBook_588736, schemes: {Scheme.Https})
type
  Call_BooksCloudloadingDeleteBook_589006 = ref object of OpenApiRestCall_588466
proc url_BooksCloudloadingDeleteBook_589008(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksCloudloadingDeleteBook_589007(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Remove the book and its contents
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   volumeId: JString (required)
  ##           : The id of the book to be removed.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589009 = query.getOrDefault("fields")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "fields", valid_589009
  var valid_589010 = query.getOrDefault("quotaUser")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "quotaUser", valid_589010
  var valid_589011 = query.getOrDefault("alt")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = newJString("json"))
  if valid_589011 != nil:
    section.add "alt", valid_589011
  var valid_589012 = query.getOrDefault("oauth_token")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "oauth_token", valid_589012
  var valid_589013 = query.getOrDefault("userIp")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "userIp", valid_589013
  var valid_589014 = query.getOrDefault("key")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "key", valid_589014
  assert query != nil,
        "query argument is necessary due to required `volumeId` field"
  var valid_589015 = query.getOrDefault("volumeId")
  valid_589015 = validateParameter(valid_589015, JString, required = true,
                                 default = nil)
  if valid_589015 != nil:
    section.add "volumeId", valid_589015
  var valid_589016 = query.getOrDefault("prettyPrint")
  valid_589016 = validateParameter(valid_589016, JBool, required = false,
                                 default = newJBool(true))
  if valid_589016 != nil:
    section.add "prettyPrint", valid_589016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589017: Call_BooksCloudloadingDeleteBook_589006; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove the book and its contents
  ## 
  let valid = call_589017.validator(path, query, header, formData, body)
  let scheme = call_589017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589017.url(scheme.get, call_589017.host, call_589017.base,
                         call_589017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589017, url, valid)

proc call*(call_589018: Call_BooksCloudloadingDeleteBook_589006; volumeId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## booksCloudloadingDeleteBook
  ## Remove the book and its contents
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   volumeId: string (required)
  ##           : The id of the book to be removed.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589019 = newJObject()
  add(query_589019, "fields", newJString(fields))
  add(query_589019, "quotaUser", newJString(quotaUser))
  add(query_589019, "alt", newJString(alt))
  add(query_589019, "oauth_token", newJString(oauthToken))
  add(query_589019, "userIp", newJString(userIp))
  add(query_589019, "key", newJString(key))
  add(query_589019, "volumeId", newJString(volumeId))
  add(query_589019, "prettyPrint", newJBool(prettyPrint))
  result = call_589018.call(nil, query_589019, nil, nil, nil)

var booksCloudloadingDeleteBook* = Call_BooksCloudloadingDeleteBook_589006(
    name: "booksCloudloadingDeleteBook", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/cloudloading/deleteBook",
    validator: validate_BooksCloudloadingDeleteBook_589007, base: "/books/v1",
    url: url_BooksCloudloadingDeleteBook_589008, schemes: {Scheme.Https})
type
  Call_BooksCloudloadingUpdateBook_589020 = ref object of OpenApiRestCall_588466
proc url_BooksCloudloadingUpdateBook_589022(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksCloudloadingUpdateBook_589021(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589023 = query.getOrDefault("fields")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "fields", valid_589023
  var valid_589024 = query.getOrDefault("quotaUser")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "quotaUser", valid_589024
  var valid_589025 = query.getOrDefault("alt")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = newJString("json"))
  if valid_589025 != nil:
    section.add "alt", valid_589025
  var valid_589026 = query.getOrDefault("oauth_token")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "oauth_token", valid_589026
  var valid_589027 = query.getOrDefault("userIp")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "userIp", valid_589027
  var valid_589028 = query.getOrDefault("key")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "key", valid_589028
  var valid_589029 = query.getOrDefault("prettyPrint")
  valid_589029 = validateParameter(valid_589029, JBool, required = false,
                                 default = newJBool(true))
  if valid_589029 != nil:
    section.add "prettyPrint", valid_589029
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589031: Call_BooksCloudloadingUpdateBook_589020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_589031.validator(path, query, header, formData, body)
  let scheme = call_589031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589031.url(scheme.get, call_589031.host, call_589031.base,
                         call_589031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589031, url, valid)

proc call*(call_589032: Call_BooksCloudloadingUpdateBook_589020;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## booksCloudloadingUpdateBook
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589033 = newJObject()
  var body_589034 = newJObject()
  add(query_589033, "fields", newJString(fields))
  add(query_589033, "quotaUser", newJString(quotaUser))
  add(query_589033, "alt", newJString(alt))
  add(query_589033, "oauth_token", newJString(oauthToken))
  add(query_589033, "userIp", newJString(userIp))
  add(query_589033, "key", newJString(key))
  if body != nil:
    body_589034 = body
  add(query_589033, "prettyPrint", newJBool(prettyPrint))
  result = call_589032.call(nil, query_589033, nil, nil, body_589034)

var booksCloudloadingUpdateBook* = Call_BooksCloudloadingUpdateBook_589020(
    name: "booksCloudloadingUpdateBook", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/cloudloading/updateBook",
    validator: validate_BooksCloudloadingUpdateBook_589021, base: "/books/v1",
    url: url_BooksCloudloadingUpdateBook_589022, schemes: {Scheme.Https})
type
  Call_BooksDictionaryListOfflineMetadata_589035 = ref object of OpenApiRestCall_588466
proc url_BooksDictionaryListOfflineMetadata_589037(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksDictionaryListOfflineMetadata_589036(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of offline dictionary metadata available
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   cpksver: JString (required)
  ##          : The device/version ID from which to request the data.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589038 = query.getOrDefault("fields")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "fields", valid_589038
  var valid_589039 = query.getOrDefault("quotaUser")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "quotaUser", valid_589039
  var valid_589040 = query.getOrDefault("alt")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = newJString("json"))
  if valid_589040 != nil:
    section.add "alt", valid_589040
  var valid_589041 = query.getOrDefault("oauth_token")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "oauth_token", valid_589041
  assert query != nil, "query argument is necessary due to required `cpksver` field"
  var valid_589042 = query.getOrDefault("cpksver")
  valid_589042 = validateParameter(valid_589042, JString, required = true,
                                 default = nil)
  if valid_589042 != nil:
    section.add "cpksver", valid_589042
  var valid_589043 = query.getOrDefault("userIp")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "userIp", valid_589043
  var valid_589044 = query.getOrDefault("key")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "key", valid_589044
  var valid_589045 = query.getOrDefault("prettyPrint")
  valid_589045 = validateParameter(valid_589045, JBool, required = false,
                                 default = newJBool(true))
  if valid_589045 != nil:
    section.add "prettyPrint", valid_589045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589046: Call_BooksDictionaryListOfflineMetadata_589035;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of offline dictionary metadata available
  ## 
  let valid = call_589046.validator(path, query, header, formData, body)
  let scheme = call_589046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589046.url(scheme.get, call_589046.host, call_589046.base,
                         call_589046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589046, url, valid)

proc call*(call_589047: Call_BooksDictionaryListOfflineMetadata_589035;
          cpksver: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## booksDictionaryListOfflineMetadata
  ## Returns a list of offline dictionary metadata available
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   cpksver: string (required)
  ##          : The device/version ID from which to request the data.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589048 = newJObject()
  add(query_589048, "fields", newJString(fields))
  add(query_589048, "quotaUser", newJString(quotaUser))
  add(query_589048, "alt", newJString(alt))
  add(query_589048, "oauth_token", newJString(oauthToken))
  add(query_589048, "cpksver", newJString(cpksver))
  add(query_589048, "userIp", newJString(userIp))
  add(query_589048, "key", newJString(key))
  add(query_589048, "prettyPrint", newJBool(prettyPrint))
  result = call_589047.call(nil, query_589048, nil, nil, nil)

var booksDictionaryListOfflineMetadata* = Call_BooksDictionaryListOfflineMetadata_589035(
    name: "booksDictionaryListOfflineMetadata", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/dictionary/listOfflineMetadata",
    validator: validate_BooksDictionaryListOfflineMetadata_589036,
    base: "/books/v1", url: url_BooksDictionaryListOfflineMetadata_589037,
    schemes: {Scheme.Https})
type
  Call_BooksFamilysharingGetFamilyInfo_589049 = ref object of OpenApiRestCall_588466
proc url_BooksFamilysharingGetFamilyInfo_589051(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksFamilysharingGetFamilyInfo_589050(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information regarding the family that the user is part of.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589052 = query.getOrDefault("fields")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "fields", valid_589052
  var valid_589053 = query.getOrDefault("quotaUser")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "quotaUser", valid_589053
  var valid_589054 = query.getOrDefault("alt")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = newJString("json"))
  if valid_589054 != nil:
    section.add "alt", valid_589054
  var valid_589055 = query.getOrDefault("oauth_token")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "oauth_token", valid_589055
  var valid_589056 = query.getOrDefault("userIp")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "userIp", valid_589056
  var valid_589057 = query.getOrDefault("source")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "source", valid_589057
  var valid_589058 = query.getOrDefault("key")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "key", valid_589058
  var valid_589059 = query.getOrDefault("prettyPrint")
  valid_589059 = validateParameter(valid_589059, JBool, required = false,
                                 default = newJBool(true))
  if valid_589059 != nil:
    section.add "prettyPrint", valid_589059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589060: Call_BooksFamilysharingGetFamilyInfo_589049;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information regarding the family that the user is part of.
  ## 
  let valid = call_589060.validator(path, query, header, formData, body)
  let scheme = call_589060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589060.url(scheme.get, call_589060.host, call_589060.base,
                         call_589060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589060, url, valid)

proc call*(call_589061: Call_BooksFamilysharingGetFamilyInfo_589049;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; source: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## booksFamilysharingGetFamilyInfo
  ## Gets information regarding the family that the user is part of.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589062 = newJObject()
  add(query_589062, "fields", newJString(fields))
  add(query_589062, "quotaUser", newJString(quotaUser))
  add(query_589062, "alt", newJString(alt))
  add(query_589062, "oauth_token", newJString(oauthToken))
  add(query_589062, "userIp", newJString(userIp))
  add(query_589062, "source", newJString(source))
  add(query_589062, "key", newJString(key))
  add(query_589062, "prettyPrint", newJBool(prettyPrint))
  result = call_589061.call(nil, query_589062, nil, nil, nil)

var booksFamilysharingGetFamilyInfo* = Call_BooksFamilysharingGetFamilyInfo_589049(
    name: "booksFamilysharingGetFamilyInfo", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/familysharing/getFamilyInfo",
    validator: validate_BooksFamilysharingGetFamilyInfo_589050, base: "/books/v1",
    url: url_BooksFamilysharingGetFamilyInfo_589051, schemes: {Scheme.Https})
type
  Call_BooksFamilysharingShare_589063 = ref object of OpenApiRestCall_588466
proc url_BooksFamilysharingShare_589065(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksFamilysharingShare_589064(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Initiates sharing of the content with the user's family. Empty response indicates success.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   docId: JString
  ##        : The docid to share.
  ##   volumeId: JString
  ##           : The volume to share.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589066 = query.getOrDefault("fields")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "fields", valid_589066
  var valid_589067 = query.getOrDefault("quotaUser")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "quotaUser", valid_589067
  var valid_589068 = query.getOrDefault("alt")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = newJString("json"))
  if valid_589068 != nil:
    section.add "alt", valid_589068
  var valid_589069 = query.getOrDefault("oauth_token")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "oauth_token", valid_589069
  var valid_589070 = query.getOrDefault("userIp")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "userIp", valid_589070
  var valid_589071 = query.getOrDefault("source")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "source", valid_589071
  var valid_589072 = query.getOrDefault("key")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "key", valid_589072
  var valid_589073 = query.getOrDefault("docId")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "docId", valid_589073
  var valid_589074 = query.getOrDefault("volumeId")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "volumeId", valid_589074
  var valid_589075 = query.getOrDefault("prettyPrint")
  valid_589075 = validateParameter(valid_589075, JBool, required = false,
                                 default = newJBool(true))
  if valid_589075 != nil:
    section.add "prettyPrint", valid_589075
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589076: Call_BooksFamilysharingShare_589063; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Initiates sharing of the content with the user's family. Empty response indicates success.
  ## 
  let valid = call_589076.validator(path, query, header, formData, body)
  let scheme = call_589076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589076.url(scheme.get, call_589076.host, call_589076.base,
                         call_589076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589076, url, valid)

proc call*(call_589077: Call_BooksFamilysharingShare_589063; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; source: string = ""; key: string = ""; docId: string = "";
          volumeId: string = ""; prettyPrint: bool = true): Recallable =
  ## booksFamilysharingShare
  ## Initiates sharing of the content with the user's family. Empty response indicates success.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   docId: string
  ##        : The docid to share.
  ##   volumeId: string
  ##           : The volume to share.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589078 = newJObject()
  add(query_589078, "fields", newJString(fields))
  add(query_589078, "quotaUser", newJString(quotaUser))
  add(query_589078, "alt", newJString(alt))
  add(query_589078, "oauth_token", newJString(oauthToken))
  add(query_589078, "userIp", newJString(userIp))
  add(query_589078, "source", newJString(source))
  add(query_589078, "key", newJString(key))
  add(query_589078, "docId", newJString(docId))
  add(query_589078, "volumeId", newJString(volumeId))
  add(query_589078, "prettyPrint", newJBool(prettyPrint))
  result = call_589077.call(nil, query_589078, nil, nil, nil)

var booksFamilysharingShare* = Call_BooksFamilysharingShare_589063(
    name: "booksFamilysharingShare", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/familysharing/share",
    validator: validate_BooksFamilysharingShare_589064, base: "/books/v1",
    url: url_BooksFamilysharingShare_589065, schemes: {Scheme.Https})
type
  Call_BooksFamilysharingUnshare_589079 = ref object of OpenApiRestCall_588466
proc url_BooksFamilysharingUnshare_589081(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksFamilysharingUnshare_589080(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Initiates revoking content that has already been shared with the user's family. Empty response indicates success.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   docId: JString
  ##        : The docid to unshare.
  ##   volumeId: JString
  ##           : The volume to unshare.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589082 = query.getOrDefault("fields")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "fields", valid_589082
  var valid_589083 = query.getOrDefault("quotaUser")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "quotaUser", valid_589083
  var valid_589084 = query.getOrDefault("alt")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = newJString("json"))
  if valid_589084 != nil:
    section.add "alt", valid_589084
  var valid_589085 = query.getOrDefault("oauth_token")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "oauth_token", valid_589085
  var valid_589086 = query.getOrDefault("userIp")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "userIp", valid_589086
  var valid_589087 = query.getOrDefault("source")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "source", valid_589087
  var valid_589088 = query.getOrDefault("key")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "key", valid_589088
  var valid_589089 = query.getOrDefault("docId")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "docId", valid_589089
  var valid_589090 = query.getOrDefault("volumeId")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "volumeId", valid_589090
  var valid_589091 = query.getOrDefault("prettyPrint")
  valid_589091 = validateParameter(valid_589091, JBool, required = false,
                                 default = newJBool(true))
  if valid_589091 != nil:
    section.add "prettyPrint", valid_589091
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589092: Call_BooksFamilysharingUnshare_589079; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Initiates revoking content that has already been shared with the user's family. Empty response indicates success.
  ## 
  let valid = call_589092.validator(path, query, header, formData, body)
  let scheme = call_589092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589092.url(scheme.get, call_589092.host, call_589092.base,
                         call_589092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589092, url, valid)

proc call*(call_589093: Call_BooksFamilysharingUnshare_589079; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; source: string = ""; key: string = ""; docId: string = "";
          volumeId: string = ""; prettyPrint: bool = true): Recallable =
  ## booksFamilysharingUnshare
  ## Initiates revoking content that has already been shared with the user's family. Empty response indicates success.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   docId: string
  ##        : The docid to unshare.
  ##   volumeId: string
  ##           : The volume to unshare.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589094 = newJObject()
  add(query_589094, "fields", newJString(fields))
  add(query_589094, "quotaUser", newJString(quotaUser))
  add(query_589094, "alt", newJString(alt))
  add(query_589094, "oauth_token", newJString(oauthToken))
  add(query_589094, "userIp", newJString(userIp))
  add(query_589094, "source", newJString(source))
  add(query_589094, "key", newJString(key))
  add(query_589094, "docId", newJString(docId))
  add(query_589094, "volumeId", newJString(volumeId))
  add(query_589094, "prettyPrint", newJBool(prettyPrint))
  result = call_589093.call(nil, query_589094, nil, nil, nil)

var booksFamilysharingUnshare* = Call_BooksFamilysharingUnshare_589079(
    name: "booksFamilysharingUnshare", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/familysharing/unshare",
    validator: validate_BooksFamilysharingUnshare_589080, base: "/books/v1",
    url: url_BooksFamilysharingUnshare_589081, schemes: {Scheme.Https})
type
  Call_BooksMyconfigGetUserSettings_589095 = ref object of OpenApiRestCall_588466
proc url_BooksMyconfigGetUserSettings_589097(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksMyconfigGetUserSettings_589096(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the current settings for the user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589098 = query.getOrDefault("fields")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "fields", valid_589098
  var valid_589099 = query.getOrDefault("quotaUser")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "quotaUser", valid_589099
  var valid_589100 = query.getOrDefault("alt")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = newJString("json"))
  if valid_589100 != nil:
    section.add "alt", valid_589100
  var valid_589101 = query.getOrDefault("oauth_token")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "oauth_token", valid_589101
  var valid_589102 = query.getOrDefault("userIp")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "userIp", valid_589102
  var valid_589103 = query.getOrDefault("key")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "key", valid_589103
  var valid_589104 = query.getOrDefault("prettyPrint")
  valid_589104 = validateParameter(valid_589104, JBool, required = false,
                                 default = newJBool(true))
  if valid_589104 != nil:
    section.add "prettyPrint", valid_589104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589105: Call_BooksMyconfigGetUserSettings_589095; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current settings for the user.
  ## 
  let valid = call_589105.validator(path, query, header, formData, body)
  let scheme = call_589105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589105.url(scheme.get, call_589105.host, call_589105.base,
                         call_589105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589105, url, valid)

proc call*(call_589106: Call_BooksMyconfigGetUserSettings_589095;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## booksMyconfigGetUserSettings
  ## Gets the current settings for the user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589107 = newJObject()
  add(query_589107, "fields", newJString(fields))
  add(query_589107, "quotaUser", newJString(quotaUser))
  add(query_589107, "alt", newJString(alt))
  add(query_589107, "oauth_token", newJString(oauthToken))
  add(query_589107, "userIp", newJString(userIp))
  add(query_589107, "key", newJString(key))
  add(query_589107, "prettyPrint", newJBool(prettyPrint))
  result = call_589106.call(nil, query_589107, nil, nil, nil)

var booksMyconfigGetUserSettings* = Call_BooksMyconfigGetUserSettings_589095(
    name: "booksMyconfigGetUserSettings", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/myconfig/getUserSettings",
    validator: validate_BooksMyconfigGetUserSettings_589096, base: "/books/v1",
    url: url_BooksMyconfigGetUserSettings_589097, schemes: {Scheme.Https})
type
  Call_BooksMyconfigReleaseDownloadAccess_589108 = ref object of OpenApiRestCall_588466
proc url_BooksMyconfigReleaseDownloadAccess_589110(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksMyconfigReleaseDownloadAccess_589109(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Release downloaded content access restriction.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   locale: JString
  ##         : ISO-639-1, ISO-3166-1 codes for message localization, i.e. en_US.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   cpksver: JString (required)
  ##          : The device/version ID from which to release the restriction.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   volumeIds: JArray (required)
  ##            : The volume(s) to release restrictions for.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589111 = query.getOrDefault("locale")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "locale", valid_589111
  var valid_589112 = query.getOrDefault("fields")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "fields", valid_589112
  var valid_589113 = query.getOrDefault("quotaUser")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "quotaUser", valid_589113
  var valid_589114 = query.getOrDefault("alt")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = newJString("json"))
  if valid_589114 != nil:
    section.add "alt", valid_589114
  var valid_589115 = query.getOrDefault("oauth_token")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "oauth_token", valid_589115
  assert query != nil, "query argument is necessary due to required `cpksver` field"
  var valid_589116 = query.getOrDefault("cpksver")
  valid_589116 = validateParameter(valid_589116, JString, required = true,
                                 default = nil)
  if valid_589116 != nil:
    section.add "cpksver", valid_589116
  var valid_589117 = query.getOrDefault("userIp")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "userIp", valid_589117
  var valid_589118 = query.getOrDefault("volumeIds")
  valid_589118 = validateParameter(valid_589118, JArray, required = true, default = nil)
  if valid_589118 != nil:
    section.add "volumeIds", valid_589118
  var valid_589119 = query.getOrDefault("source")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "source", valid_589119
  var valid_589120 = query.getOrDefault("key")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "key", valid_589120
  var valid_589121 = query.getOrDefault("prettyPrint")
  valid_589121 = validateParameter(valid_589121, JBool, required = false,
                                 default = newJBool(true))
  if valid_589121 != nil:
    section.add "prettyPrint", valid_589121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589122: Call_BooksMyconfigReleaseDownloadAccess_589108;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Release downloaded content access restriction.
  ## 
  let valid = call_589122.validator(path, query, header, formData, body)
  let scheme = call_589122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589122.url(scheme.get, call_589122.host, call_589122.base,
                         call_589122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589122, url, valid)

proc call*(call_589123: Call_BooksMyconfigReleaseDownloadAccess_589108;
          cpksver: string; volumeIds: JsonNode; locale: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; source: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## booksMyconfigReleaseDownloadAccess
  ## Release downloaded content access restriction.
  ##   locale: string
  ##         : ISO-639-1, ISO-3166-1 codes for message localization, i.e. en_US.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   cpksver: string (required)
  ##          : The device/version ID from which to release the restriction.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   volumeIds: JArray (required)
  ##            : The volume(s) to release restrictions for.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589124 = newJObject()
  add(query_589124, "locale", newJString(locale))
  add(query_589124, "fields", newJString(fields))
  add(query_589124, "quotaUser", newJString(quotaUser))
  add(query_589124, "alt", newJString(alt))
  add(query_589124, "oauth_token", newJString(oauthToken))
  add(query_589124, "cpksver", newJString(cpksver))
  add(query_589124, "userIp", newJString(userIp))
  if volumeIds != nil:
    query_589124.add "volumeIds", volumeIds
  add(query_589124, "source", newJString(source))
  add(query_589124, "key", newJString(key))
  add(query_589124, "prettyPrint", newJBool(prettyPrint))
  result = call_589123.call(nil, query_589124, nil, nil, nil)

var booksMyconfigReleaseDownloadAccess* = Call_BooksMyconfigReleaseDownloadAccess_589108(
    name: "booksMyconfigReleaseDownloadAccess", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/myconfig/releaseDownloadAccess",
    validator: validate_BooksMyconfigReleaseDownloadAccess_589109,
    base: "/books/v1", url: url_BooksMyconfigReleaseDownloadAccess_589110,
    schemes: {Scheme.Https})
type
  Call_BooksMyconfigRequestAccess_589125 = ref object of OpenApiRestCall_588466
proc url_BooksMyconfigRequestAccess_589127(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksMyconfigRequestAccess_589126(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Request concurrent and download access restrictions.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   locale: JString
  ##         : ISO-639-1, ISO-3166-1 codes for message localization, i.e. en_US.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   cpksver: JString (required)
  ##          : The device/version ID from which to request the restrictions.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   licenseTypes: JString
  ##               : The type of access license to request. If not specified, the default is BOTH.
  ##   nonce: JString (required)
  ##        : The client nonce value.
  ##   source: JString (required)
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   volumeId: JString (required)
  ##           : The volume to request concurrent/download restrictions for.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589128 = query.getOrDefault("locale")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "locale", valid_589128
  var valid_589129 = query.getOrDefault("fields")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "fields", valid_589129
  var valid_589130 = query.getOrDefault("quotaUser")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "quotaUser", valid_589130
  var valid_589131 = query.getOrDefault("alt")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = newJString("json"))
  if valid_589131 != nil:
    section.add "alt", valid_589131
  var valid_589132 = query.getOrDefault("oauth_token")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "oauth_token", valid_589132
  assert query != nil, "query argument is necessary due to required `cpksver` field"
  var valid_589133 = query.getOrDefault("cpksver")
  valid_589133 = validateParameter(valid_589133, JString, required = true,
                                 default = nil)
  if valid_589133 != nil:
    section.add "cpksver", valid_589133
  var valid_589134 = query.getOrDefault("userIp")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "userIp", valid_589134
  var valid_589135 = query.getOrDefault("licenseTypes")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = newJString("BOTH"))
  if valid_589135 != nil:
    section.add "licenseTypes", valid_589135
  var valid_589136 = query.getOrDefault("nonce")
  valid_589136 = validateParameter(valid_589136, JString, required = true,
                                 default = nil)
  if valid_589136 != nil:
    section.add "nonce", valid_589136
  var valid_589137 = query.getOrDefault("source")
  valid_589137 = validateParameter(valid_589137, JString, required = true,
                                 default = nil)
  if valid_589137 != nil:
    section.add "source", valid_589137
  var valid_589138 = query.getOrDefault("key")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "key", valid_589138
  var valid_589139 = query.getOrDefault("volumeId")
  valid_589139 = validateParameter(valid_589139, JString, required = true,
                                 default = nil)
  if valid_589139 != nil:
    section.add "volumeId", valid_589139
  var valid_589140 = query.getOrDefault("prettyPrint")
  valid_589140 = validateParameter(valid_589140, JBool, required = false,
                                 default = newJBool(true))
  if valid_589140 != nil:
    section.add "prettyPrint", valid_589140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589141: Call_BooksMyconfigRequestAccess_589125; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Request concurrent and download access restrictions.
  ## 
  let valid = call_589141.validator(path, query, header, formData, body)
  let scheme = call_589141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589141.url(scheme.get, call_589141.host, call_589141.base,
                         call_589141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589141, url, valid)

proc call*(call_589142: Call_BooksMyconfigRequestAccess_589125; cpksver: string;
          nonce: string; source: string; volumeId: string; locale: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; licenseTypes: string = "BOTH";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## booksMyconfigRequestAccess
  ## Request concurrent and download access restrictions.
  ##   locale: string
  ##         : ISO-639-1, ISO-3166-1 codes for message localization, i.e. en_US.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   cpksver: string (required)
  ##          : The device/version ID from which to request the restrictions.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   licenseTypes: string
  ##               : The type of access license to request. If not specified, the default is BOTH.
  ##   nonce: string (required)
  ##        : The client nonce value.
  ##   source: string (required)
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   volumeId: string (required)
  ##           : The volume to request concurrent/download restrictions for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589143 = newJObject()
  add(query_589143, "locale", newJString(locale))
  add(query_589143, "fields", newJString(fields))
  add(query_589143, "quotaUser", newJString(quotaUser))
  add(query_589143, "alt", newJString(alt))
  add(query_589143, "oauth_token", newJString(oauthToken))
  add(query_589143, "cpksver", newJString(cpksver))
  add(query_589143, "userIp", newJString(userIp))
  add(query_589143, "licenseTypes", newJString(licenseTypes))
  add(query_589143, "nonce", newJString(nonce))
  add(query_589143, "source", newJString(source))
  add(query_589143, "key", newJString(key))
  add(query_589143, "volumeId", newJString(volumeId))
  add(query_589143, "prettyPrint", newJBool(prettyPrint))
  result = call_589142.call(nil, query_589143, nil, nil, nil)

var booksMyconfigRequestAccess* = Call_BooksMyconfigRequestAccess_589125(
    name: "booksMyconfigRequestAccess", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/myconfig/requestAccess",
    validator: validate_BooksMyconfigRequestAccess_589126, base: "/books/v1",
    url: url_BooksMyconfigRequestAccess_589127, schemes: {Scheme.Https})
type
  Call_BooksMyconfigSyncVolumeLicenses_589144 = ref object of OpenApiRestCall_588466
proc url_BooksMyconfigSyncVolumeLicenses_589146(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksMyconfigSyncVolumeLicenses_589145(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Request downloaded content access for specified volumes on the My eBooks shelf.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   locale: JString
  ##         : ISO-639-1, ISO-3166-1 codes for message localization, i.e. en_US.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   cpksver: JString (required)
  ##          : The device/version ID from which to release the restriction.
  ##   includeNonComicsSeries: JBool
  ##                         : Set to true to include non-comics series. Defaults to false.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   nonce: JString (required)
  ##        : The client nonce value.
  ##   volumeIds: JArray
  ##            : The volume(s) to request download restrictions for.
  ##   source: JString (required)
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   features: JArray
  ##           : List of features supported by the client, i.e., 'RENTALS'
  ##   showPreorders: JBool
  ##                : Set to true to show pre-ordered books. Defaults to false.
  section = newJObject()
  var valid_589147 = query.getOrDefault("locale")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "locale", valid_589147
  var valid_589148 = query.getOrDefault("fields")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "fields", valid_589148
  var valid_589149 = query.getOrDefault("quotaUser")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "quotaUser", valid_589149
  var valid_589150 = query.getOrDefault("alt")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = newJString("json"))
  if valid_589150 != nil:
    section.add "alt", valid_589150
  var valid_589151 = query.getOrDefault("oauth_token")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "oauth_token", valid_589151
  assert query != nil, "query argument is necessary due to required `cpksver` field"
  var valid_589152 = query.getOrDefault("cpksver")
  valid_589152 = validateParameter(valid_589152, JString, required = true,
                                 default = nil)
  if valid_589152 != nil:
    section.add "cpksver", valid_589152
  var valid_589153 = query.getOrDefault("includeNonComicsSeries")
  valid_589153 = validateParameter(valid_589153, JBool, required = false, default = nil)
  if valid_589153 != nil:
    section.add "includeNonComicsSeries", valid_589153
  var valid_589154 = query.getOrDefault("userIp")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "userIp", valid_589154
  var valid_589155 = query.getOrDefault("nonce")
  valid_589155 = validateParameter(valid_589155, JString, required = true,
                                 default = nil)
  if valid_589155 != nil:
    section.add "nonce", valid_589155
  var valid_589156 = query.getOrDefault("volumeIds")
  valid_589156 = validateParameter(valid_589156, JArray, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "volumeIds", valid_589156
  var valid_589157 = query.getOrDefault("source")
  valid_589157 = validateParameter(valid_589157, JString, required = true,
                                 default = nil)
  if valid_589157 != nil:
    section.add "source", valid_589157
  var valid_589158 = query.getOrDefault("key")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "key", valid_589158
  var valid_589159 = query.getOrDefault("prettyPrint")
  valid_589159 = validateParameter(valid_589159, JBool, required = false,
                                 default = newJBool(true))
  if valid_589159 != nil:
    section.add "prettyPrint", valid_589159
  var valid_589160 = query.getOrDefault("features")
  valid_589160 = validateParameter(valid_589160, JArray, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "features", valid_589160
  var valid_589161 = query.getOrDefault("showPreorders")
  valid_589161 = validateParameter(valid_589161, JBool, required = false, default = nil)
  if valid_589161 != nil:
    section.add "showPreorders", valid_589161
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589162: Call_BooksMyconfigSyncVolumeLicenses_589144;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Request downloaded content access for specified volumes on the My eBooks shelf.
  ## 
  let valid = call_589162.validator(path, query, header, formData, body)
  let scheme = call_589162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589162.url(scheme.get, call_589162.host, call_589162.base,
                         call_589162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589162, url, valid)

proc call*(call_589163: Call_BooksMyconfigSyncVolumeLicenses_589144;
          cpksver: string; nonce: string; source: string; locale: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; includeNonComicsSeries: bool = false;
          userIp: string = ""; volumeIds: JsonNode = nil; key: string = "";
          prettyPrint: bool = true; features: JsonNode = nil;
          showPreorders: bool = false): Recallable =
  ## booksMyconfigSyncVolumeLicenses
  ## Request downloaded content access for specified volumes on the My eBooks shelf.
  ##   locale: string
  ##         : ISO-639-1, ISO-3166-1 codes for message localization, i.e. en_US.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   cpksver: string (required)
  ##          : The device/version ID from which to release the restriction.
  ##   includeNonComicsSeries: bool
  ##                         : Set to true to include non-comics series. Defaults to false.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   nonce: string (required)
  ##        : The client nonce value.
  ##   volumeIds: JArray
  ##            : The volume(s) to request download restrictions for.
  ##   source: string (required)
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   features: JArray
  ##           : List of features supported by the client, i.e., 'RENTALS'
  ##   showPreorders: bool
  ##                : Set to true to show pre-ordered books. Defaults to false.
  var query_589164 = newJObject()
  add(query_589164, "locale", newJString(locale))
  add(query_589164, "fields", newJString(fields))
  add(query_589164, "quotaUser", newJString(quotaUser))
  add(query_589164, "alt", newJString(alt))
  add(query_589164, "oauth_token", newJString(oauthToken))
  add(query_589164, "cpksver", newJString(cpksver))
  add(query_589164, "includeNonComicsSeries", newJBool(includeNonComicsSeries))
  add(query_589164, "userIp", newJString(userIp))
  add(query_589164, "nonce", newJString(nonce))
  if volumeIds != nil:
    query_589164.add "volumeIds", volumeIds
  add(query_589164, "source", newJString(source))
  add(query_589164, "key", newJString(key))
  add(query_589164, "prettyPrint", newJBool(prettyPrint))
  if features != nil:
    query_589164.add "features", features
  add(query_589164, "showPreorders", newJBool(showPreorders))
  result = call_589163.call(nil, query_589164, nil, nil, nil)

var booksMyconfigSyncVolumeLicenses* = Call_BooksMyconfigSyncVolumeLicenses_589144(
    name: "booksMyconfigSyncVolumeLicenses", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/myconfig/syncVolumeLicenses",
    validator: validate_BooksMyconfigSyncVolumeLicenses_589145, base: "/books/v1",
    url: url_BooksMyconfigSyncVolumeLicenses_589146, schemes: {Scheme.Https})
type
  Call_BooksMyconfigUpdateUserSettings_589165 = ref object of OpenApiRestCall_588466
proc url_BooksMyconfigUpdateUserSettings_589167(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksMyconfigUpdateUserSettings_589166(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the settings for the user. If a sub-object is specified, it will overwrite the existing sub-object stored in the server. Unspecified sub-objects will retain the existing value.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589168 = query.getOrDefault("fields")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "fields", valid_589168
  var valid_589169 = query.getOrDefault("quotaUser")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "quotaUser", valid_589169
  var valid_589170 = query.getOrDefault("alt")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = newJString("json"))
  if valid_589170 != nil:
    section.add "alt", valid_589170
  var valid_589171 = query.getOrDefault("oauth_token")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "oauth_token", valid_589171
  var valid_589172 = query.getOrDefault("userIp")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "userIp", valid_589172
  var valid_589173 = query.getOrDefault("key")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "key", valid_589173
  var valid_589174 = query.getOrDefault("prettyPrint")
  valid_589174 = validateParameter(valid_589174, JBool, required = false,
                                 default = newJBool(true))
  if valid_589174 != nil:
    section.add "prettyPrint", valid_589174
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589176: Call_BooksMyconfigUpdateUserSettings_589165;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the settings for the user. If a sub-object is specified, it will overwrite the existing sub-object stored in the server. Unspecified sub-objects will retain the existing value.
  ## 
  let valid = call_589176.validator(path, query, header, formData, body)
  let scheme = call_589176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589176.url(scheme.get, call_589176.host, call_589176.base,
                         call_589176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589176, url, valid)

proc call*(call_589177: Call_BooksMyconfigUpdateUserSettings_589165;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## booksMyconfigUpdateUserSettings
  ## Sets the settings for the user. If a sub-object is specified, it will overwrite the existing sub-object stored in the server. Unspecified sub-objects will retain the existing value.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589178 = newJObject()
  var body_589179 = newJObject()
  add(query_589178, "fields", newJString(fields))
  add(query_589178, "quotaUser", newJString(quotaUser))
  add(query_589178, "alt", newJString(alt))
  add(query_589178, "oauth_token", newJString(oauthToken))
  add(query_589178, "userIp", newJString(userIp))
  add(query_589178, "key", newJString(key))
  if body != nil:
    body_589179 = body
  add(query_589178, "prettyPrint", newJBool(prettyPrint))
  result = call_589177.call(nil, query_589178, nil, nil, body_589179)

var booksMyconfigUpdateUserSettings* = Call_BooksMyconfigUpdateUserSettings_589165(
    name: "booksMyconfigUpdateUserSettings", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/myconfig/updateUserSettings",
    validator: validate_BooksMyconfigUpdateUserSettings_589166, base: "/books/v1",
    url: url_BooksMyconfigUpdateUserSettings_589167, schemes: {Scheme.Https})
type
  Call_BooksMylibraryAnnotationsInsert_589203 = ref object of OpenApiRestCall_588466
proc url_BooksMylibraryAnnotationsInsert_589205(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksMylibraryAnnotationsInsert_589204(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts a new annotation.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   country: JString
  ##          : ISO-3166-1 code to override the IP-based location.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   showOnlySummaryInResponse: JBool
  ##                            : Requests that only the summary of the specified layer be provided in the response.
  ##   annotationId: JString
  ##               : The ID for the annotation to insert.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589206 = query.getOrDefault("fields")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "fields", valid_589206
  var valid_589207 = query.getOrDefault("country")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "country", valid_589207
  var valid_589208 = query.getOrDefault("quotaUser")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "quotaUser", valid_589208
  var valid_589209 = query.getOrDefault("alt")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = newJString("json"))
  if valid_589209 != nil:
    section.add "alt", valid_589209
  var valid_589210 = query.getOrDefault("showOnlySummaryInResponse")
  valid_589210 = validateParameter(valid_589210, JBool, required = false, default = nil)
  if valid_589210 != nil:
    section.add "showOnlySummaryInResponse", valid_589210
  var valid_589211 = query.getOrDefault("annotationId")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "annotationId", valid_589211
  var valid_589212 = query.getOrDefault("oauth_token")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = nil)
  if valid_589212 != nil:
    section.add "oauth_token", valid_589212
  var valid_589213 = query.getOrDefault("userIp")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "userIp", valid_589213
  var valid_589214 = query.getOrDefault("source")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "source", valid_589214
  var valid_589215 = query.getOrDefault("key")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "key", valid_589215
  var valid_589216 = query.getOrDefault("prettyPrint")
  valid_589216 = validateParameter(valid_589216, JBool, required = false,
                                 default = newJBool(true))
  if valid_589216 != nil:
    section.add "prettyPrint", valid_589216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589218: Call_BooksMylibraryAnnotationsInsert_589203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a new annotation.
  ## 
  let valid = call_589218.validator(path, query, header, formData, body)
  let scheme = call_589218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589218.url(scheme.get, call_589218.host, call_589218.base,
                         call_589218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589218, url, valid)

proc call*(call_589219: Call_BooksMylibraryAnnotationsInsert_589203;
          fields: string = ""; country: string = ""; quotaUser: string = "";
          alt: string = "json"; showOnlySummaryInResponse: bool = false;
          annotationId: string = ""; oauthToken: string = ""; userIp: string = "";
          source: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## booksMylibraryAnnotationsInsert
  ## Inserts a new annotation.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   country: string
  ##          : ISO-3166-1 code to override the IP-based location.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   showOnlySummaryInResponse: bool
  ##                            : Requests that only the summary of the specified layer be provided in the response.
  ##   annotationId: string
  ##               : The ID for the annotation to insert.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589220 = newJObject()
  var body_589221 = newJObject()
  add(query_589220, "fields", newJString(fields))
  add(query_589220, "country", newJString(country))
  add(query_589220, "quotaUser", newJString(quotaUser))
  add(query_589220, "alt", newJString(alt))
  add(query_589220, "showOnlySummaryInResponse",
      newJBool(showOnlySummaryInResponse))
  add(query_589220, "annotationId", newJString(annotationId))
  add(query_589220, "oauth_token", newJString(oauthToken))
  add(query_589220, "userIp", newJString(userIp))
  add(query_589220, "source", newJString(source))
  add(query_589220, "key", newJString(key))
  if body != nil:
    body_589221 = body
  add(query_589220, "prettyPrint", newJBool(prettyPrint))
  result = call_589219.call(nil, query_589220, nil, nil, body_589221)

var booksMylibraryAnnotationsInsert* = Call_BooksMylibraryAnnotationsInsert_589203(
    name: "booksMylibraryAnnotationsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/mylibrary/annotations",
    validator: validate_BooksMylibraryAnnotationsInsert_589204, base: "/books/v1",
    url: url_BooksMylibraryAnnotationsInsert_589205, schemes: {Scheme.Https})
type
  Call_BooksMylibraryAnnotationsList_589180 = ref object of OpenApiRestCall_588466
proc url_BooksMylibraryAnnotationsList_589182(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksMylibraryAnnotationsList_589181(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of annotations, possibly filtered.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   layerIds: JArray
  ##           : The layer ID(s) to limit annotation by.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The value of the nextToken from the previous page.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   updatedMax: JString
  ##             : RFC 3339 timestamp to restrict to items updated prior to this timestamp (exclusive).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   layerId: JString
  ##          : The layer ID to limit annotation by.
  ##   maxResults: JInt
  ##             : Maximum number of results to return
  ##   contentVersion: JString
  ##                 : The content version for the requested volume.
  ##   showDeleted: JBool
  ##              : Set to true to return deleted annotations. updatedMin must be in the request to use this. Defaults to false.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   updatedMin: JString
  ##             : RFC 3339 timestamp to restrict to items updated since this timestamp (inclusive).
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   volumeId: JString
  ##           : The volume to restrict annotations to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589183 = query.getOrDefault("layerIds")
  valid_589183 = validateParameter(valid_589183, JArray, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "layerIds", valid_589183
  var valid_589184 = query.getOrDefault("fields")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "fields", valid_589184
  var valid_589185 = query.getOrDefault("pageToken")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "pageToken", valid_589185
  var valid_589186 = query.getOrDefault("quotaUser")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "quotaUser", valid_589186
  var valid_589187 = query.getOrDefault("alt")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = newJString("json"))
  if valid_589187 != nil:
    section.add "alt", valid_589187
  var valid_589188 = query.getOrDefault("updatedMax")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "updatedMax", valid_589188
  var valid_589189 = query.getOrDefault("oauth_token")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "oauth_token", valid_589189
  var valid_589190 = query.getOrDefault("userIp")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "userIp", valid_589190
  var valid_589191 = query.getOrDefault("layerId")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "layerId", valid_589191
  var valid_589192 = query.getOrDefault("maxResults")
  valid_589192 = validateParameter(valid_589192, JInt, required = false, default = nil)
  if valid_589192 != nil:
    section.add "maxResults", valid_589192
  var valid_589193 = query.getOrDefault("contentVersion")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "contentVersion", valid_589193
  var valid_589194 = query.getOrDefault("showDeleted")
  valid_589194 = validateParameter(valid_589194, JBool, required = false, default = nil)
  if valid_589194 != nil:
    section.add "showDeleted", valid_589194
  var valid_589195 = query.getOrDefault("source")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "source", valid_589195
  var valid_589196 = query.getOrDefault("updatedMin")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "updatedMin", valid_589196
  var valid_589197 = query.getOrDefault("key")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "key", valid_589197
  var valid_589198 = query.getOrDefault("volumeId")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "volumeId", valid_589198
  var valid_589199 = query.getOrDefault("prettyPrint")
  valid_589199 = validateParameter(valid_589199, JBool, required = false,
                                 default = newJBool(true))
  if valid_589199 != nil:
    section.add "prettyPrint", valid_589199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589200: Call_BooksMylibraryAnnotationsList_589180; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of annotations, possibly filtered.
  ## 
  let valid = call_589200.validator(path, query, header, formData, body)
  let scheme = call_589200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589200.url(scheme.get, call_589200.host, call_589200.base,
                         call_589200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589200, url, valid)

proc call*(call_589201: Call_BooksMylibraryAnnotationsList_589180;
          layerIds: JsonNode = nil; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; updatedMax: string = "";
          oauthToken: string = ""; userIp: string = ""; layerId: string = "";
          maxResults: int = 0; contentVersion: string = ""; showDeleted: bool = false;
          source: string = ""; updatedMin: string = ""; key: string = "";
          volumeId: string = ""; prettyPrint: bool = true): Recallable =
  ## booksMylibraryAnnotationsList
  ## Retrieves a list of annotations, possibly filtered.
  ##   layerIds: JArray
  ##           : The layer ID(s) to limit annotation by.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The value of the nextToken from the previous page.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   updatedMax: string
  ##             : RFC 3339 timestamp to restrict to items updated prior to this timestamp (exclusive).
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   layerId: string
  ##          : The layer ID to limit annotation by.
  ##   maxResults: int
  ##             : Maximum number of results to return
  ##   contentVersion: string
  ##                 : The content version for the requested volume.
  ##   showDeleted: bool
  ##              : Set to true to return deleted annotations. updatedMin must be in the request to use this. Defaults to false.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   updatedMin: string
  ##             : RFC 3339 timestamp to restrict to items updated since this timestamp (inclusive).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   volumeId: string
  ##           : The volume to restrict annotations to.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589202 = newJObject()
  if layerIds != nil:
    query_589202.add "layerIds", layerIds
  add(query_589202, "fields", newJString(fields))
  add(query_589202, "pageToken", newJString(pageToken))
  add(query_589202, "quotaUser", newJString(quotaUser))
  add(query_589202, "alt", newJString(alt))
  add(query_589202, "updatedMax", newJString(updatedMax))
  add(query_589202, "oauth_token", newJString(oauthToken))
  add(query_589202, "userIp", newJString(userIp))
  add(query_589202, "layerId", newJString(layerId))
  add(query_589202, "maxResults", newJInt(maxResults))
  add(query_589202, "contentVersion", newJString(contentVersion))
  add(query_589202, "showDeleted", newJBool(showDeleted))
  add(query_589202, "source", newJString(source))
  add(query_589202, "updatedMin", newJString(updatedMin))
  add(query_589202, "key", newJString(key))
  add(query_589202, "volumeId", newJString(volumeId))
  add(query_589202, "prettyPrint", newJBool(prettyPrint))
  result = call_589201.call(nil, query_589202, nil, nil, nil)

var booksMylibraryAnnotationsList* = Call_BooksMylibraryAnnotationsList_589180(
    name: "booksMylibraryAnnotationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/mylibrary/annotations",
    validator: validate_BooksMylibraryAnnotationsList_589181, base: "/books/v1",
    url: url_BooksMylibraryAnnotationsList_589182, schemes: {Scheme.Https})
type
  Call_BooksMylibraryAnnotationsSummary_589222 = ref object of OpenApiRestCall_588466
proc url_BooksMylibraryAnnotationsSummary_589224(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksMylibraryAnnotationsSummary_589223(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the summary of specified layers.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   layerIds: JArray (required)
  ##           : Array of layer IDs to get the summary for.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   volumeId: JString (required)
  ##           : Volume id to get the summary for.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `layerIds` field"
  var valid_589225 = query.getOrDefault("layerIds")
  valid_589225 = validateParameter(valid_589225, JArray, required = true, default = nil)
  if valid_589225 != nil:
    section.add "layerIds", valid_589225
  var valid_589226 = query.getOrDefault("fields")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "fields", valid_589226
  var valid_589227 = query.getOrDefault("quotaUser")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "quotaUser", valid_589227
  var valid_589228 = query.getOrDefault("alt")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = newJString("json"))
  if valid_589228 != nil:
    section.add "alt", valid_589228
  var valid_589229 = query.getOrDefault("oauth_token")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = nil)
  if valid_589229 != nil:
    section.add "oauth_token", valid_589229
  var valid_589230 = query.getOrDefault("userIp")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "userIp", valid_589230
  var valid_589231 = query.getOrDefault("key")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "key", valid_589231
  var valid_589232 = query.getOrDefault("volumeId")
  valid_589232 = validateParameter(valid_589232, JString, required = true,
                                 default = nil)
  if valid_589232 != nil:
    section.add "volumeId", valid_589232
  var valid_589233 = query.getOrDefault("prettyPrint")
  valid_589233 = validateParameter(valid_589233, JBool, required = false,
                                 default = newJBool(true))
  if valid_589233 != nil:
    section.add "prettyPrint", valid_589233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589234: Call_BooksMylibraryAnnotationsSummary_589222;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the summary of specified layers.
  ## 
  let valid = call_589234.validator(path, query, header, formData, body)
  let scheme = call_589234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589234.url(scheme.get, call_589234.host, call_589234.base,
                         call_589234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589234, url, valid)

proc call*(call_589235: Call_BooksMylibraryAnnotationsSummary_589222;
          layerIds: JsonNode; volumeId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## booksMylibraryAnnotationsSummary
  ## Gets the summary of specified layers.
  ##   layerIds: JArray (required)
  ##           : Array of layer IDs to get the summary for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   volumeId: string (required)
  ##           : Volume id to get the summary for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589236 = newJObject()
  if layerIds != nil:
    query_589236.add "layerIds", layerIds
  add(query_589236, "fields", newJString(fields))
  add(query_589236, "quotaUser", newJString(quotaUser))
  add(query_589236, "alt", newJString(alt))
  add(query_589236, "oauth_token", newJString(oauthToken))
  add(query_589236, "userIp", newJString(userIp))
  add(query_589236, "key", newJString(key))
  add(query_589236, "volumeId", newJString(volumeId))
  add(query_589236, "prettyPrint", newJBool(prettyPrint))
  result = call_589235.call(nil, query_589236, nil, nil, nil)

var booksMylibraryAnnotationsSummary* = Call_BooksMylibraryAnnotationsSummary_589222(
    name: "booksMylibraryAnnotationsSummary", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/mylibrary/annotations/summary",
    validator: validate_BooksMylibraryAnnotationsSummary_589223,
    base: "/books/v1", url: url_BooksMylibraryAnnotationsSummary_589224,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryAnnotationsUpdate_589237 = ref object of OpenApiRestCall_588466
proc url_BooksMylibraryAnnotationsUpdate_589239(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "annotationId" in path, "`annotationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/mylibrary/annotations/"),
               (kind: VariableSegment, value: "annotationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BooksMylibraryAnnotationsUpdate_589238(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing annotation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   annotationId: JString (required)
  ##               : The ID for the annotation to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `annotationId` field"
  var valid_589254 = path.getOrDefault("annotationId")
  valid_589254 = validateParameter(valid_589254, JString, required = true,
                                 default = nil)
  if valid_589254 != nil:
    section.add "annotationId", valid_589254
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589255 = query.getOrDefault("fields")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = nil)
  if valid_589255 != nil:
    section.add "fields", valid_589255
  var valid_589256 = query.getOrDefault("quotaUser")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = nil)
  if valid_589256 != nil:
    section.add "quotaUser", valid_589256
  var valid_589257 = query.getOrDefault("alt")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = newJString("json"))
  if valid_589257 != nil:
    section.add "alt", valid_589257
  var valid_589258 = query.getOrDefault("oauth_token")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "oauth_token", valid_589258
  var valid_589259 = query.getOrDefault("userIp")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = nil)
  if valid_589259 != nil:
    section.add "userIp", valid_589259
  var valid_589260 = query.getOrDefault("source")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = nil)
  if valid_589260 != nil:
    section.add "source", valid_589260
  var valid_589261 = query.getOrDefault("key")
  valid_589261 = validateParameter(valid_589261, JString, required = false,
                                 default = nil)
  if valid_589261 != nil:
    section.add "key", valid_589261
  var valid_589262 = query.getOrDefault("prettyPrint")
  valid_589262 = validateParameter(valid_589262, JBool, required = false,
                                 default = newJBool(true))
  if valid_589262 != nil:
    section.add "prettyPrint", valid_589262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589264: Call_BooksMylibraryAnnotationsUpdate_589237;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing annotation.
  ## 
  let valid = call_589264.validator(path, query, header, formData, body)
  let scheme = call_589264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589264.url(scheme.get, call_589264.host, call_589264.base,
                         call_589264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589264, url, valid)

proc call*(call_589265: Call_BooksMylibraryAnnotationsUpdate_589237;
          annotationId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          source: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## booksMylibraryAnnotationsUpdate
  ## Updates an existing annotation.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   annotationId: string (required)
  ##               : The ID for the annotation to update.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589266 = newJObject()
  var query_589267 = newJObject()
  var body_589268 = newJObject()
  add(query_589267, "fields", newJString(fields))
  add(query_589267, "quotaUser", newJString(quotaUser))
  add(query_589267, "alt", newJString(alt))
  add(query_589267, "oauth_token", newJString(oauthToken))
  add(path_589266, "annotationId", newJString(annotationId))
  add(query_589267, "userIp", newJString(userIp))
  add(query_589267, "source", newJString(source))
  add(query_589267, "key", newJString(key))
  if body != nil:
    body_589268 = body
  add(query_589267, "prettyPrint", newJBool(prettyPrint))
  result = call_589265.call(path_589266, query_589267, nil, nil, body_589268)

var booksMylibraryAnnotationsUpdate* = Call_BooksMylibraryAnnotationsUpdate_589237(
    name: "booksMylibraryAnnotationsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/mylibrary/annotations/{annotationId}",
    validator: validate_BooksMylibraryAnnotationsUpdate_589238, base: "/books/v1",
    url: url_BooksMylibraryAnnotationsUpdate_589239, schemes: {Scheme.Https})
type
  Call_BooksMylibraryAnnotationsDelete_589269 = ref object of OpenApiRestCall_588466
proc url_BooksMylibraryAnnotationsDelete_589271(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "annotationId" in path, "`annotationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/mylibrary/annotations/"),
               (kind: VariableSegment, value: "annotationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BooksMylibraryAnnotationsDelete_589270(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an annotation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   annotationId: JString (required)
  ##               : The ID for the annotation to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `annotationId` field"
  var valid_589272 = path.getOrDefault("annotationId")
  valid_589272 = validateParameter(valid_589272, JString, required = true,
                                 default = nil)
  if valid_589272 != nil:
    section.add "annotationId", valid_589272
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589273 = query.getOrDefault("fields")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = nil)
  if valid_589273 != nil:
    section.add "fields", valid_589273
  var valid_589274 = query.getOrDefault("quotaUser")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = nil)
  if valid_589274 != nil:
    section.add "quotaUser", valid_589274
  var valid_589275 = query.getOrDefault("alt")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = newJString("json"))
  if valid_589275 != nil:
    section.add "alt", valid_589275
  var valid_589276 = query.getOrDefault("oauth_token")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = nil)
  if valid_589276 != nil:
    section.add "oauth_token", valid_589276
  var valid_589277 = query.getOrDefault("userIp")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = nil)
  if valid_589277 != nil:
    section.add "userIp", valid_589277
  var valid_589278 = query.getOrDefault("source")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = nil)
  if valid_589278 != nil:
    section.add "source", valid_589278
  var valid_589279 = query.getOrDefault("key")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "key", valid_589279
  var valid_589280 = query.getOrDefault("prettyPrint")
  valid_589280 = validateParameter(valid_589280, JBool, required = false,
                                 default = newJBool(true))
  if valid_589280 != nil:
    section.add "prettyPrint", valid_589280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589281: Call_BooksMylibraryAnnotationsDelete_589269;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an annotation.
  ## 
  let valid = call_589281.validator(path, query, header, formData, body)
  let scheme = call_589281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589281.url(scheme.get, call_589281.host, call_589281.base,
                         call_589281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589281, url, valid)

proc call*(call_589282: Call_BooksMylibraryAnnotationsDelete_589269;
          annotationId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          source: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## booksMylibraryAnnotationsDelete
  ## Deletes an annotation.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   annotationId: string (required)
  ##               : The ID for the annotation to delete.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589283 = newJObject()
  var query_589284 = newJObject()
  add(query_589284, "fields", newJString(fields))
  add(query_589284, "quotaUser", newJString(quotaUser))
  add(query_589284, "alt", newJString(alt))
  add(query_589284, "oauth_token", newJString(oauthToken))
  add(path_589283, "annotationId", newJString(annotationId))
  add(query_589284, "userIp", newJString(userIp))
  add(query_589284, "source", newJString(source))
  add(query_589284, "key", newJString(key))
  add(query_589284, "prettyPrint", newJBool(prettyPrint))
  result = call_589282.call(path_589283, query_589284, nil, nil, nil)

var booksMylibraryAnnotationsDelete* = Call_BooksMylibraryAnnotationsDelete_589269(
    name: "booksMylibraryAnnotationsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/mylibrary/annotations/{annotationId}",
    validator: validate_BooksMylibraryAnnotationsDelete_589270, base: "/books/v1",
    url: url_BooksMylibraryAnnotationsDelete_589271, schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesList_589285 = ref object of OpenApiRestCall_588466
proc url_BooksMylibraryBookshelvesList_589287(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksMylibraryBookshelvesList_589286(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of bookshelves belonging to the authenticated user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589288 = query.getOrDefault("fields")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = nil)
  if valid_589288 != nil:
    section.add "fields", valid_589288
  var valid_589289 = query.getOrDefault("quotaUser")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "quotaUser", valid_589289
  var valid_589290 = query.getOrDefault("alt")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = newJString("json"))
  if valid_589290 != nil:
    section.add "alt", valid_589290
  var valid_589291 = query.getOrDefault("oauth_token")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = nil)
  if valid_589291 != nil:
    section.add "oauth_token", valid_589291
  var valid_589292 = query.getOrDefault("userIp")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = nil)
  if valid_589292 != nil:
    section.add "userIp", valid_589292
  var valid_589293 = query.getOrDefault("source")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "source", valid_589293
  var valid_589294 = query.getOrDefault("key")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "key", valid_589294
  var valid_589295 = query.getOrDefault("prettyPrint")
  valid_589295 = validateParameter(valid_589295, JBool, required = false,
                                 default = newJBool(true))
  if valid_589295 != nil:
    section.add "prettyPrint", valid_589295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589296: Call_BooksMylibraryBookshelvesList_589285; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of bookshelves belonging to the authenticated user.
  ## 
  let valid = call_589296.validator(path, query, header, formData, body)
  let scheme = call_589296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589296.url(scheme.get, call_589296.host, call_589296.base,
                         call_589296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589296, url, valid)

proc call*(call_589297: Call_BooksMylibraryBookshelvesList_589285;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; source: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## booksMylibraryBookshelvesList
  ## Retrieves a list of bookshelves belonging to the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589298 = newJObject()
  add(query_589298, "fields", newJString(fields))
  add(query_589298, "quotaUser", newJString(quotaUser))
  add(query_589298, "alt", newJString(alt))
  add(query_589298, "oauth_token", newJString(oauthToken))
  add(query_589298, "userIp", newJString(userIp))
  add(query_589298, "source", newJString(source))
  add(query_589298, "key", newJString(key))
  add(query_589298, "prettyPrint", newJBool(prettyPrint))
  result = call_589297.call(nil, query_589298, nil, nil, nil)

var booksMylibraryBookshelvesList* = Call_BooksMylibraryBookshelvesList_589285(
    name: "booksMylibraryBookshelvesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/mylibrary/bookshelves",
    validator: validate_BooksMylibraryBookshelvesList_589286, base: "/books/v1",
    url: url_BooksMylibraryBookshelvesList_589287, schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesGet_589299 = ref object of OpenApiRestCall_588466
proc url_BooksMylibraryBookshelvesGet_589301(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "shelf" in path, "`shelf` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/mylibrary/bookshelves/"),
               (kind: VariableSegment, value: "shelf")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BooksMylibraryBookshelvesGet_589300(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves metadata for a specific bookshelf belonging to the authenticated user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   shelf: JString (required)
  ##        : ID of bookshelf to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `shelf` field"
  var valid_589302 = path.getOrDefault("shelf")
  valid_589302 = validateParameter(valid_589302, JString, required = true,
                                 default = nil)
  if valid_589302 != nil:
    section.add "shelf", valid_589302
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589303 = query.getOrDefault("fields")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = nil)
  if valid_589303 != nil:
    section.add "fields", valid_589303
  var valid_589304 = query.getOrDefault("quotaUser")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = nil)
  if valid_589304 != nil:
    section.add "quotaUser", valid_589304
  var valid_589305 = query.getOrDefault("alt")
  valid_589305 = validateParameter(valid_589305, JString, required = false,
                                 default = newJString("json"))
  if valid_589305 != nil:
    section.add "alt", valid_589305
  var valid_589306 = query.getOrDefault("oauth_token")
  valid_589306 = validateParameter(valid_589306, JString, required = false,
                                 default = nil)
  if valid_589306 != nil:
    section.add "oauth_token", valid_589306
  var valid_589307 = query.getOrDefault("userIp")
  valid_589307 = validateParameter(valid_589307, JString, required = false,
                                 default = nil)
  if valid_589307 != nil:
    section.add "userIp", valid_589307
  var valid_589308 = query.getOrDefault("source")
  valid_589308 = validateParameter(valid_589308, JString, required = false,
                                 default = nil)
  if valid_589308 != nil:
    section.add "source", valid_589308
  var valid_589309 = query.getOrDefault("key")
  valid_589309 = validateParameter(valid_589309, JString, required = false,
                                 default = nil)
  if valid_589309 != nil:
    section.add "key", valid_589309
  var valid_589310 = query.getOrDefault("prettyPrint")
  valid_589310 = validateParameter(valid_589310, JBool, required = false,
                                 default = newJBool(true))
  if valid_589310 != nil:
    section.add "prettyPrint", valid_589310
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589311: Call_BooksMylibraryBookshelvesGet_589299; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves metadata for a specific bookshelf belonging to the authenticated user.
  ## 
  let valid = call_589311.validator(path, query, header, formData, body)
  let scheme = call_589311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589311.url(scheme.get, call_589311.host, call_589311.base,
                         call_589311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589311, url, valid)

proc call*(call_589312: Call_BooksMylibraryBookshelvesGet_589299; shelf: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; source: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## booksMylibraryBookshelvesGet
  ## Retrieves metadata for a specific bookshelf belonging to the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   shelf: string (required)
  ##        : ID of bookshelf to retrieve.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589313 = newJObject()
  var query_589314 = newJObject()
  add(query_589314, "fields", newJString(fields))
  add(query_589314, "quotaUser", newJString(quotaUser))
  add(query_589314, "alt", newJString(alt))
  add(query_589314, "oauth_token", newJString(oauthToken))
  add(query_589314, "userIp", newJString(userIp))
  add(path_589313, "shelf", newJString(shelf))
  add(query_589314, "source", newJString(source))
  add(query_589314, "key", newJString(key))
  add(query_589314, "prettyPrint", newJBool(prettyPrint))
  result = call_589312.call(path_589313, query_589314, nil, nil, nil)

var booksMylibraryBookshelvesGet* = Call_BooksMylibraryBookshelvesGet_589299(
    name: "booksMylibraryBookshelvesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/mylibrary/bookshelves/{shelf}",
    validator: validate_BooksMylibraryBookshelvesGet_589300, base: "/books/v1",
    url: url_BooksMylibraryBookshelvesGet_589301, schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesAddVolume_589315 = ref object of OpenApiRestCall_588466
proc url_BooksMylibraryBookshelvesAddVolume_589317(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "shelf" in path, "`shelf` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/mylibrary/bookshelves/"),
               (kind: VariableSegment, value: "shelf"),
               (kind: ConstantSegment, value: "/addVolume")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BooksMylibraryBookshelvesAddVolume_589316(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a volume to a bookshelf.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   shelf: JString (required)
  ##        : ID of bookshelf to which to add a volume.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `shelf` field"
  var valid_589318 = path.getOrDefault("shelf")
  valid_589318 = validateParameter(valid_589318, JString, required = true,
                                 default = nil)
  if valid_589318 != nil:
    section.add "shelf", valid_589318
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   volumeId: JString (required)
  ##           : ID of volume to add.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   reason: JString
  ##         : The reason for which the book is added to the library.
  section = newJObject()
  var valid_589319 = query.getOrDefault("fields")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = nil)
  if valid_589319 != nil:
    section.add "fields", valid_589319
  var valid_589320 = query.getOrDefault("quotaUser")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "quotaUser", valid_589320
  var valid_589321 = query.getOrDefault("alt")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = newJString("json"))
  if valid_589321 != nil:
    section.add "alt", valid_589321
  var valid_589322 = query.getOrDefault("oauth_token")
  valid_589322 = validateParameter(valid_589322, JString, required = false,
                                 default = nil)
  if valid_589322 != nil:
    section.add "oauth_token", valid_589322
  var valid_589323 = query.getOrDefault("userIp")
  valid_589323 = validateParameter(valid_589323, JString, required = false,
                                 default = nil)
  if valid_589323 != nil:
    section.add "userIp", valid_589323
  var valid_589324 = query.getOrDefault("source")
  valid_589324 = validateParameter(valid_589324, JString, required = false,
                                 default = nil)
  if valid_589324 != nil:
    section.add "source", valid_589324
  var valid_589325 = query.getOrDefault("key")
  valid_589325 = validateParameter(valid_589325, JString, required = false,
                                 default = nil)
  if valid_589325 != nil:
    section.add "key", valid_589325
  assert query != nil,
        "query argument is necessary due to required `volumeId` field"
  var valid_589326 = query.getOrDefault("volumeId")
  valid_589326 = validateParameter(valid_589326, JString, required = true,
                                 default = nil)
  if valid_589326 != nil:
    section.add "volumeId", valid_589326
  var valid_589327 = query.getOrDefault("prettyPrint")
  valid_589327 = validateParameter(valid_589327, JBool, required = false,
                                 default = newJBool(true))
  if valid_589327 != nil:
    section.add "prettyPrint", valid_589327
  var valid_589328 = query.getOrDefault("reason")
  valid_589328 = validateParameter(valid_589328, JString, required = false,
                                 default = newJString("IOS_PREX"))
  if valid_589328 != nil:
    section.add "reason", valid_589328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589329: Call_BooksMylibraryBookshelvesAddVolume_589315;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a volume to a bookshelf.
  ## 
  let valid = call_589329.validator(path, query, header, formData, body)
  let scheme = call_589329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589329.url(scheme.get, call_589329.host, call_589329.base,
                         call_589329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589329, url, valid)

proc call*(call_589330: Call_BooksMylibraryBookshelvesAddVolume_589315;
          shelf: string; volumeId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          source: string = ""; key: string = ""; prettyPrint: bool = true;
          reason: string = "IOS_PREX"): Recallable =
  ## booksMylibraryBookshelvesAddVolume
  ## Adds a volume to a bookshelf.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   shelf: string (required)
  ##        : ID of bookshelf to which to add a volume.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   volumeId: string (required)
  ##           : ID of volume to add.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   reason: string
  ##         : The reason for which the book is added to the library.
  var path_589331 = newJObject()
  var query_589332 = newJObject()
  add(query_589332, "fields", newJString(fields))
  add(query_589332, "quotaUser", newJString(quotaUser))
  add(query_589332, "alt", newJString(alt))
  add(query_589332, "oauth_token", newJString(oauthToken))
  add(query_589332, "userIp", newJString(userIp))
  add(path_589331, "shelf", newJString(shelf))
  add(query_589332, "source", newJString(source))
  add(query_589332, "key", newJString(key))
  add(query_589332, "volumeId", newJString(volumeId))
  add(query_589332, "prettyPrint", newJBool(prettyPrint))
  add(query_589332, "reason", newJString(reason))
  result = call_589330.call(path_589331, query_589332, nil, nil, nil)

var booksMylibraryBookshelvesAddVolume* = Call_BooksMylibraryBookshelvesAddVolume_589315(
    name: "booksMylibraryBookshelvesAddVolume", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/mylibrary/bookshelves/{shelf}/addVolume",
    validator: validate_BooksMylibraryBookshelvesAddVolume_589316,
    base: "/books/v1", url: url_BooksMylibraryBookshelvesAddVolume_589317,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesClearVolumes_589333 = ref object of OpenApiRestCall_588466
proc url_BooksMylibraryBookshelvesClearVolumes_589335(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "shelf" in path, "`shelf` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/mylibrary/bookshelves/"),
               (kind: VariableSegment, value: "shelf"),
               (kind: ConstantSegment, value: "/clearVolumes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BooksMylibraryBookshelvesClearVolumes_589334(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Clears all volumes from a bookshelf.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   shelf: JString (required)
  ##        : ID of bookshelf from which to remove a volume.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `shelf` field"
  var valid_589336 = path.getOrDefault("shelf")
  valid_589336 = validateParameter(valid_589336, JString, required = true,
                                 default = nil)
  if valid_589336 != nil:
    section.add "shelf", valid_589336
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589337 = query.getOrDefault("fields")
  valid_589337 = validateParameter(valid_589337, JString, required = false,
                                 default = nil)
  if valid_589337 != nil:
    section.add "fields", valid_589337
  var valid_589338 = query.getOrDefault("quotaUser")
  valid_589338 = validateParameter(valid_589338, JString, required = false,
                                 default = nil)
  if valid_589338 != nil:
    section.add "quotaUser", valid_589338
  var valid_589339 = query.getOrDefault("alt")
  valid_589339 = validateParameter(valid_589339, JString, required = false,
                                 default = newJString("json"))
  if valid_589339 != nil:
    section.add "alt", valid_589339
  var valid_589340 = query.getOrDefault("oauth_token")
  valid_589340 = validateParameter(valid_589340, JString, required = false,
                                 default = nil)
  if valid_589340 != nil:
    section.add "oauth_token", valid_589340
  var valid_589341 = query.getOrDefault("userIp")
  valid_589341 = validateParameter(valid_589341, JString, required = false,
                                 default = nil)
  if valid_589341 != nil:
    section.add "userIp", valid_589341
  var valid_589342 = query.getOrDefault("source")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = nil)
  if valid_589342 != nil:
    section.add "source", valid_589342
  var valid_589343 = query.getOrDefault("key")
  valid_589343 = validateParameter(valid_589343, JString, required = false,
                                 default = nil)
  if valid_589343 != nil:
    section.add "key", valid_589343
  var valid_589344 = query.getOrDefault("prettyPrint")
  valid_589344 = validateParameter(valid_589344, JBool, required = false,
                                 default = newJBool(true))
  if valid_589344 != nil:
    section.add "prettyPrint", valid_589344
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589345: Call_BooksMylibraryBookshelvesClearVolumes_589333;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Clears all volumes from a bookshelf.
  ## 
  let valid = call_589345.validator(path, query, header, formData, body)
  let scheme = call_589345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589345.url(scheme.get, call_589345.host, call_589345.base,
                         call_589345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589345, url, valid)

proc call*(call_589346: Call_BooksMylibraryBookshelvesClearVolumes_589333;
          shelf: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          source: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## booksMylibraryBookshelvesClearVolumes
  ## Clears all volumes from a bookshelf.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   shelf: string (required)
  ##        : ID of bookshelf from which to remove a volume.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589347 = newJObject()
  var query_589348 = newJObject()
  add(query_589348, "fields", newJString(fields))
  add(query_589348, "quotaUser", newJString(quotaUser))
  add(query_589348, "alt", newJString(alt))
  add(query_589348, "oauth_token", newJString(oauthToken))
  add(query_589348, "userIp", newJString(userIp))
  add(path_589347, "shelf", newJString(shelf))
  add(query_589348, "source", newJString(source))
  add(query_589348, "key", newJString(key))
  add(query_589348, "prettyPrint", newJBool(prettyPrint))
  result = call_589346.call(path_589347, query_589348, nil, nil, nil)

var booksMylibraryBookshelvesClearVolumes* = Call_BooksMylibraryBookshelvesClearVolumes_589333(
    name: "booksMylibraryBookshelvesClearVolumes", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/mylibrary/bookshelves/{shelf}/clearVolumes",
    validator: validate_BooksMylibraryBookshelvesClearVolumes_589334,
    base: "/books/v1", url: url_BooksMylibraryBookshelvesClearVolumes_589335,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesMoveVolume_589349 = ref object of OpenApiRestCall_588466
proc url_BooksMylibraryBookshelvesMoveVolume_589351(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "shelf" in path, "`shelf` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/mylibrary/bookshelves/"),
               (kind: VariableSegment, value: "shelf"),
               (kind: ConstantSegment, value: "/moveVolume")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BooksMylibraryBookshelvesMoveVolume_589350(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Moves a volume within a bookshelf.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   shelf: JString (required)
  ##        : ID of bookshelf with the volume.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `shelf` field"
  var valid_589352 = path.getOrDefault("shelf")
  valid_589352 = validateParameter(valid_589352, JString, required = true,
                                 default = nil)
  if valid_589352 != nil:
    section.add "shelf", valid_589352
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   volumePosition: JInt (required)
  ##                 : Position on shelf to move the item (0 puts the item before the current first item, 1 puts it between the first and the second and so on.)
  ##   volumeId: JString (required)
  ##           : ID of volume to move.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589353 = query.getOrDefault("fields")
  valid_589353 = validateParameter(valid_589353, JString, required = false,
                                 default = nil)
  if valid_589353 != nil:
    section.add "fields", valid_589353
  var valid_589354 = query.getOrDefault("quotaUser")
  valid_589354 = validateParameter(valid_589354, JString, required = false,
                                 default = nil)
  if valid_589354 != nil:
    section.add "quotaUser", valid_589354
  var valid_589355 = query.getOrDefault("alt")
  valid_589355 = validateParameter(valid_589355, JString, required = false,
                                 default = newJString("json"))
  if valid_589355 != nil:
    section.add "alt", valid_589355
  var valid_589356 = query.getOrDefault("oauth_token")
  valid_589356 = validateParameter(valid_589356, JString, required = false,
                                 default = nil)
  if valid_589356 != nil:
    section.add "oauth_token", valid_589356
  var valid_589357 = query.getOrDefault("userIp")
  valid_589357 = validateParameter(valid_589357, JString, required = false,
                                 default = nil)
  if valid_589357 != nil:
    section.add "userIp", valid_589357
  var valid_589358 = query.getOrDefault("source")
  valid_589358 = validateParameter(valid_589358, JString, required = false,
                                 default = nil)
  if valid_589358 != nil:
    section.add "source", valid_589358
  var valid_589359 = query.getOrDefault("key")
  valid_589359 = validateParameter(valid_589359, JString, required = false,
                                 default = nil)
  if valid_589359 != nil:
    section.add "key", valid_589359
  assert query != nil,
        "query argument is necessary due to required `volumePosition` field"
  var valid_589360 = query.getOrDefault("volumePosition")
  valid_589360 = validateParameter(valid_589360, JInt, required = true, default = nil)
  if valid_589360 != nil:
    section.add "volumePosition", valid_589360
  var valid_589361 = query.getOrDefault("volumeId")
  valid_589361 = validateParameter(valid_589361, JString, required = true,
                                 default = nil)
  if valid_589361 != nil:
    section.add "volumeId", valid_589361
  var valid_589362 = query.getOrDefault("prettyPrint")
  valid_589362 = validateParameter(valid_589362, JBool, required = false,
                                 default = newJBool(true))
  if valid_589362 != nil:
    section.add "prettyPrint", valid_589362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589363: Call_BooksMylibraryBookshelvesMoveVolume_589349;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Moves a volume within a bookshelf.
  ## 
  let valid = call_589363.validator(path, query, header, formData, body)
  let scheme = call_589363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589363.url(scheme.get, call_589363.host, call_589363.base,
                         call_589363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589363, url, valid)

proc call*(call_589364: Call_BooksMylibraryBookshelvesMoveVolume_589349;
          shelf: string; volumePosition: int; volumeId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; source: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## booksMylibraryBookshelvesMoveVolume
  ## Moves a volume within a bookshelf.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   shelf: string (required)
  ##        : ID of bookshelf with the volume.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   volumePosition: int (required)
  ##                 : Position on shelf to move the item (0 puts the item before the current first item, 1 puts it between the first and the second and so on.)
  ##   volumeId: string (required)
  ##           : ID of volume to move.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589365 = newJObject()
  var query_589366 = newJObject()
  add(query_589366, "fields", newJString(fields))
  add(query_589366, "quotaUser", newJString(quotaUser))
  add(query_589366, "alt", newJString(alt))
  add(query_589366, "oauth_token", newJString(oauthToken))
  add(query_589366, "userIp", newJString(userIp))
  add(path_589365, "shelf", newJString(shelf))
  add(query_589366, "source", newJString(source))
  add(query_589366, "key", newJString(key))
  add(query_589366, "volumePosition", newJInt(volumePosition))
  add(query_589366, "volumeId", newJString(volumeId))
  add(query_589366, "prettyPrint", newJBool(prettyPrint))
  result = call_589364.call(path_589365, query_589366, nil, nil, nil)

var booksMylibraryBookshelvesMoveVolume* = Call_BooksMylibraryBookshelvesMoveVolume_589349(
    name: "booksMylibraryBookshelvesMoveVolume", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/mylibrary/bookshelves/{shelf}/moveVolume",
    validator: validate_BooksMylibraryBookshelvesMoveVolume_589350,
    base: "/books/v1", url: url_BooksMylibraryBookshelvesMoveVolume_589351,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesRemoveVolume_589367 = ref object of OpenApiRestCall_588466
proc url_BooksMylibraryBookshelvesRemoveVolume_589369(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "shelf" in path, "`shelf` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/mylibrary/bookshelves/"),
               (kind: VariableSegment, value: "shelf"),
               (kind: ConstantSegment, value: "/removeVolume")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BooksMylibraryBookshelvesRemoveVolume_589368(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a volume from a bookshelf.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   shelf: JString (required)
  ##        : ID of bookshelf from which to remove a volume.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `shelf` field"
  var valid_589370 = path.getOrDefault("shelf")
  valid_589370 = validateParameter(valid_589370, JString, required = true,
                                 default = nil)
  if valid_589370 != nil:
    section.add "shelf", valid_589370
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   volumeId: JString (required)
  ##           : ID of volume to remove.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   reason: JString
  ##         : The reason for which the book is removed from the library.
  section = newJObject()
  var valid_589371 = query.getOrDefault("fields")
  valid_589371 = validateParameter(valid_589371, JString, required = false,
                                 default = nil)
  if valid_589371 != nil:
    section.add "fields", valid_589371
  var valid_589372 = query.getOrDefault("quotaUser")
  valid_589372 = validateParameter(valid_589372, JString, required = false,
                                 default = nil)
  if valid_589372 != nil:
    section.add "quotaUser", valid_589372
  var valid_589373 = query.getOrDefault("alt")
  valid_589373 = validateParameter(valid_589373, JString, required = false,
                                 default = newJString("json"))
  if valid_589373 != nil:
    section.add "alt", valid_589373
  var valid_589374 = query.getOrDefault("oauth_token")
  valid_589374 = validateParameter(valid_589374, JString, required = false,
                                 default = nil)
  if valid_589374 != nil:
    section.add "oauth_token", valid_589374
  var valid_589375 = query.getOrDefault("userIp")
  valid_589375 = validateParameter(valid_589375, JString, required = false,
                                 default = nil)
  if valid_589375 != nil:
    section.add "userIp", valid_589375
  var valid_589376 = query.getOrDefault("source")
  valid_589376 = validateParameter(valid_589376, JString, required = false,
                                 default = nil)
  if valid_589376 != nil:
    section.add "source", valid_589376
  var valid_589377 = query.getOrDefault("key")
  valid_589377 = validateParameter(valid_589377, JString, required = false,
                                 default = nil)
  if valid_589377 != nil:
    section.add "key", valid_589377
  assert query != nil,
        "query argument is necessary due to required `volumeId` field"
  var valid_589378 = query.getOrDefault("volumeId")
  valid_589378 = validateParameter(valid_589378, JString, required = true,
                                 default = nil)
  if valid_589378 != nil:
    section.add "volumeId", valid_589378
  var valid_589379 = query.getOrDefault("prettyPrint")
  valid_589379 = validateParameter(valid_589379, JBool, required = false,
                                 default = newJBool(true))
  if valid_589379 != nil:
    section.add "prettyPrint", valid_589379
  var valid_589380 = query.getOrDefault("reason")
  valid_589380 = validateParameter(valid_589380, JString, required = false,
                                 default = newJString("ONBOARDING"))
  if valid_589380 != nil:
    section.add "reason", valid_589380
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589381: Call_BooksMylibraryBookshelvesRemoveVolume_589367;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a volume from a bookshelf.
  ## 
  let valid = call_589381.validator(path, query, header, formData, body)
  let scheme = call_589381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589381.url(scheme.get, call_589381.host, call_589381.base,
                         call_589381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589381, url, valid)

proc call*(call_589382: Call_BooksMylibraryBookshelvesRemoveVolume_589367;
          shelf: string; volumeId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          source: string = ""; key: string = ""; prettyPrint: bool = true;
          reason: string = "ONBOARDING"): Recallable =
  ## booksMylibraryBookshelvesRemoveVolume
  ## Removes a volume from a bookshelf.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   shelf: string (required)
  ##        : ID of bookshelf from which to remove a volume.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   volumeId: string (required)
  ##           : ID of volume to remove.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   reason: string
  ##         : The reason for which the book is removed from the library.
  var path_589383 = newJObject()
  var query_589384 = newJObject()
  add(query_589384, "fields", newJString(fields))
  add(query_589384, "quotaUser", newJString(quotaUser))
  add(query_589384, "alt", newJString(alt))
  add(query_589384, "oauth_token", newJString(oauthToken))
  add(query_589384, "userIp", newJString(userIp))
  add(path_589383, "shelf", newJString(shelf))
  add(query_589384, "source", newJString(source))
  add(query_589384, "key", newJString(key))
  add(query_589384, "volumeId", newJString(volumeId))
  add(query_589384, "prettyPrint", newJBool(prettyPrint))
  add(query_589384, "reason", newJString(reason))
  result = call_589382.call(path_589383, query_589384, nil, nil, nil)

var booksMylibraryBookshelvesRemoveVolume* = Call_BooksMylibraryBookshelvesRemoveVolume_589367(
    name: "booksMylibraryBookshelvesRemoveVolume", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/mylibrary/bookshelves/{shelf}/removeVolume",
    validator: validate_BooksMylibraryBookshelvesRemoveVolume_589368,
    base: "/books/v1", url: url_BooksMylibraryBookshelvesRemoveVolume_589369,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesVolumesList_589385 = ref object of OpenApiRestCall_588466
proc url_BooksMylibraryBookshelvesVolumesList_589387(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "shelf" in path, "`shelf` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/mylibrary/bookshelves/"),
               (kind: VariableSegment, value: "shelf"),
               (kind: ConstantSegment, value: "/volumes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BooksMylibraryBookshelvesVolumesList_589386(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets volume information for volumes on a bookshelf.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   shelf: JString (required)
  ##        : The bookshelf ID or name retrieve volumes for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `shelf` field"
  var valid_589388 = path.getOrDefault("shelf")
  valid_589388 = validateParameter(valid_589388, JString, required = true,
                                 default = nil)
  if valid_589388 != nil:
    section.add "shelf", valid_589388
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   country: JString
  ##          : ISO-3166-1 code to override the IP-based location.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of results to return
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   q: JString
  ##    : Full-text search query string in this bookshelf.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Restrict information returned to a set of selected fields.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   showPreorders: JBool
  ##                : Set to true to show pre-ordered books. Defaults to false.
  ##   startIndex: JInt
  ##             : Index of the first element to return (starts at 0)
  section = newJObject()
  var valid_589389 = query.getOrDefault("fields")
  valid_589389 = validateParameter(valid_589389, JString, required = false,
                                 default = nil)
  if valid_589389 != nil:
    section.add "fields", valid_589389
  var valid_589390 = query.getOrDefault("country")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = nil)
  if valid_589390 != nil:
    section.add "country", valid_589390
  var valid_589391 = query.getOrDefault("quotaUser")
  valid_589391 = validateParameter(valid_589391, JString, required = false,
                                 default = nil)
  if valid_589391 != nil:
    section.add "quotaUser", valid_589391
  var valid_589392 = query.getOrDefault("alt")
  valid_589392 = validateParameter(valid_589392, JString, required = false,
                                 default = newJString("json"))
  if valid_589392 != nil:
    section.add "alt", valid_589392
  var valid_589393 = query.getOrDefault("oauth_token")
  valid_589393 = validateParameter(valid_589393, JString, required = false,
                                 default = nil)
  if valid_589393 != nil:
    section.add "oauth_token", valid_589393
  var valid_589394 = query.getOrDefault("userIp")
  valid_589394 = validateParameter(valid_589394, JString, required = false,
                                 default = nil)
  if valid_589394 != nil:
    section.add "userIp", valid_589394
  var valid_589395 = query.getOrDefault("maxResults")
  valid_589395 = validateParameter(valid_589395, JInt, required = false, default = nil)
  if valid_589395 != nil:
    section.add "maxResults", valid_589395
  var valid_589396 = query.getOrDefault("source")
  valid_589396 = validateParameter(valid_589396, JString, required = false,
                                 default = nil)
  if valid_589396 != nil:
    section.add "source", valid_589396
  var valid_589397 = query.getOrDefault("q")
  valid_589397 = validateParameter(valid_589397, JString, required = false,
                                 default = nil)
  if valid_589397 != nil:
    section.add "q", valid_589397
  var valid_589398 = query.getOrDefault("key")
  valid_589398 = validateParameter(valid_589398, JString, required = false,
                                 default = nil)
  if valid_589398 != nil:
    section.add "key", valid_589398
  var valid_589399 = query.getOrDefault("projection")
  valid_589399 = validateParameter(valid_589399, JString, required = false,
                                 default = newJString("full"))
  if valid_589399 != nil:
    section.add "projection", valid_589399
  var valid_589400 = query.getOrDefault("prettyPrint")
  valid_589400 = validateParameter(valid_589400, JBool, required = false,
                                 default = newJBool(true))
  if valid_589400 != nil:
    section.add "prettyPrint", valid_589400
  var valid_589401 = query.getOrDefault("showPreorders")
  valid_589401 = validateParameter(valid_589401, JBool, required = false, default = nil)
  if valid_589401 != nil:
    section.add "showPreorders", valid_589401
  var valid_589402 = query.getOrDefault("startIndex")
  valid_589402 = validateParameter(valid_589402, JInt, required = false, default = nil)
  if valid_589402 != nil:
    section.add "startIndex", valid_589402
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589403: Call_BooksMylibraryBookshelvesVolumesList_589385;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets volume information for volumes on a bookshelf.
  ## 
  let valid = call_589403.validator(path, query, header, formData, body)
  let scheme = call_589403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589403.url(scheme.get, call_589403.host, call_589403.base,
                         call_589403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589403, url, valid)

proc call*(call_589404: Call_BooksMylibraryBookshelvesVolumesList_589385;
          shelf: string; fields: string = ""; country: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; source: string = ""; q: string = "";
          key: string = ""; projection: string = "full"; prettyPrint: bool = true;
          showPreorders: bool = false; startIndex: int = 0): Recallable =
  ## booksMylibraryBookshelvesVolumesList
  ## Gets volume information for volumes on a bookshelf.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   country: string
  ##          : ISO-3166-1 code to override the IP-based location.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   shelf: string (required)
  ##        : The bookshelf ID or name retrieve volumes for.
  ##   maxResults: int
  ##             : Maximum number of results to return
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   q: string
  ##    : Full-text search query string in this bookshelf.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Restrict information returned to a set of selected fields.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   showPreorders: bool
  ##                : Set to true to show pre-ordered books. Defaults to false.
  ##   startIndex: int
  ##             : Index of the first element to return (starts at 0)
  var path_589405 = newJObject()
  var query_589406 = newJObject()
  add(query_589406, "fields", newJString(fields))
  add(query_589406, "country", newJString(country))
  add(query_589406, "quotaUser", newJString(quotaUser))
  add(query_589406, "alt", newJString(alt))
  add(query_589406, "oauth_token", newJString(oauthToken))
  add(query_589406, "userIp", newJString(userIp))
  add(path_589405, "shelf", newJString(shelf))
  add(query_589406, "maxResults", newJInt(maxResults))
  add(query_589406, "source", newJString(source))
  add(query_589406, "q", newJString(q))
  add(query_589406, "key", newJString(key))
  add(query_589406, "projection", newJString(projection))
  add(query_589406, "prettyPrint", newJBool(prettyPrint))
  add(query_589406, "showPreorders", newJBool(showPreorders))
  add(query_589406, "startIndex", newJInt(startIndex))
  result = call_589404.call(path_589405, query_589406, nil, nil, nil)

var booksMylibraryBookshelvesVolumesList* = Call_BooksMylibraryBookshelvesVolumesList_589385(
    name: "booksMylibraryBookshelvesVolumesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/mylibrary/bookshelves/{shelf}/volumes",
    validator: validate_BooksMylibraryBookshelvesVolumesList_589386,
    base: "/books/v1", url: url_BooksMylibraryBookshelvesVolumesList_589387,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryReadingpositionsGet_589407 = ref object of OpenApiRestCall_588466
proc url_BooksMylibraryReadingpositionsGet_589409(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "volumeId" in path, "`volumeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/mylibrary/readingpositions/"),
               (kind: VariableSegment, value: "volumeId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BooksMylibraryReadingpositionsGet_589408(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves my reading position information for a volume.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   volumeId: JString (required)
  ##           : ID of volume for which to retrieve a reading position.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `volumeId` field"
  var valid_589410 = path.getOrDefault("volumeId")
  valid_589410 = validateParameter(valid_589410, JString, required = true,
                                 default = nil)
  if valid_589410 != nil:
    section.add "volumeId", valid_589410
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   contentVersion: JString
  ##                 : Volume content version for which this reading position is requested.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589411 = query.getOrDefault("fields")
  valid_589411 = validateParameter(valid_589411, JString, required = false,
                                 default = nil)
  if valid_589411 != nil:
    section.add "fields", valid_589411
  var valid_589412 = query.getOrDefault("quotaUser")
  valid_589412 = validateParameter(valid_589412, JString, required = false,
                                 default = nil)
  if valid_589412 != nil:
    section.add "quotaUser", valid_589412
  var valid_589413 = query.getOrDefault("alt")
  valid_589413 = validateParameter(valid_589413, JString, required = false,
                                 default = newJString("json"))
  if valid_589413 != nil:
    section.add "alt", valid_589413
  var valid_589414 = query.getOrDefault("oauth_token")
  valid_589414 = validateParameter(valid_589414, JString, required = false,
                                 default = nil)
  if valid_589414 != nil:
    section.add "oauth_token", valid_589414
  var valid_589415 = query.getOrDefault("userIp")
  valid_589415 = validateParameter(valid_589415, JString, required = false,
                                 default = nil)
  if valid_589415 != nil:
    section.add "userIp", valid_589415
  var valid_589416 = query.getOrDefault("contentVersion")
  valid_589416 = validateParameter(valid_589416, JString, required = false,
                                 default = nil)
  if valid_589416 != nil:
    section.add "contentVersion", valid_589416
  var valid_589417 = query.getOrDefault("source")
  valid_589417 = validateParameter(valid_589417, JString, required = false,
                                 default = nil)
  if valid_589417 != nil:
    section.add "source", valid_589417
  var valid_589418 = query.getOrDefault("key")
  valid_589418 = validateParameter(valid_589418, JString, required = false,
                                 default = nil)
  if valid_589418 != nil:
    section.add "key", valid_589418
  var valid_589419 = query.getOrDefault("prettyPrint")
  valid_589419 = validateParameter(valid_589419, JBool, required = false,
                                 default = newJBool(true))
  if valid_589419 != nil:
    section.add "prettyPrint", valid_589419
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589420: Call_BooksMylibraryReadingpositionsGet_589407;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves my reading position information for a volume.
  ## 
  let valid = call_589420.validator(path, query, header, formData, body)
  let scheme = call_589420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589420.url(scheme.get, call_589420.host, call_589420.base,
                         call_589420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589420, url, valid)

proc call*(call_589421: Call_BooksMylibraryReadingpositionsGet_589407;
          volumeId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          contentVersion: string = ""; source: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## booksMylibraryReadingpositionsGet
  ## Retrieves my reading position information for a volume.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   contentVersion: string
  ##                 : Volume content version for which this reading position is requested.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   volumeId: string (required)
  ##           : ID of volume for which to retrieve a reading position.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589422 = newJObject()
  var query_589423 = newJObject()
  add(query_589423, "fields", newJString(fields))
  add(query_589423, "quotaUser", newJString(quotaUser))
  add(query_589423, "alt", newJString(alt))
  add(query_589423, "oauth_token", newJString(oauthToken))
  add(query_589423, "userIp", newJString(userIp))
  add(query_589423, "contentVersion", newJString(contentVersion))
  add(query_589423, "source", newJString(source))
  add(query_589423, "key", newJString(key))
  add(path_589422, "volumeId", newJString(volumeId))
  add(query_589423, "prettyPrint", newJBool(prettyPrint))
  result = call_589421.call(path_589422, query_589423, nil, nil, nil)

var booksMylibraryReadingpositionsGet* = Call_BooksMylibraryReadingpositionsGet_589407(
    name: "booksMylibraryReadingpositionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/mylibrary/readingpositions/{volumeId}",
    validator: validate_BooksMylibraryReadingpositionsGet_589408,
    base: "/books/v1", url: url_BooksMylibraryReadingpositionsGet_589409,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryReadingpositionsSetPosition_589424 = ref object of OpenApiRestCall_588466
proc url_BooksMylibraryReadingpositionsSetPosition_589426(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "volumeId" in path, "`volumeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/mylibrary/readingpositions/"),
               (kind: VariableSegment, value: "volumeId"),
               (kind: ConstantSegment, value: "/setPosition")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BooksMylibraryReadingpositionsSetPosition_589425(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets my reading position information for a volume.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   volumeId: JString (required)
  ##           : ID of volume for which to update the reading position.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `volumeId` field"
  var valid_589427 = path.getOrDefault("volumeId")
  valid_589427 = validateParameter(valid_589427, JString, required = true,
                                 default = nil)
  if valid_589427 != nil:
    section.add "volumeId", valid_589427
  result.add "path", section
  ## parameters in `query` object:
  ##   action: JString
  ##         : Action that caused this reading position to be set.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   contentVersion: JString
  ##                 : Volume content version for which this reading position applies.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   deviceCookie: JString
  ##               : Random persistent device cookie optional on set position.
  ##   timestamp: JString (required)
  ##            : RFC 3339 UTC format timestamp associated with this reading position.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   position: JString (required)
  ##           : Position string for the new volume reading position.
  section = newJObject()
  var valid_589428 = query.getOrDefault("action")
  valid_589428 = validateParameter(valid_589428, JString, required = false,
                                 default = newJString("bookmark"))
  if valid_589428 != nil:
    section.add "action", valid_589428
  var valid_589429 = query.getOrDefault("fields")
  valid_589429 = validateParameter(valid_589429, JString, required = false,
                                 default = nil)
  if valid_589429 != nil:
    section.add "fields", valid_589429
  var valid_589430 = query.getOrDefault("quotaUser")
  valid_589430 = validateParameter(valid_589430, JString, required = false,
                                 default = nil)
  if valid_589430 != nil:
    section.add "quotaUser", valid_589430
  var valid_589431 = query.getOrDefault("alt")
  valid_589431 = validateParameter(valid_589431, JString, required = false,
                                 default = newJString("json"))
  if valid_589431 != nil:
    section.add "alt", valid_589431
  var valid_589432 = query.getOrDefault("oauth_token")
  valid_589432 = validateParameter(valid_589432, JString, required = false,
                                 default = nil)
  if valid_589432 != nil:
    section.add "oauth_token", valid_589432
  var valid_589433 = query.getOrDefault("userIp")
  valid_589433 = validateParameter(valid_589433, JString, required = false,
                                 default = nil)
  if valid_589433 != nil:
    section.add "userIp", valid_589433
  var valid_589434 = query.getOrDefault("contentVersion")
  valid_589434 = validateParameter(valid_589434, JString, required = false,
                                 default = nil)
  if valid_589434 != nil:
    section.add "contentVersion", valid_589434
  var valid_589435 = query.getOrDefault("source")
  valid_589435 = validateParameter(valid_589435, JString, required = false,
                                 default = nil)
  if valid_589435 != nil:
    section.add "source", valid_589435
  var valid_589436 = query.getOrDefault("key")
  valid_589436 = validateParameter(valid_589436, JString, required = false,
                                 default = nil)
  if valid_589436 != nil:
    section.add "key", valid_589436
  var valid_589437 = query.getOrDefault("deviceCookie")
  valid_589437 = validateParameter(valid_589437, JString, required = false,
                                 default = nil)
  if valid_589437 != nil:
    section.add "deviceCookie", valid_589437
  assert query != nil,
        "query argument is necessary due to required `timestamp` field"
  var valid_589438 = query.getOrDefault("timestamp")
  valid_589438 = validateParameter(valid_589438, JString, required = true,
                                 default = nil)
  if valid_589438 != nil:
    section.add "timestamp", valid_589438
  var valid_589439 = query.getOrDefault("prettyPrint")
  valid_589439 = validateParameter(valid_589439, JBool, required = false,
                                 default = newJBool(true))
  if valid_589439 != nil:
    section.add "prettyPrint", valid_589439
  var valid_589440 = query.getOrDefault("position")
  valid_589440 = validateParameter(valid_589440, JString, required = true,
                                 default = nil)
  if valid_589440 != nil:
    section.add "position", valid_589440
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589441: Call_BooksMylibraryReadingpositionsSetPosition_589424;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets my reading position information for a volume.
  ## 
  let valid = call_589441.validator(path, query, header, formData, body)
  let scheme = call_589441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589441.url(scheme.get, call_589441.host, call_589441.base,
                         call_589441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589441, url, valid)

proc call*(call_589442: Call_BooksMylibraryReadingpositionsSetPosition_589424;
          volumeId: string; timestamp: string; position: string;
          action: string = "bookmark"; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          contentVersion: string = ""; source: string = ""; key: string = "";
          deviceCookie: string = ""; prettyPrint: bool = true): Recallable =
  ## booksMylibraryReadingpositionsSetPosition
  ## Sets my reading position information for a volume.
  ##   action: string
  ##         : Action that caused this reading position to be set.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   contentVersion: string
  ##                 : Volume content version for which this reading position applies.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   volumeId: string (required)
  ##           : ID of volume for which to update the reading position.
  ##   deviceCookie: string
  ##               : Random persistent device cookie optional on set position.
  ##   timestamp: string (required)
  ##            : RFC 3339 UTC format timestamp associated with this reading position.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   position: string (required)
  ##           : Position string for the new volume reading position.
  var path_589443 = newJObject()
  var query_589444 = newJObject()
  add(query_589444, "action", newJString(action))
  add(query_589444, "fields", newJString(fields))
  add(query_589444, "quotaUser", newJString(quotaUser))
  add(query_589444, "alt", newJString(alt))
  add(query_589444, "oauth_token", newJString(oauthToken))
  add(query_589444, "userIp", newJString(userIp))
  add(query_589444, "contentVersion", newJString(contentVersion))
  add(query_589444, "source", newJString(source))
  add(query_589444, "key", newJString(key))
  add(path_589443, "volumeId", newJString(volumeId))
  add(query_589444, "deviceCookie", newJString(deviceCookie))
  add(query_589444, "timestamp", newJString(timestamp))
  add(query_589444, "prettyPrint", newJBool(prettyPrint))
  add(query_589444, "position", newJString(position))
  result = call_589442.call(path_589443, query_589444, nil, nil, nil)

var booksMylibraryReadingpositionsSetPosition* = Call_BooksMylibraryReadingpositionsSetPosition_589424(
    name: "booksMylibraryReadingpositionsSetPosition", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/mylibrary/readingpositions/{volumeId}/setPosition",
    validator: validate_BooksMylibraryReadingpositionsSetPosition_589425,
    base: "/books/v1", url: url_BooksMylibraryReadingpositionsSetPosition_589426,
    schemes: {Scheme.Https})
type
  Call_BooksNotificationGet_589445 = ref object of OpenApiRestCall_588466
proc url_BooksNotificationGet_589447(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksNotificationGet_589446(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns notification details for a given notification id.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   locale: JString
  ##         : ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'. Used for generating notification title and body.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   notification_id: JString (required)
  ##                  : String to identify the notification.
  section = newJObject()
  var valid_589448 = query.getOrDefault("locale")
  valid_589448 = validateParameter(valid_589448, JString, required = false,
                                 default = nil)
  if valid_589448 != nil:
    section.add "locale", valid_589448
  var valid_589449 = query.getOrDefault("fields")
  valid_589449 = validateParameter(valid_589449, JString, required = false,
                                 default = nil)
  if valid_589449 != nil:
    section.add "fields", valid_589449
  var valid_589450 = query.getOrDefault("quotaUser")
  valid_589450 = validateParameter(valid_589450, JString, required = false,
                                 default = nil)
  if valid_589450 != nil:
    section.add "quotaUser", valid_589450
  var valid_589451 = query.getOrDefault("alt")
  valid_589451 = validateParameter(valid_589451, JString, required = false,
                                 default = newJString("json"))
  if valid_589451 != nil:
    section.add "alt", valid_589451
  var valid_589452 = query.getOrDefault("oauth_token")
  valid_589452 = validateParameter(valid_589452, JString, required = false,
                                 default = nil)
  if valid_589452 != nil:
    section.add "oauth_token", valid_589452
  var valid_589453 = query.getOrDefault("userIp")
  valid_589453 = validateParameter(valid_589453, JString, required = false,
                                 default = nil)
  if valid_589453 != nil:
    section.add "userIp", valid_589453
  var valid_589454 = query.getOrDefault("source")
  valid_589454 = validateParameter(valid_589454, JString, required = false,
                                 default = nil)
  if valid_589454 != nil:
    section.add "source", valid_589454
  var valid_589455 = query.getOrDefault("key")
  valid_589455 = validateParameter(valid_589455, JString, required = false,
                                 default = nil)
  if valid_589455 != nil:
    section.add "key", valid_589455
  var valid_589456 = query.getOrDefault("prettyPrint")
  valid_589456 = validateParameter(valid_589456, JBool, required = false,
                                 default = newJBool(true))
  if valid_589456 != nil:
    section.add "prettyPrint", valid_589456
  assert query != nil,
        "query argument is necessary due to required `notification_id` field"
  var valid_589457 = query.getOrDefault("notification_id")
  valid_589457 = validateParameter(valid_589457, JString, required = true,
                                 default = nil)
  if valid_589457 != nil:
    section.add "notification_id", valid_589457
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589458: Call_BooksNotificationGet_589445; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns notification details for a given notification id.
  ## 
  let valid = call_589458.validator(path, query, header, formData, body)
  let scheme = call_589458.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589458.url(scheme.get, call_589458.host, call_589458.base,
                         call_589458.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589458, url, valid)

proc call*(call_589459: Call_BooksNotificationGet_589445; notificationId: string;
          locale: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          source: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## booksNotificationGet
  ## Returns notification details for a given notification id.
  ##   locale: string
  ##         : ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'. Used for generating notification title and body.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   notificationId: string (required)
  ##                 : String to identify the notification.
  var query_589460 = newJObject()
  add(query_589460, "locale", newJString(locale))
  add(query_589460, "fields", newJString(fields))
  add(query_589460, "quotaUser", newJString(quotaUser))
  add(query_589460, "alt", newJString(alt))
  add(query_589460, "oauth_token", newJString(oauthToken))
  add(query_589460, "userIp", newJString(userIp))
  add(query_589460, "source", newJString(source))
  add(query_589460, "key", newJString(key))
  add(query_589460, "prettyPrint", newJBool(prettyPrint))
  add(query_589460, "notification_id", newJString(notificationId))
  result = call_589459.call(nil, query_589460, nil, nil, nil)

var booksNotificationGet* = Call_BooksNotificationGet_589445(
    name: "booksNotificationGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/notification/get",
    validator: validate_BooksNotificationGet_589446, base: "/books/v1",
    url: url_BooksNotificationGet_589447, schemes: {Scheme.Https})
type
  Call_BooksOnboardingListCategories_589461 = ref object of OpenApiRestCall_588466
proc url_BooksOnboardingListCategories_589463(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksOnboardingListCategories_589462(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List categories for onboarding experience.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   locale: JString
  ##         : ISO-639-1 language and ISO-3166-1 country code. Default is en-US if unset.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589464 = query.getOrDefault("locale")
  valid_589464 = validateParameter(valid_589464, JString, required = false,
                                 default = nil)
  if valid_589464 != nil:
    section.add "locale", valid_589464
  var valid_589465 = query.getOrDefault("fields")
  valid_589465 = validateParameter(valid_589465, JString, required = false,
                                 default = nil)
  if valid_589465 != nil:
    section.add "fields", valid_589465
  var valid_589466 = query.getOrDefault("quotaUser")
  valid_589466 = validateParameter(valid_589466, JString, required = false,
                                 default = nil)
  if valid_589466 != nil:
    section.add "quotaUser", valid_589466
  var valid_589467 = query.getOrDefault("alt")
  valid_589467 = validateParameter(valid_589467, JString, required = false,
                                 default = newJString("json"))
  if valid_589467 != nil:
    section.add "alt", valid_589467
  var valid_589468 = query.getOrDefault("oauth_token")
  valid_589468 = validateParameter(valid_589468, JString, required = false,
                                 default = nil)
  if valid_589468 != nil:
    section.add "oauth_token", valid_589468
  var valid_589469 = query.getOrDefault("userIp")
  valid_589469 = validateParameter(valid_589469, JString, required = false,
                                 default = nil)
  if valid_589469 != nil:
    section.add "userIp", valid_589469
  var valid_589470 = query.getOrDefault("key")
  valid_589470 = validateParameter(valid_589470, JString, required = false,
                                 default = nil)
  if valid_589470 != nil:
    section.add "key", valid_589470
  var valid_589471 = query.getOrDefault("prettyPrint")
  valid_589471 = validateParameter(valid_589471, JBool, required = false,
                                 default = newJBool(true))
  if valid_589471 != nil:
    section.add "prettyPrint", valid_589471
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589472: Call_BooksOnboardingListCategories_589461; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List categories for onboarding experience.
  ## 
  let valid = call_589472.validator(path, query, header, formData, body)
  let scheme = call_589472.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589472.url(scheme.get, call_589472.host, call_589472.base,
                         call_589472.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589472, url, valid)

proc call*(call_589473: Call_BooksOnboardingListCategories_589461;
          locale: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## booksOnboardingListCategories
  ## List categories for onboarding experience.
  ##   locale: string
  ##         : ISO-639-1 language and ISO-3166-1 country code. Default is en-US if unset.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589474 = newJObject()
  add(query_589474, "locale", newJString(locale))
  add(query_589474, "fields", newJString(fields))
  add(query_589474, "quotaUser", newJString(quotaUser))
  add(query_589474, "alt", newJString(alt))
  add(query_589474, "oauth_token", newJString(oauthToken))
  add(query_589474, "userIp", newJString(userIp))
  add(query_589474, "key", newJString(key))
  add(query_589474, "prettyPrint", newJBool(prettyPrint))
  result = call_589473.call(nil, query_589474, nil, nil, nil)

var booksOnboardingListCategories* = Call_BooksOnboardingListCategories_589461(
    name: "booksOnboardingListCategories", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/onboarding/listCategories",
    validator: validate_BooksOnboardingListCategories_589462, base: "/books/v1",
    url: url_BooksOnboardingListCategories_589463, schemes: {Scheme.Https})
type
  Call_BooksOnboardingListCategoryVolumes_589475 = ref object of OpenApiRestCall_588466
proc url_BooksOnboardingListCategoryVolumes_589477(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksOnboardingListCategoryVolumes_589476(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List available volumes under categories for onboarding experience.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   locale: JString
  ##         : ISO-639-1 language and ISO-3166-1 country code. Default is en-US if unset.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The value of the nextToken from the previous page.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   categoryId: JArray
  ##             : List of category ids requested.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pageSize: JInt
  ##           : Number of maximum results per page to be included in the response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   maxAllowedMaturityRating: JString
  ##                           : The maximum allowed maturity rating of returned volumes. Books with a higher maturity rating are filtered out.
  section = newJObject()
  var valid_589478 = query.getOrDefault("locale")
  valid_589478 = validateParameter(valid_589478, JString, required = false,
                                 default = nil)
  if valid_589478 != nil:
    section.add "locale", valid_589478
  var valid_589479 = query.getOrDefault("fields")
  valid_589479 = validateParameter(valid_589479, JString, required = false,
                                 default = nil)
  if valid_589479 != nil:
    section.add "fields", valid_589479
  var valid_589480 = query.getOrDefault("pageToken")
  valid_589480 = validateParameter(valid_589480, JString, required = false,
                                 default = nil)
  if valid_589480 != nil:
    section.add "pageToken", valid_589480
  var valid_589481 = query.getOrDefault("quotaUser")
  valid_589481 = validateParameter(valid_589481, JString, required = false,
                                 default = nil)
  if valid_589481 != nil:
    section.add "quotaUser", valid_589481
  var valid_589482 = query.getOrDefault("alt")
  valid_589482 = validateParameter(valid_589482, JString, required = false,
                                 default = newJString("json"))
  if valid_589482 != nil:
    section.add "alt", valid_589482
  var valid_589483 = query.getOrDefault("categoryId")
  valid_589483 = validateParameter(valid_589483, JArray, required = false,
                                 default = nil)
  if valid_589483 != nil:
    section.add "categoryId", valid_589483
  var valid_589484 = query.getOrDefault("oauth_token")
  valid_589484 = validateParameter(valid_589484, JString, required = false,
                                 default = nil)
  if valid_589484 != nil:
    section.add "oauth_token", valid_589484
  var valid_589485 = query.getOrDefault("userIp")
  valid_589485 = validateParameter(valid_589485, JString, required = false,
                                 default = nil)
  if valid_589485 != nil:
    section.add "userIp", valid_589485
  var valid_589486 = query.getOrDefault("key")
  valid_589486 = validateParameter(valid_589486, JString, required = false,
                                 default = nil)
  if valid_589486 != nil:
    section.add "key", valid_589486
  var valid_589487 = query.getOrDefault("pageSize")
  valid_589487 = validateParameter(valid_589487, JInt, required = false, default = nil)
  if valid_589487 != nil:
    section.add "pageSize", valid_589487
  var valid_589488 = query.getOrDefault("prettyPrint")
  valid_589488 = validateParameter(valid_589488, JBool, required = false,
                                 default = newJBool(true))
  if valid_589488 != nil:
    section.add "prettyPrint", valid_589488
  var valid_589489 = query.getOrDefault("maxAllowedMaturityRating")
  valid_589489 = validateParameter(valid_589489, JString, required = false,
                                 default = newJString("mature"))
  if valid_589489 != nil:
    section.add "maxAllowedMaturityRating", valid_589489
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589490: Call_BooksOnboardingListCategoryVolumes_589475;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List available volumes under categories for onboarding experience.
  ## 
  let valid = call_589490.validator(path, query, header, formData, body)
  let scheme = call_589490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589490.url(scheme.get, call_589490.host, call_589490.base,
                         call_589490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589490, url, valid)

proc call*(call_589491: Call_BooksOnboardingListCategoryVolumes_589475;
          locale: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; categoryId: JsonNode = nil;
          oauthToken: string = ""; userIp: string = ""; key: string = ""; pageSize: int = 0;
          prettyPrint: bool = true; maxAllowedMaturityRating: string = "mature"): Recallable =
  ## booksOnboardingListCategoryVolumes
  ## List available volumes under categories for onboarding experience.
  ##   locale: string
  ##         : ISO-639-1 language and ISO-3166-1 country code. Default is en-US if unset.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The value of the nextToken from the previous page.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   categoryId: JArray
  ##             : List of category ids requested.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pageSize: int
  ##           : Number of maximum results per page to be included in the response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   maxAllowedMaturityRating: string
  ##                           : The maximum allowed maturity rating of returned volumes. Books with a higher maturity rating are filtered out.
  var query_589492 = newJObject()
  add(query_589492, "locale", newJString(locale))
  add(query_589492, "fields", newJString(fields))
  add(query_589492, "pageToken", newJString(pageToken))
  add(query_589492, "quotaUser", newJString(quotaUser))
  add(query_589492, "alt", newJString(alt))
  if categoryId != nil:
    query_589492.add "categoryId", categoryId
  add(query_589492, "oauth_token", newJString(oauthToken))
  add(query_589492, "userIp", newJString(userIp))
  add(query_589492, "key", newJString(key))
  add(query_589492, "pageSize", newJInt(pageSize))
  add(query_589492, "prettyPrint", newJBool(prettyPrint))
  add(query_589492, "maxAllowedMaturityRating",
      newJString(maxAllowedMaturityRating))
  result = call_589491.call(nil, query_589492, nil, nil, nil)

var booksOnboardingListCategoryVolumes* = Call_BooksOnboardingListCategoryVolumes_589475(
    name: "booksOnboardingListCategoryVolumes", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/onboarding/listCategoryVolumes",
    validator: validate_BooksOnboardingListCategoryVolumes_589476,
    base: "/books/v1", url: url_BooksOnboardingListCategoryVolumes_589477,
    schemes: {Scheme.Https})
type
  Call_BooksPersonalizedstreamGet_589493 = ref object of OpenApiRestCall_588466
proc url_BooksPersonalizedstreamGet_589495(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksPersonalizedstreamGet_589494(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a stream of personalized book clusters
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   locale: JString
  ##         : ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'. Used for generating recommendations.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   maxAllowedMaturityRating: JString
  ##                           : The maximum allowed maturity rating of returned recommendations. Books with a higher maturity rating are filtered out.
  section = newJObject()
  var valid_589496 = query.getOrDefault("locale")
  valid_589496 = validateParameter(valid_589496, JString, required = false,
                                 default = nil)
  if valid_589496 != nil:
    section.add "locale", valid_589496
  var valid_589497 = query.getOrDefault("fields")
  valid_589497 = validateParameter(valid_589497, JString, required = false,
                                 default = nil)
  if valid_589497 != nil:
    section.add "fields", valid_589497
  var valid_589498 = query.getOrDefault("quotaUser")
  valid_589498 = validateParameter(valid_589498, JString, required = false,
                                 default = nil)
  if valid_589498 != nil:
    section.add "quotaUser", valid_589498
  var valid_589499 = query.getOrDefault("alt")
  valid_589499 = validateParameter(valid_589499, JString, required = false,
                                 default = newJString("json"))
  if valid_589499 != nil:
    section.add "alt", valid_589499
  var valid_589500 = query.getOrDefault("oauth_token")
  valid_589500 = validateParameter(valid_589500, JString, required = false,
                                 default = nil)
  if valid_589500 != nil:
    section.add "oauth_token", valid_589500
  var valid_589501 = query.getOrDefault("userIp")
  valid_589501 = validateParameter(valid_589501, JString, required = false,
                                 default = nil)
  if valid_589501 != nil:
    section.add "userIp", valid_589501
  var valid_589502 = query.getOrDefault("source")
  valid_589502 = validateParameter(valid_589502, JString, required = false,
                                 default = nil)
  if valid_589502 != nil:
    section.add "source", valid_589502
  var valid_589503 = query.getOrDefault("key")
  valid_589503 = validateParameter(valid_589503, JString, required = false,
                                 default = nil)
  if valid_589503 != nil:
    section.add "key", valid_589503
  var valid_589504 = query.getOrDefault("prettyPrint")
  valid_589504 = validateParameter(valid_589504, JBool, required = false,
                                 default = newJBool(true))
  if valid_589504 != nil:
    section.add "prettyPrint", valid_589504
  var valid_589505 = query.getOrDefault("maxAllowedMaturityRating")
  valid_589505 = validateParameter(valid_589505, JString, required = false,
                                 default = newJString("mature"))
  if valid_589505 != nil:
    section.add "maxAllowedMaturityRating", valid_589505
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589506: Call_BooksPersonalizedstreamGet_589493; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a stream of personalized book clusters
  ## 
  let valid = call_589506.validator(path, query, header, formData, body)
  let scheme = call_589506.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589506.url(scheme.get, call_589506.host, call_589506.base,
                         call_589506.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589506, url, valid)

proc call*(call_589507: Call_BooksPersonalizedstreamGet_589493;
          locale: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          source: string = ""; key: string = ""; prettyPrint: bool = true;
          maxAllowedMaturityRating: string = "mature"): Recallable =
  ## booksPersonalizedstreamGet
  ## Returns a stream of personalized book clusters
  ##   locale: string
  ##         : ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'. Used for generating recommendations.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   maxAllowedMaturityRating: string
  ##                           : The maximum allowed maturity rating of returned recommendations. Books with a higher maturity rating are filtered out.
  var query_589508 = newJObject()
  add(query_589508, "locale", newJString(locale))
  add(query_589508, "fields", newJString(fields))
  add(query_589508, "quotaUser", newJString(quotaUser))
  add(query_589508, "alt", newJString(alt))
  add(query_589508, "oauth_token", newJString(oauthToken))
  add(query_589508, "userIp", newJString(userIp))
  add(query_589508, "source", newJString(source))
  add(query_589508, "key", newJString(key))
  add(query_589508, "prettyPrint", newJBool(prettyPrint))
  add(query_589508, "maxAllowedMaturityRating",
      newJString(maxAllowedMaturityRating))
  result = call_589507.call(nil, query_589508, nil, nil, nil)

var booksPersonalizedstreamGet* = Call_BooksPersonalizedstreamGet_589493(
    name: "booksPersonalizedstreamGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/personalizedstream/get",
    validator: validate_BooksPersonalizedstreamGet_589494, base: "/books/v1",
    url: url_BooksPersonalizedstreamGet_589495, schemes: {Scheme.Https})
type
  Call_BooksPromoofferAccept_589509 = ref object of OpenApiRestCall_588466
proc url_BooksPromoofferAccept_589511(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksPromoofferAccept_589510(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   androidId: JString
  ##            : device android_id
  ##   model: JString
  ##        : device model
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   product: JString
  ##          : device product
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   serial: JString
  ##         : device serial
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   device: JString
  ##         : device device
  ##   manufacturer: JString
  ##               : device manufacturer
  ##   offerId: JString
  ##   volumeId: JString
  ##           : Volume id to exercise the offer
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589512 = query.getOrDefault("fields")
  valid_589512 = validateParameter(valid_589512, JString, required = false,
                                 default = nil)
  if valid_589512 != nil:
    section.add "fields", valid_589512
  var valid_589513 = query.getOrDefault("quotaUser")
  valid_589513 = validateParameter(valid_589513, JString, required = false,
                                 default = nil)
  if valid_589513 != nil:
    section.add "quotaUser", valid_589513
  var valid_589514 = query.getOrDefault("alt")
  valid_589514 = validateParameter(valid_589514, JString, required = false,
                                 default = newJString("json"))
  if valid_589514 != nil:
    section.add "alt", valid_589514
  var valid_589515 = query.getOrDefault("androidId")
  valid_589515 = validateParameter(valid_589515, JString, required = false,
                                 default = nil)
  if valid_589515 != nil:
    section.add "androidId", valid_589515
  var valid_589516 = query.getOrDefault("model")
  valid_589516 = validateParameter(valid_589516, JString, required = false,
                                 default = nil)
  if valid_589516 != nil:
    section.add "model", valid_589516
  var valid_589517 = query.getOrDefault("oauth_token")
  valid_589517 = validateParameter(valid_589517, JString, required = false,
                                 default = nil)
  if valid_589517 != nil:
    section.add "oauth_token", valid_589517
  var valid_589518 = query.getOrDefault("product")
  valid_589518 = validateParameter(valid_589518, JString, required = false,
                                 default = nil)
  if valid_589518 != nil:
    section.add "product", valid_589518
  var valid_589519 = query.getOrDefault("userIp")
  valid_589519 = validateParameter(valid_589519, JString, required = false,
                                 default = nil)
  if valid_589519 != nil:
    section.add "userIp", valid_589519
  var valid_589520 = query.getOrDefault("serial")
  valid_589520 = validateParameter(valid_589520, JString, required = false,
                                 default = nil)
  if valid_589520 != nil:
    section.add "serial", valid_589520
  var valid_589521 = query.getOrDefault("key")
  valid_589521 = validateParameter(valid_589521, JString, required = false,
                                 default = nil)
  if valid_589521 != nil:
    section.add "key", valid_589521
  var valid_589522 = query.getOrDefault("device")
  valid_589522 = validateParameter(valid_589522, JString, required = false,
                                 default = nil)
  if valid_589522 != nil:
    section.add "device", valid_589522
  var valid_589523 = query.getOrDefault("manufacturer")
  valid_589523 = validateParameter(valid_589523, JString, required = false,
                                 default = nil)
  if valid_589523 != nil:
    section.add "manufacturer", valid_589523
  var valid_589524 = query.getOrDefault("offerId")
  valid_589524 = validateParameter(valid_589524, JString, required = false,
                                 default = nil)
  if valid_589524 != nil:
    section.add "offerId", valid_589524
  var valid_589525 = query.getOrDefault("volumeId")
  valid_589525 = validateParameter(valid_589525, JString, required = false,
                                 default = nil)
  if valid_589525 != nil:
    section.add "volumeId", valid_589525
  var valid_589526 = query.getOrDefault("prettyPrint")
  valid_589526 = validateParameter(valid_589526, JBool, required = false,
                                 default = newJBool(true))
  if valid_589526 != nil:
    section.add "prettyPrint", valid_589526
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589527: Call_BooksPromoofferAccept_589509; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_589527.validator(path, query, header, formData, body)
  let scheme = call_589527.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589527.url(scheme.get, call_589527.host, call_589527.base,
                         call_589527.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589527, url, valid)

proc call*(call_589528: Call_BooksPromoofferAccept_589509; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; androidId: string = "";
          model: string = ""; oauthToken: string = ""; product: string = "";
          userIp: string = ""; serial: string = ""; key: string = ""; device: string = "";
          manufacturer: string = ""; offerId: string = ""; volumeId: string = "";
          prettyPrint: bool = true): Recallable =
  ## booksPromoofferAccept
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   androidId: string
  ##            : device android_id
  ##   model: string
  ##        : device model
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   product: string
  ##          : device product
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   serial: string
  ##         : device serial
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   device: string
  ##         : device device
  ##   manufacturer: string
  ##               : device manufacturer
  ##   offerId: string
  ##   volumeId: string
  ##           : Volume id to exercise the offer
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589529 = newJObject()
  add(query_589529, "fields", newJString(fields))
  add(query_589529, "quotaUser", newJString(quotaUser))
  add(query_589529, "alt", newJString(alt))
  add(query_589529, "androidId", newJString(androidId))
  add(query_589529, "model", newJString(model))
  add(query_589529, "oauth_token", newJString(oauthToken))
  add(query_589529, "product", newJString(product))
  add(query_589529, "userIp", newJString(userIp))
  add(query_589529, "serial", newJString(serial))
  add(query_589529, "key", newJString(key))
  add(query_589529, "device", newJString(device))
  add(query_589529, "manufacturer", newJString(manufacturer))
  add(query_589529, "offerId", newJString(offerId))
  add(query_589529, "volumeId", newJString(volumeId))
  add(query_589529, "prettyPrint", newJBool(prettyPrint))
  result = call_589528.call(nil, query_589529, nil, nil, nil)

var booksPromoofferAccept* = Call_BooksPromoofferAccept_589509(
    name: "booksPromoofferAccept", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/promooffer/accept",
    validator: validate_BooksPromoofferAccept_589510, base: "/books/v1",
    url: url_BooksPromoofferAccept_589511, schemes: {Scheme.Https})
type
  Call_BooksPromoofferDismiss_589530 = ref object of OpenApiRestCall_588466
proc url_BooksPromoofferDismiss_589532(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksPromoofferDismiss_589531(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   androidId: JString
  ##            : device android_id
  ##   model: JString
  ##        : device model
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   product: JString
  ##          : device product
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   serial: JString
  ##         : device serial
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   device: JString
  ##         : device device
  ##   manufacturer: JString
  ##               : device manufacturer
  ##   offerId: JString
  ##          : Offer to dimiss
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589533 = query.getOrDefault("fields")
  valid_589533 = validateParameter(valid_589533, JString, required = false,
                                 default = nil)
  if valid_589533 != nil:
    section.add "fields", valid_589533
  var valid_589534 = query.getOrDefault("quotaUser")
  valid_589534 = validateParameter(valid_589534, JString, required = false,
                                 default = nil)
  if valid_589534 != nil:
    section.add "quotaUser", valid_589534
  var valid_589535 = query.getOrDefault("alt")
  valid_589535 = validateParameter(valid_589535, JString, required = false,
                                 default = newJString("json"))
  if valid_589535 != nil:
    section.add "alt", valid_589535
  var valid_589536 = query.getOrDefault("androidId")
  valid_589536 = validateParameter(valid_589536, JString, required = false,
                                 default = nil)
  if valid_589536 != nil:
    section.add "androidId", valid_589536
  var valid_589537 = query.getOrDefault("model")
  valid_589537 = validateParameter(valid_589537, JString, required = false,
                                 default = nil)
  if valid_589537 != nil:
    section.add "model", valid_589537
  var valid_589538 = query.getOrDefault("oauth_token")
  valid_589538 = validateParameter(valid_589538, JString, required = false,
                                 default = nil)
  if valid_589538 != nil:
    section.add "oauth_token", valid_589538
  var valid_589539 = query.getOrDefault("product")
  valid_589539 = validateParameter(valid_589539, JString, required = false,
                                 default = nil)
  if valid_589539 != nil:
    section.add "product", valid_589539
  var valid_589540 = query.getOrDefault("userIp")
  valid_589540 = validateParameter(valid_589540, JString, required = false,
                                 default = nil)
  if valid_589540 != nil:
    section.add "userIp", valid_589540
  var valid_589541 = query.getOrDefault("serial")
  valid_589541 = validateParameter(valid_589541, JString, required = false,
                                 default = nil)
  if valid_589541 != nil:
    section.add "serial", valid_589541
  var valid_589542 = query.getOrDefault("key")
  valid_589542 = validateParameter(valid_589542, JString, required = false,
                                 default = nil)
  if valid_589542 != nil:
    section.add "key", valid_589542
  var valid_589543 = query.getOrDefault("device")
  valid_589543 = validateParameter(valid_589543, JString, required = false,
                                 default = nil)
  if valid_589543 != nil:
    section.add "device", valid_589543
  var valid_589544 = query.getOrDefault("manufacturer")
  valid_589544 = validateParameter(valid_589544, JString, required = false,
                                 default = nil)
  if valid_589544 != nil:
    section.add "manufacturer", valid_589544
  var valid_589545 = query.getOrDefault("offerId")
  valid_589545 = validateParameter(valid_589545, JString, required = false,
                                 default = nil)
  if valid_589545 != nil:
    section.add "offerId", valid_589545
  var valid_589546 = query.getOrDefault("prettyPrint")
  valid_589546 = validateParameter(valid_589546, JBool, required = false,
                                 default = newJBool(true))
  if valid_589546 != nil:
    section.add "prettyPrint", valid_589546
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589547: Call_BooksPromoofferDismiss_589530; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_589547.validator(path, query, header, formData, body)
  let scheme = call_589547.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589547.url(scheme.get, call_589547.host, call_589547.base,
                         call_589547.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589547, url, valid)

proc call*(call_589548: Call_BooksPromoofferDismiss_589530; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; androidId: string = "";
          model: string = ""; oauthToken: string = ""; product: string = "";
          userIp: string = ""; serial: string = ""; key: string = ""; device: string = "";
          manufacturer: string = ""; offerId: string = ""; prettyPrint: bool = true): Recallable =
  ## booksPromoofferDismiss
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   androidId: string
  ##            : device android_id
  ##   model: string
  ##        : device model
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   product: string
  ##          : device product
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   serial: string
  ##         : device serial
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   device: string
  ##         : device device
  ##   manufacturer: string
  ##               : device manufacturer
  ##   offerId: string
  ##          : Offer to dimiss
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589549 = newJObject()
  add(query_589549, "fields", newJString(fields))
  add(query_589549, "quotaUser", newJString(quotaUser))
  add(query_589549, "alt", newJString(alt))
  add(query_589549, "androidId", newJString(androidId))
  add(query_589549, "model", newJString(model))
  add(query_589549, "oauth_token", newJString(oauthToken))
  add(query_589549, "product", newJString(product))
  add(query_589549, "userIp", newJString(userIp))
  add(query_589549, "serial", newJString(serial))
  add(query_589549, "key", newJString(key))
  add(query_589549, "device", newJString(device))
  add(query_589549, "manufacturer", newJString(manufacturer))
  add(query_589549, "offerId", newJString(offerId))
  add(query_589549, "prettyPrint", newJBool(prettyPrint))
  result = call_589548.call(nil, query_589549, nil, nil, nil)

var booksPromoofferDismiss* = Call_BooksPromoofferDismiss_589530(
    name: "booksPromoofferDismiss", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/promooffer/dismiss",
    validator: validate_BooksPromoofferDismiss_589531, base: "/books/v1",
    url: url_BooksPromoofferDismiss_589532, schemes: {Scheme.Https})
type
  Call_BooksPromoofferGet_589550 = ref object of OpenApiRestCall_588466
proc url_BooksPromoofferGet_589552(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksPromoofferGet_589551(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Returns a list of promo offers available to the user
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   androidId: JString
  ##            : device android_id
  ##   model: JString
  ##        : device model
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   product: JString
  ##          : device product
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   serial: JString
  ##         : device serial
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   device: JString
  ##         : device device
  ##   manufacturer: JString
  ##               : device manufacturer
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589553 = query.getOrDefault("fields")
  valid_589553 = validateParameter(valid_589553, JString, required = false,
                                 default = nil)
  if valid_589553 != nil:
    section.add "fields", valid_589553
  var valid_589554 = query.getOrDefault("quotaUser")
  valid_589554 = validateParameter(valid_589554, JString, required = false,
                                 default = nil)
  if valid_589554 != nil:
    section.add "quotaUser", valid_589554
  var valid_589555 = query.getOrDefault("alt")
  valid_589555 = validateParameter(valid_589555, JString, required = false,
                                 default = newJString("json"))
  if valid_589555 != nil:
    section.add "alt", valid_589555
  var valid_589556 = query.getOrDefault("androidId")
  valid_589556 = validateParameter(valid_589556, JString, required = false,
                                 default = nil)
  if valid_589556 != nil:
    section.add "androidId", valid_589556
  var valid_589557 = query.getOrDefault("model")
  valid_589557 = validateParameter(valid_589557, JString, required = false,
                                 default = nil)
  if valid_589557 != nil:
    section.add "model", valid_589557
  var valid_589558 = query.getOrDefault("oauth_token")
  valid_589558 = validateParameter(valid_589558, JString, required = false,
                                 default = nil)
  if valid_589558 != nil:
    section.add "oauth_token", valid_589558
  var valid_589559 = query.getOrDefault("product")
  valid_589559 = validateParameter(valid_589559, JString, required = false,
                                 default = nil)
  if valid_589559 != nil:
    section.add "product", valid_589559
  var valid_589560 = query.getOrDefault("userIp")
  valid_589560 = validateParameter(valid_589560, JString, required = false,
                                 default = nil)
  if valid_589560 != nil:
    section.add "userIp", valid_589560
  var valid_589561 = query.getOrDefault("serial")
  valid_589561 = validateParameter(valid_589561, JString, required = false,
                                 default = nil)
  if valid_589561 != nil:
    section.add "serial", valid_589561
  var valid_589562 = query.getOrDefault("key")
  valid_589562 = validateParameter(valid_589562, JString, required = false,
                                 default = nil)
  if valid_589562 != nil:
    section.add "key", valid_589562
  var valid_589563 = query.getOrDefault("device")
  valid_589563 = validateParameter(valid_589563, JString, required = false,
                                 default = nil)
  if valid_589563 != nil:
    section.add "device", valid_589563
  var valid_589564 = query.getOrDefault("manufacturer")
  valid_589564 = validateParameter(valid_589564, JString, required = false,
                                 default = nil)
  if valid_589564 != nil:
    section.add "manufacturer", valid_589564
  var valid_589565 = query.getOrDefault("prettyPrint")
  valid_589565 = validateParameter(valid_589565, JBool, required = false,
                                 default = newJBool(true))
  if valid_589565 != nil:
    section.add "prettyPrint", valid_589565
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589566: Call_BooksPromoofferGet_589550; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of promo offers available to the user
  ## 
  let valid = call_589566.validator(path, query, header, formData, body)
  let scheme = call_589566.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589566.url(scheme.get, call_589566.host, call_589566.base,
                         call_589566.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589566, url, valid)

proc call*(call_589567: Call_BooksPromoofferGet_589550; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; androidId: string = "";
          model: string = ""; oauthToken: string = ""; product: string = "";
          userIp: string = ""; serial: string = ""; key: string = ""; device: string = "";
          manufacturer: string = ""; prettyPrint: bool = true): Recallable =
  ## booksPromoofferGet
  ## Returns a list of promo offers available to the user
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   androidId: string
  ##            : device android_id
  ##   model: string
  ##        : device model
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   product: string
  ##          : device product
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   serial: string
  ##         : device serial
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   device: string
  ##         : device device
  ##   manufacturer: string
  ##               : device manufacturer
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589568 = newJObject()
  add(query_589568, "fields", newJString(fields))
  add(query_589568, "quotaUser", newJString(quotaUser))
  add(query_589568, "alt", newJString(alt))
  add(query_589568, "androidId", newJString(androidId))
  add(query_589568, "model", newJString(model))
  add(query_589568, "oauth_token", newJString(oauthToken))
  add(query_589568, "product", newJString(product))
  add(query_589568, "userIp", newJString(userIp))
  add(query_589568, "serial", newJString(serial))
  add(query_589568, "key", newJString(key))
  add(query_589568, "device", newJString(device))
  add(query_589568, "manufacturer", newJString(manufacturer))
  add(query_589568, "prettyPrint", newJBool(prettyPrint))
  result = call_589567.call(nil, query_589568, nil, nil, nil)

var booksPromoofferGet* = Call_BooksPromoofferGet_589550(
    name: "booksPromoofferGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/promooffer/get",
    validator: validate_BooksPromoofferGet_589551, base: "/books/v1",
    url: url_BooksPromoofferGet_589552, schemes: {Scheme.Https})
type
  Call_BooksSeriesGet_589569 = ref object of OpenApiRestCall_588466
proc url_BooksSeriesGet_589571(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksSeriesGet_589570(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Returns Series metadata for the given series ids.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   series_id: JArray (required)
  ##            : String that identifies the series
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `series_id` field"
  var valid_589572 = query.getOrDefault("series_id")
  valid_589572 = validateParameter(valid_589572, JArray, required = true, default = nil)
  if valid_589572 != nil:
    section.add "series_id", valid_589572
  var valid_589573 = query.getOrDefault("fields")
  valid_589573 = validateParameter(valid_589573, JString, required = false,
                                 default = nil)
  if valid_589573 != nil:
    section.add "fields", valid_589573
  var valid_589574 = query.getOrDefault("quotaUser")
  valid_589574 = validateParameter(valid_589574, JString, required = false,
                                 default = nil)
  if valid_589574 != nil:
    section.add "quotaUser", valid_589574
  var valid_589575 = query.getOrDefault("alt")
  valid_589575 = validateParameter(valid_589575, JString, required = false,
                                 default = newJString("json"))
  if valid_589575 != nil:
    section.add "alt", valid_589575
  var valid_589576 = query.getOrDefault("oauth_token")
  valid_589576 = validateParameter(valid_589576, JString, required = false,
                                 default = nil)
  if valid_589576 != nil:
    section.add "oauth_token", valid_589576
  var valid_589577 = query.getOrDefault("userIp")
  valid_589577 = validateParameter(valid_589577, JString, required = false,
                                 default = nil)
  if valid_589577 != nil:
    section.add "userIp", valid_589577
  var valid_589578 = query.getOrDefault("key")
  valid_589578 = validateParameter(valid_589578, JString, required = false,
                                 default = nil)
  if valid_589578 != nil:
    section.add "key", valid_589578
  var valid_589579 = query.getOrDefault("prettyPrint")
  valid_589579 = validateParameter(valid_589579, JBool, required = false,
                                 default = newJBool(true))
  if valid_589579 != nil:
    section.add "prettyPrint", valid_589579
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589580: Call_BooksSeriesGet_589569; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Series metadata for the given series ids.
  ## 
  let valid = call_589580.validator(path, query, header, formData, body)
  let scheme = call_589580.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589580.url(scheme.get, call_589580.host, call_589580.base,
                         call_589580.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589580, url, valid)

proc call*(call_589581: Call_BooksSeriesGet_589569; seriesId: JsonNode;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## booksSeriesGet
  ## Returns Series metadata for the given series ids.
  ##   seriesId: JArray (required)
  ##           : String that identifies the series
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589582 = newJObject()
  if seriesId != nil:
    query_589582.add "series_id", seriesId
  add(query_589582, "fields", newJString(fields))
  add(query_589582, "quotaUser", newJString(quotaUser))
  add(query_589582, "alt", newJString(alt))
  add(query_589582, "oauth_token", newJString(oauthToken))
  add(query_589582, "userIp", newJString(userIp))
  add(query_589582, "key", newJString(key))
  add(query_589582, "prettyPrint", newJBool(prettyPrint))
  result = call_589581.call(nil, query_589582, nil, nil, nil)

var booksSeriesGet* = Call_BooksSeriesGet_589569(name: "booksSeriesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/series/get",
    validator: validate_BooksSeriesGet_589570, base: "/books/v1",
    url: url_BooksSeriesGet_589571, schemes: {Scheme.Https})
type
  Call_BooksSeriesMembershipGet_589583 = ref object of OpenApiRestCall_588466
proc url_BooksSeriesMembershipGet_589585(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksSeriesMembershipGet_589584(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns Series membership data given the series id.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   series_id: JString (required)
  ##            : String that identifies the series
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   page_token: JString
  ##             : The value of the nextToken from the previous page.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   page_size: JInt
  ##            : Number of maximum results per page to be included in the response.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `series_id` field"
  var valid_589586 = query.getOrDefault("series_id")
  valid_589586 = validateParameter(valid_589586, JString, required = true,
                                 default = nil)
  if valid_589586 != nil:
    section.add "series_id", valid_589586
  var valid_589587 = query.getOrDefault("fields")
  valid_589587 = validateParameter(valid_589587, JString, required = false,
                                 default = nil)
  if valid_589587 != nil:
    section.add "fields", valid_589587
  var valid_589588 = query.getOrDefault("page_token")
  valid_589588 = validateParameter(valid_589588, JString, required = false,
                                 default = nil)
  if valid_589588 != nil:
    section.add "page_token", valid_589588
  var valid_589589 = query.getOrDefault("quotaUser")
  valid_589589 = validateParameter(valid_589589, JString, required = false,
                                 default = nil)
  if valid_589589 != nil:
    section.add "quotaUser", valid_589589
  var valid_589590 = query.getOrDefault("alt")
  valid_589590 = validateParameter(valid_589590, JString, required = false,
                                 default = newJString("json"))
  if valid_589590 != nil:
    section.add "alt", valid_589590
  var valid_589591 = query.getOrDefault("oauth_token")
  valid_589591 = validateParameter(valid_589591, JString, required = false,
                                 default = nil)
  if valid_589591 != nil:
    section.add "oauth_token", valid_589591
  var valid_589592 = query.getOrDefault("userIp")
  valid_589592 = validateParameter(valid_589592, JString, required = false,
                                 default = nil)
  if valid_589592 != nil:
    section.add "userIp", valid_589592
  var valid_589593 = query.getOrDefault("page_size")
  valid_589593 = validateParameter(valid_589593, JInt, required = false, default = nil)
  if valid_589593 != nil:
    section.add "page_size", valid_589593
  var valid_589594 = query.getOrDefault("key")
  valid_589594 = validateParameter(valid_589594, JString, required = false,
                                 default = nil)
  if valid_589594 != nil:
    section.add "key", valid_589594
  var valid_589595 = query.getOrDefault("prettyPrint")
  valid_589595 = validateParameter(valid_589595, JBool, required = false,
                                 default = newJBool(true))
  if valid_589595 != nil:
    section.add "prettyPrint", valid_589595
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589596: Call_BooksSeriesMembershipGet_589583; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Series membership data given the series id.
  ## 
  let valid = call_589596.validator(path, query, header, formData, body)
  let scheme = call_589596.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589596.url(scheme.get, call_589596.host, call_589596.base,
                         call_589596.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589596, url, valid)

proc call*(call_589597: Call_BooksSeriesMembershipGet_589583; seriesId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          pageSize: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## booksSeriesMembershipGet
  ## Returns Series membership data given the series id.
  ##   seriesId: string (required)
  ##           : String that identifies the series
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The value of the nextToken from the previous page.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   pageSize: int
  ##           : Number of maximum results per page to be included in the response.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589598 = newJObject()
  add(query_589598, "series_id", newJString(seriesId))
  add(query_589598, "fields", newJString(fields))
  add(query_589598, "page_token", newJString(pageToken))
  add(query_589598, "quotaUser", newJString(quotaUser))
  add(query_589598, "alt", newJString(alt))
  add(query_589598, "oauth_token", newJString(oauthToken))
  add(query_589598, "userIp", newJString(userIp))
  add(query_589598, "page_size", newJInt(pageSize))
  add(query_589598, "key", newJString(key))
  add(query_589598, "prettyPrint", newJBool(prettyPrint))
  result = call_589597.call(nil, query_589598, nil, nil, nil)

var booksSeriesMembershipGet* = Call_BooksSeriesMembershipGet_589583(
    name: "booksSeriesMembershipGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/series/membership/get",
    validator: validate_BooksSeriesMembershipGet_589584, base: "/books/v1",
    url: url_BooksSeriesMembershipGet_589585, schemes: {Scheme.Https})
type
  Call_BooksBookshelvesList_589599 = ref object of OpenApiRestCall_588466
proc url_BooksBookshelvesList_589601(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/bookshelves")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BooksBookshelvesList_589600(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of public bookshelves for the specified user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : ID of user for whom to retrieve bookshelves.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_589602 = path.getOrDefault("userId")
  valid_589602 = validateParameter(valid_589602, JString, required = true,
                                 default = nil)
  if valid_589602 != nil:
    section.add "userId", valid_589602
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589603 = query.getOrDefault("fields")
  valid_589603 = validateParameter(valid_589603, JString, required = false,
                                 default = nil)
  if valid_589603 != nil:
    section.add "fields", valid_589603
  var valid_589604 = query.getOrDefault("quotaUser")
  valid_589604 = validateParameter(valid_589604, JString, required = false,
                                 default = nil)
  if valid_589604 != nil:
    section.add "quotaUser", valid_589604
  var valid_589605 = query.getOrDefault("alt")
  valid_589605 = validateParameter(valid_589605, JString, required = false,
                                 default = newJString("json"))
  if valid_589605 != nil:
    section.add "alt", valid_589605
  var valid_589606 = query.getOrDefault("oauth_token")
  valid_589606 = validateParameter(valid_589606, JString, required = false,
                                 default = nil)
  if valid_589606 != nil:
    section.add "oauth_token", valid_589606
  var valid_589607 = query.getOrDefault("userIp")
  valid_589607 = validateParameter(valid_589607, JString, required = false,
                                 default = nil)
  if valid_589607 != nil:
    section.add "userIp", valid_589607
  var valid_589608 = query.getOrDefault("source")
  valid_589608 = validateParameter(valid_589608, JString, required = false,
                                 default = nil)
  if valid_589608 != nil:
    section.add "source", valid_589608
  var valid_589609 = query.getOrDefault("key")
  valid_589609 = validateParameter(valid_589609, JString, required = false,
                                 default = nil)
  if valid_589609 != nil:
    section.add "key", valid_589609
  var valid_589610 = query.getOrDefault("prettyPrint")
  valid_589610 = validateParameter(valid_589610, JBool, required = false,
                                 default = newJBool(true))
  if valid_589610 != nil:
    section.add "prettyPrint", valid_589610
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589611: Call_BooksBookshelvesList_589599; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of public bookshelves for the specified user.
  ## 
  let valid = call_589611.validator(path, query, header, formData, body)
  let scheme = call_589611.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589611.url(scheme.get, call_589611.host, call_589611.base,
                         call_589611.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589611, url, valid)

proc call*(call_589612: Call_BooksBookshelvesList_589599; userId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; source: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## booksBookshelvesList
  ## Retrieves a list of public bookshelves for the specified user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : ID of user for whom to retrieve bookshelves.
  var path_589613 = newJObject()
  var query_589614 = newJObject()
  add(query_589614, "fields", newJString(fields))
  add(query_589614, "quotaUser", newJString(quotaUser))
  add(query_589614, "alt", newJString(alt))
  add(query_589614, "oauth_token", newJString(oauthToken))
  add(query_589614, "userIp", newJString(userIp))
  add(query_589614, "source", newJString(source))
  add(query_589614, "key", newJString(key))
  add(query_589614, "prettyPrint", newJBool(prettyPrint))
  add(path_589613, "userId", newJString(userId))
  result = call_589612.call(path_589613, query_589614, nil, nil, nil)

var booksBookshelvesList* = Call_BooksBookshelvesList_589599(
    name: "booksBookshelvesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userId}/bookshelves",
    validator: validate_BooksBookshelvesList_589600, base: "/books/v1",
    url: url_BooksBookshelvesList_589601, schemes: {Scheme.Https})
type
  Call_BooksBookshelvesGet_589615 = ref object of OpenApiRestCall_588466
proc url_BooksBookshelvesGet_589617(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "shelf" in path, "`shelf` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/bookshelves/"),
               (kind: VariableSegment, value: "shelf")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BooksBookshelvesGet_589616(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves metadata for a specific bookshelf for the specified user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   shelf: JString (required)
  ##        : ID of bookshelf to retrieve.
  ##   userId: JString (required)
  ##         : ID of user for whom to retrieve bookshelves.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `shelf` field"
  var valid_589618 = path.getOrDefault("shelf")
  valid_589618 = validateParameter(valid_589618, JString, required = true,
                                 default = nil)
  if valid_589618 != nil:
    section.add "shelf", valid_589618
  var valid_589619 = path.getOrDefault("userId")
  valid_589619 = validateParameter(valid_589619, JString, required = true,
                                 default = nil)
  if valid_589619 != nil:
    section.add "userId", valid_589619
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589620 = query.getOrDefault("fields")
  valid_589620 = validateParameter(valid_589620, JString, required = false,
                                 default = nil)
  if valid_589620 != nil:
    section.add "fields", valid_589620
  var valid_589621 = query.getOrDefault("quotaUser")
  valid_589621 = validateParameter(valid_589621, JString, required = false,
                                 default = nil)
  if valid_589621 != nil:
    section.add "quotaUser", valid_589621
  var valid_589622 = query.getOrDefault("alt")
  valid_589622 = validateParameter(valid_589622, JString, required = false,
                                 default = newJString("json"))
  if valid_589622 != nil:
    section.add "alt", valid_589622
  var valid_589623 = query.getOrDefault("oauth_token")
  valid_589623 = validateParameter(valid_589623, JString, required = false,
                                 default = nil)
  if valid_589623 != nil:
    section.add "oauth_token", valid_589623
  var valid_589624 = query.getOrDefault("userIp")
  valid_589624 = validateParameter(valid_589624, JString, required = false,
                                 default = nil)
  if valid_589624 != nil:
    section.add "userIp", valid_589624
  var valid_589625 = query.getOrDefault("source")
  valid_589625 = validateParameter(valid_589625, JString, required = false,
                                 default = nil)
  if valid_589625 != nil:
    section.add "source", valid_589625
  var valid_589626 = query.getOrDefault("key")
  valid_589626 = validateParameter(valid_589626, JString, required = false,
                                 default = nil)
  if valid_589626 != nil:
    section.add "key", valid_589626
  var valid_589627 = query.getOrDefault("prettyPrint")
  valid_589627 = validateParameter(valid_589627, JBool, required = false,
                                 default = newJBool(true))
  if valid_589627 != nil:
    section.add "prettyPrint", valid_589627
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589628: Call_BooksBookshelvesGet_589615; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves metadata for a specific bookshelf for the specified user.
  ## 
  let valid = call_589628.validator(path, query, header, formData, body)
  let scheme = call_589628.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589628.url(scheme.get, call_589628.host, call_589628.base,
                         call_589628.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589628, url, valid)

proc call*(call_589629: Call_BooksBookshelvesGet_589615; shelf: string;
          userId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          source: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## booksBookshelvesGet
  ## Retrieves metadata for a specific bookshelf for the specified user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   shelf: string (required)
  ##        : ID of bookshelf to retrieve.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : ID of user for whom to retrieve bookshelves.
  var path_589630 = newJObject()
  var query_589631 = newJObject()
  add(query_589631, "fields", newJString(fields))
  add(query_589631, "quotaUser", newJString(quotaUser))
  add(query_589631, "alt", newJString(alt))
  add(query_589631, "oauth_token", newJString(oauthToken))
  add(query_589631, "userIp", newJString(userIp))
  add(path_589630, "shelf", newJString(shelf))
  add(query_589631, "source", newJString(source))
  add(query_589631, "key", newJString(key))
  add(query_589631, "prettyPrint", newJBool(prettyPrint))
  add(path_589630, "userId", newJString(userId))
  result = call_589629.call(path_589630, query_589631, nil, nil, nil)

var booksBookshelvesGet* = Call_BooksBookshelvesGet_589615(
    name: "booksBookshelvesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userId}/bookshelves/{shelf}",
    validator: validate_BooksBookshelvesGet_589616, base: "/books/v1",
    url: url_BooksBookshelvesGet_589617, schemes: {Scheme.Https})
type
  Call_BooksBookshelvesVolumesList_589632 = ref object of OpenApiRestCall_588466
proc url_BooksBookshelvesVolumesList_589634(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "shelf" in path, "`shelf` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/bookshelves/"),
               (kind: VariableSegment, value: "shelf"),
               (kind: ConstantSegment, value: "/volumes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BooksBookshelvesVolumesList_589633(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves volumes in a specific bookshelf for the specified user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   shelf: JString (required)
  ##        : ID of bookshelf to retrieve volumes.
  ##   userId: JString (required)
  ##         : ID of user for whom to retrieve bookshelf volumes.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `shelf` field"
  var valid_589635 = path.getOrDefault("shelf")
  valid_589635 = validateParameter(valid_589635, JString, required = true,
                                 default = nil)
  if valid_589635 != nil:
    section.add "shelf", valid_589635
  var valid_589636 = path.getOrDefault("userId")
  valid_589636 = validateParameter(valid_589636, JString, required = true,
                                 default = nil)
  if valid_589636 != nil:
    section.add "userId", valid_589636
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of results to return
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   showPreorders: JBool
  ##                : Set to true to show pre-ordered books. Defaults to false.
  ##   startIndex: JInt
  ##             : Index of the first element to return (starts at 0)
  section = newJObject()
  var valid_589637 = query.getOrDefault("fields")
  valid_589637 = validateParameter(valid_589637, JString, required = false,
                                 default = nil)
  if valid_589637 != nil:
    section.add "fields", valid_589637
  var valid_589638 = query.getOrDefault("quotaUser")
  valid_589638 = validateParameter(valid_589638, JString, required = false,
                                 default = nil)
  if valid_589638 != nil:
    section.add "quotaUser", valid_589638
  var valid_589639 = query.getOrDefault("alt")
  valid_589639 = validateParameter(valid_589639, JString, required = false,
                                 default = newJString("json"))
  if valid_589639 != nil:
    section.add "alt", valid_589639
  var valid_589640 = query.getOrDefault("oauth_token")
  valid_589640 = validateParameter(valid_589640, JString, required = false,
                                 default = nil)
  if valid_589640 != nil:
    section.add "oauth_token", valid_589640
  var valid_589641 = query.getOrDefault("userIp")
  valid_589641 = validateParameter(valid_589641, JString, required = false,
                                 default = nil)
  if valid_589641 != nil:
    section.add "userIp", valid_589641
  var valid_589642 = query.getOrDefault("maxResults")
  valid_589642 = validateParameter(valid_589642, JInt, required = false, default = nil)
  if valid_589642 != nil:
    section.add "maxResults", valid_589642
  var valid_589643 = query.getOrDefault("source")
  valid_589643 = validateParameter(valid_589643, JString, required = false,
                                 default = nil)
  if valid_589643 != nil:
    section.add "source", valid_589643
  var valid_589644 = query.getOrDefault("key")
  valid_589644 = validateParameter(valid_589644, JString, required = false,
                                 default = nil)
  if valid_589644 != nil:
    section.add "key", valid_589644
  var valid_589645 = query.getOrDefault("prettyPrint")
  valid_589645 = validateParameter(valid_589645, JBool, required = false,
                                 default = newJBool(true))
  if valid_589645 != nil:
    section.add "prettyPrint", valid_589645
  var valid_589646 = query.getOrDefault("showPreorders")
  valid_589646 = validateParameter(valid_589646, JBool, required = false, default = nil)
  if valid_589646 != nil:
    section.add "showPreorders", valid_589646
  var valid_589647 = query.getOrDefault("startIndex")
  valid_589647 = validateParameter(valid_589647, JInt, required = false, default = nil)
  if valid_589647 != nil:
    section.add "startIndex", valid_589647
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589648: Call_BooksBookshelvesVolumesList_589632; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves volumes in a specific bookshelf for the specified user.
  ## 
  let valid = call_589648.validator(path, query, header, formData, body)
  let scheme = call_589648.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589648.url(scheme.get, call_589648.host, call_589648.base,
                         call_589648.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589648, url, valid)

proc call*(call_589649: Call_BooksBookshelvesVolumesList_589632; shelf: string;
          userId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; source: string = ""; key: string = "";
          prettyPrint: bool = true; showPreorders: bool = false; startIndex: int = 0): Recallable =
  ## booksBookshelvesVolumesList
  ## Retrieves volumes in a specific bookshelf for the specified user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   shelf: string (required)
  ##        : ID of bookshelf to retrieve volumes.
  ##   maxResults: int
  ##             : Maximum number of results to return
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   showPreorders: bool
  ##                : Set to true to show pre-ordered books. Defaults to false.
  ##   userId: string (required)
  ##         : ID of user for whom to retrieve bookshelf volumes.
  ##   startIndex: int
  ##             : Index of the first element to return (starts at 0)
  var path_589650 = newJObject()
  var query_589651 = newJObject()
  add(query_589651, "fields", newJString(fields))
  add(query_589651, "quotaUser", newJString(quotaUser))
  add(query_589651, "alt", newJString(alt))
  add(query_589651, "oauth_token", newJString(oauthToken))
  add(query_589651, "userIp", newJString(userIp))
  add(path_589650, "shelf", newJString(shelf))
  add(query_589651, "maxResults", newJInt(maxResults))
  add(query_589651, "source", newJString(source))
  add(query_589651, "key", newJString(key))
  add(query_589651, "prettyPrint", newJBool(prettyPrint))
  add(query_589651, "showPreorders", newJBool(showPreorders))
  add(path_589650, "userId", newJString(userId))
  add(query_589651, "startIndex", newJInt(startIndex))
  result = call_589649.call(path_589650, query_589651, nil, nil, nil)

var booksBookshelvesVolumesList* = Call_BooksBookshelvesVolumesList_589632(
    name: "booksBookshelvesVolumesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/users/{userId}/bookshelves/{shelf}/volumes",
    validator: validate_BooksBookshelvesVolumesList_589633, base: "/books/v1",
    url: url_BooksBookshelvesVolumesList_589634, schemes: {Scheme.Https})
type
  Call_BooksVolumesList_589652 = ref object of OpenApiRestCall_588466
proc url_BooksVolumesList_589654(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksVolumesList_589653(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Performs a book search.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   libraryRestrict: JString
  ##                  : Restrict search to this user's library.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   langRestrict: JString
  ##               : Restrict results to books with this language code.
  ##   maxResults: JInt
  ##             : Maximum number of results to return.
  ##   orderBy: JString
  ##          : Sort search results.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   q: JString (required)
  ##    : Full-text search query string.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Restrict information returned to a set of selected fields.
  ##   partner: JString
  ##          : Restrict and brand results for partner ID.
  ##   download: JString
  ##           : Restrict to volumes by download availability.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   maxAllowedMaturityRating: JString
  ##                           : The maximum allowed maturity rating of returned recommendations. Books with a higher maturity rating are filtered out.
  ##   showPreorders: JBool
  ##                : Set to true to show books available for preorder. Defaults to false.
  ##   filter: JString
  ##         : Filter search results.
  ##   printType: JString
  ##            : Restrict to books or magazines.
  ##   startIndex: JInt
  ##             : Index of the first result to return (starts at 0)
  section = newJObject()
  var valid_589655 = query.getOrDefault("libraryRestrict")
  valid_589655 = validateParameter(valid_589655, JString, required = false,
                                 default = newJString("my-library"))
  if valid_589655 != nil:
    section.add "libraryRestrict", valid_589655
  var valid_589656 = query.getOrDefault("fields")
  valid_589656 = validateParameter(valid_589656, JString, required = false,
                                 default = nil)
  if valid_589656 != nil:
    section.add "fields", valid_589656
  var valid_589657 = query.getOrDefault("quotaUser")
  valid_589657 = validateParameter(valid_589657, JString, required = false,
                                 default = nil)
  if valid_589657 != nil:
    section.add "quotaUser", valid_589657
  var valid_589658 = query.getOrDefault("alt")
  valid_589658 = validateParameter(valid_589658, JString, required = false,
                                 default = newJString("json"))
  if valid_589658 != nil:
    section.add "alt", valid_589658
  var valid_589659 = query.getOrDefault("oauth_token")
  valid_589659 = validateParameter(valid_589659, JString, required = false,
                                 default = nil)
  if valid_589659 != nil:
    section.add "oauth_token", valid_589659
  var valid_589660 = query.getOrDefault("userIp")
  valid_589660 = validateParameter(valid_589660, JString, required = false,
                                 default = nil)
  if valid_589660 != nil:
    section.add "userIp", valid_589660
  var valid_589661 = query.getOrDefault("langRestrict")
  valid_589661 = validateParameter(valid_589661, JString, required = false,
                                 default = nil)
  if valid_589661 != nil:
    section.add "langRestrict", valid_589661
  var valid_589662 = query.getOrDefault("maxResults")
  valid_589662 = validateParameter(valid_589662, JInt, required = false, default = nil)
  if valid_589662 != nil:
    section.add "maxResults", valid_589662
  var valid_589663 = query.getOrDefault("orderBy")
  valid_589663 = validateParameter(valid_589663, JString, required = false,
                                 default = newJString("newest"))
  if valid_589663 != nil:
    section.add "orderBy", valid_589663
  var valid_589664 = query.getOrDefault("source")
  valid_589664 = validateParameter(valid_589664, JString, required = false,
                                 default = nil)
  if valid_589664 != nil:
    section.add "source", valid_589664
  assert query != nil, "query argument is necessary due to required `q` field"
  var valid_589665 = query.getOrDefault("q")
  valid_589665 = validateParameter(valid_589665, JString, required = true,
                                 default = nil)
  if valid_589665 != nil:
    section.add "q", valid_589665
  var valid_589666 = query.getOrDefault("key")
  valid_589666 = validateParameter(valid_589666, JString, required = false,
                                 default = nil)
  if valid_589666 != nil:
    section.add "key", valid_589666
  var valid_589667 = query.getOrDefault("projection")
  valid_589667 = validateParameter(valid_589667, JString, required = false,
                                 default = newJString("full"))
  if valid_589667 != nil:
    section.add "projection", valid_589667
  var valid_589668 = query.getOrDefault("partner")
  valid_589668 = validateParameter(valid_589668, JString, required = false,
                                 default = nil)
  if valid_589668 != nil:
    section.add "partner", valid_589668
  var valid_589669 = query.getOrDefault("download")
  valid_589669 = validateParameter(valid_589669, JString, required = false,
                                 default = newJString("epub"))
  if valid_589669 != nil:
    section.add "download", valid_589669
  var valid_589670 = query.getOrDefault("prettyPrint")
  valid_589670 = validateParameter(valid_589670, JBool, required = false,
                                 default = newJBool(true))
  if valid_589670 != nil:
    section.add "prettyPrint", valid_589670
  var valid_589671 = query.getOrDefault("maxAllowedMaturityRating")
  valid_589671 = validateParameter(valid_589671, JString, required = false,
                                 default = newJString("mature"))
  if valid_589671 != nil:
    section.add "maxAllowedMaturityRating", valid_589671
  var valid_589672 = query.getOrDefault("showPreorders")
  valid_589672 = validateParameter(valid_589672, JBool, required = false, default = nil)
  if valid_589672 != nil:
    section.add "showPreorders", valid_589672
  var valid_589673 = query.getOrDefault("filter")
  valid_589673 = validateParameter(valid_589673, JString, required = false,
                                 default = newJString("ebooks"))
  if valid_589673 != nil:
    section.add "filter", valid_589673
  var valid_589674 = query.getOrDefault("printType")
  valid_589674 = validateParameter(valid_589674, JString, required = false,
                                 default = newJString("all"))
  if valid_589674 != nil:
    section.add "printType", valid_589674
  var valid_589675 = query.getOrDefault("startIndex")
  valid_589675 = validateParameter(valid_589675, JInt, required = false, default = nil)
  if valid_589675 != nil:
    section.add "startIndex", valid_589675
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589676: Call_BooksVolumesList_589652; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs a book search.
  ## 
  let valid = call_589676.validator(path, query, header, formData, body)
  let scheme = call_589676.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589676.url(scheme.get, call_589676.host, call_589676.base,
                         call_589676.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589676, url, valid)

proc call*(call_589677: Call_BooksVolumesList_589652; q: string;
          libraryRestrict: string = "my-library"; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; langRestrict: string = ""; maxResults: int = 0;
          orderBy: string = "newest"; source: string = ""; key: string = "";
          projection: string = "full"; partner: string = ""; download: string = "epub";
          prettyPrint: bool = true; maxAllowedMaturityRating: string = "mature";
          showPreorders: bool = false; filter: string = "ebooks";
          printType: string = "all"; startIndex: int = 0): Recallable =
  ## booksVolumesList
  ## Performs a book search.
  ##   libraryRestrict: string
  ##                  : Restrict search to this user's library.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   langRestrict: string
  ##               : Restrict results to books with this language code.
  ##   maxResults: int
  ##             : Maximum number of results to return.
  ##   orderBy: string
  ##          : Sort search results.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   q: string (required)
  ##    : Full-text search query string.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Restrict information returned to a set of selected fields.
  ##   partner: string
  ##          : Restrict and brand results for partner ID.
  ##   download: string
  ##           : Restrict to volumes by download availability.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   maxAllowedMaturityRating: string
  ##                           : The maximum allowed maturity rating of returned recommendations. Books with a higher maturity rating are filtered out.
  ##   showPreorders: bool
  ##                : Set to true to show books available for preorder. Defaults to false.
  ##   filter: string
  ##         : Filter search results.
  ##   printType: string
  ##            : Restrict to books or magazines.
  ##   startIndex: int
  ##             : Index of the first result to return (starts at 0)
  var query_589678 = newJObject()
  add(query_589678, "libraryRestrict", newJString(libraryRestrict))
  add(query_589678, "fields", newJString(fields))
  add(query_589678, "quotaUser", newJString(quotaUser))
  add(query_589678, "alt", newJString(alt))
  add(query_589678, "oauth_token", newJString(oauthToken))
  add(query_589678, "userIp", newJString(userIp))
  add(query_589678, "langRestrict", newJString(langRestrict))
  add(query_589678, "maxResults", newJInt(maxResults))
  add(query_589678, "orderBy", newJString(orderBy))
  add(query_589678, "source", newJString(source))
  add(query_589678, "q", newJString(q))
  add(query_589678, "key", newJString(key))
  add(query_589678, "projection", newJString(projection))
  add(query_589678, "partner", newJString(partner))
  add(query_589678, "download", newJString(download))
  add(query_589678, "prettyPrint", newJBool(prettyPrint))
  add(query_589678, "maxAllowedMaturityRating",
      newJString(maxAllowedMaturityRating))
  add(query_589678, "showPreorders", newJBool(showPreorders))
  add(query_589678, "filter", newJString(filter))
  add(query_589678, "printType", newJString(printType))
  add(query_589678, "startIndex", newJInt(startIndex))
  result = call_589677.call(nil, query_589678, nil, nil, nil)

var booksVolumesList* = Call_BooksVolumesList_589652(name: "booksVolumesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/volumes",
    validator: validate_BooksVolumesList_589653, base: "/books/v1",
    url: url_BooksVolumesList_589654, schemes: {Scheme.Https})
type
  Call_BooksVolumesMybooksList_589679 = ref object of OpenApiRestCall_588466
proc url_BooksVolumesMybooksList_589681(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksVolumesMybooksList_589680(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Return a list of books in My Library.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   locale: JString
  ##         : ISO-639-1 language and ISO-3166-1 country code. Ex:'en_US'. Used for generating recommendations.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   country: JString
  ##          : ISO-3166-1 code to override the IP-based location.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   processingState: JArray
  ##                  : The processing state of the user uploaded volumes to be returned. Applicable only if the UPLOADED is specified in the acquireMethod.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of results to return.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   acquireMethod: JArray
  ##                : How the book was acquired
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: JInt
  ##             : Index of the first result to return (starts at 0)
  section = newJObject()
  var valid_589682 = query.getOrDefault("locale")
  valid_589682 = validateParameter(valid_589682, JString, required = false,
                                 default = nil)
  if valid_589682 != nil:
    section.add "locale", valid_589682
  var valid_589683 = query.getOrDefault("fields")
  valid_589683 = validateParameter(valid_589683, JString, required = false,
                                 default = nil)
  if valid_589683 != nil:
    section.add "fields", valid_589683
  var valid_589684 = query.getOrDefault("country")
  valid_589684 = validateParameter(valid_589684, JString, required = false,
                                 default = nil)
  if valid_589684 != nil:
    section.add "country", valid_589684
  var valid_589685 = query.getOrDefault("quotaUser")
  valid_589685 = validateParameter(valid_589685, JString, required = false,
                                 default = nil)
  if valid_589685 != nil:
    section.add "quotaUser", valid_589685
  var valid_589686 = query.getOrDefault("processingState")
  valid_589686 = validateParameter(valid_589686, JArray, required = false,
                                 default = nil)
  if valid_589686 != nil:
    section.add "processingState", valid_589686
  var valid_589687 = query.getOrDefault("alt")
  valid_589687 = validateParameter(valid_589687, JString, required = false,
                                 default = newJString("json"))
  if valid_589687 != nil:
    section.add "alt", valid_589687
  var valid_589688 = query.getOrDefault("oauth_token")
  valid_589688 = validateParameter(valid_589688, JString, required = false,
                                 default = nil)
  if valid_589688 != nil:
    section.add "oauth_token", valid_589688
  var valid_589689 = query.getOrDefault("userIp")
  valid_589689 = validateParameter(valid_589689, JString, required = false,
                                 default = nil)
  if valid_589689 != nil:
    section.add "userIp", valid_589689
  var valid_589690 = query.getOrDefault("maxResults")
  valid_589690 = validateParameter(valid_589690, JInt, required = false, default = nil)
  if valid_589690 != nil:
    section.add "maxResults", valid_589690
  var valid_589691 = query.getOrDefault("source")
  valid_589691 = validateParameter(valid_589691, JString, required = false,
                                 default = nil)
  if valid_589691 != nil:
    section.add "source", valid_589691
  var valid_589692 = query.getOrDefault("key")
  valid_589692 = validateParameter(valid_589692, JString, required = false,
                                 default = nil)
  if valid_589692 != nil:
    section.add "key", valid_589692
  var valid_589693 = query.getOrDefault("acquireMethod")
  valid_589693 = validateParameter(valid_589693, JArray, required = false,
                                 default = nil)
  if valid_589693 != nil:
    section.add "acquireMethod", valid_589693
  var valid_589694 = query.getOrDefault("prettyPrint")
  valid_589694 = validateParameter(valid_589694, JBool, required = false,
                                 default = newJBool(true))
  if valid_589694 != nil:
    section.add "prettyPrint", valid_589694
  var valid_589695 = query.getOrDefault("startIndex")
  valid_589695 = validateParameter(valid_589695, JInt, required = false, default = nil)
  if valid_589695 != nil:
    section.add "startIndex", valid_589695
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589696: Call_BooksVolumesMybooksList_589679; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return a list of books in My Library.
  ## 
  let valid = call_589696.validator(path, query, header, formData, body)
  let scheme = call_589696.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589696.url(scheme.get, call_589696.host, call_589696.base,
                         call_589696.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589696, url, valid)

proc call*(call_589697: Call_BooksVolumesMybooksList_589679; locale: string = "";
          fields: string = ""; country: string = ""; quotaUser: string = "";
          processingState: JsonNode = nil; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          source: string = ""; key: string = ""; acquireMethod: JsonNode = nil;
          prettyPrint: bool = true; startIndex: int = 0): Recallable =
  ## booksVolumesMybooksList
  ## Return a list of books in My Library.
  ##   locale: string
  ##         : ISO-639-1 language and ISO-3166-1 country code. Ex:'en_US'. Used for generating recommendations.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   country: string
  ##          : ISO-3166-1 code to override the IP-based location.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   processingState: JArray
  ##                  : The processing state of the user uploaded volumes to be returned. Applicable only if the UPLOADED is specified in the acquireMethod.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of results to return.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   acquireMethod: JArray
  ##                : How the book was acquired
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: int
  ##             : Index of the first result to return (starts at 0)
  var query_589698 = newJObject()
  add(query_589698, "locale", newJString(locale))
  add(query_589698, "fields", newJString(fields))
  add(query_589698, "country", newJString(country))
  add(query_589698, "quotaUser", newJString(quotaUser))
  if processingState != nil:
    query_589698.add "processingState", processingState
  add(query_589698, "alt", newJString(alt))
  add(query_589698, "oauth_token", newJString(oauthToken))
  add(query_589698, "userIp", newJString(userIp))
  add(query_589698, "maxResults", newJInt(maxResults))
  add(query_589698, "source", newJString(source))
  add(query_589698, "key", newJString(key))
  if acquireMethod != nil:
    query_589698.add "acquireMethod", acquireMethod
  add(query_589698, "prettyPrint", newJBool(prettyPrint))
  add(query_589698, "startIndex", newJInt(startIndex))
  result = call_589697.call(nil, query_589698, nil, nil, nil)

var booksVolumesMybooksList* = Call_BooksVolumesMybooksList_589679(
    name: "booksVolumesMybooksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/volumes/mybooks",
    validator: validate_BooksVolumesMybooksList_589680, base: "/books/v1",
    url: url_BooksVolumesMybooksList_589681, schemes: {Scheme.Https})
type
  Call_BooksVolumesRecommendedList_589699 = ref object of OpenApiRestCall_588466
proc url_BooksVolumesRecommendedList_589701(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksVolumesRecommendedList_589700(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Return a list of recommended books for the current user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   locale: JString
  ##         : ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'. Used for generating recommendations.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   maxAllowedMaturityRating: JString
  ##                           : The maximum allowed maturity rating of returned recommendations. Books with a higher maturity rating are filtered out.
  section = newJObject()
  var valid_589702 = query.getOrDefault("locale")
  valid_589702 = validateParameter(valid_589702, JString, required = false,
                                 default = nil)
  if valid_589702 != nil:
    section.add "locale", valid_589702
  var valid_589703 = query.getOrDefault("fields")
  valid_589703 = validateParameter(valid_589703, JString, required = false,
                                 default = nil)
  if valid_589703 != nil:
    section.add "fields", valid_589703
  var valid_589704 = query.getOrDefault("quotaUser")
  valid_589704 = validateParameter(valid_589704, JString, required = false,
                                 default = nil)
  if valid_589704 != nil:
    section.add "quotaUser", valid_589704
  var valid_589705 = query.getOrDefault("alt")
  valid_589705 = validateParameter(valid_589705, JString, required = false,
                                 default = newJString("json"))
  if valid_589705 != nil:
    section.add "alt", valid_589705
  var valid_589706 = query.getOrDefault("oauth_token")
  valid_589706 = validateParameter(valid_589706, JString, required = false,
                                 default = nil)
  if valid_589706 != nil:
    section.add "oauth_token", valid_589706
  var valid_589707 = query.getOrDefault("userIp")
  valid_589707 = validateParameter(valid_589707, JString, required = false,
                                 default = nil)
  if valid_589707 != nil:
    section.add "userIp", valid_589707
  var valid_589708 = query.getOrDefault("source")
  valid_589708 = validateParameter(valid_589708, JString, required = false,
                                 default = nil)
  if valid_589708 != nil:
    section.add "source", valid_589708
  var valid_589709 = query.getOrDefault("key")
  valid_589709 = validateParameter(valid_589709, JString, required = false,
                                 default = nil)
  if valid_589709 != nil:
    section.add "key", valid_589709
  var valid_589710 = query.getOrDefault("prettyPrint")
  valid_589710 = validateParameter(valid_589710, JBool, required = false,
                                 default = newJBool(true))
  if valid_589710 != nil:
    section.add "prettyPrint", valid_589710
  var valid_589711 = query.getOrDefault("maxAllowedMaturityRating")
  valid_589711 = validateParameter(valid_589711, JString, required = false,
                                 default = newJString("mature"))
  if valid_589711 != nil:
    section.add "maxAllowedMaturityRating", valid_589711
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589712: Call_BooksVolumesRecommendedList_589699; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return a list of recommended books for the current user.
  ## 
  let valid = call_589712.validator(path, query, header, formData, body)
  let scheme = call_589712.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589712.url(scheme.get, call_589712.host, call_589712.base,
                         call_589712.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589712, url, valid)

proc call*(call_589713: Call_BooksVolumesRecommendedList_589699;
          locale: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          source: string = ""; key: string = ""; prettyPrint: bool = true;
          maxAllowedMaturityRating: string = "mature"): Recallable =
  ## booksVolumesRecommendedList
  ## Return a list of recommended books for the current user.
  ##   locale: string
  ##         : ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'. Used for generating recommendations.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   maxAllowedMaturityRating: string
  ##                           : The maximum allowed maturity rating of returned recommendations. Books with a higher maturity rating are filtered out.
  var query_589714 = newJObject()
  add(query_589714, "locale", newJString(locale))
  add(query_589714, "fields", newJString(fields))
  add(query_589714, "quotaUser", newJString(quotaUser))
  add(query_589714, "alt", newJString(alt))
  add(query_589714, "oauth_token", newJString(oauthToken))
  add(query_589714, "userIp", newJString(userIp))
  add(query_589714, "source", newJString(source))
  add(query_589714, "key", newJString(key))
  add(query_589714, "prettyPrint", newJBool(prettyPrint))
  add(query_589714, "maxAllowedMaturityRating",
      newJString(maxAllowedMaturityRating))
  result = call_589713.call(nil, query_589714, nil, nil, nil)

var booksVolumesRecommendedList* = Call_BooksVolumesRecommendedList_589699(
    name: "booksVolumesRecommendedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/volumes/recommended",
    validator: validate_BooksVolumesRecommendedList_589700, base: "/books/v1",
    url: url_BooksVolumesRecommendedList_589701, schemes: {Scheme.Https})
type
  Call_BooksVolumesRecommendedRate_589715 = ref object of OpenApiRestCall_588466
proc url_BooksVolumesRecommendedRate_589717(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksVolumesRecommendedRate_589716(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rate a recommended book for the current user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   locale: JString
  ##         : ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'. Used for generating recommendations.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   rating: JString (required)
  ##         : Rating to be given to the volume.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   volumeId: JString (required)
  ##           : ID of the source volume.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589718 = query.getOrDefault("locale")
  valid_589718 = validateParameter(valid_589718, JString, required = false,
                                 default = nil)
  if valid_589718 != nil:
    section.add "locale", valid_589718
  var valid_589719 = query.getOrDefault("fields")
  valid_589719 = validateParameter(valid_589719, JString, required = false,
                                 default = nil)
  if valid_589719 != nil:
    section.add "fields", valid_589719
  var valid_589720 = query.getOrDefault("quotaUser")
  valid_589720 = validateParameter(valid_589720, JString, required = false,
                                 default = nil)
  if valid_589720 != nil:
    section.add "quotaUser", valid_589720
  var valid_589721 = query.getOrDefault("alt")
  valid_589721 = validateParameter(valid_589721, JString, required = false,
                                 default = newJString("json"))
  if valid_589721 != nil:
    section.add "alt", valid_589721
  assert query != nil, "query argument is necessary due to required `rating` field"
  var valid_589722 = query.getOrDefault("rating")
  valid_589722 = validateParameter(valid_589722, JString, required = true,
                                 default = newJString("HAVE_IT"))
  if valid_589722 != nil:
    section.add "rating", valid_589722
  var valid_589723 = query.getOrDefault("oauth_token")
  valid_589723 = validateParameter(valid_589723, JString, required = false,
                                 default = nil)
  if valid_589723 != nil:
    section.add "oauth_token", valid_589723
  var valid_589724 = query.getOrDefault("userIp")
  valid_589724 = validateParameter(valid_589724, JString, required = false,
                                 default = nil)
  if valid_589724 != nil:
    section.add "userIp", valid_589724
  var valid_589725 = query.getOrDefault("source")
  valid_589725 = validateParameter(valid_589725, JString, required = false,
                                 default = nil)
  if valid_589725 != nil:
    section.add "source", valid_589725
  var valid_589726 = query.getOrDefault("key")
  valid_589726 = validateParameter(valid_589726, JString, required = false,
                                 default = nil)
  if valid_589726 != nil:
    section.add "key", valid_589726
  var valid_589727 = query.getOrDefault("volumeId")
  valid_589727 = validateParameter(valid_589727, JString, required = true,
                                 default = nil)
  if valid_589727 != nil:
    section.add "volumeId", valid_589727
  var valid_589728 = query.getOrDefault("prettyPrint")
  valid_589728 = validateParameter(valid_589728, JBool, required = false,
                                 default = newJBool(true))
  if valid_589728 != nil:
    section.add "prettyPrint", valid_589728
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589729: Call_BooksVolumesRecommendedRate_589715; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rate a recommended book for the current user.
  ## 
  let valid = call_589729.validator(path, query, header, formData, body)
  let scheme = call_589729.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589729.url(scheme.get, call_589729.host, call_589729.base,
                         call_589729.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589729, url, valid)

proc call*(call_589730: Call_BooksVolumesRecommendedRate_589715; volumeId: string;
          locale: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; rating: string = "HAVE_IT"; oauthToken: string = "";
          userIp: string = ""; source: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## booksVolumesRecommendedRate
  ## Rate a recommended book for the current user.
  ##   locale: string
  ##         : ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'. Used for generating recommendations.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   rating: string (required)
  ##         : Rating to be given to the volume.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   volumeId: string (required)
  ##           : ID of the source volume.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589731 = newJObject()
  add(query_589731, "locale", newJString(locale))
  add(query_589731, "fields", newJString(fields))
  add(query_589731, "quotaUser", newJString(quotaUser))
  add(query_589731, "alt", newJString(alt))
  add(query_589731, "rating", newJString(rating))
  add(query_589731, "oauth_token", newJString(oauthToken))
  add(query_589731, "userIp", newJString(userIp))
  add(query_589731, "source", newJString(source))
  add(query_589731, "key", newJString(key))
  add(query_589731, "volumeId", newJString(volumeId))
  add(query_589731, "prettyPrint", newJBool(prettyPrint))
  result = call_589730.call(nil, query_589731, nil, nil, nil)

var booksVolumesRecommendedRate* = Call_BooksVolumesRecommendedRate_589715(
    name: "booksVolumesRecommendedRate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/volumes/recommended/rate",
    validator: validate_BooksVolumesRecommendedRate_589716, base: "/books/v1",
    url: url_BooksVolumesRecommendedRate_589717, schemes: {Scheme.Https})
type
  Call_BooksVolumesUseruploadedList_589732 = ref object of OpenApiRestCall_588466
proc url_BooksVolumesUseruploadedList_589734(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksVolumesUseruploadedList_589733(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Return a list of books uploaded by the current user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   locale: JString
  ##         : ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'. Used for generating recommendations.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   processingState: JArray
  ##                  : The processing state of the user uploaded volumes to be returned.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of results to return.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   volumeId: JArray
  ##           : The ids of the volumes to be returned. If not specified all that match the processingState are returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: JInt
  ##             : Index of the first result to return (starts at 0)
  section = newJObject()
  var valid_589735 = query.getOrDefault("locale")
  valid_589735 = validateParameter(valid_589735, JString, required = false,
                                 default = nil)
  if valid_589735 != nil:
    section.add "locale", valid_589735
  var valid_589736 = query.getOrDefault("fields")
  valid_589736 = validateParameter(valid_589736, JString, required = false,
                                 default = nil)
  if valid_589736 != nil:
    section.add "fields", valid_589736
  var valid_589737 = query.getOrDefault("quotaUser")
  valid_589737 = validateParameter(valid_589737, JString, required = false,
                                 default = nil)
  if valid_589737 != nil:
    section.add "quotaUser", valid_589737
  var valid_589738 = query.getOrDefault("processingState")
  valid_589738 = validateParameter(valid_589738, JArray, required = false,
                                 default = nil)
  if valid_589738 != nil:
    section.add "processingState", valid_589738
  var valid_589739 = query.getOrDefault("alt")
  valid_589739 = validateParameter(valid_589739, JString, required = false,
                                 default = newJString("json"))
  if valid_589739 != nil:
    section.add "alt", valid_589739
  var valid_589740 = query.getOrDefault("oauth_token")
  valid_589740 = validateParameter(valid_589740, JString, required = false,
                                 default = nil)
  if valid_589740 != nil:
    section.add "oauth_token", valid_589740
  var valid_589741 = query.getOrDefault("userIp")
  valid_589741 = validateParameter(valid_589741, JString, required = false,
                                 default = nil)
  if valid_589741 != nil:
    section.add "userIp", valid_589741
  var valid_589742 = query.getOrDefault("maxResults")
  valid_589742 = validateParameter(valid_589742, JInt, required = false, default = nil)
  if valid_589742 != nil:
    section.add "maxResults", valid_589742
  var valid_589743 = query.getOrDefault("source")
  valid_589743 = validateParameter(valid_589743, JString, required = false,
                                 default = nil)
  if valid_589743 != nil:
    section.add "source", valid_589743
  var valid_589744 = query.getOrDefault("key")
  valid_589744 = validateParameter(valid_589744, JString, required = false,
                                 default = nil)
  if valid_589744 != nil:
    section.add "key", valid_589744
  var valid_589745 = query.getOrDefault("volumeId")
  valid_589745 = validateParameter(valid_589745, JArray, required = false,
                                 default = nil)
  if valid_589745 != nil:
    section.add "volumeId", valid_589745
  var valid_589746 = query.getOrDefault("prettyPrint")
  valid_589746 = validateParameter(valid_589746, JBool, required = false,
                                 default = newJBool(true))
  if valid_589746 != nil:
    section.add "prettyPrint", valid_589746
  var valid_589747 = query.getOrDefault("startIndex")
  valid_589747 = validateParameter(valid_589747, JInt, required = false, default = nil)
  if valid_589747 != nil:
    section.add "startIndex", valid_589747
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589748: Call_BooksVolumesUseruploadedList_589732; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return a list of books uploaded by the current user.
  ## 
  let valid = call_589748.validator(path, query, header, formData, body)
  let scheme = call_589748.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589748.url(scheme.get, call_589748.host, call_589748.base,
                         call_589748.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589748, url, valid)

proc call*(call_589749: Call_BooksVolumesUseruploadedList_589732;
          locale: string = ""; fields: string = ""; quotaUser: string = "";
          processingState: JsonNode = nil; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          source: string = ""; key: string = ""; volumeId: JsonNode = nil;
          prettyPrint: bool = true; startIndex: int = 0): Recallable =
  ## booksVolumesUseruploadedList
  ## Return a list of books uploaded by the current user.
  ##   locale: string
  ##         : ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'. Used for generating recommendations.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   processingState: JArray
  ##                  : The processing state of the user uploaded volumes to be returned.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of results to return.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   volumeId: JArray
  ##           : The ids of the volumes to be returned. If not specified all that match the processingState are returned.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: int
  ##             : Index of the first result to return (starts at 0)
  var query_589750 = newJObject()
  add(query_589750, "locale", newJString(locale))
  add(query_589750, "fields", newJString(fields))
  add(query_589750, "quotaUser", newJString(quotaUser))
  if processingState != nil:
    query_589750.add "processingState", processingState
  add(query_589750, "alt", newJString(alt))
  add(query_589750, "oauth_token", newJString(oauthToken))
  add(query_589750, "userIp", newJString(userIp))
  add(query_589750, "maxResults", newJInt(maxResults))
  add(query_589750, "source", newJString(source))
  add(query_589750, "key", newJString(key))
  if volumeId != nil:
    query_589750.add "volumeId", volumeId
  add(query_589750, "prettyPrint", newJBool(prettyPrint))
  add(query_589750, "startIndex", newJInt(startIndex))
  result = call_589749.call(nil, query_589750, nil, nil, nil)

var booksVolumesUseruploadedList* = Call_BooksVolumesUseruploadedList_589732(
    name: "booksVolumesUseruploadedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/volumes/useruploaded",
    validator: validate_BooksVolumesUseruploadedList_589733, base: "/books/v1",
    url: url_BooksVolumesUseruploadedList_589734, schemes: {Scheme.Https})
type
  Call_BooksVolumesGet_589751 = ref object of OpenApiRestCall_588466
proc url_BooksVolumesGet_589753(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "volumeId" in path, "`volumeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/volumes/"),
               (kind: VariableSegment, value: "volumeId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BooksVolumesGet_589752(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets volume information for a single volume.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   volumeId: JString (required)
  ##           : ID of volume to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `volumeId` field"
  var valid_589754 = path.getOrDefault("volumeId")
  valid_589754 = validateParameter(valid_589754, JString, required = true,
                                 default = nil)
  if valid_589754 != nil:
    section.add "volumeId", valid_589754
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   country: JString
  ##          : ISO-3166-1 code to override the IP-based location.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   includeNonComicsSeries: JBool
  ##                         : Set to true to include non-comics series. Defaults to false.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Restrict information returned to a set of selected fields.
  ##   partner: JString
  ##          : Brand results for partner ID.
  ##   user_library_consistent_read: JBool
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589755 = query.getOrDefault("fields")
  valid_589755 = validateParameter(valid_589755, JString, required = false,
                                 default = nil)
  if valid_589755 != nil:
    section.add "fields", valid_589755
  var valid_589756 = query.getOrDefault("country")
  valid_589756 = validateParameter(valid_589756, JString, required = false,
                                 default = nil)
  if valid_589756 != nil:
    section.add "country", valid_589756
  var valid_589757 = query.getOrDefault("quotaUser")
  valid_589757 = validateParameter(valid_589757, JString, required = false,
                                 default = nil)
  if valid_589757 != nil:
    section.add "quotaUser", valid_589757
  var valid_589758 = query.getOrDefault("alt")
  valid_589758 = validateParameter(valid_589758, JString, required = false,
                                 default = newJString("json"))
  if valid_589758 != nil:
    section.add "alt", valid_589758
  var valid_589759 = query.getOrDefault("oauth_token")
  valid_589759 = validateParameter(valid_589759, JString, required = false,
                                 default = nil)
  if valid_589759 != nil:
    section.add "oauth_token", valid_589759
  var valid_589760 = query.getOrDefault("includeNonComicsSeries")
  valid_589760 = validateParameter(valid_589760, JBool, required = false, default = nil)
  if valid_589760 != nil:
    section.add "includeNonComicsSeries", valid_589760
  var valid_589761 = query.getOrDefault("userIp")
  valid_589761 = validateParameter(valid_589761, JString, required = false,
                                 default = nil)
  if valid_589761 != nil:
    section.add "userIp", valid_589761
  var valid_589762 = query.getOrDefault("source")
  valid_589762 = validateParameter(valid_589762, JString, required = false,
                                 default = nil)
  if valid_589762 != nil:
    section.add "source", valid_589762
  var valid_589763 = query.getOrDefault("key")
  valid_589763 = validateParameter(valid_589763, JString, required = false,
                                 default = nil)
  if valid_589763 != nil:
    section.add "key", valid_589763
  var valid_589764 = query.getOrDefault("projection")
  valid_589764 = validateParameter(valid_589764, JString, required = false,
                                 default = newJString("full"))
  if valid_589764 != nil:
    section.add "projection", valid_589764
  var valid_589765 = query.getOrDefault("partner")
  valid_589765 = validateParameter(valid_589765, JString, required = false,
                                 default = nil)
  if valid_589765 != nil:
    section.add "partner", valid_589765
  var valid_589766 = query.getOrDefault("user_library_consistent_read")
  valid_589766 = validateParameter(valid_589766, JBool, required = false, default = nil)
  if valid_589766 != nil:
    section.add "user_library_consistent_read", valid_589766
  var valid_589767 = query.getOrDefault("prettyPrint")
  valid_589767 = validateParameter(valid_589767, JBool, required = false,
                                 default = newJBool(true))
  if valid_589767 != nil:
    section.add "prettyPrint", valid_589767
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589768: Call_BooksVolumesGet_589751; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets volume information for a single volume.
  ## 
  let valid = call_589768.validator(path, query, header, formData, body)
  let scheme = call_589768.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589768.url(scheme.get, call_589768.host, call_589768.base,
                         call_589768.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589768, url, valid)

proc call*(call_589769: Call_BooksVolumesGet_589751; volumeId: string;
          fields: string = ""; country: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = "";
          includeNonComicsSeries: bool = false; userIp: string = "";
          source: string = ""; key: string = ""; projection: string = "full";
          partner: string = ""; userLibraryConsistentRead: bool = false;
          prettyPrint: bool = true): Recallable =
  ## booksVolumesGet
  ## Gets volume information for a single volume.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   country: string
  ##          : ISO-3166-1 code to override the IP-based location.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   includeNonComicsSeries: bool
  ##                         : Set to true to include non-comics series. Defaults to false.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   volumeId: string (required)
  ##           : ID of volume to retrieve.
  ##   projection: string
  ##             : Restrict information returned to a set of selected fields.
  ##   partner: string
  ##          : Brand results for partner ID.
  ##   userLibraryConsistentRead: bool
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589770 = newJObject()
  var query_589771 = newJObject()
  add(query_589771, "fields", newJString(fields))
  add(query_589771, "country", newJString(country))
  add(query_589771, "quotaUser", newJString(quotaUser))
  add(query_589771, "alt", newJString(alt))
  add(query_589771, "oauth_token", newJString(oauthToken))
  add(query_589771, "includeNonComicsSeries", newJBool(includeNonComicsSeries))
  add(query_589771, "userIp", newJString(userIp))
  add(query_589771, "source", newJString(source))
  add(query_589771, "key", newJString(key))
  add(path_589770, "volumeId", newJString(volumeId))
  add(query_589771, "projection", newJString(projection))
  add(query_589771, "partner", newJString(partner))
  add(query_589771, "user_library_consistent_read",
      newJBool(userLibraryConsistentRead))
  add(query_589771, "prettyPrint", newJBool(prettyPrint))
  result = call_589769.call(path_589770, query_589771, nil, nil, nil)

var booksVolumesGet* = Call_BooksVolumesGet_589751(name: "booksVolumesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/volumes/{volumeId}", validator: validate_BooksVolumesGet_589752,
    base: "/books/v1", url: url_BooksVolumesGet_589753, schemes: {Scheme.Https})
type
  Call_BooksVolumesAssociatedList_589772 = ref object of OpenApiRestCall_588466
proc url_BooksVolumesAssociatedList_589774(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "volumeId" in path, "`volumeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/volumes/"),
               (kind: VariableSegment, value: "volumeId"),
               (kind: ConstantSegment, value: "/associated")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BooksVolumesAssociatedList_589773(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Return a list of associated books.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   volumeId: JString (required)
  ##           : ID of the source volume.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `volumeId` field"
  var valid_589775 = path.getOrDefault("volumeId")
  valid_589775 = validateParameter(valid_589775, JString, required = true,
                                 default = nil)
  if valid_589775 != nil:
    section.add "volumeId", valid_589775
  result.add "path", section
  ## parameters in `query` object:
  ##   association: JString
  ##              : Association type.
  ##   locale: JString
  ##         : ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'. Used for generating recommendations.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   maxAllowedMaturityRating: JString
  ##                           : The maximum allowed maturity rating of returned recommendations. Books with a higher maturity rating are filtered out.
  section = newJObject()
  var valid_589776 = query.getOrDefault("association")
  valid_589776 = validateParameter(valid_589776, JString, required = false,
                                 default = newJString("end-of-sample"))
  if valid_589776 != nil:
    section.add "association", valid_589776
  var valid_589777 = query.getOrDefault("locale")
  valid_589777 = validateParameter(valid_589777, JString, required = false,
                                 default = nil)
  if valid_589777 != nil:
    section.add "locale", valid_589777
  var valid_589778 = query.getOrDefault("fields")
  valid_589778 = validateParameter(valid_589778, JString, required = false,
                                 default = nil)
  if valid_589778 != nil:
    section.add "fields", valid_589778
  var valid_589779 = query.getOrDefault("quotaUser")
  valid_589779 = validateParameter(valid_589779, JString, required = false,
                                 default = nil)
  if valid_589779 != nil:
    section.add "quotaUser", valid_589779
  var valid_589780 = query.getOrDefault("alt")
  valid_589780 = validateParameter(valid_589780, JString, required = false,
                                 default = newJString("json"))
  if valid_589780 != nil:
    section.add "alt", valid_589780
  var valid_589781 = query.getOrDefault("oauth_token")
  valid_589781 = validateParameter(valid_589781, JString, required = false,
                                 default = nil)
  if valid_589781 != nil:
    section.add "oauth_token", valid_589781
  var valid_589782 = query.getOrDefault("userIp")
  valid_589782 = validateParameter(valid_589782, JString, required = false,
                                 default = nil)
  if valid_589782 != nil:
    section.add "userIp", valid_589782
  var valid_589783 = query.getOrDefault("source")
  valid_589783 = validateParameter(valid_589783, JString, required = false,
                                 default = nil)
  if valid_589783 != nil:
    section.add "source", valid_589783
  var valid_589784 = query.getOrDefault("key")
  valid_589784 = validateParameter(valid_589784, JString, required = false,
                                 default = nil)
  if valid_589784 != nil:
    section.add "key", valid_589784
  var valid_589785 = query.getOrDefault("prettyPrint")
  valid_589785 = validateParameter(valid_589785, JBool, required = false,
                                 default = newJBool(true))
  if valid_589785 != nil:
    section.add "prettyPrint", valid_589785
  var valid_589786 = query.getOrDefault("maxAllowedMaturityRating")
  valid_589786 = validateParameter(valid_589786, JString, required = false,
                                 default = newJString("mature"))
  if valid_589786 != nil:
    section.add "maxAllowedMaturityRating", valid_589786
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589787: Call_BooksVolumesAssociatedList_589772; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return a list of associated books.
  ## 
  let valid = call_589787.validator(path, query, header, formData, body)
  let scheme = call_589787.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589787.url(scheme.get, call_589787.host, call_589787.base,
                         call_589787.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589787, url, valid)

proc call*(call_589788: Call_BooksVolumesAssociatedList_589772; volumeId: string;
          association: string = "end-of-sample"; locale: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; source: string = "";
          key: string = ""; prettyPrint: bool = true;
          maxAllowedMaturityRating: string = "mature"): Recallable =
  ## booksVolumesAssociatedList
  ## Return a list of associated books.
  ##   association: string
  ##              : Association type.
  ##   locale: string
  ##         : ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'. Used for generating recommendations.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   volumeId: string (required)
  ##           : ID of the source volume.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   maxAllowedMaturityRating: string
  ##                           : The maximum allowed maturity rating of returned recommendations. Books with a higher maturity rating are filtered out.
  var path_589789 = newJObject()
  var query_589790 = newJObject()
  add(query_589790, "association", newJString(association))
  add(query_589790, "locale", newJString(locale))
  add(query_589790, "fields", newJString(fields))
  add(query_589790, "quotaUser", newJString(quotaUser))
  add(query_589790, "alt", newJString(alt))
  add(query_589790, "oauth_token", newJString(oauthToken))
  add(query_589790, "userIp", newJString(userIp))
  add(query_589790, "source", newJString(source))
  add(query_589790, "key", newJString(key))
  add(path_589789, "volumeId", newJString(volumeId))
  add(query_589790, "prettyPrint", newJBool(prettyPrint))
  add(query_589790, "maxAllowedMaturityRating",
      newJString(maxAllowedMaturityRating))
  result = call_589788.call(path_589789, query_589790, nil, nil, nil)

var booksVolumesAssociatedList* = Call_BooksVolumesAssociatedList_589772(
    name: "booksVolumesAssociatedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/volumes/{volumeId}/associated",
    validator: validate_BooksVolumesAssociatedList_589773, base: "/books/v1",
    url: url_BooksVolumesAssociatedList_589774, schemes: {Scheme.Https})
type
  Call_BooksLayersVolumeAnnotationsList_589791 = ref object of OpenApiRestCall_588466
proc url_BooksLayersVolumeAnnotationsList_589793(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "volumeId" in path, "`volumeId` is a required path parameter"
  assert "layerId" in path, "`layerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/volumes/"),
               (kind: VariableSegment, value: "volumeId"),
               (kind: ConstantSegment, value: "/layers/"),
               (kind: VariableSegment, value: "layerId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BooksLayersVolumeAnnotationsList_589792(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the volume annotations for a volume and layer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   volumeId: JString (required)
  ##           : The volume to retrieve annotations for.
  ##   layerId: JString (required)
  ##          : The ID for the layer to get the annotations.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `volumeId` field"
  var valid_589794 = path.getOrDefault("volumeId")
  valid_589794 = validateParameter(valid_589794, JString, required = true,
                                 default = nil)
  if valid_589794 != nil:
    section.add "volumeId", valid_589794
  var valid_589795 = path.getOrDefault("layerId")
  valid_589795 = validateParameter(valid_589795, JString, required = true,
                                 default = nil)
  if valid_589795 != nil:
    section.add "layerId", valid_589795
  result.add "path", section
  ## parameters in `query` object:
  ##   locale: JString
  ##         : The locale information for the data. ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The value of the nextToken from the previous page.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   updatedMax: JString
  ##             : RFC 3339 timestamp to restrict to items updated prior to this timestamp (exclusive).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of results to return
  ##   contentVersion: JString (required)
  ##                 : The content version for the requested volume.
  ##   showDeleted: JBool
  ##              : Set to true to return deleted annotations. updatedMin must be in the request to use this. Defaults to false.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   updatedMin: JString
  ##             : RFC 3339 timestamp to restrict to items updated since this timestamp (inclusive).
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   endOffset: JString
  ##            : The end offset to end retrieving data from.
  ##   startOffset: JString
  ##              : The start offset to start retrieving data from.
  ##   startPosition: JString
  ##                : The start position to start retrieving data from.
  ##   volumeAnnotationsVersion: JString
  ##                           : The version of the volume annotations that you are requesting.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   endPosition: JString
  ##              : The end position to end retrieving data from.
  section = newJObject()
  var valid_589796 = query.getOrDefault("locale")
  valid_589796 = validateParameter(valid_589796, JString, required = false,
                                 default = nil)
  if valid_589796 != nil:
    section.add "locale", valid_589796
  var valid_589797 = query.getOrDefault("fields")
  valid_589797 = validateParameter(valid_589797, JString, required = false,
                                 default = nil)
  if valid_589797 != nil:
    section.add "fields", valid_589797
  var valid_589798 = query.getOrDefault("pageToken")
  valid_589798 = validateParameter(valid_589798, JString, required = false,
                                 default = nil)
  if valid_589798 != nil:
    section.add "pageToken", valid_589798
  var valid_589799 = query.getOrDefault("quotaUser")
  valid_589799 = validateParameter(valid_589799, JString, required = false,
                                 default = nil)
  if valid_589799 != nil:
    section.add "quotaUser", valid_589799
  var valid_589800 = query.getOrDefault("alt")
  valid_589800 = validateParameter(valid_589800, JString, required = false,
                                 default = newJString("json"))
  if valid_589800 != nil:
    section.add "alt", valid_589800
  var valid_589801 = query.getOrDefault("updatedMax")
  valid_589801 = validateParameter(valid_589801, JString, required = false,
                                 default = nil)
  if valid_589801 != nil:
    section.add "updatedMax", valid_589801
  var valid_589802 = query.getOrDefault("oauth_token")
  valid_589802 = validateParameter(valid_589802, JString, required = false,
                                 default = nil)
  if valid_589802 != nil:
    section.add "oauth_token", valid_589802
  var valid_589803 = query.getOrDefault("userIp")
  valid_589803 = validateParameter(valid_589803, JString, required = false,
                                 default = nil)
  if valid_589803 != nil:
    section.add "userIp", valid_589803
  var valid_589804 = query.getOrDefault("maxResults")
  valid_589804 = validateParameter(valid_589804, JInt, required = false, default = nil)
  if valid_589804 != nil:
    section.add "maxResults", valid_589804
  assert query != nil,
        "query argument is necessary due to required `contentVersion` field"
  var valid_589805 = query.getOrDefault("contentVersion")
  valid_589805 = validateParameter(valid_589805, JString, required = true,
                                 default = nil)
  if valid_589805 != nil:
    section.add "contentVersion", valid_589805
  var valid_589806 = query.getOrDefault("showDeleted")
  valid_589806 = validateParameter(valid_589806, JBool, required = false, default = nil)
  if valid_589806 != nil:
    section.add "showDeleted", valid_589806
  var valid_589807 = query.getOrDefault("source")
  valid_589807 = validateParameter(valid_589807, JString, required = false,
                                 default = nil)
  if valid_589807 != nil:
    section.add "source", valid_589807
  var valid_589808 = query.getOrDefault("updatedMin")
  valid_589808 = validateParameter(valid_589808, JString, required = false,
                                 default = nil)
  if valid_589808 != nil:
    section.add "updatedMin", valid_589808
  var valid_589809 = query.getOrDefault("key")
  valid_589809 = validateParameter(valid_589809, JString, required = false,
                                 default = nil)
  if valid_589809 != nil:
    section.add "key", valid_589809
  var valid_589810 = query.getOrDefault("endOffset")
  valid_589810 = validateParameter(valid_589810, JString, required = false,
                                 default = nil)
  if valid_589810 != nil:
    section.add "endOffset", valid_589810
  var valid_589811 = query.getOrDefault("startOffset")
  valid_589811 = validateParameter(valid_589811, JString, required = false,
                                 default = nil)
  if valid_589811 != nil:
    section.add "startOffset", valid_589811
  var valid_589812 = query.getOrDefault("startPosition")
  valid_589812 = validateParameter(valid_589812, JString, required = false,
                                 default = nil)
  if valid_589812 != nil:
    section.add "startPosition", valid_589812
  var valid_589813 = query.getOrDefault("volumeAnnotationsVersion")
  valid_589813 = validateParameter(valid_589813, JString, required = false,
                                 default = nil)
  if valid_589813 != nil:
    section.add "volumeAnnotationsVersion", valid_589813
  var valid_589814 = query.getOrDefault("prettyPrint")
  valid_589814 = validateParameter(valid_589814, JBool, required = false,
                                 default = newJBool(true))
  if valid_589814 != nil:
    section.add "prettyPrint", valid_589814
  var valid_589815 = query.getOrDefault("endPosition")
  valid_589815 = validateParameter(valid_589815, JString, required = false,
                                 default = nil)
  if valid_589815 != nil:
    section.add "endPosition", valid_589815
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589816: Call_BooksLayersVolumeAnnotationsList_589791;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the volume annotations for a volume and layer.
  ## 
  let valid = call_589816.validator(path, query, header, formData, body)
  let scheme = call_589816.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589816.url(scheme.get, call_589816.host, call_589816.base,
                         call_589816.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589816, url, valid)

proc call*(call_589817: Call_BooksLayersVolumeAnnotationsList_589791;
          contentVersion: string; volumeId: string; layerId: string;
          locale: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; updatedMax: string = "";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          showDeleted: bool = false; source: string = ""; updatedMin: string = "";
          key: string = ""; endOffset: string = ""; startOffset: string = "";
          startPosition: string = ""; volumeAnnotationsVersion: string = "";
          prettyPrint: bool = true; endPosition: string = ""): Recallable =
  ## booksLayersVolumeAnnotationsList
  ## Gets the volume annotations for a volume and layer.
  ##   locale: string
  ##         : The locale information for the data. ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The value of the nextToken from the previous page.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   updatedMax: string
  ##             : RFC 3339 timestamp to restrict to items updated prior to this timestamp (exclusive).
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of results to return
  ##   contentVersion: string (required)
  ##                 : The content version for the requested volume.
  ##   showDeleted: bool
  ##              : Set to true to return deleted annotations. updatedMin must be in the request to use this. Defaults to false.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   updatedMin: string
  ##             : RFC 3339 timestamp to restrict to items updated since this timestamp (inclusive).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   volumeId: string (required)
  ##           : The volume to retrieve annotations for.
  ##   endOffset: string
  ##            : The end offset to end retrieving data from.
  ##   startOffset: string
  ##              : The start offset to start retrieving data from.
  ##   startPosition: string
  ##                : The start position to start retrieving data from.
  ##   volumeAnnotationsVersion: string
  ##                           : The version of the volume annotations that you are requesting.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   endPosition: string
  ##              : The end position to end retrieving data from.
  ##   layerId: string (required)
  ##          : The ID for the layer to get the annotations.
  var path_589818 = newJObject()
  var query_589819 = newJObject()
  add(query_589819, "locale", newJString(locale))
  add(query_589819, "fields", newJString(fields))
  add(query_589819, "pageToken", newJString(pageToken))
  add(query_589819, "quotaUser", newJString(quotaUser))
  add(query_589819, "alt", newJString(alt))
  add(query_589819, "updatedMax", newJString(updatedMax))
  add(query_589819, "oauth_token", newJString(oauthToken))
  add(query_589819, "userIp", newJString(userIp))
  add(query_589819, "maxResults", newJInt(maxResults))
  add(query_589819, "contentVersion", newJString(contentVersion))
  add(query_589819, "showDeleted", newJBool(showDeleted))
  add(query_589819, "source", newJString(source))
  add(query_589819, "updatedMin", newJString(updatedMin))
  add(query_589819, "key", newJString(key))
  add(path_589818, "volumeId", newJString(volumeId))
  add(query_589819, "endOffset", newJString(endOffset))
  add(query_589819, "startOffset", newJString(startOffset))
  add(query_589819, "startPosition", newJString(startPosition))
  add(query_589819, "volumeAnnotationsVersion",
      newJString(volumeAnnotationsVersion))
  add(query_589819, "prettyPrint", newJBool(prettyPrint))
  add(query_589819, "endPosition", newJString(endPosition))
  add(path_589818, "layerId", newJString(layerId))
  result = call_589817.call(path_589818, query_589819, nil, nil, nil)

var booksLayersVolumeAnnotationsList* = Call_BooksLayersVolumeAnnotationsList_589791(
    name: "booksLayersVolumeAnnotationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/volumes/{volumeId}/layers/{layerId}",
    validator: validate_BooksLayersVolumeAnnotationsList_589792,
    base: "/books/v1", url: url_BooksLayersVolumeAnnotationsList_589793,
    schemes: {Scheme.Https})
type
  Call_BooksLayersVolumeAnnotationsGet_589820 = ref object of OpenApiRestCall_588466
proc url_BooksLayersVolumeAnnotationsGet_589822(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "volumeId" in path, "`volumeId` is a required path parameter"
  assert "layerId" in path, "`layerId` is a required path parameter"
  assert "annotationId" in path, "`annotationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/volumes/"),
               (kind: VariableSegment, value: "volumeId"),
               (kind: ConstantSegment, value: "/layers/"),
               (kind: VariableSegment, value: "layerId"),
               (kind: ConstantSegment, value: "/annotations/"),
               (kind: VariableSegment, value: "annotationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BooksLayersVolumeAnnotationsGet_589821(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the volume annotation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   annotationId: JString (required)
  ##               : The ID of the volume annotation to retrieve.
  ##   volumeId: JString (required)
  ##           : The volume to retrieve annotations for.
  ##   layerId: JString (required)
  ##          : The ID for the layer to get the annotations.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `annotationId` field"
  var valid_589823 = path.getOrDefault("annotationId")
  valid_589823 = validateParameter(valid_589823, JString, required = true,
                                 default = nil)
  if valid_589823 != nil:
    section.add "annotationId", valid_589823
  var valid_589824 = path.getOrDefault("volumeId")
  valid_589824 = validateParameter(valid_589824, JString, required = true,
                                 default = nil)
  if valid_589824 != nil:
    section.add "volumeId", valid_589824
  var valid_589825 = path.getOrDefault("layerId")
  valid_589825 = validateParameter(valid_589825, JString, required = true,
                                 default = nil)
  if valid_589825 != nil:
    section.add "layerId", valid_589825
  result.add "path", section
  ## parameters in `query` object:
  ##   locale: JString
  ##         : The locale information for the data. ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589826 = query.getOrDefault("locale")
  valid_589826 = validateParameter(valid_589826, JString, required = false,
                                 default = nil)
  if valid_589826 != nil:
    section.add "locale", valid_589826
  var valid_589827 = query.getOrDefault("fields")
  valid_589827 = validateParameter(valid_589827, JString, required = false,
                                 default = nil)
  if valid_589827 != nil:
    section.add "fields", valid_589827
  var valid_589828 = query.getOrDefault("quotaUser")
  valid_589828 = validateParameter(valid_589828, JString, required = false,
                                 default = nil)
  if valid_589828 != nil:
    section.add "quotaUser", valid_589828
  var valid_589829 = query.getOrDefault("alt")
  valid_589829 = validateParameter(valid_589829, JString, required = false,
                                 default = newJString("json"))
  if valid_589829 != nil:
    section.add "alt", valid_589829
  var valid_589830 = query.getOrDefault("oauth_token")
  valid_589830 = validateParameter(valid_589830, JString, required = false,
                                 default = nil)
  if valid_589830 != nil:
    section.add "oauth_token", valid_589830
  var valid_589831 = query.getOrDefault("userIp")
  valid_589831 = validateParameter(valid_589831, JString, required = false,
                                 default = nil)
  if valid_589831 != nil:
    section.add "userIp", valid_589831
  var valid_589832 = query.getOrDefault("source")
  valid_589832 = validateParameter(valid_589832, JString, required = false,
                                 default = nil)
  if valid_589832 != nil:
    section.add "source", valid_589832
  var valid_589833 = query.getOrDefault("key")
  valid_589833 = validateParameter(valid_589833, JString, required = false,
                                 default = nil)
  if valid_589833 != nil:
    section.add "key", valid_589833
  var valid_589834 = query.getOrDefault("prettyPrint")
  valid_589834 = validateParameter(valid_589834, JBool, required = false,
                                 default = newJBool(true))
  if valid_589834 != nil:
    section.add "prettyPrint", valid_589834
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589835: Call_BooksLayersVolumeAnnotationsGet_589820;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the volume annotation.
  ## 
  let valid = call_589835.validator(path, query, header, formData, body)
  let scheme = call_589835.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589835.url(scheme.get, call_589835.host, call_589835.base,
                         call_589835.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589835, url, valid)

proc call*(call_589836: Call_BooksLayersVolumeAnnotationsGet_589820;
          annotationId: string; volumeId: string; layerId: string;
          locale: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          source: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## booksLayersVolumeAnnotationsGet
  ## Gets the volume annotation.
  ##   locale: string
  ##         : The locale information for the data. ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   annotationId: string (required)
  ##               : The ID of the volume annotation to retrieve.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   volumeId: string (required)
  ##           : The volume to retrieve annotations for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   layerId: string (required)
  ##          : The ID for the layer to get the annotations.
  var path_589837 = newJObject()
  var query_589838 = newJObject()
  add(query_589838, "locale", newJString(locale))
  add(query_589838, "fields", newJString(fields))
  add(query_589838, "quotaUser", newJString(quotaUser))
  add(query_589838, "alt", newJString(alt))
  add(query_589838, "oauth_token", newJString(oauthToken))
  add(path_589837, "annotationId", newJString(annotationId))
  add(query_589838, "userIp", newJString(userIp))
  add(query_589838, "source", newJString(source))
  add(query_589838, "key", newJString(key))
  add(path_589837, "volumeId", newJString(volumeId))
  add(query_589838, "prettyPrint", newJBool(prettyPrint))
  add(path_589837, "layerId", newJString(layerId))
  result = call_589836.call(path_589837, query_589838, nil, nil, nil)

var booksLayersVolumeAnnotationsGet* = Call_BooksLayersVolumeAnnotationsGet_589820(
    name: "booksLayersVolumeAnnotationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/volumes/{volumeId}/layers/{layerId}/annotations/{annotationId}",
    validator: validate_BooksLayersVolumeAnnotationsGet_589821, base: "/books/v1",
    url: url_BooksLayersVolumeAnnotationsGet_589822, schemes: {Scheme.Https})
type
  Call_BooksLayersAnnotationDataList_589839 = ref object of OpenApiRestCall_588466
proc url_BooksLayersAnnotationDataList_589841(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "volumeId" in path, "`volumeId` is a required path parameter"
  assert "layerId" in path, "`layerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/volumes/"),
               (kind: VariableSegment, value: "volumeId"),
               (kind: ConstantSegment, value: "/layers/"),
               (kind: VariableSegment, value: "layerId"),
               (kind: ConstantSegment, value: "/data")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BooksLayersAnnotationDataList_589840(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the annotation data for a volume and layer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   volumeId: JString (required)
  ##           : The volume to retrieve annotation data for.
  ##   layerId: JString (required)
  ##          : The ID for the layer to get the annotation data.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `volumeId` field"
  var valid_589842 = path.getOrDefault("volumeId")
  valid_589842 = validateParameter(valid_589842, JString, required = true,
                                 default = nil)
  if valid_589842 != nil:
    section.add "volumeId", valid_589842
  var valid_589843 = path.getOrDefault("layerId")
  valid_589843 = validateParameter(valid_589843, JString, required = true,
                                 default = nil)
  if valid_589843 != nil:
    section.add "layerId", valid_589843
  result.add "path", section
  ## parameters in `query` object:
  ##   locale: JString
  ##         : The locale information for the data. ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The value of the nextToken from the previous page.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   updatedMax: JString
  ##             : RFC 3339 timestamp to restrict to items updated prior to this timestamp (exclusive).
  ##   scale: JInt
  ##        : The requested scale for the image.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of results to return
  ##   contentVersion: JString (required)
  ##                 : The content version for the requested volume.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   updatedMin: JString
  ##             : RFC 3339 timestamp to restrict to items updated since this timestamp (inclusive).
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   w: JInt
  ##    : The requested pixel width for any images. If width is provided height must also be provided.
  ##   annotationDataId: JArray
  ##                   : The list of Annotation Data Ids to retrieve. Pagination is ignored if this is set.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   h: JInt
  ##    : The requested pixel height for any images. If height is provided width must also be provided.
  section = newJObject()
  var valid_589844 = query.getOrDefault("locale")
  valid_589844 = validateParameter(valid_589844, JString, required = false,
                                 default = nil)
  if valid_589844 != nil:
    section.add "locale", valid_589844
  var valid_589845 = query.getOrDefault("fields")
  valid_589845 = validateParameter(valid_589845, JString, required = false,
                                 default = nil)
  if valid_589845 != nil:
    section.add "fields", valid_589845
  var valid_589846 = query.getOrDefault("pageToken")
  valid_589846 = validateParameter(valid_589846, JString, required = false,
                                 default = nil)
  if valid_589846 != nil:
    section.add "pageToken", valid_589846
  var valid_589847 = query.getOrDefault("quotaUser")
  valid_589847 = validateParameter(valid_589847, JString, required = false,
                                 default = nil)
  if valid_589847 != nil:
    section.add "quotaUser", valid_589847
  var valid_589848 = query.getOrDefault("alt")
  valid_589848 = validateParameter(valid_589848, JString, required = false,
                                 default = newJString("json"))
  if valid_589848 != nil:
    section.add "alt", valid_589848
  var valid_589849 = query.getOrDefault("updatedMax")
  valid_589849 = validateParameter(valid_589849, JString, required = false,
                                 default = nil)
  if valid_589849 != nil:
    section.add "updatedMax", valid_589849
  var valid_589850 = query.getOrDefault("scale")
  valid_589850 = validateParameter(valid_589850, JInt, required = false, default = nil)
  if valid_589850 != nil:
    section.add "scale", valid_589850
  var valid_589851 = query.getOrDefault("oauth_token")
  valid_589851 = validateParameter(valid_589851, JString, required = false,
                                 default = nil)
  if valid_589851 != nil:
    section.add "oauth_token", valid_589851
  var valid_589852 = query.getOrDefault("userIp")
  valid_589852 = validateParameter(valid_589852, JString, required = false,
                                 default = nil)
  if valid_589852 != nil:
    section.add "userIp", valid_589852
  var valid_589853 = query.getOrDefault("maxResults")
  valid_589853 = validateParameter(valid_589853, JInt, required = false, default = nil)
  if valid_589853 != nil:
    section.add "maxResults", valid_589853
  assert query != nil,
        "query argument is necessary due to required `contentVersion` field"
  var valid_589854 = query.getOrDefault("contentVersion")
  valid_589854 = validateParameter(valid_589854, JString, required = true,
                                 default = nil)
  if valid_589854 != nil:
    section.add "contentVersion", valid_589854
  var valid_589855 = query.getOrDefault("source")
  valid_589855 = validateParameter(valid_589855, JString, required = false,
                                 default = nil)
  if valid_589855 != nil:
    section.add "source", valid_589855
  var valid_589856 = query.getOrDefault("updatedMin")
  valid_589856 = validateParameter(valid_589856, JString, required = false,
                                 default = nil)
  if valid_589856 != nil:
    section.add "updatedMin", valid_589856
  var valid_589857 = query.getOrDefault("key")
  valid_589857 = validateParameter(valid_589857, JString, required = false,
                                 default = nil)
  if valid_589857 != nil:
    section.add "key", valid_589857
  var valid_589858 = query.getOrDefault("w")
  valid_589858 = validateParameter(valid_589858, JInt, required = false, default = nil)
  if valid_589858 != nil:
    section.add "w", valid_589858
  var valid_589859 = query.getOrDefault("annotationDataId")
  valid_589859 = validateParameter(valid_589859, JArray, required = false,
                                 default = nil)
  if valid_589859 != nil:
    section.add "annotationDataId", valid_589859
  var valid_589860 = query.getOrDefault("prettyPrint")
  valid_589860 = validateParameter(valid_589860, JBool, required = false,
                                 default = newJBool(true))
  if valid_589860 != nil:
    section.add "prettyPrint", valid_589860
  var valid_589861 = query.getOrDefault("h")
  valid_589861 = validateParameter(valid_589861, JInt, required = false, default = nil)
  if valid_589861 != nil:
    section.add "h", valid_589861
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589862: Call_BooksLayersAnnotationDataList_589839; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the annotation data for a volume and layer.
  ## 
  let valid = call_589862.validator(path, query, header, formData, body)
  let scheme = call_589862.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589862.url(scheme.get, call_589862.host, call_589862.base,
                         call_589862.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589862, url, valid)

proc call*(call_589863: Call_BooksLayersAnnotationDataList_589839;
          contentVersion: string; volumeId: string; layerId: string;
          locale: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; updatedMax: string = "";
          scale: int = 0; oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          source: string = ""; updatedMin: string = ""; key: string = ""; w: int = 0;
          annotationDataId: JsonNode = nil; prettyPrint: bool = true; h: int = 0): Recallable =
  ## booksLayersAnnotationDataList
  ## Gets the annotation data for a volume and layer.
  ##   locale: string
  ##         : The locale information for the data. ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The value of the nextToken from the previous page.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   updatedMax: string
  ##             : RFC 3339 timestamp to restrict to items updated prior to this timestamp (exclusive).
  ##   scale: int
  ##        : The requested scale for the image.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of results to return
  ##   contentVersion: string (required)
  ##                 : The content version for the requested volume.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   updatedMin: string
  ##             : RFC 3339 timestamp to restrict to items updated since this timestamp (inclusive).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   volumeId: string (required)
  ##           : The volume to retrieve annotation data for.
  ##   w: int
  ##    : The requested pixel width for any images. If width is provided height must also be provided.
  ##   annotationDataId: JArray
  ##                   : The list of Annotation Data Ids to retrieve. Pagination is ignored if this is set.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   h: int
  ##    : The requested pixel height for any images. If height is provided width must also be provided.
  ##   layerId: string (required)
  ##          : The ID for the layer to get the annotation data.
  var path_589864 = newJObject()
  var query_589865 = newJObject()
  add(query_589865, "locale", newJString(locale))
  add(query_589865, "fields", newJString(fields))
  add(query_589865, "pageToken", newJString(pageToken))
  add(query_589865, "quotaUser", newJString(quotaUser))
  add(query_589865, "alt", newJString(alt))
  add(query_589865, "updatedMax", newJString(updatedMax))
  add(query_589865, "scale", newJInt(scale))
  add(query_589865, "oauth_token", newJString(oauthToken))
  add(query_589865, "userIp", newJString(userIp))
  add(query_589865, "maxResults", newJInt(maxResults))
  add(query_589865, "contentVersion", newJString(contentVersion))
  add(query_589865, "source", newJString(source))
  add(query_589865, "updatedMin", newJString(updatedMin))
  add(query_589865, "key", newJString(key))
  add(path_589864, "volumeId", newJString(volumeId))
  add(query_589865, "w", newJInt(w))
  if annotationDataId != nil:
    query_589865.add "annotationDataId", annotationDataId
  add(query_589865, "prettyPrint", newJBool(prettyPrint))
  add(query_589865, "h", newJInt(h))
  add(path_589864, "layerId", newJString(layerId))
  result = call_589863.call(path_589864, query_589865, nil, nil, nil)

var booksLayersAnnotationDataList* = Call_BooksLayersAnnotationDataList_589839(
    name: "booksLayersAnnotationDataList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/volumes/{volumeId}/layers/{layerId}/data",
    validator: validate_BooksLayersAnnotationDataList_589840, base: "/books/v1",
    url: url_BooksLayersAnnotationDataList_589841, schemes: {Scheme.Https})
type
  Call_BooksLayersAnnotationDataGet_589866 = ref object of OpenApiRestCall_588466
proc url_BooksLayersAnnotationDataGet_589868(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "volumeId" in path, "`volumeId` is a required path parameter"
  assert "layerId" in path, "`layerId` is a required path parameter"
  assert "annotationDataId" in path,
        "`annotationDataId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/volumes/"),
               (kind: VariableSegment, value: "volumeId"),
               (kind: ConstantSegment, value: "/layers/"),
               (kind: VariableSegment, value: "layerId"),
               (kind: ConstantSegment, value: "/data/"),
               (kind: VariableSegment, value: "annotationDataId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BooksLayersAnnotationDataGet_589867(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the annotation data.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   annotationDataId: JString (required)
  ##                   : The ID of the annotation data to retrieve.
  ##   volumeId: JString (required)
  ##           : The volume to retrieve annotations for.
  ##   layerId: JString (required)
  ##          : The ID for the layer to get the annotations.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `annotationDataId` field"
  var valid_589869 = path.getOrDefault("annotationDataId")
  valid_589869 = validateParameter(valid_589869, JString, required = true,
                                 default = nil)
  if valid_589869 != nil:
    section.add "annotationDataId", valid_589869
  var valid_589870 = path.getOrDefault("volumeId")
  valid_589870 = validateParameter(valid_589870, JString, required = true,
                                 default = nil)
  if valid_589870 != nil:
    section.add "volumeId", valid_589870
  var valid_589871 = path.getOrDefault("layerId")
  valid_589871 = validateParameter(valid_589871, JString, required = true,
                                 default = nil)
  if valid_589871 != nil:
    section.add "layerId", valid_589871
  result.add "path", section
  ## parameters in `query` object:
  ##   locale: JString
  ##         : The locale information for the data. ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   scale: JInt
  ##        : The requested scale for the image.
  ##   allowWebDefinitions: JBool
  ##                      : For the dictionary layer. Whether or not to allow web definitions.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   contentVersion: JString (required)
  ##                 : The content version for the volume you are trying to retrieve.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   w: JInt
  ##    : The requested pixel width for any images. If width is provided height must also be provided.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   h: JInt
  ##    : The requested pixel height for any images. If height is provided width must also be provided.
  section = newJObject()
  var valid_589872 = query.getOrDefault("locale")
  valid_589872 = validateParameter(valid_589872, JString, required = false,
                                 default = nil)
  if valid_589872 != nil:
    section.add "locale", valid_589872
  var valid_589873 = query.getOrDefault("fields")
  valid_589873 = validateParameter(valid_589873, JString, required = false,
                                 default = nil)
  if valid_589873 != nil:
    section.add "fields", valid_589873
  var valid_589874 = query.getOrDefault("quotaUser")
  valid_589874 = validateParameter(valid_589874, JString, required = false,
                                 default = nil)
  if valid_589874 != nil:
    section.add "quotaUser", valid_589874
  var valid_589875 = query.getOrDefault("alt")
  valid_589875 = validateParameter(valid_589875, JString, required = false,
                                 default = newJString("json"))
  if valid_589875 != nil:
    section.add "alt", valid_589875
  var valid_589876 = query.getOrDefault("scale")
  valid_589876 = validateParameter(valid_589876, JInt, required = false, default = nil)
  if valid_589876 != nil:
    section.add "scale", valid_589876
  var valid_589877 = query.getOrDefault("allowWebDefinitions")
  valid_589877 = validateParameter(valid_589877, JBool, required = false, default = nil)
  if valid_589877 != nil:
    section.add "allowWebDefinitions", valid_589877
  var valid_589878 = query.getOrDefault("oauth_token")
  valid_589878 = validateParameter(valid_589878, JString, required = false,
                                 default = nil)
  if valid_589878 != nil:
    section.add "oauth_token", valid_589878
  var valid_589879 = query.getOrDefault("userIp")
  valid_589879 = validateParameter(valid_589879, JString, required = false,
                                 default = nil)
  if valid_589879 != nil:
    section.add "userIp", valid_589879
  assert query != nil,
        "query argument is necessary due to required `contentVersion` field"
  var valid_589880 = query.getOrDefault("contentVersion")
  valid_589880 = validateParameter(valid_589880, JString, required = true,
                                 default = nil)
  if valid_589880 != nil:
    section.add "contentVersion", valid_589880
  var valid_589881 = query.getOrDefault("source")
  valid_589881 = validateParameter(valid_589881, JString, required = false,
                                 default = nil)
  if valid_589881 != nil:
    section.add "source", valid_589881
  var valid_589882 = query.getOrDefault("key")
  valid_589882 = validateParameter(valid_589882, JString, required = false,
                                 default = nil)
  if valid_589882 != nil:
    section.add "key", valid_589882
  var valid_589883 = query.getOrDefault("w")
  valid_589883 = validateParameter(valid_589883, JInt, required = false, default = nil)
  if valid_589883 != nil:
    section.add "w", valid_589883
  var valid_589884 = query.getOrDefault("prettyPrint")
  valid_589884 = validateParameter(valid_589884, JBool, required = false,
                                 default = newJBool(true))
  if valid_589884 != nil:
    section.add "prettyPrint", valid_589884
  var valid_589885 = query.getOrDefault("h")
  valid_589885 = validateParameter(valid_589885, JInt, required = false, default = nil)
  if valid_589885 != nil:
    section.add "h", valid_589885
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589886: Call_BooksLayersAnnotationDataGet_589866; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the annotation data.
  ## 
  let valid = call_589886.validator(path, query, header, formData, body)
  let scheme = call_589886.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589886.url(scheme.get, call_589886.host, call_589886.base,
                         call_589886.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589886, url, valid)

proc call*(call_589887: Call_BooksLayersAnnotationDataGet_589866;
          annotationDataId: string; contentVersion: string; volumeId: string;
          layerId: string; locale: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; scale: int = 0;
          allowWebDefinitions: bool = false; oauthToken: string = "";
          userIp: string = ""; source: string = ""; key: string = ""; w: int = 0;
          prettyPrint: bool = true; h: int = 0): Recallable =
  ## booksLayersAnnotationDataGet
  ## Gets the annotation data.
  ##   locale: string
  ##         : The locale information for the data. ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'.
  ##   annotationDataId: string (required)
  ##                   : The ID of the annotation data to retrieve.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   scale: int
  ##        : The requested scale for the image.
  ##   allowWebDefinitions: bool
  ##                      : For the dictionary layer. Whether or not to allow web definitions.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   contentVersion: string (required)
  ##                 : The content version for the volume you are trying to retrieve.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   volumeId: string (required)
  ##           : The volume to retrieve annotations for.
  ##   w: int
  ##    : The requested pixel width for any images. If width is provided height must also be provided.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   h: int
  ##    : The requested pixel height for any images. If height is provided width must also be provided.
  ##   layerId: string (required)
  ##          : The ID for the layer to get the annotations.
  var path_589888 = newJObject()
  var query_589889 = newJObject()
  add(query_589889, "locale", newJString(locale))
  add(path_589888, "annotationDataId", newJString(annotationDataId))
  add(query_589889, "fields", newJString(fields))
  add(query_589889, "quotaUser", newJString(quotaUser))
  add(query_589889, "alt", newJString(alt))
  add(query_589889, "scale", newJInt(scale))
  add(query_589889, "allowWebDefinitions", newJBool(allowWebDefinitions))
  add(query_589889, "oauth_token", newJString(oauthToken))
  add(query_589889, "userIp", newJString(userIp))
  add(query_589889, "contentVersion", newJString(contentVersion))
  add(query_589889, "source", newJString(source))
  add(query_589889, "key", newJString(key))
  add(path_589888, "volumeId", newJString(volumeId))
  add(query_589889, "w", newJInt(w))
  add(query_589889, "prettyPrint", newJBool(prettyPrint))
  add(query_589889, "h", newJInt(h))
  add(path_589888, "layerId", newJString(layerId))
  result = call_589887.call(path_589888, query_589889, nil, nil, nil)

var booksLayersAnnotationDataGet* = Call_BooksLayersAnnotationDataGet_589866(
    name: "booksLayersAnnotationDataGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/volumes/{volumeId}/layers/{layerId}/data/{annotationDataId}",
    validator: validate_BooksLayersAnnotationDataGet_589867, base: "/books/v1",
    url: url_BooksLayersAnnotationDataGet_589868, schemes: {Scheme.Https})
type
  Call_BooksLayersList_589890 = ref object of OpenApiRestCall_588466
proc url_BooksLayersList_589892(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "volumeId" in path, "`volumeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/volumes/"),
               (kind: VariableSegment, value: "volumeId"),
               (kind: ConstantSegment, value: "/layersummary")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BooksLayersList_589891(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## List the layer summaries for a volume.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   volumeId: JString (required)
  ##           : The volume to retrieve layers for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `volumeId` field"
  var valid_589893 = path.getOrDefault("volumeId")
  valid_589893 = validateParameter(valid_589893, JString, required = true,
                                 default = nil)
  if valid_589893 != nil:
    section.add "volumeId", valid_589893
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The value of the nextToken from the previous page.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of results to return
  ##   contentVersion: JString
  ##                 : The content version for the requested volume.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589894 = query.getOrDefault("fields")
  valid_589894 = validateParameter(valid_589894, JString, required = false,
                                 default = nil)
  if valid_589894 != nil:
    section.add "fields", valid_589894
  var valid_589895 = query.getOrDefault("pageToken")
  valid_589895 = validateParameter(valid_589895, JString, required = false,
                                 default = nil)
  if valid_589895 != nil:
    section.add "pageToken", valid_589895
  var valid_589896 = query.getOrDefault("quotaUser")
  valid_589896 = validateParameter(valid_589896, JString, required = false,
                                 default = nil)
  if valid_589896 != nil:
    section.add "quotaUser", valid_589896
  var valid_589897 = query.getOrDefault("alt")
  valid_589897 = validateParameter(valid_589897, JString, required = false,
                                 default = newJString("json"))
  if valid_589897 != nil:
    section.add "alt", valid_589897
  var valid_589898 = query.getOrDefault("oauth_token")
  valid_589898 = validateParameter(valid_589898, JString, required = false,
                                 default = nil)
  if valid_589898 != nil:
    section.add "oauth_token", valid_589898
  var valid_589899 = query.getOrDefault("userIp")
  valid_589899 = validateParameter(valid_589899, JString, required = false,
                                 default = nil)
  if valid_589899 != nil:
    section.add "userIp", valid_589899
  var valid_589900 = query.getOrDefault("maxResults")
  valid_589900 = validateParameter(valid_589900, JInt, required = false, default = nil)
  if valid_589900 != nil:
    section.add "maxResults", valid_589900
  var valid_589901 = query.getOrDefault("contentVersion")
  valid_589901 = validateParameter(valid_589901, JString, required = false,
                                 default = nil)
  if valid_589901 != nil:
    section.add "contentVersion", valid_589901
  var valid_589902 = query.getOrDefault("source")
  valid_589902 = validateParameter(valid_589902, JString, required = false,
                                 default = nil)
  if valid_589902 != nil:
    section.add "source", valid_589902
  var valid_589903 = query.getOrDefault("key")
  valid_589903 = validateParameter(valid_589903, JString, required = false,
                                 default = nil)
  if valid_589903 != nil:
    section.add "key", valid_589903
  var valid_589904 = query.getOrDefault("prettyPrint")
  valid_589904 = validateParameter(valid_589904, JBool, required = false,
                                 default = newJBool(true))
  if valid_589904 != nil:
    section.add "prettyPrint", valid_589904
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589905: Call_BooksLayersList_589890; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the layer summaries for a volume.
  ## 
  let valid = call_589905.validator(path, query, header, formData, body)
  let scheme = call_589905.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589905.url(scheme.get, call_589905.host, call_589905.base,
                         call_589905.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589905, url, valid)

proc call*(call_589906: Call_BooksLayersList_589890; volumeId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; contentVersion: string = ""; source: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## booksLayersList
  ## List the layer summaries for a volume.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The value of the nextToken from the previous page.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of results to return
  ##   contentVersion: string
  ##                 : The content version for the requested volume.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   volumeId: string (required)
  ##           : The volume to retrieve layers for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589907 = newJObject()
  var query_589908 = newJObject()
  add(query_589908, "fields", newJString(fields))
  add(query_589908, "pageToken", newJString(pageToken))
  add(query_589908, "quotaUser", newJString(quotaUser))
  add(query_589908, "alt", newJString(alt))
  add(query_589908, "oauth_token", newJString(oauthToken))
  add(query_589908, "userIp", newJString(userIp))
  add(query_589908, "maxResults", newJInt(maxResults))
  add(query_589908, "contentVersion", newJString(contentVersion))
  add(query_589908, "source", newJString(source))
  add(query_589908, "key", newJString(key))
  add(path_589907, "volumeId", newJString(volumeId))
  add(query_589908, "prettyPrint", newJBool(prettyPrint))
  result = call_589906.call(path_589907, query_589908, nil, nil, nil)

var booksLayersList* = Call_BooksLayersList_589890(name: "booksLayersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/volumes/{volumeId}/layersummary",
    validator: validate_BooksLayersList_589891, base: "/books/v1",
    url: url_BooksLayersList_589892, schemes: {Scheme.Https})
type
  Call_BooksLayersGet_589909 = ref object of OpenApiRestCall_588466
proc url_BooksLayersGet_589911(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "volumeId" in path, "`volumeId` is a required path parameter"
  assert "summaryId" in path, "`summaryId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/volumes/"),
               (kind: VariableSegment, value: "volumeId"),
               (kind: ConstantSegment, value: "/layersummary/"),
               (kind: VariableSegment, value: "summaryId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BooksLayersGet_589910(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets the layer summary for a volume.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   volumeId: JString (required)
  ##           : The volume to retrieve layers for.
  ##   summaryId: JString (required)
  ##            : The ID for the layer to get the summary for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `volumeId` field"
  var valid_589912 = path.getOrDefault("volumeId")
  valid_589912 = validateParameter(valid_589912, JString, required = true,
                                 default = nil)
  if valid_589912 != nil:
    section.add "volumeId", valid_589912
  var valid_589913 = path.getOrDefault("summaryId")
  valid_589913 = validateParameter(valid_589913, JString, required = true,
                                 default = nil)
  if valid_589913 != nil:
    section.add "summaryId", valid_589913
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   contentVersion: JString
  ##                 : The content version for the requested volume.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589914 = query.getOrDefault("fields")
  valid_589914 = validateParameter(valid_589914, JString, required = false,
                                 default = nil)
  if valid_589914 != nil:
    section.add "fields", valid_589914
  var valid_589915 = query.getOrDefault("quotaUser")
  valid_589915 = validateParameter(valid_589915, JString, required = false,
                                 default = nil)
  if valid_589915 != nil:
    section.add "quotaUser", valid_589915
  var valid_589916 = query.getOrDefault("alt")
  valid_589916 = validateParameter(valid_589916, JString, required = false,
                                 default = newJString("json"))
  if valid_589916 != nil:
    section.add "alt", valid_589916
  var valid_589917 = query.getOrDefault("oauth_token")
  valid_589917 = validateParameter(valid_589917, JString, required = false,
                                 default = nil)
  if valid_589917 != nil:
    section.add "oauth_token", valid_589917
  var valid_589918 = query.getOrDefault("userIp")
  valid_589918 = validateParameter(valid_589918, JString, required = false,
                                 default = nil)
  if valid_589918 != nil:
    section.add "userIp", valid_589918
  var valid_589919 = query.getOrDefault("contentVersion")
  valid_589919 = validateParameter(valid_589919, JString, required = false,
                                 default = nil)
  if valid_589919 != nil:
    section.add "contentVersion", valid_589919
  var valid_589920 = query.getOrDefault("source")
  valid_589920 = validateParameter(valid_589920, JString, required = false,
                                 default = nil)
  if valid_589920 != nil:
    section.add "source", valid_589920
  var valid_589921 = query.getOrDefault("key")
  valid_589921 = validateParameter(valid_589921, JString, required = false,
                                 default = nil)
  if valid_589921 != nil:
    section.add "key", valid_589921
  var valid_589922 = query.getOrDefault("prettyPrint")
  valid_589922 = validateParameter(valid_589922, JBool, required = false,
                                 default = newJBool(true))
  if valid_589922 != nil:
    section.add "prettyPrint", valid_589922
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589923: Call_BooksLayersGet_589909; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the layer summary for a volume.
  ## 
  let valid = call_589923.validator(path, query, header, formData, body)
  let scheme = call_589923.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589923.url(scheme.get, call_589923.host, call_589923.base,
                         call_589923.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589923, url, valid)

proc call*(call_589924: Call_BooksLayersGet_589909; volumeId: string;
          summaryId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          contentVersion: string = ""; source: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## booksLayersGet
  ## Gets the layer summary for a volume.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   contentVersion: string
  ##                 : The content version for the requested volume.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   volumeId: string (required)
  ##           : The volume to retrieve layers for.
  ##   summaryId: string (required)
  ##            : The ID for the layer to get the summary for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589925 = newJObject()
  var query_589926 = newJObject()
  add(query_589926, "fields", newJString(fields))
  add(query_589926, "quotaUser", newJString(quotaUser))
  add(query_589926, "alt", newJString(alt))
  add(query_589926, "oauth_token", newJString(oauthToken))
  add(query_589926, "userIp", newJString(userIp))
  add(query_589926, "contentVersion", newJString(contentVersion))
  add(query_589926, "source", newJString(source))
  add(query_589926, "key", newJString(key))
  add(path_589925, "volumeId", newJString(volumeId))
  add(path_589925, "summaryId", newJString(summaryId))
  add(query_589926, "prettyPrint", newJBool(prettyPrint))
  result = call_589924.call(path_589925, query_589926, nil, nil, nil)

var booksLayersGet* = Call_BooksLayersGet_589909(name: "booksLayersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/volumes/{volumeId}/layersummary/{summaryId}",
    validator: validate_BooksLayersGet_589910, base: "/books/v1",
    url: url_BooksLayersGet_589911, schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
