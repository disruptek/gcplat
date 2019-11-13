
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

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

  OpenApiRestCall_579389 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579389](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579389): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "books"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BooksCloudloadingAddBook_579659 = ref object of OpenApiRestCall_579389
proc url_BooksCloudloadingAddBook_579661(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BooksCloudloadingAddBook_579660(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   name: JString
  ##       : The document name. It can be set only if the drive_document_id is set.
  ##   drive_document_id: JString
  ##                    : A drive document id. The upload_client_token must not be set.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   mime_type: JString
  ##            : The document MIME type. It can be set only if the drive_document_id is set.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_client_token: JString
  section = newJObject()
  var valid_579773 = query.getOrDefault("key")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "key", valid_579773
  var valid_579787 = query.getOrDefault("prettyPrint")
  valid_579787 = validateParameter(valid_579787, JBool, required = false,
                                 default = newJBool(true))
  if valid_579787 != nil:
    section.add "prettyPrint", valid_579787
  var valid_579788 = query.getOrDefault("oauth_token")
  valid_579788 = validateParameter(valid_579788, JString, required = false,
                                 default = nil)
  if valid_579788 != nil:
    section.add "oauth_token", valid_579788
  var valid_579789 = query.getOrDefault("name")
  valid_579789 = validateParameter(valid_579789, JString, required = false,
                                 default = nil)
  if valid_579789 != nil:
    section.add "name", valid_579789
  var valid_579790 = query.getOrDefault("drive_document_id")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = nil)
  if valid_579790 != nil:
    section.add "drive_document_id", valid_579790
  var valid_579791 = query.getOrDefault("alt")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = newJString("json"))
  if valid_579791 != nil:
    section.add "alt", valid_579791
  var valid_579792 = query.getOrDefault("userIp")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "userIp", valid_579792
  var valid_579793 = query.getOrDefault("quotaUser")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "quotaUser", valid_579793
  var valid_579794 = query.getOrDefault("mime_type")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = nil)
  if valid_579794 != nil:
    section.add "mime_type", valid_579794
  var valid_579795 = query.getOrDefault("fields")
  valid_579795 = validateParameter(valid_579795, JString, required = false,
                                 default = nil)
  if valid_579795 != nil:
    section.add "fields", valid_579795
  var valid_579796 = query.getOrDefault("upload_client_token")
  valid_579796 = validateParameter(valid_579796, JString, required = false,
                                 default = nil)
  if valid_579796 != nil:
    section.add "upload_client_token", valid_579796
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579819: Call_BooksCloudloadingAddBook_579659; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_579819.validator(path, query, header, formData, body)
  let scheme = call_579819.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579819.url(scheme.get, call_579819.host, call_579819.base,
                         call_579819.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579819, url, valid)

proc call*(call_579890: Call_BooksCloudloadingAddBook_579659; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; name: string = "";
          driveDocumentId: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; mimeType: string = ""; fields: string = "";
          uploadClientToken: string = ""): Recallable =
  ## booksCloudloadingAddBook
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   name: string
  ##       : The document name. It can be set only if the drive_document_id is set.
  ##   driveDocumentId: string
  ##                  : A drive document id. The upload_client_token must not be set.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   mimeType: string
  ##           : The document MIME type. It can be set only if the drive_document_id is set.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadClientToken: string
  var query_579891 = newJObject()
  add(query_579891, "key", newJString(key))
  add(query_579891, "prettyPrint", newJBool(prettyPrint))
  add(query_579891, "oauth_token", newJString(oauthToken))
  add(query_579891, "name", newJString(name))
  add(query_579891, "drive_document_id", newJString(driveDocumentId))
  add(query_579891, "alt", newJString(alt))
  add(query_579891, "userIp", newJString(userIp))
  add(query_579891, "quotaUser", newJString(quotaUser))
  add(query_579891, "mime_type", newJString(mimeType))
  add(query_579891, "fields", newJString(fields))
  add(query_579891, "upload_client_token", newJString(uploadClientToken))
  result = call_579890.call(nil, query_579891, nil, nil, nil)

var booksCloudloadingAddBook* = Call_BooksCloudloadingAddBook_579659(
    name: "booksCloudloadingAddBook", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/cloudloading/addBook",
    validator: validate_BooksCloudloadingAddBook_579660, base: "/books/v1",
    url: url_BooksCloudloadingAddBook_579661, schemes: {Scheme.Https})
type
  Call_BooksCloudloadingDeleteBook_579931 = ref object of OpenApiRestCall_579389
proc url_BooksCloudloadingDeleteBook_579933(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BooksCloudloadingDeleteBook_579932(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Remove the book and its contents
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   volumeId: JString (required)
  ##           : The id of the book to be removed.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579934 = query.getOrDefault("key")
  valid_579934 = validateParameter(valid_579934, JString, required = false,
                                 default = nil)
  if valid_579934 != nil:
    section.add "key", valid_579934
  var valid_579935 = query.getOrDefault("prettyPrint")
  valid_579935 = validateParameter(valid_579935, JBool, required = false,
                                 default = newJBool(true))
  if valid_579935 != nil:
    section.add "prettyPrint", valid_579935
  var valid_579936 = query.getOrDefault("oauth_token")
  valid_579936 = validateParameter(valid_579936, JString, required = false,
                                 default = nil)
  if valid_579936 != nil:
    section.add "oauth_token", valid_579936
  assert query != nil,
        "query argument is necessary due to required `volumeId` field"
  var valid_579937 = query.getOrDefault("volumeId")
  valid_579937 = validateParameter(valid_579937, JString, required = true,
                                 default = nil)
  if valid_579937 != nil:
    section.add "volumeId", valid_579937
  var valid_579938 = query.getOrDefault("alt")
  valid_579938 = validateParameter(valid_579938, JString, required = false,
                                 default = newJString("json"))
  if valid_579938 != nil:
    section.add "alt", valid_579938
  var valid_579939 = query.getOrDefault("userIp")
  valid_579939 = validateParameter(valid_579939, JString, required = false,
                                 default = nil)
  if valid_579939 != nil:
    section.add "userIp", valid_579939
  var valid_579940 = query.getOrDefault("quotaUser")
  valid_579940 = validateParameter(valid_579940, JString, required = false,
                                 default = nil)
  if valid_579940 != nil:
    section.add "quotaUser", valid_579940
  var valid_579941 = query.getOrDefault("fields")
  valid_579941 = validateParameter(valid_579941, JString, required = false,
                                 default = nil)
  if valid_579941 != nil:
    section.add "fields", valid_579941
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579942: Call_BooksCloudloadingDeleteBook_579931; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove the book and its contents
  ## 
  let valid = call_579942.validator(path, query, header, formData, body)
  let scheme = call_579942.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579942.url(scheme.get, call_579942.host, call_579942.base,
                         call_579942.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579942, url, valid)

proc call*(call_579943: Call_BooksCloudloadingDeleteBook_579931; volumeId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## booksCloudloadingDeleteBook
  ## Remove the book and its contents
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   volumeId: string (required)
  ##           : The id of the book to be removed.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579944 = newJObject()
  add(query_579944, "key", newJString(key))
  add(query_579944, "prettyPrint", newJBool(prettyPrint))
  add(query_579944, "oauth_token", newJString(oauthToken))
  add(query_579944, "volumeId", newJString(volumeId))
  add(query_579944, "alt", newJString(alt))
  add(query_579944, "userIp", newJString(userIp))
  add(query_579944, "quotaUser", newJString(quotaUser))
  add(query_579944, "fields", newJString(fields))
  result = call_579943.call(nil, query_579944, nil, nil, nil)

var booksCloudloadingDeleteBook* = Call_BooksCloudloadingDeleteBook_579931(
    name: "booksCloudloadingDeleteBook", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/cloudloading/deleteBook",
    validator: validate_BooksCloudloadingDeleteBook_579932, base: "/books/v1",
    url: url_BooksCloudloadingDeleteBook_579933, schemes: {Scheme.Https})
type
  Call_BooksCloudloadingUpdateBook_579945 = ref object of OpenApiRestCall_579389
proc url_BooksCloudloadingUpdateBook_579947(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BooksCloudloadingUpdateBook_579946(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579948 = query.getOrDefault("key")
  valid_579948 = validateParameter(valid_579948, JString, required = false,
                                 default = nil)
  if valid_579948 != nil:
    section.add "key", valid_579948
  var valid_579949 = query.getOrDefault("prettyPrint")
  valid_579949 = validateParameter(valid_579949, JBool, required = false,
                                 default = newJBool(true))
  if valid_579949 != nil:
    section.add "prettyPrint", valid_579949
  var valid_579950 = query.getOrDefault("oauth_token")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = nil)
  if valid_579950 != nil:
    section.add "oauth_token", valid_579950
  var valid_579951 = query.getOrDefault("alt")
  valid_579951 = validateParameter(valid_579951, JString, required = false,
                                 default = newJString("json"))
  if valid_579951 != nil:
    section.add "alt", valid_579951
  var valid_579952 = query.getOrDefault("userIp")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = nil)
  if valid_579952 != nil:
    section.add "userIp", valid_579952
  var valid_579953 = query.getOrDefault("quotaUser")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = nil)
  if valid_579953 != nil:
    section.add "quotaUser", valid_579953
  var valid_579954 = query.getOrDefault("fields")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = nil)
  if valid_579954 != nil:
    section.add "fields", valid_579954
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

proc call*(call_579956: Call_BooksCloudloadingUpdateBook_579945; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_579956.validator(path, query, header, formData, body)
  let scheme = call_579956.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579956.url(scheme.get, call_579956.host, call_579956.base,
                         call_579956.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579956, url, valid)

proc call*(call_579957: Call_BooksCloudloadingUpdateBook_579945; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## booksCloudloadingUpdateBook
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579958 = newJObject()
  var body_579959 = newJObject()
  add(query_579958, "key", newJString(key))
  add(query_579958, "prettyPrint", newJBool(prettyPrint))
  add(query_579958, "oauth_token", newJString(oauthToken))
  add(query_579958, "alt", newJString(alt))
  add(query_579958, "userIp", newJString(userIp))
  add(query_579958, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579959 = body
  add(query_579958, "fields", newJString(fields))
  result = call_579957.call(nil, query_579958, nil, nil, body_579959)

var booksCloudloadingUpdateBook* = Call_BooksCloudloadingUpdateBook_579945(
    name: "booksCloudloadingUpdateBook", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/cloudloading/updateBook",
    validator: validate_BooksCloudloadingUpdateBook_579946, base: "/books/v1",
    url: url_BooksCloudloadingUpdateBook_579947, schemes: {Scheme.Https})
type
  Call_BooksDictionaryListOfflineMetadata_579960 = ref object of OpenApiRestCall_579389
proc url_BooksDictionaryListOfflineMetadata_579962(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BooksDictionaryListOfflineMetadata_579961(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of offline dictionary metadata available
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   cpksver: JString (required)
  ##          : The device/version ID from which to request the data.
  section = newJObject()
  var valid_579963 = query.getOrDefault("key")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "key", valid_579963
  var valid_579964 = query.getOrDefault("prettyPrint")
  valid_579964 = validateParameter(valid_579964, JBool, required = false,
                                 default = newJBool(true))
  if valid_579964 != nil:
    section.add "prettyPrint", valid_579964
  var valid_579965 = query.getOrDefault("oauth_token")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "oauth_token", valid_579965
  var valid_579966 = query.getOrDefault("alt")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = newJString("json"))
  if valid_579966 != nil:
    section.add "alt", valid_579966
  var valid_579967 = query.getOrDefault("userIp")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "userIp", valid_579967
  var valid_579968 = query.getOrDefault("quotaUser")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "quotaUser", valid_579968
  var valid_579969 = query.getOrDefault("fields")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "fields", valid_579969
  assert query != nil, "query argument is necessary due to required `cpksver` field"
  var valid_579970 = query.getOrDefault("cpksver")
  valid_579970 = validateParameter(valid_579970, JString, required = true,
                                 default = nil)
  if valid_579970 != nil:
    section.add "cpksver", valid_579970
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579971: Call_BooksDictionaryListOfflineMetadata_579960;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of offline dictionary metadata available
  ## 
  let valid = call_579971.validator(path, query, header, formData, body)
  let scheme = call_579971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579971.url(scheme.get, call_579971.host, call_579971.base,
                         call_579971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579971, url, valid)

proc call*(call_579972: Call_BooksDictionaryListOfflineMetadata_579960;
          cpksver: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## booksDictionaryListOfflineMetadata
  ## Returns a list of offline dictionary metadata available
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   cpksver: string (required)
  ##          : The device/version ID from which to request the data.
  var query_579973 = newJObject()
  add(query_579973, "key", newJString(key))
  add(query_579973, "prettyPrint", newJBool(prettyPrint))
  add(query_579973, "oauth_token", newJString(oauthToken))
  add(query_579973, "alt", newJString(alt))
  add(query_579973, "userIp", newJString(userIp))
  add(query_579973, "quotaUser", newJString(quotaUser))
  add(query_579973, "fields", newJString(fields))
  add(query_579973, "cpksver", newJString(cpksver))
  result = call_579972.call(nil, query_579973, nil, nil, nil)

var booksDictionaryListOfflineMetadata* = Call_BooksDictionaryListOfflineMetadata_579960(
    name: "booksDictionaryListOfflineMetadata", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/dictionary/listOfflineMetadata",
    validator: validate_BooksDictionaryListOfflineMetadata_579961,
    base: "/books/v1", url: url_BooksDictionaryListOfflineMetadata_579962,
    schemes: {Scheme.Https})
type
  Call_BooksFamilysharingGetFamilyInfo_579974 = ref object of OpenApiRestCall_579389
proc url_BooksFamilysharingGetFamilyInfo_579976(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BooksFamilysharingGetFamilyInfo_579975(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information regarding the family that the user is part of.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579977 = query.getOrDefault("key")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "key", valid_579977
  var valid_579978 = query.getOrDefault("prettyPrint")
  valid_579978 = validateParameter(valid_579978, JBool, required = false,
                                 default = newJBool(true))
  if valid_579978 != nil:
    section.add "prettyPrint", valid_579978
  var valid_579979 = query.getOrDefault("oauth_token")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "oauth_token", valid_579979
  var valid_579980 = query.getOrDefault("source")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "source", valid_579980
  var valid_579981 = query.getOrDefault("alt")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = newJString("json"))
  if valid_579981 != nil:
    section.add "alt", valid_579981
  var valid_579982 = query.getOrDefault("userIp")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "userIp", valid_579982
  var valid_579983 = query.getOrDefault("quotaUser")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "quotaUser", valid_579983
  var valid_579984 = query.getOrDefault("fields")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "fields", valid_579984
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579985: Call_BooksFamilysharingGetFamilyInfo_579974;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information regarding the family that the user is part of.
  ## 
  let valid = call_579985.validator(path, query, header, formData, body)
  let scheme = call_579985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579985.url(scheme.get, call_579985.host, call_579985.base,
                         call_579985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579985, url, valid)

proc call*(call_579986: Call_BooksFamilysharingGetFamilyInfo_579974;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          source: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## booksFamilysharingGetFamilyInfo
  ## Gets information regarding the family that the user is part of.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579987 = newJObject()
  add(query_579987, "key", newJString(key))
  add(query_579987, "prettyPrint", newJBool(prettyPrint))
  add(query_579987, "oauth_token", newJString(oauthToken))
  add(query_579987, "source", newJString(source))
  add(query_579987, "alt", newJString(alt))
  add(query_579987, "userIp", newJString(userIp))
  add(query_579987, "quotaUser", newJString(quotaUser))
  add(query_579987, "fields", newJString(fields))
  result = call_579986.call(nil, query_579987, nil, nil, nil)

var booksFamilysharingGetFamilyInfo* = Call_BooksFamilysharingGetFamilyInfo_579974(
    name: "booksFamilysharingGetFamilyInfo", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/familysharing/getFamilyInfo",
    validator: validate_BooksFamilysharingGetFamilyInfo_579975, base: "/books/v1",
    url: url_BooksFamilysharingGetFamilyInfo_579976, schemes: {Scheme.Https})
type
  Call_BooksFamilysharingShare_579988 = ref object of OpenApiRestCall_579389
proc url_BooksFamilysharingShare_579990(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BooksFamilysharingShare_579989(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Initiates sharing of the content with the user's family. Empty response indicates success.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   docId: JString
  ##        : The docid to share.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   volumeId: JString
  ##           : The volume to share.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579991 = query.getOrDefault("key")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "key", valid_579991
  var valid_579992 = query.getOrDefault("docId")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "docId", valid_579992
  var valid_579993 = query.getOrDefault("prettyPrint")
  valid_579993 = validateParameter(valid_579993, JBool, required = false,
                                 default = newJBool(true))
  if valid_579993 != nil:
    section.add "prettyPrint", valid_579993
  var valid_579994 = query.getOrDefault("oauth_token")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "oauth_token", valid_579994
  var valid_579995 = query.getOrDefault("volumeId")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "volumeId", valid_579995
  var valid_579996 = query.getOrDefault("source")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "source", valid_579996
  var valid_579997 = query.getOrDefault("alt")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = newJString("json"))
  if valid_579997 != nil:
    section.add "alt", valid_579997
  var valid_579998 = query.getOrDefault("userIp")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "userIp", valid_579998
  var valid_579999 = query.getOrDefault("quotaUser")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "quotaUser", valid_579999
  var valid_580000 = query.getOrDefault("fields")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "fields", valid_580000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580001: Call_BooksFamilysharingShare_579988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Initiates sharing of the content with the user's family. Empty response indicates success.
  ## 
  let valid = call_580001.validator(path, query, header, formData, body)
  let scheme = call_580001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580001.url(scheme.get, call_580001.host, call_580001.base,
                         call_580001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580001, url, valid)

proc call*(call_580002: Call_BooksFamilysharingShare_579988; key: string = "";
          docId: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          volumeId: string = ""; source: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## booksFamilysharingShare
  ## Initiates sharing of the content with the user's family. Empty response indicates success.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   docId: string
  ##        : The docid to share.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   volumeId: string
  ##           : The volume to share.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580003 = newJObject()
  add(query_580003, "key", newJString(key))
  add(query_580003, "docId", newJString(docId))
  add(query_580003, "prettyPrint", newJBool(prettyPrint))
  add(query_580003, "oauth_token", newJString(oauthToken))
  add(query_580003, "volumeId", newJString(volumeId))
  add(query_580003, "source", newJString(source))
  add(query_580003, "alt", newJString(alt))
  add(query_580003, "userIp", newJString(userIp))
  add(query_580003, "quotaUser", newJString(quotaUser))
  add(query_580003, "fields", newJString(fields))
  result = call_580002.call(nil, query_580003, nil, nil, nil)

var booksFamilysharingShare* = Call_BooksFamilysharingShare_579988(
    name: "booksFamilysharingShare", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/familysharing/share",
    validator: validate_BooksFamilysharingShare_579989, base: "/books/v1",
    url: url_BooksFamilysharingShare_579990, schemes: {Scheme.Https})
type
  Call_BooksFamilysharingUnshare_580004 = ref object of OpenApiRestCall_579389
proc url_BooksFamilysharingUnshare_580006(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BooksFamilysharingUnshare_580005(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Initiates revoking content that has already been shared with the user's family. Empty response indicates success.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   docId: JString
  ##        : The docid to unshare.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   volumeId: JString
  ##           : The volume to unshare.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580007 = query.getOrDefault("key")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "key", valid_580007
  var valid_580008 = query.getOrDefault("docId")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "docId", valid_580008
  var valid_580009 = query.getOrDefault("prettyPrint")
  valid_580009 = validateParameter(valid_580009, JBool, required = false,
                                 default = newJBool(true))
  if valid_580009 != nil:
    section.add "prettyPrint", valid_580009
  var valid_580010 = query.getOrDefault("oauth_token")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "oauth_token", valid_580010
  var valid_580011 = query.getOrDefault("volumeId")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "volumeId", valid_580011
  var valid_580012 = query.getOrDefault("source")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "source", valid_580012
  var valid_580013 = query.getOrDefault("alt")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = newJString("json"))
  if valid_580013 != nil:
    section.add "alt", valid_580013
  var valid_580014 = query.getOrDefault("userIp")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "userIp", valid_580014
  var valid_580015 = query.getOrDefault("quotaUser")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "quotaUser", valid_580015
  var valid_580016 = query.getOrDefault("fields")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "fields", valid_580016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580017: Call_BooksFamilysharingUnshare_580004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Initiates revoking content that has already been shared with the user's family. Empty response indicates success.
  ## 
  let valid = call_580017.validator(path, query, header, formData, body)
  let scheme = call_580017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580017.url(scheme.get, call_580017.host, call_580017.base,
                         call_580017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580017, url, valid)

proc call*(call_580018: Call_BooksFamilysharingUnshare_580004; key: string = "";
          docId: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          volumeId: string = ""; source: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## booksFamilysharingUnshare
  ## Initiates revoking content that has already been shared with the user's family. Empty response indicates success.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   docId: string
  ##        : The docid to unshare.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   volumeId: string
  ##           : The volume to unshare.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580019 = newJObject()
  add(query_580019, "key", newJString(key))
  add(query_580019, "docId", newJString(docId))
  add(query_580019, "prettyPrint", newJBool(prettyPrint))
  add(query_580019, "oauth_token", newJString(oauthToken))
  add(query_580019, "volumeId", newJString(volumeId))
  add(query_580019, "source", newJString(source))
  add(query_580019, "alt", newJString(alt))
  add(query_580019, "userIp", newJString(userIp))
  add(query_580019, "quotaUser", newJString(quotaUser))
  add(query_580019, "fields", newJString(fields))
  result = call_580018.call(nil, query_580019, nil, nil, nil)

var booksFamilysharingUnshare* = Call_BooksFamilysharingUnshare_580004(
    name: "booksFamilysharingUnshare", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/familysharing/unshare",
    validator: validate_BooksFamilysharingUnshare_580005, base: "/books/v1",
    url: url_BooksFamilysharingUnshare_580006, schemes: {Scheme.Https})
type
  Call_BooksMyconfigGetUserSettings_580020 = ref object of OpenApiRestCall_579389
proc url_BooksMyconfigGetUserSettings_580022(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BooksMyconfigGetUserSettings_580021(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the current settings for the user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580023 = query.getOrDefault("key")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "key", valid_580023
  var valid_580024 = query.getOrDefault("prettyPrint")
  valid_580024 = validateParameter(valid_580024, JBool, required = false,
                                 default = newJBool(true))
  if valid_580024 != nil:
    section.add "prettyPrint", valid_580024
  var valid_580025 = query.getOrDefault("oauth_token")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "oauth_token", valid_580025
  var valid_580026 = query.getOrDefault("alt")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = newJString("json"))
  if valid_580026 != nil:
    section.add "alt", valid_580026
  var valid_580027 = query.getOrDefault("userIp")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "userIp", valid_580027
  var valid_580028 = query.getOrDefault("quotaUser")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "quotaUser", valid_580028
  var valid_580029 = query.getOrDefault("fields")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "fields", valid_580029
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580030: Call_BooksMyconfigGetUserSettings_580020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current settings for the user.
  ## 
  let valid = call_580030.validator(path, query, header, formData, body)
  let scheme = call_580030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580030.url(scheme.get, call_580030.host, call_580030.base,
                         call_580030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580030, url, valid)

proc call*(call_580031: Call_BooksMyconfigGetUserSettings_580020; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## booksMyconfigGetUserSettings
  ## Gets the current settings for the user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580032 = newJObject()
  add(query_580032, "key", newJString(key))
  add(query_580032, "prettyPrint", newJBool(prettyPrint))
  add(query_580032, "oauth_token", newJString(oauthToken))
  add(query_580032, "alt", newJString(alt))
  add(query_580032, "userIp", newJString(userIp))
  add(query_580032, "quotaUser", newJString(quotaUser))
  add(query_580032, "fields", newJString(fields))
  result = call_580031.call(nil, query_580032, nil, nil, nil)

var booksMyconfigGetUserSettings* = Call_BooksMyconfigGetUserSettings_580020(
    name: "booksMyconfigGetUserSettings", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/myconfig/getUserSettings",
    validator: validate_BooksMyconfigGetUserSettings_580021, base: "/books/v1",
    url: url_BooksMyconfigGetUserSettings_580022, schemes: {Scheme.Https})
type
  Call_BooksMyconfigReleaseDownloadAccess_580033 = ref object of OpenApiRestCall_579389
proc url_BooksMyconfigReleaseDownloadAccess_580035(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BooksMyconfigReleaseDownloadAccess_580034(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Release downloaded content access restriction.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   locale: JString
  ##         : ISO-639-1, ISO-3166-1 codes for message localization, i.e. en_US.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   cpksver: JString (required)
  ##          : The device/version ID from which to release the restriction.
  ##   volumeIds: JArray (required)
  ##            : The volume(s) to release restrictions for.
  section = newJObject()
  var valid_580036 = query.getOrDefault("key")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "key", valid_580036
  var valid_580037 = query.getOrDefault("prettyPrint")
  valid_580037 = validateParameter(valid_580037, JBool, required = false,
                                 default = newJBool(true))
  if valid_580037 != nil:
    section.add "prettyPrint", valid_580037
  var valid_580038 = query.getOrDefault("oauth_token")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "oauth_token", valid_580038
  var valid_580039 = query.getOrDefault("locale")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "locale", valid_580039
  var valid_580040 = query.getOrDefault("source")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "source", valid_580040
  var valid_580041 = query.getOrDefault("alt")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = newJString("json"))
  if valid_580041 != nil:
    section.add "alt", valid_580041
  var valid_580042 = query.getOrDefault("userIp")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "userIp", valid_580042
  var valid_580043 = query.getOrDefault("quotaUser")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "quotaUser", valid_580043
  var valid_580044 = query.getOrDefault("fields")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "fields", valid_580044
  assert query != nil, "query argument is necessary due to required `cpksver` field"
  var valid_580045 = query.getOrDefault("cpksver")
  valid_580045 = validateParameter(valid_580045, JString, required = true,
                                 default = nil)
  if valid_580045 != nil:
    section.add "cpksver", valid_580045
  var valid_580046 = query.getOrDefault("volumeIds")
  valid_580046 = validateParameter(valid_580046, JArray, required = true, default = nil)
  if valid_580046 != nil:
    section.add "volumeIds", valid_580046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580047: Call_BooksMyconfigReleaseDownloadAccess_580033;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Release downloaded content access restriction.
  ## 
  let valid = call_580047.validator(path, query, header, formData, body)
  let scheme = call_580047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580047.url(scheme.get, call_580047.host, call_580047.base,
                         call_580047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580047, url, valid)

proc call*(call_580048: Call_BooksMyconfigReleaseDownloadAccess_580033;
          cpksver: string; volumeIds: JsonNode; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; locale: string = "";
          source: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## booksMyconfigReleaseDownloadAccess
  ## Release downloaded content access restriction.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   locale: string
  ##         : ISO-639-1, ISO-3166-1 codes for message localization, i.e. en_US.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   cpksver: string (required)
  ##          : The device/version ID from which to release the restriction.
  ##   volumeIds: JArray (required)
  ##            : The volume(s) to release restrictions for.
  var query_580049 = newJObject()
  add(query_580049, "key", newJString(key))
  add(query_580049, "prettyPrint", newJBool(prettyPrint))
  add(query_580049, "oauth_token", newJString(oauthToken))
  add(query_580049, "locale", newJString(locale))
  add(query_580049, "source", newJString(source))
  add(query_580049, "alt", newJString(alt))
  add(query_580049, "userIp", newJString(userIp))
  add(query_580049, "quotaUser", newJString(quotaUser))
  add(query_580049, "fields", newJString(fields))
  add(query_580049, "cpksver", newJString(cpksver))
  if volumeIds != nil:
    query_580049.add "volumeIds", volumeIds
  result = call_580048.call(nil, query_580049, nil, nil, nil)

var booksMyconfigReleaseDownloadAccess* = Call_BooksMyconfigReleaseDownloadAccess_580033(
    name: "booksMyconfigReleaseDownloadAccess", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/myconfig/releaseDownloadAccess",
    validator: validate_BooksMyconfigReleaseDownloadAccess_580034,
    base: "/books/v1", url: url_BooksMyconfigReleaseDownloadAccess_580035,
    schemes: {Scheme.Https})
type
  Call_BooksMyconfigRequestAccess_580050 = ref object of OpenApiRestCall_579389
proc url_BooksMyconfigRequestAccess_580052(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BooksMyconfigRequestAccess_580051(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Request concurrent and download access restrictions.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   locale: JString
  ##         : ISO-639-1, ISO-3166-1 codes for message localization, i.e. en_US.
  ##   volumeId: JString (required)
  ##           : The volume to request concurrent/download restrictions for.
  ##   source: JString (required)
  ##         : String to identify the originator of this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   nonce: JString (required)
  ##        : The client nonce value.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   cpksver: JString (required)
  ##          : The device/version ID from which to request the restrictions.
  ##   licenseTypes: JString
  ##               : The type of access license to request. If not specified, the default is BOTH.
  section = newJObject()
  var valid_580053 = query.getOrDefault("key")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "key", valid_580053
  var valid_580054 = query.getOrDefault("prettyPrint")
  valid_580054 = validateParameter(valid_580054, JBool, required = false,
                                 default = newJBool(true))
  if valid_580054 != nil:
    section.add "prettyPrint", valid_580054
  var valid_580055 = query.getOrDefault("oauth_token")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "oauth_token", valid_580055
  var valid_580056 = query.getOrDefault("locale")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "locale", valid_580056
  assert query != nil,
        "query argument is necessary due to required `volumeId` field"
  var valid_580057 = query.getOrDefault("volumeId")
  valid_580057 = validateParameter(valid_580057, JString, required = true,
                                 default = nil)
  if valid_580057 != nil:
    section.add "volumeId", valid_580057
  var valid_580058 = query.getOrDefault("source")
  valid_580058 = validateParameter(valid_580058, JString, required = true,
                                 default = nil)
  if valid_580058 != nil:
    section.add "source", valid_580058
  var valid_580059 = query.getOrDefault("alt")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = newJString("json"))
  if valid_580059 != nil:
    section.add "alt", valid_580059
  var valid_580060 = query.getOrDefault("userIp")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "userIp", valid_580060
  var valid_580061 = query.getOrDefault("quotaUser")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "quotaUser", valid_580061
  var valid_580062 = query.getOrDefault("nonce")
  valid_580062 = validateParameter(valid_580062, JString, required = true,
                                 default = nil)
  if valid_580062 != nil:
    section.add "nonce", valid_580062
  var valid_580063 = query.getOrDefault("fields")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "fields", valid_580063
  var valid_580064 = query.getOrDefault("cpksver")
  valid_580064 = validateParameter(valid_580064, JString, required = true,
                                 default = nil)
  if valid_580064 != nil:
    section.add "cpksver", valid_580064
  var valid_580065 = query.getOrDefault("licenseTypes")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = newJString("BOTH"))
  if valid_580065 != nil:
    section.add "licenseTypes", valid_580065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580066: Call_BooksMyconfigRequestAccess_580050; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Request concurrent and download access restrictions.
  ## 
  let valid = call_580066.validator(path, query, header, formData, body)
  let scheme = call_580066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580066.url(scheme.get, call_580066.host, call_580066.base,
                         call_580066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580066, url, valid)

proc call*(call_580067: Call_BooksMyconfigRequestAccess_580050; volumeId: string;
          source: string; nonce: string; cpksver: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; locale: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""; licenseTypes: string = "BOTH"): Recallable =
  ## booksMyconfigRequestAccess
  ## Request concurrent and download access restrictions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   locale: string
  ##         : ISO-639-1, ISO-3166-1 codes for message localization, i.e. en_US.
  ##   volumeId: string (required)
  ##           : The volume to request concurrent/download restrictions for.
  ##   source: string (required)
  ##         : String to identify the originator of this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   nonce: string (required)
  ##        : The client nonce value.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   cpksver: string (required)
  ##          : The device/version ID from which to request the restrictions.
  ##   licenseTypes: string
  ##               : The type of access license to request. If not specified, the default is BOTH.
  var query_580068 = newJObject()
  add(query_580068, "key", newJString(key))
  add(query_580068, "prettyPrint", newJBool(prettyPrint))
  add(query_580068, "oauth_token", newJString(oauthToken))
  add(query_580068, "locale", newJString(locale))
  add(query_580068, "volumeId", newJString(volumeId))
  add(query_580068, "source", newJString(source))
  add(query_580068, "alt", newJString(alt))
  add(query_580068, "userIp", newJString(userIp))
  add(query_580068, "quotaUser", newJString(quotaUser))
  add(query_580068, "nonce", newJString(nonce))
  add(query_580068, "fields", newJString(fields))
  add(query_580068, "cpksver", newJString(cpksver))
  add(query_580068, "licenseTypes", newJString(licenseTypes))
  result = call_580067.call(nil, query_580068, nil, nil, nil)

var booksMyconfigRequestAccess* = Call_BooksMyconfigRequestAccess_580050(
    name: "booksMyconfigRequestAccess", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/myconfig/requestAccess",
    validator: validate_BooksMyconfigRequestAccess_580051, base: "/books/v1",
    url: url_BooksMyconfigRequestAccess_580052, schemes: {Scheme.Https})
type
  Call_BooksMyconfigSyncVolumeLicenses_580069 = ref object of OpenApiRestCall_579389
proc url_BooksMyconfigSyncVolumeLicenses_580071(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BooksMyconfigSyncVolumeLicenses_580070(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Request downloaded content access for specified volumes on the My eBooks shelf.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   locale: JString
  ##         : ISO-639-1, ISO-3166-1 codes for message localization, i.e. en_US.
  ##   includeNonComicsSeries: JBool
  ##                         : Set to true to include non-comics series. Defaults to false.
  ##   source: JString (required)
  ##         : String to identify the originator of this request.
  ##   showPreorders: JBool
  ##                : Set to true to show pre-ordered books. Defaults to false.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   nonce: JString (required)
  ##        : The client nonce value.
  ##   features: JArray
  ##           : List of features supported by the client, i.e., 'RENTALS'
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   cpksver: JString (required)
  ##          : The device/version ID from which to release the restriction.
  ##   volumeIds: JArray
  ##            : The volume(s) to request download restrictions for.
  section = newJObject()
  var valid_580072 = query.getOrDefault("key")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "key", valid_580072
  var valid_580073 = query.getOrDefault("prettyPrint")
  valid_580073 = validateParameter(valid_580073, JBool, required = false,
                                 default = newJBool(true))
  if valid_580073 != nil:
    section.add "prettyPrint", valid_580073
  var valid_580074 = query.getOrDefault("oauth_token")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "oauth_token", valid_580074
  var valid_580075 = query.getOrDefault("locale")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "locale", valid_580075
  var valid_580076 = query.getOrDefault("includeNonComicsSeries")
  valid_580076 = validateParameter(valid_580076, JBool, required = false, default = nil)
  if valid_580076 != nil:
    section.add "includeNonComicsSeries", valid_580076
  assert query != nil, "query argument is necessary due to required `source` field"
  var valid_580077 = query.getOrDefault("source")
  valid_580077 = validateParameter(valid_580077, JString, required = true,
                                 default = nil)
  if valid_580077 != nil:
    section.add "source", valid_580077
  var valid_580078 = query.getOrDefault("showPreorders")
  valid_580078 = validateParameter(valid_580078, JBool, required = false, default = nil)
  if valid_580078 != nil:
    section.add "showPreorders", valid_580078
  var valid_580079 = query.getOrDefault("alt")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = newJString("json"))
  if valid_580079 != nil:
    section.add "alt", valid_580079
  var valid_580080 = query.getOrDefault("userIp")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "userIp", valid_580080
  var valid_580081 = query.getOrDefault("quotaUser")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "quotaUser", valid_580081
  var valid_580082 = query.getOrDefault("nonce")
  valid_580082 = validateParameter(valid_580082, JString, required = true,
                                 default = nil)
  if valid_580082 != nil:
    section.add "nonce", valid_580082
  var valid_580083 = query.getOrDefault("features")
  valid_580083 = validateParameter(valid_580083, JArray, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "features", valid_580083
  var valid_580084 = query.getOrDefault("fields")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "fields", valid_580084
  var valid_580085 = query.getOrDefault("cpksver")
  valid_580085 = validateParameter(valid_580085, JString, required = true,
                                 default = nil)
  if valid_580085 != nil:
    section.add "cpksver", valid_580085
  var valid_580086 = query.getOrDefault("volumeIds")
  valid_580086 = validateParameter(valid_580086, JArray, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "volumeIds", valid_580086
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580087: Call_BooksMyconfigSyncVolumeLicenses_580069;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Request downloaded content access for specified volumes on the My eBooks shelf.
  ## 
  let valid = call_580087.validator(path, query, header, formData, body)
  let scheme = call_580087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580087.url(scheme.get, call_580087.host, call_580087.base,
                         call_580087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580087, url, valid)

proc call*(call_580088: Call_BooksMyconfigSyncVolumeLicenses_580069;
          source: string; nonce: string; cpksver: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; locale: string = "";
          includeNonComicsSeries: bool = false; showPreorders: bool = false;
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          features: JsonNode = nil; fields: string = ""; volumeIds: JsonNode = nil): Recallable =
  ## booksMyconfigSyncVolumeLicenses
  ## Request downloaded content access for specified volumes on the My eBooks shelf.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   locale: string
  ##         : ISO-639-1, ISO-3166-1 codes for message localization, i.e. en_US.
  ##   includeNonComicsSeries: bool
  ##                         : Set to true to include non-comics series. Defaults to false.
  ##   source: string (required)
  ##         : String to identify the originator of this request.
  ##   showPreorders: bool
  ##                : Set to true to show pre-ordered books. Defaults to false.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   nonce: string (required)
  ##        : The client nonce value.
  ##   features: JArray
  ##           : List of features supported by the client, i.e., 'RENTALS'
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   cpksver: string (required)
  ##          : The device/version ID from which to release the restriction.
  ##   volumeIds: JArray
  ##            : The volume(s) to request download restrictions for.
  var query_580089 = newJObject()
  add(query_580089, "key", newJString(key))
  add(query_580089, "prettyPrint", newJBool(prettyPrint))
  add(query_580089, "oauth_token", newJString(oauthToken))
  add(query_580089, "locale", newJString(locale))
  add(query_580089, "includeNonComicsSeries", newJBool(includeNonComicsSeries))
  add(query_580089, "source", newJString(source))
  add(query_580089, "showPreorders", newJBool(showPreorders))
  add(query_580089, "alt", newJString(alt))
  add(query_580089, "userIp", newJString(userIp))
  add(query_580089, "quotaUser", newJString(quotaUser))
  add(query_580089, "nonce", newJString(nonce))
  if features != nil:
    query_580089.add "features", features
  add(query_580089, "fields", newJString(fields))
  add(query_580089, "cpksver", newJString(cpksver))
  if volumeIds != nil:
    query_580089.add "volumeIds", volumeIds
  result = call_580088.call(nil, query_580089, nil, nil, nil)

var booksMyconfigSyncVolumeLicenses* = Call_BooksMyconfigSyncVolumeLicenses_580069(
    name: "booksMyconfigSyncVolumeLicenses", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/myconfig/syncVolumeLicenses",
    validator: validate_BooksMyconfigSyncVolumeLicenses_580070, base: "/books/v1",
    url: url_BooksMyconfigSyncVolumeLicenses_580071, schemes: {Scheme.Https})
type
  Call_BooksMyconfigUpdateUserSettings_580090 = ref object of OpenApiRestCall_579389
proc url_BooksMyconfigUpdateUserSettings_580092(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BooksMyconfigUpdateUserSettings_580091(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the settings for the user. If a sub-object is specified, it will overwrite the existing sub-object stored in the server. Unspecified sub-objects will retain the existing value.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580093 = query.getOrDefault("key")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "key", valid_580093
  var valid_580094 = query.getOrDefault("prettyPrint")
  valid_580094 = validateParameter(valid_580094, JBool, required = false,
                                 default = newJBool(true))
  if valid_580094 != nil:
    section.add "prettyPrint", valid_580094
  var valid_580095 = query.getOrDefault("oauth_token")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "oauth_token", valid_580095
  var valid_580096 = query.getOrDefault("alt")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = newJString("json"))
  if valid_580096 != nil:
    section.add "alt", valid_580096
  var valid_580097 = query.getOrDefault("userIp")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "userIp", valid_580097
  var valid_580098 = query.getOrDefault("quotaUser")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "quotaUser", valid_580098
  var valid_580099 = query.getOrDefault("fields")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "fields", valid_580099
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

proc call*(call_580101: Call_BooksMyconfigUpdateUserSettings_580090;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the settings for the user. If a sub-object is specified, it will overwrite the existing sub-object stored in the server. Unspecified sub-objects will retain the existing value.
  ## 
  let valid = call_580101.validator(path, query, header, formData, body)
  let scheme = call_580101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580101.url(scheme.get, call_580101.host, call_580101.base,
                         call_580101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580101, url, valid)

proc call*(call_580102: Call_BooksMyconfigUpdateUserSettings_580090;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## booksMyconfigUpdateUserSettings
  ## Sets the settings for the user. If a sub-object is specified, it will overwrite the existing sub-object stored in the server. Unspecified sub-objects will retain the existing value.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580103 = newJObject()
  var body_580104 = newJObject()
  add(query_580103, "key", newJString(key))
  add(query_580103, "prettyPrint", newJBool(prettyPrint))
  add(query_580103, "oauth_token", newJString(oauthToken))
  add(query_580103, "alt", newJString(alt))
  add(query_580103, "userIp", newJString(userIp))
  add(query_580103, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580104 = body
  add(query_580103, "fields", newJString(fields))
  result = call_580102.call(nil, query_580103, nil, nil, body_580104)

var booksMyconfigUpdateUserSettings* = Call_BooksMyconfigUpdateUserSettings_580090(
    name: "booksMyconfigUpdateUserSettings", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/myconfig/updateUserSettings",
    validator: validate_BooksMyconfigUpdateUserSettings_580091, base: "/books/v1",
    url: url_BooksMyconfigUpdateUserSettings_580092, schemes: {Scheme.Https})
type
  Call_BooksMylibraryAnnotationsInsert_580128 = ref object of OpenApiRestCall_579389
proc url_BooksMylibraryAnnotationsInsert_580130(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BooksMylibraryAnnotationsInsert_580129(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts a new annotation.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   showOnlySummaryInResponse: JBool
  ##                            : Requests that only the summary of the specified layer be provided in the response.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   annotationId: JString
  ##               : The ID for the annotation to insert.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   country: JString
  ##          : ISO-3166-1 code to override the IP-based location.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580131 = query.getOrDefault("key")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "key", valid_580131
  var valid_580132 = query.getOrDefault("prettyPrint")
  valid_580132 = validateParameter(valid_580132, JBool, required = false,
                                 default = newJBool(true))
  if valid_580132 != nil:
    section.add "prettyPrint", valid_580132
  var valid_580133 = query.getOrDefault("oauth_token")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "oauth_token", valid_580133
  var valid_580134 = query.getOrDefault("showOnlySummaryInResponse")
  valid_580134 = validateParameter(valid_580134, JBool, required = false, default = nil)
  if valid_580134 != nil:
    section.add "showOnlySummaryInResponse", valid_580134
  var valid_580135 = query.getOrDefault("source")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "source", valid_580135
  var valid_580136 = query.getOrDefault("annotationId")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "annotationId", valid_580136
  var valid_580137 = query.getOrDefault("alt")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = newJString("json"))
  if valid_580137 != nil:
    section.add "alt", valid_580137
  var valid_580138 = query.getOrDefault("userIp")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "userIp", valid_580138
  var valid_580139 = query.getOrDefault("quotaUser")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "quotaUser", valid_580139
  var valid_580140 = query.getOrDefault("country")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "country", valid_580140
  var valid_580141 = query.getOrDefault("fields")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "fields", valid_580141
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

proc call*(call_580143: Call_BooksMylibraryAnnotationsInsert_580128;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a new annotation.
  ## 
  let valid = call_580143.validator(path, query, header, formData, body)
  let scheme = call_580143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580143.url(scheme.get, call_580143.host, call_580143.base,
                         call_580143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580143, url, valid)

proc call*(call_580144: Call_BooksMylibraryAnnotationsInsert_580128;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          showOnlySummaryInResponse: bool = false; source: string = "";
          annotationId: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; country: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## booksMylibraryAnnotationsInsert
  ## Inserts a new annotation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   showOnlySummaryInResponse: bool
  ##                            : Requests that only the summary of the specified layer be provided in the response.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   annotationId: string
  ##               : The ID for the annotation to insert.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   country: string
  ##          : ISO-3166-1 code to override the IP-based location.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580145 = newJObject()
  var body_580146 = newJObject()
  add(query_580145, "key", newJString(key))
  add(query_580145, "prettyPrint", newJBool(prettyPrint))
  add(query_580145, "oauth_token", newJString(oauthToken))
  add(query_580145, "showOnlySummaryInResponse",
      newJBool(showOnlySummaryInResponse))
  add(query_580145, "source", newJString(source))
  add(query_580145, "annotationId", newJString(annotationId))
  add(query_580145, "alt", newJString(alt))
  add(query_580145, "userIp", newJString(userIp))
  add(query_580145, "quotaUser", newJString(quotaUser))
  add(query_580145, "country", newJString(country))
  if body != nil:
    body_580146 = body
  add(query_580145, "fields", newJString(fields))
  result = call_580144.call(nil, query_580145, nil, nil, body_580146)

var booksMylibraryAnnotationsInsert* = Call_BooksMylibraryAnnotationsInsert_580128(
    name: "booksMylibraryAnnotationsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/mylibrary/annotations",
    validator: validate_BooksMylibraryAnnotationsInsert_580129, base: "/books/v1",
    url: url_BooksMylibraryAnnotationsInsert_580130, schemes: {Scheme.Https})
type
  Call_BooksMylibraryAnnotationsList_580105 = ref object of OpenApiRestCall_579389
proc url_BooksMylibraryAnnotationsList_580107(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BooksMylibraryAnnotationsList_580106(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of annotations, possibly filtered.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   volumeId: JString
  ##           : The volume to restrict annotations to.
  ##   layerId: JString
  ##          : The layer ID to limit annotation by.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   layerIds: JArray
  ##           : The layer ID(s) to limit annotation by.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   contentVersion: JString
  ##                 : The content version for the requested volume.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The value of the nextToken from the previous page.
  ##   updatedMax: JString
  ##             : RFC 3339 timestamp to restrict to items updated prior to this timestamp (exclusive).
  ##   updatedMin: JString
  ##             : RFC 3339 timestamp to restrict to items updated since this timestamp (inclusive).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   showDeleted: JBool
  ##              : Set to true to return deleted annotations. updatedMin must be in the request to use this. Defaults to false.
  ##   maxResults: JInt
  ##             : Maximum number of results to return
  section = newJObject()
  var valid_580108 = query.getOrDefault("key")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "key", valid_580108
  var valid_580109 = query.getOrDefault("prettyPrint")
  valid_580109 = validateParameter(valid_580109, JBool, required = false,
                                 default = newJBool(true))
  if valid_580109 != nil:
    section.add "prettyPrint", valid_580109
  var valid_580110 = query.getOrDefault("oauth_token")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "oauth_token", valid_580110
  var valid_580111 = query.getOrDefault("volumeId")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "volumeId", valid_580111
  var valid_580112 = query.getOrDefault("layerId")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "layerId", valid_580112
  var valid_580113 = query.getOrDefault("source")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "source", valid_580113
  var valid_580114 = query.getOrDefault("layerIds")
  valid_580114 = validateParameter(valid_580114, JArray, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "layerIds", valid_580114
  var valid_580115 = query.getOrDefault("alt")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = newJString("json"))
  if valid_580115 != nil:
    section.add "alt", valid_580115
  var valid_580116 = query.getOrDefault("userIp")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "userIp", valid_580116
  var valid_580117 = query.getOrDefault("contentVersion")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "contentVersion", valid_580117
  var valid_580118 = query.getOrDefault("quotaUser")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "quotaUser", valid_580118
  var valid_580119 = query.getOrDefault("pageToken")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "pageToken", valid_580119
  var valid_580120 = query.getOrDefault("updatedMax")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "updatedMax", valid_580120
  var valid_580121 = query.getOrDefault("updatedMin")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "updatedMin", valid_580121
  var valid_580122 = query.getOrDefault("fields")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "fields", valid_580122
  var valid_580123 = query.getOrDefault("showDeleted")
  valid_580123 = validateParameter(valid_580123, JBool, required = false, default = nil)
  if valid_580123 != nil:
    section.add "showDeleted", valid_580123
  var valid_580124 = query.getOrDefault("maxResults")
  valid_580124 = validateParameter(valid_580124, JInt, required = false, default = nil)
  if valid_580124 != nil:
    section.add "maxResults", valid_580124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580125: Call_BooksMylibraryAnnotationsList_580105; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of annotations, possibly filtered.
  ## 
  let valid = call_580125.validator(path, query, header, formData, body)
  let scheme = call_580125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580125.url(scheme.get, call_580125.host, call_580125.base,
                         call_580125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580125, url, valid)

proc call*(call_580126: Call_BooksMylibraryAnnotationsList_580105;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          volumeId: string = ""; layerId: string = ""; source: string = "";
          layerIds: JsonNode = nil; alt: string = "json"; userIp: string = "";
          contentVersion: string = ""; quotaUser: string = ""; pageToken: string = "";
          updatedMax: string = ""; updatedMin: string = ""; fields: string = "";
          showDeleted: bool = false; maxResults: int = 0): Recallable =
  ## booksMylibraryAnnotationsList
  ## Retrieves a list of annotations, possibly filtered.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   volumeId: string
  ##           : The volume to restrict annotations to.
  ##   layerId: string
  ##          : The layer ID to limit annotation by.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   layerIds: JArray
  ##           : The layer ID(s) to limit annotation by.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   contentVersion: string
  ##                 : The content version for the requested volume.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : The value of the nextToken from the previous page.
  ##   updatedMax: string
  ##             : RFC 3339 timestamp to restrict to items updated prior to this timestamp (exclusive).
  ##   updatedMin: string
  ##             : RFC 3339 timestamp to restrict to items updated since this timestamp (inclusive).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   showDeleted: bool
  ##              : Set to true to return deleted annotations. updatedMin must be in the request to use this. Defaults to false.
  ##   maxResults: int
  ##             : Maximum number of results to return
  var query_580127 = newJObject()
  add(query_580127, "key", newJString(key))
  add(query_580127, "prettyPrint", newJBool(prettyPrint))
  add(query_580127, "oauth_token", newJString(oauthToken))
  add(query_580127, "volumeId", newJString(volumeId))
  add(query_580127, "layerId", newJString(layerId))
  add(query_580127, "source", newJString(source))
  if layerIds != nil:
    query_580127.add "layerIds", layerIds
  add(query_580127, "alt", newJString(alt))
  add(query_580127, "userIp", newJString(userIp))
  add(query_580127, "contentVersion", newJString(contentVersion))
  add(query_580127, "quotaUser", newJString(quotaUser))
  add(query_580127, "pageToken", newJString(pageToken))
  add(query_580127, "updatedMax", newJString(updatedMax))
  add(query_580127, "updatedMin", newJString(updatedMin))
  add(query_580127, "fields", newJString(fields))
  add(query_580127, "showDeleted", newJBool(showDeleted))
  add(query_580127, "maxResults", newJInt(maxResults))
  result = call_580126.call(nil, query_580127, nil, nil, nil)

var booksMylibraryAnnotationsList* = Call_BooksMylibraryAnnotationsList_580105(
    name: "booksMylibraryAnnotationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/mylibrary/annotations",
    validator: validate_BooksMylibraryAnnotationsList_580106, base: "/books/v1",
    url: url_BooksMylibraryAnnotationsList_580107, schemes: {Scheme.Https})
type
  Call_BooksMylibraryAnnotationsSummary_580147 = ref object of OpenApiRestCall_579389
proc url_BooksMylibraryAnnotationsSummary_580149(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BooksMylibraryAnnotationsSummary_580148(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the summary of specified layers.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   volumeId: JString (required)
  ##           : Volume id to get the summary for.
  ##   layerIds: JArray (required)
  ##           : Array of layer IDs to get the summary for.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580150 = query.getOrDefault("key")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "key", valid_580150
  var valid_580151 = query.getOrDefault("prettyPrint")
  valid_580151 = validateParameter(valid_580151, JBool, required = false,
                                 default = newJBool(true))
  if valid_580151 != nil:
    section.add "prettyPrint", valid_580151
  var valid_580152 = query.getOrDefault("oauth_token")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "oauth_token", valid_580152
  assert query != nil,
        "query argument is necessary due to required `volumeId` field"
  var valid_580153 = query.getOrDefault("volumeId")
  valid_580153 = validateParameter(valid_580153, JString, required = true,
                                 default = nil)
  if valid_580153 != nil:
    section.add "volumeId", valid_580153
  var valid_580154 = query.getOrDefault("layerIds")
  valid_580154 = validateParameter(valid_580154, JArray, required = true, default = nil)
  if valid_580154 != nil:
    section.add "layerIds", valid_580154
  var valid_580155 = query.getOrDefault("alt")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = newJString("json"))
  if valid_580155 != nil:
    section.add "alt", valid_580155
  var valid_580156 = query.getOrDefault("userIp")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "userIp", valid_580156
  var valid_580157 = query.getOrDefault("quotaUser")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "quotaUser", valid_580157
  var valid_580158 = query.getOrDefault("fields")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "fields", valid_580158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580159: Call_BooksMylibraryAnnotationsSummary_580147;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the summary of specified layers.
  ## 
  let valid = call_580159.validator(path, query, header, formData, body)
  let scheme = call_580159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580159.url(scheme.get, call_580159.host, call_580159.base,
                         call_580159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580159, url, valid)

proc call*(call_580160: Call_BooksMylibraryAnnotationsSummary_580147;
          volumeId: string; layerIds: JsonNode; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## booksMylibraryAnnotationsSummary
  ## Gets the summary of specified layers.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   volumeId: string (required)
  ##           : Volume id to get the summary for.
  ##   layerIds: JArray (required)
  ##           : Array of layer IDs to get the summary for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580161 = newJObject()
  add(query_580161, "key", newJString(key))
  add(query_580161, "prettyPrint", newJBool(prettyPrint))
  add(query_580161, "oauth_token", newJString(oauthToken))
  add(query_580161, "volumeId", newJString(volumeId))
  if layerIds != nil:
    query_580161.add "layerIds", layerIds
  add(query_580161, "alt", newJString(alt))
  add(query_580161, "userIp", newJString(userIp))
  add(query_580161, "quotaUser", newJString(quotaUser))
  add(query_580161, "fields", newJString(fields))
  result = call_580160.call(nil, query_580161, nil, nil, nil)

var booksMylibraryAnnotationsSummary* = Call_BooksMylibraryAnnotationsSummary_580147(
    name: "booksMylibraryAnnotationsSummary", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/mylibrary/annotations/summary",
    validator: validate_BooksMylibraryAnnotationsSummary_580148,
    base: "/books/v1", url: url_BooksMylibraryAnnotationsSummary_580149,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryAnnotationsUpdate_580162 = ref object of OpenApiRestCall_579389
proc url_BooksMylibraryAnnotationsUpdate_580164(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BooksMylibraryAnnotationsUpdate_580163(path: JsonNode;
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
  var valid_580179 = path.getOrDefault("annotationId")
  valid_580179 = validateParameter(valid_580179, JString, required = true,
                                 default = nil)
  if valid_580179 != nil:
    section.add "annotationId", valid_580179
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580180 = query.getOrDefault("key")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "key", valid_580180
  var valid_580181 = query.getOrDefault("prettyPrint")
  valid_580181 = validateParameter(valid_580181, JBool, required = false,
                                 default = newJBool(true))
  if valid_580181 != nil:
    section.add "prettyPrint", valid_580181
  var valid_580182 = query.getOrDefault("oauth_token")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "oauth_token", valid_580182
  var valid_580183 = query.getOrDefault("source")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "source", valid_580183
  var valid_580184 = query.getOrDefault("alt")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = newJString("json"))
  if valid_580184 != nil:
    section.add "alt", valid_580184
  var valid_580185 = query.getOrDefault("userIp")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "userIp", valid_580185
  var valid_580186 = query.getOrDefault("quotaUser")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "quotaUser", valid_580186
  var valid_580187 = query.getOrDefault("fields")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "fields", valid_580187
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

proc call*(call_580189: Call_BooksMylibraryAnnotationsUpdate_580162;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing annotation.
  ## 
  let valid = call_580189.validator(path, query, header, formData, body)
  let scheme = call_580189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580189.url(scheme.get, call_580189.host, call_580189.base,
                         call_580189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580189, url, valid)

proc call*(call_580190: Call_BooksMylibraryAnnotationsUpdate_580162;
          annotationId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; source: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## booksMylibraryAnnotationsUpdate
  ## Updates an existing annotation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   annotationId: string (required)
  ##               : The ID for the annotation to update.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580191 = newJObject()
  var query_580192 = newJObject()
  var body_580193 = newJObject()
  add(query_580192, "key", newJString(key))
  add(query_580192, "prettyPrint", newJBool(prettyPrint))
  add(query_580192, "oauth_token", newJString(oauthToken))
  add(query_580192, "source", newJString(source))
  add(path_580191, "annotationId", newJString(annotationId))
  add(query_580192, "alt", newJString(alt))
  add(query_580192, "userIp", newJString(userIp))
  add(query_580192, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580193 = body
  add(query_580192, "fields", newJString(fields))
  result = call_580190.call(path_580191, query_580192, nil, nil, body_580193)

var booksMylibraryAnnotationsUpdate* = Call_BooksMylibraryAnnotationsUpdate_580162(
    name: "booksMylibraryAnnotationsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/mylibrary/annotations/{annotationId}",
    validator: validate_BooksMylibraryAnnotationsUpdate_580163, base: "/books/v1",
    url: url_BooksMylibraryAnnotationsUpdate_580164, schemes: {Scheme.Https})
type
  Call_BooksMylibraryAnnotationsDelete_580194 = ref object of OpenApiRestCall_579389
proc url_BooksMylibraryAnnotationsDelete_580196(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BooksMylibraryAnnotationsDelete_580195(path: JsonNode;
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
  var valid_580197 = path.getOrDefault("annotationId")
  valid_580197 = validateParameter(valid_580197, JString, required = true,
                                 default = nil)
  if valid_580197 != nil:
    section.add "annotationId", valid_580197
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580198 = query.getOrDefault("key")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "key", valid_580198
  var valid_580199 = query.getOrDefault("prettyPrint")
  valid_580199 = validateParameter(valid_580199, JBool, required = false,
                                 default = newJBool(true))
  if valid_580199 != nil:
    section.add "prettyPrint", valid_580199
  var valid_580200 = query.getOrDefault("oauth_token")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "oauth_token", valid_580200
  var valid_580201 = query.getOrDefault("source")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "source", valid_580201
  var valid_580202 = query.getOrDefault("alt")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = newJString("json"))
  if valid_580202 != nil:
    section.add "alt", valid_580202
  var valid_580203 = query.getOrDefault("userIp")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "userIp", valid_580203
  var valid_580204 = query.getOrDefault("quotaUser")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "quotaUser", valid_580204
  var valid_580205 = query.getOrDefault("fields")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "fields", valid_580205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580206: Call_BooksMylibraryAnnotationsDelete_580194;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an annotation.
  ## 
  let valid = call_580206.validator(path, query, header, formData, body)
  let scheme = call_580206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580206.url(scheme.get, call_580206.host, call_580206.base,
                         call_580206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580206, url, valid)

proc call*(call_580207: Call_BooksMylibraryAnnotationsDelete_580194;
          annotationId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; source: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## booksMylibraryAnnotationsDelete
  ## Deletes an annotation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   annotationId: string (required)
  ##               : The ID for the annotation to delete.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580208 = newJObject()
  var query_580209 = newJObject()
  add(query_580209, "key", newJString(key))
  add(query_580209, "prettyPrint", newJBool(prettyPrint))
  add(query_580209, "oauth_token", newJString(oauthToken))
  add(query_580209, "source", newJString(source))
  add(path_580208, "annotationId", newJString(annotationId))
  add(query_580209, "alt", newJString(alt))
  add(query_580209, "userIp", newJString(userIp))
  add(query_580209, "quotaUser", newJString(quotaUser))
  add(query_580209, "fields", newJString(fields))
  result = call_580207.call(path_580208, query_580209, nil, nil, nil)

var booksMylibraryAnnotationsDelete* = Call_BooksMylibraryAnnotationsDelete_580194(
    name: "booksMylibraryAnnotationsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/mylibrary/annotations/{annotationId}",
    validator: validate_BooksMylibraryAnnotationsDelete_580195, base: "/books/v1",
    url: url_BooksMylibraryAnnotationsDelete_580196, schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesList_580210 = ref object of OpenApiRestCall_579389
proc url_BooksMylibraryBookshelvesList_580212(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BooksMylibraryBookshelvesList_580211(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of bookshelves belonging to the authenticated user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580213 = query.getOrDefault("key")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "key", valid_580213
  var valid_580214 = query.getOrDefault("prettyPrint")
  valid_580214 = validateParameter(valid_580214, JBool, required = false,
                                 default = newJBool(true))
  if valid_580214 != nil:
    section.add "prettyPrint", valid_580214
  var valid_580215 = query.getOrDefault("oauth_token")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "oauth_token", valid_580215
  var valid_580216 = query.getOrDefault("source")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "source", valid_580216
  var valid_580217 = query.getOrDefault("alt")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = newJString("json"))
  if valid_580217 != nil:
    section.add "alt", valid_580217
  var valid_580218 = query.getOrDefault("userIp")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "userIp", valid_580218
  var valid_580219 = query.getOrDefault("quotaUser")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "quotaUser", valid_580219
  var valid_580220 = query.getOrDefault("fields")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "fields", valid_580220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580221: Call_BooksMylibraryBookshelvesList_580210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of bookshelves belonging to the authenticated user.
  ## 
  let valid = call_580221.validator(path, query, header, formData, body)
  let scheme = call_580221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580221.url(scheme.get, call_580221.host, call_580221.base,
                         call_580221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580221, url, valid)

proc call*(call_580222: Call_BooksMylibraryBookshelvesList_580210;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          source: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## booksMylibraryBookshelvesList
  ## Retrieves a list of bookshelves belonging to the authenticated user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580223 = newJObject()
  add(query_580223, "key", newJString(key))
  add(query_580223, "prettyPrint", newJBool(prettyPrint))
  add(query_580223, "oauth_token", newJString(oauthToken))
  add(query_580223, "source", newJString(source))
  add(query_580223, "alt", newJString(alt))
  add(query_580223, "userIp", newJString(userIp))
  add(query_580223, "quotaUser", newJString(quotaUser))
  add(query_580223, "fields", newJString(fields))
  result = call_580222.call(nil, query_580223, nil, nil, nil)

var booksMylibraryBookshelvesList* = Call_BooksMylibraryBookshelvesList_580210(
    name: "booksMylibraryBookshelvesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/mylibrary/bookshelves",
    validator: validate_BooksMylibraryBookshelvesList_580211, base: "/books/v1",
    url: url_BooksMylibraryBookshelvesList_580212, schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesGet_580224 = ref object of OpenApiRestCall_579389
proc url_BooksMylibraryBookshelvesGet_580226(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BooksMylibraryBookshelvesGet_580225(path: JsonNode; query: JsonNode;
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
  var valid_580227 = path.getOrDefault("shelf")
  valid_580227 = validateParameter(valid_580227, JString, required = true,
                                 default = nil)
  if valid_580227 != nil:
    section.add "shelf", valid_580227
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580228 = query.getOrDefault("key")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "key", valid_580228
  var valid_580229 = query.getOrDefault("prettyPrint")
  valid_580229 = validateParameter(valid_580229, JBool, required = false,
                                 default = newJBool(true))
  if valid_580229 != nil:
    section.add "prettyPrint", valid_580229
  var valid_580230 = query.getOrDefault("oauth_token")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "oauth_token", valid_580230
  var valid_580231 = query.getOrDefault("source")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "source", valid_580231
  var valid_580232 = query.getOrDefault("alt")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = newJString("json"))
  if valid_580232 != nil:
    section.add "alt", valid_580232
  var valid_580233 = query.getOrDefault("userIp")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "userIp", valid_580233
  var valid_580234 = query.getOrDefault("quotaUser")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "quotaUser", valid_580234
  var valid_580235 = query.getOrDefault("fields")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "fields", valid_580235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580236: Call_BooksMylibraryBookshelvesGet_580224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves metadata for a specific bookshelf belonging to the authenticated user.
  ## 
  let valid = call_580236.validator(path, query, header, formData, body)
  let scheme = call_580236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580236.url(scheme.get, call_580236.host, call_580236.base,
                         call_580236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580236, url, valid)

proc call*(call_580237: Call_BooksMylibraryBookshelvesGet_580224; shelf: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          source: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## booksMylibraryBookshelvesGet
  ## Retrieves metadata for a specific bookshelf belonging to the authenticated user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   shelf: string (required)
  ##        : ID of bookshelf to retrieve.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580238 = newJObject()
  var query_580239 = newJObject()
  add(query_580239, "key", newJString(key))
  add(query_580239, "prettyPrint", newJBool(prettyPrint))
  add(query_580239, "oauth_token", newJString(oauthToken))
  add(query_580239, "source", newJString(source))
  add(query_580239, "alt", newJString(alt))
  add(query_580239, "userIp", newJString(userIp))
  add(query_580239, "quotaUser", newJString(quotaUser))
  add(path_580238, "shelf", newJString(shelf))
  add(query_580239, "fields", newJString(fields))
  result = call_580237.call(path_580238, query_580239, nil, nil, nil)

var booksMylibraryBookshelvesGet* = Call_BooksMylibraryBookshelvesGet_580224(
    name: "booksMylibraryBookshelvesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/mylibrary/bookshelves/{shelf}",
    validator: validate_BooksMylibraryBookshelvesGet_580225, base: "/books/v1",
    url: url_BooksMylibraryBookshelvesGet_580226, schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesAddVolume_580240 = ref object of OpenApiRestCall_579389
proc url_BooksMylibraryBookshelvesAddVolume_580242(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BooksMylibraryBookshelvesAddVolume_580241(path: JsonNode;
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
  var valid_580243 = path.getOrDefault("shelf")
  valid_580243 = validateParameter(valid_580243, JString, required = true,
                                 default = nil)
  if valid_580243 != nil:
    section.add "shelf", valid_580243
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   volumeId: JString (required)
  ##           : ID of volume to add.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   reason: JString
  ##         : The reason for which the book is added to the library.
  section = newJObject()
  var valid_580244 = query.getOrDefault("key")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "key", valid_580244
  var valid_580245 = query.getOrDefault("prettyPrint")
  valid_580245 = validateParameter(valid_580245, JBool, required = false,
                                 default = newJBool(true))
  if valid_580245 != nil:
    section.add "prettyPrint", valid_580245
  var valid_580246 = query.getOrDefault("oauth_token")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "oauth_token", valid_580246
  assert query != nil,
        "query argument is necessary due to required `volumeId` field"
  var valid_580247 = query.getOrDefault("volumeId")
  valid_580247 = validateParameter(valid_580247, JString, required = true,
                                 default = nil)
  if valid_580247 != nil:
    section.add "volumeId", valid_580247
  var valid_580248 = query.getOrDefault("source")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "source", valid_580248
  var valid_580249 = query.getOrDefault("alt")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = newJString("json"))
  if valid_580249 != nil:
    section.add "alt", valid_580249
  var valid_580250 = query.getOrDefault("userIp")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "userIp", valid_580250
  var valid_580251 = query.getOrDefault("quotaUser")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "quotaUser", valid_580251
  var valid_580252 = query.getOrDefault("fields")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "fields", valid_580252
  var valid_580253 = query.getOrDefault("reason")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = newJString("IOS_PREX"))
  if valid_580253 != nil:
    section.add "reason", valid_580253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580254: Call_BooksMylibraryBookshelvesAddVolume_580240;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a volume to a bookshelf.
  ## 
  let valid = call_580254.validator(path, query, header, formData, body)
  let scheme = call_580254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580254.url(scheme.get, call_580254.host, call_580254.base,
                         call_580254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580254, url, valid)

proc call*(call_580255: Call_BooksMylibraryBookshelvesAddVolume_580240;
          volumeId: string; shelf: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; source: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = "";
          reason: string = "IOS_PREX"): Recallable =
  ## booksMylibraryBookshelvesAddVolume
  ## Adds a volume to a bookshelf.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   volumeId: string (required)
  ##           : ID of volume to add.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   shelf: string (required)
  ##        : ID of bookshelf to which to add a volume.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   reason: string
  ##         : The reason for which the book is added to the library.
  var path_580256 = newJObject()
  var query_580257 = newJObject()
  add(query_580257, "key", newJString(key))
  add(query_580257, "prettyPrint", newJBool(prettyPrint))
  add(query_580257, "oauth_token", newJString(oauthToken))
  add(query_580257, "volumeId", newJString(volumeId))
  add(query_580257, "source", newJString(source))
  add(query_580257, "alt", newJString(alt))
  add(query_580257, "userIp", newJString(userIp))
  add(query_580257, "quotaUser", newJString(quotaUser))
  add(path_580256, "shelf", newJString(shelf))
  add(query_580257, "fields", newJString(fields))
  add(query_580257, "reason", newJString(reason))
  result = call_580255.call(path_580256, query_580257, nil, nil, nil)

var booksMylibraryBookshelvesAddVolume* = Call_BooksMylibraryBookshelvesAddVolume_580240(
    name: "booksMylibraryBookshelvesAddVolume", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/mylibrary/bookshelves/{shelf}/addVolume",
    validator: validate_BooksMylibraryBookshelvesAddVolume_580241,
    base: "/books/v1", url: url_BooksMylibraryBookshelvesAddVolume_580242,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesClearVolumes_580258 = ref object of OpenApiRestCall_579389
proc url_BooksMylibraryBookshelvesClearVolumes_580260(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BooksMylibraryBookshelvesClearVolumes_580259(path: JsonNode;
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
  var valid_580261 = path.getOrDefault("shelf")
  valid_580261 = validateParameter(valid_580261, JString, required = true,
                                 default = nil)
  if valid_580261 != nil:
    section.add "shelf", valid_580261
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580262 = query.getOrDefault("key")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "key", valid_580262
  var valid_580263 = query.getOrDefault("prettyPrint")
  valid_580263 = validateParameter(valid_580263, JBool, required = false,
                                 default = newJBool(true))
  if valid_580263 != nil:
    section.add "prettyPrint", valid_580263
  var valid_580264 = query.getOrDefault("oauth_token")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "oauth_token", valid_580264
  var valid_580265 = query.getOrDefault("source")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "source", valid_580265
  var valid_580266 = query.getOrDefault("alt")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = newJString("json"))
  if valid_580266 != nil:
    section.add "alt", valid_580266
  var valid_580267 = query.getOrDefault("userIp")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "userIp", valid_580267
  var valid_580268 = query.getOrDefault("quotaUser")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "quotaUser", valid_580268
  var valid_580269 = query.getOrDefault("fields")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "fields", valid_580269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580270: Call_BooksMylibraryBookshelvesClearVolumes_580258;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Clears all volumes from a bookshelf.
  ## 
  let valid = call_580270.validator(path, query, header, formData, body)
  let scheme = call_580270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580270.url(scheme.get, call_580270.host, call_580270.base,
                         call_580270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580270, url, valid)

proc call*(call_580271: Call_BooksMylibraryBookshelvesClearVolumes_580258;
          shelf: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; source: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## booksMylibraryBookshelvesClearVolumes
  ## Clears all volumes from a bookshelf.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   shelf: string (required)
  ##        : ID of bookshelf from which to remove a volume.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580272 = newJObject()
  var query_580273 = newJObject()
  add(query_580273, "key", newJString(key))
  add(query_580273, "prettyPrint", newJBool(prettyPrint))
  add(query_580273, "oauth_token", newJString(oauthToken))
  add(query_580273, "source", newJString(source))
  add(query_580273, "alt", newJString(alt))
  add(query_580273, "userIp", newJString(userIp))
  add(query_580273, "quotaUser", newJString(quotaUser))
  add(path_580272, "shelf", newJString(shelf))
  add(query_580273, "fields", newJString(fields))
  result = call_580271.call(path_580272, query_580273, nil, nil, nil)

var booksMylibraryBookshelvesClearVolumes* = Call_BooksMylibraryBookshelvesClearVolumes_580258(
    name: "booksMylibraryBookshelvesClearVolumes", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/mylibrary/bookshelves/{shelf}/clearVolumes",
    validator: validate_BooksMylibraryBookshelvesClearVolumes_580259,
    base: "/books/v1", url: url_BooksMylibraryBookshelvesClearVolumes_580260,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesMoveVolume_580274 = ref object of OpenApiRestCall_579389
proc url_BooksMylibraryBookshelvesMoveVolume_580276(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BooksMylibraryBookshelvesMoveVolume_580275(path: JsonNode;
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
  var valid_580277 = path.getOrDefault("shelf")
  valid_580277 = validateParameter(valid_580277, JString, required = true,
                                 default = nil)
  if valid_580277 != nil:
    section.add "shelf", valid_580277
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   volumeId: JString (required)
  ##           : ID of volume to move.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   volumePosition: JInt (required)
  ##                 : Position on shelf to move the item (0 puts the item before the current first item, 1 puts it between the first and the second and so on.)
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580278 = query.getOrDefault("key")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "key", valid_580278
  var valid_580279 = query.getOrDefault("prettyPrint")
  valid_580279 = validateParameter(valid_580279, JBool, required = false,
                                 default = newJBool(true))
  if valid_580279 != nil:
    section.add "prettyPrint", valid_580279
  var valid_580280 = query.getOrDefault("oauth_token")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "oauth_token", valid_580280
  assert query != nil,
        "query argument is necessary due to required `volumeId` field"
  var valid_580281 = query.getOrDefault("volumeId")
  valid_580281 = validateParameter(valid_580281, JString, required = true,
                                 default = nil)
  if valid_580281 != nil:
    section.add "volumeId", valid_580281
  var valid_580282 = query.getOrDefault("source")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "source", valid_580282
  var valid_580283 = query.getOrDefault("alt")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = newJString("json"))
  if valid_580283 != nil:
    section.add "alt", valid_580283
  var valid_580284 = query.getOrDefault("userIp")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "userIp", valid_580284
  var valid_580285 = query.getOrDefault("quotaUser")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "quotaUser", valid_580285
  var valid_580286 = query.getOrDefault("volumePosition")
  valid_580286 = validateParameter(valid_580286, JInt, required = true, default = nil)
  if valid_580286 != nil:
    section.add "volumePosition", valid_580286
  var valid_580287 = query.getOrDefault("fields")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "fields", valid_580287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580288: Call_BooksMylibraryBookshelvesMoveVolume_580274;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Moves a volume within a bookshelf.
  ## 
  let valid = call_580288.validator(path, query, header, formData, body)
  let scheme = call_580288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580288.url(scheme.get, call_580288.host, call_580288.base,
                         call_580288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580288, url, valid)

proc call*(call_580289: Call_BooksMylibraryBookshelvesMoveVolume_580274;
          volumeId: string; volumePosition: int; shelf: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; source: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## booksMylibraryBookshelvesMoveVolume
  ## Moves a volume within a bookshelf.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   volumeId: string (required)
  ##           : ID of volume to move.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   volumePosition: int (required)
  ##                 : Position on shelf to move the item (0 puts the item before the current first item, 1 puts it between the first and the second and so on.)
  ##   shelf: string (required)
  ##        : ID of bookshelf with the volume.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580290 = newJObject()
  var query_580291 = newJObject()
  add(query_580291, "key", newJString(key))
  add(query_580291, "prettyPrint", newJBool(prettyPrint))
  add(query_580291, "oauth_token", newJString(oauthToken))
  add(query_580291, "volumeId", newJString(volumeId))
  add(query_580291, "source", newJString(source))
  add(query_580291, "alt", newJString(alt))
  add(query_580291, "userIp", newJString(userIp))
  add(query_580291, "quotaUser", newJString(quotaUser))
  add(query_580291, "volumePosition", newJInt(volumePosition))
  add(path_580290, "shelf", newJString(shelf))
  add(query_580291, "fields", newJString(fields))
  result = call_580289.call(path_580290, query_580291, nil, nil, nil)

var booksMylibraryBookshelvesMoveVolume* = Call_BooksMylibraryBookshelvesMoveVolume_580274(
    name: "booksMylibraryBookshelvesMoveVolume", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/mylibrary/bookshelves/{shelf}/moveVolume",
    validator: validate_BooksMylibraryBookshelvesMoveVolume_580275,
    base: "/books/v1", url: url_BooksMylibraryBookshelvesMoveVolume_580276,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesRemoveVolume_580292 = ref object of OpenApiRestCall_579389
proc url_BooksMylibraryBookshelvesRemoveVolume_580294(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BooksMylibraryBookshelvesRemoveVolume_580293(path: JsonNode;
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
  var valid_580295 = path.getOrDefault("shelf")
  valid_580295 = validateParameter(valid_580295, JString, required = true,
                                 default = nil)
  if valid_580295 != nil:
    section.add "shelf", valid_580295
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   volumeId: JString (required)
  ##           : ID of volume to remove.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   reason: JString
  ##         : The reason for which the book is removed from the library.
  section = newJObject()
  var valid_580296 = query.getOrDefault("key")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = nil)
  if valid_580296 != nil:
    section.add "key", valid_580296
  var valid_580297 = query.getOrDefault("prettyPrint")
  valid_580297 = validateParameter(valid_580297, JBool, required = false,
                                 default = newJBool(true))
  if valid_580297 != nil:
    section.add "prettyPrint", valid_580297
  var valid_580298 = query.getOrDefault("oauth_token")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "oauth_token", valid_580298
  assert query != nil,
        "query argument is necessary due to required `volumeId` field"
  var valid_580299 = query.getOrDefault("volumeId")
  valid_580299 = validateParameter(valid_580299, JString, required = true,
                                 default = nil)
  if valid_580299 != nil:
    section.add "volumeId", valid_580299
  var valid_580300 = query.getOrDefault("source")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "source", valid_580300
  var valid_580301 = query.getOrDefault("alt")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = newJString("json"))
  if valid_580301 != nil:
    section.add "alt", valid_580301
  var valid_580302 = query.getOrDefault("userIp")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "userIp", valid_580302
  var valid_580303 = query.getOrDefault("quotaUser")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "quotaUser", valid_580303
  var valid_580304 = query.getOrDefault("fields")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "fields", valid_580304
  var valid_580305 = query.getOrDefault("reason")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = newJString("ONBOARDING"))
  if valid_580305 != nil:
    section.add "reason", valid_580305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580306: Call_BooksMylibraryBookshelvesRemoveVolume_580292;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a volume from a bookshelf.
  ## 
  let valid = call_580306.validator(path, query, header, formData, body)
  let scheme = call_580306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580306.url(scheme.get, call_580306.host, call_580306.base,
                         call_580306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580306, url, valid)

proc call*(call_580307: Call_BooksMylibraryBookshelvesRemoveVolume_580292;
          volumeId: string; shelf: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; source: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = "";
          reason: string = "ONBOARDING"): Recallable =
  ## booksMylibraryBookshelvesRemoveVolume
  ## Removes a volume from a bookshelf.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   volumeId: string (required)
  ##           : ID of volume to remove.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   shelf: string (required)
  ##        : ID of bookshelf from which to remove a volume.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   reason: string
  ##         : The reason for which the book is removed from the library.
  var path_580308 = newJObject()
  var query_580309 = newJObject()
  add(query_580309, "key", newJString(key))
  add(query_580309, "prettyPrint", newJBool(prettyPrint))
  add(query_580309, "oauth_token", newJString(oauthToken))
  add(query_580309, "volumeId", newJString(volumeId))
  add(query_580309, "source", newJString(source))
  add(query_580309, "alt", newJString(alt))
  add(query_580309, "userIp", newJString(userIp))
  add(query_580309, "quotaUser", newJString(quotaUser))
  add(path_580308, "shelf", newJString(shelf))
  add(query_580309, "fields", newJString(fields))
  add(query_580309, "reason", newJString(reason))
  result = call_580307.call(path_580308, query_580309, nil, nil, nil)

var booksMylibraryBookshelvesRemoveVolume* = Call_BooksMylibraryBookshelvesRemoveVolume_580292(
    name: "booksMylibraryBookshelvesRemoveVolume", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/mylibrary/bookshelves/{shelf}/removeVolume",
    validator: validate_BooksMylibraryBookshelvesRemoveVolume_580293,
    base: "/books/v1", url: url_BooksMylibraryBookshelvesRemoveVolume_580294,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesVolumesList_580310 = ref object of OpenApiRestCall_579389
proc url_BooksMylibraryBookshelvesVolumesList_580312(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BooksMylibraryBookshelvesVolumesList_580311(path: JsonNode;
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
  var valid_580313 = path.getOrDefault("shelf")
  valid_580313 = validateParameter(valid_580313, JString, required = true,
                                 default = nil)
  if valid_580313 != nil:
    section.add "shelf", valid_580313
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   q: JString
  ##    : Full-text search query string in this bookshelf.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   showPreorders: JBool
  ##                : Set to true to show pre-ordered books. Defaults to false.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: JInt
  ##             : Index of the first element to return (starts at 0)
  ##   country: JString
  ##          : ISO-3166-1 code to override the IP-based location.
  ##   projection: JString
  ##             : Restrict information returned to a set of selected fields.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of results to return
  section = newJObject()
  var valid_580314 = query.getOrDefault("key")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = nil)
  if valid_580314 != nil:
    section.add "key", valid_580314
  var valid_580315 = query.getOrDefault("prettyPrint")
  valid_580315 = validateParameter(valid_580315, JBool, required = false,
                                 default = newJBool(true))
  if valid_580315 != nil:
    section.add "prettyPrint", valid_580315
  var valid_580316 = query.getOrDefault("oauth_token")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "oauth_token", valid_580316
  var valid_580317 = query.getOrDefault("q")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "q", valid_580317
  var valid_580318 = query.getOrDefault("source")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "source", valid_580318
  var valid_580319 = query.getOrDefault("showPreorders")
  valid_580319 = validateParameter(valid_580319, JBool, required = false, default = nil)
  if valid_580319 != nil:
    section.add "showPreorders", valid_580319
  var valid_580320 = query.getOrDefault("alt")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = newJString("json"))
  if valid_580320 != nil:
    section.add "alt", valid_580320
  var valid_580321 = query.getOrDefault("userIp")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "userIp", valid_580321
  var valid_580322 = query.getOrDefault("quotaUser")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = nil)
  if valid_580322 != nil:
    section.add "quotaUser", valid_580322
  var valid_580323 = query.getOrDefault("startIndex")
  valid_580323 = validateParameter(valid_580323, JInt, required = false, default = nil)
  if valid_580323 != nil:
    section.add "startIndex", valid_580323
  var valid_580324 = query.getOrDefault("country")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "country", valid_580324
  var valid_580325 = query.getOrDefault("projection")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = newJString("full"))
  if valid_580325 != nil:
    section.add "projection", valid_580325
  var valid_580326 = query.getOrDefault("fields")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = nil)
  if valid_580326 != nil:
    section.add "fields", valid_580326
  var valid_580327 = query.getOrDefault("maxResults")
  valid_580327 = validateParameter(valid_580327, JInt, required = false, default = nil)
  if valid_580327 != nil:
    section.add "maxResults", valid_580327
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580328: Call_BooksMylibraryBookshelvesVolumesList_580310;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets volume information for volumes on a bookshelf.
  ## 
  let valid = call_580328.validator(path, query, header, formData, body)
  let scheme = call_580328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580328.url(scheme.get, call_580328.host, call_580328.base,
                         call_580328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580328, url, valid)

proc call*(call_580329: Call_BooksMylibraryBookshelvesVolumesList_580310;
          shelf: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; q: string = ""; source: string = "";
          showPreorders: bool = false; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; startIndex: int = 0; country: string = "";
          projection: string = "full"; fields: string = ""; maxResults: int = 0): Recallable =
  ## booksMylibraryBookshelvesVolumesList
  ## Gets volume information for volumes on a bookshelf.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   q: string
  ##    : Full-text search query string in this bookshelf.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   showPreorders: bool
  ##                : Set to true to show pre-ordered books. Defaults to false.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##             : Index of the first element to return (starts at 0)
  ##   country: string
  ##          : ISO-3166-1 code to override the IP-based location.
  ##   shelf: string (required)
  ##        : The bookshelf ID or name retrieve volumes for.
  ##   projection: string
  ##             : Restrict information returned to a set of selected fields.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of results to return
  var path_580330 = newJObject()
  var query_580331 = newJObject()
  add(query_580331, "key", newJString(key))
  add(query_580331, "prettyPrint", newJBool(prettyPrint))
  add(query_580331, "oauth_token", newJString(oauthToken))
  add(query_580331, "q", newJString(q))
  add(query_580331, "source", newJString(source))
  add(query_580331, "showPreorders", newJBool(showPreorders))
  add(query_580331, "alt", newJString(alt))
  add(query_580331, "userIp", newJString(userIp))
  add(query_580331, "quotaUser", newJString(quotaUser))
  add(query_580331, "startIndex", newJInt(startIndex))
  add(query_580331, "country", newJString(country))
  add(path_580330, "shelf", newJString(shelf))
  add(query_580331, "projection", newJString(projection))
  add(query_580331, "fields", newJString(fields))
  add(query_580331, "maxResults", newJInt(maxResults))
  result = call_580329.call(path_580330, query_580331, nil, nil, nil)

var booksMylibraryBookshelvesVolumesList* = Call_BooksMylibraryBookshelvesVolumesList_580310(
    name: "booksMylibraryBookshelvesVolumesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/mylibrary/bookshelves/{shelf}/volumes",
    validator: validate_BooksMylibraryBookshelvesVolumesList_580311,
    base: "/books/v1", url: url_BooksMylibraryBookshelvesVolumesList_580312,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryReadingpositionsGet_580332 = ref object of OpenApiRestCall_579389
proc url_BooksMylibraryReadingpositionsGet_580334(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BooksMylibraryReadingpositionsGet_580333(path: JsonNode;
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
  var valid_580335 = path.getOrDefault("volumeId")
  valid_580335 = validateParameter(valid_580335, JString, required = true,
                                 default = nil)
  if valid_580335 != nil:
    section.add "volumeId", valid_580335
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   contentVersion: JString
  ##                 : Volume content version for which this reading position is requested.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580336 = query.getOrDefault("key")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "key", valid_580336
  var valid_580337 = query.getOrDefault("prettyPrint")
  valid_580337 = validateParameter(valid_580337, JBool, required = false,
                                 default = newJBool(true))
  if valid_580337 != nil:
    section.add "prettyPrint", valid_580337
  var valid_580338 = query.getOrDefault("oauth_token")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "oauth_token", valid_580338
  var valid_580339 = query.getOrDefault("source")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "source", valid_580339
  var valid_580340 = query.getOrDefault("alt")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = newJString("json"))
  if valid_580340 != nil:
    section.add "alt", valid_580340
  var valid_580341 = query.getOrDefault("userIp")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "userIp", valid_580341
  var valid_580342 = query.getOrDefault("contentVersion")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "contentVersion", valid_580342
  var valid_580343 = query.getOrDefault("quotaUser")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "quotaUser", valid_580343
  var valid_580344 = query.getOrDefault("fields")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "fields", valid_580344
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580345: Call_BooksMylibraryReadingpositionsGet_580332;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves my reading position information for a volume.
  ## 
  let valid = call_580345.validator(path, query, header, formData, body)
  let scheme = call_580345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580345.url(scheme.get, call_580345.host, call_580345.base,
                         call_580345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580345, url, valid)

proc call*(call_580346: Call_BooksMylibraryReadingpositionsGet_580332;
          volumeId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; source: string = ""; alt: string = "json";
          userIp: string = ""; contentVersion: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## booksMylibraryReadingpositionsGet
  ## Retrieves my reading position information for a volume.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   contentVersion: string
  ##                 : Volume content version for which this reading position is requested.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   volumeId: string (required)
  ##           : ID of volume for which to retrieve a reading position.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580347 = newJObject()
  var query_580348 = newJObject()
  add(query_580348, "key", newJString(key))
  add(query_580348, "prettyPrint", newJBool(prettyPrint))
  add(query_580348, "oauth_token", newJString(oauthToken))
  add(query_580348, "source", newJString(source))
  add(query_580348, "alt", newJString(alt))
  add(query_580348, "userIp", newJString(userIp))
  add(query_580348, "contentVersion", newJString(contentVersion))
  add(query_580348, "quotaUser", newJString(quotaUser))
  add(path_580347, "volumeId", newJString(volumeId))
  add(query_580348, "fields", newJString(fields))
  result = call_580346.call(path_580347, query_580348, nil, nil, nil)

var booksMylibraryReadingpositionsGet* = Call_BooksMylibraryReadingpositionsGet_580332(
    name: "booksMylibraryReadingpositionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/mylibrary/readingpositions/{volumeId}",
    validator: validate_BooksMylibraryReadingpositionsGet_580333,
    base: "/books/v1", url: url_BooksMylibraryReadingpositionsGet_580334,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryReadingpositionsSetPosition_580349 = ref object of OpenApiRestCall_579389
proc url_BooksMylibraryReadingpositionsSetPosition_580351(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BooksMylibraryReadingpositionsSetPosition_580350(path: JsonNode;
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
  var valid_580352 = path.getOrDefault("volumeId")
  valid_580352 = validateParameter(valid_580352, JString, required = true,
                                 default = nil)
  if valid_580352 != nil:
    section.add "volumeId", valid_580352
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   action: JString
  ##         : Action that caused this reading position to be set.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   contentVersion: JString
  ##                 : Volume content version for which this reading position applies.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   position: JString (required)
  ##           : Position string for the new volume reading position.
  ##   timestamp: JString (required)
  ##            : RFC 3339 UTC format timestamp associated with this reading position.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   deviceCookie: JString
  ##               : Random persistent device cookie optional on set position.
  section = newJObject()
  var valid_580353 = query.getOrDefault("key")
  valid_580353 = validateParameter(valid_580353, JString, required = false,
                                 default = nil)
  if valid_580353 != nil:
    section.add "key", valid_580353
  var valid_580354 = query.getOrDefault("prettyPrint")
  valid_580354 = validateParameter(valid_580354, JBool, required = false,
                                 default = newJBool(true))
  if valid_580354 != nil:
    section.add "prettyPrint", valid_580354
  var valid_580355 = query.getOrDefault("oauth_token")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "oauth_token", valid_580355
  var valid_580356 = query.getOrDefault("action")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = newJString("bookmark"))
  if valid_580356 != nil:
    section.add "action", valid_580356
  var valid_580357 = query.getOrDefault("source")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = nil)
  if valid_580357 != nil:
    section.add "source", valid_580357
  var valid_580358 = query.getOrDefault("alt")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = newJString("json"))
  if valid_580358 != nil:
    section.add "alt", valid_580358
  var valid_580359 = query.getOrDefault("userIp")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = nil)
  if valid_580359 != nil:
    section.add "userIp", valid_580359
  var valid_580360 = query.getOrDefault("contentVersion")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "contentVersion", valid_580360
  var valid_580361 = query.getOrDefault("quotaUser")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "quotaUser", valid_580361
  assert query != nil,
        "query argument is necessary due to required `position` field"
  var valid_580362 = query.getOrDefault("position")
  valid_580362 = validateParameter(valid_580362, JString, required = true,
                                 default = nil)
  if valid_580362 != nil:
    section.add "position", valid_580362
  var valid_580363 = query.getOrDefault("timestamp")
  valid_580363 = validateParameter(valid_580363, JString, required = true,
                                 default = nil)
  if valid_580363 != nil:
    section.add "timestamp", valid_580363
  var valid_580364 = query.getOrDefault("fields")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "fields", valid_580364
  var valid_580365 = query.getOrDefault("deviceCookie")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "deviceCookie", valid_580365
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580366: Call_BooksMylibraryReadingpositionsSetPosition_580349;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets my reading position information for a volume.
  ## 
  let valid = call_580366.validator(path, query, header, formData, body)
  let scheme = call_580366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580366.url(scheme.get, call_580366.host, call_580366.base,
                         call_580366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580366, url, valid)

proc call*(call_580367: Call_BooksMylibraryReadingpositionsSetPosition_580349;
          position: string; volumeId: string; timestamp: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          action: string = "bookmark"; source: string = ""; alt: string = "json";
          userIp: string = ""; contentVersion: string = ""; quotaUser: string = "";
          fields: string = ""; deviceCookie: string = ""): Recallable =
  ## booksMylibraryReadingpositionsSetPosition
  ## Sets my reading position information for a volume.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   action: string
  ##         : Action that caused this reading position to be set.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   contentVersion: string
  ##                 : Volume content version for which this reading position applies.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   position: string (required)
  ##           : Position string for the new volume reading position.
  ##   volumeId: string (required)
  ##           : ID of volume for which to update the reading position.
  ##   timestamp: string (required)
  ##            : RFC 3339 UTC format timestamp associated with this reading position.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   deviceCookie: string
  ##               : Random persistent device cookie optional on set position.
  var path_580368 = newJObject()
  var query_580369 = newJObject()
  add(query_580369, "key", newJString(key))
  add(query_580369, "prettyPrint", newJBool(prettyPrint))
  add(query_580369, "oauth_token", newJString(oauthToken))
  add(query_580369, "action", newJString(action))
  add(query_580369, "source", newJString(source))
  add(query_580369, "alt", newJString(alt))
  add(query_580369, "userIp", newJString(userIp))
  add(query_580369, "contentVersion", newJString(contentVersion))
  add(query_580369, "quotaUser", newJString(quotaUser))
  add(query_580369, "position", newJString(position))
  add(path_580368, "volumeId", newJString(volumeId))
  add(query_580369, "timestamp", newJString(timestamp))
  add(query_580369, "fields", newJString(fields))
  add(query_580369, "deviceCookie", newJString(deviceCookie))
  result = call_580367.call(path_580368, query_580369, nil, nil, nil)

var booksMylibraryReadingpositionsSetPosition* = Call_BooksMylibraryReadingpositionsSetPosition_580349(
    name: "booksMylibraryReadingpositionsSetPosition", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/mylibrary/readingpositions/{volumeId}/setPosition",
    validator: validate_BooksMylibraryReadingpositionsSetPosition_580350,
    base: "/books/v1", url: url_BooksMylibraryReadingpositionsSetPosition_580351,
    schemes: {Scheme.Https})
type
  Call_BooksNotificationGet_580370 = ref object of OpenApiRestCall_579389
proc url_BooksNotificationGet_580372(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BooksNotificationGet_580371(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns notification details for a given notification id.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   locale: JString
  ##         : ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'. Used for generating notification title and body.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   notification_id: JString (required)
  ##                  : String to identify the notification.
  section = newJObject()
  var valid_580373 = query.getOrDefault("key")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = nil)
  if valid_580373 != nil:
    section.add "key", valid_580373
  var valid_580374 = query.getOrDefault("prettyPrint")
  valid_580374 = validateParameter(valid_580374, JBool, required = false,
                                 default = newJBool(true))
  if valid_580374 != nil:
    section.add "prettyPrint", valid_580374
  var valid_580375 = query.getOrDefault("oauth_token")
  valid_580375 = validateParameter(valid_580375, JString, required = false,
                                 default = nil)
  if valid_580375 != nil:
    section.add "oauth_token", valid_580375
  var valid_580376 = query.getOrDefault("locale")
  valid_580376 = validateParameter(valid_580376, JString, required = false,
                                 default = nil)
  if valid_580376 != nil:
    section.add "locale", valid_580376
  var valid_580377 = query.getOrDefault("source")
  valid_580377 = validateParameter(valid_580377, JString, required = false,
                                 default = nil)
  if valid_580377 != nil:
    section.add "source", valid_580377
  var valid_580378 = query.getOrDefault("alt")
  valid_580378 = validateParameter(valid_580378, JString, required = false,
                                 default = newJString("json"))
  if valid_580378 != nil:
    section.add "alt", valid_580378
  var valid_580379 = query.getOrDefault("userIp")
  valid_580379 = validateParameter(valid_580379, JString, required = false,
                                 default = nil)
  if valid_580379 != nil:
    section.add "userIp", valid_580379
  var valid_580380 = query.getOrDefault("quotaUser")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = nil)
  if valid_580380 != nil:
    section.add "quotaUser", valid_580380
  var valid_580381 = query.getOrDefault("fields")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "fields", valid_580381
  assert query != nil,
        "query argument is necessary due to required `notification_id` field"
  var valid_580382 = query.getOrDefault("notification_id")
  valid_580382 = validateParameter(valid_580382, JString, required = true,
                                 default = nil)
  if valid_580382 != nil:
    section.add "notification_id", valid_580382
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580383: Call_BooksNotificationGet_580370; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns notification details for a given notification id.
  ## 
  let valid = call_580383.validator(path, query, header, formData, body)
  let scheme = call_580383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580383.url(scheme.get, call_580383.host, call_580383.base,
                         call_580383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580383, url, valid)

proc call*(call_580384: Call_BooksNotificationGet_580370; notificationId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          locale: string = ""; source: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## booksNotificationGet
  ## Returns notification details for a given notification id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   locale: string
  ##         : ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'. Used for generating notification title and body.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   notificationId: string (required)
  ##                 : String to identify the notification.
  var query_580385 = newJObject()
  add(query_580385, "key", newJString(key))
  add(query_580385, "prettyPrint", newJBool(prettyPrint))
  add(query_580385, "oauth_token", newJString(oauthToken))
  add(query_580385, "locale", newJString(locale))
  add(query_580385, "source", newJString(source))
  add(query_580385, "alt", newJString(alt))
  add(query_580385, "userIp", newJString(userIp))
  add(query_580385, "quotaUser", newJString(quotaUser))
  add(query_580385, "fields", newJString(fields))
  add(query_580385, "notification_id", newJString(notificationId))
  result = call_580384.call(nil, query_580385, nil, nil, nil)

var booksNotificationGet* = Call_BooksNotificationGet_580370(
    name: "booksNotificationGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/notification/get",
    validator: validate_BooksNotificationGet_580371, base: "/books/v1",
    url: url_BooksNotificationGet_580372, schemes: {Scheme.Https})
type
  Call_BooksOnboardingListCategories_580386 = ref object of OpenApiRestCall_579389
proc url_BooksOnboardingListCategories_580388(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BooksOnboardingListCategories_580387(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List categories for onboarding experience.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   locale: JString
  ##         : ISO-639-1 language and ISO-3166-1 country code. Default is en-US if unset.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580389 = query.getOrDefault("key")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "key", valid_580389
  var valid_580390 = query.getOrDefault("prettyPrint")
  valid_580390 = validateParameter(valid_580390, JBool, required = false,
                                 default = newJBool(true))
  if valid_580390 != nil:
    section.add "prettyPrint", valid_580390
  var valid_580391 = query.getOrDefault("oauth_token")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = nil)
  if valid_580391 != nil:
    section.add "oauth_token", valid_580391
  var valid_580392 = query.getOrDefault("locale")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = nil)
  if valid_580392 != nil:
    section.add "locale", valid_580392
  var valid_580393 = query.getOrDefault("alt")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = newJString("json"))
  if valid_580393 != nil:
    section.add "alt", valid_580393
  var valid_580394 = query.getOrDefault("userIp")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = nil)
  if valid_580394 != nil:
    section.add "userIp", valid_580394
  var valid_580395 = query.getOrDefault("quotaUser")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = nil)
  if valid_580395 != nil:
    section.add "quotaUser", valid_580395
  var valid_580396 = query.getOrDefault("fields")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = nil)
  if valid_580396 != nil:
    section.add "fields", valid_580396
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580397: Call_BooksOnboardingListCategories_580386; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List categories for onboarding experience.
  ## 
  let valid = call_580397.validator(path, query, header, formData, body)
  let scheme = call_580397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580397.url(scheme.get, call_580397.host, call_580397.base,
                         call_580397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580397, url, valid)

proc call*(call_580398: Call_BooksOnboardingListCategories_580386;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          locale: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## booksOnboardingListCategories
  ## List categories for onboarding experience.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   locale: string
  ##         : ISO-639-1 language and ISO-3166-1 country code. Default is en-US if unset.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580399 = newJObject()
  add(query_580399, "key", newJString(key))
  add(query_580399, "prettyPrint", newJBool(prettyPrint))
  add(query_580399, "oauth_token", newJString(oauthToken))
  add(query_580399, "locale", newJString(locale))
  add(query_580399, "alt", newJString(alt))
  add(query_580399, "userIp", newJString(userIp))
  add(query_580399, "quotaUser", newJString(quotaUser))
  add(query_580399, "fields", newJString(fields))
  result = call_580398.call(nil, query_580399, nil, nil, nil)

var booksOnboardingListCategories* = Call_BooksOnboardingListCategories_580386(
    name: "booksOnboardingListCategories", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/onboarding/listCategories",
    validator: validate_BooksOnboardingListCategories_580387, base: "/books/v1",
    url: url_BooksOnboardingListCategories_580388, schemes: {Scheme.Https})
type
  Call_BooksOnboardingListCategoryVolumes_580400 = ref object of OpenApiRestCall_579389
proc url_BooksOnboardingListCategoryVolumes_580402(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BooksOnboardingListCategoryVolumes_580401(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List available volumes under categories for onboarding experience.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   locale: JString
  ##         : ISO-639-1 language and ISO-3166-1 country code. Default is en-US if unset.
  ##   pageSize: JInt
  ##           : Number of maximum results per page to be included in the response.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   categoryId: JArray
  ##             : List of category ids requested.
  ##   pageToken: JString
  ##            : The value of the nextToken from the previous page.
  ##   maxAllowedMaturityRating: JString
  ##                           : The maximum allowed maturity rating of returned volumes. Books with a higher maturity rating are filtered out.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580403 = query.getOrDefault("key")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = nil)
  if valid_580403 != nil:
    section.add "key", valid_580403
  var valid_580404 = query.getOrDefault("prettyPrint")
  valid_580404 = validateParameter(valid_580404, JBool, required = false,
                                 default = newJBool(true))
  if valid_580404 != nil:
    section.add "prettyPrint", valid_580404
  var valid_580405 = query.getOrDefault("oauth_token")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = nil)
  if valid_580405 != nil:
    section.add "oauth_token", valid_580405
  var valid_580406 = query.getOrDefault("locale")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = nil)
  if valid_580406 != nil:
    section.add "locale", valid_580406
  var valid_580407 = query.getOrDefault("pageSize")
  valid_580407 = validateParameter(valid_580407, JInt, required = false, default = nil)
  if valid_580407 != nil:
    section.add "pageSize", valid_580407
  var valid_580408 = query.getOrDefault("alt")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = newJString("json"))
  if valid_580408 != nil:
    section.add "alt", valid_580408
  var valid_580409 = query.getOrDefault("userIp")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = nil)
  if valid_580409 != nil:
    section.add "userIp", valid_580409
  var valid_580410 = query.getOrDefault("quotaUser")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = nil)
  if valid_580410 != nil:
    section.add "quotaUser", valid_580410
  var valid_580411 = query.getOrDefault("categoryId")
  valid_580411 = validateParameter(valid_580411, JArray, required = false,
                                 default = nil)
  if valid_580411 != nil:
    section.add "categoryId", valid_580411
  var valid_580412 = query.getOrDefault("pageToken")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = nil)
  if valid_580412 != nil:
    section.add "pageToken", valid_580412
  var valid_580413 = query.getOrDefault("maxAllowedMaturityRating")
  valid_580413 = validateParameter(valid_580413, JString, required = false,
                                 default = newJString("mature"))
  if valid_580413 != nil:
    section.add "maxAllowedMaturityRating", valid_580413
  var valid_580414 = query.getOrDefault("fields")
  valid_580414 = validateParameter(valid_580414, JString, required = false,
                                 default = nil)
  if valid_580414 != nil:
    section.add "fields", valid_580414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580415: Call_BooksOnboardingListCategoryVolumes_580400;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List available volumes under categories for onboarding experience.
  ## 
  let valid = call_580415.validator(path, query, header, formData, body)
  let scheme = call_580415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580415.url(scheme.get, call_580415.host, call_580415.base,
                         call_580415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580415, url, valid)

proc call*(call_580416: Call_BooksOnboardingListCategoryVolumes_580400;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          locale: string = ""; pageSize: int = 0; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; categoryId: JsonNode = nil; pageToken: string = "";
          maxAllowedMaturityRating: string = "mature"; fields: string = ""): Recallable =
  ## booksOnboardingListCategoryVolumes
  ## List available volumes under categories for onboarding experience.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   locale: string
  ##         : ISO-639-1 language and ISO-3166-1 country code. Default is en-US if unset.
  ##   pageSize: int
  ##           : Number of maximum results per page to be included in the response.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   categoryId: JArray
  ##             : List of category ids requested.
  ##   pageToken: string
  ##            : The value of the nextToken from the previous page.
  ##   maxAllowedMaturityRating: string
  ##                           : The maximum allowed maturity rating of returned volumes. Books with a higher maturity rating are filtered out.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580417 = newJObject()
  add(query_580417, "key", newJString(key))
  add(query_580417, "prettyPrint", newJBool(prettyPrint))
  add(query_580417, "oauth_token", newJString(oauthToken))
  add(query_580417, "locale", newJString(locale))
  add(query_580417, "pageSize", newJInt(pageSize))
  add(query_580417, "alt", newJString(alt))
  add(query_580417, "userIp", newJString(userIp))
  add(query_580417, "quotaUser", newJString(quotaUser))
  if categoryId != nil:
    query_580417.add "categoryId", categoryId
  add(query_580417, "pageToken", newJString(pageToken))
  add(query_580417, "maxAllowedMaturityRating",
      newJString(maxAllowedMaturityRating))
  add(query_580417, "fields", newJString(fields))
  result = call_580416.call(nil, query_580417, nil, nil, nil)

var booksOnboardingListCategoryVolumes* = Call_BooksOnboardingListCategoryVolumes_580400(
    name: "booksOnboardingListCategoryVolumes", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/onboarding/listCategoryVolumes",
    validator: validate_BooksOnboardingListCategoryVolumes_580401,
    base: "/books/v1", url: url_BooksOnboardingListCategoryVolumes_580402,
    schemes: {Scheme.Https})
type
  Call_BooksPersonalizedstreamGet_580418 = ref object of OpenApiRestCall_579389
proc url_BooksPersonalizedstreamGet_580420(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BooksPersonalizedstreamGet_580419(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a stream of personalized book clusters
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   locale: JString
  ##         : ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'. Used for generating recommendations.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   maxAllowedMaturityRating: JString
  ##                           : The maximum allowed maturity rating of returned recommendations. Books with a higher maturity rating are filtered out.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580421 = query.getOrDefault("key")
  valid_580421 = validateParameter(valid_580421, JString, required = false,
                                 default = nil)
  if valid_580421 != nil:
    section.add "key", valid_580421
  var valid_580422 = query.getOrDefault("prettyPrint")
  valid_580422 = validateParameter(valid_580422, JBool, required = false,
                                 default = newJBool(true))
  if valid_580422 != nil:
    section.add "prettyPrint", valid_580422
  var valid_580423 = query.getOrDefault("oauth_token")
  valid_580423 = validateParameter(valid_580423, JString, required = false,
                                 default = nil)
  if valid_580423 != nil:
    section.add "oauth_token", valid_580423
  var valid_580424 = query.getOrDefault("locale")
  valid_580424 = validateParameter(valid_580424, JString, required = false,
                                 default = nil)
  if valid_580424 != nil:
    section.add "locale", valid_580424
  var valid_580425 = query.getOrDefault("source")
  valid_580425 = validateParameter(valid_580425, JString, required = false,
                                 default = nil)
  if valid_580425 != nil:
    section.add "source", valid_580425
  var valid_580426 = query.getOrDefault("alt")
  valid_580426 = validateParameter(valid_580426, JString, required = false,
                                 default = newJString("json"))
  if valid_580426 != nil:
    section.add "alt", valid_580426
  var valid_580427 = query.getOrDefault("userIp")
  valid_580427 = validateParameter(valid_580427, JString, required = false,
                                 default = nil)
  if valid_580427 != nil:
    section.add "userIp", valid_580427
  var valid_580428 = query.getOrDefault("quotaUser")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = nil)
  if valid_580428 != nil:
    section.add "quotaUser", valid_580428
  var valid_580429 = query.getOrDefault("maxAllowedMaturityRating")
  valid_580429 = validateParameter(valid_580429, JString, required = false,
                                 default = newJString("mature"))
  if valid_580429 != nil:
    section.add "maxAllowedMaturityRating", valid_580429
  var valid_580430 = query.getOrDefault("fields")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = nil)
  if valid_580430 != nil:
    section.add "fields", valid_580430
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580431: Call_BooksPersonalizedstreamGet_580418; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a stream of personalized book clusters
  ## 
  let valid = call_580431.validator(path, query, header, formData, body)
  let scheme = call_580431.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580431.url(scheme.get, call_580431.host, call_580431.base,
                         call_580431.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580431, url, valid)

proc call*(call_580432: Call_BooksPersonalizedstreamGet_580418; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; locale: string = "";
          source: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; maxAllowedMaturityRating: string = "mature";
          fields: string = ""): Recallable =
  ## booksPersonalizedstreamGet
  ## Returns a stream of personalized book clusters
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   locale: string
  ##         : ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'. Used for generating recommendations.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   maxAllowedMaturityRating: string
  ##                           : The maximum allowed maturity rating of returned recommendations. Books with a higher maturity rating are filtered out.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580433 = newJObject()
  add(query_580433, "key", newJString(key))
  add(query_580433, "prettyPrint", newJBool(prettyPrint))
  add(query_580433, "oauth_token", newJString(oauthToken))
  add(query_580433, "locale", newJString(locale))
  add(query_580433, "source", newJString(source))
  add(query_580433, "alt", newJString(alt))
  add(query_580433, "userIp", newJString(userIp))
  add(query_580433, "quotaUser", newJString(quotaUser))
  add(query_580433, "maxAllowedMaturityRating",
      newJString(maxAllowedMaturityRating))
  add(query_580433, "fields", newJString(fields))
  result = call_580432.call(nil, query_580433, nil, nil, nil)

var booksPersonalizedstreamGet* = Call_BooksPersonalizedstreamGet_580418(
    name: "booksPersonalizedstreamGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/personalizedstream/get",
    validator: validate_BooksPersonalizedstreamGet_580419, base: "/books/v1",
    url: url_BooksPersonalizedstreamGet_580420, schemes: {Scheme.Https})
type
  Call_BooksPromoofferAccept_580434 = ref object of OpenApiRestCall_579389
proc url_BooksPromoofferAccept_580436(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BooksPromoofferAccept_580435(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   model: JString
  ##        : device model
  ##   serial: JString
  ##         : device serial
  ##   volumeId: JString
  ##           : Volume id to exercise the offer
  ##   manufacturer: JString
  ##               : device manufacturer
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   offerId: JString
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   device: JString
  ##         : device device
  ##   product: JString
  ##          : device product
  ##   androidId: JString
  ##            : device android_id
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580437 = query.getOrDefault("key")
  valid_580437 = validateParameter(valid_580437, JString, required = false,
                                 default = nil)
  if valid_580437 != nil:
    section.add "key", valid_580437
  var valid_580438 = query.getOrDefault("prettyPrint")
  valid_580438 = validateParameter(valid_580438, JBool, required = false,
                                 default = newJBool(true))
  if valid_580438 != nil:
    section.add "prettyPrint", valid_580438
  var valid_580439 = query.getOrDefault("oauth_token")
  valid_580439 = validateParameter(valid_580439, JString, required = false,
                                 default = nil)
  if valid_580439 != nil:
    section.add "oauth_token", valid_580439
  var valid_580440 = query.getOrDefault("model")
  valid_580440 = validateParameter(valid_580440, JString, required = false,
                                 default = nil)
  if valid_580440 != nil:
    section.add "model", valid_580440
  var valid_580441 = query.getOrDefault("serial")
  valid_580441 = validateParameter(valid_580441, JString, required = false,
                                 default = nil)
  if valid_580441 != nil:
    section.add "serial", valid_580441
  var valid_580442 = query.getOrDefault("volumeId")
  valid_580442 = validateParameter(valid_580442, JString, required = false,
                                 default = nil)
  if valid_580442 != nil:
    section.add "volumeId", valid_580442
  var valid_580443 = query.getOrDefault("manufacturer")
  valid_580443 = validateParameter(valid_580443, JString, required = false,
                                 default = nil)
  if valid_580443 != nil:
    section.add "manufacturer", valid_580443
  var valid_580444 = query.getOrDefault("alt")
  valid_580444 = validateParameter(valid_580444, JString, required = false,
                                 default = newJString("json"))
  if valid_580444 != nil:
    section.add "alt", valid_580444
  var valid_580445 = query.getOrDefault("userIp")
  valid_580445 = validateParameter(valid_580445, JString, required = false,
                                 default = nil)
  if valid_580445 != nil:
    section.add "userIp", valid_580445
  var valid_580446 = query.getOrDefault("offerId")
  valid_580446 = validateParameter(valid_580446, JString, required = false,
                                 default = nil)
  if valid_580446 != nil:
    section.add "offerId", valid_580446
  var valid_580447 = query.getOrDefault("quotaUser")
  valid_580447 = validateParameter(valid_580447, JString, required = false,
                                 default = nil)
  if valid_580447 != nil:
    section.add "quotaUser", valid_580447
  var valid_580448 = query.getOrDefault("device")
  valid_580448 = validateParameter(valid_580448, JString, required = false,
                                 default = nil)
  if valid_580448 != nil:
    section.add "device", valid_580448
  var valid_580449 = query.getOrDefault("product")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = nil)
  if valid_580449 != nil:
    section.add "product", valid_580449
  var valid_580450 = query.getOrDefault("androidId")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = nil)
  if valid_580450 != nil:
    section.add "androidId", valid_580450
  var valid_580451 = query.getOrDefault("fields")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = nil)
  if valid_580451 != nil:
    section.add "fields", valid_580451
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580452: Call_BooksPromoofferAccept_580434; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_580452.validator(path, query, header, formData, body)
  let scheme = call_580452.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580452.url(scheme.get, call_580452.host, call_580452.base,
                         call_580452.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580452, url, valid)

proc call*(call_580453: Call_BooksPromoofferAccept_580434; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; model: string = "";
          serial: string = ""; volumeId: string = ""; manufacturer: string = "";
          alt: string = "json"; userIp: string = ""; offerId: string = "";
          quotaUser: string = ""; device: string = ""; product: string = "";
          androidId: string = ""; fields: string = ""): Recallable =
  ## booksPromoofferAccept
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   model: string
  ##        : device model
  ##   serial: string
  ##         : device serial
  ##   volumeId: string
  ##           : Volume id to exercise the offer
  ##   manufacturer: string
  ##               : device manufacturer
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   offerId: string
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   device: string
  ##         : device device
  ##   product: string
  ##          : device product
  ##   androidId: string
  ##            : device android_id
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580454 = newJObject()
  add(query_580454, "key", newJString(key))
  add(query_580454, "prettyPrint", newJBool(prettyPrint))
  add(query_580454, "oauth_token", newJString(oauthToken))
  add(query_580454, "model", newJString(model))
  add(query_580454, "serial", newJString(serial))
  add(query_580454, "volumeId", newJString(volumeId))
  add(query_580454, "manufacturer", newJString(manufacturer))
  add(query_580454, "alt", newJString(alt))
  add(query_580454, "userIp", newJString(userIp))
  add(query_580454, "offerId", newJString(offerId))
  add(query_580454, "quotaUser", newJString(quotaUser))
  add(query_580454, "device", newJString(device))
  add(query_580454, "product", newJString(product))
  add(query_580454, "androidId", newJString(androidId))
  add(query_580454, "fields", newJString(fields))
  result = call_580453.call(nil, query_580454, nil, nil, nil)

var booksPromoofferAccept* = Call_BooksPromoofferAccept_580434(
    name: "booksPromoofferAccept", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/promooffer/accept",
    validator: validate_BooksPromoofferAccept_580435, base: "/books/v1",
    url: url_BooksPromoofferAccept_580436, schemes: {Scheme.Https})
type
  Call_BooksPromoofferDismiss_580455 = ref object of OpenApiRestCall_579389
proc url_BooksPromoofferDismiss_580457(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BooksPromoofferDismiss_580456(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   model: JString
  ##        : device model
  ##   serial: JString
  ##         : device serial
  ##   manufacturer: JString
  ##               : device manufacturer
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   offerId: JString
  ##          : Offer to dimiss
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   device: JString
  ##         : device device
  ##   product: JString
  ##          : device product
  ##   androidId: JString
  ##            : device android_id
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580458 = query.getOrDefault("key")
  valid_580458 = validateParameter(valid_580458, JString, required = false,
                                 default = nil)
  if valid_580458 != nil:
    section.add "key", valid_580458
  var valid_580459 = query.getOrDefault("prettyPrint")
  valid_580459 = validateParameter(valid_580459, JBool, required = false,
                                 default = newJBool(true))
  if valid_580459 != nil:
    section.add "prettyPrint", valid_580459
  var valid_580460 = query.getOrDefault("oauth_token")
  valid_580460 = validateParameter(valid_580460, JString, required = false,
                                 default = nil)
  if valid_580460 != nil:
    section.add "oauth_token", valid_580460
  var valid_580461 = query.getOrDefault("model")
  valid_580461 = validateParameter(valid_580461, JString, required = false,
                                 default = nil)
  if valid_580461 != nil:
    section.add "model", valid_580461
  var valid_580462 = query.getOrDefault("serial")
  valid_580462 = validateParameter(valid_580462, JString, required = false,
                                 default = nil)
  if valid_580462 != nil:
    section.add "serial", valid_580462
  var valid_580463 = query.getOrDefault("manufacturer")
  valid_580463 = validateParameter(valid_580463, JString, required = false,
                                 default = nil)
  if valid_580463 != nil:
    section.add "manufacturer", valid_580463
  var valid_580464 = query.getOrDefault("alt")
  valid_580464 = validateParameter(valid_580464, JString, required = false,
                                 default = newJString("json"))
  if valid_580464 != nil:
    section.add "alt", valid_580464
  var valid_580465 = query.getOrDefault("userIp")
  valid_580465 = validateParameter(valid_580465, JString, required = false,
                                 default = nil)
  if valid_580465 != nil:
    section.add "userIp", valid_580465
  var valid_580466 = query.getOrDefault("offerId")
  valid_580466 = validateParameter(valid_580466, JString, required = false,
                                 default = nil)
  if valid_580466 != nil:
    section.add "offerId", valid_580466
  var valid_580467 = query.getOrDefault("quotaUser")
  valid_580467 = validateParameter(valid_580467, JString, required = false,
                                 default = nil)
  if valid_580467 != nil:
    section.add "quotaUser", valid_580467
  var valid_580468 = query.getOrDefault("device")
  valid_580468 = validateParameter(valid_580468, JString, required = false,
                                 default = nil)
  if valid_580468 != nil:
    section.add "device", valid_580468
  var valid_580469 = query.getOrDefault("product")
  valid_580469 = validateParameter(valid_580469, JString, required = false,
                                 default = nil)
  if valid_580469 != nil:
    section.add "product", valid_580469
  var valid_580470 = query.getOrDefault("androidId")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = nil)
  if valid_580470 != nil:
    section.add "androidId", valid_580470
  var valid_580471 = query.getOrDefault("fields")
  valid_580471 = validateParameter(valid_580471, JString, required = false,
                                 default = nil)
  if valid_580471 != nil:
    section.add "fields", valid_580471
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580472: Call_BooksPromoofferDismiss_580455; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_580472.validator(path, query, header, formData, body)
  let scheme = call_580472.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580472.url(scheme.get, call_580472.host, call_580472.base,
                         call_580472.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580472, url, valid)

proc call*(call_580473: Call_BooksPromoofferDismiss_580455; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; model: string = "";
          serial: string = ""; manufacturer: string = ""; alt: string = "json";
          userIp: string = ""; offerId: string = ""; quotaUser: string = "";
          device: string = ""; product: string = ""; androidId: string = "";
          fields: string = ""): Recallable =
  ## booksPromoofferDismiss
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   model: string
  ##        : device model
  ##   serial: string
  ##         : device serial
  ##   manufacturer: string
  ##               : device manufacturer
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   offerId: string
  ##          : Offer to dimiss
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   device: string
  ##         : device device
  ##   product: string
  ##          : device product
  ##   androidId: string
  ##            : device android_id
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580474 = newJObject()
  add(query_580474, "key", newJString(key))
  add(query_580474, "prettyPrint", newJBool(prettyPrint))
  add(query_580474, "oauth_token", newJString(oauthToken))
  add(query_580474, "model", newJString(model))
  add(query_580474, "serial", newJString(serial))
  add(query_580474, "manufacturer", newJString(manufacturer))
  add(query_580474, "alt", newJString(alt))
  add(query_580474, "userIp", newJString(userIp))
  add(query_580474, "offerId", newJString(offerId))
  add(query_580474, "quotaUser", newJString(quotaUser))
  add(query_580474, "device", newJString(device))
  add(query_580474, "product", newJString(product))
  add(query_580474, "androidId", newJString(androidId))
  add(query_580474, "fields", newJString(fields))
  result = call_580473.call(nil, query_580474, nil, nil, nil)

var booksPromoofferDismiss* = Call_BooksPromoofferDismiss_580455(
    name: "booksPromoofferDismiss", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/promooffer/dismiss",
    validator: validate_BooksPromoofferDismiss_580456, base: "/books/v1",
    url: url_BooksPromoofferDismiss_580457, schemes: {Scheme.Https})
type
  Call_BooksPromoofferGet_580475 = ref object of OpenApiRestCall_579389
proc url_BooksPromoofferGet_580477(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BooksPromoofferGet_580476(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Returns a list of promo offers available to the user
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   model: JString
  ##        : device model
  ##   serial: JString
  ##         : device serial
  ##   manufacturer: JString
  ##               : device manufacturer
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   device: JString
  ##         : device device
  ##   product: JString
  ##          : device product
  ##   androidId: JString
  ##            : device android_id
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580478 = query.getOrDefault("key")
  valid_580478 = validateParameter(valid_580478, JString, required = false,
                                 default = nil)
  if valid_580478 != nil:
    section.add "key", valid_580478
  var valid_580479 = query.getOrDefault("prettyPrint")
  valid_580479 = validateParameter(valid_580479, JBool, required = false,
                                 default = newJBool(true))
  if valid_580479 != nil:
    section.add "prettyPrint", valid_580479
  var valid_580480 = query.getOrDefault("oauth_token")
  valid_580480 = validateParameter(valid_580480, JString, required = false,
                                 default = nil)
  if valid_580480 != nil:
    section.add "oauth_token", valid_580480
  var valid_580481 = query.getOrDefault("model")
  valid_580481 = validateParameter(valid_580481, JString, required = false,
                                 default = nil)
  if valid_580481 != nil:
    section.add "model", valid_580481
  var valid_580482 = query.getOrDefault("serial")
  valid_580482 = validateParameter(valid_580482, JString, required = false,
                                 default = nil)
  if valid_580482 != nil:
    section.add "serial", valid_580482
  var valid_580483 = query.getOrDefault("manufacturer")
  valid_580483 = validateParameter(valid_580483, JString, required = false,
                                 default = nil)
  if valid_580483 != nil:
    section.add "manufacturer", valid_580483
  var valid_580484 = query.getOrDefault("alt")
  valid_580484 = validateParameter(valid_580484, JString, required = false,
                                 default = newJString("json"))
  if valid_580484 != nil:
    section.add "alt", valid_580484
  var valid_580485 = query.getOrDefault("userIp")
  valid_580485 = validateParameter(valid_580485, JString, required = false,
                                 default = nil)
  if valid_580485 != nil:
    section.add "userIp", valid_580485
  var valid_580486 = query.getOrDefault("quotaUser")
  valid_580486 = validateParameter(valid_580486, JString, required = false,
                                 default = nil)
  if valid_580486 != nil:
    section.add "quotaUser", valid_580486
  var valid_580487 = query.getOrDefault("device")
  valid_580487 = validateParameter(valid_580487, JString, required = false,
                                 default = nil)
  if valid_580487 != nil:
    section.add "device", valid_580487
  var valid_580488 = query.getOrDefault("product")
  valid_580488 = validateParameter(valid_580488, JString, required = false,
                                 default = nil)
  if valid_580488 != nil:
    section.add "product", valid_580488
  var valid_580489 = query.getOrDefault("androidId")
  valid_580489 = validateParameter(valid_580489, JString, required = false,
                                 default = nil)
  if valid_580489 != nil:
    section.add "androidId", valid_580489
  var valid_580490 = query.getOrDefault("fields")
  valid_580490 = validateParameter(valid_580490, JString, required = false,
                                 default = nil)
  if valid_580490 != nil:
    section.add "fields", valid_580490
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580491: Call_BooksPromoofferGet_580475; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of promo offers available to the user
  ## 
  let valid = call_580491.validator(path, query, header, formData, body)
  let scheme = call_580491.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580491.url(scheme.get, call_580491.host, call_580491.base,
                         call_580491.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580491, url, valid)

proc call*(call_580492: Call_BooksPromoofferGet_580475; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; model: string = "";
          serial: string = ""; manufacturer: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; device: string = "";
          product: string = ""; androidId: string = ""; fields: string = ""): Recallable =
  ## booksPromoofferGet
  ## Returns a list of promo offers available to the user
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   model: string
  ##        : device model
  ##   serial: string
  ##         : device serial
  ##   manufacturer: string
  ##               : device manufacturer
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   device: string
  ##         : device device
  ##   product: string
  ##          : device product
  ##   androidId: string
  ##            : device android_id
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580493 = newJObject()
  add(query_580493, "key", newJString(key))
  add(query_580493, "prettyPrint", newJBool(prettyPrint))
  add(query_580493, "oauth_token", newJString(oauthToken))
  add(query_580493, "model", newJString(model))
  add(query_580493, "serial", newJString(serial))
  add(query_580493, "manufacturer", newJString(manufacturer))
  add(query_580493, "alt", newJString(alt))
  add(query_580493, "userIp", newJString(userIp))
  add(query_580493, "quotaUser", newJString(quotaUser))
  add(query_580493, "device", newJString(device))
  add(query_580493, "product", newJString(product))
  add(query_580493, "androidId", newJString(androidId))
  add(query_580493, "fields", newJString(fields))
  result = call_580492.call(nil, query_580493, nil, nil, nil)

var booksPromoofferGet* = Call_BooksPromoofferGet_580475(
    name: "booksPromoofferGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/promooffer/get",
    validator: validate_BooksPromoofferGet_580476, base: "/books/v1",
    url: url_BooksPromoofferGet_580477, schemes: {Scheme.Https})
type
  Call_BooksSeriesGet_580494 = ref object of OpenApiRestCall_579389
proc url_BooksSeriesGet_580496(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BooksSeriesGet_580495(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Returns Series metadata for the given series ids.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   series_id: JArray (required)
  ##            : String that identifies the series
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580497 = query.getOrDefault("key")
  valid_580497 = validateParameter(valid_580497, JString, required = false,
                                 default = nil)
  if valid_580497 != nil:
    section.add "key", valid_580497
  var valid_580498 = query.getOrDefault("prettyPrint")
  valid_580498 = validateParameter(valid_580498, JBool, required = false,
                                 default = newJBool(true))
  if valid_580498 != nil:
    section.add "prettyPrint", valid_580498
  var valid_580499 = query.getOrDefault("oauth_token")
  valid_580499 = validateParameter(valid_580499, JString, required = false,
                                 default = nil)
  if valid_580499 != nil:
    section.add "oauth_token", valid_580499
  assert query != nil,
        "query argument is necessary due to required `series_id` field"
  var valid_580500 = query.getOrDefault("series_id")
  valid_580500 = validateParameter(valid_580500, JArray, required = true, default = nil)
  if valid_580500 != nil:
    section.add "series_id", valid_580500
  var valid_580501 = query.getOrDefault("alt")
  valid_580501 = validateParameter(valid_580501, JString, required = false,
                                 default = newJString("json"))
  if valid_580501 != nil:
    section.add "alt", valid_580501
  var valid_580502 = query.getOrDefault("userIp")
  valid_580502 = validateParameter(valid_580502, JString, required = false,
                                 default = nil)
  if valid_580502 != nil:
    section.add "userIp", valid_580502
  var valid_580503 = query.getOrDefault("quotaUser")
  valid_580503 = validateParameter(valid_580503, JString, required = false,
                                 default = nil)
  if valid_580503 != nil:
    section.add "quotaUser", valid_580503
  var valid_580504 = query.getOrDefault("fields")
  valid_580504 = validateParameter(valid_580504, JString, required = false,
                                 default = nil)
  if valid_580504 != nil:
    section.add "fields", valid_580504
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580505: Call_BooksSeriesGet_580494; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Series metadata for the given series ids.
  ## 
  let valid = call_580505.validator(path, query, header, formData, body)
  let scheme = call_580505.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580505.url(scheme.get, call_580505.host, call_580505.base,
                         call_580505.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580505, url, valid)

proc call*(call_580506: Call_BooksSeriesGet_580494; seriesId: JsonNode;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## booksSeriesGet
  ## Returns Series metadata for the given series ids.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   seriesId: JArray (required)
  ##           : String that identifies the series
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580507 = newJObject()
  add(query_580507, "key", newJString(key))
  add(query_580507, "prettyPrint", newJBool(prettyPrint))
  add(query_580507, "oauth_token", newJString(oauthToken))
  if seriesId != nil:
    query_580507.add "series_id", seriesId
  add(query_580507, "alt", newJString(alt))
  add(query_580507, "userIp", newJString(userIp))
  add(query_580507, "quotaUser", newJString(quotaUser))
  add(query_580507, "fields", newJString(fields))
  result = call_580506.call(nil, query_580507, nil, nil, nil)

var booksSeriesGet* = Call_BooksSeriesGet_580494(name: "booksSeriesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/series/get",
    validator: validate_BooksSeriesGet_580495, base: "/books/v1",
    url: url_BooksSeriesGet_580496, schemes: {Scheme.Https})
type
  Call_BooksSeriesMembershipGet_580508 = ref object of OpenApiRestCall_579389
proc url_BooksSeriesMembershipGet_580510(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BooksSeriesMembershipGet_580509(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns Series membership data given the series id.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   page_size: JInt
  ##            : Number of maximum results per page to be included in the response.
  ##   series_id: JString (required)
  ##            : String that identifies the series
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   page_token: JString
  ##             : The value of the nextToken from the previous page.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580511 = query.getOrDefault("key")
  valid_580511 = validateParameter(valid_580511, JString, required = false,
                                 default = nil)
  if valid_580511 != nil:
    section.add "key", valid_580511
  var valid_580512 = query.getOrDefault("prettyPrint")
  valid_580512 = validateParameter(valid_580512, JBool, required = false,
                                 default = newJBool(true))
  if valid_580512 != nil:
    section.add "prettyPrint", valid_580512
  var valid_580513 = query.getOrDefault("oauth_token")
  valid_580513 = validateParameter(valid_580513, JString, required = false,
                                 default = nil)
  if valid_580513 != nil:
    section.add "oauth_token", valid_580513
  var valid_580514 = query.getOrDefault("page_size")
  valid_580514 = validateParameter(valid_580514, JInt, required = false, default = nil)
  if valid_580514 != nil:
    section.add "page_size", valid_580514
  assert query != nil,
        "query argument is necessary due to required `series_id` field"
  var valid_580515 = query.getOrDefault("series_id")
  valid_580515 = validateParameter(valid_580515, JString, required = true,
                                 default = nil)
  if valid_580515 != nil:
    section.add "series_id", valid_580515
  var valid_580516 = query.getOrDefault("alt")
  valid_580516 = validateParameter(valid_580516, JString, required = false,
                                 default = newJString("json"))
  if valid_580516 != nil:
    section.add "alt", valid_580516
  var valid_580517 = query.getOrDefault("userIp")
  valid_580517 = validateParameter(valid_580517, JString, required = false,
                                 default = nil)
  if valid_580517 != nil:
    section.add "userIp", valid_580517
  var valid_580518 = query.getOrDefault("quotaUser")
  valid_580518 = validateParameter(valid_580518, JString, required = false,
                                 default = nil)
  if valid_580518 != nil:
    section.add "quotaUser", valid_580518
  var valid_580519 = query.getOrDefault("page_token")
  valid_580519 = validateParameter(valid_580519, JString, required = false,
                                 default = nil)
  if valid_580519 != nil:
    section.add "page_token", valid_580519
  var valid_580520 = query.getOrDefault("fields")
  valid_580520 = validateParameter(valid_580520, JString, required = false,
                                 default = nil)
  if valid_580520 != nil:
    section.add "fields", valid_580520
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580521: Call_BooksSeriesMembershipGet_580508; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Series membership data given the series id.
  ## 
  let valid = call_580521.validator(path, query, header, formData, body)
  let scheme = call_580521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580521.url(scheme.get, call_580521.host, call_580521.base,
                         call_580521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580521, url, valid)

proc call*(call_580522: Call_BooksSeriesMembershipGet_580508; seriesId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          pageSize: int = 0; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = ""): Recallable =
  ## booksSeriesMembershipGet
  ## Returns Series membership data given the series id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   pageSize: int
  ##           : Number of maximum results per page to be included in the response.
  ##   seriesId: string (required)
  ##           : String that identifies the series
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : The value of the nextToken from the previous page.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580523 = newJObject()
  add(query_580523, "key", newJString(key))
  add(query_580523, "prettyPrint", newJBool(prettyPrint))
  add(query_580523, "oauth_token", newJString(oauthToken))
  add(query_580523, "page_size", newJInt(pageSize))
  add(query_580523, "series_id", newJString(seriesId))
  add(query_580523, "alt", newJString(alt))
  add(query_580523, "userIp", newJString(userIp))
  add(query_580523, "quotaUser", newJString(quotaUser))
  add(query_580523, "page_token", newJString(pageToken))
  add(query_580523, "fields", newJString(fields))
  result = call_580522.call(nil, query_580523, nil, nil, nil)

var booksSeriesMembershipGet* = Call_BooksSeriesMembershipGet_580508(
    name: "booksSeriesMembershipGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/series/membership/get",
    validator: validate_BooksSeriesMembershipGet_580509, base: "/books/v1",
    url: url_BooksSeriesMembershipGet_580510, schemes: {Scheme.Https})
type
  Call_BooksBookshelvesList_580524 = ref object of OpenApiRestCall_579389
proc url_BooksBookshelvesList_580526(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BooksBookshelvesList_580525(path: JsonNode; query: JsonNode;
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
  var valid_580527 = path.getOrDefault("userId")
  valid_580527 = validateParameter(valid_580527, JString, required = true,
                                 default = nil)
  if valid_580527 != nil:
    section.add "userId", valid_580527
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580528 = query.getOrDefault("key")
  valid_580528 = validateParameter(valid_580528, JString, required = false,
                                 default = nil)
  if valid_580528 != nil:
    section.add "key", valid_580528
  var valid_580529 = query.getOrDefault("prettyPrint")
  valid_580529 = validateParameter(valid_580529, JBool, required = false,
                                 default = newJBool(true))
  if valid_580529 != nil:
    section.add "prettyPrint", valid_580529
  var valid_580530 = query.getOrDefault("oauth_token")
  valid_580530 = validateParameter(valid_580530, JString, required = false,
                                 default = nil)
  if valid_580530 != nil:
    section.add "oauth_token", valid_580530
  var valid_580531 = query.getOrDefault("source")
  valid_580531 = validateParameter(valid_580531, JString, required = false,
                                 default = nil)
  if valid_580531 != nil:
    section.add "source", valid_580531
  var valid_580532 = query.getOrDefault("alt")
  valid_580532 = validateParameter(valid_580532, JString, required = false,
                                 default = newJString("json"))
  if valid_580532 != nil:
    section.add "alt", valid_580532
  var valid_580533 = query.getOrDefault("userIp")
  valid_580533 = validateParameter(valid_580533, JString, required = false,
                                 default = nil)
  if valid_580533 != nil:
    section.add "userIp", valid_580533
  var valid_580534 = query.getOrDefault("quotaUser")
  valid_580534 = validateParameter(valid_580534, JString, required = false,
                                 default = nil)
  if valid_580534 != nil:
    section.add "quotaUser", valid_580534
  var valid_580535 = query.getOrDefault("fields")
  valid_580535 = validateParameter(valid_580535, JString, required = false,
                                 default = nil)
  if valid_580535 != nil:
    section.add "fields", valid_580535
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580536: Call_BooksBookshelvesList_580524; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of public bookshelves for the specified user.
  ## 
  let valid = call_580536.validator(path, query, header, formData, body)
  let scheme = call_580536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580536.url(scheme.get, call_580536.host, call_580536.base,
                         call_580536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580536, url, valid)

proc call*(call_580537: Call_BooksBookshelvesList_580524; userId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          source: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## booksBookshelvesList
  ## Retrieves a list of public bookshelves for the specified user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : ID of user for whom to retrieve bookshelves.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580538 = newJObject()
  var query_580539 = newJObject()
  add(query_580539, "key", newJString(key))
  add(query_580539, "prettyPrint", newJBool(prettyPrint))
  add(query_580539, "oauth_token", newJString(oauthToken))
  add(query_580539, "source", newJString(source))
  add(query_580539, "alt", newJString(alt))
  add(query_580539, "userIp", newJString(userIp))
  add(query_580539, "quotaUser", newJString(quotaUser))
  add(path_580538, "userId", newJString(userId))
  add(query_580539, "fields", newJString(fields))
  result = call_580537.call(path_580538, query_580539, nil, nil, nil)

var booksBookshelvesList* = Call_BooksBookshelvesList_580524(
    name: "booksBookshelvesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userId}/bookshelves",
    validator: validate_BooksBookshelvesList_580525, base: "/books/v1",
    url: url_BooksBookshelvesList_580526, schemes: {Scheme.Https})
type
  Call_BooksBookshelvesGet_580540 = ref object of OpenApiRestCall_579389
proc url_BooksBookshelvesGet_580542(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BooksBookshelvesGet_580541(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves metadata for a specific bookshelf for the specified user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : ID of user for whom to retrieve bookshelves.
  ##   shelf: JString (required)
  ##        : ID of bookshelf to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580543 = path.getOrDefault("userId")
  valid_580543 = validateParameter(valid_580543, JString, required = true,
                                 default = nil)
  if valid_580543 != nil:
    section.add "userId", valid_580543
  var valid_580544 = path.getOrDefault("shelf")
  valid_580544 = validateParameter(valid_580544, JString, required = true,
                                 default = nil)
  if valid_580544 != nil:
    section.add "shelf", valid_580544
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580545 = query.getOrDefault("key")
  valid_580545 = validateParameter(valid_580545, JString, required = false,
                                 default = nil)
  if valid_580545 != nil:
    section.add "key", valid_580545
  var valid_580546 = query.getOrDefault("prettyPrint")
  valid_580546 = validateParameter(valid_580546, JBool, required = false,
                                 default = newJBool(true))
  if valid_580546 != nil:
    section.add "prettyPrint", valid_580546
  var valid_580547 = query.getOrDefault("oauth_token")
  valid_580547 = validateParameter(valid_580547, JString, required = false,
                                 default = nil)
  if valid_580547 != nil:
    section.add "oauth_token", valid_580547
  var valid_580548 = query.getOrDefault("source")
  valid_580548 = validateParameter(valid_580548, JString, required = false,
                                 default = nil)
  if valid_580548 != nil:
    section.add "source", valid_580548
  var valid_580549 = query.getOrDefault("alt")
  valid_580549 = validateParameter(valid_580549, JString, required = false,
                                 default = newJString("json"))
  if valid_580549 != nil:
    section.add "alt", valid_580549
  var valid_580550 = query.getOrDefault("userIp")
  valid_580550 = validateParameter(valid_580550, JString, required = false,
                                 default = nil)
  if valid_580550 != nil:
    section.add "userIp", valid_580550
  var valid_580551 = query.getOrDefault("quotaUser")
  valid_580551 = validateParameter(valid_580551, JString, required = false,
                                 default = nil)
  if valid_580551 != nil:
    section.add "quotaUser", valid_580551
  var valid_580552 = query.getOrDefault("fields")
  valid_580552 = validateParameter(valid_580552, JString, required = false,
                                 default = nil)
  if valid_580552 != nil:
    section.add "fields", valid_580552
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580553: Call_BooksBookshelvesGet_580540; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves metadata for a specific bookshelf for the specified user.
  ## 
  let valid = call_580553.validator(path, query, header, formData, body)
  let scheme = call_580553.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580553.url(scheme.get, call_580553.host, call_580553.base,
                         call_580553.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580553, url, valid)

proc call*(call_580554: Call_BooksBookshelvesGet_580540; userId: string;
          shelf: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; source: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## booksBookshelvesGet
  ## Retrieves metadata for a specific bookshelf for the specified user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : ID of user for whom to retrieve bookshelves.
  ##   shelf: string (required)
  ##        : ID of bookshelf to retrieve.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580555 = newJObject()
  var query_580556 = newJObject()
  add(query_580556, "key", newJString(key))
  add(query_580556, "prettyPrint", newJBool(prettyPrint))
  add(query_580556, "oauth_token", newJString(oauthToken))
  add(query_580556, "source", newJString(source))
  add(query_580556, "alt", newJString(alt))
  add(query_580556, "userIp", newJString(userIp))
  add(query_580556, "quotaUser", newJString(quotaUser))
  add(path_580555, "userId", newJString(userId))
  add(path_580555, "shelf", newJString(shelf))
  add(query_580556, "fields", newJString(fields))
  result = call_580554.call(path_580555, query_580556, nil, nil, nil)

var booksBookshelvesGet* = Call_BooksBookshelvesGet_580540(
    name: "booksBookshelvesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userId}/bookshelves/{shelf}",
    validator: validate_BooksBookshelvesGet_580541, base: "/books/v1",
    url: url_BooksBookshelvesGet_580542, schemes: {Scheme.Https})
type
  Call_BooksBookshelvesVolumesList_580557 = ref object of OpenApiRestCall_579389
proc url_BooksBookshelvesVolumesList_580559(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BooksBookshelvesVolumesList_580558(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves volumes in a specific bookshelf for the specified user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : ID of user for whom to retrieve bookshelf volumes.
  ##   shelf: JString (required)
  ##        : ID of bookshelf to retrieve volumes.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580560 = path.getOrDefault("userId")
  valid_580560 = validateParameter(valid_580560, JString, required = true,
                                 default = nil)
  if valid_580560 != nil:
    section.add "userId", valid_580560
  var valid_580561 = path.getOrDefault("shelf")
  valid_580561 = validateParameter(valid_580561, JString, required = true,
                                 default = nil)
  if valid_580561 != nil:
    section.add "shelf", valid_580561
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   showPreorders: JBool
  ##                : Set to true to show pre-ordered books. Defaults to false.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: JInt
  ##             : Index of the first element to return (starts at 0)
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of results to return
  section = newJObject()
  var valid_580562 = query.getOrDefault("key")
  valid_580562 = validateParameter(valid_580562, JString, required = false,
                                 default = nil)
  if valid_580562 != nil:
    section.add "key", valid_580562
  var valid_580563 = query.getOrDefault("prettyPrint")
  valid_580563 = validateParameter(valid_580563, JBool, required = false,
                                 default = newJBool(true))
  if valid_580563 != nil:
    section.add "prettyPrint", valid_580563
  var valid_580564 = query.getOrDefault("oauth_token")
  valid_580564 = validateParameter(valid_580564, JString, required = false,
                                 default = nil)
  if valid_580564 != nil:
    section.add "oauth_token", valid_580564
  var valid_580565 = query.getOrDefault("source")
  valid_580565 = validateParameter(valid_580565, JString, required = false,
                                 default = nil)
  if valid_580565 != nil:
    section.add "source", valid_580565
  var valid_580566 = query.getOrDefault("showPreorders")
  valid_580566 = validateParameter(valid_580566, JBool, required = false, default = nil)
  if valid_580566 != nil:
    section.add "showPreorders", valid_580566
  var valid_580567 = query.getOrDefault("alt")
  valid_580567 = validateParameter(valid_580567, JString, required = false,
                                 default = newJString("json"))
  if valid_580567 != nil:
    section.add "alt", valid_580567
  var valid_580568 = query.getOrDefault("userIp")
  valid_580568 = validateParameter(valid_580568, JString, required = false,
                                 default = nil)
  if valid_580568 != nil:
    section.add "userIp", valid_580568
  var valid_580569 = query.getOrDefault("quotaUser")
  valid_580569 = validateParameter(valid_580569, JString, required = false,
                                 default = nil)
  if valid_580569 != nil:
    section.add "quotaUser", valid_580569
  var valid_580570 = query.getOrDefault("startIndex")
  valid_580570 = validateParameter(valid_580570, JInt, required = false, default = nil)
  if valid_580570 != nil:
    section.add "startIndex", valid_580570
  var valid_580571 = query.getOrDefault("fields")
  valid_580571 = validateParameter(valid_580571, JString, required = false,
                                 default = nil)
  if valid_580571 != nil:
    section.add "fields", valid_580571
  var valid_580572 = query.getOrDefault("maxResults")
  valid_580572 = validateParameter(valid_580572, JInt, required = false, default = nil)
  if valid_580572 != nil:
    section.add "maxResults", valid_580572
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580573: Call_BooksBookshelvesVolumesList_580557; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves volumes in a specific bookshelf for the specified user.
  ## 
  let valid = call_580573.validator(path, query, header, formData, body)
  let scheme = call_580573.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580573.url(scheme.get, call_580573.host, call_580573.base,
                         call_580573.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580573, url, valid)

proc call*(call_580574: Call_BooksBookshelvesVolumesList_580557; userId: string;
          shelf: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; source: string = ""; showPreorders: bool = false;
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          startIndex: int = 0; fields: string = ""; maxResults: int = 0): Recallable =
  ## booksBookshelvesVolumesList
  ## Retrieves volumes in a specific bookshelf for the specified user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   showPreorders: bool
  ##                : Set to true to show pre-ordered books. Defaults to false.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##             : Index of the first element to return (starts at 0)
  ##   userId: string (required)
  ##         : ID of user for whom to retrieve bookshelf volumes.
  ##   shelf: string (required)
  ##        : ID of bookshelf to retrieve volumes.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of results to return
  var path_580575 = newJObject()
  var query_580576 = newJObject()
  add(query_580576, "key", newJString(key))
  add(query_580576, "prettyPrint", newJBool(prettyPrint))
  add(query_580576, "oauth_token", newJString(oauthToken))
  add(query_580576, "source", newJString(source))
  add(query_580576, "showPreorders", newJBool(showPreorders))
  add(query_580576, "alt", newJString(alt))
  add(query_580576, "userIp", newJString(userIp))
  add(query_580576, "quotaUser", newJString(quotaUser))
  add(query_580576, "startIndex", newJInt(startIndex))
  add(path_580575, "userId", newJString(userId))
  add(path_580575, "shelf", newJString(shelf))
  add(query_580576, "fields", newJString(fields))
  add(query_580576, "maxResults", newJInt(maxResults))
  result = call_580574.call(path_580575, query_580576, nil, nil, nil)

var booksBookshelvesVolumesList* = Call_BooksBookshelvesVolumesList_580557(
    name: "booksBookshelvesVolumesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/users/{userId}/bookshelves/{shelf}/volumes",
    validator: validate_BooksBookshelvesVolumesList_580558, base: "/books/v1",
    url: url_BooksBookshelvesVolumesList_580559, schemes: {Scheme.Https})
type
  Call_BooksVolumesList_580577 = ref object of OpenApiRestCall_579389
proc url_BooksVolumesList_580579(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BooksVolumesList_580578(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Performs a book search.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   libraryRestrict: JString
  ##                  : Restrict search to this user's library.
  ##   printType: JString
  ##            : Restrict to books or magazines.
  ##   q: JString (required)
  ##    : Full-text search query string.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   showPreorders: JBool
  ##                : Set to true to show books available for preorder. Defaults to false.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   download: JString
  ##           : Restrict to volumes by download availability.
  ##   orderBy: JString
  ##          : Sort search results.
  ##   filter: JString
  ##         : Filter search results.
  ##   startIndex: JInt
  ##             : Index of the first result to return (starts at 0)
  ##   partner: JString
  ##          : Restrict and brand results for partner ID.
  ##   maxAllowedMaturityRating: JString
  ##                           : The maximum allowed maturity rating of returned recommendations. Books with a higher maturity rating are filtered out.
  ##   langRestrict: JString
  ##               : Restrict results to books with this language code.
  ##   projection: JString
  ##             : Restrict information returned to a set of selected fields.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of results to return.
  section = newJObject()
  var valid_580580 = query.getOrDefault("key")
  valid_580580 = validateParameter(valid_580580, JString, required = false,
                                 default = nil)
  if valid_580580 != nil:
    section.add "key", valid_580580
  var valid_580581 = query.getOrDefault("prettyPrint")
  valid_580581 = validateParameter(valid_580581, JBool, required = false,
                                 default = newJBool(true))
  if valid_580581 != nil:
    section.add "prettyPrint", valid_580581
  var valid_580582 = query.getOrDefault("oauth_token")
  valid_580582 = validateParameter(valid_580582, JString, required = false,
                                 default = nil)
  if valid_580582 != nil:
    section.add "oauth_token", valid_580582
  var valid_580583 = query.getOrDefault("libraryRestrict")
  valid_580583 = validateParameter(valid_580583, JString, required = false,
                                 default = newJString("my-library"))
  if valid_580583 != nil:
    section.add "libraryRestrict", valid_580583
  var valid_580584 = query.getOrDefault("printType")
  valid_580584 = validateParameter(valid_580584, JString, required = false,
                                 default = newJString("all"))
  if valid_580584 != nil:
    section.add "printType", valid_580584
  assert query != nil, "query argument is necessary due to required `q` field"
  var valid_580585 = query.getOrDefault("q")
  valid_580585 = validateParameter(valid_580585, JString, required = true,
                                 default = nil)
  if valid_580585 != nil:
    section.add "q", valid_580585
  var valid_580586 = query.getOrDefault("source")
  valid_580586 = validateParameter(valid_580586, JString, required = false,
                                 default = nil)
  if valid_580586 != nil:
    section.add "source", valid_580586
  var valid_580587 = query.getOrDefault("showPreorders")
  valid_580587 = validateParameter(valid_580587, JBool, required = false, default = nil)
  if valid_580587 != nil:
    section.add "showPreorders", valid_580587
  var valid_580588 = query.getOrDefault("alt")
  valid_580588 = validateParameter(valid_580588, JString, required = false,
                                 default = newJString("json"))
  if valid_580588 != nil:
    section.add "alt", valid_580588
  var valid_580589 = query.getOrDefault("userIp")
  valid_580589 = validateParameter(valid_580589, JString, required = false,
                                 default = nil)
  if valid_580589 != nil:
    section.add "userIp", valid_580589
  var valid_580590 = query.getOrDefault("quotaUser")
  valid_580590 = validateParameter(valid_580590, JString, required = false,
                                 default = nil)
  if valid_580590 != nil:
    section.add "quotaUser", valid_580590
  var valid_580591 = query.getOrDefault("download")
  valid_580591 = validateParameter(valid_580591, JString, required = false,
                                 default = newJString("epub"))
  if valid_580591 != nil:
    section.add "download", valid_580591
  var valid_580592 = query.getOrDefault("orderBy")
  valid_580592 = validateParameter(valid_580592, JString, required = false,
                                 default = newJString("newest"))
  if valid_580592 != nil:
    section.add "orderBy", valid_580592
  var valid_580593 = query.getOrDefault("filter")
  valid_580593 = validateParameter(valid_580593, JString, required = false,
                                 default = newJString("ebooks"))
  if valid_580593 != nil:
    section.add "filter", valid_580593
  var valid_580594 = query.getOrDefault("startIndex")
  valid_580594 = validateParameter(valid_580594, JInt, required = false, default = nil)
  if valid_580594 != nil:
    section.add "startIndex", valid_580594
  var valid_580595 = query.getOrDefault("partner")
  valid_580595 = validateParameter(valid_580595, JString, required = false,
                                 default = nil)
  if valid_580595 != nil:
    section.add "partner", valid_580595
  var valid_580596 = query.getOrDefault("maxAllowedMaturityRating")
  valid_580596 = validateParameter(valid_580596, JString, required = false,
                                 default = newJString("mature"))
  if valid_580596 != nil:
    section.add "maxAllowedMaturityRating", valid_580596
  var valid_580597 = query.getOrDefault("langRestrict")
  valid_580597 = validateParameter(valid_580597, JString, required = false,
                                 default = nil)
  if valid_580597 != nil:
    section.add "langRestrict", valid_580597
  var valid_580598 = query.getOrDefault("projection")
  valid_580598 = validateParameter(valid_580598, JString, required = false,
                                 default = newJString("full"))
  if valid_580598 != nil:
    section.add "projection", valid_580598
  var valid_580599 = query.getOrDefault("fields")
  valid_580599 = validateParameter(valid_580599, JString, required = false,
                                 default = nil)
  if valid_580599 != nil:
    section.add "fields", valid_580599
  var valid_580600 = query.getOrDefault("maxResults")
  valid_580600 = validateParameter(valid_580600, JInt, required = false, default = nil)
  if valid_580600 != nil:
    section.add "maxResults", valid_580600
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580601: Call_BooksVolumesList_580577; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs a book search.
  ## 
  let valid = call_580601.validator(path, query, header, formData, body)
  let scheme = call_580601.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580601.url(scheme.get, call_580601.host, call_580601.base,
                         call_580601.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580601, url, valid)

proc call*(call_580602: Call_BooksVolumesList_580577; q: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          libraryRestrict: string = "my-library"; printType: string = "all";
          source: string = ""; showPreorders: bool = false; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; download: string = "epub";
          orderBy: string = "newest"; filter: string = "ebooks"; startIndex: int = 0;
          partner: string = ""; maxAllowedMaturityRating: string = "mature";
          langRestrict: string = ""; projection: string = "full"; fields: string = "";
          maxResults: int = 0): Recallable =
  ## booksVolumesList
  ## Performs a book search.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   libraryRestrict: string
  ##                  : Restrict search to this user's library.
  ##   printType: string
  ##            : Restrict to books or magazines.
  ##   q: string (required)
  ##    : Full-text search query string.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   showPreorders: bool
  ##                : Set to true to show books available for preorder. Defaults to false.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   download: string
  ##           : Restrict to volumes by download availability.
  ##   orderBy: string
  ##          : Sort search results.
  ##   filter: string
  ##         : Filter search results.
  ##   startIndex: int
  ##             : Index of the first result to return (starts at 0)
  ##   partner: string
  ##          : Restrict and brand results for partner ID.
  ##   maxAllowedMaturityRating: string
  ##                           : The maximum allowed maturity rating of returned recommendations. Books with a higher maturity rating are filtered out.
  ##   langRestrict: string
  ##               : Restrict results to books with this language code.
  ##   projection: string
  ##             : Restrict information returned to a set of selected fields.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of results to return.
  var query_580603 = newJObject()
  add(query_580603, "key", newJString(key))
  add(query_580603, "prettyPrint", newJBool(prettyPrint))
  add(query_580603, "oauth_token", newJString(oauthToken))
  add(query_580603, "libraryRestrict", newJString(libraryRestrict))
  add(query_580603, "printType", newJString(printType))
  add(query_580603, "q", newJString(q))
  add(query_580603, "source", newJString(source))
  add(query_580603, "showPreorders", newJBool(showPreorders))
  add(query_580603, "alt", newJString(alt))
  add(query_580603, "userIp", newJString(userIp))
  add(query_580603, "quotaUser", newJString(quotaUser))
  add(query_580603, "download", newJString(download))
  add(query_580603, "orderBy", newJString(orderBy))
  add(query_580603, "filter", newJString(filter))
  add(query_580603, "startIndex", newJInt(startIndex))
  add(query_580603, "partner", newJString(partner))
  add(query_580603, "maxAllowedMaturityRating",
      newJString(maxAllowedMaturityRating))
  add(query_580603, "langRestrict", newJString(langRestrict))
  add(query_580603, "projection", newJString(projection))
  add(query_580603, "fields", newJString(fields))
  add(query_580603, "maxResults", newJInt(maxResults))
  result = call_580602.call(nil, query_580603, nil, nil, nil)

var booksVolumesList* = Call_BooksVolumesList_580577(name: "booksVolumesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/volumes",
    validator: validate_BooksVolumesList_580578, base: "/books/v1",
    url: url_BooksVolumesList_580579, schemes: {Scheme.Https})
type
  Call_BooksVolumesMybooksList_580604 = ref object of OpenApiRestCall_579389
proc url_BooksVolumesMybooksList_580606(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BooksVolumesMybooksList_580605(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Return a list of books in My Library.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   locale: JString
  ##         : ISO-639-1 language and ISO-3166-1 country code. Ex:'en_US'. Used for generating recommendations.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   acquireMethod: JArray
  ##                : How the book was acquired
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: JInt
  ##             : Index of the first result to return (starts at 0)
  ##   country: JString
  ##          : ISO-3166-1 code to override the IP-based location.
  ##   processingState: JArray
  ##                  : The processing state of the user uploaded volumes to be returned. Applicable only if the UPLOADED is specified in the acquireMethod.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of results to return.
  section = newJObject()
  var valid_580607 = query.getOrDefault("key")
  valid_580607 = validateParameter(valid_580607, JString, required = false,
                                 default = nil)
  if valid_580607 != nil:
    section.add "key", valid_580607
  var valid_580608 = query.getOrDefault("prettyPrint")
  valid_580608 = validateParameter(valid_580608, JBool, required = false,
                                 default = newJBool(true))
  if valid_580608 != nil:
    section.add "prettyPrint", valid_580608
  var valid_580609 = query.getOrDefault("oauth_token")
  valid_580609 = validateParameter(valid_580609, JString, required = false,
                                 default = nil)
  if valid_580609 != nil:
    section.add "oauth_token", valid_580609
  var valid_580610 = query.getOrDefault("locale")
  valid_580610 = validateParameter(valid_580610, JString, required = false,
                                 default = nil)
  if valid_580610 != nil:
    section.add "locale", valid_580610
  var valid_580611 = query.getOrDefault("source")
  valid_580611 = validateParameter(valid_580611, JString, required = false,
                                 default = nil)
  if valid_580611 != nil:
    section.add "source", valid_580611
  var valid_580612 = query.getOrDefault("alt")
  valid_580612 = validateParameter(valid_580612, JString, required = false,
                                 default = newJString("json"))
  if valid_580612 != nil:
    section.add "alt", valid_580612
  var valid_580613 = query.getOrDefault("userIp")
  valid_580613 = validateParameter(valid_580613, JString, required = false,
                                 default = nil)
  if valid_580613 != nil:
    section.add "userIp", valid_580613
  var valid_580614 = query.getOrDefault("acquireMethod")
  valid_580614 = validateParameter(valid_580614, JArray, required = false,
                                 default = nil)
  if valid_580614 != nil:
    section.add "acquireMethod", valid_580614
  var valid_580615 = query.getOrDefault("quotaUser")
  valid_580615 = validateParameter(valid_580615, JString, required = false,
                                 default = nil)
  if valid_580615 != nil:
    section.add "quotaUser", valid_580615
  var valid_580616 = query.getOrDefault("startIndex")
  valid_580616 = validateParameter(valid_580616, JInt, required = false, default = nil)
  if valid_580616 != nil:
    section.add "startIndex", valid_580616
  var valid_580617 = query.getOrDefault("country")
  valid_580617 = validateParameter(valid_580617, JString, required = false,
                                 default = nil)
  if valid_580617 != nil:
    section.add "country", valid_580617
  var valid_580618 = query.getOrDefault("processingState")
  valid_580618 = validateParameter(valid_580618, JArray, required = false,
                                 default = nil)
  if valid_580618 != nil:
    section.add "processingState", valid_580618
  var valid_580619 = query.getOrDefault("fields")
  valid_580619 = validateParameter(valid_580619, JString, required = false,
                                 default = nil)
  if valid_580619 != nil:
    section.add "fields", valid_580619
  var valid_580620 = query.getOrDefault("maxResults")
  valid_580620 = validateParameter(valid_580620, JInt, required = false, default = nil)
  if valid_580620 != nil:
    section.add "maxResults", valid_580620
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580621: Call_BooksVolumesMybooksList_580604; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return a list of books in My Library.
  ## 
  let valid = call_580621.validator(path, query, header, formData, body)
  let scheme = call_580621.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580621.url(scheme.get, call_580621.host, call_580621.base,
                         call_580621.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580621, url, valid)

proc call*(call_580622: Call_BooksVolumesMybooksList_580604; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; locale: string = "";
          source: string = ""; alt: string = "json"; userIp: string = "";
          acquireMethod: JsonNode = nil; quotaUser: string = ""; startIndex: int = 0;
          country: string = ""; processingState: JsonNode = nil; fields: string = "";
          maxResults: int = 0): Recallable =
  ## booksVolumesMybooksList
  ## Return a list of books in My Library.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   locale: string
  ##         : ISO-639-1 language and ISO-3166-1 country code. Ex:'en_US'. Used for generating recommendations.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   acquireMethod: JArray
  ##                : How the book was acquired
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##             : Index of the first result to return (starts at 0)
  ##   country: string
  ##          : ISO-3166-1 code to override the IP-based location.
  ##   processingState: JArray
  ##                  : The processing state of the user uploaded volumes to be returned. Applicable only if the UPLOADED is specified in the acquireMethod.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of results to return.
  var query_580623 = newJObject()
  add(query_580623, "key", newJString(key))
  add(query_580623, "prettyPrint", newJBool(prettyPrint))
  add(query_580623, "oauth_token", newJString(oauthToken))
  add(query_580623, "locale", newJString(locale))
  add(query_580623, "source", newJString(source))
  add(query_580623, "alt", newJString(alt))
  add(query_580623, "userIp", newJString(userIp))
  if acquireMethod != nil:
    query_580623.add "acquireMethod", acquireMethod
  add(query_580623, "quotaUser", newJString(quotaUser))
  add(query_580623, "startIndex", newJInt(startIndex))
  add(query_580623, "country", newJString(country))
  if processingState != nil:
    query_580623.add "processingState", processingState
  add(query_580623, "fields", newJString(fields))
  add(query_580623, "maxResults", newJInt(maxResults))
  result = call_580622.call(nil, query_580623, nil, nil, nil)

var booksVolumesMybooksList* = Call_BooksVolumesMybooksList_580604(
    name: "booksVolumesMybooksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/volumes/mybooks",
    validator: validate_BooksVolumesMybooksList_580605, base: "/books/v1",
    url: url_BooksVolumesMybooksList_580606, schemes: {Scheme.Https})
type
  Call_BooksVolumesRecommendedList_580624 = ref object of OpenApiRestCall_579389
proc url_BooksVolumesRecommendedList_580626(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BooksVolumesRecommendedList_580625(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Return a list of recommended books for the current user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   locale: JString
  ##         : ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'. Used for generating recommendations.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   maxAllowedMaturityRating: JString
  ##                           : The maximum allowed maturity rating of returned recommendations. Books with a higher maturity rating are filtered out.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580627 = query.getOrDefault("key")
  valid_580627 = validateParameter(valid_580627, JString, required = false,
                                 default = nil)
  if valid_580627 != nil:
    section.add "key", valid_580627
  var valid_580628 = query.getOrDefault("prettyPrint")
  valid_580628 = validateParameter(valid_580628, JBool, required = false,
                                 default = newJBool(true))
  if valid_580628 != nil:
    section.add "prettyPrint", valid_580628
  var valid_580629 = query.getOrDefault("oauth_token")
  valid_580629 = validateParameter(valid_580629, JString, required = false,
                                 default = nil)
  if valid_580629 != nil:
    section.add "oauth_token", valid_580629
  var valid_580630 = query.getOrDefault("locale")
  valid_580630 = validateParameter(valid_580630, JString, required = false,
                                 default = nil)
  if valid_580630 != nil:
    section.add "locale", valid_580630
  var valid_580631 = query.getOrDefault("source")
  valid_580631 = validateParameter(valid_580631, JString, required = false,
                                 default = nil)
  if valid_580631 != nil:
    section.add "source", valid_580631
  var valid_580632 = query.getOrDefault("alt")
  valid_580632 = validateParameter(valid_580632, JString, required = false,
                                 default = newJString("json"))
  if valid_580632 != nil:
    section.add "alt", valid_580632
  var valid_580633 = query.getOrDefault("userIp")
  valid_580633 = validateParameter(valid_580633, JString, required = false,
                                 default = nil)
  if valid_580633 != nil:
    section.add "userIp", valid_580633
  var valid_580634 = query.getOrDefault("quotaUser")
  valid_580634 = validateParameter(valid_580634, JString, required = false,
                                 default = nil)
  if valid_580634 != nil:
    section.add "quotaUser", valid_580634
  var valid_580635 = query.getOrDefault("maxAllowedMaturityRating")
  valid_580635 = validateParameter(valid_580635, JString, required = false,
                                 default = newJString("mature"))
  if valid_580635 != nil:
    section.add "maxAllowedMaturityRating", valid_580635
  var valid_580636 = query.getOrDefault("fields")
  valid_580636 = validateParameter(valid_580636, JString, required = false,
                                 default = nil)
  if valid_580636 != nil:
    section.add "fields", valid_580636
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580637: Call_BooksVolumesRecommendedList_580624; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return a list of recommended books for the current user.
  ## 
  let valid = call_580637.validator(path, query, header, formData, body)
  let scheme = call_580637.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580637.url(scheme.get, call_580637.host, call_580637.base,
                         call_580637.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580637, url, valid)

proc call*(call_580638: Call_BooksVolumesRecommendedList_580624; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; locale: string = "";
          source: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; maxAllowedMaturityRating: string = "mature";
          fields: string = ""): Recallable =
  ## booksVolumesRecommendedList
  ## Return a list of recommended books for the current user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   locale: string
  ##         : ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'. Used for generating recommendations.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   maxAllowedMaturityRating: string
  ##                           : The maximum allowed maturity rating of returned recommendations. Books with a higher maturity rating are filtered out.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580639 = newJObject()
  add(query_580639, "key", newJString(key))
  add(query_580639, "prettyPrint", newJBool(prettyPrint))
  add(query_580639, "oauth_token", newJString(oauthToken))
  add(query_580639, "locale", newJString(locale))
  add(query_580639, "source", newJString(source))
  add(query_580639, "alt", newJString(alt))
  add(query_580639, "userIp", newJString(userIp))
  add(query_580639, "quotaUser", newJString(quotaUser))
  add(query_580639, "maxAllowedMaturityRating",
      newJString(maxAllowedMaturityRating))
  add(query_580639, "fields", newJString(fields))
  result = call_580638.call(nil, query_580639, nil, nil, nil)

var booksVolumesRecommendedList* = Call_BooksVolumesRecommendedList_580624(
    name: "booksVolumesRecommendedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/volumes/recommended",
    validator: validate_BooksVolumesRecommendedList_580625, base: "/books/v1",
    url: url_BooksVolumesRecommendedList_580626, schemes: {Scheme.Https})
type
  Call_BooksVolumesRecommendedRate_580640 = ref object of OpenApiRestCall_579389
proc url_BooksVolumesRecommendedRate_580642(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BooksVolumesRecommendedRate_580641(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rate a recommended book for the current user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   locale: JString
  ##         : ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'. Used for generating recommendations.
  ##   rating: JString (required)
  ##         : Rating to be given to the volume.
  ##   volumeId: JString (required)
  ##           : ID of the source volume.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580643 = query.getOrDefault("key")
  valid_580643 = validateParameter(valid_580643, JString, required = false,
                                 default = nil)
  if valid_580643 != nil:
    section.add "key", valid_580643
  var valid_580644 = query.getOrDefault("prettyPrint")
  valid_580644 = validateParameter(valid_580644, JBool, required = false,
                                 default = newJBool(true))
  if valid_580644 != nil:
    section.add "prettyPrint", valid_580644
  var valid_580645 = query.getOrDefault("oauth_token")
  valid_580645 = validateParameter(valid_580645, JString, required = false,
                                 default = nil)
  if valid_580645 != nil:
    section.add "oauth_token", valid_580645
  var valid_580646 = query.getOrDefault("locale")
  valid_580646 = validateParameter(valid_580646, JString, required = false,
                                 default = nil)
  if valid_580646 != nil:
    section.add "locale", valid_580646
  assert query != nil, "query argument is necessary due to required `rating` field"
  var valid_580647 = query.getOrDefault("rating")
  valid_580647 = validateParameter(valid_580647, JString, required = true,
                                 default = newJString("HAVE_IT"))
  if valid_580647 != nil:
    section.add "rating", valid_580647
  var valid_580648 = query.getOrDefault("volumeId")
  valid_580648 = validateParameter(valid_580648, JString, required = true,
                                 default = nil)
  if valid_580648 != nil:
    section.add "volumeId", valid_580648
  var valid_580649 = query.getOrDefault("source")
  valid_580649 = validateParameter(valid_580649, JString, required = false,
                                 default = nil)
  if valid_580649 != nil:
    section.add "source", valid_580649
  var valid_580650 = query.getOrDefault("alt")
  valid_580650 = validateParameter(valid_580650, JString, required = false,
                                 default = newJString("json"))
  if valid_580650 != nil:
    section.add "alt", valid_580650
  var valid_580651 = query.getOrDefault("userIp")
  valid_580651 = validateParameter(valid_580651, JString, required = false,
                                 default = nil)
  if valid_580651 != nil:
    section.add "userIp", valid_580651
  var valid_580652 = query.getOrDefault("quotaUser")
  valid_580652 = validateParameter(valid_580652, JString, required = false,
                                 default = nil)
  if valid_580652 != nil:
    section.add "quotaUser", valid_580652
  var valid_580653 = query.getOrDefault("fields")
  valid_580653 = validateParameter(valid_580653, JString, required = false,
                                 default = nil)
  if valid_580653 != nil:
    section.add "fields", valid_580653
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580654: Call_BooksVolumesRecommendedRate_580640; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rate a recommended book for the current user.
  ## 
  let valid = call_580654.validator(path, query, header, formData, body)
  let scheme = call_580654.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580654.url(scheme.get, call_580654.host, call_580654.base,
                         call_580654.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580654, url, valid)

proc call*(call_580655: Call_BooksVolumesRecommendedRate_580640; volumeId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          locale: string = ""; rating: string = "HAVE_IT"; source: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## booksVolumesRecommendedRate
  ## Rate a recommended book for the current user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   locale: string
  ##         : ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'. Used for generating recommendations.
  ##   rating: string (required)
  ##         : Rating to be given to the volume.
  ##   volumeId: string (required)
  ##           : ID of the source volume.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580656 = newJObject()
  add(query_580656, "key", newJString(key))
  add(query_580656, "prettyPrint", newJBool(prettyPrint))
  add(query_580656, "oauth_token", newJString(oauthToken))
  add(query_580656, "locale", newJString(locale))
  add(query_580656, "rating", newJString(rating))
  add(query_580656, "volumeId", newJString(volumeId))
  add(query_580656, "source", newJString(source))
  add(query_580656, "alt", newJString(alt))
  add(query_580656, "userIp", newJString(userIp))
  add(query_580656, "quotaUser", newJString(quotaUser))
  add(query_580656, "fields", newJString(fields))
  result = call_580655.call(nil, query_580656, nil, nil, nil)

var booksVolumesRecommendedRate* = Call_BooksVolumesRecommendedRate_580640(
    name: "booksVolumesRecommendedRate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/volumes/recommended/rate",
    validator: validate_BooksVolumesRecommendedRate_580641, base: "/books/v1",
    url: url_BooksVolumesRecommendedRate_580642, schemes: {Scheme.Https})
type
  Call_BooksVolumesUseruploadedList_580657 = ref object of OpenApiRestCall_579389
proc url_BooksVolumesUseruploadedList_580659(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BooksVolumesUseruploadedList_580658(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Return a list of books uploaded by the current user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   locale: JString
  ##         : ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'. Used for generating recommendations.
  ##   volumeId: JArray
  ##           : The ids of the volumes to be returned. If not specified all that match the processingState are returned.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: JInt
  ##             : Index of the first result to return (starts at 0)
  ##   processingState: JArray
  ##                  : The processing state of the user uploaded volumes to be returned.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of results to return.
  section = newJObject()
  var valid_580660 = query.getOrDefault("key")
  valid_580660 = validateParameter(valid_580660, JString, required = false,
                                 default = nil)
  if valid_580660 != nil:
    section.add "key", valid_580660
  var valid_580661 = query.getOrDefault("prettyPrint")
  valid_580661 = validateParameter(valid_580661, JBool, required = false,
                                 default = newJBool(true))
  if valid_580661 != nil:
    section.add "prettyPrint", valid_580661
  var valid_580662 = query.getOrDefault("oauth_token")
  valid_580662 = validateParameter(valid_580662, JString, required = false,
                                 default = nil)
  if valid_580662 != nil:
    section.add "oauth_token", valid_580662
  var valid_580663 = query.getOrDefault("locale")
  valid_580663 = validateParameter(valid_580663, JString, required = false,
                                 default = nil)
  if valid_580663 != nil:
    section.add "locale", valid_580663
  var valid_580664 = query.getOrDefault("volumeId")
  valid_580664 = validateParameter(valid_580664, JArray, required = false,
                                 default = nil)
  if valid_580664 != nil:
    section.add "volumeId", valid_580664
  var valid_580665 = query.getOrDefault("source")
  valid_580665 = validateParameter(valid_580665, JString, required = false,
                                 default = nil)
  if valid_580665 != nil:
    section.add "source", valid_580665
  var valid_580666 = query.getOrDefault("alt")
  valid_580666 = validateParameter(valid_580666, JString, required = false,
                                 default = newJString("json"))
  if valid_580666 != nil:
    section.add "alt", valid_580666
  var valid_580667 = query.getOrDefault("userIp")
  valid_580667 = validateParameter(valid_580667, JString, required = false,
                                 default = nil)
  if valid_580667 != nil:
    section.add "userIp", valid_580667
  var valid_580668 = query.getOrDefault("quotaUser")
  valid_580668 = validateParameter(valid_580668, JString, required = false,
                                 default = nil)
  if valid_580668 != nil:
    section.add "quotaUser", valid_580668
  var valid_580669 = query.getOrDefault("startIndex")
  valid_580669 = validateParameter(valid_580669, JInt, required = false, default = nil)
  if valid_580669 != nil:
    section.add "startIndex", valid_580669
  var valid_580670 = query.getOrDefault("processingState")
  valid_580670 = validateParameter(valid_580670, JArray, required = false,
                                 default = nil)
  if valid_580670 != nil:
    section.add "processingState", valid_580670
  var valid_580671 = query.getOrDefault("fields")
  valid_580671 = validateParameter(valid_580671, JString, required = false,
                                 default = nil)
  if valid_580671 != nil:
    section.add "fields", valid_580671
  var valid_580672 = query.getOrDefault("maxResults")
  valid_580672 = validateParameter(valid_580672, JInt, required = false, default = nil)
  if valid_580672 != nil:
    section.add "maxResults", valid_580672
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580673: Call_BooksVolumesUseruploadedList_580657; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return a list of books uploaded by the current user.
  ## 
  let valid = call_580673.validator(path, query, header, formData, body)
  let scheme = call_580673.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580673.url(scheme.get, call_580673.host, call_580673.base,
                         call_580673.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580673, url, valid)

proc call*(call_580674: Call_BooksVolumesUseruploadedList_580657; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; locale: string = "";
          volumeId: JsonNode = nil; source: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; startIndex: int = 0;
          processingState: JsonNode = nil; fields: string = ""; maxResults: int = 0): Recallable =
  ## booksVolumesUseruploadedList
  ## Return a list of books uploaded by the current user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   locale: string
  ##         : ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'. Used for generating recommendations.
  ##   volumeId: JArray
  ##           : The ids of the volumes to be returned. If not specified all that match the processingState are returned.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##             : Index of the first result to return (starts at 0)
  ##   processingState: JArray
  ##                  : The processing state of the user uploaded volumes to be returned.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of results to return.
  var query_580675 = newJObject()
  add(query_580675, "key", newJString(key))
  add(query_580675, "prettyPrint", newJBool(prettyPrint))
  add(query_580675, "oauth_token", newJString(oauthToken))
  add(query_580675, "locale", newJString(locale))
  if volumeId != nil:
    query_580675.add "volumeId", volumeId
  add(query_580675, "source", newJString(source))
  add(query_580675, "alt", newJString(alt))
  add(query_580675, "userIp", newJString(userIp))
  add(query_580675, "quotaUser", newJString(quotaUser))
  add(query_580675, "startIndex", newJInt(startIndex))
  if processingState != nil:
    query_580675.add "processingState", processingState
  add(query_580675, "fields", newJString(fields))
  add(query_580675, "maxResults", newJInt(maxResults))
  result = call_580674.call(nil, query_580675, nil, nil, nil)

var booksVolumesUseruploadedList* = Call_BooksVolumesUseruploadedList_580657(
    name: "booksVolumesUseruploadedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/volumes/useruploaded",
    validator: validate_BooksVolumesUseruploadedList_580658, base: "/books/v1",
    url: url_BooksVolumesUseruploadedList_580659, schemes: {Scheme.Https})
type
  Call_BooksVolumesGet_580676 = ref object of OpenApiRestCall_579389
proc url_BooksVolumesGet_580678(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BooksVolumesGet_580677(path: JsonNode; query: JsonNode;
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
  var valid_580679 = path.getOrDefault("volumeId")
  valid_580679 = validateParameter(valid_580679, JString, required = true,
                                 default = nil)
  if valid_580679 != nil:
    section.add "volumeId", valid_580679
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   includeNonComicsSeries: JBool
  ##                         : Set to true to include non-comics series. Defaults to false.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   partner: JString
  ##          : Brand results for partner ID.
  ##   user_library_consistent_read: JBool
  ##   country: JString
  ##          : ISO-3166-1 code to override the IP-based location.
  ##   projection: JString
  ##             : Restrict information returned to a set of selected fields.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580680 = query.getOrDefault("key")
  valid_580680 = validateParameter(valid_580680, JString, required = false,
                                 default = nil)
  if valid_580680 != nil:
    section.add "key", valid_580680
  var valid_580681 = query.getOrDefault("prettyPrint")
  valid_580681 = validateParameter(valid_580681, JBool, required = false,
                                 default = newJBool(true))
  if valid_580681 != nil:
    section.add "prettyPrint", valid_580681
  var valid_580682 = query.getOrDefault("oauth_token")
  valid_580682 = validateParameter(valid_580682, JString, required = false,
                                 default = nil)
  if valid_580682 != nil:
    section.add "oauth_token", valid_580682
  var valid_580683 = query.getOrDefault("includeNonComicsSeries")
  valid_580683 = validateParameter(valid_580683, JBool, required = false, default = nil)
  if valid_580683 != nil:
    section.add "includeNonComicsSeries", valid_580683
  var valid_580684 = query.getOrDefault("source")
  valid_580684 = validateParameter(valid_580684, JString, required = false,
                                 default = nil)
  if valid_580684 != nil:
    section.add "source", valid_580684
  var valid_580685 = query.getOrDefault("alt")
  valid_580685 = validateParameter(valid_580685, JString, required = false,
                                 default = newJString("json"))
  if valid_580685 != nil:
    section.add "alt", valid_580685
  var valid_580686 = query.getOrDefault("userIp")
  valid_580686 = validateParameter(valid_580686, JString, required = false,
                                 default = nil)
  if valid_580686 != nil:
    section.add "userIp", valid_580686
  var valid_580687 = query.getOrDefault("quotaUser")
  valid_580687 = validateParameter(valid_580687, JString, required = false,
                                 default = nil)
  if valid_580687 != nil:
    section.add "quotaUser", valid_580687
  var valid_580688 = query.getOrDefault("partner")
  valid_580688 = validateParameter(valid_580688, JString, required = false,
                                 default = nil)
  if valid_580688 != nil:
    section.add "partner", valid_580688
  var valid_580689 = query.getOrDefault("user_library_consistent_read")
  valid_580689 = validateParameter(valid_580689, JBool, required = false, default = nil)
  if valid_580689 != nil:
    section.add "user_library_consistent_read", valid_580689
  var valid_580690 = query.getOrDefault("country")
  valid_580690 = validateParameter(valid_580690, JString, required = false,
                                 default = nil)
  if valid_580690 != nil:
    section.add "country", valid_580690
  var valid_580691 = query.getOrDefault("projection")
  valid_580691 = validateParameter(valid_580691, JString, required = false,
                                 default = newJString("full"))
  if valid_580691 != nil:
    section.add "projection", valid_580691
  var valid_580692 = query.getOrDefault("fields")
  valid_580692 = validateParameter(valid_580692, JString, required = false,
                                 default = nil)
  if valid_580692 != nil:
    section.add "fields", valid_580692
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580693: Call_BooksVolumesGet_580676; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets volume information for a single volume.
  ## 
  let valid = call_580693.validator(path, query, header, formData, body)
  let scheme = call_580693.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580693.url(scheme.get, call_580693.host, call_580693.base,
                         call_580693.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580693, url, valid)

proc call*(call_580694: Call_BooksVolumesGet_580676; volumeId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          includeNonComicsSeries: bool = false; source: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          partner: string = ""; userLibraryConsistentRead: bool = false;
          country: string = ""; projection: string = "full"; fields: string = ""): Recallable =
  ## booksVolumesGet
  ## Gets volume information for a single volume.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   includeNonComicsSeries: bool
  ##                         : Set to true to include non-comics series. Defaults to false.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   partner: string
  ##          : Brand results for partner ID.
  ##   volumeId: string (required)
  ##           : ID of volume to retrieve.
  ##   userLibraryConsistentRead: bool
  ##   country: string
  ##          : ISO-3166-1 code to override the IP-based location.
  ##   projection: string
  ##             : Restrict information returned to a set of selected fields.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580695 = newJObject()
  var query_580696 = newJObject()
  add(query_580696, "key", newJString(key))
  add(query_580696, "prettyPrint", newJBool(prettyPrint))
  add(query_580696, "oauth_token", newJString(oauthToken))
  add(query_580696, "includeNonComicsSeries", newJBool(includeNonComicsSeries))
  add(query_580696, "source", newJString(source))
  add(query_580696, "alt", newJString(alt))
  add(query_580696, "userIp", newJString(userIp))
  add(query_580696, "quotaUser", newJString(quotaUser))
  add(query_580696, "partner", newJString(partner))
  add(path_580695, "volumeId", newJString(volumeId))
  add(query_580696, "user_library_consistent_read",
      newJBool(userLibraryConsistentRead))
  add(query_580696, "country", newJString(country))
  add(query_580696, "projection", newJString(projection))
  add(query_580696, "fields", newJString(fields))
  result = call_580694.call(path_580695, query_580696, nil, nil, nil)

var booksVolumesGet* = Call_BooksVolumesGet_580676(name: "booksVolumesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/volumes/{volumeId}", validator: validate_BooksVolumesGet_580677,
    base: "/books/v1", url: url_BooksVolumesGet_580678, schemes: {Scheme.Https})
type
  Call_BooksVolumesAssociatedList_580697 = ref object of OpenApiRestCall_579389
proc url_BooksVolumesAssociatedList_580699(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BooksVolumesAssociatedList_580698(path: JsonNode; query: JsonNode;
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
  var valid_580700 = path.getOrDefault("volumeId")
  valid_580700 = validateParameter(valid_580700, JString, required = true,
                                 default = nil)
  if valid_580700 != nil:
    section.add "volumeId", valid_580700
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   association: JString
  ##              : Association type.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   locale: JString
  ##         : ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'. Used for generating recommendations.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   maxAllowedMaturityRating: JString
  ##                           : The maximum allowed maturity rating of returned recommendations. Books with a higher maturity rating are filtered out.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580701 = query.getOrDefault("key")
  valid_580701 = validateParameter(valid_580701, JString, required = false,
                                 default = nil)
  if valid_580701 != nil:
    section.add "key", valid_580701
  var valid_580702 = query.getOrDefault("association")
  valid_580702 = validateParameter(valid_580702, JString, required = false,
                                 default = newJString("end-of-sample"))
  if valid_580702 != nil:
    section.add "association", valid_580702
  var valid_580703 = query.getOrDefault("prettyPrint")
  valid_580703 = validateParameter(valid_580703, JBool, required = false,
                                 default = newJBool(true))
  if valid_580703 != nil:
    section.add "prettyPrint", valid_580703
  var valid_580704 = query.getOrDefault("oauth_token")
  valid_580704 = validateParameter(valid_580704, JString, required = false,
                                 default = nil)
  if valid_580704 != nil:
    section.add "oauth_token", valid_580704
  var valid_580705 = query.getOrDefault("locale")
  valid_580705 = validateParameter(valid_580705, JString, required = false,
                                 default = nil)
  if valid_580705 != nil:
    section.add "locale", valid_580705
  var valid_580706 = query.getOrDefault("source")
  valid_580706 = validateParameter(valid_580706, JString, required = false,
                                 default = nil)
  if valid_580706 != nil:
    section.add "source", valid_580706
  var valid_580707 = query.getOrDefault("alt")
  valid_580707 = validateParameter(valid_580707, JString, required = false,
                                 default = newJString("json"))
  if valid_580707 != nil:
    section.add "alt", valid_580707
  var valid_580708 = query.getOrDefault("userIp")
  valid_580708 = validateParameter(valid_580708, JString, required = false,
                                 default = nil)
  if valid_580708 != nil:
    section.add "userIp", valid_580708
  var valid_580709 = query.getOrDefault("quotaUser")
  valid_580709 = validateParameter(valid_580709, JString, required = false,
                                 default = nil)
  if valid_580709 != nil:
    section.add "quotaUser", valid_580709
  var valid_580710 = query.getOrDefault("maxAllowedMaturityRating")
  valid_580710 = validateParameter(valid_580710, JString, required = false,
                                 default = newJString("mature"))
  if valid_580710 != nil:
    section.add "maxAllowedMaturityRating", valid_580710
  var valid_580711 = query.getOrDefault("fields")
  valid_580711 = validateParameter(valid_580711, JString, required = false,
                                 default = nil)
  if valid_580711 != nil:
    section.add "fields", valid_580711
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580712: Call_BooksVolumesAssociatedList_580697; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return a list of associated books.
  ## 
  let valid = call_580712.validator(path, query, header, formData, body)
  let scheme = call_580712.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580712.url(scheme.get, call_580712.host, call_580712.base,
                         call_580712.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580712, url, valid)

proc call*(call_580713: Call_BooksVolumesAssociatedList_580697; volumeId: string;
          key: string = ""; association: string = "end-of-sample";
          prettyPrint: bool = true; oauthToken: string = ""; locale: string = "";
          source: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; maxAllowedMaturityRating: string = "mature";
          fields: string = ""): Recallable =
  ## booksVolumesAssociatedList
  ## Return a list of associated books.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   association: string
  ##              : Association type.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   locale: string
  ##         : ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'. Used for generating recommendations.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   maxAllowedMaturityRating: string
  ##                           : The maximum allowed maturity rating of returned recommendations. Books with a higher maturity rating are filtered out.
  ##   volumeId: string (required)
  ##           : ID of the source volume.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580714 = newJObject()
  var query_580715 = newJObject()
  add(query_580715, "key", newJString(key))
  add(query_580715, "association", newJString(association))
  add(query_580715, "prettyPrint", newJBool(prettyPrint))
  add(query_580715, "oauth_token", newJString(oauthToken))
  add(query_580715, "locale", newJString(locale))
  add(query_580715, "source", newJString(source))
  add(query_580715, "alt", newJString(alt))
  add(query_580715, "userIp", newJString(userIp))
  add(query_580715, "quotaUser", newJString(quotaUser))
  add(query_580715, "maxAllowedMaturityRating",
      newJString(maxAllowedMaturityRating))
  add(path_580714, "volumeId", newJString(volumeId))
  add(query_580715, "fields", newJString(fields))
  result = call_580713.call(path_580714, query_580715, nil, nil, nil)

var booksVolumesAssociatedList* = Call_BooksVolumesAssociatedList_580697(
    name: "booksVolumesAssociatedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/volumes/{volumeId}/associated",
    validator: validate_BooksVolumesAssociatedList_580698, base: "/books/v1",
    url: url_BooksVolumesAssociatedList_580699, schemes: {Scheme.Https})
type
  Call_BooksLayersVolumeAnnotationsList_580716 = ref object of OpenApiRestCall_579389
proc url_BooksLayersVolumeAnnotationsList_580718(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BooksLayersVolumeAnnotationsList_580717(path: JsonNode;
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
  var valid_580719 = path.getOrDefault("volumeId")
  valid_580719 = validateParameter(valid_580719, JString, required = true,
                                 default = nil)
  if valid_580719 != nil:
    section.add "volumeId", valid_580719
  var valid_580720 = path.getOrDefault("layerId")
  valid_580720 = validateParameter(valid_580720, JString, required = true,
                                 default = nil)
  if valid_580720 != nil:
    section.add "layerId", valid_580720
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   endOffset: JString
  ##            : The end offset to end retrieving data from.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   locale: JString
  ##         : The locale information for the data. ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'.
  ##   startPosition: JString
  ##                : The start position to start retrieving data from.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   volumeAnnotationsVersion: JString
  ##                           : The version of the volume annotations that you are requesting.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   contentVersion: JString (required)
  ##                 : The content version for the requested volume.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The value of the nextToken from the previous page.
  ##   updatedMax: JString
  ##             : RFC 3339 timestamp to restrict to items updated prior to this timestamp (exclusive).
  ##   endPosition: JString
  ##              : The end position to end retrieving data from.
  ##   startOffset: JString
  ##              : The start offset to start retrieving data from.
  ##   updatedMin: JString
  ##             : RFC 3339 timestamp to restrict to items updated since this timestamp (inclusive).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   showDeleted: JBool
  ##              : Set to true to return deleted annotations. updatedMin must be in the request to use this. Defaults to false.
  ##   maxResults: JInt
  ##             : Maximum number of results to return
  section = newJObject()
  var valid_580721 = query.getOrDefault("key")
  valid_580721 = validateParameter(valid_580721, JString, required = false,
                                 default = nil)
  if valid_580721 != nil:
    section.add "key", valid_580721
  var valid_580722 = query.getOrDefault("endOffset")
  valid_580722 = validateParameter(valid_580722, JString, required = false,
                                 default = nil)
  if valid_580722 != nil:
    section.add "endOffset", valid_580722
  var valid_580723 = query.getOrDefault("prettyPrint")
  valid_580723 = validateParameter(valid_580723, JBool, required = false,
                                 default = newJBool(true))
  if valid_580723 != nil:
    section.add "prettyPrint", valid_580723
  var valid_580724 = query.getOrDefault("oauth_token")
  valid_580724 = validateParameter(valid_580724, JString, required = false,
                                 default = nil)
  if valid_580724 != nil:
    section.add "oauth_token", valid_580724
  var valid_580725 = query.getOrDefault("locale")
  valid_580725 = validateParameter(valid_580725, JString, required = false,
                                 default = nil)
  if valid_580725 != nil:
    section.add "locale", valid_580725
  var valid_580726 = query.getOrDefault("startPosition")
  valid_580726 = validateParameter(valid_580726, JString, required = false,
                                 default = nil)
  if valid_580726 != nil:
    section.add "startPosition", valid_580726
  var valid_580727 = query.getOrDefault("source")
  valid_580727 = validateParameter(valid_580727, JString, required = false,
                                 default = nil)
  if valid_580727 != nil:
    section.add "source", valid_580727
  var valid_580728 = query.getOrDefault("volumeAnnotationsVersion")
  valid_580728 = validateParameter(valid_580728, JString, required = false,
                                 default = nil)
  if valid_580728 != nil:
    section.add "volumeAnnotationsVersion", valid_580728
  var valid_580729 = query.getOrDefault("alt")
  valid_580729 = validateParameter(valid_580729, JString, required = false,
                                 default = newJString("json"))
  if valid_580729 != nil:
    section.add "alt", valid_580729
  var valid_580730 = query.getOrDefault("userIp")
  valid_580730 = validateParameter(valid_580730, JString, required = false,
                                 default = nil)
  if valid_580730 != nil:
    section.add "userIp", valid_580730
  assert query != nil,
        "query argument is necessary due to required `contentVersion` field"
  var valid_580731 = query.getOrDefault("contentVersion")
  valid_580731 = validateParameter(valid_580731, JString, required = true,
                                 default = nil)
  if valid_580731 != nil:
    section.add "contentVersion", valid_580731
  var valid_580732 = query.getOrDefault("quotaUser")
  valid_580732 = validateParameter(valid_580732, JString, required = false,
                                 default = nil)
  if valid_580732 != nil:
    section.add "quotaUser", valid_580732
  var valid_580733 = query.getOrDefault("pageToken")
  valid_580733 = validateParameter(valid_580733, JString, required = false,
                                 default = nil)
  if valid_580733 != nil:
    section.add "pageToken", valid_580733
  var valid_580734 = query.getOrDefault("updatedMax")
  valid_580734 = validateParameter(valid_580734, JString, required = false,
                                 default = nil)
  if valid_580734 != nil:
    section.add "updatedMax", valid_580734
  var valid_580735 = query.getOrDefault("endPosition")
  valid_580735 = validateParameter(valid_580735, JString, required = false,
                                 default = nil)
  if valid_580735 != nil:
    section.add "endPosition", valid_580735
  var valid_580736 = query.getOrDefault("startOffset")
  valid_580736 = validateParameter(valid_580736, JString, required = false,
                                 default = nil)
  if valid_580736 != nil:
    section.add "startOffset", valid_580736
  var valid_580737 = query.getOrDefault("updatedMin")
  valid_580737 = validateParameter(valid_580737, JString, required = false,
                                 default = nil)
  if valid_580737 != nil:
    section.add "updatedMin", valid_580737
  var valid_580738 = query.getOrDefault("fields")
  valid_580738 = validateParameter(valid_580738, JString, required = false,
                                 default = nil)
  if valid_580738 != nil:
    section.add "fields", valid_580738
  var valid_580739 = query.getOrDefault("showDeleted")
  valid_580739 = validateParameter(valid_580739, JBool, required = false, default = nil)
  if valid_580739 != nil:
    section.add "showDeleted", valid_580739
  var valid_580740 = query.getOrDefault("maxResults")
  valid_580740 = validateParameter(valid_580740, JInt, required = false, default = nil)
  if valid_580740 != nil:
    section.add "maxResults", valid_580740
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580741: Call_BooksLayersVolumeAnnotationsList_580716;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the volume annotations for a volume and layer.
  ## 
  let valid = call_580741.validator(path, query, header, formData, body)
  let scheme = call_580741.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580741.url(scheme.get, call_580741.host, call_580741.base,
                         call_580741.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580741, url, valid)

proc call*(call_580742: Call_BooksLayersVolumeAnnotationsList_580716;
          contentVersion: string; volumeId: string; layerId: string; key: string = "";
          endOffset: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          locale: string = ""; startPosition: string = ""; source: string = "";
          volumeAnnotationsVersion: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          updatedMax: string = ""; endPosition: string = ""; startOffset: string = "";
          updatedMin: string = ""; fields: string = ""; showDeleted: bool = false;
          maxResults: int = 0): Recallable =
  ## booksLayersVolumeAnnotationsList
  ## Gets the volume annotations for a volume and layer.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   endOffset: string
  ##            : The end offset to end retrieving data from.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   locale: string
  ##         : The locale information for the data. ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'.
  ##   startPosition: string
  ##                : The start position to start retrieving data from.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   volumeAnnotationsVersion: string
  ##                           : The version of the volume annotations that you are requesting.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   contentVersion: string (required)
  ##                 : The content version for the requested volume.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : The value of the nextToken from the previous page.
  ##   volumeId: string (required)
  ##           : The volume to retrieve annotations for.
  ##   layerId: string (required)
  ##          : The ID for the layer to get the annotations.
  ##   updatedMax: string
  ##             : RFC 3339 timestamp to restrict to items updated prior to this timestamp (exclusive).
  ##   endPosition: string
  ##              : The end position to end retrieving data from.
  ##   startOffset: string
  ##              : The start offset to start retrieving data from.
  ##   updatedMin: string
  ##             : RFC 3339 timestamp to restrict to items updated since this timestamp (inclusive).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   showDeleted: bool
  ##              : Set to true to return deleted annotations. updatedMin must be in the request to use this. Defaults to false.
  ##   maxResults: int
  ##             : Maximum number of results to return
  var path_580743 = newJObject()
  var query_580744 = newJObject()
  add(query_580744, "key", newJString(key))
  add(query_580744, "endOffset", newJString(endOffset))
  add(query_580744, "prettyPrint", newJBool(prettyPrint))
  add(query_580744, "oauth_token", newJString(oauthToken))
  add(query_580744, "locale", newJString(locale))
  add(query_580744, "startPosition", newJString(startPosition))
  add(query_580744, "source", newJString(source))
  add(query_580744, "volumeAnnotationsVersion",
      newJString(volumeAnnotationsVersion))
  add(query_580744, "alt", newJString(alt))
  add(query_580744, "userIp", newJString(userIp))
  add(query_580744, "contentVersion", newJString(contentVersion))
  add(query_580744, "quotaUser", newJString(quotaUser))
  add(query_580744, "pageToken", newJString(pageToken))
  add(path_580743, "volumeId", newJString(volumeId))
  add(path_580743, "layerId", newJString(layerId))
  add(query_580744, "updatedMax", newJString(updatedMax))
  add(query_580744, "endPosition", newJString(endPosition))
  add(query_580744, "startOffset", newJString(startOffset))
  add(query_580744, "updatedMin", newJString(updatedMin))
  add(query_580744, "fields", newJString(fields))
  add(query_580744, "showDeleted", newJBool(showDeleted))
  add(query_580744, "maxResults", newJInt(maxResults))
  result = call_580742.call(path_580743, query_580744, nil, nil, nil)

var booksLayersVolumeAnnotationsList* = Call_BooksLayersVolumeAnnotationsList_580716(
    name: "booksLayersVolumeAnnotationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/volumes/{volumeId}/layers/{layerId}",
    validator: validate_BooksLayersVolumeAnnotationsList_580717,
    base: "/books/v1", url: url_BooksLayersVolumeAnnotationsList_580718,
    schemes: {Scheme.Https})
type
  Call_BooksLayersVolumeAnnotationsGet_580745 = ref object of OpenApiRestCall_579389
proc url_BooksLayersVolumeAnnotationsGet_580747(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BooksLayersVolumeAnnotationsGet_580746(path: JsonNode;
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
  var valid_580748 = path.getOrDefault("annotationId")
  valid_580748 = validateParameter(valid_580748, JString, required = true,
                                 default = nil)
  if valid_580748 != nil:
    section.add "annotationId", valid_580748
  var valid_580749 = path.getOrDefault("volumeId")
  valid_580749 = validateParameter(valid_580749, JString, required = true,
                                 default = nil)
  if valid_580749 != nil:
    section.add "volumeId", valid_580749
  var valid_580750 = path.getOrDefault("layerId")
  valid_580750 = validateParameter(valid_580750, JString, required = true,
                                 default = nil)
  if valid_580750 != nil:
    section.add "layerId", valid_580750
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   locale: JString
  ##         : The locale information for the data. ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580751 = query.getOrDefault("key")
  valid_580751 = validateParameter(valid_580751, JString, required = false,
                                 default = nil)
  if valid_580751 != nil:
    section.add "key", valid_580751
  var valid_580752 = query.getOrDefault("prettyPrint")
  valid_580752 = validateParameter(valid_580752, JBool, required = false,
                                 default = newJBool(true))
  if valid_580752 != nil:
    section.add "prettyPrint", valid_580752
  var valid_580753 = query.getOrDefault("oauth_token")
  valid_580753 = validateParameter(valid_580753, JString, required = false,
                                 default = nil)
  if valid_580753 != nil:
    section.add "oauth_token", valid_580753
  var valid_580754 = query.getOrDefault("locale")
  valid_580754 = validateParameter(valid_580754, JString, required = false,
                                 default = nil)
  if valid_580754 != nil:
    section.add "locale", valid_580754
  var valid_580755 = query.getOrDefault("source")
  valid_580755 = validateParameter(valid_580755, JString, required = false,
                                 default = nil)
  if valid_580755 != nil:
    section.add "source", valid_580755
  var valid_580756 = query.getOrDefault("alt")
  valid_580756 = validateParameter(valid_580756, JString, required = false,
                                 default = newJString("json"))
  if valid_580756 != nil:
    section.add "alt", valid_580756
  var valid_580757 = query.getOrDefault("userIp")
  valid_580757 = validateParameter(valid_580757, JString, required = false,
                                 default = nil)
  if valid_580757 != nil:
    section.add "userIp", valid_580757
  var valid_580758 = query.getOrDefault("quotaUser")
  valid_580758 = validateParameter(valid_580758, JString, required = false,
                                 default = nil)
  if valid_580758 != nil:
    section.add "quotaUser", valid_580758
  var valid_580759 = query.getOrDefault("fields")
  valid_580759 = validateParameter(valid_580759, JString, required = false,
                                 default = nil)
  if valid_580759 != nil:
    section.add "fields", valid_580759
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580760: Call_BooksLayersVolumeAnnotationsGet_580745;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the volume annotation.
  ## 
  let valid = call_580760.validator(path, query, header, formData, body)
  let scheme = call_580760.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580760.url(scheme.get, call_580760.host, call_580760.base,
                         call_580760.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580760, url, valid)

proc call*(call_580761: Call_BooksLayersVolumeAnnotationsGet_580745;
          annotationId: string; volumeId: string; layerId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; locale: string = "";
          source: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## booksLayersVolumeAnnotationsGet
  ## Gets the volume annotation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   locale: string
  ##         : The locale information for the data. ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   annotationId: string (required)
  ##               : The ID of the volume annotation to retrieve.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   volumeId: string (required)
  ##           : The volume to retrieve annotations for.
  ##   layerId: string (required)
  ##          : The ID for the layer to get the annotations.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580762 = newJObject()
  var query_580763 = newJObject()
  add(query_580763, "key", newJString(key))
  add(query_580763, "prettyPrint", newJBool(prettyPrint))
  add(query_580763, "oauth_token", newJString(oauthToken))
  add(query_580763, "locale", newJString(locale))
  add(query_580763, "source", newJString(source))
  add(path_580762, "annotationId", newJString(annotationId))
  add(query_580763, "alt", newJString(alt))
  add(query_580763, "userIp", newJString(userIp))
  add(query_580763, "quotaUser", newJString(quotaUser))
  add(path_580762, "volumeId", newJString(volumeId))
  add(path_580762, "layerId", newJString(layerId))
  add(query_580763, "fields", newJString(fields))
  result = call_580761.call(path_580762, query_580763, nil, nil, nil)

var booksLayersVolumeAnnotationsGet* = Call_BooksLayersVolumeAnnotationsGet_580745(
    name: "booksLayersVolumeAnnotationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/volumes/{volumeId}/layers/{layerId}/annotations/{annotationId}",
    validator: validate_BooksLayersVolumeAnnotationsGet_580746, base: "/books/v1",
    url: url_BooksLayersVolumeAnnotationsGet_580747, schemes: {Scheme.Https})
type
  Call_BooksLayersAnnotationDataList_580764 = ref object of OpenApiRestCall_579389
proc url_BooksLayersAnnotationDataList_580766(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BooksLayersAnnotationDataList_580765(path: JsonNode; query: JsonNode;
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
  var valid_580767 = path.getOrDefault("volumeId")
  valid_580767 = validateParameter(valid_580767, JString, required = true,
                                 default = nil)
  if valid_580767 != nil:
    section.add "volumeId", valid_580767
  var valid_580768 = path.getOrDefault("layerId")
  valid_580768 = validateParameter(valid_580768, JString, required = true,
                                 default = nil)
  if valid_580768 != nil:
    section.add "layerId", valid_580768
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   h: JInt
  ##    : The requested pixel height for any images. If height is provided width must also be provided.
  ##   locale: JString
  ##         : The locale information for the data. ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   contentVersion: JString (required)
  ##                 : The content version for the requested volume.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The value of the nextToken from the previous page.
  ##   scale: JInt
  ##        : The requested scale for the image.
  ##   updatedMax: JString
  ##             : RFC 3339 timestamp to restrict to items updated prior to this timestamp (exclusive).
  ##   annotationDataId: JArray
  ##                   : The list of Annotation Data Ids to retrieve. Pagination is ignored if this is set.
  ##   w: JInt
  ##    : The requested pixel width for any images. If width is provided height must also be provided.
  ##   updatedMin: JString
  ##             : RFC 3339 timestamp to restrict to items updated since this timestamp (inclusive).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of results to return
  section = newJObject()
  var valid_580769 = query.getOrDefault("key")
  valid_580769 = validateParameter(valid_580769, JString, required = false,
                                 default = nil)
  if valid_580769 != nil:
    section.add "key", valid_580769
  var valid_580770 = query.getOrDefault("prettyPrint")
  valid_580770 = validateParameter(valid_580770, JBool, required = false,
                                 default = newJBool(true))
  if valid_580770 != nil:
    section.add "prettyPrint", valid_580770
  var valid_580771 = query.getOrDefault("oauth_token")
  valid_580771 = validateParameter(valid_580771, JString, required = false,
                                 default = nil)
  if valid_580771 != nil:
    section.add "oauth_token", valid_580771
  var valid_580772 = query.getOrDefault("h")
  valid_580772 = validateParameter(valid_580772, JInt, required = false, default = nil)
  if valid_580772 != nil:
    section.add "h", valid_580772
  var valid_580773 = query.getOrDefault("locale")
  valid_580773 = validateParameter(valid_580773, JString, required = false,
                                 default = nil)
  if valid_580773 != nil:
    section.add "locale", valid_580773
  var valid_580774 = query.getOrDefault("source")
  valid_580774 = validateParameter(valid_580774, JString, required = false,
                                 default = nil)
  if valid_580774 != nil:
    section.add "source", valid_580774
  var valid_580775 = query.getOrDefault("alt")
  valid_580775 = validateParameter(valid_580775, JString, required = false,
                                 default = newJString("json"))
  if valid_580775 != nil:
    section.add "alt", valid_580775
  var valid_580776 = query.getOrDefault("userIp")
  valid_580776 = validateParameter(valid_580776, JString, required = false,
                                 default = nil)
  if valid_580776 != nil:
    section.add "userIp", valid_580776
  assert query != nil,
        "query argument is necessary due to required `contentVersion` field"
  var valid_580777 = query.getOrDefault("contentVersion")
  valid_580777 = validateParameter(valid_580777, JString, required = true,
                                 default = nil)
  if valid_580777 != nil:
    section.add "contentVersion", valid_580777
  var valid_580778 = query.getOrDefault("quotaUser")
  valid_580778 = validateParameter(valid_580778, JString, required = false,
                                 default = nil)
  if valid_580778 != nil:
    section.add "quotaUser", valid_580778
  var valid_580779 = query.getOrDefault("pageToken")
  valid_580779 = validateParameter(valid_580779, JString, required = false,
                                 default = nil)
  if valid_580779 != nil:
    section.add "pageToken", valid_580779
  var valid_580780 = query.getOrDefault("scale")
  valid_580780 = validateParameter(valid_580780, JInt, required = false, default = nil)
  if valid_580780 != nil:
    section.add "scale", valid_580780
  var valid_580781 = query.getOrDefault("updatedMax")
  valid_580781 = validateParameter(valid_580781, JString, required = false,
                                 default = nil)
  if valid_580781 != nil:
    section.add "updatedMax", valid_580781
  var valid_580782 = query.getOrDefault("annotationDataId")
  valid_580782 = validateParameter(valid_580782, JArray, required = false,
                                 default = nil)
  if valid_580782 != nil:
    section.add "annotationDataId", valid_580782
  var valid_580783 = query.getOrDefault("w")
  valid_580783 = validateParameter(valid_580783, JInt, required = false, default = nil)
  if valid_580783 != nil:
    section.add "w", valid_580783
  var valid_580784 = query.getOrDefault("updatedMin")
  valid_580784 = validateParameter(valid_580784, JString, required = false,
                                 default = nil)
  if valid_580784 != nil:
    section.add "updatedMin", valid_580784
  var valid_580785 = query.getOrDefault("fields")
  valid_580785 = validateParameter(valid_580785, JString, required = false,
                                 default = nil)
  if valid_580785 != nil:
    section.add "fields", valid_580785
  var valid_580786 = query.getOrDefault("maxResults")
  valid_580786 = validateParameter(valid_580786, JInt, required = false, default = nil)
  if valid_580786 != nil:
    section.add "maxResults", valid_580786
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580787: Call_BooksLayersAnnotationDataList_580764; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the annotation data for a volume and layer.
  ## 
  let valid = call_580787.validator(path, query, header, formData, body)
  let scheme = call_580787.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580787.url(scheme.get, call_580787.host, call_580787.base,
                         call_580787.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580787, url, valid)

proc call*(call_580788: Call_BooksLayersAnnotationDataList_580764;
          contentVersion: string; volumeId: string; layerId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; h: int = 0;
          locale: string = ""; source: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          scale: int = 0; updatedMax: string = ""; annotationDataId: JsonNode = nil;
          w: int = 0; updatedMin: string = ""; fields: string = ""; maxResults: int = 0): Recallable =
  ## booksLayersAnnotationDataList
  ## Gets the annotation data for a volume and layer.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   h: int
  ##    : The requested pixel height for any images. If height is provided width must also be provided.
  ##   locale: string
  ##         : The locale information for the data. ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   contentVersion: string (required)
  ##                 : The content version for the requested volume.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : The value of the nextToken from the previous page.
  ##   scale: int
  ##        : The requested scale for the image.
  ##   volumeId: string (required)
  ##           : The volume to retrieve annotation data for.
  ##   layerId: string (required)
  ##          : The ID for the layer to get the annotation data.
  ##   updatedMax: string
  ##             : RFC 3339 timestamp to restrict to items updated prior to this timestamp (exclusive).
  ##   annotationDataId: JArray
  ##                   : The list of Annotation Data Ids to retrieve. Pagination is ignored if this is set.
  ##   w: int
  ##    : The requested pixel width for any images. If width is provided height must also be provided.
  ##   updatedMin: string
  ##             : RFC 3339 timestamp to restrict to items updated since this timestamp (inclusive).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of results to return
  var path_580789 = newJObject()
  var query_580790 = newJObject()
  add(query_580790, "key", newJString(key))
  add(query_580790, "prettyPrint", newJBool(prettyPrint))
  add(query_580790, "oauth_token", newJString(oauthToken))
  add(query_580790, "h", newJInt(h))
  add(query_580790, "locale", newJString(locale))
  add(query_580790, "source", newJString(source))
  add(query_580790, "alt", newJString(alt))
  add(query_580790, "userIp", newJString(userIp))
  add(query_580790, "contentVersion", newJString(contentVersion))
  add(query_580790, "quotaUser", newJString(quotaUser))
  add(query_580790, "pageToken", newJString(pageToken))
  add(query_580790, "scale", newJInt(scale))
  add(path_580789, "volumeId", newJString(volumeId))
  add(path_580789, "layerId", newJString(layerId))
  add(query_580790, "updatedMax", newJString(updatedMax))
  if annotationDataId != nil:
    query_580790.add "annotationDataId", annotationDataId
  add(query_580790, "w", newJInt(w))
  add(query_580790, "updatedMin", newJString(updatedMin))
  add(query_580790, "fields", newJString(fields))
  add(query_580790, "maxResults", newJInt(maxResults))
  result = call_580788.call(path_580789, query_580790, nil, nil, nil)

var booksLayersAnnotationDataList* = Call_BooksLayersAnnotationDataList_580764(
    name: "booksLayersAnnotationDataList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/volumes/{volumeId}/layers/{layerId}/data",
    validator: validate_BooksLayersAnnotationDataList_580765, base: "/books/v1",
    url: url_BooksLayersAnnotationDataList_580766, schemes: {Scheme.Https})
type
  Call_BooksLayersAnnotationDataGet_580791 = ref object of OpenApiRestCall_579389
proc url_BooksLayersAnnotationDataGet_580793(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BooksLayersAnnotationDataGet_580792(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the annotation data.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   volumeId: JString (required)
  ##           : The volume to retrieve annotations for.
  ##   layerId: JString (required)
  ##          : The ID for the layer to get the annotations.
  ##   annotationDataId: JString (required)
  ##                   : The ID of the annotation data to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `volumeId` field"
  var valid_580794 = path.getOrDefault("volumeId")
  valid_580794 = validateParameter(valid_580794, JString, required = true,
                                 default = nil)
  if valid_580794 != nil:
    section.add "volumeId", valid_580794
  var valid_580795 = path.getOrDefault("layerId")
  valid_580795 = validateParameter(valid_580795, JString, required = true,
                                 default = nil)
  if valid_580795 != nil:
    section.add "layerId", valid_580795
  var valid_580796 = path.getOrDefault("annotationDataId")
  valid_580796 = validateParameter(valid_580796, JString, required = true,
                                 default = nil)
  if valid_580796 != nil:
    section.add "annotationDataId", valid_580796
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   h: JInt
  ##    : The requested pixel height for any images. If height is provided width must also be provided.
  ##   locale: JString
  ##         : The locale information for the data. ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   contentVersion: JString (required)
  ##                 : The content version for the volume you are trying to retrieve.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   scale: JInt
  ##        : The requested scale for the image.
  ##   allowWebDefinitions: JBool
  ##                      : For the dictionary layer. Whether or not to allow web definitions.
  ##   w: JInt
  ##    : The requested pixel width for any images. If width is provided height must also be provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580797 = query.getOrDefault("key")
  valid_580797 = validateParameter(valid_580797, JString, required = false,
                                 default = nil)
  if valid_580797 != nil:
    section.add "key", valid_580797
  var valid_580798 = query.getOrDefault("prettyPrint")
  valid_580798 = validateParameter(valid_580798, JBool, required = false,
                                 default = newJBool(true))
  if valid_580798 != nil:
    section.add "prettyPrint", valid_580798
  var valid_580799 = query.getOrDefault("oauth_token")
  valid_580799 = validateParameter(valid_580799, JString, required = false,
                                 default = nil)
  if valid_580799 != nil:
    section.add "oauth_token", valid_580799
  var valid_580800 = query.getOrDefault("h")
  valid_580800 = validateParameter(valid_580800, JInt, required = false, default = nil)
  if valid_580800 != nil:
    section.add "h", valid_580800
  var valid_580801 = query.getOrDefault("locale")
  valid_580801 = validateParameter(valid_580801, JString, required = false,
                                 default = nil)
  if valid_580801 != nil:
    section.add "locale", valid_580801
  var valid_580802 = query.getOrDefault("source")
  valid_580802 = validateParameter(valid_580802, JString, required = false,
                                 default = nil)
  if valid_580802 != nil:
    section.add "source", valid_580802
  var valid_580803 = query.getOrDefault("alt")
  valid_580803 = validateParameter(valid_580803, JString, required = false,
                                 default = newJString("json"))
  if valid_580803 != nil:
    section.add "alt", valid_580803
  var valid_580804 = query.getOrDefault("userIp")
  valid_580804 = validateParameter(valid_580804, JString, required = false,
                                 default = nil)
  if valid_580804 != nil:
    section.add "userIp", valid_580804
  assert query != nil,
        "query argument is necessary due to required `contentVersion` field"
  var valid_580805 = query.getOrDefault("contentVersion")
  valid_580805 = validateParameter(valid_580805, JString, required = true,
                                 default = nil)
  if valid_580805 != nil:
    section.add "contentVersion", valid_580805
  var valid_580806 = query.getOrDefault("quotaUser")
  valid_580806 = validateParameter(valid_580806, JString, required = false,
                                 default = nil)
  if valid_580806 != nil:
    section.add "quotaUser", valid_580806
  var valid_580807 = query.getOrDefault("scale")
  valid_580807 = validateParameter(valid_580807, JInt, required = false, default = nil)
  if valid_580807 != nil:
    section.add "scale", valid_580807
  var valid_580808 = query.getOrDefault("allowWebDefinitions")
  valid_580808 = validateParameter(valid_580808, JBool, required = false, default = nil)
  if valid_580808 != nil:
    section.add "allowWebDefinitions", valid_580808
  var valid_580809 = query.getOrDefault("w")
  valid_580809 = validateParameter(valid_580809, JInt, required = false, default = nil)
  if valid_580809 != nil:
    section.add "w", valid_580809
  var valid_580810 = query.getOrDefault("fields")
  valid_580810 = validateParameter(valid_580810, JString, required = false,
                                 default = nil)
  if valid_580810 != nil:
    section.add "fields", valid_580810
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580811: Call_BooksLayersAnnotationDataGet_580791; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the annotation data.
  ## 
  let valid = call_580811.validator(path, query, header, formData, body)
  let scheme = call_580811.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580811.url(scheme.get, call_580811.host, call_580811.base,
                         call_580811.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580811, url, valid)

proc call*(call_580812: Call_BooksLayersAnnotationDataGet_580791;
          contentVersion: string; volumeId: string; layerId: string;
          annotationDataId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; h: int = 0; locale: string = ""; source: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = ""; scale: int = 0;
          allowWebDefinitions: bool = false; w: int = 0; fields: string = ""): Recallable =
  ## booksLayersAnnotationDataGet
  ## Gets the annotation data.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   h: int
  ##    : The requested pixel height for any images. If height is provided width must also be provided.
  ##   locale: string
  ##         : The locale information for the data. ISO-639-1 language and ISO-3166-1 country code. Ex: 'en_US'.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   contentVersion: string (required)
  ##                 : The content version for the volume you are trying to retrieve.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   scale: int
  ##        : The requested scale for the image.
  ##   allowWebDefinitions: bool
  ##                      : For the dictionary layer. Whether or not to allow web definitions.
  ##   volumeId: string (required)
  ##           : The volume to retrieve annotations for.
  ##   layerId: string (required)
  ##          : The ID for the layer to get the annotations.
  ##   annotationDataId: string (required)
  ##                   : The ID of the annotation data to retrieve.
  ##   w: int
  ##    : The requested pixel width for any images. If width is provided height must also be provided.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580813 = newJObject()
  var query_580814 = newJObject()
  add(query_580814, "key", newJString(key))
  add(query_580814, "prettyPrint", newJBool(prettyPrint))
  add(query_580814, "oauth_token", newJString(oauthToken))
  add(query_580814, "h", newJInt(h))
  add(query_580814, "locale", newJString(locale))
  add(query_580814, "source", newJString(source))
  add(query_580814, "alt", newJString(alt))
  add(query_580814, "userIp", newJString(userIp))
  add(query_580814, "contentVersion", newJString(contentVersion))
  add(query_580814, "quotaUser", newJString(quotaUser))
  add(query_580814, "scale", newJInt(scale))
  add(query_580814, "allowWebDefinitions", newJBool(allowWebDefinitions))
  add(path_580813, "volumeId", newJString(volumeId))
  add(path_580813, "layerId", newJString(layerId))
  add(path_580813, "annotationDataId", newJString(annotationDataId))
  add(query_580814, "w", newJInt(w))
  add(query_580814, "fields", newJString(fields))
  result = call_580812.call(path_580813, query_580814, nil, nil, nil)

var booksLayersAnnotationDataGet* = Call_BooksLayersAnnotationDataGet_580791(
    name: "booksLayersAnnotationDataGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/volumes/{volumeId}/layers/{layerId}/data/{annotationDataId}",
    validator: validate_BooksLayersAnnotationDataGet_580792, base: "/books/v1",
    url: url_BooksLayersAnnotationDataGet_580793, schemes: {Scheme.Https})
type
  Call_BooksLayersList_580815 = ref object of OpenApiRestCall_579389
proc url_BooksLayersList_580817(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BooksLayersList_580816(path: JsonNode; query: JsonNode;
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
  var valid_580818 = path.getOrDefault("volumeId")
  valid_580818 = validateParameter(valid_580818, JString, required = true,
                                 default = nil)
  if valid_580818 != nil:
    section.add "volumeId", valid_580818
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   contentVersion: JString
  ##                 : The content version for the requested volume.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The value of the nextToken from the previous page.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of results to return
  section = newJObject()
  var valid_580819 = query.getOrDefault("key")
  valid_580819 = validateParameter(valid_580819, JString, required = false,
                                 default = nil)
  if valid_580819 != nil:
    section.add "key", valid_580819
  var valid_580820 = query.getOrDefault("prettyPrint")
  valid_580820 = validateParameter(valid_580820, JBool, required = false,
                                 default = newJBool(true))
  if valid_580820 != nil:
    section.add "prettyPrint", valid_580820
  var valid_580821 = query.getOrDefault("oauth_token")
  valid_580821 = validateParameter(valid_580821, JString, required = false,
                                 default = nil)
  if valid_580821 != nil:
    section.add "oauth_token", valid_580821
  var valid_580822 = query.getOrDefault("source")
  valid_580822 = validateParameter(valid_580822, JString, required = false,
                                 default = nil)
  if valid_580822 != nil:
    section.add "source", valid_580822
  var valid_580823 = query.getOrDefault("alt")
  valid_580823 = validateParameter(valid_580823, JString, required = false,
                                 default = newJString("json"))
  if valid_580823 != nil:
    section.add "alt", valid_580823
  var valid_580824 = query.getOrDefault("userIp")
  valid_580824 = validateParameter(valid_580824, JString, required = false,
                                 default = nil)
  if valid_580824 != nil:
    section.add "userIp", valid_580824
  var valid_580825 = query.getOrDefault("contentVersion")
  valid_580825 = validateParameter(valid_580825, JString, required = false,
                                 default = nil)
  if valid_580825 != nil:
    section.add "contentVersion", valid_580825
  var valid_580826 = query.getOrDefault("quotaUser")
  valid_580826 = validateParameter(valid_580826, JString, required = false,
                                 default = nil)
  if valid_580826 != nil:
    section.add "quotaUser", valid_580826
  var valid_580827 = query.getOrDefault("pageToken")
  valid_580827 = validateParameter(valid_580827, JString, required = false,
                                 default = nil)
  if valid_580827 != nil:
    section.add "pageToken", valid_580827
  var valid_580828 = query.getOrDefault("fields")
  valid_580828 = validateParameter(valid_580828, JString, required = false,
                                 default = nil)
  if valid_580828 != nil:
    section.add "fields", valid_580828
  var valid_580829 = query.getOrDefault("maxResults")
  valid_580829 = validateParameter(valid_580829, JInt, required = false, default = nil)
  if valid_580829 != nil:
    section.add "maxResults", valid_580829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580830: Call_BooksLayersList_580815; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the layer summaries for a volume.
  ## 
  let valid = call_580830.validator(path, query, header, formData, body)
  let scheme = call_580830.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580830.url(scheme.get, call_580830.host, call_580830.base,
                         call_580830.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580830, url, valid)

proc call*(call_580831: Call_BooksLayersList_580815; volumeId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          source: string = ""; alt: string = "json"; userIp: string = "";
          contentVersion: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 0): Recallable =
  ## booksLayersList
  ## List the layer summaries for a volume.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   contentVersion: string
  ##                 : The content version for the requested volume.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : The value of the nextToken from the previous page.
  ##   volumeId: string (required)
  ##           : The volume to retrieve layers for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of results to return
  var path_580832 = newJObject()
  var query_580833 = newJObject()
  add(query_580833, "key", newJString(key))
  add(query_580833, "prettyPrint", newJBool(prettyPrint))
  add(query_580833, "oauth_token", newJString(oauthToken))
  add(query_580833, "source", newJString(source))
  add(query_580833, "alt", newJString(alt))
  add(query_580833, "userIp", newJString(userIp))
  add(query_580833, "contentVersion", newJString(contentVersion))
  add(query_580833, "quotaUser", newJString(quotaUser))
  add(query_580833, "pageToken", newJString(pageToken))
  add(path_580832, "volumeId", newJString(volumeId))
  add(query_580833, "fields", newJString(fields))
  add(query_580833, "maxResults", newJInt(maxResults))
  result = call_580831.call(path_580832, query_580833, nil, nil, nil)

var booksLayersList* = Call_BooksLayersList_580815(name: "booksLayersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/volumes/{volumeId}/layersummary",
    validator: validate_BooksLayersList_580816, base: "/books/v1",
    url: url_BooksLayersList_580817, schemes: {Scheme.Https})
type
  Call_BooksLayersGet_580834 = ref object of OpenApiRestCall_579389
proc url_BooksLayersGet_580836(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BooksLayersGet_580835(path: JsonNode; query: JsonNode;
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
  var valid_580837 = path.getOrDefault("volumeId")
  valid_580837 = validateParameter(valid_580837, JString, required = true,
                                 default = nil)
  if valid_580837 != nil:
    section.add "volumeId", valid_580837
  var valid_580838 = path.getOrDefault("summaryId")
  valid_580838 = validateParameter(valid_580838, JString, required = true,
                                 default = nil)
  if valid_580838 != nil:
    section.add "summaryId", valid_580838
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   source: JString
  ##         : String to identify the originator of this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   contentVersion: JString
  ##                 : The content version for the requested volume.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580839 = query.getOrDefault("key")
  valid_580839 = validateParameter(valid_580839, JString, required = false,
                                 default = nil)
  if valid_580839 != nil:
    section.add "key", valid_580839
  var valid_580840 = query.getOrDefault("prettyPrint")
  valid_580840 = validateParameter(valid_580840, JBool, required = false,
                                 default = newJBool(true))
  if valid_580840 != nil:
    section.add "prettyPrint", valid_580840
  var valid_580841 = query.getOrDefault("oauth_token")
  valid_580841 = validateParameter(valid_580841, JString, required = false,
                                 default = nil)
  if valid_580841 != nil:
    section.add "oauth_token", valid_580841
  var valid_580842 = query.getOrDefault("source")
  valid_580842 = validateParameter(valid_580842, JString, required = false,
                                 default = nil)
  if valid_580842 != nil:
    section.add "source", valid_580842
  var valid_580843 = query.getOrDefault("alt")
  valid_580843 = validateParameter(valid_580843, JString, required = false,
                                 default = newJString("json"))
  if valid_580843 != nil:
    section.add "alt", valid_580843
  var valid_580844 = query.getOrDefault("userIp")
  valid_580844 = validateParameter(valid_580844, JString, required = false,
                                 default = nil)
  if valid_580844 != nil:
    section.add "userIp", valid_580844
  var valid_580845 = query.getOrDefault("contentVersion")
  valid_580845 = validateParameter(valid_580845, JString, required = false,
                                 default = nil)
  if valid_580845 != nil:
    section.add "contentVersion", valid_580845
  var valid_580846 = query.getOrDefault("quotaUser")
  valid_580846 = validateParameter(valid_580846, JString, required = false,
                                 default = nil)
  if valid_580846 != nil:
    section.add "quotaUser", valid_580846
  var valid_580847 = query.getOrDefault("fields")
  valid_580847 = validateParameter(valid_580847, JString, required = false,
                                 default = nil)
  if valid_580847 != nil:
    section.add "fields", valid_580847
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580848: Call_BooksLayersGet_580834; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the layer summary for a volume.
  ## 
  let valid = call_580848.validator(path, query, header, formData, body)
  let scheme = call_580848.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580848.url(scheme.get, call_580848.host, call_580848.base,
                         call_580848.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580848, url, valid)

proc call*(call_580849: Call_BooksLayersGet_580834; volumeId: string;
          summaryId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; source: string = ""; alt: string = "json";
          userIp: string = ""; contentVersion: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## booksLayersGet
  ## Gets the layer summary for a volume.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   source: string
  ##         : String to identify the originator of this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   contentVersion: string
  ##                 : The content version for the requested volume.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   volumeId: string (required)
  ##           : The volume to retrieve layers for.
  ##   summaryId: string (required)
  ##            : The ID for the layer to get the summary for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580850 = newJObject()
  var query_580851 = newJObject()
  add(query_580851, "key", newJString(key))
  add(query_580851, "prettyPrint", newJBool(prettyPrint))
  add(query_580851, "oauth_token", newJString(oauthToken))
  add(query_580851, "source", newJString(source))
  add(query_580851, "alt", newJString(alt))
  add(query_580851, "userIp", newJString(userIp))
  add(query_580851, "contentVersion", newJString(contentVersion))
  add(query_580851, "quotaUser", newJString(quotaUser))
  add(path_580850, "volumeId", newJString(volumeId))
  add(path_580850, "summaryId", newJString(summaryId))
  add(query_580851, "fields", newJString(fields))
  result = call_580849.call(path_580850, query_580851, nil, nil, nil)

var booksLayersGet* = Call_BooksLayersGet_580834(name: "booksLayersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/volumes/{volumeId}/layersummary/{summaryId}",
    validator: validate_BooksLayersGet_580835, base: "/books/v1",
    url: url_BooksLayersGet_580836, schemes: {Scheme.Https})
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
