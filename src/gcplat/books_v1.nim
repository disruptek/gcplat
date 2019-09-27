
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597437 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597437](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597437): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BooksCloudloadingAddBook_597705 = ref object of OpenApiRestCall_597437
proc url_BooksCloudloadingAddBook_597707(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BooksCloudloadingAddBook_597706(path: JsonNode; query: JsonNode;
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
  var valid_597819 = query.getOrDefault("fields")
  valid_597819 = validateParameter(valid_597819, JString, required = false,
                                 default = nil)
  if valid_597819 != nil:
    section.add "fields", valid_597819
  var valid_597820 = query.getOrDefault("quotaUser")
  valid_597820 = validateParameter(valid_597820, JString, required = false,
                                 default = nil)
  if valid_597820 != nil:
    section.add "quotaUser", valid_597820
  var valid_597834 = query.getOrDefault("alt")
  valid_597834 = validateParameter(valid_597834, JString, required = false,
                                 default = newJString("json"))
  if valid_597834 != nil:
    section.add "alt", valid_597834
  var valid_597835 = query.getOrDefault("mime_type")
  valid_597835 = validateParameter(valid_597835, JString, required = false,
                                 default = nil)
  if valid_597835 != nil:
    section.add "mime_type", valid_597835
  var valid_597836 = query.getOrDefault("oauth_token")
  valid_597836 = validateParameter(valid_597836, JString, required = false,
                                 default = nil)
  if valid_597836 != nil:
    section.add "oauth_token", valid_597836
  var valid_597837 = query.getOrDefault("userIp")
  valid_597837 = validateParameter(valid_597837, JString, required = false,
                                 default = nil)
  if valid_597837 != nil:
    section.add "userIp", valid_597837
  var valid_597838 = query.getOrDefault("drive_document_id")
  valid_597838 = validateParameter(valid_597838, JString, required = false,
                                 default = nil)
  if valid_597838 != nil:
    section.add "drive_document_id", valid_597838
  var valid_597839 = query.getOrDefault("key")
  valid_597839 = validateParameter(valid_597839, JString, required = false,
                                 default = nil)
  if valid_597839 != nil:
    section.add "key", valid_597839
  var valid_597840 = query.getOrDefault("name")
  valid_597840 = validateParameter(valid_597840, JString, required = false,
                                 default = nil)
  if valid_597840 != nil:
    section.add "name", valid_597840
  var valid_597841 = query.getOrDefault("prettyPrint")
  valid_597841 = validateParameter(valid_597841, JBool, required = false,
                                 default = newJBool(true))
  if valid_597841 != nil:
    section.add "prettyPrint", valid_597841
  var valid_597842 = query.getOrDefault("upload_client_token")
  valid_597842 = validateParameter(valid_597842, JString, required = false,
                                 default = nil)
  if valid_597842 != nil:
    section.add "upload_client_token", valid_597842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597865: Call_BooksCloudloadingAddBook_597705; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_597865.validator(path, query, header, formData, body)
  let scheme = call_597865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597865.url(scheme.get, call_597865.host, call_597865.base,
                         call_597865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597865, url, valid)

proc call*(call_597936: Call_BooksCloudloadingAddBook_597705; fields: string = "";
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
  var query_597937 = newJObject()
  add(query_597937, "fields", newJString(fields))
  add(query_597937, "quotaUser", newJString(quotaUser))
  add(query_597937, "alt", newJString(alt))
  add(query_597937, "mime_type", newJString(mimeType))
  add(query_597937, "oauth_token", newJString(oauthToken))
  add(query_597937, "userIp", newJString(userIp))
  add(query_597937, "drive_document_id", newJString(driveDocumentId))
  add(query_597937, "key", newJString(key))
  add(query_597937, "name", newJString(name))
  add(query_597937, "prettyPrint", newJBool(prettyPrint))
  add(query_597937, "upload_client_token", newJString(uploadClientToken))
  result = call_597936.call(nil, query_597937, nil, nil, nil)

var booksCloudloadingAddBook* = Call_BooksCloudloadingAddBook_597705(
    name: "booksCloudloadingAddBook", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/cloudloading/addBook",
    validator: validate_BooksCloudloadingAddBook_597706, base: "/books/v1",
    url: url_BooksCloudloadingAddBook_597707, schemes: {Scheme.Https})
type
  Call_BooksCloudloadingDeleteBook_597977 = ref object of OpenApiRestCall_597437
proc url_BooksCloudloadingDeleteBook_597979(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BooksCloudloadingDeleteBook_597978(path: JsonNode; query: JsonNode;
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
  var valid_597980 = query.getOrDefault("fields")
  valid_597980 = validateParameter(valid_597980, JString, required = false,
                                 default = nil)
  if valid_597980 != nil:
    section.add "fields", valid_597980
  var valid_597981 = query.getOrDefault("quotaUser")
  valid_597981 = validateParameter(valid_597981, JString, required = false,
                                 default = nil)
  if valid_597981 != nil:
    section.add "quotaUser", valid_597981
  var valid_597982 = query.getOrDefault("alt")
  valid_597982 = validateParameter(valid_597982, JString, required = false,
                                 default = newJString("json"))
  if valid_597982 != nil:
    section.add "alt", valid_597982
  var valid_597983 = query.getOrDefault("oauth_token")
  valid_597983 = validateParameter(valid_597983, JString, required = false,
                                 default = nil)
  if valid_597983 != nil:
    section.add "oauth_token", valid_597983
  var valid_597984 = query.getOrDefault("userIp")
  valid_597984 = validateParameter(valid_597984, JString, required = false,
                                 default = nil)
  if valid_597984 != nil:
    section.add "userIp", valid_597984
  var valid_597985 = query.getOrDefault("key")
  valid_597985 = validateParameter(valid_597985, JString, required = false,
                                 default = nil)
  if valid_597985 != nil:
    section.add "key", valid_597985
  assert query != nil,
        "query argument is necessary due to required `volumeId` field"
  var valid_597986 = query.getOrDefault("volumeId")
  valid_597986 = validateParameter(valid_597986, JString, required = true,
                                 default = nil)
  if valid_597986 != nil:
    section.add "volumeId", valid_597986
  var valid_597987 = query.getOrDefault("prettyPrint")
  valid_597987 = validateParameter(valid_597987, JBool, required = false,
                                 default = newJBool(true))
  if valid_597987 != nil:
    section.add "prettyPrint", valid_597987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597988: Call_BooksCloudloadingDeleteBook_597977; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove the book and its contents
  ## 
  let valid = call_597988.validator(path, query, header, formData, body)
  let scheme = call_597988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597988.url(scheme.get, call_597988.host, call_597988.base,
                         call_597988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597988, url, valid)

proc call*(call_597989: Call_BooksCloudloadingDeleteBook_597977; volumeId: string;
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
  var query_597990 = newJObject()
  add(query_597990, "fields", newJString(fields))
  add(query_597990, "quotaUser", newJString(quotaUser))
  add(query_597990, "alt", newJString(alt))
  add(query_597990, "oauth_token", newJString(oauthToken))
  add(query_597990, "userIp", newJString(userIp))
  add(query_597990, "key", newJString(key))
  add(query_597990, "volumeId", newJString(volumeId))
  add(query_597990, "prettyPrint", newJBool(prettyPrint))
  result = call_597989.call(nil, query_597990, nil, nil, nil)

var booksCloudloadingDeleteBook* = Call_BooksCloudloadingDeleteBook_597977(
    name: "booksCloudloadingDeleteBook", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/cloudloading/deleteBook",
    validator: validate_BooksCloudloadingDeleteBook_597978, base: "/books/v1",
    url: url_BooksCloudloadingDeleteBook_597979, schemes: {Scheme.Https})
type
  Call_BooksCloudloadingUpdateBook_597991 = ref object of OpenApiRestCall_597437
proc url_BooksCloudloadingUpdateBook_597993(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BooksCloudloadingUpdateBook_597992(path: JsonNode; query: JsonNode;
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
  var valid_597994 = query.getOrDefault("fields")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "fields", valid_597994
  var valid_597995 = query.getOrDefault("quotaUser")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "quotaUser", valid_597995
  var valid_597996 = query.getOrDefault("alt")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = newJString("json"))
  if valid_597996 != nil:
    section.add "alt", valid_597996
  var valid_597997 = query.getOrDefault("oauth_token")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "oauth_token", valid_597997
  var valid_597998 = query.getOrDefault("userIp")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = nil)
  if valid_597998 != nil:
    section.add "userIp", valid_597998
  var valid_597999 = query.getOrDefault("key")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = nil)
  if valid_597999 != nil:
    section.add "key", valid_597999
  var valid_598000 = query.getOrDefault("prettyPrint")
  valid_598000 = validateParameter(valid_598000, JBool, required = false,
                                 default = newJBool(true))
  if valid_598000 != nil:
    section.add "prettyPrint", valid_598000
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

proc call*(call_598002: Call_BooksCloudloadingUpdateBook_597991; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_598002.validator(path, query, header, formData, body)
  let scheme = call_598002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598002.url(scheme.get, call_598002.host, call_598002.base,
                         call_598002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598002, url, valid)

proc call*(call_598003: Call_BooksCloudloadingUpdateBook_597991;
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
  var query_598004 = newJObject()
  var body_598005 = newJObject()
  add(query_598004, "fields", newJString(fields))
  add(query_598004, "quotaUser", newJString(quotaUser))
  add(query_598004, "alt", newJString(alt))
  add(query_598004, "oauth_token", newJString(oauthToken))
  add(query_598004, "userIp", newJString(userIp))
  add(query_598004, "key", newJString(key))
  if body != nil:
    body_598005 = body
  add(query_598004, "prettyPrint", newJBool(prettyPrint))
  result = call_598003.call(nil, query_598004, nil, nil, body_598005)

var booksCloudloadingUpdateBook* = Call_BooksCloudloadingUpdateBook_597991(
    name: "booksCloudloadingUpdateBook", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/cloudloading/updateBook",
    validator: validate_BooksCloudloadingUpdateBook_597992, base: "/books/v1",
    url: url_BooksCloudloadingUpdateBook_597993, schemes: {Scheme.Https})
type
  Call_BooksDictionaryListOfflineMetadata_598006 = ref object of OpenApiRestCall_597437
proc url_BooksDictionaryListOfflineMetadata_598008(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BooksDictionaryListOfflineMetadata_598007(path: JsonNode;
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
  var valid_598009 = query.getOrDefault("fields")
  valid_598009 = validateParameter(valid_598009, JString, required = false,
                                 default = nil)
  if valid_598009 != nil:
    section.add "fields", valid_598009
  var valid_598010 = query.getOrDefault("quotaUser")
  valid_598010 = validateParameter(valid_598010, JString, required = false,
                                 default = nil)
  if valid_598010 != nil:
    section.add "quotaUser", valid_598010
  var valid_598011 = query.getOrDefault("alt")
  valid_598011 = validateParameter(valid_598011, JString, required = false,
                                 default = newJString("json"))
  if valid_598011 != nil:
    section.add "alt", valid_598011
  var valid_598012 = query.getOrDefault("oauth_token")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "oauth_token", valid_598012
  assert query != nil, "query argument is necessary due to required `cpksver` field"
  var valid_598013 = query.getOrDefault("cpksver")
  valid_598013 = validateParameter(valid_598013, JString, required = true,
                                 default = nil)
  if valid_598013 != nil:
    section.add "cpksver", valid_598013
  var valid_598014 = query.getOrDefault("userIp")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = nil)
  if valid_598014 != nil:
    section.add "userIp", valid_598014
  var valid_598015 = query.getOrDefault("key")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "key", valid_598015
  var valid_598016 = query.getOrDefault("prettyPrint")
  valid_598016 = validateParameter(valid_598016, JBool, required = false,
                                 default = newJBool(true))
  if valid_598016 != nil:
    section.add "prettyPrint", valid_598016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598017: Call_BooksDictionaryListOfflineMetadata_598006;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of offline dictionary metadata available
  ## 
  let valid = call_598017.validator(path, query, header, formData, body)
  let scheme = call_598017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598017.url(scheme.get, call_598017.host, call_598017.base,
                         call_598017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598017, url, valid)

proc call*(call_598018: Call_BooksDictionaryListOfflineMetadata_598006;
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
  var query_598019 = newJObject()
  add(query_598019, "fields", newJString(fields))
  add(query_598019, "quotaUser", newJString(quotaUser))
  add(query_598019, "alt", newJString(alt))
  add(query_598019, "oauth_token", newJString(oauthToken))
  add(query_598019, "cpksver", newJString(cpksver))
  add(query_598019, "userIp", newJString(userIp))
  add(query_598019, "key", newJString(key))
  add(query_598019, "prettyPrint", newJBool(prettyPrint))
  result = call_598018.call(nil, query_598019, nil, nil, nil)

var booksDictionaryListOfflineMetadata* = Call_BooksDictionaryListOfflineMetadata_598006(
    name: "booksDictionaryListOfflineMetadata", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/dictionary/listOfflineMetadata",
    validator: validate_BooksDictionaryListOfflineMetadata_598007,
    base: "/books/v1", url: url_BooksDictionaryListOfflineMetadata_598008,
    schemes: {Scheme.Https})
type
  Call_BooksFamilysharingGetFamilyInfo_598020 = ref object of OpenApiRestCall_597437
proc url_BooksFamilysharingGetFamilyInfo_598022(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BooksFamilysharingGetFamilyInfo_598021(path: JsonNode;
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
  var valid_598023 = query.getOrDefault("fields")
  valid_598023 = validateParameter(valid_598023, JString, required = false,
                                 default = nil)
  if valid_598023 != nil:
    section.add "fields", valid_598023
  var valid_598024 = query.getOrDefault("quotaUser")
  valid_598024 = validateParameter(valid_598024, JString, required = false,
                                 default = nil)
  if valid_598024 != nil:
    section.add "quotaUser", valid_598024
  var valid_598025 = query.getOrDefault("alt")
  valid_598025 = validateParameter(valid_598025, JString, required = false,
                                 default = newJString("json"))
  if valid_598025 != nil:
    section.add "alt", valid_598025
  var valid_598026 = query.getOrDefault("oauth_token")
  valid_598026 = validateParameter(valid_598026, JString, required = false,
                                 default = nil)
  if valid_598026 != nil:
    section.add "oauth_token", valid_598026
  var valid_598027 = query.getOrDefault("userIp")
  valid_598027 = validateParameter(valid_598027, JString, required = false,
                                 default = nil)
  if valid_598027 != nil:
    section.add "userIp", valid_598027
  var valid_598028 = query.getOrDefault("source")
  valid_598028 = validateParameter(valid_598028, JString, required = false,
                                 default = nil)
  if valid_598028 != nil:
    section.add "source", valid_598028
  var valid_598029 = query.getOrDefault("key")
  valid_598029 = validateParameter(valid_598029, JString, required = false,
                                 default = nil)
  if valid_598029 != nil:
    section.add "key", valid_598029
  var valid_598030 = query.getOrDefault("prettyPrint")
  valid_598030 = validateParameter(valid_598030, JBool, required = false,
                                 default = newJBool(true))
  if valid_598030 != nil:
    section.add "prettyPrint", valid_598030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598031: Call_BooksFamilysharingGetFamilyInfo_598020;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information regarding the family that the user is part of.
  ## 
  let valid = call_598031.validator(path, query, header, formData, body)
  let scheme = call_598031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598031.url(scheme.get, call_598031.host, call_598031.base,
                         call_598031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598031, url, valid)

proc call*(call_598032: Call_BooksFamilysharingGetFamilyInfo_598020;
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
  var query_598033 = newJObject()
  add(query_598033, "fields", newJString(fields))
  add(query_598033, "quotaUser", newJString(quotaUser))
  add(query_598033, "alt", newJString(alt))
  add(query_598033, "oauth_token", newJString(oauthToken))
  add(query_598033, "userIp", newJString(userIp))
  add(query_598033, "source", newJString(source))
  add(query_598033, "key", newJString(key))
  add(query_598033, "prettyPrint", newJBool(prettyPrint))
  result = call_598032.call(nil, query_598033, nil, nil, nil)

var booksFamilysharingGetFamilyInfo* = Call_BooksFamilysharingGetFamilyInfo_598020(
    name: "booksFamilysharingGetFamilyInfo", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/familysharing/getFamilyInfo",
    validator: validate_BooksFamilysharingGetFamilyInfo_598021, base: "/books/v1",
    url: url_BooksFamilysharingGetFamilyInfo_598022, schemes: {Scheme.Https})
type
  Call_BooksFamilysharingShare_598034 = ref object of OpenApiRestCall_597437
proc url_BooksFamilysharingShare_598036(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BooksFamilysharingShare_598035(path: JsonNode; query: JsonNode;
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
  var valid_598037 = query.getOrDefault("fields")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = nil)
  if valid_598037 != nil:
    section.add "fields", valid_598037
  var valid_598038 = query.getOrDefault("quotaUser")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = nil)
  if valid_598038 != nil:
    section.add "quotaUser", valid_598038
  var valid_598039 = query.getOrDefault("alt")
  valid_598039 = validateParameter(valid_598039, JString, required = false,
                                 default = newJString("json"))
  if valid_598039 != nil:
    section.add "alt", valid_598039
  var valid_598040 = query.getOrDefault("oauth_token")
  valid_598040 = validateParameter(valid_598040, JString, required = false,
                                 default = nil)
  if valid_598040 != nil:
    section.add "oauth_token", valid_598040
  var valid_598041 = query.getOrDefault("userIp")
  valid_598041 = validateParameter(valid_598041, JString, required = false,
                                 default = nil)
  if valid_598041 != nil:
    section.add "userIp", valid_598041
  var valid_598042 = query.getOrDefault("source")
  valid_598042 = validateParameter(valid_598042, JString, required = false,
                                 default = nil)
  if valid_598042 != nil:
    section.add "source", valid_598042
  var valid_598043 = query.getOrDefault("key")
  valid_598043 = validateParameter(valid_598043, JString, required = false,
                                 default = nil)
  if valid_598043 != nil:
    section.add "key", valid_598043
  var valid_598044 = query.getOrDefault("docId")
  valid_598044 = validateParameter(valid_598044, JString, required = false,
                                 default = nil)
  if valid_598044 != nil:
    section.add "docId", valid_598044
  var valid_598045 = query.getOrDefault("volumeId")
  valid_598045 = validateParameter(valid_598045, JString, required = false,
                                 default = nil)
  if valid_598045 != nil:
    section.add "volumeId", valid_598045
  var valid_598046 = query.getOrDefault("prettyPrint")
  valid_598046 = validateParameter(valid_598046, JBool, required = false,
                                 default = newJBool(true))
  if valid_598046 != nil:
    section.add "prettyPrint", valid_598046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598047: Call_BooksFamilysharingShare_598034; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Initiates sharing of the content with the user's family. Empty response indicates success.
  ## 
  let valid = call_598047.validator(path, query, header, formData, body)
  let scheme = call_598047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598047.url(scheme.get, call_598047.host, call_598047.base,
                         call_598047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598047, url, valid)

proc call*(call_598048: Call_BooksFamilysharingShare_598034; fields: string = "";
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
  var query_598049 = newJObject()
  add(query_598049, "fields", newJString(fields))
  add(query_598049, "quotaUser", newJString(quotaUser))
  add(query_598049, "alt", newJString(alt))
  add(query_598049, "oauth_token", newJString(oauthToken))
  add(query_598049, "userIp", newJString(userIp))
  add(query_598049, "source", newJString(source))
  add(query_598049, "key", newJString(key))
  add(query_598049, "docId", newJString(docId))
  add(query_598049, "volumeId", newJString(volumeId))
  add(query_598049, "prettyPrint", newJBool(prettyPrint))
  result = call_598048.call(nil, query_598049, nil, nil, nil)

var booksFamilysharingShare* = Call_BooksFamilysharingShare_598034(
    name: "booksFamilysharingShare", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/familysharing/share",
    validator: validate_BooksFamilysharingShare_598035, base: "/books/v1",
    url: url_BooksFamilysharingShare_598036, schemes: {Scheme.Https})
type
  Call_BooksFamilysharingUnshare_598050 = ref object of OpenApiRestCall_597437
proc url_BooksFamilysharingUnshare_598052(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BooksFamilysharingUnshare_598051(path: JsonNode; query: JsonNode;
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
  var valid_598053 = query.getOrDefault("fields")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = nil)
  if valid_598053 != nil:
    section.add "fields", valid_598053
  var valid_598054 = query.getOrDefault("quotaUser")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = nil)
  if valid_598054 != nil:
    section.add "quotaUser", valid_598054
  var valid_598055 = query.getOrDefault("alt")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = newJString("json"))
  if valid_598055 != nil:
    section.add "alt", valid_598055
  var valid_598056 = query.getOrDefault("oauth_token")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = nil)
  if valid_598056 != nil:
    section.add "oauth_token", valid_598056
  var valid_598057 = query.getOrDefault("userIp")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = nil)
  if valid_598057 != nil:
    section.add "userIp", valid_598057
  var valid_598058 = query.getOrDefault("source")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = nil)
  if valid_598058 != nil:
    section.add "source", valid_598058
  var valid_598059 = query.getOrDefault("key")
  valid_598059 = validateParameter(valid_598059, JString, required = false,
                                 default = nil)
  if valid_598059 != nil:
    section.add "key", valid_598059
  var valid_598060 = query.getOrDefault("docId")
  valid_598060 = validateParameter(valid_598060, JString, required = false,
                                 default = nil)
  if valid_598060 != nil:
    section.add "docId", valid_598060
  var valid_598061 = query.getOrDefault("volumeId")
  valid_598061 = validateParameter(valid_598061, JString, required = false,
                                 default = nil)
  if valid_598061 != nil:
    section.add "volumeId", valid_598061
  var valid_598062 = query.getOrDefault("prettyPrint")
  valid_598062 = validateParameter(valid_598062, JBool, required = false,
                                 default = newJBool(true))
  if valid_598062 != nil:
    section.add "prettyPrint", valid_598062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598063: Call_BooksFamilysharingUnshare_598050; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Initiates revoking content that has already been shared with the user's family. Empty response indicates success.
  ## 
  let valid = call_598063.validator(path, query, header, formData, body)
  let scheme = call_598063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598063.url(scheme.get, call_598063.host, call_598063.base,
                         call_598063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598063, url, valid)

proc call*(call_598064: Call_BooksFamilysharingUnshare_598050; fields: string = "";
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
  var query_598065 = newJObject()
  add(query_598065, "fields", newJString(fields))
  add(query_598065, "quotaUser", newJString(quotaUser))
  add(query_598065, "alt", newJString(alt))
  add(query_598065, "oauth_token", newJString(oauthToken))
  add(query_598065, "userIp", newJString(userIp))
  add(query_598065, "source", newJString(source))
  add(query_598065, "key", newJString(key))
  add(query_598065, "docId", newJString(docId))
  add(query_598065, "volumeId", newJString(volumeId))
  add(query_598065, "prettyPrint", newJBool(prettyPrint))
  result = call_598064.call(nil, query_598065, nil, nil, nil)

var booksFamilysharingUnshare* = Call_BooksFamilysharingUnshare_598050(
    name: "booksFamilysharingUnshare", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/familysharing/unshare",
    validator: validate_BooksFamilysharingUnshare_598051, base: "/books/v1",
    url: url_BooksFamilysharingUnshare_598052, schemes: {Scheme.Https})
type
  Call_BooksMyconfigGetUserSettings_598066 = ref object of OpenApiRestCall_597437
proc url_BooksMyconfigGetUserSettings_598068(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BooksMyconfigGetUserSettings_598067(path: JsonNode; query: JsonNode;
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
  var valid_598069 = query.getOrDefault("fields")
  valid_598069 = validateParameter(valid_598069, JString, required = false,
                                 default = nil)
  if valid_598069 != nil:
    section.add "fields", valid_598069
  var valid_598070 = query.getOrDefault("quotaUser")
  valid_598070 = validateParameter(valid_598070, JString, required = false,
                                 default = nil)
  if valid_598070 != nil:
    section.add "quotaUser", valid_598070
  var valid_598071 = query.getOrDefault("alt")
  valid_598071 = validateParameter(valid_598071, JString, required = false,
                                 default = newJString("json"))
  if valid_598071 != nil:
    section.add "alt", valid_598071
  var valid_598072 = query.getOrDefault("oauth_token")
  valid_598072 = validateParameter(valid_598072, JString, required = false,
                                 default = nil)
  if valid_598072 != nil:
    section.add "oauth_token", valid_598072
  var valid_598073 = query.getOrDefault("userIp")
  valid_598073 = validateParameter(valid_598073, JString, required = false,
                                 default = nil)
  if valid_598073 != nil:
    section.add "userIp", valid_598073
  var valid_598074 = query.getOrDefault("key")
  valid_598074 = validateParameter(valid_598074, JString, required = false,
                                 default = nil)
  if valid_598074 != nil:
    section.add "key", valid_598074
  var valid_598075 = query.getOrDefault("prettyPrint")
  valid_598075 = validateParameter(valid_598075, JBool, required = false,
                                 default = newJBool(true))
  if valid_598075 != nil:
    section.add "prettyPrint", valid_598075
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598076: Call_BooksMyconfigGetUserSettings_598066; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current settings for the user.
  ## 
  let valid = call_598076.validator(path, query, header, formData, body)
  let scheme = call_598076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598076.url(scheme.get, call_598076.host, call_598076.base,
                         call_598076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598076, url, valid)

proc call*(call_598077: Call_BooksMyconfigGetUserSettings_598066;
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
  var query_598078 = newJObject()
  add(query_598078, "fields", newJString(fields))
  add(query_598078, "quotaUser", newJString(quotaUser))
  add(query_598078, "alt", newJString(alt))
  add(query_598078, "oauth_token", newJString(oauthToken))
  add(query_598078, "userIp", newJString(userIp))
  add(query_598078, "key", newJString(key))
  add(query_598078, "prettyPrint", newJBool(prettyPrint))
  result = call_598077.call(nil, query_598078, nil, nil, nil)

var booksMyconfigGetUserSettings* = Call_BooksMyconfigGetUserSettings_598066(
    name: "booksMyconfigGetUserSettings", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/myconfig/getUserSettings",
    validator: validate_BooksMyconfigGetUserSettings_598067, base: "/books/v1",
    url: url_BooksMyconfigGetUserSettings_598068, schemes: {Scheme.Https})
type
  Call_BooksMyconfigReleaseDownloadAccess_598079 = ref object of OpenApiRestCall_597437
proc url_BooksMyconfigReleaseDownloadAccess_598081(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BooksMyconfigReleaseDownloadAccess_598080(path: JsonNode;
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
  var valid_598082 = query.getOrDefault("locale")
  valid_598082 = validateParameter(valid_598082, JString, required = false,
                                 default = nil)
  if valid_598082 != nil:
    section.add "locale", valid_598082
  var valid_598083 = query.getOrDefault("fields")
  valid_598083 = validateParameter(valid_598083, JString, required = false,
                                 default = nil)
  if valid_598083 != nil:
    section.add "fields", valid_598083
  var valid_598084 = query.getOrDefault("quotaUser")
  valid_598084 = validateParameter(valid_598084, JString, required = false,
                                 default = nil)
  if valid_598084 != nil:
    section.add "quotaUser", valid_598084
  var valid_598085 = query.getOrDefault("alt")
  valid_598085 = validateParameter(valid_598085, JString, required = false,
                                 default = newJString("json"))
  if valid_598085 != nil:
    section.add "alt", valid_598085
  var valid_598086 = query.getOrDefault("oauth_token")
  valid_598086 = validateParameter(valid_598086, JString, required = false,
                                 default = nil)
  if valid_598086 != nil:
    section.add "oauth_token", valid_598086
  assert query != nil, "query argument is necessary due to required `cpksver` field"
  var valid_598087 = query.getOrDefault("cpksver")
  valid_598087 = validateParameter(valid_598087, JString, required = true,
                                 default = nil)
  if valid_598087 != nil:
    section.add "cpksver", valid_598087
  var valid_598088 = query.getOrDefault("userIp")
  valid_598088 = validateParameter(valid_598088, JString, required = false,
                                 default = nil)
  if valid_598088 != nil:
    section.add "userIp", valid_598088
  var valid_598089 = query.getOrDefault("volumeIds")
  valid_598089 = validateParameter(valid_598089, JArray, required = true, default = nil)
  if valid_598089 != nil:
    section.add "volumeIds", valid_598089
  var valid_598090 = query.getOrDefault("source")
  valid_598090 = validateParameter(valid_598090, JString, required = false,
                                 default = nil)
  if valid_598090 != nil:
    section.add "source", valid_598090
  var valid_598091 = query.getOrDefault("key")
  valid_598091 = validateParameter(valid_598091, JString, required = false,
                                 default = nil)
  if valid_598091 != nil:
    section.add "key", valid_598091
  var valid_598092 = query.getOrDefault("prettyPrint")
  valid_598092 = validateParameter(valid_598092, JBool, required = false,
                                 default = newJBool(true))
  if valid_598092 != nil:
    section.add "prettyPrint", valid_598092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598093: Call_BooksMyconfigReleaseDownloadAccess_598079;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Release downloaded content access restriction.
  ## 
  let valid = call_598093.validator(path, query, header, formData, body)
  let scheme = call_598093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598093.url(scheme.get, call_598093.host, call_598093.base,
                         call_598093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598093, url, valid)

proc call*(call_598094: Call_BooksMyconfigReleaseDownloadAccess_598079;
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
  var query_598095 = newJObject()
  add(query_598095, "locale", newJString(locale))
  add(query_598095, "fields", newJString(fields))
  add(query_598095, "quotaUser", newJString(quotaUser))
  add(query_598095, "alt", newJString(alt))
  add(query_598095, "oauth_token", newJString(oauthToken))
  add(query_598095, "cpksver", newJString(cpksver))
  add(query_598095, "userIp", newJString(userIp))
  if volumeIds != nil:
    query_598095.add "volumeIds", volumeIds
  add(query_598095, "source", newJString(source))
  add(query_598095, "key", newJString(key))
  add(query_598095, "prettyPrint", newJBool(prettyPrint))
  result = call_598094.call(nil, query_598095, nil, nil, nil)

var booksMyconfigReleaseDownloadAccess* = Call_BooksMyconfigReleaseDownloadAccess_598079(
    name: "booksMyconfigReleaseDownloadAccess", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/myconfig/releaseDownloadAccess",
    validator: validate_BooksMyconfigReleaseDownloadAccess_598080,
    base: "/books/v1", url: url_BooksMyconfigReleaseDownloadAccess_598081,
    schemes: {Scheme.Https})
type
  Call_BooksMyconfigRequestAccess_598096 = ref object of OpenApiRestCall_597437
proc url_BooksMyconfigRequestAccess_598098(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BooksMyconfigRequestAccess_598097(path: JsonNode; query: JsonNode;
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
  var valid_598099 = query.getOrDefault("locale")
  valid_598099 = validateParameter(valid_598099, JString, required = false,
                                 default = nil)
  if valid_598099 != nil:
    section.add "locale", valid_598099
  var valid_598100 = query.getOrDefault("fields")
  valid_598100 = validateParameter(valid_598100, JString, required = false,
                                 default = nil)
  if valid_598100 != nil:
    section.add "fields", valid_598100
  var valid_598101 = query.getOrDefault("quotaUser")
  valid_598101 = validateParameter(valid_598101, JString, required = false,
                                 default = nil)
  if valid_598101 != nil:
    section.add "quotaUser", valid_598101
  var valid_598102 = query.getOrDefault("alt")
  valid_598102 = validateParameter(valid_598102, JString, required = false,
                                 default = newJString("json"))
  if valid_598102 != nil:
    section.add "alt", valid_598102
  var valid_598103 = query.getOrDefault("oauth_token")
  valid_598103 = validateParameter(valid_598103, JString, required = false,
                                 default = nil)
  if valid_598103 != nil:
    section.add "oauth_token", valid_598103
  assert query != nil, "query argument is necessary due to required `cpksver` field"
  var valid_598104 = query.getOrDefault("cpksver")
  valid_598104 = validateParameter(valid_598104, JString, required = true,
                                 default = nil)
  if valid_598104 != nil:
    section.add "cpksver", valid_598104
  var valid_598105 = query.getOrDefault("userIp")
  valid_598105 = validateParameter(valid_598105, JString, required = false,
                                 default = nil)
  if valid_598105 != nil:
    section.add "userIp", valid_598105
  var valid_598106 = query.getOrDefault("licenseTypes")
  valid_598106 = validateParameter(valid_598106, JString, required = false,
                                 default = newJString("BOTH"))
  if valid_598106 != nil:
    section.add "licenseTypes", valid_598106
  var valid_598107 = query.getOrDefault("nonce")
  valid_598107 = validateParameter(valid_598107, JString, required = true,
                                 default = nil)
  if valid_598107 != nil:
    section.add "nonce", valid_598107
  var valid_598108 = query.getOrDefault("source")
  valid_598108 = validateParameter(valid_598108, JString, required = true,
                                 default = nil)
  if valid_598108 != nil:
    section.add "source", valid_598108
  var valid_598109 = query.getOrDefault("key")
  valid_598109 = validateParameter(valid_598109, JString, required = false,
                                 default = nil)
  if valid_598109 != nil:
    section.add "key", valid_598109
  var valid_598110 = query.getOrDefault("volumeId")
  valid_598110 = validateParameter(valid_598110, JString, required = true,
                                 default = nil)
  if valid_598110 != nil:
    section.add "volumeId", valid_598110
  var valid_598111 = query.getOrDefault("prettyPrint")
  valid_598111 = validateParameter(valid_598111, JBool, required = false,
                                 default = newJBool(true))
  if valid_598111 != nil:
    section.add "prettyPrint", valid_598111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598112: Call_BooksMyconfigRequestAccess_598096; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Request concurrent and download access restrictions.
  ## 
  let valid = call_598112.validator(path, query, header, formData, body)
  let scheme = call_598112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598112.url(scheme.get, call_598112.host, call_598112.base,
                         call_598112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598112, url, valid)

proc call*(call_598113: Call_BooksMyconfigRequestAccess_598096; cpksver: string;
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
  var query_598114 = newJObject()
  add(query_598114, "locale", newJString(locale))
  add(query_598114, "fields", newJString(fields))
  add(query_598114, "quotaUser", newJString(quotaUser))
  add(query_598114, "alt", newJString(alt))
  add(query_598114, "oauth_token", newJString(oauthToken))
  add(query_598114, "cpksver", newJString(cpksver))
  add(query_598114, "userIp", newJString(userIp))
  add(query_598114, "licenseTypes", newJString(licenseTypes))
  add(query_598114, "nonce", newJString(nonce))
  add(query_598114, "source", newJString(source))
  add(query_598114, "key", newJString(key))
  add(query_598114, "volumeId", newJString(volumeId))
  add(query_598114, "prettyPrint", newJBool(prettyPrint))
  result = call_598113.call(nil, query_598114, nil, nil, nil)

var booksMyconfigRequestAccess* = Call_BooksMyconfigRequestAccess_598096(
    name: "booksMyconfigRequestAccess", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/myconfig/requestAccess",
    validator: validate_BooksMyconfigRequestAccess_598097, base: "/books/v1",
    url: url_BooksMyconfigRequestAccess_598098, schemes: {Scheme.Https})
type
  Call_BooksMyconfigSyncVolumeLicenses_598115 = ref object of OpenApiRestCall_597437
proc url_BooksMyconfigSyncVolumeLicenses_598117(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BooksMyconfigSyncVolumeLicenses_598116(path: JsonNode;
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
  var valid_598118 = query.getOrDefault("locale")
  valid_598118 = validateParameter(valid_598118, JString, required = false,
                                 default = nil)
  if valid_598118 != nil:
    section.add "locale", valid_598118
  var valid_598119 = query.getOrDefault("fields")
  valid_598119 = validateParameter(valid_598119, JString, required = false,
                                 default = nil)
  if valid_598119 != nil:
    section.add "fields", valid_598119
  var valid_598120 = query.getOrDefault("quotaUser")
  valid_598120 = validateParameter(valid_598120, JString, required = false,
                                 default = nil)
  if valid_598120 != nil:
    section.add "quotaUser", valid_598120
  var valid_598121 = query.getOrDefault("alt")
  valid_598121 = validateParameter(valid_598121, JString, required = false,
                                 default = newJString("json"))
  if valid_598121 != nil:
    section.add "alt", valid_598121
  var valid_598122 = query.getOrDefault("oauth_token")
  valid_598122 = validateParameter(valid_598122, JString, required = false,
                                 default = nil)
  if valid_598122 != nil:
    section.add "oauth_token", valid_598122
  assert query != nil, "query argument is necessary due to required `cpksver` field"
  var valid_598123 = query.getOrDefault("cpksver")
  valid_598123 = validateParameter(valid_598123, JString, required = true,
                                 default = nil)
  if valid_598123 != nil:
    section.add "cpksver", valid_598123
  var valid_598124 = query.getOrDefault("includeNonComicsSeries")
  valid_598124 = validateParameter(valid_598124, JBool, required = false, default = nil)
  if valid_598124 != nil:
    section.add "includeNonComicsSeries", valid_598124
  var valid_598125 = query.getOrDefault("userIp")
  valid_598125 = validateParameter(valid_598125, JString, required = false,
                                 default = nil)
  if valid_598125 != nil:
    section.add "userIp", valid_598125
  var valid_598126 = query.getOrDefault("nonce")
  valid_598126 = validateParameter(valid_598126, JString, required = true,
                                 default = nil)
  if valid_598126 != nil:
    section.add "nonce", valid_598126
  var valid_598127 = query.getOrDefault("volumeIds")
  valid_598127 = validateParameter(valid_598127, JArray, required = false,
                                 default = nil)
  if valid_598127 != nil:
    section.add "volumeIds", valid_598127
  var valid_598128 = query.getOrDefault("source")
  valid_598128 = validateParameter(valid_598128, JString, required = true,
                                 default = nil)
  if valid_598128 != nil:
    section.add "source", valid_598128
  var valid_598129 = query.getOrDefault("key")
  valid_598129 = validateParameter(valid_598129, JString, required = false,
                                 default = nil)
  if valid_598129 != nil:
    section.add "key", valid_598129
  var valid_598130 = query.getOrDefault("prettyPrint")
  valid_598130 = validateParameter(valid_598130, JBool, required = false,
                                 default = newJBool(true))
  if valid_598130 != nil:
    section.add "prettyPrint", valid_598130
  var valid_598131 = query.getOrDefault("features")
  valid_598131 = validateParameter(valid_598131, JArray, required = false,
                                 default = nil)
  if valid_598131 != nil:
    section.add "features", valid_598131
  var valid_598132 = query.getOrDefault("showPreorders")
  valid_598132 = validateParameter(valid_598132, JBool, required = false, default = nil)
  if valid_598132 != nil:
    section.add "showPreorders", valid_598132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598133: Call_BooksMyconfigSyncVolumeLicenses_598115;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Request downloaded content access for specified volumes on the My eBooks shelf.
  ## 
  let valid = call_598133.validator(path, query, header, formData, body)
  let scheme = call_598133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598133.url(scheme.get, call_598133.host, call_598133.base,
                         call_598133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598133, url, valid)

proc call*(call_598134: Call_BooksMyconfigSyncVolumeLicenses_598115;
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
  var query_598135 = newJObject()
  add(query_598135, "locale", newJString(locale))
  add(query_598135, "fields", newJString(fields))
  add(query_598135, "quotaUser", newJString(quotaUser))
  add(query_598135, "alt", newJString(alt))
  add(query_598135, "oauth_token", newJString(oauthToken))
  add(query_598135, "cpksver", newJString(cpksver))
  add(query_598135, "includeNonComicsSeries", newJBool(includeNonComicsSeries))
  add(query_598135, "userIp", newJString(userIp))
  add(query_598135, "nonce", newJString(nonce))
  if volumeIds != nil:
    query_598135.add "volumeIds", volumeIds
  add(query_598135, "source", newJString(source))
  add(query_598135, "key", newJString(key))
  add(query_598135, "prettyPrint", newJBool(prettyPrint))
  if features != nil:
    query_598135.add "features", features
  add(query_598135, "showPreorders", newJBool(showPreorders))
  result = call_598134.call(nil, query_598135, nil, nil, nil)

var booksMyconfigSyncVolumeLicenses* = Call_BooksMyconfigSyncVolumeLicenses_598115(
    name: "booksMyconfigSyncVolumeLicenses", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/myconfig/syncVolumeLicenses",
    validator: validate_BooksMyconfigSyncVolumeLicenses_598116, base: "/books/v1",
    url: url_BooksMyconfigSyncVolumeLicenses_598117, schemes: {Scheme.Https})
type
  Call_BooksMyconfigUpdateUserSettings_598136 = ref object of OpenApiRestCall_597437
proc url_BooksMyconfigUpdateUserSettings_598138(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BooksMyconfigUpdateUserSettings_598137(path: JsonNode;
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
  var valid_598139 = query.getOrDefault("fields")
  valid_598139 = validateParameter(valid_598139, JString, required = false,
                                 default = nil)
  if valid_598139 != nil:
    section.add "fields", valid_598139
  var valid_598140 = query.getOrDefault("quotaUser")
  valid_598140 = validateParameter(valid_598140, JString, required = false,
                                 default = nil)
  if valid_598140 != nil:
    section.add "quotaUser", valid_598140
  var valid_598141 = query.getOrDefault("alt")
  valid_598141 = validateParameter(valid_598141, JString, required = false,
                                 default = newJString("json"))
  if valid_598141 != nil:
    section.add "alt", valid_598141
  var valid_598142 = query.getOrDefault("oauth_token")
  valid_598142 = validateParameter(valid_598142, JString, required = false,
                                 default = nil)
  if valid_598142 != nil:
    section.add "oauth_token", valid_598142
  var valid_598143 = query.getOrDefault("userIp")
  valid_598143 = validateParameter(valid_598143, JString, required = false,
                                 default = nil)
  if valid_598143 != nil:
    section.add "userIp", valid_598143
  var valid_598144 = query.getOrDefault("key")
  valid_598144 = validateParameter(valid_598144, JString, required = false,
                                 default = nil)
  if valid_598144 != nil:
    section.add "key", valid_598144
  var valid_598145 = query.getOrDefault("prettyPrint")
  valid_598145 = validateParameter(valid_598145, JBool, required = false,
                                 default = newJBool(true))
  if valid_598145 != nil:
    section.add "prettyPrint", valid_598145
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

proc call*(call_598147: Call_BooksMyconfigUpdateUserSettings_598136;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the settings for the user. If a sub-object is specified, it will overwrite the existing sub-object stored in the server. Unspecified sub-objects will retain the existing value.
  ## 
  let valid = call_598147.validator(path, query, header, formData, body)
  let scheme = call_598147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598147.url(scheme.get, call_598147.host, call_598147.base,
                         call_598147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598147, url, valid)

proc call*(call_598148: Call_BooksMyconfigUpdateUserSettings_598136;
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
  var query_598149 = newJObject()
  var body_598150 = newJObject()
  add(query_598149, "fields", newJString(fields))
  add(query_598149, "quotaUser", newJString(quotaUser))
  add(query_598149, "alt", newJString(alt))
  add(query_598149, "oauth_token", newJString(oauthToken))
  add(query_598149, "userIp", newJString(userIp))
  add(query_598149, "key", newJString(key))
  if body != nil:
    body_598150 = body
  add(query_598149, "prettyPrint", newJBool(prettyPrint))
  result = call_598148.call(nil, query_598149, nil, nil, body_598150)

var booksMyconfigUpdateUserSettings* = Call_BooksMyconfigUpdateUserSettings_598136(
    name: "booksMyconfigUpdateUserSettings", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/myconfig/updateUserSettings",
    validator: validate_BooksMyconfigUpdateUserSettings_598137, base: "/books/v1",
    url: url_BooksMyconfigUpdateUserSettings_598138, schemes: {Scheme.Https})
type
  Call_BooksMylibraryAnnotationsInsert_598174 = ref object of OpenApiRestCall_597437
proc url_BooksMylibraryAnnotationsInsert_598176(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BooksMylibraryAnnotationsInsert_598175(path: JsonNode;
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
  var valid_598177 = query.getOrDefault("fields")
  valid_598177 = validateParameter(valid_598177, JString, required = false,
                                 default = nil)
  if valid_598177 != nil:
    section.add "fields", valid_598177
  var valid_598178 = query.getOrDefault("country")
  valid_598178 = validateParameter(valid_598178, JString, required = false,
                                 default = nil)
  if valid_598178 != nil:
    section.add "country", valid_598178
  var valid_598179 = query.getOrDefault("quotaUser")
  valid_598179 = validateParameter(valid_598179, JString, required = false,
                                 default = nil)
  if valid_598179 != nil:
    section.add "quotaUser", valid_598179
  var valid_598180 = query.getOrDefault("alt")
  valid_598180 = validateParameter(valid_598180, JString, required = false,
                                 default = newJString("json"))
  if valid_598180 != nil:
    section.add "alt", valid_598180
  var valid_598181 = query.getOrDefault("showOnlySummaryInResponse")
  valid_598181 = validateParameter(valid_598181, JBool, required = false, default = nil)
  if valid_598181 != nil:
    section.add "showOnlySummaryInResponse", valid_598181
  var valid_598182 = query.getOrDefault("annotationId")
  valid_598182 = validateParameter(valid_598182, JString, required = false,
                                 default = nil)
  if valid_598182 != nil:
    section.add "annotationId", valid_598182
  var valid_598183 = query.getOrDefault("oauth_token")
  valid_598183 = validateParameter(valid_598183, JString, required = false,
                                 default = nil)
  if valid_598183 != nil:
    section.add "oauth_token", valid_598183
  var valid_598184 = query.getOrDefault("userIp")
  valid_598184 = validateParameter(valid_598184, JString, required = false,
                                 default = nil)
  if valid_598184 != nil:
    section.add "userIp", valid_598184
  var valid_598185 = query.getOrDefault("source")
  valid_598185 = validateParameter(valid_598185, JString, required = false,
                                 default = nil)
  if valid_598185 != nil:
    section.add "source", valid_598185
  var valid_598186 = query.getOrDefault("key")
  valid_598186 = validateParameter(valid_598186, JString, required = false,
                                 default = nil)
  if valid_598186 != nil:
    section.add "key", valid_598186
  var valid_598187 = query.getOrDefault("prettyPrint")
  valid_598187 = validateParameter(valid_598187, JBool, required = false,
                                 default = newJBool(true))
  if valid_598187 != nil:
    section.add "prettyPrint", valid_598187
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

proc call*(call_598189: Call_BooksMylibraryAnnotationsInsert_598174;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a new annotation.
  ## 
  let valid = call_598189.validator(path, query, header, formData, body)
  let scheme = call_598189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598189.url(scheme.get, call_598189.host, call_598189.base,
                         call_598189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598189, url, valid)

proc call*(call_598190: Call_BooksMylibraryAnnotationsInsert_598174;
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
  var query_598191 = newJObject()
  var body_598192 = newJObject()
  add(query_598191, "fields", newJString(fields))
  add(query_598191, "country", newJString(country))
  add(query_598191, "quotaUser", newJString(quotaUser))
  add(query_598191, "alt", newJString(alt))
  add(query_598191, "showOnlySummaryInResponse",
      newJBool(showOnlySummaryInResponse))
  add(query_598191, "annotationId", newJString(annotationId))
  add(query_598191, "oauth_token", newJString(oauthToken))
  add(query_598191, "userIp", newJString(userIp))
  add(query_598191, "source", newJString(source))
  add(query_598191, "key", newJString(key))
  if body != nil:
    body_598192 = body
  add(query_598191, "prettyPrint", newJBool(prettyPrint))
  result = call_598190.call(nil, query_598191, nil, nil, body_598192)

var booksMylibraryAnnotationsInsert* = Call_BooksMylibraryAnnotationsInsert_598174(
    name: "booksMylibraryAnnotationsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/mylibrary/annotations",
    validator: validate_BooksMylibraryAnnotationsInsert_598175, base: "/books/v1",
    url: url_BooksMylibraryAnnotationsInsert_598176, schemes: {Scheme.Https})
type
  Call_BooksMylibraryAnnotationsList_598151 = ref object of OpenApiRestCall_597437
proc url_BooksMylibraryAnnotationsList_598153(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BooksMylibraryAnnotationsList_598152(path: JsonNode; query: JsonNode;
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
  var valid_598154 = query.getOrDefault("layerIds")
  valid_598154 = validateParameter(valid_598154, JArray, required = false,
                                 default = nil)
  if valid_598154 != nil:
    section.add "layerIds", valid_598154
  var valid_598155 = query.getOrDefault("fields")
  valid_598155 = validateParameter(valid_598155, JString, required = false,
                                 default = nil)
  if valid_598155 != nil:
    section.add "fields", valid_598155
  var valid_598156 = query.getOrDefault("pageToken")
  valid_598156 = validateParameter(valid_598156, JString, required = false,
                                 default = nil)
  if valid_598156 != nil:
    section.add "pageToken", valid_598156
  var valid_598157 = query.getOrDefault("quotaUser")
  valid_598157 = validateParameter(valid_598157, JString, required = false,
                                 default = nil)
  if valid_598157 != nil:
    section.add "quotaUser", valid_598157
  var valid_598158 = query.getOrDefault("alt")
  valid_598158 = validateParameter(valid_598158, JString, required = false,
                                 default = newJString("json"))
  if valid_598158 != nil:
    section.add "alt", valid_598158
  var valid_598159 = query.getOrDefault("updatedMax")
  valid_598159 = validateParameter(valid_598159, JString, required = false,
                                 default = nil)
  if valid_598159 != nil:
    section.add "updatedMax", valid_598159
  var valid_598160 = query.getOrDefault("oauth_token")
  valid_598160 = validateParameter(valid_598160, JString, required = false,
                                 default = nil)
  if valid_598160 != nil:
    section.add "oauth_token", valid_598160
  var valid_598161 = query.getOrDefault("userIp")
  valid_598161 = validateParameter(valid_598161, JString, required = false,
                                 default = nil)
  if valid_598161 != nil:
    section.add "userIp", valid_598161
  var valid_598162 = query.getOrDefault("layerId")
  valid_598162 = validateParameter(valid_598162, JString, required = false,
                                 default = nil)
  if valid_598162 != nil:
    section.add "layerId", valid_598162
  var valid_598163 = query.getOrDefault("maxResults")
  valid_598163 = validateParameter(valid_598163, JInt, required = false, default = nil)
  if valid_598163 != nil:
    section.add "maxResults", valid_598163
  var valid_598164 = query.getOrDefault("contentVersion")
  valid_598164 = validateParameter(valid_598164, JString, required = false,
                                 default = nil)
  if valid_598164 != nil:
    section.add "contentVersion", valid_598164
  var valid_598165 = query.getOrDefault("showDeleted")
  valid_598165 = validateParameter(valid_598165, JBool, required = false, default = nil)
  if valid_598165 != nil:
    section.add "showDeleted", valid_598165
  var valid_598166 = query.getOrDefault("source")
  valid_598166 = validateParameter(valid_598166, JString, required = false,
                                 default = nil)
  if valid_598166 != nil:
    section.add "source", valid_598166
  var valid_598167 = query.getOrDefault("updatedMin")
  valid_598167 = validateParameter(valid_598167, JString, required = false,
                                 default = nil)
  if valid_598167 != nil:
    section.add "updatedMin", valid_598167
  var valid_598168 = query.getOrDefault("key")
  valid_598168 = validateParameter(valid_598168, JString, required = false,
                                 default = nil)
  if valid_598168 != nil:
    section.add "key", valid_598168
  var valid_598169 = query.getOrDefault("volumeId")
  valid_598169 = validateParameter(valid_598169, JString, required = false,
                                 default = nil)
  if valid_598169 != nil:
    section.add "volumeId", valid_598169
  var valid_598170 = query.getOrDefault("prettyPrint")
  valid_598170 = validateParameter(valid_598170, JBool, required = false,
                                 default = newJBool(true))
  if valid_598170 != nil:
    section.add "prettyPrint", valid_598170
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598171: Call_BooksMylibraryAnnotationsList_598151; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of annotations, possibly filtered.
  ## 
  let valid = call_598171.validator(path, query, header, formData, body)
  let scheme = call_598171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598171.url(scheme.get, call_598171.host, call_598171.base,
                         call_598171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598171, url, valid)

proc call*(call_598172: Call_BooksMylibraryAnnotationsList_598151;
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
  var query_598173 = newJObject()
  if layerIds != nil:
    query_598173.add "layerIds", layerIds
  add(query_598173, "fields", newJString(fields))
  add(query_598173, "pageToken", newJString(pageToken))
  add(query_598173, "quotaUser", newJString(quotaUser))
  add(query_598173, "alt", newJString(alt))
  add(query_598173, "updatedMax", newJString(updatedMax))
  add(query_598173, "oauth_token", newJString(oauthToken))
  add(query_598173, "userIp", newJString(userIp))
  add(query_598173, "layerId", newJString(layerId))
  add(query_598173, "maxResults", newJInt(maxResults))
  add(query_598173, "contentVersion", newJString(contentVersion))
  add(query_598173, "showDeleted", newJBool(showDeleted))
  add(query_598173, "source", newJString(source))
  add(query_598173, "updatedMin", newJString(updatedMin))
  add(query_598173, "key", newJString(key))
  add(query_598173, "volumeId", newJString(volumeId))
  add(query_598173, "prettyPrint", newJBool(prettyPrint))
  result = call_598172.call(nil, query_598173, nil, nil, nil)

var booksMylibraryAnnotationsList* = Call_BooksMylibraryAnnotationsList_598151(
    name: "booksMylibraryAnnotationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/mylibrary/annotations",
    validator: validate_BooksMylibraryAnnotationsList_598152, base: "/books/v1",
    url: url_BooksMylibraryAnnotationsList_598153, schemes: {Scheme.Https})
type
  Call_BooksMylibraryAnnotationsSummary_598193 = ref object of OpenApiRestCall_597437
proc url_BooksMylibraryAnnotationsSummary_598195(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BooksMylibraryAnnotationsSummary_598194(path: JsonNode;
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
  var valid_598196 = query.getOrDefault("layerIds")
  valid_598196 = validateParameter(valid_598196, JArray, required = true, default = nil)
  if valid_598196 != nil:
    section.add "layerIds", valid_598196
  var valid_598197 = query.getOrDefault("fields")
  valid_598197 = validateParameter(valid_598197, JString, required = false,
                                 default = nil)
  if valid_598197 != nil:
    section.add "fields", valid_598197
  var valid_598198 = query.getOrDefault("quotaUser")
  valid_598198 = validateParameter(valid_598198, JString, required = false,
                                 default = nil)
  if valid_598198 != nil:
    section.add "quotaUser", valid_598198
  var valid_598199 = query.getOrDefault("alt")
  valid_598199 = validateParameter(valid_598199, JString, required = false,
                                 default = newJString("json"))
  if valid_598199 != nil:
    section.add "alt", valid_598199
  var valid_598200 = query.getOrDefault("oauth_token")
  valid_598200 = validateParameter(valid_598200, JString, required = false,
                                 default = nil)
  if valid_598200 != nil:
    section.add "oauth_token", valid_598200
  var valid_598201 = query.getOrDefault("userIp")
  valid_598201 = validateParameter(valid_598201, JString, required = false,
                                 default = nil)
  if valid_598201 != nil:
    section.add "userIp", valid_598201
  var valid_598202 = query.getOrDefault("key")
  valid_598202 = validateParameter(valid_598202, JString, required = false,
                                 default = nil)
  if valid_598202 != nil:
    section.add "key", valid_598202
  var valid_598203 = query.getOrDefault("volumeId")
  valid_598203 = validateParameter(valid_598203, JString, required = true,
                                 default = nil)
  if valid_598203 != nil:
    section.add "volumeId", valid_598203
  var valid_598204 = query.getOrDefault("prettyPrint")
  valid_598204 = validateParameter(valid_598204, JBool, required = false,
                                 default = newJBool(true))
  if valid_598204 != nil:
    section.add "prettyPrint", valid_598204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598205: Call_BooksMylibraryAnnotationsSummary_598193;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the summary of specified layers.
  ## 
  let valid = call_598205.validator(path, query, header, formData, body)
  let scheme = call_598205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598205.url(scheme.get, call_598205.host, call_598205.base,
                         call_598205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598205, url, valid)

proc call*(call_598206: Call_BooksMylibraryAnnotationsSummary_598193;
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
  var query_598207 = newJObject()
  if layerIds != nil:
    query_598207.add "layerIds", layerIds
  add(query_598207, "fields", newJString(fields))
  add(query_598207, "quotaUser", newJString(quotaUser))
  add(query_598207, "alt", newJString(alt))
  add(query_598207, "oauth_token", newJString(oauthToken))
  add(query_598207, "userIp", newJString(userIp))
  add(query_598207, "key", newJString(key))
  add(query_598207, "volumeId", newJString(volumeId))
  add(query_598207, "prettyPrint", newJBool(prettyPrint))
  result = call_598206.call(nil, query_598207, nil, nil, nil)

var booksMylibraryAnnotationsSummary* = Call_BooksMylibraryAnnotationsSummary_598193(
    name: "booksMylibraryAnnotationsSummary", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/mylibrary/annotations/summary",
    validator: validate_BooksMylibraryAnnotationsSummary_598194,
    base: "/books/v1", url: url_BooksMylibraryAnnotationsSummary_598195,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryAnnotationsUpdate_598208 = ref object of OpenApiRestCall_597437
proc url_BooksMylibraryAnnotationsUpdate_598210(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "annotationId" in path, "`annotationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/mylibrary/annotations/"),
               (kind: VariableSegment, value: "annotationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BooksMylibraryAnnotationsUpdate_598209(path: JsonNode;
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
  var valid_598225 = path.getOrDefault("annotationId")
  valid_598225 = validateParameter(valid_598225, JString, required = true,
                                 default = nil)
  if valid_598225 != nil:
    section.add "annotationId", valid_598225
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
  var valid_598226 = query.getOrDefault("fields")
  valid_598226 = validateParameter(valid_598226, JString, required = false,
                                 default = nil)
  if valid_598226 != nil:
    section.add "fields", valid_598226
  var valid_598227 = query.getOrDefault("quotaUser")
  valid_598227 = validateParameter(valid_598227, JString, required = false,
                                 default = nil)
  if valid_598227 != nil:
    section.add "quotaUser", valid_598227
  var valid_598228 = query.getOrDefault("alt")
  valid_598228 = validateParameter(valid_598228, JString, required = false,
                                 default = newJString("json"))
  if valid_598228 != nil:
    section.add "alt", valid_598228
  var valid_598229 = query.getOrDefault("oauth_token")
  valid_598229 = validateParameter(valid_598229, JString, required = false,
                                 default = nil)
  if valid_598229 != nil:
    section.add "oauth_token", valid_598229
  var valid_598230 = query.getOrDefault("userIp")
  valid_598230 = validateParameter(valid_598230, JString, required = false,
                                 default = nil)
  if valid_598230 != nil:
    section.add "userIp", valid_598230
  var valid_598231 = query.getOrDefault("source")
  valid_598231 = validateParameter(valid_598231, JString, required = false,
                                 default = nil)
  if valid_598231 != nil:
    section.add "source", valid_598231
  var valid_598232 = query.getOrDefault("key")
  valid_598232 = validateParameter(valid_598232, JString, required = false,
                                 default = nil)
  if valid_598232 != nil:
    section.add "key", valid_598232
  var valid_598233 = query.getOrDefault("prettyPrint")
  valid_598233 = validateParameter(valid_598233, JBool, required = false,
                                 default = newJBool(true))
  if valid_598233 != nil:
    section.add "prettyPrint", valid_598233
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

proc call*(call_598235: Call_BooksMylibraryAnnotationsUpdate_598208;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing annotation.
  ## 
  let valid = call_598235.validator(path, query, header, formData, body)
  let scheme = call_598235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598235.url(scheme.get, call_598235.host, call_598235.base,
                         call_598235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598235, url, valid)

proc call*(call_598236: Call_BooksMylibraryAnnotationsUpdate_598208;
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
  var path_598237 = newJObject()
  var query_598238 = newJObject()
  var body_598239 = newJObject()
  add(query_598238, "fields", newJString(fields))
  add(query_598238, "quotaUser", newJString(quotaUser))
  add(query_598238, "alt", newJString(alt))
  add(query_598238, "oauth_token", newJString(oauthToken))
  add(path_598237, "annotationId", newJString(annotationId))
  add(query_598238, "userIp", newJString(userIp))
  add(query_598238, "source", newJString(source))
  add(query_598238, "key", newJString(key))
  if body != nil:
    body_598239 = body
  add(query_598238, "prettyPrint", newJBool(prettyPrint))
  result = call_598236.call(path_598237, query_598238, nil, nil, body_598239)

var booksMylibraryAnnotationsUpdate* = Call_BooksMylibraryAnnotationsUpdate_598208(
    name: "booksMylibraryAnnotationsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/mylibrary/annotations/{annotationId}",
    validator: validate_BooksMylibraryAnnotationsUpdate_598209, base: "/books/v1",
    url: url_BooksMylibraryAnnotationsUpdate_598210, schemes: {Scheme.Https})
type
  Call_BooksMylibraryAnnotationsDelete_598240 = ref object of OpenApiRestCall_597437
proc url_BooksMylibraryAnnotationsDelete_598242(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "annotationId" in path, "`annotationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/mylibrary/annotations/"),
               (kind: VariableSegment, value: "annotationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BooksMylibraryAnnotationsDelete_598241(path: JsonNode;
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
  var valid_598243 = path.getOrDefault("annotationId")
  valid_598243 = validateParameter(valid_598243, JString, required = true,
                                 default = nil)
  if valid_598243 != nil:
    section.add "annotationId", valid_598243
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
  var valid_598244 = query.getOrDefault("fields")
  valid_598244 = validateParameter(valid_598244, JString, required = false,
                                 default = nil)
  if valid_598244 != nil:
    section.add "fields", valid_598244
  var valid_598245 = query.getOrDefault("quotaUser")
  valid_598245 = validateParameter(valid_598245, JString, required = false,
                                 default = nil)
  if valid_598245 != nil:
    section.add "quotaUser", valid_598245
  var valid_598246 = query.getOrDefault("alt")
  valid_598246 = validateParameter(valid_598246, JString, required = false,
                                 default = newJString("json"))
  if valid_598246 != nil:
    section.add "alt", valid_598246
  var valid_598247 = query.getOrDefault("oauth_token")
  valid_598247 = validateParameter(valid_598247, JString, required = false,
                                 default = nil)
  if valid_598247 != nil:
    section.add "oauth_token", valid_598247
  var valid_598248 = query.getOrDefault("userIp")
  valid_598248 = validateParameter(valid_598248, JString, required = false,
                                 default = nil)
  if valid_598248 != nil:
    section.add "userIp", valid_598248
  var valid_598249 = query.getOrDefault("source")
  valid_598249 = validateParameter(valid_598249, JString, required = false,
                                 default = nil)
  if valid_598249 != nil:
    section.add "source", valid_598249
  var valid_598250 = query.getOrDefault("key")
  valid_598250 = validateParameter(valid_598250, JString, required = false,
                                 default = nil)
  if valid_598250 != nil:
    section.add "key", valid_598250
  var valid_598251 = query.getOrDefault("prettyPrint")
  valid_598251 = validateParameter(valid_598251, JBool, required = false,
                                 default = newJBool(true))
  if valid_598251 != nil:
    section.add "prettyPrint", valid_598251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598252: Call_BooksMylibraryAnnotationsDelete_598240;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an annotation.
  ## 
  let valid = call_598252.validator(path, query, header, formData, body)
  let scheme = call_598252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598252.url(scheme.get, call_598252.host, call_598252.base,
                         call_598252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598252, url, valid)

proc call*(call_598253: Call_BooksMylibraryAnnotationsDelete_598240;
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
  var path_598254 = newJObject()
  var query_598255 = newJObject()
  add(query_598255, "fields", newJString(fields))
  add(query_598255, "quotaUser", newJString(quotaUser))
  add(query_598255, "alt", newJString(alt))
  add(query_598255, "oauth_token", newJString(oauthToken))
  add(path_598254, "annotationId", newJString(annotationId))
  add(query_598255, "userIp", newJString(userIp))
  add(query_598255, "source", newJString(source))
  add(query_598255, "key", newJString(key))
  add(query_598255, "prettyPrint", newJBool(prettyPrint))
  result = call_598253.call(path_598254, query_598255, nil, nil, nil)

var booksMylibraryAnnotationsDelete* = Call_BooksMylibraryAnnotationsDelete_598240(
    name: "booksMylibraryAnnotationsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/mylibrary/annotations/{annotationId}",
    validator: validate_BooksMylibraryAnnotationsDelete_598241, base: "/books/v1",
    url: url_BooksMylibraryAnnotationsDelete_598242, schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesList_598256 = ref object of OpenApiRestCall_597437
proc url_BooksMylibraryBookshelvesList_598258(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BooksMylibraryBookshelvesList_598257(path: JsonNode; query: JsonNode;
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
  var valid_598259 = query.getOrDefault("fields")
  valid_598259 = validateParameter(valid_598259, JString, required = false,
                                 default = nil)
  if valid_598259 != nil:
    section.add "fields", valid_598259
  var valid_598260 = query.getOrDefault("quotaUser")
  valid_598260 = validateParameter(valid_598260, JString, required = false,
                                 default = nil)
  if valid_598260 != nil:
    section.add "quotaUser", valid_598260
  var valid_598261 = query.getOrDefault("alt")
  valid_598261 = validateParameter(valid_598261, JString, required = false,
                                 default = newJString("json"))
  if valid_598261 != nil:
    section.add "alt", valid_598261
  var valid_598262 = query.getOrDefault("oauth_token")
  valid_598262 = validateParameter(valid_598262, JString, required = false,
                                 default = nil)
  if valid_598262 != nil:
    section.add "oauth_token", valid_598262
  var valid_598263 = query.getOrDefault("userIp")
  valid_598263 = validateParameter(valid_598263, JString, required = false,
                                 default = nil)
  if valid_598263 != nil:
    section.add "userIp", valid_598263
  var valid_598264 = query.getOrDefault("source")
  valid_598264 = validateParameter(valid_598264, JString, required = false,
                                 default = nil)
  if valid_598264 != nil:
    section.add "source", valid_598264
  var valid_598265 = query.getOrDefault("key")
  valid_598265 = validateParameter(valid_598265, JString, required = false,
                                 default = nil)
  if valid_598265 != nil:
    section.add "key", valid_598265
  var valid_598266 = query.getOrDefault("prettyPrint")
  valid_598266 = validateParameter(valid_598266, JBool, required = false,
                                 default = newJBool(true))
  if valid_598266 != nil:
    section.add "prettyPrint", valid_598266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598267: Call_BooksMylibraryBookshelvesList_598256; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of bookshelves belonging to the authenticated user.
  ## 
  let valid = call_598267.validator(path, query, header, formData, body)
  let scheme = call_598267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598267.url(scheme.get, call_598267.host, call_598267.base,
                         call_598267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598267, url, valid)

proc call*(call_598268: Call_BooksMylibraryBookshelvesList_598256;
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
  var query_598269 = newJObject()
  add(query_598269, "fields", newJString(fields))
  add(query_598269, "quotaUser", newJString(quotaUser))
  add(query_598269, "alt", newJString(alt))
  add(query_598269, "oauth_token", newJString(oauthToken))
  add(query_598269, "userIp", newJString(userIp))
  add(query_598269, "source", newJString(source))
  add(query_598269, "key", newJString(key))
  add(query_598269, "prettyPrint", newJBool(prettyPrint))
  result = call_598268.call(nil, query_598269, nil, nil, nil)

var booksMylibraryBookshelvesList* = Call_BooksMylibraryBookshelvesList_598256(
    name: "booksMylibraryBookshelvesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/mylibrary/bookshelves",
    validator: validate_BooksMylibraryBookshelvesList_598257, base: "/books/v1",
    url: url_BooksMylibraryBookshelvesList_598258, schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesGet_598270 = ref object of OpenApiRestCall_597437
proc url_BooksMylibraryBookshelvesGet_598272(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "shelf" in path, "`shelf` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/mylibrary/bookshelves/"),
               (kind: VariableSegment, value: "shelf")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BooksMylibraryBookshelvesGet_598271(path: JsonNode; query: JsonNode;
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
  var valid_598273 = path.getOrDefault("shelf")
  valid_598273 = validateParameter(valid_598273, JString, required = true,
                                 default = nil)
  if valid_598273 != nil:
    section.add "shelf", valid_598273
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
  var valid_598274 = query.getOrDefault("fields")
  valid_598274 = validateParameter(valid_598274, JString, required = false,
                                 default = nil)
  if valid_598274 != nil:
    section.add "fields", valid_598274
  var valid_598275 = query.getOrDefault("quotaUser")
  valid_598275 = validateParameter(valid_598275, JString, required = false,
                                 default = nil)
  if valid_598275 != nil:
    section.add "quotaUser", valid_598275
  var valid_598276 = query.getOrDefault("alt")
  valid_598276 = validateParameter(valid_598276, JString, required = false,
                                 default = newJString("json"))
  if valid_598276 != nil:
    section.add "alt", valid_598276
  var valid_598277 = query.getOrDefault("oauth_token")
  valid_598277 = validateParameter(valid_598277, JString, required = false,
                                 default = nil)
  if valid_598277 != nil:
    section.add "oauth_token", valid_598277
  var valid_598278 = query.getOrDefault("userIp")
  valid_598278 = validateParameter(valid_598278, JString, required = false,
                                 default = nil)
  if valid_598278 != nil:
    section.add "userIp", valid_598278
  var valid_598279 = query.getOrDefault("source")
  valid_598279 = validateParameter(valid_598279, JString, required = false,
                                 default = nil)
  if valid_598279 != nil:
    section.add "source", valid_598279
  var valid_598280 = query.getOrDefault("key")
  valid_598280 = validateParameter(valid_598280, JString, required = false,
                                 default = nil)
  if valid_598280 != nil:
    section.add "key", valid_598280
  var valid_598281 = query.getOrDefault("prettyPrint")
  valid_598281 = validateParameter(valid_598281, JBool, required = false,
                                 default = newJBool(true))
  if valid_598281 != nil:
    section.add "prettyPrint", valid_598281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598282: Call_BooksMylibraryBookshelvesGet_598270; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves metadata for a specific bookshelf belonging to the authenticated user.
  ## 
  let valid = call_598282.validator(path, query, header, formData, body)
  let scheme = call_598282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598282.url(scheme.get, call_598282.host, call_598282.base,
                         call_598282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598282, url, valid)

proc call*(call_598283: Call_BooksMylibraryBookshelvesGet_598270; shelf: string;
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
  var path_598284 = newJObject()
  var query_598285 = newJObject()
  add(query_598285, "fields", newJString(fields))
  add(query_598285, "quotaUser", newJString(quotaUser))
  add(query_598285, "alt", newJString(alt))
  add(query_598285, "oauth_token", newJString(oauthToken))
  add(query_598285, "userIp", newJString(userIp))
  add(path_598284, "shelf", newJString(shelf))
  add(query_598285, "source", newJString(source))
  add(query_598285, "key", newJString(key))
  add(query_598285, "prettyPrint", newJBool(prettyPrint))
  result = call_598283.call(path_598284, query_598285, nil, nil, nil)

var booksMylibraryBookshelvesGet* = Call_BooksMylibraryBookshelvesGet_598270(
    name: "booksMylibraryBookshelvesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/mylibrary/bookshelves/{shelf}",
    validator: validate_BooksMylibraryBookshelvesGet_598271, base: "/books/v1",
    url: url_BooksMylibraryBookshelvesGet_598272, schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesAddVolume_598286 = ref object of OpenApiRestCall_597437
proc url_BooksMylibraryBookshelvesAddVolume_598288(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BooksMylibraryBookshelvesAddVolume_598287(path: JsonNode;
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
  var valid_598289 = path.getOrDefault("shelf")
  valid_598289 = validateParameter(valid_598289, JString, required = true,
                                 default = nil)
  if valid_598289 != nil:
    section.add "shelf", valid_598289
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
  var valid_598290 = query.getOrDefault("fields")
  valid_598290 = validateParameter(valid_598290, JString, required = false,
                                 default = nil)
  if valid_598290 != nil:
    section.add "fields", valid_598290
  var valid_598291 = query.getOrDefault("quotaUser")
  valid_598291 = validateParameter(valid_598291, JString, required = false,
                                 default = nil)
  if valid_598291 != nil:
    section.add "quotaUser", valid_598291
  var valid_598292 = query.getOrDefault("alt")
  valid_598292 = validateParameter(valid_598292, JString, required = false,
                                 default = newJString("json"))
  if valid_598292 != nil:
    section.add "alt", valid_598292
  var valid_598293 = query.getOrDefault("oauth_token")
  valid_598293 = validateParameter(valid_598293, JString, required = false,
                                 default = nil)
  if valid_598293 != nil:
    section.add "oauth_token", valid_598293
  var valid_598294 = query.getOrDefault("userIp")
  valid_598294 = validateParameter(valid_598294, JString, required = false,
                                 default = nil)
  if valid_598294 != nil:
    section.add "userIp", valid_598294
  var valid_598295 = query.getOrDefault("source")
  valid_598295 = validateParameter(valid_598295, JString, required = false,
                                 default = nil)
  if valid_598295 != nil:
    section.add "source", valid_598295
  var valid_598296 = query.getOrDefault("key")
  valid_598296 = validateParameter(valid_598296, JString, required = false,
                                 default = nil)
  if valid_598296 != nil:
    section.add "key", valid_598296
  assert query != nil,
        "query argument is necessary due to required `volumeId` field"
  var valid_598297 = query.getOrDefault("volumeId")
  valid_598297 = validateParameter(valid_598297, JString, required = true,
                                 default = nil)
  if valid_598297 != nil:
    section.add "volumeId", valid_598297
  var valid_598298 = query.getOrDefault("prettyPrint")
  valid_598298 = validateParameter(valid_598298, JBool, required = false,
                                 default = newJBool(true))
  if valid_598298 != nil:
    section.add "prettyPrint", valid_598298
  var valid_598299 = query.getOrDefault("reason")
  valid_598299 = validateParameter(valid_598299, JString, required = false,
                                 default = newJString("IOS_PREX"))
  if valid_598299 != nil:
    section.add "reason", valid_598299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598300: Call_BooksMylibraryBookshelvesAddVolume_598286;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a volume to a bookshelf.
  ## 
  let valid = call_598300.validator(path, query, header, formData, body)
  let scheme = call_598300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598300.url(scheme.get, call_598300.host, call_598300.base,
                         call_598300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598300, url, valid)

proc call*(call_598301: Call_BooksMylibraryBookshelvesAddVolume_598286;
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
  var path_598302 = newJObject()
  var query_598303 = newJObject()
  add(query_598303, "fields", newJString(fields))
  add(query_598303, "quotaUser", newJString(quotaUser))
  add(query_598303, "alt", newJString(alt))
  add(query_598303, "oauth_token", newJString(oauthToken))
  add(query_598303, "userIp", newJString(userIp))
  add(path_598302, "shelf", newJString(shelf))
  add(query_598303, "source", newJString(source))
  add(query_598303, "key", newJString(key))
  add(query_598303, "volumeId", newJString(volumeId))
  add(query_598303, "prettyPrint", newJBool(prettyPrint))
  add(query_598303, "reason", newJString(reason))
  result = call_598301.call(path_598302, query_598303, nil, nil, nil)

var booksMylibraryBookshelvesAddVolume* = Call_BooksMylibraryBookshelvesAddVolume_598286(
    name: "booksMylibraryBookshelvesAddVolume", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/mylibrary/bookshelves/{shelf}/addVolume",
    validator: validate_BooksMylibraryBookshelvesAddVolume_598287,
    base: "/books/v1", url: url_BooksMylibraryBookshelvesAddVolume_598288,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesClearVolumes_598304 = ref object of OpenApiRestCall_597437
proc url_BooksMylibraryBookshelvesClearVolumes_598306(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BooksMylibraryBookshelvesClearVolumes_598305(path: JsonNode;
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
  var valid_598307 = path.getOrDefault("shelf")
  valid_598307 = validateParameter(valid_598307, JString, required = true,
                                 default = nil)
  if valid_598307 != nil:
    section.add "shelf", valid_598307
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
  var valid_598308 = query.getOrDefault("fields")
  valid_598308 = validateParameter(valid_598308, JString, required = false,
                                 default = nil)
  if valid_598308 != nil:
    section.add "fields", valid_598308
  var valid_598309 = query.getOrDefault("quotaUser")
  valid_598309 = validateParameter(valid_598309, JString, required = false,
                                 default = nil)
  if valid_598309 != nil:
    section.add "quotaUser", valid_598309
  var valid_598310 = query.getOrDefault("alt")
  valid_598310 = validateParameter(valid_598310, JString, required = false,
                                 default = newJString("json"))
  if valid_598310 != nil:
    section.add "alt", valid_598310
  var valid_598311 = query.getOrDefault("oauth_token")
  valid_598311 = validateParameter(valid_598311, JString, required = false,
                                 default = nil)
  if valid_598311 != nil:
    section.add "oauth_token", valid_598311
  var valid_598312 = query.getOrDefault("userIp")
  valid_598312 = validateParameter(valid_598312, JString, required = false,
                                 default = nil)
  if valid_598312 != nil:
    section.add "userIp", valid_598312
  var valid_598313 = query.getOrDefault("source")
  valid_598313 = validateParameter(valid_598313, JString, required = false,
                                 default = nil)
  if valid_598313 != nil:
    section.add "source", valid_598313
  var valid_598314 = query.getOrDefault("key")
  valid_598314 = validateParameter(valid_598314, JString, required = false,
                                 default = nil)
  if valid_598314 != nil:
    section.add "key", valid_598314
  var valid_598315 = query.getOrDefault("prettyPrint")
  valid_598315 = validateParameter(valid_598315, JBool, required = false,
                                 default = newJBool(true))
  if valid_598315 != nil:
    section.add "prettyPrint", valid_598315
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598316: Call_BooksMylibraryBookshelvesClearVolumes_598304;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Clears all volumes from a bookshelf.
  ## 
  let valid = call_598316.validator(path, query, header, formData, body)
  let scheme = call_598316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598316.url(scheme.get, call_598316.host, call_598316.base,
                         call_598316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598316, url, valid)

proc call*(call_598317: Call_BooksMylibraryBookshelvesClearVolumes_598304;
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
  var path_598318 = newJObject()
  var query_598319 = newJObject()
  add(query_598319, "fields", newJString(fields))
  add(query_598319, "quotaUser", newJString(quotaUser))
  add(query_598319, "alt", newJString(alt))
  add(query_598319, "oauth_token", newJString(oauthToken))
  add(query_598319, "userIp", newJString(userIp))
  add(path_598318, "shelf", newJString(shelf))
  add(query_598319, "source", newJString(source))
  add(query_598319, "key", newJString(key))
  add(query_598319, "prettyPrint", newJBool(prettyPrint))
  result = call_598317.call(path_598318, query_598319, nil, nil, nil)

var booksMylibraryBookshelvesClearVolumes* = Call_BooksMylibraryBookshelvesClearVolumes_598304(
    name: "booksMylibraryBookshelvesClearVolumes", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/mylibrary/bookshelves/{shelf}/clearVolumes",
    validator: validate_BooksMylibraryBookshelvesClearVolumes_598305,
    base: "/books/v1", url: url_BooksMylibraryBookshelvesClearVolumes_598306,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesMoveVolume_598320 = ref object of OpenApiRestCall_597437
proc url_BooksMylibraryBookshelvesMoveVolume_598322(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BooksMylibraryBookshelvesMoveVolume_598321(path: JsonNode;
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
  var valid_598323 = path.getOrDefault("shelf")
  valid_598323 = validateParameter(valid_598323, JString, required = true,
                                 default = nil)
  if valid_598323 != nil:
    section.add "shelf", valid_598323
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
  var valid_598324 = query.getOrDefault("fields")
  valid_598324 = validateParameter(valid_598324, JString, required = false,
                                 default = nil)
  if valid_598324 != nil:
    section.add "fields", valid_598324
  var valid_598325 = query.getOrDefault("quotaUser")
  valid_598325 = validateParameter(valid_598325, JString, required = false,
                                 default = nil)
  if valid_598325 != nil:
    section.add "quotaUser", valid_598325
  var valid_598326 = query.getOrDefault("alt")
  valid_598326 = validateParameter(valid_598326, JString, required = false,
                                 default = newJString("json"))
  if valid_598326 != nil:
    section.add "alt", valid_598326
  var valid_598327 = query.getOrDefault("oauth_token")
  valid_598327 = validateParameter(valid_598327, JString, required = false,
                                 default = nil)
  if valid_598327 != nil:
    section.add "oauth_token", valid_598327
  var valid_598328 = query.getOrDefault("userIp")
  valid_598328 = validateParameter(valid_598328, JString, required = false,
                                 default = nil)
  if valid_598328 != nil:
    section.add "userIp", valid_598328
  var valid_598329 = query.getOrDefault("source")
  valid_598329 = validateParameter(valid_598329, JString, required = false,
                                 default = nil)
  if valid_598329 != nil:
    section.add "source", valid_598329
  var valid_598330 = query.getOrDefault("key")
  valid_598330 = validateParameter(valid_598330, JString, required = false,
                                 default = nil)
  if valid_598330 != nil:
    section.add "key", valid_598330
  assert query != nil,
        "query argument is necessary due to required `volumePosition` field"
  var valid_598331 = query.getOrDefault("volumePosition")
  valid_598331 = validateParameter(valid_598331, JInt, required = true, default = nil)
  if valid_598331 != nil:
    section.add "volumePosition", valid_598331
  var valid_598332 = query.getOrDefault("volumeId")
  valid_598332 = validateParameter(valid_598332, JString, required = true,
                                 default = nil)
  if valid_598332 != nil:
    section.add "volumeId", valid_598332
  var valid_598333 = query.getOrDefault("prettyPrint")
  valid_598333 = validateParameter(valid_598333, JBool, required = false,
                                 default = newJBool(true))
  if valid_598333 != nil:
    section.add "prettyPrint", valid_598333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598334: Call_BooksMylibraryBookshelvesMoveVolume_598320;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Moves a volume within a bookshelf.
  ## 
  let valid = call_598334.validator(path, query, header, formData, body)
  let scheme = call_598334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598334.url(scheme.get, call_598334.host, call_598334.base,
                         call_598334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598334, url, valid)

proc call*(call_598335: Call_BooksMylibraryBookshelvesMoveVolume_598320;
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
  var path_598336 = newJObject()
  var query_598337 = newJObject()
  add(query_598337, "fields", newJString(fields))
  add(query_598337, "quotaUser", newJString(quotaUser))
  add(query_598337, "alt", newJString(alt))
  add(query_598337, "oauth_token", newJString(oauthToken))
  add(query_598337, "userIp", newJString(userIp))
  add(path_598336, "shelf", newJString(shelf))
  add(query_598337, "source", newJString(source))
  add(query_598337, "key", newJString(key))
  add(query_598337, "volumePosition", newJInt(volumePosition))
  add(query_598337, "volumeId", newJString(volumeId))
  add(query_598337, "prettyPrint", newJBool(prettyPrint))
  result = call_598335.call(path_598336, query_598337, nil, nil, nil)

var booksMylibraryBookshelvesMoveVolume* = Call_BooksMylibraryBookshelvesMoveVolume_598320(
    name: "booksMylibraryBookshelvesMoveVolume", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/mylibrary/bookshelves/{shelf}/moveVolume",
    validator: validate_BooksMylibraryBookshelvesMoveVolume_598321,
    base: "/books/v1", url: url_BooksMylibraryBookshelvesMoveVolume_598322,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesRemoveVolume_598338 = ref object of OpenApiRestCall_597437
proc url_BooksMylibraryBookshelvesRemoveVolume_598340(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BooksMylibraryBookshelvesRemoveVolume_598339(path: JsonNode;
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
  var valid_598341 = path.getOrDefault("shelf")
  valid_598341 = validateParameter(valid_598341, JString, required = true,
                                 default = nil)
  if valid_598341 != nil:
    section.add "shelf", valid_598341
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
  var valid_598342 = query.getOrDefault("fields")
  valid_598342 = validateParameter(valid_598342, JString, required = false,
                                 default = nil)
  if valid_598342 != nil:
    section.add "fields", valid_598342
  var valid_598343 = query.getOrDefault("quotaUser")
  valid_598343 = validateParameter(valid_598343, JString, required = false,
                                 default = nil)
  if valid_598343 != nil:
    section.add "quotaUser", valid_598343
  var valid_598344 = query.getOrDefault("alt")
  valid_598344 = validateParameter(valid_598344, JString, required = false,
                                 default = newJString("json"))
  if valid_598344 != nil:
    section.add "alt", valid_598344
  var valid_598345 = query.getOrDefault("oauth_token")
  valid_598345 = validateParameter(valid_598345, JString, required = false,
                                 default = nil)
  if valid_598345 != nil:
    section.add "oauth_token", valid_598345
  var valid_598346 = query.getOrDefault("userIp")
  valid_598346 = validateParameter(valid_598346, JString, required = false,
                                 default = nil)
  if valid_598346 != nil:
    section.add "userIp", valid_598346
  var valid_598347 = query.getOrDefault("source")
  valid_598347 = validateParameter(valid_598347, JString, required = false,
                                 default = nil)
  if valid_598347 != nil:
    section.add "source", valid_598347
  var valid_598348 = query.getOrDefault("key")
  valid_598348 = validateParameter(valid_598348, JString, required = false,
                                 default = nil)
  if valid_598348 != nil:
    section.add "key", valid_598348
  assert query != nil,
        "query argument is necessary due to required `volumeId` field"
  var valid_598349 = query.getOrDefault("volumeId")
  valid_598349 = validateParameter(valid_598349, JString, required = true,
                                 default = nil)
  if valid_598349 != nil:
    section.add "volumeId", valid_598349
  var valid_598350 = query.getOrDefault("prettyPrint")
  valid_598350 = validateParameter(valid_598350, JBool, required = false,
                                 default = newJBool(true))
  if valid_598350 != nil:
    section.add "prettyPrint", valid_598350
  var valid_598351 = query.getOrDefault("reason")
  valid_598351 = validateParameter(valid_598351, JString, required = false,
                                 default = newJString("ONBOARDING"))
  if valid_598351 != nil:
    section.add "reason", valid_598351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598352: Call_BooksMylibraryBookshelvesRemoveVolume_598338;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a volume from a bookshelf.
  ## 
  let valid = call_598352.validator(path, query, header, formData, body)
  let scheme = call_598352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598352.url(scheme.get, call_598352.host, call_598352.base,
                         call_598352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598352, url, valid)

proc call*(call_598353: Call_BooksMylibraryBookshelvesRemoveVolume_598338;
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
  var path_598354 = newJObject()
  var query_598355 = newJObject()
  add(query_598355, "fields", newJString(fields))
  add(query_598355, "quotaUser", newJString(quotaUser))
  add(query_598355, "alt", newJString(alt))
  add(query_598355, "oauth_token", newJString(oauthToken))
  add(query_598355, "userIp", newJString(userIp))
  add(path_598354, "shelf", newJString(shelf))
  add(query_598355, "source", newJString(source))
  add(query_598355, "key", newJString(key))
  add(query_598355, "volumeId", newJString(volumeId))
  add(query_598355, "prettyPrint", newJBool(prettyPrint))
  add(query_598355, "reason", newJString(reason))
  result = call_598353.call(path_598354, query_598355, nil, nil, nil)

var booksMylibraryBookshelvesRemoveVolume* = Call_BooksMylibraryBookshelvesRemoveVolume_598338(
    name: "booksMylibraryBookshelvesRemoveVolume", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/mylibrary/bookshelves/{shelf}/removeVolume",
    validator: validate_BooksMylibraryBookshelvesRemoveVolume_598339,
    base: "/books/v1", url: url_BooksMylibraryBookshelvesRemoveVolume_598340,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesVolumesList_598356 = ref object of OpenApiRestCall_597437
proc url_BooksMylibraryBookshelvesVolumesList_598358(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BooksMylibraryBookshelvesVolumesList_598357(path: JsonNode;
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
  var valid_598359 = path.getOrDefault("shelf")
  valid_598359 = validateParameter(valid_598359, JString, required = true,
                                 default = nil)
  if valid_598359 != nil:
    section.add "shelf", valid_598359
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
  var valid_598360 = query.getOrDefault("fields")
  valid_598360 = validateParameter(valid_598360, JString, required = false,
                                 default = nil)
  if valid_598360 != nil:
    section.add "fields", valid_598360
  var valid_598361 = query.getOrDefault("country")
  valid_598361 = validateParameter(valid_598361, JString, required = false,
                                 default = nil)
  if valid_598361 != nil:
    section.add "country", valid_598361
  var valid_598362 = query.getOrDefault("quotaUser")
  valid_598362 = validateParameter(valid_598362, JString, required = false,
                                 default = nil)
  if valid_598362 != nil:
    section.add "quotaUser", valid_598362
  var valid_598363 = query.getOrDefault("alt")
  valid_598363 = validateParameter(valid_598363, JString, required = false,
                                 default = newJString("json"))
  if valid_598363 != nil:
    section.add "alt", valid_598363
  var valid_598364 = query.getOrDefault("oauth_token")
  valid_598364 = validateParameter(valid_598364, JString, required = false,
                                 default = nil)
  if valid_598364 != nil:
    section.add "oauth_token", valid_598364
  var valid_598365 = query.getOrDefault("userIp")
  valid_598365 = validateParameter(valid_598365, JString, required = false,
                                 default = nil)
  if valid_598365 != nil:
    section.add "userIp", valid_598365
  var valid_598366 = query.getOrDefault("maxResults")
  valid_598366 = validateParameter(valid_598366, JInt, required = false, default = nil)
  if valid_598366 != nil:
    section.add "maxResults", valid_598366
  var valid_598367 = query.getOrDefault("source")
  valid_598367 = validateParameter(valid_598367, JString, required = false,
                                 default = nil)
  if valid_598367 != nil:
    section.add "source", valid_598367
  var valid_598368 = query.getOrDefault("q")
  valid_598368 = validateParameter(valid_598368, JString, required = false,
                                 default = nil)
  if valid_598368 != nil:
    section.add "q", valid_598368
  var valid_598369 = query.getOrDefault("key")
  valid_598369 = validateParameter(valid_598369, JString, required = false,
                                 default = nil)
  if valid_598369 != nil:
    section.add "key", valid_598369
  var valid_598370 = query.getOrDefault("projection")
  valid_598370 = validateParameter(valid_598370, JString, required = false,
                                 default = newJString("full"))
  if valid_598370 != nil:
    section.add "projection", valid_598370
  var valid_598371 = query.getOrDefault("prettyPrint")
  valid_598371 = validateParameter(valid_598371, JBool, required = false,
                                 default = newJBool(true))
  if valid_598371 != nil:
    section.add "prettyPrint", valid_598371
  var valid_598372 = query.getOrDefault("showPreorders")
  valid_598372 = validateParameter(valid_598372, JBool, required = false, default = nil)
  if valid_598372 != nil:
    section.add "showPreorders", valid_598372
  var valid_598373 = query.getOrDefault("startIndex")
  valid_598373 = validateParameter(valid_598373, JInt, required = false, default = nil)
  if valid_598373 != nil:
    section.add "startIndex", valid_598373
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598374: Call_BooksMylibraryBookshelvesVolumesList_598356;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets volume information for volumes on a bookshelf.
  ## 
  let valid = call_598374.validator(path, query, header, formData, body)
  let scheme = call_598374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598374.url(scheme.get, call_598374.host, call_598374.base,
                         call_598374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598374, url, valid)

proc call*(call_598375: Call_BooksMylibraryBookshelvesVolumesList_598356;
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
  var path_598376 = newJObject()
  var query_598377 = newJObject()
  add(query_598377, "fields", newJString(fields))
  add(query_598377, "country", newJString(country))
  add(query_598377, "quotaUser", newJString(quotaUser))
  add(query_598377, "alt", newJString(alt))
  add(query_598377, "oauth_token", newJString(oauthToken))
  add(query_598377, "userIp", newJString(userIp))
  add(path_598376, "shelf", newJString(shelf))
  add(query_598377, "maxResults", newJInt(maxResults))
  add(query_598377, "source", newJString(source))
  add(query_598377, "q", newJString(q))
  add(query_598377, "key", newJString(key))
  add(query_598377, "projection", newJString(projection))
  add(query_598377, "prettyPrint", newJBool(prettyPrint))
  add(query_598377, "showPreorders", newJBool(showPreorders))
  add(query_598377, "startIndex", newJInt(startIndex))
  result = call_598375.call(path_598376, query_598377, nil, nil, nil)

var booksMylibraryBookshelvesVolumesList* = Call_BooksMylibraryBookshelvesVolumesList_598356(
    name: "booksMylibraryBookshelvesVolumesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/mylibrary/bookshelves/{shelf}/volumes",
    validator: validate_BooksMylibraryBookshelvesVolumesList_598357,
    base: "/books/v1", url: url_BooksMylibraryBookshelvesVolumesList_598358,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryReadingpositionsGet_598378 = ref object of OpenApiRestCall_597437
proc url_BooksMylibraryReadingpositionsGet_598380(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "volumeId" in path, "`volumeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/mylibrary/readingpositions/"),
               (kind: VariableSegment, value: "volumeId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BooksMylibraryReadingpositionsGet_598379(path: JsonNode;
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
  var valid_598381 = path.getOrDefault("volumeId")
  valid_598381 = validateParameter(valid_598381, JString, required = true,
                                 default = nil)
  if valid_598381 != nil:
    section.add "volumeId", valid_598381
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
  var valid_598382 = query.getOrDefault("fields")
  valid_598382 = validateParameter(valid_598382, JString, required = false,
                                 default = nil)
  if valid_598382 != nil:
    section.add "fields", valid_598382
  var valid_598383 = query.getOrDefault("quotaUser")
  valid_598383 = validateParameter(valid_598383, JString, required = false,
                                 default = nil)
  if valid_598383 != nil:
    section.add "quotaUser", valid_598383
  var valid_598384 = query.getOrDefault("alt")
  valid_598384 = validateParameter(valid_598384, JString, required = false,
                                 default = newJString("json"))
  if valid_598384 != nil:
    section.add "alt", valid_598384
  var valid_598385 = query.getOrDefault("oauth_token")
  valid_598385 = validateParameter(valid_598385, JString, required = false,
                                 default = nil)
  if valid_598385 != nil:
    section.add "oauth_token", valid_598385
  var valid_598386 = query.getOrDefault("userIp")
  valid_598386 = validateParameter(valid_598386, JString, required = false,
                                 default = nil)
  if valid_598386 != nil:
    section.add "userIp", valid_598386
  var valid_598387 = query.getOrDefault("contentVersion")
  valid_598387 = validateParameter(valid_598387, JString, required = false,
                                 default = nil)
  if valid_598387 != nil:
    section.add "contentVersion", valid_598387
  var valid_598388 = query.getOrDefault("source")
  valid_598388 = validateParameter(valid_598388, JString, required = false,
                                 default = nil)
  if valid_598388 != nil:
    section.add "source", valid_598388
  var valid_598389 = query.getOrDefault("key")
  valid_598389 = validateParameter(valid_598389, JString, required = false,
                                 default = nil)
  if valid_598389 != nil:
    section.add "key", valid_598389
  var valid_598390 = query.getOrDefault("prettyPrint")
  valid_598390 = validateParameter(valid_598390, JBool, required = false,
                                 default = newJBool(true))
  if valid_598390 != nil:
    section.add "prettyPrint", valid_598390
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598391: Call_BooksMylibraryReadingpositionsGet_598378;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves my reading position information for a volume.
  ## 
  let valid = call_598391.validator(path, query, header, formData, body)
  let scheme = call_598391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598391.url(scheme.get, call_598391.host, call_598391.base,
                         call_598391.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598391, url, valid)

proc call*(call_598392: Call_BooksMylibraryReadingpositionsGet_598378;
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
  var path_598393 = newJObject()
  var query_598394 = newJObject()
  add(query_598394, "fields", newJString(fields))
  add(query_598394, "quotaUser", newJString(quotaUser))
  add(query_598394, "alt", newJString(alt))
  add(query_598394, "oauth_token", newJString(oauthToken))
  add(query_598394, "userIp", newJString(userIp))
  add(query_598394, "contentVersion", newJString(contentVersion))
  add(query_598394, "source", newJString(source))
  add(query_598394, "key", newJString(key))
  add(path_598393, "volumeId", newJString(volumeId))
  add(query_598394, "prettyPrint", newJBool(prettyPrint))
  result = call_598392.call(path_598393, query_598394, nil, nil, nil)

var booksMylibraryReadingpositionsGet* = Call_BooksMylibraryReadingpositionsGet_598378(
    name: "booksMylibraryReadingpositionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/mylibrary/readingpositions/{volumeId}",
    validator: validate_BooksMylibraryReadingpositionsGet_598379,
    base: "/books/v1", url: url_BooksMylibraryReadingpositionsGet_598380,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryReadingpositionsSetPosition_598395 = ref object of OpenApiRestCall_597437
proc url_BooksMylibraryReadingpositionsSetPosition_598397(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BooksMylibraryReadingpositionsSetPosition_598396(path: JsonNode;
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
  var valid_598398 = path.getOrDefault("volumeId")
  valid_598398 = validateParameter(valid_598398, JString, required = true,
                                 default = nil)
  if valid_598398 != nil:
    section.add "volumeId", valid_598398
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
  var valid_598399 = query.getOrDefault("action")
  valid_598399 = validateParameter(valid_598399, JString, required = false,
                                 default = newJString("bookmark"))
  if valid_598399 != nil:
    section.add "action", valid_598399
  var valid_598400 = query.getOrDefault("fields")
  valid_598400 = validateParameter(valid_598400, JString, required = false,
                                 default = nil)
  if valid_598400 != nil:
    section.add "fields", valid_598400
  var valid_598401 = query.getOrDefault("quotaUser")
  valid_598401 = validateParameter(valid_598401, JString, required = false,
                                 default = nil)
  if valid_598401 != nil:
    section.add "quotaUser", valid_598401
  var valid_598402 = query.getOrDefault("alt")
  valid_598402 = validateParameter(valid_598402, JString, required = false,
                                 default = newJString("json"))
  if valid_598402 != nil:
    section.add "alt", valid_598402
  var valid_598403 = query.getOrDefault("oauth_token")
  valid_598403 = validateParameter(valid_598403, JString, required = false,
                                 default = nil)
  if valid_598403 != nil:
    section.add "oauth_token", valid_598403
  var valid_598404 = query.getOrDefault("userIp")
  valid_598404 = validateParameter(valid_598404, JString, required = false,
                                 default = nil)
  if valid_598404 != nil:
    section.add "userIp", valid_598404
  var valid_598405 = query.getOrDefault("contentVersion")
  valid_598405 = validateParameter(valid_598405, JString, required = false,
                                 default = nil)
  if valid_598405 != nil:
    section.add "contentVersion", valid_598405
  var valid_598406 = query.getOrDefault("source")
  valid_598406 = validateParameter(valid_598406, JString, required = false,
                                 default = nil)
  if valid_598406 != nil:
    section.add "source", valid_598406
  var valid_598407 = query.getOrDefault("key")
  valid_598407 = validateParameter(valid_598407, JString, required = false,
                                 default = nil)
  if valid_598407 != nil:
    section.add "key", valid_598407
  var valid_598408 = query.getOrDefault("deviceCookie")
  valid_598408 = validateParameter(valid_598408, JString, required = false,
                                 default = nil)
  if valid_598408 != nil:
    section.add "deviceCookie", valid_598408
  assert query != nil,
        "query argument is necessary due to required `timestamp` field"
  var valid_598409 = query.getOrDefault("timestamp")
  valid_598409 = validateParameter(valid_598409, JString, required = true,
                                 default = nil)
  if valid_598409 != nil:
    section.add "timestamp", valid_598409
  var valid_598410 = query.getOrDefault("prettyPrint")
  valid_598410 = validateParameter(valid_598410, JBool, required = false,
                                 default = newJBool(true))
  if valid_598410 != nil:
    section.add "prettyPrint", valid_598410
  var valid_598411 = query.getOrDefault("position")
  valid_598411 = validateParameter(valid_598411, JString, required = true,
                                 default = nil)
  if valid_598411 != nil:
    section.add "position", valid_598411
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598412: Call_BooksMylibraryReadingpositionsSetPosition_598395;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets my reading position information for a volume.
  ## 
  let valid = call_598412.validator(path, query, header, formData, body)
  let scheme = call_598412.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598412.url(scheme.get, call_598412.host, call_598412.base,
                         call_598412.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598412, url, valid)

proc call*(call_598413: Call_BooksMylibraryReadingpositionsSetPosition_598395;
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
  var path_598414 = newJObject()
  var query_598415 = newJObject()
  add(query_598415, "action", newJString(action))
  add(query_598415, "fields", newJString(fields))
  add(query_598415, "quotaUser", newJString(quotaUser))
  add(query_598415, "alt", newJString(alt))
  add(query_598415, "oauth_token", newJString(oauthToken))
  add(query_598415, "userIp", newJString(userIp))
  add(query_598415, "contentVersion", newJString(contentVersion))
  add(query_598415, "source", newJString(source))
  add(query_598415, "key", newJString(key))
  add(path_598414, "volumeId", newJString(volumeId))
  add(query_598415, "deviceCookie", newJString(deviceCookie))
  add(query_598415, "timestamp", newJString(timestamp))
  add(query_598415, "prettyPrint", newJBool(prettyPrint))
  add(query_598415, "position", newJString(position))
  result = call_598413.call(path_598414, query_598415, nil, nil, nil)

var booksMylibraryReadingpositionsSetPosition* = Call_BooksMylibraryReadingpositionsSetPosition_598395(
    name: "booksMylibraryReadingpositionsSetPosition", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/mylibrary/readingpositions/{volumeId}/setPosition",
    validator: validate_BooksMylibraryReadingpositionsSetPosition_598396,
    base: "/books/v1", url: url_BooksMylibraryReadingpositionsSetPosition_598397,
    schemes: {Scheme.Https})
type
  Call_BooksNotificationGet_598416 = ref object of OpenApiRestCall_597437
proc url_BooksNotificationGet_598418(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BooksNotificationGet_598417(path: JsonNode; query: JsonNode;
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
  var valid_598419 = query.getOrDefault("locale")
  valid_598419 = validateParameter(valid_598419, JString, required = false,
                                 default = nil)
  if valid_598419 != nil:
    section.add "locale", valid_598419
  var valid_598420 = query.getOrDefault("fields")
  valid_598420 = validateParameter(valid_598420, JString, required = false,
                                 default = nil)
  if valid_598420 != nil:
    section.add "fields", valid_598420
  var valid_598421 = query.getOrDefault("quotaUser")
  valid_598421 = validateParameter(valid_598421, JString, required = false,
                                 default = nil)
  if valid_598421 != nil:
    section.add "quotaUser", valid_598421
  var valid_598422 = query.getOrDefault("alt")
  valid_598422 = validateParameter(valid_598422, JString, required = false,
                                 default = newJString("json"))
  if valid_598422 != nil:
    section.add "alt", valid_598422
  var valid_598423 = query.getOrDefault("oauth_token")
  valid_598423 = validateParameter(valid_598423, JString, required = false,
                                 default = nil)
  if valid_598423 != nil:
    section.add "oauth_token", valid_598423
  var valid_598424 = query.getOrDefault("userIp")
  valid_598424 = validateParameter(valid_598424, JString, required = false,
                                 default = nil)
  if valid_598424 != nil:
    section.add "userIp", valid_598424
  var valid_598425 = query.getOrDefault("source")
  valid_598425 = validateParameter(valid_598425, JString, required = false,
                                 default = nil)
  if valid_598425 != nil:
    section.add "source", valid_598425
  var valid_598426 = query.getOrDefault("key")
  valid_598426 = validateParameter(valid_598426, JString, required = false,
                                 default = nil)
  if valid_598426 != nil:
    section.add "key", valid_598426
  var valid_598427 = query.getOrDefault("prettyPrint")
  valid_598427 = validateParameter(valid_598427, JBool, required = false,
                                 default = newJBool(true))
  if valid_598427 != nil:
    section.add "prettyPrint", valid_598427
  assert query != nil,
        "query argument is necessary due to required `notification_id` field"
  var valid_598428 = query.getOrDefault("notification_id")
  valid_598428 = validateParameter(valid_598428, JString, required = true,
                                 default = nil)
  if valid_598428 != nil:
    section.add "notification_id", valid_598428
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598429: Call_BooksNotificationGet_598416; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns notification details for a given notification id.
  ## 
  let valid = call_598429.validator(path, query, header, formData, body)
  let scheme = call_598429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598429.url(scheme.get, call_598429.host, call_598429.base,
                         call_598429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598429, url, valid)

proc call*(call_598430: Call_BooksNotificationGet_598416; notificationId: string;
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
  var query_598431 = newJObject()
  add(query_598431, "locale", newJString(locale))
  add(query_598431, "fields", newJString(fields))
  add(query_598431, "quotaUser", newJString(quotaUser))
  add(query_598431, "alt", newJString(alt))
  add(query_598431, "oauth_token", newJString(oauthToken))
  add(query_598431, "userIp", newJString(userIp))
  add(query_598431, "source", newJString(source))
  add(query_598431, "key", newJString(key))
  add(query_598431, "prettyPrint", newJBool(prettyPrint))
  add(query_598431, "notification_id", newJString(notificationId))
  result = call_598430.call(nil, query_598431, nil, nil, nil)

var booksNotificationGet* = Call_BooksNotificationGet_598416(
    name: "booksNotificationGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/notification/get",
    validator: validate_BooksNotificationGet_598417, base: "/books/v1",
    url: url_BooksNotificationGet_598418, schemes: {Scheme.Https})
type
  Call_BooksOnboardingListCategories_598432 = ref object of OpenApiRestCall_597437
proc url_BooksOnboardingListCategories_598434(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BooksOnboardingListCategories_598433(path: JsonNode; query: JsonNode;
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
  var valid_598435 = query.getOrDefault("locale")
  valid_598435 = validateParameter(valid_598435, JString, required = false,
                                 default = nil)
  if valid_598435 != nil:
    section.add "locale", valid_598435
  var valid_598436 = query.getOrDefault("fields")
  valid_598436 = validateParameter(valid_598436, JString, required = false,
                                 default = nil)
  if valid_598436 != nil:
    section.add "fields", valid_598436
  var valid_598437 = query.getOrDefault("quotaUser")
  valid_598437 = validateParameter(valid_598437, JString, required = false,
                                 default = nil)
  if valid_598437 != nil:
    section.add "quotaUser", valid_598437
  var valid_598438 = query.getOrDefault("alt")
  valid_598438 = validateParameter(valid_598438, JString, required = false,
                                 default = newJString("json"))
  if valid_598438 != nil:
    section.add "alt", valid_598438
  var valid_598439 = query.getOrDefault("oauth_token")
  valid_598439 = validateParameter(valid_598439, JString, required = false,
                                 default = nil)
  if valid_598439 != nil:
    section.add "oauth_token", valid_598439
  var valid_598440 = query.getOrDefault("userIp")
  valid_598440 = validateParameter(valid_598440, JString, required = false,
                                 default = nil)
  if valid_598440 != nil:
    section.add "userIp", valid_598440
  var valid_598441 = query.getOrDefault("key")
  valid_598441 = validateParameter(valid_598441, JString, required = false,
                                 default = nil)
  if valid_598441 != nil:
    section.add "key", valid_598441
  var valid_598442 = query.getOrDefault("prettyPrint")
  valid_598442 = validateParameter(valid_598442, JBool, required = false,
                                 default = newJBool(true))
  if valid_598442 != nil:
    section.add "prettyPrint", valid_598442
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598443: Call_BooksOnboardingListCategories_598432; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List categories for onboarding experience.
  ## 
  let valid = call_598443.validator(path, query, header, formData, body)
  let scheme = call_598443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598443.url(scheme.get, call_598443.host, call_598443.base,
                         call_598443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598443, url, valid)

proc call*(call_598444: Call_BooksOnboardingListCategories_598432;
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
  var query_598445 = newJObject()
  add(query_598445, "locale", newJString(locale))
  add(query_598445, "fields", newJString(fields))
  add(query_598445, "quotaUser", newJString(quotaUser))
  add(query_598445, "alt", newJString(alt))
  add(query_598445, "oauth_token", newJString(oauthToken))
  add(query_598445, "userIp", newJString(userIp))
  add(query_598445, "key", newJString(key))
  add(query_598445, "prettyPrint", newJBool(prettyPrint))
  result = call_598444.call(nil, query_598445, nil, nil, nil)

var booksOnboardingListCategories* = Call_BooksOnboardingListCategories_598432(
    name: "booksOnboardingListCategories", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/onboarding/listCategories",
    validator: validate_BooksOnboardingListCategories_598433, base: "/books/v1",
    url: url_BooksOnboardingListCategories_598434, schemes: {Scheme.Https})
type
  Call_BooksOnboardingListCategoryVolumes_598446 = ref object of OpenApiRestCall_597437
proc url_BooksOnboardingListCategoryVolumes_598448(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BooksOnboardingListCategoryVolumes_598447(path: JsonNode;
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
  var valid_598449 = query.getOrDefault("locale")
  valid_598449 = validateParameter(valid_598449, JString, required = false,
                                 default = nil)
  if valid_598449 != nil:
    section.add "locale", valid_598449
  var valid_598450 = query.getOrDefault("fields")
  valid_598450 = validateParameter(valid_598450, JString, required = false,
                                 default = nil)
  if valid_598450 != nil:
    section.add "fields", valid_598450
  var valid_598451 = query.getOrDefault("pageToken")
  valid_598451 = validateParameter(valid_598451, JString, required = false,
                                 default = nil)
  if valid_598451 != nil:
    section.add "pageToken", valid_598451
  var valid_598452 = query.getOrDefault("quotaUser")
  valid_598452 = validateParameter(valid_598452, JString, required = false,
                                 default = nil)
  if valid_598452 != nil:
    section.add "quotaUser", valid_598452
  var valid_598453 = query.getOrDefault("alt")
  valid_598453 = validateParameter(valid_598453, JString, required = false,
                                 default = newJString("json"))
  if valid_598453 != nil:
    section.add "alt", valid_598453
  var valid_598454 = query.getOrDefault("categoryId")
  valid_598454 = validateParameter(valid_598454, JArray, required = false,
                                 default = nil)
  if valid_598454 != nil:
    section.add "categoryId", valid_598454
  var valid_598455 = query.getOrDefault("oauth_token")
  valid_598455 = validateParameter(valid_598455, JString, required = false,
                                 default = nil)
  if valid_598455 != nil:
    section.add "oauth_token", valid_598455
  var valid_598456 = query.getOrDefault("userIp")
  valid_598456 = validateParameter(valid_598456, JString, required = false,
                                 default = nil)
  if valid_598456 != nil:
    section.add "userIp", valid_598456
  var valid_598457 = query.getOrDefault("key")
  valid_598457 = validateParameter(valid_598457, JString, required = false,
                                 default = nil)
  if valid_598457 != nil:
    section.add "key", valid_598457
  var valid_598458 = query.getOrDefault("pageSize")
  valid_598458 = validateParameter(valid_598458, JInt, required = false, default = nil)
  if valid_598458 != nil:
    section.add "pageSize", valid_598458
  var valid_598459 = query.getOrDefault("prettyPrint")
  valid_598459 = validateParameter(valid_598459, JBool, required = false,
                                 default = newJBool(true))
  if valid_598459 != nil:
    section.add "prettyPrint", valid_598459
  var valid_598460 = query.getOrDefault("maxAllowedMaturityRating")
  valid_598460 = validateParameter(valid_598460, JString, required = false,
                                 default = newJString("mature"))
  if valid_598460 != nil:
    section.add "maxAllowedMaturityRating", valid_598460
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598461: Call_BooksOnboardingListCategoryVolumes_598446;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List available volumes under categories for onboarding experience.
  ## 
  let valid = call_598461.validator(path, query, header, formData, body)
  let scheme = call_598461.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598461.url(scheme.get, call_598461.host, call_598461.base,
                         call_598461.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598461, url, valid)

proc call*(call_598462: Call_BooksOnboardingListCategoryVolumes_598446;
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
  var query_598463 = newJObject()
  add(query_598463, "locale", newJString(locale))
  add(query_598463, "fields", newJString(fields))
  add(query_598463, "pageToken", newJString(pageToken))
  add(query_598463, "quotaUser", newJString(quotaUser))
  add(query_598463, "alt", newJString(alt))
  if categoryId != nil:
    query_598463.add "categoryId", categoryId
  add(query_598463, "oauth_token", newJString(oauthToken))
  add(query_598463, "userIp", newJString(userIp))
  add(query_598463, "key", newJString(key))
  add(query_598463, "pageSize", newJInt(pageSize))
  add(query_598463, "prettyPrint", newJBool(prettyPrint))
  add(query_598463, "maxAllowedMaturityRating",
      newJString(maxAllowedMaturityRating))
  result = call_598462.call(nil, query_598463, nil, nil, nil)

var booksOnboardingListCategoryVolumes* = Call_BooksOnboardingListCategoryVolumes_598446(
    name: "booksOnboardingListCategoryVolumes", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/onboarding/listCategoryVolumes",
    validator: validate_BooksOnboardingListCategoryVolumes_598447,
    base: "/books/v1", url: url_BooksOnboardingListCategoryVolumes_598448,
    schemes: {Scheme.Https})
type
  Call_BooksPersonalizedstreamGet_598464 = ref object of OpenApiRestCall_597437
proc url_BooksPersonalizedstreamGet_598466(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BooksPersonalizedstreamGet_598465(path: JsonNode; query: JsonNode;
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
  var valid_598467 = query.getOrDefault("locale")
  valid_598467 = validateParameter(valid_598467, JString, required = false,
                                 default = nil)
  if valid_598467 != nil:
    section.add "locale", valid_598467
  var valid_598468 = query.getOrDefault("fields")
  valid_598468 = validateParameter(valid_598468, JString, required = false,
                                 default = nil)
  if valid_598468 != nil:
    section.add "fields", valid_598468
  var valid_598469 = query.getOrDefault("quotaUser")
  valid_598469 = validateParameter(valid_598469, JString, required = false,
                                 default = nil)
  if valid_598469 != nil:
    section.add "quotaUser", valid_598469
  var valid_598470 = query.getOrDefault("alt")
  valid_598470 = validateParameter(valid_598470, JString, required = false,
                                 default = newJString("json"))
  if valid_598470 != nil:
    section.add "alt", valid_598470
  var valid_598471 = query.getOrDefault("oauth_token")
  valid_598471 = validateParameter(valid_598471, JString, required = false,
                                 default = nil)
  if valid_598471 != nil:
    section.add "oauth_token", valid_598471
  var valid_598472 = query.getOrDefault("userIp")
  valid_598472 = validateParameter(valid_598472, JString, required = false,
                                 default = nil)
  if valid_598472 != nil:
    section.add "userIp", valid_598472
  var valid_598473 = query.getOrDefault("source")
  valid_598473 = validateParameter(valid_598473, JString, required = false,
                                 default = nil)
  if valid_598473 != nil:
    section.add "source", valid_598473
  var valid_598474 = query.getOrDefault("key")
  valid_598474 = validateParameter(valid_598474, JString, required = false,
                                 default = nil)
  if valid_598474 != nil:
    section.add "key", valid_598474
  var valid_598475 = query.getOrDefault("prettyPrint")
  valid_598475 = validateParameter(valid_598475, JBool, required = false,
                                 default = newJBool(true))
  if valid_598475 != nil:
    section.add "prettyPrint", valid_598475
  var valid_598476 = query.getOrDefault("maxAllowedMaturityRating")
  valid_598476 = validateParameter(valid_598476, JString, required = false,
                                 default = newJString("mature"))
  if valid_598476 != nil:
    section.add "maxAllowedMaturityRating", valid_598476
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598477: Call_BooksPersonalizedstreamGet_598464; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a stream of personalized book clusters
  ## 
  let valid = call_598477.validator(path, query, header, formData, body)
  let scheme = call_598477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598477.url(scheme.get, call_598477.host, call_598477.base,
                         call_598477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598477, url, valid)

proc call*(call_598478: Call_BooksPersonalizedstreamGet_598464;
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
  var query_598479 = newJObject()
  add(query_598479, "locale", newJString(locale))
  add(query_598479, "fields", newJString(fields))
  add(query_598479, "quotaUser", newJString(quotaUser))
  add(query_598479, "alt", newJString(alt))
  add(query_598479, "oauth_token", newJString(oauthToken))
  add(query_598479, "userIp", newJString(userIp))
  add(query_598479, "source", newJString(source))
  add(query_598479, "key", newJString(key))
  add(query_598479, "prettyPrint", newJBool(prettyPrint))
  add(query_598479, "maxAllowedMaturityRating",
      newJString(maxAllowedMaturityRating))
  result = call_598478.call(nil, query_598479, nil, nil, nil)

var booksPersonalizedstreamGet* = Call_BooksPersonalizedstreamGet_598464(
    name: "booksPersonalizedstreamGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/personalizedstream/get",
    validator: validate_BooksPersonalizedstreamGet_598465, base: "/books/v1",
    url: url_BooksPersonalizedstreamGet_598466, schemes: {Scheme.Https})
type
  Call_BooksPromoofferAccept_598480 = ref object of OpenApiRestCall_597437
proc url_BooksPromoofferAccept_598482(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BooksPromoofferAccept_598481(path: JsonNode; query: JsonNode;
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
  var valid_598483 = query.getOrDefault("fields")
  valid_598483 = validateParameter(valid_598483, JString, required = false,
                                 default = nil)
  if valid_598483 != nil:
    section.add "fields", valid_598483
  var valid_598484 = query.getOrDefault("quotaUser")
  valid_598484 = validateParameter(valid_598484, JString, required = false,
                                 default = nil)
  if valid_598484 != nil:
    section.add "quotaUser", valid_598484
  var valid_598485 = query.getOrDefault("alt")
  valid_598485 = validateParameter(valid_598485, JString, required = false,
                                 default = newJString("json"))
  if valid_598485 != nil:
    section.add "alt", valid_598485
  var valid_598486 = query.getOrDefault("androidId")
  valid_598486 = validateParameter(valid_598486, JString, required = false,
                                 default = nil)
  if valid_598486 != nil:
    section.add "androidId", valid_598486
  var valid_598487 = query.getOrDefault("model")
  valid_598487 = validateParameter(valid_598487, JString, required = false,
                                 default = nil)
  if valid_598487 != nil:
    section.add "model", valid_598487
  var valid_598488 = query.getOrDefault("oauth_token")
  valid_598488 = validateParameter(valid_598488, JString, required = false,
                                 default = nil)
  if valid_598488 != nil:
    section.add "oauth_token", valid_598488
  var valid_598489 = query.getOrDefault("product")
  valid_598489 = validateParameter(valid_598489, JString, required = false,
                                 default = nil)
  if valid_598489 != nil:
    section.add "product", valid_598489
  var valid_598490 = query.getOrDefault("userIp")
  valid_598490 = validateParameter(valid_598490, JString, required = false,
                                 default = nil)
  if valid_598490 != nil:
    section.add "userIp", valid_598490
  var valid_598491 = query.getOrDefault("serial")
  valid_598491 = validateParameter(valid_598491, JString, required = false,
                                 default = nil)
  if valid_598491 != nil:
    section.add "serial", valid_598491
  var valid_598492 = query.getOrDefault("key")
  valid_598492 = validateParameter(valid_598492, JString, required = false,
                                 default = nil)
  if valid_598492 != nil:
    section.add "key", valid_598492
  var valid_598493 = query.getOrDefault("device")
  valid_598493 = validateParameter(valid_598493, JString, required = false,
                                 default = nil)
  if valid_598493 != nil:
    section.add "device", valid_598493
  var valid_598494 = query.getOrDefault("manufacturer")
  valid_598494 = validateParameter(valid_598494, JString, required = false,
                                 default = nil)
  if valid_598494 != nil:
    section.add "manufacturer", valid_598494
  var valid_598495 = query.getOrDefault("offerId")
  valid_598495 = validateParameter(valid_598495, JString, required = false,
                                 default = nil)
  if valid_598495 != nil:
    section.add "offerId", valid_598495
  var valid_598496 = query.getOrDefault("volumeId")
  valid_598496 = validateParameter(valid_598496, JString, required = false,
                                 default = nil)
  if valid_598496 != nil:
    section.add "volumeId", valid_598496
  var valid_598497 = query.getOrDefault("prettyPrint")
  valid_598497 = validateParameter(valid_598497, JBool, required = false,
                                 default = newJBool(true))
  if valid_598497 != nil:
    section.add "prettyPrint", valid_598497
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598498: Call_BooksPromoofferAccept_598480; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_598498.validator(path, query, header, formData, body)
  let scheme = call_598498.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598498.url(scheme.get, call_598498.host, call_598498.base,
                         call_598498.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598498, url, valid)

proc call*(call_598499: Call_BooksPromoofferAccept_598480; fields: string = "";
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
  var query_598500 = newJObject()
  add(query_598500, "fields", newJString(fields))
  add(query_598500, "quotaUser", newJString(quotaUser))
  add(query_598500, "alt", newJString(alt))
  add(query_598500, "androidId", newJString(androidId))
  add(query_598500, "model", newJString(model))
  add(query_598500, "oauth_token", newJString(oauthToken))
  add(query_598500, "product", newJString(product))
  add(query_598500, "userIp", newJString(userIp))
  add(query_598500, "serial", newJString(serial))
  add(query_598500, "key", newJString(key))
  add(query_598500, "device", newJString(device))
  add(query_598500, "manufacturer", newJString(manufacturer))
  add(query_598500, "offerId", newJString(offerId))
  add(query_598500, "volumeId", newJString(volumeId))
  add(query_598500, "prettyPrint", newJBool(prettyPrint))
  result = call_598499.call(nil, query_598500, nil, nil, nil)

var booksPromoofferAccept* = Call_BooksPromoofferAccept_598480(
    name: "booksPromoofferAccept", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/promooffer/accept",
    validator: validate_BooksPromoofferAccept_598481, base: "/books/v1",
    url: url_BooksPromoofferAccept_598482, schemes: {Scheme.Https})
type
  Call_BooksPromoofferDismiss_598501 = ref object of OpenApiRestCall_597437
proc url_BooksPromoofferDismiss_598503(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BooksPromoofferDismiss_598502(path: JsonNode; query: JsonNode;
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
  var valid_598504 = query.getOrDefault("fields")
  valid_598504 = validateParameter(valid_598504, JString, required = false,
                                 default = nil)
  if valid_598504 != nil:
    section.add "fields", valid_598504
  var valid_598505 = query.getOrDefault("quotaUser")
  valid_598505 = validateParameter(valid_598505, JString, required = false,
                                 default = nil)
  if valid_598505 != nil:
    section.add "quotaUser", valid_598505
  var valid_598506 = query.getOrDefault("alt")
  valid_598506 = validateParameter(valid_598506, JString, required = false,
                                 default = newJString("json"))
  if valid_598506 != nil:
    section.add "alt", valid_598506
  var valid_598507 = query.getOrDefault("androidId")
  valid_598507 = validateParameter(valid_598507, JString, required = false,
                                 default = nil)
  if valid_598507 != nil:
    section.add "androidId", valid_598507
  var valid_598508 = query.getOrDefault("model")
  valid_598508 = validateParameter(valid_598508, JString, required = false,
                                 default = nil)
  if valid_598508 != nil:
    section.add "model", valid_598508
  var valid_598509 = query.getOrDefault("oauth_token")
  valid_598509 = validateParameter(valid_598509, JString, required = false,
                                 default = nil)
  if valid_598509 != nil:
    section.add "oauth_token", valid_598509
  var valid_598510 = query.getOrDefault("product")
  valid_598510 = validateParameter(valid_598510, JString, required = false,
                                 default = nil)
  if valid_598510 != nil:
    section.add "product", valid_598510
  var valid_598511 = query.getOrDefault("userIp")
  valid_598511 = validateParameter(valid_598511, JString, required = false,
                                 default = nil)
  if valid_598511 != nil:
    section.add "userIp", valid_598511
  var valid_598512 = query.getOrDefault("serial")
  valid_598512 = validateParameter(valid_598512, JString, required = false,
                                 default = nil)
  if valid_598512 != nil:
    section.add "serial", valid_598512
  var valid_598513 = query.getOrDefault("key")
  valid_598513 = validateParameter(valid_598513, JString, required = false,
                                 default = nil)
  if valid_598513 != nil:
    section.add "key", valid_598513
  var valid_598514 = query.getOrDefault("device")
  valid_598514 = validateParameter(valid_598514, JString, required = false,
                                 default = nil)
  if valid_598514 != nil:
    section.add "device", valid_598514
  var valid_598515 = query.getOrDefault("manufacturer")
  valid_598515 = validateParameter(valid_598515, JString, required = false,
                                 default = nil)
  if valid_598515 != nil:
    section.add "manufacturer", valid_598515
  var valid_598516 = query.getOrDefault("offerId")
  valid_598516 = validateParameter(valid_598516, JString, required = false,
                                 default = nil)
  if valid_598516 != nil:
    section.add "offerId", valid_598516
  var valid_598517 = query.getOrDefault("prettyPrint")
  valid_598517 = validateParameter(valid_598517, JBool, required = false,
                                 default = newJBool(true))
  if valid_598517 != nil:
    section.add "prettyPrint", valid_598517
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598518: Call_BooksPromoofferDismiss_598501; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_598518.validator(path, query, header, formData, body)
  let scheme = call_598518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598518.url(scheme.get, call_598518.host, call_598518.base,
                         call_598518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598518, url, valid)

proc call*(call_598519: Call_BooksPromoofferDismiss_598501; fields: string = "";
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
  var query_598520 = newJObject()
  add(query_598520, "fields", newJString(fields))
  add(query_598520, "quotaUser", newJString(quotaUser))
  add(query_598520, "alt", newJString(alt))
  add(query_598520, "androidId", newJString(androidId))
  add(query_598520, "model", newJString(model))
  add(query_598520, "oauth_token", newJString(oauthToken))
  add(query_598520, "product", newJString(product))
  add(query_598520, "userIp", newJString(userIp))
  add(query_598520, "serial", newJString(serial))
  add(query_598520, "key", newJString(key))
  add(query_598520, "device", newJString(device))
  add(query_598520, "manufacturer", newJString(manufacturer))
  add(query_598520, "offerId", newJString(offerId))
  add(query_598520, "prettyPrint", newJBool(prettyPrint))
  result = call_598519.call(nil, query_598520, nil, nil, nil)

var booksPromoofferDismiss* = Call_BooksPromoofferDismiss_598501(
    name: "booksPromoofferDismiss", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/promooffer/dismiss",
    validator: validate_BooksPromoofferDismiss_598502, base: "/books/v1",
    url: url_BooksPromoofferDismiss_598503, schemes: {Scheme.Https})
type
  Call_BooksPromoofferGet_598521 = ref object of OpenApiRestCall_597437
proc url_BooksPromoofferGet_598523(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BooksPromoofferGet_598522(path: JsonNode; query: JsonNode;
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
  var valid_598524 = query.getOrDefault("fields")
  valid_598524 = validateParameter(valid_598524, JString, required = false,
                                 default = nil)
  if valid_598524 != nil:
    section.add "fields", valid_598524
  var valid_598525 = query.getOrDefault("quotaUser")
  valid_598525 = validateParameter(valid_598525, JString, required = false,
                                 default = nil)
  if valid_598525 != nil:
    section.add "quotaUser", valid_598525
  var valid_598526 = query.getOrDefault("alt")
  valid_598526 = validateParameter(valid_598526, JString, required = false,
                                 default = newJString("json"))
  if valid_598526 != nil:
    section.add "alt", valid_598526
  var valid_598527 = query.getOrDefault("androidId")
  valid_598527 = validateParameter(valid_598527, JString, required = false,
                                 default = nil)
  if valid_598527 != nil:
    section.add "androidId", valid_598527
  var valid_598528 = query.getOrDefault("model")
  valid_598528 = validateParameter(valid_598528, JString, required = false,
                                 default = nil)
  if valid_598528 != nil:
    section.add "model", valid_598528
  var valid_598529 = query.getOrDefault("oauth_token")
  valid_598529 = validateParameter(valid_598529, JString, required = false,
                                 default = nil)
  if valid_598529 != nil:
    section.add "oauth_token", valid_598529
  var valid_598530 = query.getOrDefault("product")
  valid_598530 = validateParameter(valid_598530, JString, required = false,
                                 default = nil)
  if valid_598530 != nil:
    section.add "product", valid_598530
  var valid_598531 = query.getOrDefault("userIp")
  valid_598531 = validateParameter(valid_598531, JString, required = false,
                                 default = nil)
  if valid_598531 != nil:
    section.add "userIp", valid_598531
  var valid_598532 = query.getOrDefault("serial")
  valid_598532 = validateParameter(valid_598532, JString, required = false,
                                 default = nil)
  if valid_598532 != nil:
    section.add "serial", valid_598532
  var valid_598533 = query.getOrDefault("key")
  valid_598533 = validateParameter(valid_598533, JString, required = false,
                                 default = nil)
  if valid_598533 != nil:
    section.add "key", valid_598533
  var valid_598534 = query.getOrDefault("device")
  valid_598534 = validateParameter(valid_598534, JString, required = false,
                                 default = nil)
  if valid_598534 != nil:
    section.add "device", valid_598534
  var valid_598535 = query.getOrDefault("manufacturer")
  valid_598535 = validateParameter(valid_598535, JString, required = false,
                                 default = nil)
  if valid_598535 != nil:
    section.add "manufacturer", valid_598535
  var valid_598536 = query.getOrDefault("prettyPrint")
  valid_598536 = validateParameter(valid_598536, JBool, required = false,
                                 default = newJBool(true))
  if valid_598536 != nil:
    section.add "prettyPrint", valid_598536
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598537: Call_BooksPromoofferGet_598521; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of promo offers available to the user
  ## 
  let valid = call_598537.validator(path, query, header, formData, body)
  let scheme = call_598537.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598537.url(scheme.get, call_598537.host, call_598537.base,
                         call_598537.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598537, url, valid)

proc call*(call_598538: Call_BooksPromoofferGet_598521; fields: string = "";
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
  var query_598539 = newJObject()
  add(query_598539, "fields", newJString(fields))
  add(query_598539, "quotaUser", newJString(quotaUser))
  add(query_598539, "alt", newJString(alt))
  add(query_598539, "androidId", newJString(androidId))
  add(query_598539, "model", newJString(model))
  add(query_598539, "oauth_token", newJString(oauthToken))
  add(query_598539, "product", newJString(product))
  add(query_598539, "userIp", newJString(userIp))
  add(query_598539, "serial", newJString(serial))
  add(query_598539, "key", newJString(key))
  add(query_598539, "device", newJString(device))
  add(query_598539, "manufacturer", newJString(manufacturer))
  add(query_598539, "prettyPrint", newJBool(prettyPrint))
  result = call_598538.call(nil, query_598539, nil, nil, nil)

var booksPromoofferGet* = Call_BooksPromoofferGet_598521(
    name: "booksPromoofferGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/promooffer/get",
    validator: validate_BooksPromoofferGet_598522, base: "/books/v1",
    url: url_BooksPromoofferGet_598523, schemes: {Scheme.Https})
type
  Call_BooksSeriesGet_598540 = ref object of OpenApiRestCall_597437
proc url_BooksSeriesGet_598542(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BooksSeriesGet_598541(path: JsonNode; query: JsonNode;
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
  var valid_598543 = query.getOrDefault("series_id")
  valid_598543 = validateParameter(valid_598543, JArray, required = true, default = nil)
  if valid_598543 != nil:
    section.add "series_id", valid_598543
  var valid_598544 = query.getOrDefault("fields")
  valid_598544 = validateParameter(valid_598544, JString, required = false,
                                 default = nil)
  if valid_598544 != nil:
    section.add "fields", valid_598544
  var valid_598545 = query.getOrDefault("quotaUser")
  valid_598545 = validateParameter(valid_598545, JString, required = false,
                                 default = nil)
  if valid_598545 != nil:
    section.add "quotaUser", valid_598545
  var valid_598546 = query.getOrDefault("alt")
  valid_598546 = validateParameter(valid_598546, JString, required = false,
                                 default = newJString("json"))
  if valid_598546 != nil:
    section.add "alt", valid_598546
  var valid_598547 = query.getOrDefault("oauth_token")
  valid_598547 = validateParameter(valid_598547, JString, required = false,
                                 default = nil)
  if valid_598547 != nil:
    section.add "oauth_token", valid_598547
  var valid_598548 = query.getOrDefault("userIp")
  valid_598548 = validateParameter(valid_598548, JString, required = false,
                                 default = nil)
  if valid_598548 != nil:
    section.add "userIp", valid_598548
  var valid_598549 = query.getOrDefault("key")
  valid_598549 = validateParameter(valid_598549, JString, required = false,
                                 default = nil)
  if valid_598549 != nil:
    section.add "key", valid_598549
  var valid_598550 = query.getOrDefault("prettyPrint")
  valid_598550 = validateParameter(valid_598550, JBool, required = false,
                                 default = newJBool(true))
  if valid_598550 != nil:
    section.add "prettyPrint", valid_598550
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598551: Call_BooksSeriesGet_598540; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Series metadata for the given series ids.
  ## 
  let valid = call_598551.validator(path, query, header, formData, body)
  let scheme = call_598551.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598551.url(scheme.get, call_598551.host, call_598551.base,
                         call_598551.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598551, url, valid)

proc call*(call_598552: Call_BooksSeriesGet_598540; seriesId: JsonNode;
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
  var query_598553 = newJObject()
  if seriesId != nil:
    query_598553.add "series_id", seriesId
  add(query_598553, "fields", newJString(fields))
  add(query_598553, "quotaUser", newJString(quotaUser))
  add(query_598553, "alt", newJString(alt))
  add(query_598553, "oauth_token", newJString(oauthToken))
  add(query_598553, "userIp", newJString(userIp))
  add(query_598553, "key", newJString(key))
  add(query_598553, "prettyPrint", newJBool(prettyPrint))
  result = call_598552.call(nil, query_598553, nil, nil, nil)

var booksSeriesGet* = Call_BooksSeriesGet_598540(name: "booksSeriesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/series/get",
    validator: validate_BooksSeriesGet_598541, base: "/books/v1",
    url: url_BooksSeriesGet_598542, schemes: {Scheme.Https})
type
  Call_BooksSeriesMembershipGet_598554 = ref object of OpenApiRestCall_597437
proc url_BooksSeriesMembershipGet_598556(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BooksSeriesMembershipGet_598555(path: JsonNode; query: JsonNode;
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
  var valid_598557 = query.getOrDefault("series_id")
  valid_598557 = validateParameter(valid_598557, JString, required = true,
                                 default = nil)
  if valid_598557 != nil:
    section.add "series_id", valid_598557
  var valid_598558 = query.getOrDefault("fields")
  valid_598558 = validateParameter(valid_598558, JString, required = false,
                                 default = nil)
  if valid_598558 != nil:
    section.add "fields", valid_598558
  var valid_598559 = query.getOrDefault("page_token")
  valid_598559 = validateParameter(valid_598559, JString, required = false,
                                 default = nil)
  if valid_598559 != nil:
    section.add "page_token", valid_598559
  var valid_598560 = query.getOrDefault("quotaUser")
  valid_598560 = validateParameter(valid_598560, JString, required = false,
                                 default = nil)
  if valid_598560 != nil:
    section.add "quotaUser", valid_598560
  var valid_598561 = query.getOrDefault("alt")
  valid_598561 = validateParameter(valid_598561, JString, required = false,
                                 default = newJString("json"))
  if valid_598561 != nil:
    section.add "alt", valid_598561
  var valid_598562 = query.getOrDefault("oauth_token")
  valid_598562 = validateParameter(valid_598562, JString, required = false,
                                 default = nil)
  if valid_598562 != nil:
    section.add "oauth_token", valid_598562
  var valid_598563 = query.getOrDefault("userIp")
  valid_598563 = validateParameter(valid_598563, JString, required = false,
                                 default = nil)
  if valid_598563 != nil:
    section.add "userIp", valid_598563
  var valid_598564 = query.getOrDefault("page_size")
  valid_598564 = validateParameter(valid_598564, JInt, required = false, default = nil)
  if valid_598564 != nil:
    section.add "page_size", valid_598564
  var valid_598565 = query.getOrDefault("key")
  valid_598565 = validateParameter(valid_598565, JString, required = false,
                                 default = nil)
  if valid_598565 != nil:
    section.add "key", valid_598565
  var valid_598566 = query.getOrDefault("prettyPrint")
  valid_598566 = validateParameter(valid_598566, JBool, required = false,
                                 default = newJBool(true))
  if valid_598566 != nil:
    section.add "prettyPrint", valid_598566
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598567: Call_BooksSeriesMembershipGet_598554; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Series membership data given the series id.
  ## 
  let valid = call_598567.validator(path, query, header, formData, body)
  let scheme = call_598567.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598567.url(scheme.get, call_598567.host, call_598567.base,
                         call_598567.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598567, url, valid)

proc call*(call_598568: Call_BooksSeriesMembershipGet_598554; seriesId: string;
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
  var query_598569 = newJObject()
  add(query_598569, "series_id", newJString(seriesId))
  add(query_598569, "fields", newJString(fields))
  add(query_598569, "page_token", newJString(pageToken))
  add(query_598569, "quotaUser", newJString(quotaUser))
  add(query_598569, "alt", newJString(alt))
  add(query_598569, "oauth_token", newJString(oauthToken))
  add(query_598569, "userIp", newJString(userIp))
  add(query_598569, "page_size", newJInt(pageSize))
  add(query_598569, "key", newJString(key))
  add(query_598569, "prettyPrint", newJBool(prettyPrint))
  result = call_598568.call(nil, query_598569, nil, nil, nil)

var booksSeriesMembershipGet* = Call_BooksSeriesMembershipGet_598554(
    name: "booksSeriesMembershipGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/series/membership/get",
    validator: validate_BooksSeriesMembershipGet_598555, base: "/books/v1",
    url: url_BooksSeriesMembershipGet_598556, schemes: {Scheme.Https})
type
  Call_BooksBookshelvesList_598570 = ref object of OpenApiRestCall_597437
proc url_BooksBookshelvesList_598572(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BooksBookshelvesList_598571(path: JsonNode; query: JsonNode;
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
  var valid_598573 = path.getOrDefault("userId")
  valid_598573 = validateParameter(valid_598573, JString, required = true,
                                 default = nil)
  if valid_598573 != nil:
    section.add "userId", valid_598573
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
  var valid_598574 = query.getOrDefault("fields")
  valid_598574 = validateParameter(valid_598574, JString, required = false,
                                 default = nil)
  if valid_598574 != nil:
    section.add "fields", valid_598574
  var valid_598575 = query.getOrDefault("quotaUser")
  valid_598575 = validateParameter(valid_598575, JString, required = false,
                                 default = nil)
  if valid_598575 != nil:
    section.add "quotaUser", valid_598575
  var valid_598576 = query.getOrDefault("alt")
  valid_598576 = validateParameter(valid_598576, JString, required = false,
                                 default = newJString("json"))
  if valid_598576 != nil:
    section.add "alt", valid_598576
  var valid_598577 = query.getOrDefault("oauth_token")
  valid_598577 = validateParameter(valid_598577, JString, required = false,
                                 default = nil)
  if valid_598577 != nil:
    section.add "oauth_token", valid_598577
  var valid_598578 = query.getOrDefault("userIp")
  valid_598578 = validateParameter(valid_598578, JString, required = false,
                                 default = nil)
  if valid_598578 != nil:
    section.add "userIp", valid_598578
  var valid_598579 = query.getOrDefault("source")
  valid_598579 = validateParameter(valid_598579, JString, required = false,
                                 default = nil)
  if valid_598579 != nil:
    section.add "source", valid_598579
  var valid_598580 = query.getOrDefault("key")
  valid_598580 = validateParameter(valid_598580, JString, required = false,
                                 default = nil)
  if valid_598580 != nil:
    section.add "key", valid_598580
  var valid_598581 = query.getOrDefault("prettyPrint")
  valid_598581 = validateParameter(valid_598581, JBool, required = false,
                                 default = newJBool(true))
  if valid_598581 != nil:
    section.add "prettyPrint", valid_598581
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598582: Call_BooksBookshelvesList_598570; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of public bookshelves for the specified user.
  ## 
  let valid = call_598582.validator(path, query, header, formData, body)
  let scheme = call_598582.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598582.url(scheme.get, call_598582.host, call_598582.base,
                         call_598582.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598582, url, valid)

proc call*(call_598583: Call_BooksBookshelvesList_598570; userId: string;
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
  var path_598584 = newJObject()
  var query_598585 = newJObject()
  add(query_598585, "fields", newJString(fields))
  add(query_598585, "quotaUser", newJString(quotaUser))
  add(query_598585, "alt", newJString(alt))
  add(query_598585, "oauth_token", newJString(oauthToken))
  add(query_598585, "userIp", newJString(userIp))
  add(query_598585, "source", newJString(source))
  add(query_598585, "key", newJString(key))
  add(query_598585, "prettyPrint", newJBool(prettyPrint))
  add(path_598584, "userId", newJString(userId))
  result = call_598583.call(path_598584, query_598585, nil, nil, nil)

var booksBookshelvesList* = Call_BooksBookshelvesList_598570(
    name: "booksBookshelvesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userId}/bookshelves",
    validator: validate_BooksBookshelvesList_598571, base: "/books/v1",
    url: url_BooksBookshelvesList_598572, schemes: {Scheme.Https})
type
  Call_BooksBookshelvesGet_598586 = ref object of OpenApiRestCall_597437
proc url_BooksBookshelvesGet_598588(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BooksBookshelvesGet_598587(path: JsonNode; query: JsonNode;
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
  var valid_598589 = path.getOrDefault("shelf")
  valid_598589 = validateParameter(valid_598589, JString, required = true,
                                 default = nil)
  if valid_598589 != nil:
    section.add "shelf", valid_598589
  var valid_598590 = path.getOrDefault("userId")
  valid_598590 = validateParameter(valid_598590, JString, required = true,
                                 default = nil)
  if valid_598590 != nil:
    section.add "userId", valid_598590
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
  var valid_598591 = query.getOrDefault("fields")
  valid_598591 = validateParameter(valid_598591, JString, required = false,
                                 default = nil)
  if valid_598591 != nil:
    section.add "fields", valid_598591
  var valid_598592 = query.getOrDefault("quotaUser")
  valid_598592 = validateParameter(valid_598592, JString, required = false,
                                 default = nil)
  if valid_598592 != nil:
    section.add "quotaUser", valid_598592
  var valid_598593 = query.getOrDefault("alt")
  valid_598593 = validateParameter(valid_598593, JString, required = false,
                                 default = newJString("json"))
  if valid_598593 != nil:
    section.add "alt", valid_598593
  var valid_598594 = query.getOrDefault("oauth_token")
  valid_598594 = validateParameter(valid_598594, JString, required = false,
                                 default = nil)
  if valid_598594 != nil:
    section.add "oauth_token", valid_598594
  var valid_598595 = query.getOrDefault("userIp")
  valid_598595 = validateParameter(valid_598595, JString, required = false,
                                 default = nil)
  if valid_598595 != nil:
    section.add "userIp", valid_598595
  var valid_598596 = query.getOrDefault("source")
  valid_598596 = validateParameter(valid_598596, JString, required = false,
                                 default = nil)
  if valid_598596 != nil:
    section.add "source", valid_598596
  var valid_598597 = query.getOrDefault("key")
  valid_598597 = validateParameter(valid_598597, JString, required = false,
                                 default = nil)
  if valid_598597 != nil:
    section.add "key", valid_598597
  var valid_598598 = query.getOrDefault("prettyPrint")
  valid_598598 = validateParameter(valid_598598, JBool, required = false,
                                 default = newJBool(true))
  if valid_598598 != nil:
    section.add "prettyPrint", valid_598598
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598599: Call_BooksBookshelvesGet_598586; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves metadata for a specific bookshelf for the specified user.
  ## 
  let valid = call_598599.validator(path, query, header, formData, body)
  let scheme = call_598599.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598599.url(scheme.get, call_598599.host, call_598599.base,
                         call_598599.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598599, url, valid)

proc call*(call_598600: Call_BooksBookshelvesGet_598586; shelf: string;
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
  var path_598601 = newJObject()
  var query_598602 = newJObject()
  add(query_598602, "fields", newJString(fields))
  add(query_598602, "quotaUser", newJString(quotaUser))
  add(query_598602, "alt", newJString(alt))
  add(query_598602, "oauth_token", newJString(oauthToken))
  add(query_598602, "userIp", newJString(userIp))
  add(path_598601, "shelf", newJString(shelf))
  add(query_598602, "source", newJString(source))
  add(query_598602, "key", newJString(key))
  add(query_598602, "prettyPrint", newJBool(prettyPrint))
  add(path_598601, "userId", newJString(userId))
  result = call_598600.call(path_598601, query_598602, nil, nil, nil)

var booksBookshelvesGet* = Call_BooksBookshelvesGet_598586(
    name: "booksBookshelvesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userId}/bookshelves/{shelf}",
    validator: validate_BooksBookshelvesGet_598587, base: "/books/v1",
    url: url_BooksBookshelvesGet_598588, schemes: {Scheme.Https})
type
  Call_BooksBookshelvesVolumesList_598603 = ref object of OpenApiRestCall_597437
proc url_BooksBookshelvesVolumesList_598605(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BooksBookshelvesVolumesList_598604(path: JsonNode; query: JsonNode;
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
  var valid_598606 = path.getOrDefault("shelf")
  valid_598606 = validateParameter(valid_598606, JString, required = true,
                                 default = nil)
  if valid_598606 != nil:
    section.add "shelf", valid_598606
  var valid_598607 = path.getOrDefault("userId")
  valid_598607 = validateParameter(valid_598607, JString, required = true,
                                 default = nil)
  if valid_598607 != nil:
    section.add "userId", valid_598607
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
  var valid_598608 = query.getOrDefault("fields")
  valid_598608 = validateParameter(valid_598608, JString, required = false,
                                 default = nil)
  if valid_598608 != nil:
    section.add "fields", valid_598608
  var valid_598609 = query.getOrDefault("quotaUser")
  valid_598609 = validateParameter(valid_598609, JString, required = false,
                                 default = nil)
  if valid_598609 != nil:
    section.add "quotaUser", valid_598609
  var valid_598610 = query.getOrDefault("alt")
  valid_598610 = validateParameter(valid_598610, JString, required = false,
                                 default = newJString("json"))
  if valid_598610 != nil:
    section.add "alt", valid_598610
  var valid_598611 = query.getOrDefault("oauth_token")
  valid_598611 = validateParameter(valid_598611, JString, required = false,
                                 default = nil)
  if valid_598611 != nil:
    section.add "oauth_token", valid_598611
  var valid_598612 = query.getOrDefault("userIp")
  valid_598612 = validateParameter(valid_598612, JString, required = false,
                                 default = nil)
  if valid_598612 != nil:
    section.add "userIp", valid_598612
  var valid_598613 = query.getOrDefault("maxResults")
  valid_598613 = validateParameter(valid_598613, JInt, required = false, default = nil)
  if valid_598613 != nil:
    section.add "maxResults", valid_598613
  var valid_598614 = query.getOrDefault("source")
  valid_598614 = validateParameter(valid_598614, JString, required = false,
                                 default = nil)
  if valid_598614 != nil:
    section.add "source", valid_598614
  var valid_598615 = query.getOrDefault("key")
  valid_598615 = validateParameter(valid_598615, JString, required = false,
                                 default = nil)
  if valid_598615 != nil:
    section.add "key", valid_598615
  var valid_598616 = query.getOrDefault("prettyPrint")
  valid_598616 = validateParameter(valid_598616, JBool, required = false,
                                 default = newJBool(true))
  if valid_598616 != nil:
    section.add "prettyPrint", valid_598616
  var valid_598617 = query.getOrDefault("showPreorders")
  valid_598617 = validateParameter(valid_598617, JBool, required = false, default = nil)
  if valid_598617 != nil:
    section.add "showPreorders", valid_598617
  var valid_598618 = query.getOrDefault("startIndex")
  valid_598618 = validateParameter(valid_598618, JInt, required = false, default = nil)
  if valid_598618 != nil:
    section.add "startIndex", valid_598618
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598619: Call_BooksBookshelvesVolumesList_598603; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves volumes in a specific bookshelf for the specified user.
  ## 
  let valid = call_598619.validator(path, query, header, formData, body)
  let scheme = call_598619.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598619.url(scheme.get, call_598619.host, call_598619.base,
                         call_598619.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598619, url, valid)

proc call*(call_598620: Call_BooksBookshelvesVolumesList_598603; shelf: string;
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
  var path_598621 = newJObject()
  var query_598622 = newJObject()
  add(query_598622, "fields", newJString(fields))
  add(query_598622, "quotaUser", newJString(quotaUser))
  add(query_598622, "alt", newJString(alt))
  add(query_598622, "oauth_token", newJString(oauthToken))
  add(query_598622, "userIp", newJString(userIp))
  add(path_598621, "shelf", newJString(shelf))
  add(query_598622, "maxResults", newJInt(maxResults))
  add(query_598622, "source", newJString(source))
  add(query_598622, "key", newJString(key))
  add(query_598622, "prettyPrint", newJBool(prettyPrint))
  add(query_598622, "showPreorders", newJBool(showPreorders))
  add(path_598621, "userId", newJString(userId))
  add(query_598622, "startIndex", newJInt(startIndex))
  result = call_598620.call(path_598621, query_598622, nil, nil, nil)

var booksBookshelvesVolumesList* = Call_BooksBookshelvesVolumesList_598603(
    name: "booksBookshelvesVolumesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/users/{userId}/bookshelves/{shelf}/volumes",
    validator: validate_BooksBookshelvesVolumesList_598604, base: "/books/v1",
    url: url_BooksBookshelvesVolumesList_598605, schemes: {Scheme.Https})
type
  Call_BooksVolumesList_598623 = ref object of OpenApiRestCall_597437
proc url_BooksVolumesList_598625(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BooksVolumesList_598624(path: JsonNode; query: JsonNode;
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
  var valid_598626 = query.getOrDefault("libraryRestrict")
  valid_598626 = validateParameter(valid_598626, JString, required = false,
                                 default = newJString("my-library"))
  if valid_598626 != nil:
    section.add "libraryRestrict", valid_598626
  var valid_598627 = query.getOrDefault("fields")
  valid_598627 = validateParameter(valid_598627, JString, required = false,
                                 default = nil)
  if valid_598627 != nil:
    section.add "fields", valid_598627
  var valid_598628 = query.getOrDefault("quotaUser")
  valid_598628 = validateParameter(valid_598628, JString, required = false,
                                 default = nil)
  if valid_598628 != nil:
    section.add "quotaUser", valid_598628
  var valid_598629 = query.getOrDefault("alt")
  valid_598629 = validateParameter(valid_598629, JString, required = false,
                                 default = newJString("json"))
  if valid_598629 != nil:
    section.add "alt", valid_598629
  var valid_598630 = query.getOrDefault("oauth_token")
  valid_598630 = validateParameter(valid_598630, JString, required = false,
                                 default = nil)
  if valid_598630 != nil:
    section.add "oauth_token", valid_598630
  var valid_598631 = query.getOrDefault("userIp")
  valid_598631 = validateParameter(valid_598631, JString, required = false,
                                 default = nil)
  if valid_598631 != nil:
    section.add "userIp", valid_598631
  var valid_598632 = query.getOrDefault("langRestrict")
  valid_598632 = validateParameter(valid_598632, JString, required = false,
                                 default = nil)
  if valid_598632 != nil:
    section.add "langRestrict", valid_598632
  var valid_598633 = query.getOrDefault("maxResults")
  valid_598633 = validateParameter(valid_598633, JInt, required = false, default = nil)
  if valid_598633 != nil:
    section.add "maxResults", valid_598633
  var valid_598634 = query.getOrDefault("orderBy")
  valid_598634 = validateParameter(valid_598634, JString, required = false,
                                 default = newJString("newest"))
  if valid_598634 != nil:
    section.add "orderBy", valid_598634
  var valid_598635 = query.getOrDefault("source")
  valid_598635 = validateParameter(valid_598635, JString, required = false,
                                 default = nil)
  if valid_598635 != nil:
    section.add "source", valid_598635
  assert query != nil, "query argument is necessary due to required `q` field"
  var valid_598636 = query.getOrDefault("q")
  valid_598636 = validateParameter(valid_598636, JString, required = true,
                                 default = nil)
  if valid_598636 != nil:
    section.add "q", valid_598636
  var valid_598637 = query.getOrDefault("key")
  valid_598637 = validateParameter(valid_598637, JString, required = false,
                                 default = nil)
  if valid_598637 != nil:
    section.add "key", valid_598637
  var valid_598638 = query.getOrDefault("projection")
  valid_598638 = validateParameter(valid_598638, JString, required = false,
                                 default = newJString("full"))
  if valid_598638 != nil:
    section.add "projection", valid_598638
  var valid_598639 = query.getOrDefault("partner")
  valid_598639 = validateParameter(valid_598639, JString, required = false,
                                 default = nil)
  if valid_598639 != nil:
    section.add "partner", valid_598639
  var valid_598640 = query.getOrDefault("download")
  valid_598640 = validateParameter(valid_598640, JString, required = false,
                                 default = newJString("epub"))
  if valid_598640 != nil:
    section.add "download", valid_598640
  var valid_598641 = query.getOrDefault("prettyPrint")
  valid_598641 = validateParameter(valid_598641, JBool, required = false,
                                 default = newJBool(true))
  if valid_598641 != nil:
    section.add "prettyPrint", valid_598641
  var valid_598642 = query.getOrDefault("maxAllowedMaturityRating")
  valid_598642 = validateParameter(valid_598642, JString, required = false,
                                 default = newJString("mature"))
  if valid_598642 != nil:
    section.add "maxAllowedMaturityRating", valid_598642
  var valid_598643 = query.getOrDefault("showPreorders")
  valid_598643 = validateParameter(valid_598643, JBool, required = false, default = nil)
  if valid_598643 != nil:
    section.add "showPreorders", valid_598643
  var valid_598644 = query.getOrDefault("filter")
  valid_598644 = validateParameter(valid_598644, JString, required = false,
                                 default = newJString("ebooks"))
  if valid_598644 != nil:
    section.add "filter", valid_598644
  var valid_598645 = query.getOrDefault("printType")
  valid_598645 = validateParameter(valid_598645, JString, required = false,
                                 default = newJString("all"))
  if valid_598645 != nil:
    section.add "printType", valid_598645
  var valid_598646 = query.getOrDefault("startIndex")
  valid_598646 = validateParameter(valid_598646, JInt, required = false, default = nil)
  if valid_598646 != nil:
    section.add "startIndex", valid_598646
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598647: Call_BooksVolumesList_598623; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs a book search.
  ## 
  let valid = call_598647.validator(path, query, header, formData, body)
  let scheme = call_598647.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598647.url(scheme.get, call_598647.host, call_598647.base,
                         call_598647.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598647, url, valid)

proc call*(call_598648: Call_BooksVolumesList_598623; q: string;
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
  var query_598649 = newJObject()
  add(query_598649, "libraryRestrict", newJString(libraryRestrict))
  add(query_598649, "fields", newJString(fields))
  add(query_598649, "quotaUser", newJString(quotaUser))
  add(query_598649, "alt", newJString(alt))
  add(query_598649, "oauth_token", newJString(oauthToken))
  add(query_598649, "userIp", newJString(userIp))
  add(query_598649, "langRestrict", newJString(langRestrict))
  add(query_598649, "maxResults", newJInt(maxResults))
  add(query_598649, "orderBy", newJString(orderBy))
  add(query_598649, "source", newJString(source))
  add(query_598649, "q", newJString(q))
  add(query_598649, "key", newJString(key))
  add(query_598649, "projection", newJString(projection))
  add(query_598649, "partner", newJString(partner))
  add(query_598649, "download", newJString(download))
  add(query_598649, "prettyPrint", newJBool(prettyPrint))
  add(query_598649, "maxAllowedMaturityRating",
      newJString(maxAllowedMaturityRating))
  add(query_598649, "showPreorders", newJBool(showPreorders))
  add(query_598649, "filter", newJString(filter))
  add(query_598649, "printType", newJString(printType))
  add(query_598649, "startIndex", newJInt(startIndex))
  result = call_598648.call(nil, query_598649, nil, nil, nil)

var booksVolumesList* = Call_BooksVolumesList_598623(name: "booksVolumesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/volumes",
    validator: validate_BooksVolumesList_598624, base: "/books/v1",
    url: url_BooksVolumesList_598625, schemes: {Scheme.Https})
type
  Call_BooksVolumesMybooksList_598650 = ref object of OpenApiRestCall_597437
proc url_BooksVolumesMybooksList_598652(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BooksVolumesMybooksList_598651(path: JsonNode; query: JsonNode;
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
  var valid_598653 = query.getOrDefault("locale")
  valid_598653 = validateParameter(valid_598653, JString, required = false,
                                 default = nil)
  if valid_598653 != nil:
    section.add "locale", valid_598653
  var valid_598654 = query.getOrDefault("fields")
  valid_598654 = validateParameter(valid_598654, JString, required = false,
                                 default = nil)
  if valid_598654 != nil:
    section.add "fields", valid_598654
  var valid_598655 = query.getOrDefault("country")
  valid_598655 = validateParameter(valid_598655, JString, required = false,
                                 default = nil)
  if valid_598655 != nil:
    section.add "country", valid_598655
  var valid_598656 = query.getOrDefault("quotaUser")
  valid_598656 = validateParameter(valid_598656, JString, required = false,
                                 default = nil)
  if valid_598656 != nil:
    section.add "quotaUser", valid_598656
  var valid_598657 = query.getOrDefault("processingState")
  valid_598657 = validateParameter(valid_598657, JArray, required = false,
                                 default = nil)
  if valid_598657 != nil:
    section.add "processingState", valid_598657
  var valid_598658 = query.getOrDefault("alt")
  valid_598658 = validateParameter(valid_598658, JString, required = false,
                                 default = newJString("json"))
  if valid_598658 != nil:
    section.add "alt", valid_598658
  var valid_598659 = query.getOrDefault("oauth_token")
  valid_598659 = validateParameter(valid_598659, JString, required = false,
                                 default = nil)
  if valid_598659 != nil:
    section.add "oauth_token", valid_598659
  var valid_598660 = query.getOrDefault("userIp")
  valid_598660 = validateParameter(valid_598660, JString, required = false,
                                 default = nil)
  if valid_598660 != nil:
    section.add "userIp", valid_598660
  var valid_598661 = query.getOrDefault("maxResults")
  valid_598661 = validateParameter(valid_598661, JInt, required = false, default = nil)
  if valid_598661 != nil:
    section.add "maxResults", valid_598661
  var valid_598662 = query.getOrDefault("source")
  valid_598662 = validateParameter(valid_598662, JString, required = false,
                                 default = nil)
  if valid_598662 != nil:
    section.add "source", valid_598662
  var valid_598663 = query.getOrDefault("key")
  valid_598663 = validateParameter(valid_598663, JString, required = false,
                                 default = nil)
  if valid_598663 != nil:
    section.add "key", valid_598663
  var valid_598664 = query.getOrDefault("acquireMethod")
  valid_598664 = validateParameter(valid_598664, JArray, required = false,
                                 default = nil)
  if valid_598664 != nil:
    section.add "acquireMethod", valid_598664
  var valid_598665 = query.getOrDefault("prettyPrint")
  valid_598665 = validateParameter(valid_598665, JBool, required = false,
                                 default = newJBool(true))
  if valid_598665 != nil:
    section.add "prettyPrint", valid_598665
  var valid_598666 = query.getOrDefault("startIndex")
  valid_598666 = validateParameter(valid_598666, JInt, required = false, default = nil)
  if valid_598666 != nil:
    section.add "startIndex", valid_598666
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598667: Call_BooksVolumesMybooksList_598650; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return a list of books in My Library.
  ## 
  let valid = call_598667.validator(path, query, header, formData, body)
  let scheme = call_598667.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598667.url(scheme.get, call_598667.host, call_598667.base,
                         call_598667.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598667, url, valid)

proc call*(call_598668: Call_BooksVolumesMybooksList_598650; locale: string = "";
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
  var query_598669 = newJObject()
  add(query_598669, "locale", newJString(locale))
  add(query_598669, "fields", newJString(fields))
  add(query_598669, "country", newJString(country))
  add(query_598669, "quotaUser", newJString(quotaUser))
  if processingState != nil:
    query_598669.add "processingState", processingState
  add(query_598669, "alt", newJString(alt))
  add(query_598669, "oauth_token", newJString(oauthToken))
  add(query_598669, "userIp", newJString(userIp))
  add(query_598669, "maxResults", newJInt(maxResults))
  add(query_598669, "source", newJString(source))
  add(query_598669, "key", newJString(key))
  if acquireMethod != nil:
    query_598669.add "acquireMethod", acquireMethod
  add(query_598669, "prettyPrint", newJBool(prettyPrint))
  add(query_598669, "startIndex", newJInt(startIndex))
  result = call_598668.call(nil, query_598669, nil, nil, nil)

var booksVolumesMybooksList* = Call_BooksVolumesMybooksList_598650(
    name: "booksVolumesMybooksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/volumes/mybooks",
    validator: validate_BooksVolumesMybooksList_598651, base: "/books/v1",
    url: url_BooksVolumesMybooksList_598652, schemes: {Scheme.Https})
type
  Call_BooksVolumesRecommendedList_598670 = ref object of OpenApiRestCall_597437
proc url_BooksVolumesRecommendedList_598672(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BooksVolumesRecommendedList_598671(path: JsonNode; query: JsonNode;
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
  var valid_598673 = query.getOrDefault("locale")
  valid_598673 = validateParameter(valid_598673, JString, required = false,
                                 default = nil)
  if valid_598673 != nil:
    section.add "locale", valid_598673
  var valid_598674 = query.getOrDefault("fields")
  valid_598674 = validateParameter(valid_598674, JString, required = false,
                                 default = nil)
  if valid_598674 != nil:
    section.add "fields", valid_598674
  var valid_598675 = query.getOrDefault("quotaUser")
  valid_598675 = validateParameter(valid_598675, JString, required = false,
                                 default = nil)
  if valid_598675 != nil:
    section.add "quotaUser", valid_598675
  var valid_598676 = query.getOrDefault("alt")
  valid_598676 = validateParameter(valid_598676, JString, required = false,
                                 default = newJString("json"))
  if valid_598676 != nil:
    section.add "alt", valid_598676
  var valid_598677 = query.getOrDefault("oauth_token")
  valid_598677 = validateParameter(valid_598677, JString, required = false,
                                 default = nil)
  if valid_598677 != nil:
    section.add "oauth_token", valid_598677
  var valid_598678 = query.getOrDefault("userIp")
  valid_598678 = validateParameter(valid_598678, JString, required = false,
                                 default = nil)
  if valid_598678 != nil:
    section.add "userIp", valid_598678
  var valid_598679 = query.getOrDefault("source")
  valid_598679 = validateParameter(valid_598679, JString, required = false,
                                 default = nil)
  if valid_598679 != nil:
    section.add "source", valid_598679
  var valid_598680 = query.getOrDefault("key")
  valid_598680 = validateParameter(valid_598680, JString, required = false,
                                 default = nil)
  if valid_598680 != nil:
    section.add "key", valid_598680
  var valid_598681 = query.getOrDefault("prettyPrint")
  valid_598681 = validateParameter(valid_598681, JBool, required = false,
                                 default = newJBool(true))
  if valid_598681 != nil:
    section.add "prettyPrint", valid_598681
  var valid_598682 = query.getOrDefault("maxAllowedMaturityRating")
  valid_598682 = validateParameter(valid_598682, JString, required = false,
                                 default = newJString("mature"))
  if valid_598682 != nil:
    section.add "maxAllowedMaturityRating", valid_598682
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598683: Call_BooksVolumesRecommendedList_598670; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return a list of recommended books for the current user.
  ## 
  let valid = call_598683.validator(path, query, header, formData, body)
  let scheme = call_598683.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598683.url(scheme.get, call_598683.host, call_598683.base,
                         call_598683.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598683, url, valid)

proc call*(call_598684: Call_BooksVolumesRecommendedList_598670;
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
  var query_598685 = newJObject()
  add(query_598685, "locale", newJString(locale))
  add(query_598685, "fields", newJString(fields))
  add(query_598685, "quotaUser", newJString(quotaUser))
  add(query_598685, "alt", newJString(alt))
  add(query_598685, "oauth_token", newJString(oauthToken))
  add(query_598685, "userIp", newJString(userIp))
  add(query_598685, "source", newJString(source))
  add(query_598685, "key", newJString(key))
  add(query_598685, "prettyPrint", newJBool(prettyPrint))
  add(query_598685, "maxAllowedMaturityRating",
      newJString(maxAllowedMaturityRating))
  result = call_598684.call(nil, query_598685, nil, nil, nil)

var booksVolumesRecommendedList* = Call_BooksVolumesRecommendedList_598670(
    name: "booksVolumesRecommendedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/volumes/recommended",
    validator: validate_BooksVolumesRecommendedList_598671, base: "/books/v1",
    url: url_BooksVolumesRecommendedList_598672, schemes: {Scheme.Https})
type
  Call_BooksVolumesRecommendedRate_598686 = ref object of OpenApiRestCall_597437
proc url_BooksVolumesRecommendedRate_598688(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BooksVolumesRecommendedRate_598687(path: JsonNode; query: JsonNode;
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
  var valid_598689 = query.getOrDefault("locale")
  valid_598689 = validateParameter(valid_598689, JString, required = false,
                                 default = nil)
  if valid_598689 != nil:
    section.add "locale", valid_598689
  var valid_598690 = query.getOrDefault("fields")
  valid_598690 = validateParameter(valid_598690, JString, required = false,
                                 default = nil)
  if valid_598690 != nil:
    section.add "fields", valid_598690
  var valid_598691 = query.getOrDefault("quotaUser")
  valid_598691 = validateParameter(valid_598691, JString, required = false,
                                 default = nil)
  if valid_598691 != nil:
    section.add "quotaUser", valid_598691
  var valid_598692 = query.getOrDefault("alt")
  valid_598692 = validateParameter(valid_598692, JString, required = false,
                                 default = newJString("json"))
  if valid_598692 != nil:
    section.add "alt", valid_598692
  assert query != nil, "query argument is necessary due to required `rating` field"
  var valid_598693 = query.getOrDefault("rating")
  valid_598693 = validateParameter(valid_598693, JString, required = true,
                                 default = newJString("HAVE_IT"))
  if valid_598693 != nil:
    section.add "rating", valid_598693
  var valid_598694 = query.getOrDefault("oauth_token")
  valid_598694 = validateParameter(valid_598694, JString, required = false,
                                 default = nil)
  if valid_598694 != nil:
    section.add "oauth_token", valid_598694
  var valid_598695 = query.getOrDefault("userIp")
  valid_598695 = validateParameter(valid_598695, JString, required = false,
                                 default = nil)
  if valid_598695 != nil:
    section.add "userIp", valid_598695
  var valid_598696 = query.getOrDefault("source")
  valid_598696 = validateParameter(valid_598696, JString, required = false,
                                 default = nil)
  if valid_598696 != nil:
    section.add "source", valid_598696
  var valid_598697 = query.getOrDefault("key")
  valid_598697 = validateParameter(valid_598697, JString, required = false,
                                 default = nil)
  if valid_598697 != nil:
    section.add "key", valid_598697
  var valid_598698 = query.getOrDefault("volumeId")
  valid_598698 = validateParameter(valid_598698, JString, required = true,
                                 default = nil)
  if valid_598698 != nil:
    section.add "volumeId", valid_598698
  var valid_598699 = query.getOrDefault("prettyPrint")
  valid_598699 = validateParameter(valid_598699, JBool, required = false,
                                 default = newJBool(true))
  if valid_598699 != nil:
    section.add "prettyPrint", valid_598699
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598700: Call_BooksVolumesRecommendedRate_598686; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rate a recommended book for the current user.
  ## 
  let valid = call_598700.validator(path, query, header, formData, body)
  let scheme = call_598700.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598700.url(scheme.get, call_598700.host, call_598700.base,
                         call_598700.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598700, url, valid)

proc call*(call_598701: Call_BooksVolumesRecommendedRate_598686; volumeId: string;
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
  var query_598702 = newJObject()
  add(query_598702, "locale", newJString(locale))
  add(query_598702, "fields", newJString(fields))
  add(query_598702, "quotaUser", newJString(quotaUser))
  add(query_598702, "alt", newJString(alt))
  add(query_598702, "rating", newJString(rating))
  add(query_598702, "oauth_token", newJString(oauthToken))
  add(query_598702, "userIp", newJString(userIp))
  add(query_598702, "source", newJString(source))
  add(query_598702, "key", newJString(key))
  add(query_598702, "volumeId", newJString(volumeId))
  add(query_598702, "prettyPrint", newJBool(prettyPrint))
  result = call_598701.call(nil, query_598702, nil, nil, nil)

var booksVolumesRecommendedRate* = Call_BooksVolumesRecommendedRate_598686(
    name: "booksVolumesRecommendedRate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/volumes/recommended/rate",
    validator: validate_BooksVolumesRecommendedRate_598687, base: "/books/v1",
    url: url_BooksVolumesRecommendedRate_598688, schemes: {Scheme.Https})
type
  Call_BooksVolumesUseruploadedList_598703 = ref object of OpenApiRestCall_597437
proc url_BooksVolumesUseruploadedList_598705(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BooksVolumesUseruploadedList_598704(path: JsonNode; query: JsonNode;
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
  var valid_598706 = query.getOrDefault("locale")
  valid_598706 = validateParameter(valid_598706, JString, required = false,
                                 default = nil)
  if valid_598706 != nil:
    section.add "locale", valid_598706
  var valid_598707 = query.getOrDefault("fields")
  valid_598707 = validateParameter(valid_598707, JString, required = false,
                                 default = nil)
  if valid_598707 != nil:
    section.add "fields", valid_598707
  var valid_598708 = query.getOrDefault("quotaUser")
  valid_598708 = validateParameter(valid_598708, JString, required = false,
                                 default = nil)
  if valid_598708 != nil:
    section.add "quotaUser", valid_598708
  var valid_598709 = query.getOrDefault("processingState")
  valid_598709 = validateParameter(valid_598709, JArray, required = false,
                                 default = nil)
  if valid_598709 != nil:
    section.add "processingState", valid_598709
  var valid_598710 = query.getOrDefault("alt")
  valid_598710 = validateParameter(valid_598710, JString, required = false,
                                 default = newJString("json"))
  if valid_598710 != nil:
    section.add "alt", valid_598710
  var valid_598711 = query.getOrDefault("oauth_token")
  valid_598711 = validateParameter(valid_598711, JString, required = false,
                                 default = nil)
  if valid_598711 != nil:
    section.add "oauth_token", valid_598711
  var valid_598712 = query.getOrDefault("userIp")
  valid_598712 = validateParameter(valid_598712, JString, required = false,
                                 default = nil)
  if valid_598712 != nil:
    section.add "userIp", valid_598712
  var valid_598713 = query.getOrDefault("maxResults")
  valid_598713 = validateParameter(valid_598713, JInt, required = false, default = nil)
  if valid_598713 != nil:
    section.add "maxResults", valid_598713
  var valid_598714 = query.getOrDefault("source")
  valid_598714 = validateParameter(valid_598714, JString, required = false,
                                 default = nil)
  if valid_598714 != nil:
    section.add "source", valid_598714
  var valid_598715 = query.getOrDefault("key")
  valid_598715 = validateParameter(valid_598715, JString, required = false,
                                 default = nil)
  if valid_598715 != nil:
    section.add "key", valid_598715
  var valid_598716 = query.getOrDefault("volumeId")
  valid_598716 = validateParameter(valid_598716, JArray, required = false,
                                 default = nil)
  if valid_598716 != nil:
    section.add "volumeId", valid_598716
  var valid_598717 = query.getOrDefault("prettyPrint")
  valid_598717 = validateParameter(valid_598717, JBool, required = false,
                                 default = newJBool(true))
  if valid_598717 != nil:
    section.add "prettyPrint", valid_598717
  var valid_598718 = query.getOrDefault("startIndex")
  valid_598718 = validateParameter(valid_598718, JInt, required = false, default = nil)
  if valid_598718 != nil:
    section.add "startIndex", valid_598718
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598719: Call_BooksVolumesUseruploadedList_598703; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return a list of books uploaded by the current user.
  ## 
  let valid = call_598719.validator(path, query, header, formData, body)
  let scheme = call_598719.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598719.url(scheme.get, call_598719.host, call_598719.base,
                         call_598719.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598719, url, valid)

proc call*(call_598720: Call_BooksVolumesUseruploadedList_598703;
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
  var query_598721 = newJObject()
  add(query_598721, "locale", newJString(locale))
  add(query_598721, "fields", newJString(fields))
  add(query_598721, "quotaUser", newJString(quotaUser))
  if processingState != nil:
    query_598721.add "processingState", processingState
  add(query_598721, "alt", newJString(alt))
  add(query_598721, "oauth_token", newJString(oauthToken))
  add(query_598721, "userIp", newJString(userIp))
  add(query_598721, "maxResults", newJInt(maxResults))
  add(query_598721, "source", newJString(source))
  add(query_598721, "key", newJString(key))
  if volumeId != nil:
    query_598721.add "volumeId", volumeId
  add(query_598721, "prettyPrint", newJBool(prettyPrint))
  add(query_598721, "startIndex", newJInt(startIndex))
  result = call_598720.call(nil, query_598721, nil, nil, nil)

var booksVolumesUseruploadedList* = Call_BooksVolumesUseruploadedList_598703(
    name: "booksVolumesUseruploadedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/volumes/useruploaded",
    validator: validate_BooksVolumesUseruploadedList_598704, base: "/books/v1",
    url: url_BooksVolumesUseruploadedList_598705, schemes: {Scheme.Https})
type
  Call_BooksVolumesGet_598722 = ref object of OpenApiRestCall_597437
proc url_BooksVolumesGet_598724(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "volumeId" in path, "`volumeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/volumes/"),
               (kind: VariableSegment, value: "volumeId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BooksVolumesGet_598723(path: JsonNode; query: JsonNode;
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
  var valid_598725 = path.getOrDefault("volumeId")
  valid_598725 = validateParameter(valid_598725, JString, required = true,
                                 default = nil)
  if valid_598725 != nil:
    section.add "volumeId", valid_598725
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
  var valid_598726 = query.getOrDefault("fields")
  valid_598726 = validateParameter(valid_598726, JString, required = false,
                                 default = nil)
  if valid_598726 != nil:
    section.add "fields", valid_598726
  var valid_598727 = query.getOrDefault("country")
  valid_598727 = validateParameter(valid_598727, JString, required = false,
                                 default = nil)
  if valid_598727 != nil:
    section.add "country", valid_598727
  var valid_598728 = query.getOrDefault("quotaUser")
  valid_598728 = validateParameter(valid_598728, JString, required = false,
                                 default = nil)
  if valid_598728 != nil:
    section.add "quotaUser", valid_598728
  var valid_598729 = query.getOrDefault("alt")
  valid_598729 = validateParameter(valid_598729, JString, required = false,
                                 default = newJString("json"))
  if valid_598729 != nil:
    section.add "alt", valid_598729
  var valid_598730 = query.getOrDefault("oauth_token")
  valid_598730 = validateParameter(valid_598730, JString, required = false,
                                 default = nil)
  if valid_598730 != nil:
    section.add "oauth_token", valid_598730
  var valid_598731 = query.getOrDefault("includeNonComicsSeries")
  valid_598731 = validateParameter(valid_598731, JBool, required = false, default = nil)
  if valid_598731 != nil:
    section.add "includeNonComicsSeries", valid_598731
  var valid_598732 = query.getOrDefault("userIp")
  valid_598732 = validateParameter(valid_598732, JString, required = false,
                                 default = nil)
  if valid_598732 != nil:
    section.add "userIp", valid_598732
  var valid_598733 = query.getOrDefault("source")
  valid_598733 = validateParameter(valid_598733, JString, required = false,
                                 default = nil)
  if valid_598733 != nil:
    section.add "source", valid_598733
  var valid_598734 = query.getOrDefault("key")
  valid_598734 = validateParameter(valid_598734, JString, required = false,
                                 default = nil)
  if valid_598734 != nil:
    section.add "key", valid_598734
  var valid_598735 = query.getOrDefault("projection")
  valid_598735 = validateParameter(valid_598735, JString, required = false,
                                 default = newJString("full"))
  if valid_598735 != nil:
    section.add "projection", valid_598735
  var valid_598736 = query.getOrDefault("partner")
  valid_598736 = validateParameter(valid_598736, JString, required = false,
                                 default = nil)
  if valid_598736 != nil:
    section.add "partner", valid_598736
  var valid_598737 = query.getOrDefault("user_library_consistent_read")
  valid_598737 = validateParameter(valid_598737, JBool, required = false, default = nil)
  if valid_598737 != nil:
    section.add "user_library_consistent_read", valid_598737
  var valid_598738 = query.getOrDefault("prettyPrint")
  valid_598738 = validateParameter(valid_598738, JBool, required = false,
                                 default = newJBool(true))
  if valid_598738 != nil:
    section.add "prettyPrint", valid_598738
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598739: Call_BooksVolumesGet_598722; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets volume information for a single volume.
  ## 
  let valid = call_598739.validator(path, query, header, formData, body)
  let scheme = call_598739.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598739.url(scheme.get, call_598739.host, call_598739.base,
                         call_598739.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598739, url, valid)

proc call*(call_598740: Call_BooksVolumesGet_598722; volumeId: string;
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
  var path_598741 = newJObject()
  var query_598742 = newJObject()
  add(query_598742, "fields", newJString(fields))
  add(query_598742, "country", newJString(country))
  add(query_598742, "quotaUser", newJString(quotaUser))
  add(query_598742, "alt", newJString(alt))
  add(query_598742, "oauth_token", newJString(oauthToken))
  add(query_598742, "includeNonComicsSeries", newJBool(includeNonComicsSeries))
  add(query_598742, "userIp", newJString(userIp))
  add(query_598742, "source", newJString(source))
  add(query_598742, "key", newJString(key))
  add(path_598741, "volumeId", newJString(volumeId))
  add(query_598742, "projection", newJString(projection))
  add(query_598742, "partner", newJString(partner))
  add(query_598742, "user_library_consistent_read",
      newJBool(userLibraryConsistentRead))
  add(query_598742, "prettyPrint", newJBool(prettyPrint))
  result = call_598740.call(path_598741, query_598742, nil, nil, nil)

var booksVolumesGet* = Call_BooksVolumesGet_598722(name: "booksVolumesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/volumes/{volumeId}", validator: validate_BooksVolumesGet_598723,
    base: "/books/v1", url: url_BooksVolumesGet_598724, schemes: {Scheme.Https})
type
  Call_BooksVolumesAssociatedList_598743 = ref object of OpenApiRestCall_597437
proc url_BooksVolumesAssociatedList_598745(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BooksVolumesAssociatedList_598744(path: JsonNode; query: JsonNode;
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
  var valid_598746 = path.getOrDefault("volumeId")
  valid_598746 = validateParameter(valid_598746, JString, required = true,
                                 default = nil)
  if valid_598746 != nil:
    section.add "volumeId", valid_598746
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
  var valid_598747 = query.getOrDefault("association")
  valid_598747 = validateParameter(valid_598747, JString, required = false,
                                 default = newJString("end-of-sample"))
  if valid_598747 != nil:
    section.add "association", valid_598747
  var valid_598748 = query.getOrDefault("locale")
  valid_598748 = validateParameter(valid_598748, JString, required = false,
                                 default = nil)
  if valid_598748 != nil:
    section.add "locale", valid_598748
  var valid_598749 = query.getOrDefault("fields")
  valid_598749 = validateParameter(valid_598749, JString, required = false,
                                 default = nil)
  if valid_598749 != nil:
    section.add "fields", valid_598749
  var valid_598750 = query.getOrDefault("quotaUser")
  valid_598750 = validateParameter(valid_598750, JString, required = false,
                                 default = nil)
  if valid_598750 != nil:
    section.add "quotaUser", valid_598750
  var valid_598751 = query.getOrDefault("alt")
  valid_598751 = validateParameter(valid_598751, JString, required = false,
                                 default = newJString("json"))
  if valid_598751 != nil:
    section.add "alt", valid_598751
  var valid_598752 = query.getOrDefault("oauth_token")
  valid_598752 = validateParameter(valid_598752, JString, required = false,
                                 default = nil)
  if valid_598752 != nil:
    section.add "oauth_token", valid_598752
  var valid_598753 = query.getOrDefault("userIp")
  valid_598753 = validateParameter(valid_598753, JString, required = false,
                                 default = nil)
  if valid_598753 != nil:
    section.add "userIp", valid_598753
  var valid_598754 = query.getOrDefault("source")
  valid_598754 = validateParameter(valid_598754, JString, required = false,
                                 default = nil)
  if valid_598754 != nil:
    section.add "source", valid_598754
  var valid_598755 = query.getOrDefault("key")
  valid_598755 = validateParameter(valid_598755, JString, required = false,
                                 default = nil)
  if valid_598755 != nil:
    section.add "key", valid_598755
  var valid_598756 = query.getOrDefault("prettyPrint")
  valid_598756 = validateParameter(valid_598756, JBool, required = false,
                                 default = newJBool(true))
  if valid_598756 != nil:
    section.add "prettyPrint", valid_598756
  var valid_598757 = query.getOrDefault("maxAllowedMaturityRating")
  valid_598757 = validateParameter(valid_598757, JString, required = false,
                                 default = newJString("mature"))
  if valid_598757 != nil:
    section.add "maxAllowedMaturityRating", valid_598757
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598758: Call_BooksVolumesAssociatedList_598743; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return a list of associated books.
  ## 
  let valid = call_598758.validator(path, query, header, formData, body)
  let scheme = call_598758.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598758.url(scheme.get, call_598758.host, call_598758.base,
                         call_598758.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598758, url, valid)

proc call*(call_598759: Call_BooksVolumesAssociatedList_598743; volumeId: string;
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
  var path_598760 = newJObject()
  var query_598761 = newJObject()
  add(query_598761, "association", newJString(association))
  add(query_598761, "locale", newJString(locale))
  add(query_598761, "fields", newJString(fields))
  add(query_598761, "quotaUser", newJString(quotaUser))
  add(query_598761, "alt", newJString(alt))
  add(query_598761, "oauth_token", newJString(oauthToken))
  add(query_598761, "userIp", newJString(userIp))
  add(query_598761, "source", newJString(source))
  add(query_598761, "key", newJString(key))
  add(path_598760, "volumeId", newJString(volumeId))
  add(query_598761, "prettyPrint", newJBool(prettyPrint))
  add(query_598761, "maxAllowedMaturityRating",
      newJString(maxAllowedMaturityRating))
  result = call_598759.call(path_598760, query_598761, nil, nil, nil)

var booksVolumesAssociatedList* = Call_BooksVolumesAssociatedList_598743(
    name: "booksVolumesAssociatedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/volumes/{volumeId}/associated",
    validator: validate_BooksVolumesAssociatedList_598744, base: "/books/v1",
    url: url_BooksVolumesAssociatedList_598745, schemes: {Scheme.Https})
type
  Call_BooksLayersVolumeAnnotationsList_598762 = ref object of OpenApiRestCall_597437
proc url_BooksLayersVolumeAnnotationsList_598764(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BooksLayersVolumeAnnotationsList_598763(path: JsonNode;
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
  var valid_598765 = path.getOrDefault("volumeId")
  valid_598765 = validateParameter(valid_598765, JString, required = true,
                                 default = nil)
  if valid_598765 != nil:
    section.add "volumeId", valid_598765
  var valid_598766 = path.getOrDefault("layerId")
  valid_598766 = validateParameter(valid_598766, JString, required = true,
                                 default = nil)
  if valid_598766 != nil:
    section.add "layerId", valid_598766
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
  var valid_598767 = query.getOrDefault("locale")
  valid_598767 = validateParameter(valid_598767, JString, required = false,
                                 default = nil)
  if valid_598767 != nil:
    section.add "locale", valid_598767
  var valid_598768 = query.getOrDefault("fields")
  valid_598768 = validateParameter(valid_598768, JString, required = false,
                                 default = nil)
  if valid_598768 != nil:
    section.add "fields", valid_598768
  var valid_598769 = query.getOrDefault("pageToken")
  valid_598769 = validateParameter(valid_598769, JString, required = false,
                                 default = nil)
  if valid_598769 != nil:
    section.add "pageToken", valid_598769
  var valid_598770 = query.getOrDefault("quotaUser")
  valid_598770 = validateParameter(valid_598770, JString, required = false,
                                 default = nil)
  if valid_598770 != nil:
    section.add "quotaUser", valid_598770
  var valid_598771 = query.getOrDefault("alt")
  valid_598771 = validateParameter(valid_598771, JString, required = false,
                                 default = newJString("json"))
  if valid_598771 != nil:
    section.add "alt", valid_598771
  var valid_598772 = query.getOrDefault("updatedMax")
  valid_598772 = validateParameter(valid_598772, JString, required = false,
                                 default = nil)
  if valid_598772 != nil:
    section.add "updatedMax", valid_598772
  var valid_598773 = query.getOrDefault("oauth_token")
  valid_598773 = validateParameter(valid_598773, JString, required = false,
                                 default = nil)
  if valid_598773 != nil:
    section.add "oauth_token", valid_598773
  var valid_598774 = query.getOrDefault("userIp")
  valid_598774 = validateParameter(valid_598774, JString, required = false,
                                 default = nil)
  if valid_598774 != nil:
    section.add "userIp", valid_598774
  var valid_598775 = query.getOrDefault("maxResults")
  valid_598775 = validateParameter(valid_598775, JInt, required = false, default = nil)
  if valid_598775 != nil:
    section.add "maxResults", valid_598775
  assert query != nil,
        "query argument is necessary due to required `contentVersion` field"
  var valid_598776 = query.getOrDefault("contentVersion")
  valid_598776 = validateParameter(valid_598776, JString, required = true,
                                 default = nil)
  if valid_598776 != nil:
    section.add "contentVersion", valid_598776
  var valid_598777 = query.getOrDefault("showDeleted")
  valid_598777 = validateParameter(valid_598777, JBool, required = false, default = nil)
  if valid_598777 != nil:
    section.add "showDeleted", valid_598777
  var valid_598778 = query.getOrDefault("source")
  valid_598778 = validateParameter(valid_598778, JString, required = false,
                                 default = nil)
  if valid_598778 != nil:
    section.add "source", valid_598778
  var valid_598779 = query.getOrDefault("updatedMin")
  valid_598779 = validateParameter(valid_598779, JString, required = false,
                                 default = nil)
  if valid_598779 != nil:
    section.add "updatedMin", valid_598779
  var valid_598780 = query.getOrDefault("key")
  valid_598780 = validateParameter(valid_598780, JString, required = false,
                                 default = nil)
  if valid_598780 != nil:
    section.add "key", valid_598780
  var valid_598781 = query.getOrDefault("endOffset")
  valid_598781 = validateParameter(valid_598781, JString, required = false,
                                 default = nil)
  if valid_598781 != nil:
    section.add "endOffset", valid_598781
  var valid_598782 = query.getOrDefault("startOffset")
  valid_598782 = validateParameter(valid_598782, JString, required = false,
                                 default = nil)
  if valid_598782 != nil:
    section.add "startOffset", valid_598782
  var valid_598783 = query.getOrDefault("startPosition")
  valid_598783 = validateParameter(valid_598783, JString, required = false,
                                 default = nil)
  if valid_598783 != nil:
    section.add "startPosition", valid_598783
  var valid_598784 = query.getOrDefault("volumeAnnotationsVersion")
  valid_598784 = validateParameter(valid_598784, JString, required = false,
                                 default = nil)
  if valid_598784 != nil:
    section.add "volumeAnnotationsVersion", valid_598784
  var valid_598785 = query.getOrDefault("prettyPrint")
  valid_598785 = validateParameter(valid_598785, JBool, required = false,
                                 default = newJBool(true))
  if valid_598785 != nil:
    section.add "prettyPrint", valid_598785
  var valid_598786 = query.getOrDefault("endPosition")
  valid_598786 = validateParameter(valid_598786, JString, required = false,
                                 default = nil)
  if valid_598786 != nil:
    section.add "endPosition", valid_598786
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598787: Call_BooksLayersVolumeAnnotationsList_598762;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the volume annotations for a volume and layer.
  ## 
  let valid = call_598787.validator(path, query, header, formData, body)
  let scheme = call_598787.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598787.url(scheme.get, call_598787.host, call_598787.base,
                         call_598787.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598787, url, valid)

proc call*(call_598788: Call_BooksLayersVolumeAnnotationsList_598762;
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
  var path_598789 = newJObject()
  var query_598790 = newJObject()
  add(query_598790, "locale", newJString(locale))
  add(query_598790, "fields", newJString(fields))
  add(query_598790, "pageToken", newJString(pageToken))
  add(query_598790, "quotaUser", newJString(quotaUser))
  add(query_598790, "alt", newJString(alt))
  add(query_598790, "updatedMax", newJString(updatedMax))
  add(query_598790, "oauth_token", newJString(oauthToken))
  add(query_598790, "userIp", newJString(userIp))
  add(query_598790, "maxResults", newJInt(maxResults))
  add(query_598790, "contentVersion", newJString(contentVersion))
  add(query_598790, "showDeleted", newJBool(showDeleted))
  add(query_598790, "source", newJString(source))
  add(query_598790, "updatedMin", newJString(updatedMin))
  add(query_598790, "key", newJString(key))
  add(path_598789, "volumeId", newJString(volumeId))
  add(query_598790, "endOffset", newJString(endOffset))
  add(query_598790, "startOffset", newJString(startOffset))
  add(query_598790, "startPosition", newJString(startPosition))
  add(query_598790, "volumeAnnotationsVersion",
      newJString(volumeAnnotationsVersion))
  add(query_598790, "prettyPrint", newJBool(prettyPrint))
  add(query_598790, "endPosition", newJString(endPosition))
  add(path_598789, "layerId", newJString(layerId))
  result = call_598788.call(path_598789, query_598790, nil, nil, nil)

var booksLayersVolumeAnnotationsList* = Call_BooksLayersVolumeAnnotationsList_598762(
    name: "booksLayersVolumeAnnotationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/volumes/{volumeId}/layers/{layerId}",
    validator: validate_BooksLayersVolumeAnnotationsList_598763,
    base: "/books/v1", url: url_BooksLayersVolumeAnnotationsList_598764,
    schemes: {Scheme.Https})
type
  Call_BooksLayersVolumeAnnotationsGet_598791 = ref object of OpenApiRestCall_597437
proc url_BooksLayersVolumeAnnotationsGet_598793(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BooksLayersVolumeAnnotationsGet_598792(path: JsonNode;
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
  var valid_598794 = path.getOrDefault("annotationId")
  valid_598794 = validateParameter(valid_598794, JString, required = true,
                                 default = nil)
  if valid_598794 != nil:
    section.add "annotationId", valid_598794
  var valid_598795 = path.getOrDefault("volumeId")
  valid_598795 = validateParameter(valid_598795, JString, required = true,
                                 default = nil)
  if valid_598795 != nil:
    section.add "volumeId", valid_598795
  var valid_598796 = path.getOrDefault("layerId")
  valid_598796 = validateParameter(valid_598796, JString, required = true,
                                 default = nil)
  if valid_598796 != nil:
    section.add "layerId", valid_598796
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
  var valid_598797 = query.getOrDefault("locale")
  valid_598797 = validateParameter(valid_598797, JString, required = false,
                                 default = nil)
  if valid_598797 != nil:
    section.add "locale", valid_598797
  var valid_598798 = query.getOrDefault("fields")
  valid_598798 = validateParameter(valid_598798, JString, required = false,
                                 default = nil)
  if valid_598798 != nil:
    section.add "fields", valid_598798
  var valid_598799 = query.getOrDefault("quotaUser")
  valid_598799 = validateParameter(valid_598799, JString, required = false,
                                 default = nil)
  if valid_598799 != nil:
    section.add "quotaUser", valid_598799
  var valid_598800 = query.getOrDefault("alt")
  valid_598800 = validateParameter(valid_598800, JString, required = false,
                                 default = newJString("json"))
  if valid_598800 != nil:
    section.add "alt", valid_598800
  var valid_598801 = query.getOrDefault("oauth_token")
  valid_598801 = validateParameter(valid_598801, JString, required = false,
                                 default = nil)
  if valid_598801 != nil:
    section.add "oauth_token", valid_598801
  var valid_598802 = query.getOrDefault("userIp")
  valid_598802 = validateParameter(valid_598802, JString, required = false,
                                 default = nil)
  if valid_598802 != nil:
    section.add "userIp", valid_598802
  var valid_598803 = query.getOrDefault("source")
  valid_598803 = validateParameter(valid_598803, JString, required = false,
                                 default = nil)
  if valid_598803 != nil:
    section.add "source", valid_598803
  var valid_598804 = query.getOrDefault("key")
  valid_598804 = validateParameter(valid_598804, JString, required = false,
                                 default = nil)
  if valid_598804 != nil:
    section.add "key", valid_598804
  var valid_598805 = query.getOrDefault("prettyPrint")
  valid_598805 = validateParameter(valid_598805, JBool, required = false,
                                 default = newJBool(true))
  if valid_598805 != nil:
    section.add "prettyPrint", valid_598805
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598806: Call_BooksLayersVolumeAnnotationsGet_598791;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the volume annotation.
  ## 
  let valid = call_598806.validator(path, query, header, formData, body)
  let scheme = call_598806.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598806.url(scheme.get, call_598806.host, call_598806.base,
                         call_598806.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598806, url, valid)

proc call*(call_598807: Call_BooksLayersVolumeAnnotationsGet_598791;
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
  var path_598808 = newJObject()
  var query_598809 = newJObject()
  add(query_598809, "locale", newJString(locale))
  add(query_598809, "fields", newJString(fields))
  add(query_598809, "quotaUser", newJString(quotaUser))
  add(query_598809, "alt", newJString(alt))
  add(query_598809, "oauth_token", newJString(oauthToken))
  add(path_598808, "annotationId", newJString(annotationId))
  add(query_598809, "userIp", newJString(userIp))
  add(query_598809, "source", newJString(source))
  add(query_598809, "key", newJString(key))
  add(path_598808, "volumeId", newJString(volumeId))
  add(query_598809, "prettyPrint", newJBool(prettyPrint))
  add(path_598808, "layerId", newJString(layerId))
  result = call_598807.call(path_598808, query_598809, nil, nil, nil)

var booksLayersVolumeAnnotationsGet* = Call_BooksLayersVolumeAnnotationsGet_598791(
    name: "booksLayersVolumeAnnotationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/volumes/{volumeId}/layers/{layerId}/annotations/{annotationId}",
    validator: validate_BooksLayersVolumeAnnotationsGet_598792, base: "/books/v1",
    url: url_BooksLayersVolumeAnnotationsGet_598793, schemes: {Scheme.Https})
type
  Call_BooksLayersAnnotationDataList_598810 = ref object of OpenApiRestCall_597437
proc url_BooksLayersAnnotationDataList_598812(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BooksLayersAnnotationDataList_598811(path: JsonNode; query: JsonNode;
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
  var valid_598813 = path.getOrDefault("volumeId")
  valid_598813 = validateParameter(valid_598813, JString, required = true,
                                 default = nil)
  if valid_598813 != nil:
    section.add "volumeId", valid_598813
  var valid_598814 = path.getOrDefault("layerId")
  valid_598814 = validateParameter(valid_598814, JString, required = true,
                                 default = nil)
  if valid_598814 != nil:
    section.add "layerId", valid_598814
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
  var valid_598815 = query.getOrDefault("locale")
  valid_598815 = validateParameter(valid_598815, JString, required = false,
                                 default = nil)
  if valid_598815 != nil:
    section.add "locale", valid_598815
  var valid_598816 = query.getOrDefault("fields")
  valid_598816 = validateParameter(valid_598816, JString, required = false,
                                 default = nil)
  if valid_598816 != nil:
    section.add "fields", valid_598816
  var valid_598817 = query.getOrDefault("pageToken")
  valid_598817 = validateParameter(valid_598817, JString, required = false,
                                 default = nil)
  if valid_598817 != nil:
    section.add "pageToken", valid_598817
  var valid_598818 = query.getOrDefault("quotaUser")
  valid_598818 = validateParameter(valid_598818, JString, required = false,
                                 default = nil)
  if valid_598818 != nil:
    section.add "quotaUser", valid_598818
  var valid_598819 = query.getOrDefault("alt")
  valid_598819 = validateParameter(valid_598819, JString, required = false,
                                 default = newJString("json"))
  if valid_598819 != nil:
    section.add "alt", valid_598819
  var valid_598820 = query.getOrDefault("updatedMax")
  valid_598820 = validateParameter(valid_598820, JString, required = false,
                                 default = nil)
  if valid_598820 != nil:
    section.add "updatedMax", valid_598820
  var valid_598821 = query.getOrDefault("scale")
  valid_598821 = validateParameter(valid_598821, JInt, required = false, default = nil)
  if valid_598821 != nil:
    section.add "scale", valid_598821
  var valid_598822 = query.getOrDefault("oauth_token")
  valid_598822 = validateParameter(valid_598822, JString, required = false,
                                 default = nil)
  if valid_598822 != nil:
    section.add "oauth_token", valid_598822
  var valid_598823 = query.getOrDefault("userIp")
  valid_598823 = validateParameter(valid_598823, JString, required = false,
                                 default = nil)
  if valid_598823 != nil:
    section.add "userIp", valid_598823
  var valid_598824 = query.getOrDefault("maxResults")
  valid_598824 = validateParameter(valid_598824, JInt, required = false, default = nil)
  if valid_598824 != nil:
    section.add "maxResults", valid_598824
  assert query != nil,
        "query argument is necessary due to required `contentVersion` field"
  var valid_598825 = query.getOrDefault("contentVersion")
  valid_598825 = validateParameter(valid_598825, JString, required = true,
                                 default = nil)
  if valid_598825 != nil:
    section.add "contentVersion", valid_598825
  var valid_598826 = query.getOrDefault("source")
  valid_598826 = validateParameter(valid_598826, JString, required = false,
                                 default = nil)
  if valid_598826 != nil:
    section.add "source", valid_598826
  var valid_598827 = query.getOrDefault("updatedMin")
  valid_598827 = validateParameter(valid_598827, JString, required = false,
                                 default = nil)
  if valid_598827 != nil:
    section.add "updatedMin", valid_598827
  var valid_598828 = query.getOrDefault("key")
  valid_598828 = validateParameter(valid_598828, JString, required = false,
                                 default = nil)
  if valid_598828 != nil:
    section.add "key", valid_598828
  var valid_598829 = query.getOrDefault("w")
  valid_598829 = validateParameter(valid_598829, JInt, required = false, default = nil)
  if valid_598829 != nil:
    section.add "w", valid_598829
  var valid_598830 = query.getOrDefault("annotationDataId")
  valid_598830 = validateParameter(valid_598830, JArray, required = false,
                                 default = nil)
  if valid_598830 != nil:
    section.add "annotationDataId", valid_598830
  var valid_598831 = query.getOrDefault("prettyPrint")
  valid_598831 = validateParameter(valid_598831, JBool, required = false,
                                 default = newJBool(true))
  if valid_598831 != nil:
    section.add "prettyPrint", valid_598831
  var valid_598832 = query.getOrDefault("h")
  valid_598832 = validateParameter(valid_598832, JInt, required = false, default = nil)
  if valid_598832 != nil:
    section.add "h", valid_598832
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598833: Call_BooksLayersAnnotationDataList_598810; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the annotation data for a volume and layer.
  ## 
  let valid = call_598833.validator(path, query, header, formData, body)
  let scheme = call_598833.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598833.url(scheme.get, call_598833.host, call_598833.base,
                         call_598833.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598833, url, valid)

proc call*(call_598834: Call_BooksLayersAnnotationDataList_598810;
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
  var path_598835 = newJObject()
  var query_598836 = newJObject()
  add(query_598836, "locale", newJString(locale))
  add(query_598836, "fields", newJString(fields))
  add(query_598836, "pageToken", newJString(pageToken))
  add(query_598836, "quotaUser", newJString(quotaUser))
  add(query_598836, "alt", newJString(alt))
  add(query_598836, "updatedMax", newJString(updatedMax))
  add(query_598836, "scale", newJInt(scale))
  add(query_598836, "oauth_token", newJString(oauthToken))
  add(query_598836, "userIp", newJString(userIp))
  add(query_598836, "maxResults", newJInt(maxResults))
  add(query_598836, "contentVersion", newJString(contentVersion))
  add(query_598836, "source", newJString(source))
  add(query_598836, "updatedMin", newJString(updatedMin))
  add(query_598836, "key", newJString(key))
  add(path_598835, "volumeId", newJString(volumeId))
  add(query_598836, "w", newJInt(w))
  if annotationDataId != nil:
    query_598836.add "annotationDataId", annotationDataId
  add(query_598836, "prettyPrint", newJBool(prettyPrint))
  add(query_598836, "h", newJInt(h))
  add(path_598835, "layerId", newJString(layerId))
  result = call_598834.call(path_598835, query_598836, nil, nil, nil)

var booksLayersAnnotationDataList* = Call_BooksLayersAnnotationDataList_598810(
    name: "booksLayersAnnotationDataList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/volumes/{volumeId}/layers/{layerId}/data",
    validator: validate_BooksLayersAnnotationDataList_598811, base: "/books/v1",
    url: url_BooksLayersAnnotationDataList_598812, schemes: {Scheme.Https})
type
  Call_BooksLayersAnnotationDataGet_598837 = ref object of OpenApiRestCall_597437
proc url_BooksLayersAnnotationDataGet_598839(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BooksLayersAnnotationDataGet_598838(path: JsonNode; query: JsonNode;
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
  var valid_598840 = path.getOrDefault("annotationDataId")
  valid_598840 = validateParameter(valid_598840, JString, required = true,
                                 default = nil)
  if valid_598840 != nil:
    section.add "annotationDataId", valid_598840
  var valid_598841 = path.getOrDefault("volumeId")
  valid_598841 = validateParameter(valid_598841, JString, required = true,
                                 default = nil)
  if valid_598841 != nil:
    section.add "volumeId", valid_598841
  var valid_598842 = path.getOrDefault("layerId")
  valid_598842 = validateParameter(valid_598842, JString, required = true,
                                 default = nil)
  if valid_598842 != nil:
    section.add "layerId", valid_598842
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
  var valid_598843 = query.getOrDefault("locale")
  valid_598843 = validateParameter(valid_598843, JString, required = false,
                                 default = nil)
  if valid_598843 != nil:
    section.add "locale", valid_598843
  var valid_598844 = query.getOrDefault("fields")
  valid_598844 = validateParameter(valid_598844, JString, required = false,
                                 default = nil)
  if valid_598844 != nil:
    section.add "fields", valid_598844
  var valid_598845 = query.getOrDefault("quotaUser")
  valid_598845 = validateParameter(valid_598845, JString, required = false,
                                 default = nil)
  if valid_598845 != nil:
    section.add "quotaUser", valid_598845
  var valid_598846 = query.getOrDefault("alt")
  valid_598846 = validateParameter(valid_598846, JString, required = false,
                                 default = newJString("json"))
  if valid_598846 != nil:
    section.add "alt", valid_598846
  var valid_598847 = query.getOrDefault("scale")
  valid_598847 = validateParameter(valid_598847, JInt, required = false, default = nil)
  if valid_598847 != nil:
    section.add "scale", valid_598847
  var valid_598848 = query.getOrDefault("allowWebDefinitions")
  valid_598848 = validateParameter(valid_598848, JBool, required = false, default = nil)
  if valid_598848 != nil:
    section.add "allowWebDefinitions", valid_598848
  var valid_598849 = query.getOrDefault("oauth_token")
  valid_598849 = validateParameter(valid_598849, JString, required = false,
                                 default = nil)
  if valid_598849 != nil:
    section.add "oauth_token", valid_598849
  var valid_598850 = query.getOrDefault("userIp")
  valid_598850 = validateParameter(valid_598850, JString, required = false,
                                 default = nil)
  if valid_598850 != nil:
    section.add "userIp", valid_598850
  assert query != nil,
        "query argument is necessary due to required `contentVersion` field"
  var valid_598851 = query.getOrDefault("contentVersion")
  valid_598851 = validateParameter(valid_598851, JString, required = true,
                                 default = nil)
  if valid_598851 != nil:
    section.add "contentVersion", valid_598851
  var valid_598852 = query.getOrDefault("source")
  valid_598852 = validateParameter(valid_598852, JString, required = false,
                                 default = nil)
  if valid_598852 != nil:
    section.add "source", valid_598852
  var valid_598853 = query.getOrDefault("key")
  valid_598853 = validateParameter(valid_598853, JString, required = false,
                                 default = nil)
  if valid_598853 != nil:
    section.add "key", valid_598853
  var valid_598854 = query.getOrDefault("w")
  valid_598854 = validateParameter(valid_598854, JInt, required = false, default = nil)
  if valid_598854 != nil:
    section.add "w", valid_598854
  var valid_598855 = query.getOrDefault("prettyPrint")
  valid_598855 = validateParameter(valid_598855, JBool, required = false,
                                 default = newJBool(true))
  if valid_598855 != nil:
    section.add "prettyPrint", valid_598855
  var valid_598856 = query.getOrDefault("h")
  valid_598856 = validateParameter(valid_598856, JInt, required = false, default = nil)
  if valid_598856 != nil:
    section.add "h", valid_598856
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598857: Call_BooksLayersAnnotationDataGet_598837; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the annotation data.
  ## 
  let valid = call_598857.validator(path, query, header, formData, body)
  let scheme = call_598857.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598857.url(scheme.get, call_598857.host, call_598857.base,
                         call_598857.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598857, url, valid)

proc call*(call_598858: Call_BooksLayersAnnotationDataGet_598837;
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
  var path_598859 = newJObject()
  var query_598860 = newJObject()
  add(query_598860, "locale", newJString(locale))
  add(path_598859, "annotationDataId", newJString(annotationDataId))
  add(query_598860, "fields", newJString(fields))
  add(query_598860, "quotaUser", newJString(quotaUser))
  add(query_598860, "alt", newJString(alt))
  add(query_598860, "scale", newJInt(scale))
  add(query_598860, "allowWebDefinitions", newJBool(allowWebDefinitions))
  add(query_598860, "oauth_token", newJString(oauthToken))
  add(query_598860, "userIp", newJString(userIp))
  add(query_598860, "contentVersion", newJString(contentVersion))
  add(query_598860, "source", newJString(source))
  add(query_598860, "key", newJString(key))
  add(path_598859, "volumeId", newJString(volumeId))
  add(query_598860, "w", newJInt(w))
  add(query_598860, "prettyPrint", newJBool(prettyPrint))
  add(query_598860, "h", newJInt(h))
  add(path_598859, "layerId", newJString(layerId))
  result = call_598858.call(path_598859, query_598860, nil, nil, nil)

var booksLayersAnnotationDataGet* = Call_BooksLayersAnnotationDataGet_598837(
    name: "booksLayersAnnotationDataGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/volumes/{volumeId}/layers/{layerId}/data/{annotationDataId}",
    validator: validate_BooksLayersAnnotationDataGet_598838, base: "/books/v1",
    url: url_BooksLayersAnnotationDataGet_598839, schemes: {Scheme.Https})
type
  Call_BooksLayersList_598861 = ref object of OpenApiRestCall_597437
proc url_BooksLayersList_598863(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BooksLayersList_598862(path: JsonNode; query: JsonNode;
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
  var valid_598864 = path.getOrDefault("volumeId")
  valid_598864 = validateParameter(valid_598864, JString, required = true,
                                 default = nil)
  if valid_598864 != nil:
    section.add "volumeId", valid_598864
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
  var valid_598865 = query.getOrDefault("fields")
  valid_598865 = validateParameter(valid_598865, JString, required = false,
                                 default = nil)
  if valid_598865 != nil:
    section.add "fields", valid_598865
  var valid_598866 = query.getOrDefault("pageToken")
  valid_598866 = validateParameter(valid_598866, JString, required = false,
                                 default = nil)
  if valid_598866 != nil:
    section.add "pageToken", valid_598866
  var valid_598867 = query.getOrDefault("quotaUser")
  valid_598867 = validateParameter(valid_598867, JString, required = false,
                                 default = nil)
  if valid_598867 != nil:
    section.add "quotaUser", valid_598867
  var valid_598868 = query.getOrDefault("alt")
  valid_598868 = validateParameter(valid_598868, JString, required = false,
                                 default = newJString("json"))
  if valid_598868 != nil:
    section.add "alt", valid_598868
  var valid_598869 = query.getOrDefault("oauth_token")
  valid_598869 = validateParameter(valid_598869, JString, required = false,
                                 default = nil)
  if valid_598869 != nil:
    section.add "oauth_token", valid_598869
  var valid_598870 = query.getOrDefault("userIp")
  valid_598870 = validateParameter(valid_598870, JString, required = false,
                                 default = nil)
  if valid_598870 != nil:
    section.add "userIp", valid_598870
  var valid_598871 = query.getOrDefault("maxResults")
  valid_598871 = validateParameter(valid_598871, JInt, required = false, default = nil)
  if valid_598871 != nil:
    section.add "maxResults", valid_598871
  var valid_598872 = query.getOrDefault("contentVersion")
  valid_598872 = validateParameter(valid_598872, JString, required = false,
                                 default = nil)
  if valid_598872 != nil:
    section.add "contentVersion", valid_598872
  var valid_598873 = query.getOrDefault("source")
  valid_598873 = validateParameter(valid_598873, JString, required = false,
                                 default = nil)
  if valid_598873 != nil:
    section.add "source", valid_598873
  var valid_598874 = query.getOrDefault("key")
  valid_598874 = validateParameter(valid_598874, JString, required = false,
                                 default = nil)
  if valid_598874 != nil:
    section.add "key", valid_598874
  var valid_598875 = query.getOrDefault("prettyPrint")
  valid_598875 = validateParameter(valid_598875, JBool, required = false,
                                 default = newJBool(true))
  if valid_598875 != nil:
    section.add "prettyPrint", valid_598875
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598876: Call_BooksLayersList_598861; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the layer summaries for a volume.
  ## 
  let valid = call_598876.validator(path, query, header, formData, body)
  let scheme = call_598876.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598876.url(scheme.get, call_598876.host, call_598876.base,
                         call_598876.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598876, url, valid)

proc call*(call_598877: Call_BooksLayersList_598861; volumeId: string;
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
  var path_598878 = newJObject()
  var query_598879 = newJObject()
  add(query_598879, "fields", newJString(fields))
  add(query_598879, "pageToken", newJString(pageToken))
  add(query_598879, "quotaUser", newJString(quotaUser))
  add(query_598879, "alt", newJString(alt))
  add(query_598879, "oauth_token", newJString(oauthToken))
  add(query_598879, "userIp", newJString(userIp))
  add(query_598879, "maxResults", newJInt(maxResults))
  add(query_598879, "contentVersion", newJString(contentVersion))
  add(query_598879, "source", newJString(source))
  add(query_598879, "key", newJString(key))
  add(path_598878, "volumeId", newJString(volumeId))
  add(query_598879, "prettyPrint", newJBool(prettyPrint))
  result = call_598877.call(path_598878, query_598879, nil, nil, nil)

var booksLayersList* = Call_BooksLayersList_598861(name: "booksLayersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/volumes/{volumeId}/layersummary",
    validator: validate_BooksLayersList_598862, base: "/books/v1",
    url: url_BooksLayersList_598863, schemes: {Scheme.Https})
type
  Call_BooksLayersGet_598880 = ref object of OpenApiRestCall_597437
proc url_BooksLayersGet_598882(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BooksLayersGet_598881(path: JsonNode; query: JsonNode;
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
  var valid_598883 = path.getOrDefault("volumeId")
  valid_598883 = validateParameter(valid_598883, JString, required = true,
                                 default = nil)
  if valid_598883 != nil:
    section.add "volumeId", valid_598883
  var valid_598884 = path.getOrDefault("summaryId")
  valid_598884 = validateParameter(valid_598884, JString, required = true,
                                 default = nil)
  if valid_598884 != nil:
    section.add "summaryId", valid_598884
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
  var valid_598885 = query.getOrDefault("fields")
  valid_598885 = validateParameter(valid_598885, JString, required = false,
                                 default = nil)
  if valid_598885 != nil:
    section.add "fields", valid_598885
  var valid_598886 = query.getOrDefault("quotaUser")
  valid_598886 = validateParameter(valid_598886, JString, required = false,
                                 default = nil)
  if valid_598886 != nil:
    section.add "quotaUser", valid_598886
  var valid_598887 = query.getOrDefault("alt")
  valid_598887 = validateParameter(valid_598887, JString, required = false,
                                 default = newJString("json"))
  if valid_598887 != nil:
    section.add "alt", valid_598887
  var valid_598888 = query.getOrDefault("oauth_token")
  valid_598888 = validateParameter(valid_598888, JString, required = false,
                                 default = nil)
  if valid_598888 != nil:
    section.add "oauth_token", valid_598888
  var valid_598889 = query.getOrDefault("userIp")
  valid_598889 = validateParameter(valid_598889, JString, required = false,
                                 default = nil)
  if valid_598889 != nil:
    section.add "userIp", valid_598889
  var valid_598890 = query.getOrDefault("contentVersion")
  valid_598890 = validateParameter(valid_598890, JString, required = false,
                                 default = nil)
  if valid_598890 != nil:
    section.add "contentVersion", valid_598890
  var valid_598891 = query.getOrDefault("source")
  valid_598891 = validateParameter(valid_598891, JString, required = false,
                                 default = nil)
  if valid_598891 != nil:
    section.add "source", valid_598891
  var valid_598892 = query.getOrDefault("key")
  valid_598892 = validateParameter(valid_598892, JString, required = false,
                                 default = nil)
  if valid_598892 != nil:
    section.add "key", valid_598892
  var valid_598893 = query.getOrDefault("prettyPrint")
  valid_598893 = validateParameter(valid_598893, JBool, required = false,
                                 default = newJBool(true))
  if valid_598893 != nil:
    section.add "prettyPrint", valid_598893
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598894: Call_BooksLayersGet_598880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the layer summary for a volume.
  ## 
  let valid = call_598894.validator(path, query, header, formData, body)
  let scheme = call_598894.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598894.url(scheme.get, call_598894.host, call_598894.base,
                         call_598894.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598894, url, valid)

proc call*(call_598895: Call_BooksLayersGet_598880; volumeId: string;
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
  var path_598896 = newJObject()
  var query_598897 = newJObject()
  add(query_598897, "fields", newJString(fields))
  add(query_598897, "quotaUser", newJString(quotaUser))
  add(query_598897, "alt", newJString(alt))
  add(query_598897, "oauth_token", newJString(oauthToken))
  add(query_598897, "userIp", newJString(userIp))
  add(query_598897, "contentVersion", newJString(contentVersion))
  add(query_598897, "source", newJString(source))
  add(query_598897, "key", newJString(key))
  add(path_598896, "volumeId", newJString(volumeId))
  add(path_598896, "summaryId", newJString(summaryId))
  add(query_598897, "prettyPrint", newJBool(prettyPrint))
  result = call_598895.call(path_598896, query_598897, nil, nil, nil)

var booksLayersGet* = Call_BooksLayersGet_598880(name: "booksLayersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/volumes/{volumeId}/layersummary/{summaryId}",
    validator: validate_BooksLayersGet_598881, base: "/books/v1",
    url: url_BooksLayersGet_598882, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
