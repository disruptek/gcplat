
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

  OpenApiRestCall_579437 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579437](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579437): Option[Scheme] {.used.} =
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
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BooksCloudloadingAddBook_579705 = ref object of OpenApiRestCall_579437
proc url_BooksCloudloadingAddBook_579707(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksCloudloadingAddBook_579706(path: JsonNode; query: JsonNode;
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
  var valid_579819 = query.getOrDefault("fields")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = nil)
  if valid_579819 != nil:
    section.add "fields", valid_579819
  var valid_579820 = query.getOrDefault("quotaUser")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "quotaUser", valid_579820
  var valid_579834 = query.getOrDefault("alt")
  valid_579834 = validateParameter(valid_579834, JString, required = false,
                                 default = newJString("json"))
  if valid_579834 != nil:
    section.add "alt", valid_579834
  var valid_579835 = query.getOrDefault("mime_type")
  valid_579835 = validateParameter(valid_579835, JString, required = false,
                                 default = nil)
  if valid_579835 != nil:
    section.add "mime_type", valid_579835
  var valid_579836 = query.getOrDefault("oauth_token")
  valid_579836 = validateParameter(valid_579836, JString, required = false,
                                 default = nil)
  if valid_579836 != nil:
    section.add "oauth_token", valid_579836
  var valid_579837 = query.getOrDefault("userIp")
  valid_579837 = validateParameter(valid_579837, JString, required = false,
                                 default = nil)
  if valid_579837 != nil:
    section.add "userIp", valid_579837
  var valid_579838 = query.getOrDefault("drive_document_id")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = nil)
  if valid_579838 != nil:
    section.add "drive_document_id", valid_579838
  var valid_579839 = query.getOrDefault("key")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "key", valid_579839
  var valid_579840 = query.getOrDefault("name")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "name", valid_579840
  var valid_579841 = query.getOrDefault("prettyPrint")
  valid_579841 = validateParameter(valid_579841, JBool, required = false,
                                 default = newJBool(true))
  if valid_579841 != nil:
    section.add "prettyPrint", valid_579841
  var valid_579842 = query.getOrDefault("upload_client_token")
  valid_579842 = validateParameter(valid_579842, JString, required = false,
                                 default = nil)
  if valid_579842 != nil:
    section.add "upload_client_token", valid_579842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579865: Call_BooksCloudloadingAddBook_579705; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_579865.validator(path, query, header, formData, body)
  let scheme = call_579865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579865.url(scheme.get, call_579865.host, call_579865.base,
                         call_579865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579865, url, valid)

proc call*(call_579936: Call_BooksCloudloadingAddBook_579705; fields: string = "";
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
  var query_579937 = newJObject()
  add(query_579937, "fields", newJString(fields))
  add(query_579937, "quotaUser", newJString(quotaUser))
  add(query_579937, "alt", newJString(alt))
  add(query_579937, "mime_type", newJString(mimeType))
  add(query_579937, "oauth_token", newJString(oauthToken))
  add(query_579937, "userIp", newJString(userIp))
  add(query_579937, "drive_document_id", newJString(driveDocumentId))
  add(query_579937, "key", newJString(key))
  add(query_579937, "name", newJString(name))
  add(query_579937, "prettyPrint", newJBool(prettyPrint))
  add(query_579937, "upload_client_token", newJString(uploadClientToken))
  result = call_579936.call(nil, query_579937, nil, nil, nil)

var booksCloudloadingAddBook* = Call_BooksCloudloadingAddBook_579705(
    name: "booksCloudloadingAddBook", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/cloudloading/addBook",
    validator: validate_BooksCloudloadingAddBook_579706, base: "/books/v1",
    url: url_BooksCloudloadingAddBook_579707, schemes: {Scheme.Https})
type
  Call_BooksCloudloadingDeleteBook_579977 = ref object of OpenApiRestCall_579437
proc url_BooksCloudloadingDeleteBook_579979(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksCloudloadingDeleteBook_579978(path: JsonNode; query: JsonNode;
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
  var valid_579980 = query.getOrDefault("fields")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "fields", valid_579980
  var valid_579981 = query.getOrDefault("quotaUser")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "quotaUser", valid_579981
  var valid_579982 = query.getOrDefault("alt")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = newJString("json"))
  if valid_579982 != nil:
    section.add "alt", valid_579982
  var valid_579983 = query.getOrDefault("oauth_token")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "oauth_token", valid_579983
  var valid_579984 = query.getOrDefault("userIp")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "userIp", valid_579984
  var valid_579985 = query.getOrDefault("key")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "key", valid_579985
  assert query != nil,
        "query argument is necessary due to required `volumeId` field"
  var valid_579986 = query.getOrDefault("volumeId")
  valid_579986 = validateParameter(valid_579986, JString, required = true,
                                 default = nil)
  if valid_579986 != nil:
    section.add "volumeId", valid_579986
  var valid_579987 = query.getOrDefault("prettyPrint")
  valid_579987 = validateParameter(valid_579987, JBool, required = false,
                                 default = newJBool(true))
  if valid_579987 != nil:
    section.add "prettyPrint", valid_579987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579988: Call_BooksCloudloadingDeleteBook_579977; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove the book and its contents
  ## 
  let valid = call_579988.validator(path, query, header, formData, body)
  let scheme = call_579988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579988.url(scheme.get, call_579988.host, call_579988.base,
                         call_579988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579988, url, valid)

proc call*(call_579989: Call_BooksCloudloadingDeleteBook_579977; volumeId: string;
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
  var query_579990 = newJObject()
  add(query_579990, "fields", newJString(fields))
  add(query_579990, "quotaUser", newJString(quotaUser))
  add(query_579990, "alt", newJString(alt))
  add(query_579990, "oauth_token", newJString(oauthToken))
  add(query_579990, "userIp", newJString(userIp))
  add(query_579990, "key", newJString(key))
  add(query_579990, "volumeId", newJString(volumeId))
  add(query_579990, "prettyPrint", newJBool(prettyPrint))
  result = call_579989.call(nil, query_579990, nil, nil, nil)

var booksCloudloadingDeleteBook* = Call_BooksCloudloadingDeleteBook_579977(
    name: "booksCloudloadingDeleteBook", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/cloudloading/deleteBook",
    validator: validate_BooksCloudloadingDeleteBook_579978, base: "/books/v1",
    url: url_BooksCloudloadingDeleteBook_579979, schemes: {Scheme.Https})
type
  Call_BooksCloudloadingUpdateBook_579991 = ref object of OpenApiRestCall_579437
proc url_BooksCloudloadingUpdateBook_579993(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksCloudloadingUpdateBook_579992(path: JsonNode; query: JsonNode;
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
  var valid_579994 = query.getOrDefault("fields")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "fields", valid_579994
  var valid_579995 = query.getOrDefault("quotaUser")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "quotaUser", valid_579995
  var valid_579996 = query.getOrDefault("alt")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = newJString("json"))
  if valid_579996 != nil:
    section.add "alt", valid_579996
  var valid_579997 = query.getOrDefault("oauth_token")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "oauth_token", valid_579997
  var valid_579998 = query.getOrDefault("userIp")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "userIp", valid_579998
  var valid_579999 = query.getOrDefault("key")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "key", valid_579999
  var valid_580000 = query.getOrDefault("prettyPrint")
  valid_580000 = validateParameter(valid_580000, JBool, required = false,
                                 default = newJBool(true))
  if valid_580000 != nil:
    section.add "prettyPrint", valid_580000
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

proc call*(call_580002: Call_BooksCloudloadingUpdateBook_579991; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_580002.validator(path, query, header, formData, body)
  let scheme = call_580002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580002.url(scheme.get, call_580002.host, call_580002.base,
                         call_580002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580002, url, valid)

proc call*(call_580003: Call_BooksCloudloadingUpdateBook_579991;
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
  var query_580004 = newJObject()
  var body_580005 = newJObject()
  add(query_580004, "fields", newJString(fields))
  add(query_580004, "quotaUser", newJString(quotaUser))
  add(query_580004, "alt", newJString(alt))
  add(query_580004, "oauth_token", newJString(oauthToken))
  add(query_580004, "userIp", newJString(userIp))
  add(query_580004, "key", newJString(key))
  if body != nil:
    body_580005 = body
  add(query_580004, "prettyPrint", newJBool(prettyPrint))
  result = call_580003.call(nil, query_580004, nil, nil, body_580005)

var booksCloudloadingUpdateBook* = Call_BooksCloudloadingUpdateBook_579991(
    name: "booksCloudloadingUpdateBook", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/cloudloading/updateBook",
    validator: validate_BooksCloudloadingUpdateBook_579992, base: "/books/v1",
    url: url_BooksCloudloadingUpdateBook_579993, schemes: {Scheme.Https})
type
  Call_BooksDictionaryListOfflineMetadata_580006 = ref object of OpenApiRestCall_579437
proc url_BooksDictionaryListOfflineMetadata_580008(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksDictionaryListOfflineMetadata_580007(path: JsonNode;
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
  var valid_580009 = query.getOrDefault("fields")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "fields", valid_580009
  var valid_580010 = query.getOrDefault("quotaUser")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "quotaUser", valid_580010
  var valid_580011 = query.getOrDefault("alt")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = newJString("json"))
  if valid_580011 != nil:
    section.add "alt", valid_580011
  var valid_580012 = query.getOrDefault("oauth_token")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "oauth_token", valid_580012
  assert query != nil, "query argument is necessary due to required `cpksver` field"
  var valid_580013 = query.getOrDefault("cpksver")
  valid_580013 = validateParameter(valid_580013, JString, required = true,
                                 default = nil)
  if valid_580013 != nil:
    section.add "cpksver", valid_580013
  var valid_580014 = query.getOrDefault("userIp")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "userIp", valid_580014
  var valid_580015 = query.getOrDefault("key")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "key", valid_580015
  var valid_580016 = query.getOrDefault("prettyPrint")
  valid_580016 = validateParameter(valid_580016, JBool, required = false,
                                 default = newJBool(true))
  if valid_580016 != nil:
    section.add "prettyPrint", valid_580016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580017: Call_BooksDictionaryListOfflineMetadata_580006;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of offline dictionary metadata available
  ## 
  let valid = call_580017.validator(path, query, header, formData, body)
  let scheme = call_580017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580017.url(scheme.get, call_580017.host, call_580017.base,
                         call_580017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580017, url, valid)

proc call*(call_580018: Call_BooksDictionaryListOfflineMetadata_580006;
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
  var query_580019 = newJObject()
  add(query_580019, "fields", newJString(fields))
  add(query_580019, "quotaUser", newJString(quotaUser))
  add(query_580019, "alt", newJString(alt))
  add(query_580019, "oauth_token", newJString(oauthToken))
  add(query_580019, "cpksver", newJString(cpksver))
  add(query_580019, "userIp", newJString(userIp))
  add(query_580019, "key", newJString(key))
  add(query_580019, "prettyPrint", newJBool(prettyPrint))
  result = call_580018.call(nil, query_580019, nil, nil, nil)

var booksDictionaryListOfflineMetadata* = Call_BooksDictionaryListOfflineMetadata_580006(
    name: "booksDictionaryListOfflineMetadata", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/dictionary/listOfflineMetadata",
    validator: validate_BooksDictionaryListOfflineMetadata_580007,
    base: "/books/v1", url: url_BooksDictionaryListOfflineMetadata_580008,
    schemes: {Scheme.Https})
type
  Call_BooksFamilysharingGetFamilyInfo_580020 = ref object of OpenApiRestCall_579437
proc url_BooksFamilysharingGetFamilyInfo_580022(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksFamilysharingGetFamilyInfo_580021(path: JsonNode;
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
  var valid_580023 = query.getOrDefault("fields")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "fields", valid_580023
  var valid_580024 = query.getOrDefault("quotaUser")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "quotaUser", valid_580024
  var valid_580025 = query.getOrDefault("alt")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = newJString("json"))
  if valid_580025 != nil:
    section.add "alt", valid_580025
  var valid_580026 = query.getOrDefault("oauth_token")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "oauth_token", valid_580026
  var valid_580027 = query.getOrDefault("userIp")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "userIp", valid_580027
  var valid_580028 = query.getOrDefault("source")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "source", valid_580028
  var valid_580029 = query.getOrDefault("key")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "key", valid_580029
  var valid_580030 = query.getOrDefault("prettyPrint")
  valid_580030 = validateParameter(valid_580030, JBool, required = false,
                                 default = newJBool(true))
  if valid_580030 != nil:
    section.add "prettyPrint", valid_580030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580031: Call_BooksFamilysharingGetFamilyInfo_580020;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information regarding the family that the user is part of.
  ## 
  let valid = call_580031.validator(path, query, header, formData, body)
  let scheme = call_580031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580031.url(scheme.get, call_580031.host, call_580031.base,
                         call_580031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580031, url, valid)

proc call*(call_580032: Call_BooksFamilysharingGetFamilyInfo_580020;
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
  var query_580033 = newJObject()
  add(query_580033, "fields", newJString(fields))
  add(query_580033, "quotaUser", newJString(quotaUser))
  add(query_580033, "alt", newJString(alt))
  add(query_580033, "oauth_token", newJString(oauthToken))
  add(query_580033, "userIp", newJString(userIp))
  add(query_580033, "source", newJString(source))
  add(query_580033, "key", newJString(key))
  add(query_580033, "prettyPrint", newJBool(prettyPrint))
  result = call_580032.call(nil, query_580033, nil, nil, nil)

var booksFamilysharingGetFamilyInfo* = Call_BooksFamilysharingGetFamilyInfo_580020(
    name: "booksFamilysharingGetFamilyInfo", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/familysharing/getFamilyInfo",
    validator: validate_BooksFamilysharingGetFamilyInfo_580021, base: "/books/v1",
    url: url_BooksFamilysharingGetFamilyInfo_580022, schemes: {Scheme.Https})
type
  Call_BooksFamilysharingShare_580034 = ref object of OpenApiRestCall_579437
proc url_BooksFamilysharingShare_580036(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksFamilysharingShare_580035(path: JsonNode; query: JsonNode;
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
  var valid_580037 = query.getOrDefault("fields")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "fields", valid_580037
  var valid_580038 = query.getOrDefault("quotaUser")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "quotaUser", valid_580038
  var valid_580039 = query.getOrDefault("alt")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = newJString("json"))
  if valid_580039 != nil:
    section.add "alt", valid_580039
  var valid_580040 = query.getOrDefault("oauth_token")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "oauth_token", valid_580040
  var valid_580041 = query.getOrDefault("userIp")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "userIp", valid_580041
  var valid_580042 = query.getOrDefault("source")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "source", valid_580042
  var valid_580043 = query.getOrDefault("key")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "key", valid_580043
  var valid_580044 = query.getOrDefault("docId")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "docId", valid_580044
  var valid_580045 = query.getOrDefault("volumeId")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "volumeId", valid_580045
  var valid_580046 = query.getOrDefault("prettyPrint")
  valid_580046 = validateParameter(valid_580046, JBool, required = false,
                                 default = newJBool(true))
  if valid_580046 != nil:
    section.add "prettyPrint", valid_580046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580047: Call_BooksFamilysharingShare_580034; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Initiates sharing of the content with the user's family. Empty response indicates success.
  ## 
  let valid = call_580047.validator(path, query, header, formData, body)
  let scheme = call_580047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580047.url(scheme.get, call_580047.host, call_580047.base,
                         call_580047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580047, url, valid)

proc call*(call_580048: Call_BooksFamilysharingShare_580034; fields: string = "";
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
  var query_580049 = newJObject()
  add(query_580049, "fields", newJString(fields))
  add(query_580049, "quotaUser", newJString(quotaUser))
  add(query_580049, "alt", newJString(alt))
  add(query_580049, "oauth_token", newJString(oauthToken))
  add(query_580049, "userIp", newJString(userIp))
  add(query_580049, "source", newJString(source))
  add(query_580049, "key", newJString(key))
  add(query_580049, "docId", newJString(docId))
  add(query_580049, "volumeId", newJString(volumeId))
  add(query_580049, "prettyPrint", newJBool(prettyPrint))
  result = call_580048.call(nil, query_580049, nil, nil, nil)

var booksFamilysharingShare* = Call_BooksFamilysharingShare_580034(
    name: "booksFamilysharingShare", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/familysharing/share",
    validator: validate_BooksFamilysharingShare_580035, base: "/books/v1",
    url: url_BooksFamilysharingShare_580036, schemes: {Scheme.Https})
type
  Call_BooksFamilysharingUnshare_580050 = ref object of OpenApiRestCall_579437
proc url_BooksFamilysharingUnshare_580052(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksFamilysharingUnshare_580051(path: JsonNode; query: JsonNode;
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
  var valid_580053 = query.getOrDefault("fields")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "fields", valid_580053
  var valid_580054 = query.getOrDefault("quotaUser")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "quotaUser", valid_580054
  var valid_580055 = query.getOrDefault("alt")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = newJString("json"))
  if valid_580055 != nil:
    section.add "alt", valid_580055
  var valid_580056 = query.getOrDefault("oauth_token")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "oauth_token", valid_580056
  var valid_580057 = query.getOrDefault("userIp")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "userIp", valid_580057
  var valid_580058 = query.getOrDefault("source")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "source", valid_580058
  var valid_580059 = query.getOrDefault("key")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "key", valid_580059
  var valid_580060 = query.getOrDefault("docId")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "docId", valid_580060
  var valid_580061 = query.getOrDefault("volumeId")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "volumeId", valid_580061
  var valid_580062 = query.getOrDefault("prettyPrint")
  valid_580062 = validateParameter(valid_580062, JBool, required = false,
                                 default = newJBool(true))
  if valid_580062 != nil:
    section.add "prettyPrint", valid_580062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580063: Call_BooksFamilysharingUnshare_580050; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Initiates revoking content that has already been shared with the user's family. Empty response indicates success.
  ## 
  let valid = call_580063.validator(path, query, header, formData, body)
  let scheme = call_580063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580063.url(scheme.get, call_580063.host, call_580063.base,
                         call_580063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580063, url, valid)

proc call*(call_580064: Call_BooksFamilysharingUnshare_580050; fields: string = "";
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
  var query_580065 = newJObject()
  add(query_580065, "fields", newJString(fields))
  add(query_580065, "quotaUser", newJString(quotaUser))
  add(query_580065, "alt", newJString(alt))
  add(query_580065, "oauth_token", newJString(oauthToken))
  add(query_580065, "userIp", newJString(userIp))
  add(query_580065, "source", newJString(source))
  add(query_580065, "key", newJString(key))
  add(query_580065, "docId", newJString(docId))
  add(query_580065, "volumeId", newJString(volumeId))
  add(query_580065, "prettyPrint", newJBool(prettyPrint))
  result = call_580064.call(nil, query_580065, nil, nil, nil)

var booksFamilysharingUnshare* = Call_BooksFamilysharingUnshare_580050(
    name: "booksFamilysharingUnshare", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/familysharing/unshare",
    validator: validate_BooksFamilysharingUnshare_580051, base: "/books/v1",
    url: url_BooksFamilysharingUnshare_580052, schemes: {Scheme.Https})
type
  Call_BooksMyconfigGetUserSettings_580066 = ref object of OpenApiRestCall_579437
proc url_BooksMyconfigGetUserSettings_580068(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksMyconfigGetUserSettings_580067(path: JsonNode; query: JsonNode;
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
  var valid_580069 = query.getOrDefault("fields")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "fields", valid_580069
  var valid_580070 = query.getOrDefault("quotaUser")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "quotaUser", valid_580070
  var valid_580071 = query.getOrDefault("alt")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = newJString("json"))
  if valid_580071 != nil:
    section.add "alt", valid_580071
  var valid_580072 = query.getOrDefault("oauth_token")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "oauth_token", valid_580072
  var valid_580073 = query.getOrDefault("userIp")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "userIp", valid_580073
  var valid_580074 = query.getOrDefault("key")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "key", valid_580074
  var valid_580075 = query.getOrDefault("prettyPrint")
  valid_580075 = validateParameter(valid_580075, JBool, required = false,
                                 default = newJBool(true))
  if valid_580075 != nil:
    section.add "prettyPrint", valid_580075
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580076: Call_BooksMyconfigGetUserSettings_580066; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current settings for the user.
  ## 
  let valid = call_580076.validator(path, query, header, formData, body)
  let scheme = call_580076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580076.url(scheme.get, call_580076.host, call_580076.base,
                         call_580076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580076, url, valid)

proc call*(call_580077: Call_BooksMyconfigGetUserSettings_580066;
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
  var query_580078 = newJObject()
  add(query_580078, "fields", newJString(fields))
  add(query_580078, "quotaUser", newJString(quotaUser))
  add(query_580078, "alt", newJString(alt))
  add(query_580078, "oauth_token", newJString(oauthToken))
  add(query_580078, "userIp", newJString(userIp))
  add(query_580078, "key", newJString(key))
  add(query_580078, "prettyPrint", newJBool(prettyPrint))
  result = call_580077.call(nil, query_580078, nil, nil, nil)

var booksMyconfigGetUserSettings* = Call_BooksMyconfigGetUserSettings_580066(
    name: "booksMyconfigGetUserSettings", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/myconfig/getUserSettings",
    validator: validate_BooksMyconfigGetUserSettings_580067, base: "/books/v1",
    url: url_BooksMyconfigGetUserSettings_580068, schemes: {Scheme.Https})
type
  Call_BooksMyconfigReleaseDownloadAccess_580079 = ref object of OpenApiRestCall_579437
proc url_BooksMyconfigReleaseDownloadAccess_580081(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksMyconfigReleaseDownloadAccess_580080(path: JsonNode;
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
  var valid_580082 = query.getOrDefault("locale")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "locale", valid_580082
  var valid_580083 = query.getOrDefault("fields")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "fields", valid_580083
  var valid_580084 = query.getOrDefault("quotaUser")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "quotaUser", valid_580084
  var valid_580085 = query.getOrDefault("alt")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = newJString("json"))
  if valid_580085 != nil:
    section.add "alt", valid_580085
  var valid_580086 = query.getOrDefault("oauth_token")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "oauth_token", valid_580086
  assert query != nil, "query argument is necessary due to required `cpksver` field"
  var valid_580087 = query.getOrDefault("cpksver")
  valid_580087 = validateParameter(valid_580087, JString, required = true,
                                 default = nil)
  if valid_580087 != nil:
    section.add "cpksver", valid_580087
  var valid_580088 = query.getOrDefault("userIp")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "userIp", valid_580088
  var valid_580089 = query.getOrDefault("volumeIds")
  valid_580089 = validateParameter(valid_580089, JArray, required = true, default = nil)
  if valid_580089 != nil:
    section.add "volumeIds", valid_580089
  var valid_580090 = query.getOrDefault("source")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "source", valid_580090
  var valid_580091 = query.getOrDefault("key")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "key", valid_580091
  var valid_580092 = query.getOrDefault("prettyPrint")
  valid_580092 = validateParameter(valid_580092, JBool, required = false,
                                 default = newJBool(true))
  if valid_580092 != nil:
    section.add "prettyPrint", valid_580092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580093: Call_BooksMyconfigReleaseDownloadAccess_580079;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Release downloaded content access restriction.
  ## 
  let valid = call_580093.validator(path, query, header, formData, body)
  let scheme = call_580093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580093.url(scheme.get, call_580093.host, call_580093.base,
                         call_580093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580093, url, valid)

proc call*(call_580094: Call_BooksMyconfigReleaseDownloadAccess_580079;
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
  var query_580095 = newJObject()
  add(query_580095, "locale", newJString(locale))
  add(query_580095, "fields", newJString(fields))
  add(query_580095, "quotaUser", newJString(quotaUser))
  add(query_580095, "alt", newJString(alt))
  add(query_580095, "oauth_token", newJString(oauthToken))
  add(query_580095, "cpksver", newJString(cpksver))
  add(query_580095, "userIp", newJString(userIp))
  if volumeIds != nil:
    query_580095.add "volumeIds", volumeIds
  add(query_580095, "source", newJString(source))
  add(query_580095, "key", newJString(key))
  add(query_580095, "prettyPrint", newJBool(prettyPrint))
  result = call_580094.call(nil, query_580095, nil, nil, nil)

var booksMyconfigReleaseDownloadAccess* = Call_BooksMyconfigReleaseDownloadAccess_580079(
    name: "booksMyconfigReleaseDownloadAccess", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/myconfig/releaseDownloadAccess",
    validator: validate_BooksMyconfigReleaseDownloadAccess_580080,
    base: "/books/v1", url: url_BooksMyconfigReleaseDownloadAccess_580081,
    schemes: {Scheme.Https})
type
  Call_BooksMyconfigRequestAccess_580096 = ref object of OpenApiRestCall_579437
proc url_BooksMyconfigRequestAccess_580098(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksMyconfigRequestAccess_580097(path: JsonNode; query: JsonNode;
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
  var valid_580099 = query.getOrDefault("locale")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "locale", valid_580099
  var valid_580100 = query.getOrDefault("fields")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "fields", valid_580100
  var valid_580101 = query.getOrDefault("quotaUser")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "quotaUser", valid_580101
  var valid_580102 = query.getOrDefault("alt")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = newJString("json"))
  if valid_580102 != nil:
    section.add "alt", valid_580102
  var valid_580103 = query.getOrDefault("oauth_token")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "oauth_token", valid_580103
  assert query != nil, "query argument is necessary due to required `cpksver` field"
  var valid_580104 = query.getOrDefault("cpksver")
  valid_580104 = validateParameter(valid_580104, JString, required = true,
                                 default = nil)
  if valid_580104 != nil:
    section.add "cpksver", valid_580104
  var valid_580105 = query.getOrDefault("userIp")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "userIp", valid_580105
  var valid_580106 = query.getOrDefault("licenseTypes")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = newJString("BOTH"))
  if valid_580106 != nil:
    section.add "licenseTypes", valid_580106
  var valid_580107 = query.getOrDefault("nonce")
  valid_580107 = validateParameter(valid_580107, JString, required = true,
                                 default = nil)
  if valid_580107 != nil:
    section.add "nonce", valid_580107
  var valid_580108 = query.getOrDefault("source")
  valid_580108 = validateParameter(valid_580108, JString, required = true,
                                 default = nil)
  if valid_580108 != nil:
    section.add "source", valid_580108
  var valid_580109 = query.getOrDefault("key")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "key", valid_580109
  var valid_580110 = query.getOrDefault("volumeId")
  valid_580110 = validateParameter(valid_580110, JString, required = true,
                                 default = nil)
  if valid_580110 != nil:
    section.add "volumeId", valid_580110
  var valid_580111 = query.getOrDefault("prettyPrint")
  valid_580111 = validateParameter(valid_580111, JBool, required = false,
                                 default = newJBool(true))
  if valid_580111 != nil:
    section.add "prettyPrint", valid_580111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580112: Call_BooksMyconfigRequestAccess_580096; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Request concurrent and download access restrictions.
  ## 
  let valid = call_580112.validator(path, query, header, formData, body)
  let scheme = call_580112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580112.url(scheme.get, call_580112.host, call_580112.base,
                         call_580112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580112, url, valid)

proc call*(call_580113: Call_BooksMyconfigRequestAccess_580096; cpksver: string;
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
  var query_580114 = newJObject()
  add(query_580114, "locale", newJString(locale))
  add(query_580114, "fields", newJString(fields))
  add(query_580114, "quotaUser", newJString(quotaUser))
  add(query_580114, "alt", newJString(alt))
  add(query_580114, "oauth_token", newJString(oauthToken))
  add(query_580114, "cpksver", newJString(cpksver))
  add(query_580114, "userIp", newJString(userIp))
  add(query_580114, "licenseTypes", newJString(licenseTypes))
  add(query_580114, "nonce", newJString(nonce))
  add(query_580114, "source", newJString(source))
  add(query_580114, "key", newJString(key))
  add(query_580114, "volumeId", newJString(volumeId))
  add(query_580114, "prettyPrint", newJBool(prettyPrint))
  result = call_580113.call(nil, query_580114, nil, nil, nil)

var booksMyconfigRequestAccess* = Call_BooksMyconfigRequestAccess_580096(
    name: "booksMyconfigRequestAccess", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/myconfig/requestAccess",
    validator: validate_BooksMyconfigRequestAccess_580097, base: "/books/v1",
    url: url_BooksMyconfigRequestAccess_580098, schemes: {Scheme.Https})
type
  Call_BooksMyconfigSyncVolumeLicenses_580115 = ref object of OpenApiRestCall_579437
proc url_BooksMyconfigSyncVolumeLicenses_580117(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksMyconfigSyncVolumeLicenses_580116(path: JsonNode;
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
  var valid_580118 = query.getOrDefault("locale")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "locale", valid_580118
  var valid_580119 = query.getOrDefault("fields")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "fields", valid_580119
  var valid_580120 = query.getOrDefault("quotaUser")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "quotaUser", valid_580120
  var valid_580121 = query.getOrDefault("alt")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = newJString("json"))
  if valid_580121 != nil:
    section.add "alt", valid_580121
  var valid_580122 = query.getOrDefault("oauth_token")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "oauth_token", valid_580122
  assert query != nil, "query argument is necessary due to required `cpksver` field"
  var valid_580123 = query.getOrDefault("cpksver")
  valid_580123 = validateParameter(valid_580123, JString, required = true,
                                 default = nil)
  if valid_580123 != nil:
    section.add "cpksver", valid_580123
  var valid_580124 = query.getOrDefault("includeNonComicsSeries")
  valid_580124 = validateParameter(valid_580124, JBool, required = false, default = nil)
  if valid_580124 != nil:
    section.add "includeNonComicsSeries", valid_580124
  var valid_580125 = query.getOrDefault("userIp")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "userIp", valid_580125
  var valid_580126 = query.getOrDefault("nonce")
  valid_580126 = validateParameter(valid_580126, JString, required = true,
                                 default = nil)
  if valid_580126 != nil:
    section.add "nonce", valid_580126
  var valid_580127 = query.getOrDefault("volumeIds")
  valid_580127 = validateParameter(valid_580127, JArray, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "volumeIds", valid_580127
  var valid_580128 = query.getOrDefault("source")
  valid_580128 = validateParameter(valid_580128, JString, required = true,
                                 default = nil)
  if valid_580128 != nil:
    section.add "source", valid_580128
  var valid_580129 = query.getOrDefault("key")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "key", valid_580129
  var valid_580130 = query.getOrDefault("prettyPrint")
  valid_580130 = validateParameter(valid_580130, JBool, required = false,
                                 default = newJBool(true))
  if valid_580130 != nil:
    section.add "prettyPrint", valid_580130
  var valid_580131 = query.getOrDefault("features")
  valid_580131 = validateParameter(valid_580131, JArray, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "features", valid_580131
  var valid_580132 = query.getOrDefault("showPreorders")
  valid_580132 = validateParameter(valid_580132, JBool, required = false, default = nil)
  if valid_580132 != nil:
    section.add "showPreorders", valid_580132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580133: Call_BooksMyconfigSyncVolumeLicenses_580115;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Request downloaded content access for specified volumes on the My eBooks shelf.
  ## 
  let valid = call_580133.validator(path, query, header, formData, body)
  let scheme = call_580133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580133.url(scheme.get, call_580133.host, call_580133.base,
                         call_580133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580133, url, valid)

proc call*(call_580134: Call_BooksMyconfigSyncVolumeLicenses_580115;
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
  var query_580135 = newJObject()
  add(query_580135, "locale", newJString(locale))
  add(query_580135, "fields", newJString(fields))
  add(query_580135, "quotaUser", newJString(quotaUser))
  add(query_580135, "alt", newJString(alt))
  add(query_580135, "oauth_token", newJString(oauthToken))
  add(query_580135, "cpksver", newJString(cpksver))
  add(query_580135, "includeNonComicsSeries", newJBool(includeNonComicsSeries))
  add(query_580135, "userIp", newJString(userIp))
  add(query_580135, "nonce", newJString(nonce))
  if volumeIds != nil:
    query_580135.add "volumeIds", volumeIds
  add(query_580135, "source", newJString(source))
  add(query_580135, "key", newJString(key))
  add(query_580135, "prettyPrint", newJBool(prettyPrint))
  if features != nil:
    query_580135.add "features", features
  add(query_580135, "showPreorders", newJBool(showPreorders))
  result = call_580134.call(nil, query_580135, nil, nil, nil)

var booksMyconfigSyncVolumeLicenses* = Call_BooksMyconfigSyncVolumeLicenses_580115(
    name: "booksMyconfigSyncVolumeLicenses", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/myconfig/syncVolumeLicenses",
    validator: validate_BooksMyconfigSyncVolumeLicenses_580116, base: "/books/v1",
    url: url_BooksMyconfigSyncVolumeLicenses_580117, schemes: {Scheme.Https})
type
  Call_BooksMyconfigUpdateUserSettings_580136 = ref object of OpenApiRestCall_579437
proc url_BooksMyconfigUpdateUserSettings_580138(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksMyconfigUpdateUserSettings_580137(path: JsonNode;
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
  var valid_580139 = query.getOrDefault("fields")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "fields", valid_580139
  var valid_580140 = query.getOrDefault("quotaUser")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "quotaUser", valid_580140
  var valid_580141 = query.getOrDefault("alt")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = newJString("json"))
  if valid_580141 != nil:
    section.add "alt", valid_580141
  var valid_580142 = query.getOrDefault("oauth_token")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "oauth_token", valid_580142
  var valid_580143 = query.getOrDefault("userIp")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "userIp", valid_580143
  var valid_580144 = query.getOrDefault("key")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "key", valid_580144
  var valid_580145 = query.getOrDefault("prettyPrint")
  valid_580145 = validateParameter(valid_580145, JBool, required = false,
                                 default = newJBool(true))
  if valid_580145 != nil:
    section.add "prettyPrint", valid_580145
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

proc call*(call_580147: Call_BooksMyconfigUpdateUserSettings_580136;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the settings for the user. If a sub-object is specified, it will overwrite the existing sub-object stored in the server. Unspecified sub-objects will retain the existing value.
  ## 
  let valid = call_580147.validator(path, query, header, formData, body)
  let scheme = call_580147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580147.url(scheme.get, call_580147.host, call_580147.base,
                         call_580147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580147, url, valid)

proc call*(call_580148: Call_BooksMyconfigUpdateUserSettings_580136;
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
  var query_580149 = newJObject()
  var body_580150 = newJObject()
  add(query_580149, "fields", newJString(fields))
  add(query_580149, "quotaUser", newJString(quotaUser))
  add(query_580149, "alt", newJString(alt))
  add(query_580149, "oauth_token", newJString(oauthToken))
  add(query_580149, "userIp", newJString(userIp))
  add(query_580149, "key", newJString(key))
  if body != nil:
    body_580150 = body
  add(query_580149, "prettyPrint", newJBool(prettyPrint))
  result = call_580148.call(nil, query_580149, nil, nil, body_580150)

var booksMyconfigUpdateUserSettings* = Call_BooksMyconfigUpdateUserSettings_580136(
    name: "booksMyconfigUpdateUserSettings", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/myconfig/updateUserSettings",
    validator: validate_BooksMyconfigUpdateUserSettings_580137, base: "/books/v1",
    url: url_BooksMyconfigUpdateUserSettings_580138, schemes: {Scheme.Https})
type
  Call_BooksMylibraryAnnotationsInsert_580174 = ref object of OpenApiRestCall_579437
proc url_BooksMylibraryAnnotationsInsert_580176(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksMylibraryAnnotationsInsert_580175(path: JsonNode;
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
  var valid_580177 = query.getOrDefault("fields")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "fields", valid_580177
  var valid_580178 = query.getOrDefault("country")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "country", valid_580178
  var valid_580179 = query.getOrDefault("quotaUser")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "quotaUser", valid_580179
  var valid_580180 = query.getOrDefault("alt")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = newJString("json"))
  if valid_580180 != nil:
    section.add "alt", valid_580180
  var valid_580181 = query.getOrDefault("showOnlySummaryInResponse")
  valid_580181 = validateParameter(valid_580181, JBool, required = false, default = nil)
  if valid_580181 != nil:
    section.add "showOnlySummaryInResponse", valid_580181
  var valid_580182 = query.getOrDefault("annotationId")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "annotationId", valid_580182
  var valid_580183 = query.getOrDefault("oauth_token")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "oauth_token", valid_580183
  var valid_580184 = query.getOrDefault("userIp")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "userIp", valid_580184
  var valid_580185 = query.getOrDefault("source")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "source", valid_580185
  var valid_580186 = query.getOrDefault("key")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "key", valid_580186
  var valid_580187 = query.getOrDefault("prettyPrint")
  valid_580187 = validateParameter(valid_580187, JBool, required = false,
                                 default = newJBool(true))
  if valid_580187 != nil:
    section.add "prettyPrint", valid_580187
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

proc call*(call_580189: Call_BooksMylibraryAnnotationsInsert_580174;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a new annotation.
  ## 
  let valid = call_580189.validator(path, query, header, formData, body)
  let scheme = call_580189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580189.url(scheme.get, call_580189.host, call_580189.base,
                         call_580189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580189, url, valid)

proc call*(call_580190: Call_BooksMylibraryAnnotationsInsert_580174;
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
  var query_580191 = newJObject()
  var body_580192 = newJObject()
  add(query_580191, "fields", newJString(fields))
  add(query_580191, "country", newJString(country))
  add(query_580191, "quotaUser", newJString(quotaUser))
  add(query_580191, "alt", newJString(alt))
  add(query_580191, "showOnlySummaryInResponse",
      newJBool(showOnlySummaryInResponse))
  add(query_580191, "annotationId", newJString(annotationId))
  add(query_580191, "oauth_token", newJString(oauthToken))
  add(query_580191, "userIp", newJString(userIp))
  add(query_580191, "source", newJString(source))
  add(query_580191, "key", newJString(key))
  if body != nil:
    body_580192 = body
  add(query_580191, "prettyPrint", newJBool(prettyPrint))
  result = call_580190.call(nil, query_580191, nil, nil, body_580192)

var booksMylibraryAnnotationsInsert* = Call_BooksMylibraryAnnotationsInsert_580174(
    name: "booksMylibraryAnnotationsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/mylibrary/annotations",
    validator: validate_BooksMylibraryAnnotationsInsert_580175, base: "/books/v1",
    url: url_BooksMylibraryAnnotationsInsert_580176, schemes: {Scheme.Https})
type
  Call_BooksMylibraryAnnotationsList_580151 = ref object of OpenApiRestCall_579437
proc url_BooksMylibraryAnnotationsList_580153(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksMylibraryAnnotationsList_580152(path: JsonNode; query: JsonNode;
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
  var valid_580154 = query.getOrDefault("layerIds")
  valid_580154 = validateParameter(valid_580154, JArray, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "layerIds", valid_580154
  var valid_580155 = query.getOrDefault("fields")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "fields", valid_580155
  var valid_580156 = query.getOrDefault("pageToken")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "pageToken", valid_580156
  var valid_580157 = query.getOrDefault("quotaUser")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "quotaUser", valid_580157
  var valid_580158 = query.getOrDefault("alt")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = newJString("json"))
  if valid_580158 != nil:
    section.add "alt", valid_580158
  var valid_580159 = query.getOrDefault("updatedMax")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "updatedMax", valid_580159
  var valid_580160 = query.getOrDefault("oauth_token")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "oauth_token", valid_580160
  var valid_580161 = query.getOrDefault("userIp")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "userIp", valid_580161
  var valid_580162 = query.getOrDefault("layerId")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "layerId", valid_580162
  var valid_580163 = query.getOrDefault("maxResults")
  valid_580163 = validateParameter(valid_580163, JInt, required = false, default = nil)
  if valid_580163 != nil:
    section.add "maxResults", valid_580163
  var valid_580164 = query.getOrDefault("contentVersion")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "contentVersion", valid_580164
  var valid_580165 = query.getOrDefault("showDeleted")
  valid_580165 = validateParameter(valid_580165, JBool, required = false, default = nil)
  if valid_580165 != nil:
    section.add "showDeleted", valid_580165
  var valid_580166 = query.getOrDefault("source")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "source", valid_580166
  var valid_580167 = query.getOrDefault("updatedMin")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "updatedMin", valid_580167
  var valid_580168 = query.getOrDefault("key")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "key", valid_580168
  var valid_580169 = query.getOrDefault("volumeId")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "volumeId", valid_580169
  var valid_580170 = query.getOrDefault("prettyPrint")
  valid_580170 = validateParameter(valid_580170, JBool, required = false,
                                 default = newJBool(true))
  if valid_580170 != nil:
    section.add "prettyPrint", valid_580170
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580171: Call_BooksMylibraryAnnotationsList_580151; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of annotations, possibly filtered.
  ## 
  let valid = call_580171.validator(path, query, header, formData, body)
  let scheme = call_580171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580171.url(scheme.get, call_580171.host, call_580171.base,
                         call_580171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580171, url, valid)

proc call*(call_580172: Call_BooksMylibraryAnnotationsList_580151;
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
  var query_580173 = newJObject()
  if layerIds != nil:
    query_580173.add "layerIds", layerIds
  add(query_580173, "fields", newJString(fields))
  add(query_580173, "pageToken", newJString(pageToken))
  add(query_580173, "quotaUser", newJString(quotaUser))
  add(query_580173, "alt", newJString(alt))
  add(query_580173, "updatedMax", newJString(updatedMax))
  add(query_580173, "oauth_token", newJString(oauthToken))
  add(query_580173, "userIp", newJString(userIp))
  add(query_580173, "layerId", newJString(layerId))
  add(query_580173, "maxResults", newJInt(maxResults))
  add(query_580173, "contentVersion", newJString(contentVersion))
  add(query_580173, "showDeleted", newJBool(showDeleted))
  add(query_580173, "source", newJString(source))
  add(query_580173, "updatedMin", newJString(updatedMin))
  add(query_580173, "key", newJString(key))
  add(query_580173, "volumeId", newJString(volumeId))
  add(query_580173, "prettyPrint", newJBool(prettyPrint))
  result = call_580172.call(nil, query_580173, nil, nil, nil)

var booksMylibraryAnnotationsList* = Call_BooksMylibraryAnnotationsList_580151(
    name: "booksMylibraryAnnotationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/mylibrary/annotations",
    validator: validate_BooksMylibraryAnnotationsList_580152, base: "/books/v1",
    url: url_BooksMylibraryAnnotationsList_580153, schemes: {Scheme.Https})
type
  Call_BooksMylibraryAnnotationsSummary_580193 = ref object of OpenApiRestCall_579437
proc url_BooksMylibraryAnnotationsSummary_580195(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksMylibraryAnnotationsSummary_580194(path: JsonNode;
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
  var valid_580196 = query.getOrDefault("layerIds")
  valid_580196 = validateParameter(valid_580196, JArray, required = true, default = nil)
  if valid_580196 != nil:
    section.add "layerIds", valid_580196
  var valid_580197 = query.getOrDefault("fields")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "fields", valid_580197
  var valid_580198 = query.getOrDefault("quotaUser")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "quotaUser", valid_580198
  var valid_580199 = query.getOrDefault("alt")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = newJString("json"))
  if valid_580199 != nil:
    section.add "alt", valid_580199
  var valid_580200 = query.getOrDefault("oauth_token")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "oauth_token", valid_580200
  var valid_580201 = query.getOrDefault("userIp")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "userIp", valid_580201
  var valid_580202 = query.getOrDefault("key")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "key", valid_580202
  var valid_580203 = query.getOrDefault("volumeId")
  valid_580203 = validateParameter(valid_580203, JString, required = true,
                                 default = nil)
  if valid_580203 != nil:
    section.add "volumeId", valid_580203
  var valid_580204 = query.getOrDefault("prettyPrint")
  valid_580204 = validateParameter(valid_580204, JBool, required = false,
                                 default = newJBool(true))
  if valid_580204 != nil:
    section.add "prettyPrint", valid_580204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580205: Call_BooksMylibraryAnnotationsSummary_580193;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the summary of specified layers.
  ## 
  let valid = call_580205.validator(path, query, header, formData, body)
  let scheme = call_580205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580205.url(scheme.get, call_580205.host, call_580205.base,
                         call_580205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580205, url, valid)

proc call*(call_580206: Call_BooksMylibraryAnnotationsSummary_580193;
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
  var query_580207 = newJObject()
  if layerIds != nil:
    query_580207.add "layerIds", layerIds
  add(query_580207, "fields", newJString(fields))
  add(query_580207, "quotaUser", newJString(quotaUser))
  add(query_580207, "alt", newJString(alt))
  add(query_580207, "oauth_token", newJString(oauthToken))
  add(query_580207, "userIp", newJString(userIp))
  add(query_580207, "key", newJString(key))
  add(query_580207, "volumeId", newJString(volumeId))
  add(query_580207, "prettyPrint", newJBool(prettyPrint))
  result = call_580206.call(nil, query_580207, nil, nil, nil)

var booksMylibraryAnnotationsSummary* = Call_BooksMylibraryAnnotationsSummary_580193(
    name: "booksMylibraryAnnotationsSummary", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/mylibrary/annotations/summary",
    validator: validate_BooksMylibraryAnnotationsSummary_580194,
    base: "/books/v1", url: url_BooksMylibraryAnnotationsSummary_580195,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryAnnotationsUpdate_580208 = ref object of OpenApiRestCall_579437
proc url_BooksMylibraryAnnotationsUpdate_580210(protocol: Scheme; host: string;
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

proc validate_BooksMylibraryAnnotationsUpdate_580209(path: JsonNode;
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
  var valid_580225 = path.getOrDefault("annotationId")
  valid_580225 = validateParameter(valid_580225, JString, required = true,
                                 default = nil)
  if valid_580225 != nil:
    section.add "annotationId", valid_580225
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
  var valid_580226 = query.getOrDefault("fields")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "fields", valid_580226
  var valid_580227 = query.getOrDefault("quotaUser")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "quotaUser", valid_580227
  var valid_580228 = query.getOrDefault("alt")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = newJString("json"))
  if valid_580228 != nil:
    section.add "alt", valid_580228
  var valid_580229 = query.getOrDefault("oauth_token")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "oauth_token", valid_580229
  var valid_580230 = query.getOrDefault("userIp")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "userIp", valid_580230
  var valid_580231 = query.getOrDefault("source")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "source", valid_580231
  var valid_580232 = query.getOrDefault("key")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "key", valid_580232
  var valid_580233 = query.getOrDefault("prettyPrint")
  valid_580233 = validateParameter(valid_580233, JBool, required = false,
                                 default = newJBool(true))
  if valid_580233 != nil:
    section.add "prettyPrint", valid_580233
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

proc call*(call_580235: Call_BooksMylibraryAnnotationsUpdate_580208;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing annotation.
  ## 
  let valid = call_580235.validator(path, query, header, formData, body)
  let scheme = call_580235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580235.url(scheme.get, call_580235.host, call_580235.base,
                         call_580235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580235, url, valid)

proc call*(call_580236: Call_BooksMylibraryAnnotationsUpdate_580208;
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
  var path_580237 = newJObject()
  var query_580238 = newJObject()
  var body_580239 = newJObject()
  add(query_580238, "fields", newJString(fields))
  add(query_580238, "quotaUser", newJString(quotaUser))
  add(query_580238, "alt", newJString(alt))
  add(query_580238, "oauth_token", newJString(oauthToken))
  add(path_580237, "annotationId", newJString(annotationId))
  add(query_580238, "userIp", newJString(userIp))
  add(query_580238, "source", newJString(source))
  add(query_580238, "key", newJString(key))
  if body != nil:
    body_580239 = body
  add(query_580238, "prettyPrint", newJBool(prettyPrint))
  result = call_580236.call(path_580237, query_580238, nil, nil, body_580239)

var booksMylibraryAnnotationsUpdate* = Call_BooksMylibraryAnnotationsUpdate_580208(
    name: "booksMylibraryAnnotationsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/mylibrary/annotations/{annotationId}",
    validator: validate_BooksMylibraryAnnotationsUpdate_580209, base: "/books/v1",
    url: url_BooksMylibraryAnnotationsUpdate_580210, schemes: {Scheme.Https})
type
  Call_BooksMylibraryAnnotationsDelete_580240 = ref object of OpenApiRestCall_579437
proc url_BooksMylibraryAnnotationsDelete_580242(protocol: Scheme; host: string;
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

proc validate_BooksMylibraryAnnotationsDelete_580241(path: JsonNode;
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
  var valid_580243 = path.getOrDefault("annotationId")
  valid_580243 = validateParameter(valid_580243, JString, required = true,
                                 default = nil)
  if valid_580243 != nil:
    section.add "annotationId", valid_580243
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
  var valid_580244 = query.getOrDefault("fields")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "fields", valid_580244
  var valid_580245 = query.getOrDefault("quotaUser")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "quotaUser", valid_580245
  var valid_580246 = query.getOrDefault("alt")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = newJString("json"))
  if valid_580246 != nil:
    section.add "alt", valid_580246
  var valid_580247 = query.getOrDefault("oauth_token")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "oauth_token", valid_580247
  var valid_580248 = query.getOrDefault("userIp")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "userIp", valid_580248
  var valid_580249 = query.getOrDefault("source")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "source", valid_580249
  var valid_580250 = query.getOrDefault("key")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "key", valid_580250
  var valid_580251 = query.getOrDefault("prettyPrint")
  valid_580251 = validateParameter(valid_580251, JBool, required = false,
                                 default = newJBool(true))
  if valid_580251 != nil:
    section.add "prettyPrint", valid_580251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580252: Call_BooksMylibraryAnnotationsDelete_580240;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an annotation.
  ## 
  let valid = call_580252.validator(path, query, header, formData, body)
  let scheme = call_580252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580252.url(scheme.get, call_580252.host, call_580252.base,
                         call_580252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580252, url, valid)

proc call*(call_580253: Call_BooksMylibraryAnnotationsDelete_580240;
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
  var path_580254 = newJObject()
  var query_580255 = newJObject()
  add(query_580255, "fields", newJString(fields))
  add(query_580255, "quotaUser", newJString(quotaUser))
  add(query_580255, "alt", newJString(alt))
  add(query_580255, "oauth_token", newJString(oauthToken))
  add(path_580254, "annotationId", newJString(annotationId))
  add(query_580255, "userIp", newJString(userIp))
  add(query_580255, "source", newJString(source))
  add(query_580255, "key", newJString(key))
  add(query_580255, "prettyPrint", newJBool(prettyPrint))
  result = call_580253.call(path_580254, query_580255, nil, nil, nil)

var booksMylibraryAnnotationsDelete* = Call_BooksMylibraryAnnotationsDelete_580240(
    name: "booksMylibraryAnnotationsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/mylibrary/annotations/{annotationId}",
    validator: validate_BooksMylibraryAnnotationsDelete_580241, base: "/books/v1",
    url: url_BooksMylibraryAnnotationsDelete_580242, schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesList_580256 = ref object of OpenApiRestCall_579437
proc url_BooksMylibraryBookshelvesList_580258(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksMylibraryBookshelvesList_580257(path: JsonNode; query: JsonNode;
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
  var valid_580259 = query.getOrDefault("fields")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "fields", valid_580259
  var valid_580260 = query.getOrDefault("quotaUser")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "quotaUser", valid_580260
  var valid_580261 = query.getOrDefault("alt")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = newJString("json"))
  if valid_580261 != nil:
    section.add "alt", valid_580261
  var valid_580262 = query.getOrDefault("oauth_token")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "oauth_token", valid_580262
  var valid_580263 = query.getOrDefault("userIp")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "userIp", valid_580263
  var valid_580264 = query.getOrDefault("source")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "source", valid_580264
  var valid_580265 = query.getOrDefault("key")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "key", valid_580265
  var valid_580266 = query.getOrDefault("prettyPrint")
  valid_580266 = validateParameter(valid_580266, JBool, required = false,
                                 default = newJBool(true))
  if valid_580266 != nil:
    section.add "prettyPrint", valid_580266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580267: Call_BooksMylibraryBookshelvesList_580256; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of bookshelves belonging to the authenticated user.
  ## 
  let valid = call_580267.validator(path, query, header, formData, body)
  let scheme = call_580267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580267.url(scheme.get, call_580267.host, call_580267.base,
                         call_580267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580267, url, valid)

proc call*(call_580268: Call_BooksMylibraryBookshelvesList_580256;
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
  var query_580269 = newJObject()
  add(query_580269, "fields", newJString(fields))
  add(query_580269, "quotaUser", newJString(quotaUser))
  add(query_580269, "alt", newJString(alt))
  add(query_580269, "oauth_token", newJString(oauthToken))
  add(query_580269, "userIp", newJString(userIp))
  add(query_580269, "source", newJString(source))
  add(query_580269, "key", newJString(key))
  add(query_580269, "prettyPrint", newJBool(prettyPrint))
  result = call_580268.call(nil, query_580269, nil, nil, nil)

var booksMylibraryBookshelvesList* = Call_BooksMylibraryBookshelvesList_580256(
    name: "booksMylibraryBookshelvesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/mylibrary/bookshelves",
    validator: validate_BooksMylibraryBookshelvesList_580257, base: "/books/v1",
    url: url_BooksMylibraryBookshelvesList_580258, schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesGet_580270 = ref object of OpenApiRestCall_579437
proc url_BooksMylibraryBookshelvesGet_580272(protocol: Scheme; host: string;
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

proc validate_BooksMylibraryBookshelvesGet_580271(path: JsonNode; query: JsonNode;
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
  var valid_580273 = path.getOrDefault("shelf")
  valid_580273 = validateParameter(valid_580273, JString, required = true,
                                 default = nil)
  if valid_580273 != nil:
    section.add "shelf", valid_580273
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
  var valid_580274 = query.getOrDefault("fields")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "fields", valid_580274
  var valid_580275 = query.getOrDefault("quotaUser")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = nil)
  if valid_580275 != nil:
    section.add "quotaUser", valid_580275
  var valid_580276 = query.getOrDefault("alt")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = newJString("json"))
  if valid_580276 != nil:
    section.add "alt", valid_580276
  var valid_580277 = query.getOrDefault("oauth_token")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "oauth_token", valid_580277
  var valid_580278 = query.getOrDefault("userIp")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "userIp", valid_580278
  var valid_580279 = query.getOrDefault("source")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "source", valid_580279
  var valid_580280 = query.getOrDefault("key")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "key", valid_580280
  var valid_580281 = query.getOrDefault("prettyPrint")
  valid_580281 = validateParameter(valid_580281, JBool, required = false,
                                 default = newJBool(true))
  if valid_580281 != nil:
    section.add "prettyPrint", valid_580281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580282: Call_BooksMylibraryBookshelvesGet_580270; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves metadata for a specific bookshelf belonging to the authenticated user.
  ## 
  let valid = call_580282.validator(path, query, header, formData, body)
  let scheme = call_580282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580282.url(scheme.get, call_580282.host, call_580282.base,
                         call_580282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580282, url, valid)

proc call*(call_580283: Call_BooksMylibraryBookshelvesGet_580270; shelf: string;
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
  var path_580284 = newJObject()
  var query_580285 = newJObject()
  add(query_580285, "fields", newJString(fields))
  add(query_580285, "quotaUser", newJString(quotaUser))
  add(query_580285, "alt", newJString(alt))
  add(query_580285, "oauth_token", newJString(oauthToken))
  add(query_580285, "userIp", newJString(userIp))
  add(path_580284, "shelf", newJString(shelf))
  add(query_580285, "source", newJString(source))
  add(query_580285, "key", newJString(key))
  add(query_580285, "prettyPrint", newJBool(prettyPrint))
  result = call_580283.call(path_580284, query_580285, nil, nil, nil)

var booksMylibraryBookshelvesGet* = Call_BooksMylibraryBookshelvesGet_580270(
    name: "booksMylibraryBookshelvesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/mylibrary/bookshelves/{shelf}",
    validator: validate_BooksMylibraryBookshelvesGet_580271, base: "/books/v1",
    url: url_BooksMylibraryBookshelvesGet_580272, schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesAddVolume_580286 = ref object of OpenApiRestCall_579437
proc url_BooksMylibraryBookshelvesAddVolume_580288(protocol: Scheme; host: string;
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

proc validate_BooksMylibraryBookshelvesAddVolume_580287(path: JsonNode;
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
  var valid_580289 = path.getOrDefault("shelf")
  valid_580289 = validateParameter(valid_580289, JString, required = true,
                                 default = nil)
  if valid_580289 != nil:
    section.add "shelf", valid_580289
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
  var valid_580290 = query.getOrDefault("fields")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "fields", valid_580290
  var valid_580291 = query.getOrDefault("quotaUser")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "quotaUser", valid_580291
  var valid_580292 = query.getOrDefault("alt")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = newJString("json"))
  if valid_580292 != nil:
    section.add "alt", valid_580292
  var valid_580293 = query.getOrDefault("oauth_token")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "oauth_token", valid_580293
  var valid_580294 = query.getOrDefault("userIp")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "userIp", valid_580294
  var valid_580295 = query.getOrDefault("source")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "source", valid_580295
  var valid_580296 = query.getOrDefault("key")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = nil)
  if valid_580296 != nil:
    section.add "key", valid_580296
  assert query != nil,
        "query argument is necessary due to required `volumeId` field"
  var valid_580297 = query.getOrDefault("volumeId")
  valid_580297 = validateParameter(valid_580297, JString, required = true,
                                 default = nil)
  if valid_580297 != nil:
    section.add "volumeId", valid_580297
  var valid_580298 = query.getOrDefault("prettyPrint")
  valid_580298 = validateParameter(valid_580298, JBool, required = false,
                                 default = newJBool(true))
  if valid_580298 != nil:
    section.add "prettyPrint", valid_580298
  var valid_580299 = query.getOrDefault("reason")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = newJString("IOS_PREX"))
  if valid_580299 != nil:
    section.add "reason", valid_580299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580300: Call_BooksMylibraryBookshelvesAddVolume_580286;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a volume to a bookshelf.
  ## 
  let valid = call_580300.validator(path, query, header, formData, body)
  let scheme = call_580300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580300.url(scheme.get, call_580300.host, call_580300.base,
                         call_580300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580300, url, valid)

proc call*(call_580301: Call_BooksMylibraryBookshelvesAddVolume_580286;
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
  var path_580302 = newJObject()
  var query_580303 = newJObject()
  add(query_580303, "fields", newJString(fields))
  add(query_580303, "quotaUser", newJString(quotaUser))
  add(query_580303, "alt", newJString(alt))
  add(query_580303, "oauth_token", newJString(oauthToken))
  add(query_580303, "userIp", newJString(userIp))
  add(path_580302, "shelf", newJString(shelf))
  add(query_580303, "source", newJString(source))
  add(query_580303, "key", newJString(key))
  add(query_580303, "volumeId", newJString(volumeId))
  add(query_580303, "prettyPrint", newJBool(prettyPrint))
  add(query_580303, "reason", newJString(reason))
  result = call_580301.call(path_580302, query_580303, nil, nil, nil)

var booksMylibraryBookshelvesAddVolume* = Call_BooksMylibraryBookshelvesAddVolume_580286(
    name: "booksMylibraryBookshelvesAddVolume", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/mylibrary/bookshelves/{shelf}/addVolume",
    validator: validate_BooksMylibraryBookshelvesAddVolume_580287,
    base: "/books/v1", url: url_BooksMylibraryBookshelvesAddVolume_580288,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesClearVolumes_580304 = ref object of OpenApiRestCall_579437
proc url_BooksMylibraryBookshelvesClearVolumes_580306(protocol: Scheme;
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

proc validate_BooksMylibraryBookshelvesClearVolumes_580305(path: JsonNode;
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
  var valid_580307 = path.getOrDefault("shelf")
  valid_580307 = validateParameter(valid_580307, JString, required = true,
                                 default = nil)
  if valid_580307 != nil:
    section.add "shelf", valid_580307
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
  var valid_580308 = query.getOrDefault("fields")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "fields", valid_580308
  var valid_580309 = query.getOrDefault("quotaUser")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "quotaUser", valid_580309
  var valid_580310 = query.getOrDefault("alt")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = newJString("json"))
  if valid_580310 != nil:
    section.add "alt", valid_580310
  var valid_580311 = query.getOrDefault("oauth_token")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "oauth_token", valid_580311
  var valid_580312 = query.getOrDefault("userIp")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = nil)
  if valid_580312 != nil:
    section.add "userIp", valid_580312
  var valid_580313 = query.getOrDefault("source")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "source", valid_580313
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580316: Call_BooksMylibraryBookshelvesClearVolumes_580304;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Clears all volumes from a bookshelf.
  ## 
  let valid = call_580316.validator(path, query, header, formData, body)
  let scheme = call_580316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580316.url(scheme.get, call_580316.host, call_580316.base,
                         call_580316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580316, url, valid)

proc call*(call_580317: Call_BooksMylibraryBookshelvesClearVolumes_580304;
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
  var path_580318 = newJObject()
  var query_580319 = newJObject()
  add(query_580319, "fields", newJString(fields))
  add(query_580319, "quotaUser", newJString(quotaUser))
  add(query_580319, "alt", newJString(alt))
  add(query_580319, "oauth_token", newJString(oauthToken))
  add(query_580319, "userIp", newJString(userIp))
  add(path_580318, "shelf", newJString(shelf))
  add(query_580319, "source", newJString(source))
  add(query_580319, "key", newJString(key))
  add(query_580319, "prettyPrint", newJBool(prettyPrint))
  result = call_580317.call(path_580318, query_580319, nil, nil, nil)

var booksMylibraryBookshelvesClearVolumes* = Call_BooksMylibraryBookshelvesClearVolumes_580304(
    name: "booksMylibraryBookshelvesClearVolumes", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/mylibrary/bookshelves/{shelf}/clearVolumes",
    validator: validate_BooksMylibraryBookshelvesClearVolumes_580305,
    base: "/books/v1", url: url_BooksMylibraryBookshelvesClearVolumes_580306,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesMoveVolume_580320 = ref object of OpenApiRestCall_579437
proc url_BooksMylibraryBookshelvesMoveVolume_580322(protocol: Scheme; host: string;
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

proc validate_BooksMylibraryBookshelvesMoveVolume_580321(path: JsonNode;
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
  var valid_580323 = path.getOrDefault("shelf")
  valid_580323 = validateParameter(valid_580323, JString, required = true,
                                 default = nil)
  if valid_580323 != nil:
    section.add "shelf", valid_580323
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
  var valid_580324 = query.getOrDefault("fields")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "fields", valid_580324
  var valid_580325 = query.getOrDefault("quotaUser")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = nil)
  if valid_580325 != nil:
    section.add "quotaUser", valid_580325
  var valid_580326 = query.getOrDefault("alt")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = newJString("json"))
  if valid_580326 != nil:
    section.add "alt", valid_580326
  var valid_580327 = query.getOrDefault("oauth_token")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "oauth_token", valid_580327
  var valid_580328 = query.getOrDefault("userIp")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "userIp", valid_580328
  var valid_580329 = query.getOrDefault("source")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "source", valid_580329
  var valid_580330 = query.getOrDefault("key")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = nil)
  if valid_580330 != nil:
    section.add "key", valid_580330
  assert query != nil,
        "query argument is necessary due to required `volumePosition` field"
  var valid_580331 = query.getOrDefault("volumePosition")
  valid_580331 = validateParameter(valid_580331, JInt, required = true, default = nil)
  if valid_580331 != nil:
    section.add "volumePosition", valid_580331
  var valid_580332 = query.getOrDefault("volumeId")
  valid_580332 = validateParameter(valid_580332, JString, required = true,
                                 default = nil)
  if valid_580332 != nil:
    section.add "volumeId", valid_580332
  var valid_580333 = query.getOrDefault("prettyPrint")
  valid_580333 = validateParameter(valid_580333, JBool, required = false,
                                 default = newJBool(true))
  if valid_580333 != nil:
    section.add "prettyPrint", valid_580333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580334: Call_BooksMylibraryBookshelvesMoveVolume_580320;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Moves a volume within a bookshelf.
  ## 
  let valid = call_580334.validator(path, query, header, formData, body)
  let scheme = call_580334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580334.url(scheme.get, call_580334.host, call_580334.base,
                         call_580334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580334, url, valid)

proc call*(call_580335: Call_BooksMylibraryBookshelvesMoveVolume_580320;
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
  var path_580336 = newJObject()
  var query_580337 = newJObject()
  add(query_580337, "fields", newJString(fields))
  add(query_580337, "quotaUser", newJString(quotaUser))
  add(query_580337, "alt", newJString(alt))
  add(query_580337, "oauth_token", newJString(oauthToken))
  add(query_580337, "userIp", newJString(userIp))
  add(path_580336, "shelf", newJString(shelf))
  add(query_580337, "source", newJString(source))
  add(query_580337, "key", newJString(key))
  add(query_580337, "volumePosition", newJInt(volumePosition))
  add(query_580337, "volumeId", newJString(volumeId))
  add(query_580337, "prettyPrint", newJBool(prettyPrint))
  result = call_580335.call(path_580336, query_580337, nil, nil, nil)

var booksMylibraryBookshelvesMoveVolume* = Call_BooksMylibraryBookshelvesMoveVolume_580320(
    name: "booksMylibraryBookshelvesMoveVolume", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/mylibrary/bookshelves/{shelf}/moveVolume",
    validator: validate_BooksMylibraryBookshelvesMoveVolume_580321,
    base: "/books/v1", url: url_BooksMylibraryBookshelvesMoveVolume_580322,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesRemoveVolume_580338 = ref object of OpenApiRestCall_579437
proc url_BooksMylibraryBookshelvesRemoveVolume_580340(protocol: Scheme;
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

proc validate_BooksMylibraryBookshelvesRemoveVolume_580339(path: JsonNode;
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
  var valid_580341 = path.getOrDefault("shelf")
  valid_580341 = validateParameter(valid_580341, JString, required = true,
                                 default = nil)
  if valid_580341 != nil:
    section.add "shelf", valid_580341
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
  var valid_580342 = query.getOrDefault("fields")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "fields", valid_580342
  var valid_580343 = query.getOrDefault("quotaUser")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "quotaUser", valid_580343
  var valid_580344 = query.getOrDefault("alt")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = newJString("json"))
  if valid_580344 != nil:
    section.add "alt", valid_580344
  var valid_580345 = query.getOrDefault("oauth_token")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = nil)
  if valid_580345 != nil:
    section.add "oauth_token", valid_580345
  var valid_580346 = query.getOrDefault("userIp")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = nil)
  if valid_580346 != nil:
    section.add "userIp", valid_580346
  var valid_580347 = query.getOrDefault("source")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = nil)
  if valid_580347 != nil:
    section.add "source", valid_580347
  var valid_580348 = query.getOrDefault("key")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = nil)
  if valid_580348 != nil:
    section.add "key", valid_580348
  assert query != nil,
        "query argument is necessary due to required `volumeId` field"
  var valid_580349 = query.getOrDefault("volumeId")
  valid_580349 = validateParameter(valid_580349, JString, required = true,
                                 default = nil)
  if valid_580349 != nil:
    section.add "volumeId", valid_580349
  var valid_580350 = query.getOrDefault("prettyPrint")
  valid_580350 = validateParameter(valid_580350, JBool, required = false,
                                 default = newJBool(true))
  if valid_580350 != nil:
    section.add "prettyPrint", valid_580350
  var valid_580351 = query.getOrDefault("reason")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = newJString("ONBOARDING"))
  if valid_580351 != nil:
    section.add "reason", valid_580351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580352: Call_BooksMylibraryBookshelvesRemoveVolume_580338;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a volume from a bookshelf.
  ## 
  let valid = call_580352.validator(path, query, header, formData, body)
  let scheme = call_580352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580352.url(scheme.get, call_580352.host, call_580352.base,
                         call_580352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580352, url, valid)

proc call*(call_580353: Call_BooksMylibraryBookshelvesRemoveVolume_580338;
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
  var path_580354 = newJObject()
  var query_580355 = newJObject()
  add(query_580355, "fields", newJString(fields))
  add(query_580355, "quotaUser", newJString(quotaUser))
  add(query_580355, "alt", newJString(alt))
  add(query_580355, "oauth_token", newJString(oauthToken))
  add(query_580355, "userIp", newJString(userIp))
  add(path_580354, "shelf", newJString(shelf))
  add(query_580355, "source", newJString(source))
  add(query_580355, "key", newJString(key))
  add(query_580355, "volumeId", newJString(volumeId))
  add(query_580355, "prettyPrint", newJBool(prettyPrint))
  add(query_580355, "reason", newJString(reason))
  result = call_580353.call(path_580354, query_580355, nil, nil, nil)

var booksMylibraryBookshelvesRemoveVolume* = Call_BooksMylibraryBookshelvesRemoveVolume_580338(
    name: "booksMylibraryBookshelvesRemoveVolume", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/mylibrary/bookshelves/{shelf}/removeVolume",
    validator: validate_BooksMylibraryBookshelvesRemoveVolume_580339,
    base: "/books/v1", url: url_BooksMylibraryBookshelvesRemoveVolume_580340,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesVolumesList_580356 = ref object of OpenApiRestCall_579437
proc url_BooksMylibraryBookshelvesVolumesList_580358(protocol: Scheme;
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

proc validate_BooksMylibraryBookshelvesVolumesList_580357(path: JsonNode;
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
  var valid_580359 = path.getOrDefault("shelf")
  valid_580359 = validateParameter(valid_580359, JString, required = true,
                                 default = nil)
  if valid_580359 != nil:
    section.add "shelf", valid_580359
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
  var valid_580360 = query.getOrDefault("fields")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "fields", valid_580360
  var valid_580361 = query.getOrDefault("country")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "country", valid_580361
  var valid_580362 = query.getOrDefault("quotaUser")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "quotaUser", valid_580362
  var valid_580363 = query.getOrDefault("alt")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = newJString("json"))
  if valid_580363 != nil:
    section.add "alt", valid_580363
  var valid_580364 = query.getOrDefault("oauth_token")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "oauth_token", valid_580364
  var valid_580365 = query.getOrDefault("userIp")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "userIp", valid_580365
  var valid_580366 = query.getOrDefault("maxResults")
  valid_580366 = validateParameter(valid_580366, JInt, required = false, default = nil)
  if valid_580366 != nil:
    section.add "maxResults", valid_580366
  var valid_580367 = query.getOrDefault("source")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "source", valid_580367
  var valid_580368 = query.getOrDefault("q")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "q", valid_580368
  var valid_580369 = query.getOrDefault("key")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = nil)
  if valid_580369 != nil:
    section.add "key", valid_580369
  var valid_580370 = query.getOrDefault("projection")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = newJString("full"))
  if valid_580370 != nil:
    section.add "projection", valid_580370
  var valid_580371 = query.getOrDefault("prettyPrint")
  valid_580371 = validateParameter(valid_580371, JBool, required = false,
                                 default = newJBool(true))
  if valid_580371 != nil:
    section.add "prettyPrint", valid_580371
  var valid_580372 = query.getOrDefault("showPreorders")
  valid_580372 = validateParameter(valid_580372, JBool, required = false, default = nil)
  if valid_580372 != nil:
    section.add "showPreorders", valid_580372
  var valid_580373 = query.getOrDefault("startIndex")
  valid_580373 = validateParameter(valid_580373, JInt, required = false, default = nil)
  if valid_580373 != nil:
    section.add "startIndex", valid_580373
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580374: Call_BooksMylibraryBookshelvesVolumesList_580356;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets volume information for volumes on a bookshelf.
  ## 
  let valid = call_580374.validator(path, query, header, formData, body)
  let scheme = call_580374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580374.url(scheme.get, call_580374.host, call_580374.base,
                         call_580374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580374, url, valid)

proc call*(call_580375: Call_BooksMylibraryBookshelvesVolumesList_580356;
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
  var path_580376 = newJObject()
  var query_580377 = newJObject()
  add(query_580377, "fields", newJString(fields))
  add(query_580377, "country", newJString(country))
  add(query_580377, "quotaUser", newJString(quotaUser))
  add(query_580377, "alt", newJString(alt))
  add(query_580377, "oauth_token", newJString(oauthToken))
  add(query_580377, "userIp", newJString(userIp))
  add(path_580376, "shelf", newJString(shelf))
  add(query_580377, "maxResults", newJInt(maxResults))
  add(query_580377, "source", newJString(source))
  add(query_580377, "q", newJString(q))
  add(query_580377, "key", newJString(key))
  add(query_580377, "projection", newJString(projection))
  add(query_580377, "prettyPrint", newJBool(prettyPrint))
  add(query_580377, "showPreorders", newJBool(showPreorders))
  add(query_580377, "startIndex", newJInt(startIndex))
  result = call_580375.call(path_580376, query_580377, nil, nil, nil)

var booksMylibraryBookshelvesVolumesList* = Call_BooksMylibraryBookshelvesVolumesList_580356(
    name: "booksMylibraryBookshelvesVolumesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/mylibrary/bookshelves/{shelf}/volumes",
    validator: validate_BooksMylibraryBookshelvesVolumesList_580357,
    base: "/books/v1", url: url_BooksMylibraryBookshelvesVolumesList_580358,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryReadingpositionsGet_580378 = ref object of OpenApiRestCall_579437
proc url_BooksMylibraryReadingpositionsGet_580380(protocol: Scheme; host: string;
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

proc validate_BooksMylibraryReadingpositionsGet_580379(path: JsonNode;
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
  var valid_580381 = path.getOrDefault("volumeId")
  valid_580381 = validateParameter(valid_580381, JString, required = true,
                                 default = nil)
  if valid_580381 != nil:
    section.add "volumeId", valid_580381
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
  var valid_580382 = query.getOrDefault("fields")
  valid_580382 = validateParameter(valid_580382, JString, required = false,
                                 default = nil)
  if valid_580382 != nil:
    section.add "fields", valid_580382
  var valid_580383 = query.getOrDefault("quotaUser")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = nil)
  if valid_580383 != nil:
    section.add "quotaUser", valid_580383
  var valid_580384 = query.getOrDefault("alt")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = newJString("json"))
  if valid_580384 != nil:
    section.add "alt", valid_580384
  var valid_580385 = query.getOrDefault("oauth_token")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = nil)
  if valid_580385 != nil:
    section.add "oauth_token", valid_580385
  var valid_580386 = query.getOrDefault("userIp")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = nil)
  if valid_580386 != nil:
    section.add "userIp", valid_580386
  var valid_580387 = query.getOrDefault("contentVersion")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "contentVersion", valid_580387
  var valid_580388 = query.getOrDefault("source")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "source", valid_580388
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580391: Call_BooksMylibraryReadingpositionsGet_580378;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves my reading position information for a volume.
  ## 
  let valid = call_580391.validator(path, query, header, formData, body)
  let scheme = call_580391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580391.url(scheme.get, call_580391.host, call_580391.base,
                         call_580391.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580391, url, valid)

proc call*(call_580392: Call_BooksMylibraryReadingpositionsGet_580378;
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
  var path_580393 = newJObject()
  var query_580394 = newJObject()
  add(query_580394, "fields", newJString(fields))
  add(query_580394, "quotaUser", newJString(quotaUser))
  add(query_580394, "alt", newJString(alt))
  add(query_580394, "oauth_token", newJString(oauthToken))
  add(query_580394, "userIp", newJString(userIp))
  add(query_580394, "contentVersion", newJString(contentVersion))
  add(query_580394, "source", newJString(source))
  add(query_580394, "key", newJString(key))
  add(path_580393, "volumeId", newJString(volumeId))
  add(query_580394, "prettyPrint", newJBool(prettyPrint))
  result = call_580392.call(path_580393, query_580394, nil, nil, nil)

var booksMylibraryReadingpositionsGet* = Call_BooksMylibraryReadingpositionsGet_580378(
    name: "booksMylibraryReadingpositionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/mylibrary/readingpositions/{volumeId}",
    validator: validate_BooksMylibraryReadingpositionsGet_580379,
    base: "/books/v1", url: url_BooksMylibraryReadingpositionsGet_580380,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryReadingpositionsSetPosition_580395 = ref object of OpenApiRestCall_579437
proc url_BooksMylibraryReadingpositionsSetPosition_580397(protocol: Scheme;
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

proc validate_BooksMylibraryReadingpositionsSetPosition_580396(path: JsonNode;
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
  var valid_580398 = path.getOrDefault("volumeId")
  valid_580398 = validateParameter(valid_580398, JString, required = true,
                                 default = nil)
  if valid_580398 != nil:
    section.add "volumeId", valid_580398
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
  var valid_580399 = query.getOrDefault("action")
  valid_580399 = validateParameter(valid_580399, JString, required = false,
                                 default = newJString("bookmark"))
  if valid_580399 != nil:
    section.add "action", valid_580399
  var valid_580400 = query.getOrDefault("fields")
  valid_580400 = validateParameter(valid_580400, JString, required = false,
                                 default = nil)
  if valid_580400 != nil:
    section.add "fields", valid_580400
  var valid_580401 = query.getOrDefault("quotaUser")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "quotaUser", valid_580401
  var valid_580402 = query.getOrDefault("alt")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = newJString("json"))
  if valid_580402 != nil:
    section.add "alt", valid_580402
  var valid_580403 = query.getOrDefault("oauth_token")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = nil)
  if valid_580403 != nil:
    section.add "oauth_token", valid_580403
  var valid_580404 = query.getOrDefault("userIp")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = nil)
  if valid_580404 != nil:
    section.add "userIp", valid_580404
  var valid_580405 = query.getOrDefault("contentVersion")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = nil)
  if valid_580405 != nil:
    section.add "contentVersion", valid_580405
  var valid_580406 = query.getOrDefault("source")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = nil)
  if valid_580406 != nil:
    section.add "source", valid_580406
  var valid_580407 = query.getOrDefault("key")
  valid_580407 = validateParameter(valid_580407, JString, required = false,
                                 default = nil)
  if valid_580407 != nil:
    section.add "key", valid_580407
  var valid_580408 = query.getOrDefault("deviceCookie")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = nil)
  if valid_580408 != nil:
    section.add "deviceCookie", valid_580408
  assert query != nil,
        "query argument is necessary due to required `timestamp` field"
  var valid_580409 = query.getOrDefault("timestamp")
  valid_580409 = validateParameter(valid_580409, JString, required = true,
                                 default = nil)
  if valid_580409 != nil:
    section.add "timestamp", valid_580409
  var valid_580410 = query.getOrDefault("prettyPrint")
  valid_580410 = validateParameter(valid_580410, JBool, required = false,
                                 default = newJBool(true))
  if valid_580410 != nil:
    section.add "prettyPrint", valid_580410
  var valid_580411 = query.getOrDefault("position")
  valid_580411 = validateParameter(valid_580411, JString, required = true,
                                 default = nil)
  if valid_580411 != nil:
    section.add "position", valid_580411
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580412: Call_BooksMylibraryReadingpositionsSetPosition_580395;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets my reading position information for a volume.
  ## 
  let valid = call_580412.validator(path, query, header, formData, body)
  let scheme = call_580412.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580412.url(scheme.get, call_580412.host, call_580412.base,
                         call_580412.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580412, url, valid)

proc call*(call_580413: Call_BooksMylibraryReadingpositionsSetPosition_580395;
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
  var path_580414 = newJObject()
  var query_580415 = newJObject()
  add(query_580415, "action", newJString(action))
  add(query_580415, "fields", newJString(fields))
  add(query_580415, "quotaUser", newJString(quotaUser))
  add(query_580415, "alt", newJString(alt))
  add(query_580415, "oauth_token", newJString(oauthToken))
  add(query_580415, "userIp", newJString(userIp))
  add(query_580415, "contentVersion", newJString(contentVersion))
  add(query_580415, "source", newJString(source))
  add(query_580415, "key", newJString(key))
  add(path_580414, "volumeId", newJString(volumeId))
  add(query_580415, "deviceCookie", newJString(deviceCookie))
  add(query_580415, "timestamp", newJString(timestamp))
  add(query_580415, "prettyPrint", newJBool(prettyPrint))
  add(query_580415, "position", newJString(position))
  result = call_580413.call(path_580414, query_580415, nil, nil, nil)

var booksMylibraryReadingpositionsSetPosition* = Call_BooksMylibraryReadingpositionsSetPosition_580395(
    name: "booksMylibraryReadingpositionsSetPosition", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/mylibrary/readingpositions/{volumeId}/setPosition",
    validator: validate_BooksMylibraryReadingpositionsSetPosition_580396,
    base: "/books/v1", url: url_BooksMylibraryReadingpositionsSetPosition_580397,
    schemes: {Scheme.Https})
type
  Call_BooksNotificationGet_580416 = ref object of OpenApiRestCall_579437
proc url_BooksNotificationGet_580418(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksNotificationGet_580417(path: JsonNode; query: JsonNode;
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
  var valid_580419 = query.getOrDefault("locale")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = nil)
  if valid_580419 != nil:
    section.add "locale", valid_580419
  var valid_580420 = query.getOrDefault("fields")
  valid_580420 = validateParameter(valid_580420, JString, required = false,
                                 default = nil)
  if valid_580420 != nil:
    section.add "fields", valid_580420
  var valid_580421 = query.getOrDefault("quotaUser")
  valid_580421 = validateParameter(valid_580421, JString, required = false,
                                 default = nil)
  if valid_580421 != nil:
    section.add "quotaUser", valid_580421
  var valid_580422 = query.getOrDefault("alt")
  valid_580422 = validateParameter(valid_580422, JString, required = false,
                                 default = newJString("json"))
  if valid_580422 != nil:
    section.add "alt", valid_580422
  var valid_580423 = query.getOrDefault("oauth_token")
  valid_580423 = validateParameter(valid_580423, JString, required = false,
                                 default = nil)
  if valid_580423 != nil:
    section.add "oauth_token", valid_580423
  var valid_580424 = query.getOrDefault("userIp")
  valid_580424 = validateParameter(valid_580424, JString, required = false,
                                 default = nil)
  if valid_580424 != nil:
    section.add "userIp", valid_580424
  var valid_580425 = query.getOrDefault("source")
  valid_580425 = validateParameter(valid_580425, JString, required = false,
                                 default = nil)
  if valid_580425 != nil:
    section.add "source", valid_580425
  var valid_580426 = query.getOrDefault("key")
  valid_580426 = validateParameter(valid_580426, JString, required = false,
                                 default = nil)
  if valid_580426 != nil:
    section.add "key", valid_580426
  var valid_580427 = query.getOrDefault("prettyPrint")
  valid_580427 = validateParameter(valid_580427, JBool, required = false,
                                 default = newJBool(true))
  if valid_580427 != nil:
    section.add "prettyPrint", valid_580427
  assert query != nil,
        "query argument is necessary due to required `notification_id` field"
  var valid_580428 = query.getOrDefault("notification_id")
  valid_580428 = validateParameter(valid_580428, JString, required = true,
                                 default = nil)
  if valid_580428 != nil:
    section.add "notification_id", valid_580428
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580429: Call_BooksNotificationGet_580416; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns notification details for a given notification id.
  ## 
  let valid = call_580429.validator(path, query, header, formData, body)
  let scheme = call_580429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580429.url(scheme.get, call_580429.host, call_580429.base,
                         call_580429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580429, url, valid)

proc call*(call_580430: Call_BooksNotificationGet_580416; notificationId: string;
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
  var query_580431 = newJObject()
  add(query_580431, "locale", newJString(locale))
  add(query_580431, "fields", newJString(fields))
  add(query_580431, "quotaUser", newJString(quotaUser))
  add(query_580431, "alt", newJString(alt))
  add(query_580431, "oauth_token", newJString(oauthToken))
  add(query_580431, "userIp", newJString(userIp))
  add(query_580431, "source", newJString(source))
  add(query_580431, "key", newJString(key))
  add(query_580431, "prettyPrint", newJBool(prettyPrint))
  add(query_580431, "notification_id", newJString(notificationId))
  result = call_580430.call(nil, query_580431, nil, nil, nil)

var booksNotificationGet* = Call_BooksNotificationGet_580416(
    name: "booksNotificationGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/notification/get",
    validator: validate_BooksNotificationGet_580417, base: "/books/v1",
    url: url_BooksNotificationGet_580418, schemes: {Scheme.Https})
type
  Call_BooksOnboardingListCategories_580432 = ref object of OpenApiRestCall_579437
proc url_BooksOnboardingListCategories_580434(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksOnboardingListCategories_580433(path: JsonNode; query: JsonNode;
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
  var valid_580435 = query.getOrDefault("locale")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "locale", valid_580435
  var valid_580436 = query.getOrDefault("fields")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = nil)
  if valid_580436 != nil:
    section.add "fields", valid_580436
  var valid_580437 = query.getOrDefault("quotaUser")
  valid_580437 = validateParameter(valid_580437, JString, required = false,
                                 default = nil)
  if valid_580437 != nil:
    section.add "quotaUser", valid_580437
  var valid_580438 = query.getOrDefault("alt")
  valid_580438 = validateParameter(valid_580438, JString, required = false,
                                 default = newJString("json"))
  if valid_580438 != nil:
    section.add "alt", valid_580438
  var valid_580439 = query.getOrDefault("oauth_token")
  valid_580439 = validateParameter(valid_580439, JString, required = false,
                                 default = nil)
  if valid_580439 != nil:
    section.add "oauth_token", valid_580439
  var valid_580440 = query.getOrDefault("userIp")
  valid_580440 = validateParameter(valid_580440, JString, required = false,
                                 default = nil)
  if valid_580440 != nil:
    section.add "userIp", valid_580440
  var valid_580441 = query.getOrDefault("key")
  valid_580441 = validateParameter(valid_580441, JString, required = false,
                                 default = nil)
  if valid_580441 != nil:
    section.add "key", valid_580441
  var valid_580442 = query.getOrDefault("prettyPrint")
  valid_580442 = validateParameter(valid_580442, JBool, required = false,
                                 default = newJBool(true))
  if valid_580442 != nil:
    section.add "prettyPrint", valid_580442
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580443: Call_BooksOnboardingListCategories_580432; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List categories for onboarding experience.
  ## 
  let valid = call_580443.validator(path, query, header, formData, body)
  let scheme = call_580443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580443.url(scheme.get, call_580443.host, call_580443.base,
                         call_580443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580443, url, valid)

proc call*(call_580444: Call_BooksOnboardingListCategories_580432;
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
  var query_580445 = newJObject()
  add(query_580445, "locale", newJString(locale))
  add(query_580445, "fields", newJString(fields))
  add(query_580445, "quotaUser", newJString(quotaUser))
  add(query_580445, "alt", newJString(alt))
  add(query_580445, "oauth_token", newJString(oauthToken))
  add(query_580445, "userIp", newJString(userIp))
  add(query_580445, "key", newJString(key))
  add(query_580445, "prettyPrint", newJBool(prettyPrint))
  result = call_580444.call(nil, query_580445, nil, nil, nil)

var booksOnboardingListCategories* = Call_BooksOnboardingListCategories_580432(
    name: "booksOnboardingListCategories", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/onboarding/listCategories",
    validator: validate_BooksOnboardingListCategories_580433, base: "/books/v1",
    url: url_BooksOnboardingListCategories_580434, schemes: {Scheme.Https})
type
  Call_BooksOnboardingListCategoryVolumes_580446 = ref object of OpenApiRestCall_579437
proc url_BooksOnboardingListCategoryVolumes_580448(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksOnboardingListCategoryVolumes_580447(path: JsonNode;
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
  var valid_580449 = query.getOrDefault("locale")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = nil)
  if valid_580449 != nil:
    section.add "locale", valid_580449
  var valid_580450 = query.getOrDefault("fields")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = nil)
  if valid_580450 != nil:
    section.add "fields", valid_580450
  var valid_580451 = query.getOrDefault("pageToken")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = nil)
  if valid_580451 != nil:
    section.add "pageToken", valid_580451
  var valid_580452 = query.getOrDefault("quotaUser")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = nil)
  if valid_580452 != nil:
    section.add "quotaUser", valid_580452
  var valid_580453 = query.getOrDefault("alt")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = newJString("json"))
  if valid_580453 != nil:
    section.add "alt", valid_580453
  var valid_580454 = query.getOrDefault("categoryId")
  valid_580454 = validateParameter(valid_580454, JArray, required = false,
                                 default = nil)
  if valid_580454 != nil:
    section.add "categoryId", valid_580454
  var valid_580455 = query.getOrDefault("oauth_token")
  valid_580455 = validateParameter(valid_580455, JString, required = false,
                                 default = nil)
  if valid_580455 != nil:
    section.add "oauth_token", valid_580455
  var valid_580456 = query.getOrDefault("userIp")
  valid_580456 = validateParameter(valid_580456, JString, required = false,
                                 default = nil)
  if valid_580456 != nil:
    section.add "userIp", valid_580456
  var valid_580457 = query.getOrDefault("key")
  valid_580457 = validateParameter(valid_580457, JString, required = false,
                                 default = nil)
  if valid_580457 != nil:
    section.add "key", valid_580457
  var valid_580458 = query.getOrDefault("pageSize")
  valid_580458 = validateParameter(valid_580458, JInt, required = false, default = nil)
  if valid_580458 != nil:
    section.add "pageSize", valid_580458
  var valid_580459 = query.getOrDefault("prettyPrint")
  valid_580459 = validateParameter(valid_580459, JBool, required = false,
                                 default = newJBool(true))
  if valid_580459 != nil:
    section.add "prettyPrint", valid_580459
  var valid_580460 = query.getOrDefault("maxAllowedMaturityRating")
  valid_580460 = validateParameter(valid_580460, JString, required = false,
                                 default = newJString("mature"))
  if valid_580460 != nil:
    section.add "maxAllowedMaturityRating", valid_580460
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580461: Call_BooksOnboardingListCategoryVolumes_580446;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List available volumes under categories for onboarding experience.
  ## 
  let valid = call_580461.validator(path, query, header, formData, body)
  let scheme = call_580461.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580461.url(scheme.get, call_580461.host, call_580461.base,
                         call_580461.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580461, url, valid)

proc call*(call_580462: Call_BooksOnboardingListCategoryVolumes_580446;
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
  var query_580463 = newJObject()
  add(query_580463, "locale", newJString(locale))
  add(query_580463, "fields", newJString(fields))
  add(query_580463, "pageToken", newJString(pageToken))
  add(query_580463, "quotaUser", newJString(quotaUser))
  add(query_580463, "alt", newJString(alt))
  if categoryId != nil:
    query_580463.add "categoryId", categoryId
  add(query_580463, "oauth_token", newJString(oauthToken))
  add(query_580463, "userIp", newJString(userIp))
  add(query_580463, "key", newJString(key))
  add(query_580463, "pageSize", newJInt(pageSize))
  add(query_580463, "prettyPrint", newJBool(prettyPrint))
  add(query_580463, "maxAllowedMaturityRating",
      newJString(maxAllowedMaturityRating))
  result = call_580462.call(nil, query_580463, nil, nil, nil)

var booksOnboardingListCategoryVolumes* = Call_BooksOnboardingListCategoryVolumes_580446(
    name: "booksOnboardingListCategoryVolumes", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/onboarding/listCategoryVolumes",
    validator: validate_BooksOnboardingListCategoryVolumes_580447,
    base: "/books/v1", url: url_BooksOnboardingListCategoryVolumes_580448,
    schemes: {Scheme.Https})
type
  Call_BooksPersonalizedstreamGet_580464 = ref object of OpenApiRestCall_579437
proc url_BooksPersonalizedstreamGet_580466(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksPersonalizedstreamGet_580465(path: JsonNode; query: JsonNode;
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
  var valid_580467 = query.getOrDefault("locale")
  valid_580467 = validateParameter(valid_580467, JString, required = false,
                                 default = nil)
  if valid_580467 != nil:
    section.add "locale", valid_580467
  var valid_580468 = query.getOrDefault("fields")
  valid_580468 = validateParameter(valid_580468, JString, required = false,
                                 default = nil)
  if valid_580468 != nil:
    section.add "fields", valid_580468
  var valid_580469 = query.getOrDefault("quotaUser")
  valid_580469 = validateParameter(valid_580469, JString, required = false,
                                 default = nil)
  if valid_580469 != nil:
    section.add "quotaUser", valid_580469
  var valid_580470 = query.getOrDefault("alt")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = newJString("json"))
  if valid_580470 != nil:
    section.add "alt", valid_580470
  var valid_580471 = query.getOrDefault("oauth_token")
  valid_580471 = validateParameter(valid_580471, JString, required = false,
                                 default = nil)
  if valid_580471 != nil:
    section.add "oauth_token", valid_580471
  var valid_580472 = query.getOrDefault("userIp")
  valid_580472 = validateParameter(valid_580472, JString, required = false,
                                 default = nil)
  if valid_580472 != nil:
    section.add "userIp", valid_580472
  var valid_580473 = query.getOrDefault("source")
  valid_580473 = validateParameter(valid_580473, JString, required = false,
                                 default = nil)
  if valid_580473 != nil:
    section.add "source", valid_580473
  var valid_580474 = query.getOrDefault("key")
  valid_580474 = validateParameter(valid_580474, JString, required = false,
                                 default = nil)
  if valid_580474 != nil:
    section.add "key", valid_580474
  var valid_580475 = query.getOrDefault("prettyPrint")
  valid_580475 = validateParameter(valid_580475, JBool, required = false,
                                 default = newJBool(true))
  if valid_580475 != nil:
    section.add "prettyPrint", valid_580475
  var valid_580476 = query.getOrDefault("maxAllowedMaturityRating")
  valid_580476 = validateParameter(valid_580476, JString, required = false,
                                 default = newJString("mature"))
  if valid_580476 != nil:
    section.add "maxAllowedMaturityRating", valid_580476
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580477: Call_BooksPersonalizedstreamGet_580464; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a stream of personalized book clusters
  ## 
  let valid = call_580477.validator(path, query, header, formData, body)
  let scheme = call_580477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580477.url(scheme.get, call_580477.host, call_580477.base,
                         call_580477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580477, url, valid)

proc call*(call_580478: Call_BooksPersonalizedstreamGet_580464;
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
  var query_580479 = newJObject()
  add(query_580479, "locale", newJString(locale))
  add(query_580479, "fields", newJString(fields))
  add(query_580479, "quotaUser", newJString(quotaUser))
  add(query_580479, "alt", newJString(alt))
  add(query_580479, "oauth_token", newJString(oauthToken))
  add(query_580479, "userIp", newJString(userIp))
  add(query_580479, "source", newJString(source))
  add(query_580479, "key", newJString(key))
  add(query_580479, "prettyPrint", newJBool(prettyPrint))
  add(query_580479, "maxAllowedMaturityRating",
      newJString(maxAllowedMaturityRating))
  result = call_580478.call(nil, query_580479, nil, nil, nil)

var booksPersonalizedstreamGet* = Call_BooksPersonalizedstreamGet_580464(
    name: "booksPersonalizedstreamGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/personalizedstream/get",
    validator: validate_BooksPersonalizedstreamGet_580465, base: "/books/v1",
    url: url_BooksPersonalizedstreamGet_580466, schemes: {Scheme.Https})
type
  Call_BooksPromoofferAccept_580480 = ref object of OpenApiRestCall_579437
proc url_BooksPromoofferAccept_580482(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksPromoofferAccept_580481(path: JsonNode; query: JsonNode;
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
  var valid_580483 = query.getOrDefault("fields")
  valid_580483 = validateParameter(valid_580483, JString, required = false,
                                 default = nil)
  if valid_580483 != nil:
    section.add "fields", valid_580483
  var valid_580484 = query.getOrDefault("quotaUser")
  valid_580484 = validateParameter(valid_580484, JString, required = false,
                                 default = nil)
  if valid_580484 != nil:
    section.add "quotaUser", valid_580484
  var valid_580485 = query.getOrDefault("alt")
  valid_580485 = validateParameter(valid_580485, JString, required = false,
                                 default = newJString("json"))
  if valid_580485 != nil:
    section.add "alt", valid_580485
  var valid_580486 = query.getOrDefault("androidId")
  valid_580486 = validateParameter(valid_580486, JString, required = false,
                                 default = nil)
  if valid_580486 != nil:
    section.add "androidId", valid_580486
  var valid_580487 = query.getOrDefault("model")
  valid_580487 = validateParameter(valid_580487, JString, required = false,
                                 default = nil)
  if valid_580487 != nil:
    section.add "model", valid_580487
  var valid_580488 = query.getOrDefault("oauth_token")
  valid_580488 = validateParameter(valid_580488, JString, required = false,
                                 default = nil)
  if valid_580488 != nil:
    section.add "oauth_token", valid_580488
  var valid_580489 = query.getOrDefault("product")
  valid_580489 = validateParameter(valid_580489, JString, required = false,
                                 default = nil)
  if valid_580489 != nil:
    section.add "product", valid_580489
  var valid_580490 = query.getOrDefault("userIp")
  valid_580490 = validateParameter(valid_580490, JString, required = false,
                                 default = nil)
  if valid_580490 != nil:
    section.add "userIp", valid_580490
  var valid_580491 = query.getOrDefault("serial")
  valid_580491 = validateParameter(valid_580491, JString, required = false,
                                 default = nil)
  if valid_580491 != nil:
    section.add "serial", valid_580491
  var valid_580492 = query.getOrDefault("key")
  valid_580492 = validateParameter(valid_580492, JString, required = false,
                                 default = nil)
  if valid_580492 != nil:
    section.add "key", valid_580492
  var valid_580493 = query.getOrDefault("device")
  valid_580493 = validateParameter(valid_580493, JString, required = false,
                                 default = nil)
  if valid_580493 != nil:
    section.add "device", valid_580493
  var valid_580494 = query.getOrDefault("manufacturer")
  valid_580494 = validateParameter(valid_580494, JString, required = false,
                                 default = nil)
  if valid_580494 != nil:
    section.add "manufacturer", valid_580494
  var valid_580495 = query.getOrDefault("offerId")
  valid_580495 = validateParameter(valid_580495, JString, required = false,
                                 default = nil)
  if valid_580495 != nil:
    section.add "offerId", valid_580495
  var valid_580496 = query.getOrDefault("volumeId")
  valid_580496 = validateParameter(valid_580496, JString, required = false,
                                 default = nil)
  if valid_580496 != nil:
    section.add "volumeId", valid_580496
  var valid_580497 = query.getOrDefault("prettyPrint")
  valid_580497 = validateParameter(valid_580497, JBool, required = false,
                                 default = newJBool(true))
  if valid_580497 != nil:
    section.add "prettyPrint", valid_580497
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580498: Call_BooksPromoofferAccept_580480; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_580498.validator(path, query, header, formData, body)
  let scheme = call_580498.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580498.url(scheme.get, call_580498.host, call_580498.base,
                         call_580498.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580498, url, valid)

proc call*(call_580499: Call_BooksPromoofferAccept_580480; fields: string = "";
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
  var query_580500 = newJObject()
  add(query_580500, "fields", newJString(fields))
  add(query_580500, "quotaUser", newJString(quotaUser))
  add(query_580500, "alt", newJString(alt))
  add(query_580500, "androidId", newJString(androidId))
  add(query_580500, "model", newJString(model))
  add(query_580500, "oauth_token", newJString(oauthToken))
  add(query_580500, "product", newJString(product))
  add(query_580500, "userIp", newJString(userIp))
  add(query_580500, "serial", newJString(serial))
  add(query_580500, "key", newJString(key))
  add(query_580500, "device", newJString(device))
  add(query_580500, "manufacturer", newJString(manufacturer))
  add(query_580500, "offerId", newJString(offerId))
  add(query_580500, "volumeId", newJString(volumeId))
  add(query_580500, "prettyPrint", newJBool(prettyPrint))
  result = call_580499.call(nil, query_580500, nil, nil, nil)

var booksPromoofferAccept* = Call_BooksPromoofferAccept_580480(
    name: "booksPromoofferAccept", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/promooffer/accept",
    validator: validate_BooksPromoofferAccept_580481, base: "/books/v1",
    url: url_BooksPromoofferAccept_580482, schemes: {Scheme.Https})
type
  Call_BooksPromoofferDismiss_580501 = ref object of OpenApiRestCall_579437
proc url_BooksPromoofferDismiss_580503(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksPromoofferDismiss_580502(path: JsonNode; query: JsonNode;
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
  var valid_580504 = query.getOrDefault("fields")
  valid_580504 = validateParameter(valid_580504, JString, required = false,
                                 default = nil)
  if valid_580504 != nil:
    section.add "fields", valid_580504
  var valid_580505 = query.getOrDefault("quotaUser")
  valid_580505 = validateParameter(valid_580505, JString, required = false,
                                 default = nil)
  if valid_580505 != nil:
    section.add "quotaUser", valid_580505
  var valid_580506 = query.getOrDefault("alt")
  valid_580506 = validateParameter(valid_580506, JString, required = false,
                                 default = newJString("json"))
  if valid_580506 != nil:
    section.add "alt", valid_580506
  var valid_580507 = query.getOrDefault("androidId")
  valid_580507 = validateParameter(valid_580507, JString, required = false,
                                 default = nil)
  if valid_580507 != nil:
    section.add "androidId", valid_580507
  var valid_580508 = query.getOrDefault("model")
  valid_580508 = validateParameter(valid_580508, JString, required = false,
                                 default = nil)
  if valid_580508 != nil:
    section.add "model", valid_580508
  var valid_580509 = query.getOrDefault("oauth_token")
  valid_580509 = validateParameter(valid_580509, JString, required = false,
                                 default = nil)
  if valid_580509 != nil:
    section.add "oauth_token", valid_580509
  var valid_580510 = query.getOrDefault("product")
  valid_580510 = validateParameter(valid_580510, JString, required = false,
                                 default = nil)
  if valid_580510 != nil:
    section.add "product", valid_580510
  var valid_580511 = query.getOrDefault("userIp")
  valid_580511 = validateParameter(valid_580511, JString, required = false,
                                 default = nil)
  if valid_580511 != nil:
    section.add "userIp", valid_580511
  var valid_580512 = query.getOrDefault("serial")
  valid_580512 = validateParameter(valid_580512, JString, required = false,
                                 default = nil)
  if valid_580512 != nil:
    section.add "serial", valid_580512
  var valid_580513 = query.getOrDefault("key")
  valid_580513 = validateParameter(valid_580513, JString, required = false,
                                 default = nil)
  if valid_580513 != nil:
    section.add "key", valid_580513
  var valid_580514 = query.getOrDefault("device")
  valid_580514 = validateParameter(valid_580514, JString, required = false,
                                 default = nil)
  if valid_580514 != nil:
    section.add "device", valid_580514
  var valid_580515 = query.getOrDefault("manufacturer")
  valid_580515 = validateParameter(valid_580515, JString, required = false,
                                 default = nil)
  if valid_580515 != nil:
    section.add "manufacturer", valid_580515
  var valid_580516 = query.getOrDefault("offerId")
  valid_580516 = validateParameter(valid_580516, JString, required = false,
                                 default = nil)
  if valid_580516 != nil:
    section.add "offerId", valid_580516
  var valid_580517 = query.getOrDefault("prettyPrint")
  valid_580517 = validateParameter(valid_580517, JBool, required = false,
                                 default = newJBool(true))
  if valid_580517 != nil:
    section.add "prettyPrint", valid_580517
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580518: Call_BooksPromoofferDismiss_580501; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_580518.validator(path, query, header, formData, body)
  let scheme = call_580518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580518.url(scheme.get, call_580518.host, call_580518.base,
                         call_580518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580518, url, valid)

proc call*(call_580519: Call_BooksPromoofferDismiss_580501; fields: string = "";
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
  var query_580520 = newJObject()
  add(query_580520, "fields", newJString(fields))
  add(query_580520, "quotaUser", newJString(quotaUser))
  add(query_580520, "alt", newJString(alt))
  add(query_580520, "androidId", newJString(androidId))
  add(query_580520, "model", newJString(model))
  add(query_580520, "oauth_token", newJString(oauthToken))
  add(query_580520, "product", newJString(product))
  add(query_580520, "userIp", newJString(userIp))
  add(query_580520, "serial", newJString(serial))
  add(query_580520, "key", newJString(key))
  add(query_580520, "device", newJString(device))
  add(query_580520, "manufacturer", newJString(manufacturer))
  add(query_580520, "offerId", newJString(offerId))
  add(query_580520, "prettyPrint", newJBool(prettyPrint))
  result = call_580519.call(nil, query_580520, nil, nil, nil)

var booksPromoofferDismiss* = Call_BooksPromoofferDismiss_580501(
    name: "booksPromoofferDismiss", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/promooffer/dismiss",
    validator: validate_BooksPromoofferDismiss_580502, base: "/books/v1",
    url: url_BooksPromoofferDismiss_580503, schemes: {Scheme.Https})
type
  Call_BooksPromoofferGet_580521 = ref object of OpenApiRestCall_579437
proc url_BooksPromoofferGet_580523(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksPromoofferGet_580522(path: JsonNode; query: JsonNode;
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
  var valid_580524 = query.getOrDefault("fields")
  valid_580524 = validateParameter(valid_580524, JString, required = false,
                                 default = nil)
  if valid_580524 != nil:
    section.add "fields", valid_580524
  var valid_580525 = query.getOrDefault("quotaUser")
  valid_580525 = validateParameter(valid_580525, JString, required = false,
                                 default = nil)
  if valid_580525 != nil:
    section.add "quotaUser", valid_580525
  var valid_580526 = query.getOrDefault("alt")
  valid_580526 = validateParameter(valid_580526, JString, required = false,
                                 default = newJString("json"))
  if valid_580526 != nil:
    section.add "alt", valid_580526
  var valid_580527 = query.getOrDefault("androidId")
  valid_580527 = validateParameter(valid_580527, JString, required = false,
                                 default = nil)
  if valid_580527 != nil:
    section.add "androidId", valid_580527
  var valid_580528 = query.getOrDefault("model")
  valid_580528 = validateParameter(valid_580528, JString, required = false,
                                 default = nil)
  if valid_580528 != nil:
    section.add "model", valid_580528
  var valid_580529 = query.getOrDefault("oauth_token")
  valid_580529 = validateParameter(valid_580529, JString, required = false,
                                 default = nil)
  if valid_580529 != nil:
    section.add "oauth_token", valid_580529
  var valid_580530 = query.getOrDefault("product")
  valid_580530 = validateParameter(valid_580530, JString, required = false,
                                 default = nil)
  if valid_580530 != nil:
    section.add "product", valid_580530
  var valid_580531 = query.getOrDefault("userIp")
  valid_580531 = validateParameter(valid_580531, JString, required = false,
                                 default = nil)
  if valid_580531 != nil:
    section.add "userIp", valid_580531
  var valid_580532 = query.getOrDefault("serial")
  valid_580532 = validateParameter(valid_580532, JString, required = false,
                                 default = nil)
  if valid_580532 != nil:
    section.add "serial", valid_580532
  var valid_580533 = query.getOrDefault("key")
  valid_580533 = validateParameter(valid_580533, JString, required = false,
                                 default = nil)
  if valid_580533 != nil:
    section.add "key", valid_580533
  var valid_580534 = query.getOrDefault("device")
  valid_580534 = validateParameter(valid_580534, JString, required = false,
                                 default = nil)
  if valid_580534 != nil:
    section.add "device", valid_580534
  var valid_580535 = query.getOrDefault("manufacturer")
  valid_580535 = validateParameter(valid_580535, JString, required = false,
                                 default = nil)
  if valid_580535 != nil:
    section.add "manufacturer", valid_580535
  var valid_580536 = query.getOrDefault("prettyPrint")
  valid_580536 = validateParameter(valid_580536, JBool, required = false,
                                 default = newJBool(true))
  if valid_580536 != nil:
    section.add "prettyPrint", valid_580536
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580537: Call_BooksPromoofferGet_580521; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of promo offers available to the user
  ## 
  let valid = call_580537.validator(path, query, header, formData, body)
  let scheme = call_580537.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580537.url(scheme.get, call_580537.host, call_580537.base,
                         call_580537.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580537, url, valid)

proc call*(call_580538: Call_BooksPromoofferGet_580521; fields: string = "";
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
  var query_580539 = newJObject()
  add(query_580539, "fields", newJString(fields))
  add(query_580539, "quotaUser", newJString(quotaUser))
  add(query_580539, "alt", newJString(alt))
  add(query_580539, "androidId", newJString(androidId))
  add(query_580539, "model", newJString(model))
  add(query_580539, "oauth_token", newJString(oauthToken))
  add(query_580539, "product", newJString(product))
  add(query_580539, "userIp", newJString(userIp))
  add(query_580539, "serial", newJString(serial))
  add(query_580539, "key", newJString(key))
  add(query_580539, "device", newJString(device))
  add(query_580539, "manufacturer", newJString(manufacturer))
  add(query_580539, "prettyPrint", newJBool(prettyPrint))
  result = call_580538.call(nil, query_580539, nil, nil, nil)

var booksPromoofferGet* = Call_BooksPromoofferGet_580521(
    name: "booksPromoofferGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/promooffer/get",
    validator: validate_BooksPromoofferGet_580522, base: "/books/v1",
    url: url_BooksPromoofferGet_580523, schemes: {Scheme.Https})
type
  Call_BooksSeriesGet_580540 = ref object of OpenApiRestCall_579437
proc url_BooksSeriesGet_580542(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksSeriesGet_580541(path: JsonNode; query: JsonNode;
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
  var valid_580543 = query.getOrDefault("series_id")
  valid_580543 = validateParameter(valid_580543, JArray, required = true, default = nil)
  if valid_580543 != nil:
    section.add "series_id", valid_580543
  var valid_580544 = query.getOrDefault("fields")
  valid_580544 = validateParameter(valid_580544, JString, required = false,
                                 default = nil)
  if valid_580544 != nil:
    section.add "fields", valid_580544
  var valid_580545 = query.getOrDefault("quotaUser")
  valid_580545 = validateParameter(valid_580545, JString, required = false,
                                 default = nil)
  if valid_580545 != nil:
    section.add "quotaUser", valid_580545
  var valid_580546 = query.getOrDefault("alt")
  valid_580546 = validateParameter(valid_580546, JString, required = false,
                                 default = newJString("json"))
  if valid_580546 != nil:
    section.add "alt", valid_580546
  var valid_580547 = query.getOrDefault("oauth_token")
  valid_580547 = validateParameter(valid_580547, JString, required = false,
                                 default = nil)
  if valid_580547 != nil:
    section.add "oauth_token", valid_580547
  var valid_580548 = query.getOrDefault("userIp")
  valid_580548 = validateParameter(valid_580548, JString, required = false,
                                 default = nil)
  if valid_580548 != nil:
    section.add "userIp", valid_580548
  var valid_580549 = query.getOrDefault("key")
  valid_580549 = validateParameter(valid_580549, JString, required = false,
                                 default = nil)
  if valid_580549 != nil:
    section.add "key", valid_580549
  var valid_580550 = query.getOrDefault("prettyPrint")
  valid_580550 = validateParameter(valid_580550, JBool, required = false,
                                 default = newJBool(true))
  if valid_580550 != nil:
    section.add "prettyPrint", valid_580550
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580551: Call_BooksSeriesGet_580540; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Series metadata for the given series ids.
  ## 
  let valid = call_580551.validator(path, query, header, formData, body)
  let scheme = call_580551.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580551.url(scheme.get, call_580551.host, call_580551.base,
                         call_580551.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580551, url, valid)

proc call*(call_580552: Call_BooksSeriesGet_580540; seriesId: JsonNode;
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
  var query_580553 = newJObject()
  if seriesId != nil:
    query_580553.add "series_id", seriesId
  add(query_580553, "fields", newJString(fields))
  add(query_580553, "quotaUser", newJString(quotaUser))
  add(query_580553, "alt", newJString(alt))
  add(query_580553, "oauth_token", newJString(oauthToken))
  add(query_580553, "userIp", newJString(userIp))
  add(query_580553, "key", newJString(key))
  add(query_580553, "prettyPrint", newJBool(prettyPrint))
  result = call_580552.call(nil, query_580553, nil, nil, nil)

var booksSeriesGet* = Call_BooksSeriesGet_580540(name: "booksSeriesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/series/get",
    validator: validate_BooksSeriesGet_580541, base: "/books/v1",
    url: url_BooksSeriesGet_580542, schemes: {Scheme.Https})
type
  Call_BooksSeriesMembershipGet_580554 = ref object of OpenApiRestCall_579437
proc url_BooksSeriesMembershipGet_580556(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksSeriesMembershipGet_580555(path: JsonNode; query: JsonNode;
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
  var valid_580557 = query.getOrDefault("series_id")
  valid_580557 = validateParameter(valid_580557, JString, required = true,
                                 default = nil)
  if valid_580557 != nil:
    section.add "series_id", valid_580557
  var valid_580558 = query.getOrDefault("fields")
  valid_580558 = validateParameter(valid_580558, JString, required = false,
                                 default = nil)
  if valid_580558 != nil:
    section.add "fields", valid_580558
  var valid_580559 = query.getOrDefault("page_token")
  valid_580559 = validateParameter(valid_580559, JString, required = false,
                                 default = nil)
  if valid_580559 != nil:
    section.add "page_token", valid_580559
  var valid_580560 = query.getOrDefault("quotaUser")
  valid_580560 = validateParameter(valid_580560, JString, required = false,
                                 default = nil)
  if valid_580560 != nil:
    section.add "quotaUser", valid_580560
  var valid_580561 = query.getOrDefault("alt")
  valid_580561 = validateParameter(valid_580561, JString, required = false,
                                 default = newJString("json"))
  if valid_580561 != nil:
    section.add "alt", valid_580561
  var valid_580562 = query.getOrDefault("oauth_token")
  valid_580562 = validateParameter(valid_580562, JString, required = false,
                                 default = nil)
  if valid_580562 != nil:
    section.add "oauth_token", valid_580562
  var valid_580563 = query.getOrDefault("userIp")
  valid_580563 = validateParameter(valid_580563, JString, required = false,
                                 default = nil)
  if valid_580563 != nil:
    section.add "userIp", valid_580563
  var valid_580564 = query.getOrDefault("page_size")
  valid_580564 = validateParameter(valid_580564, JInt, required = false, default = nil)
  if valid_580564 != nil:
    section.add "page_size", valid_580564
  var valid_580565 = query.getOrDefault("key")
  valid_580565 = validateParameter(valid_580565, JString, required = false,
                                 default = nil)
  if valid_580565 != nil:
    section.add "key", valid_580565
  var valid_580566 = query.getOrDefault("prettyPrint")
  valid_580566 = validateParameter(valid_580566, JBool, required = false,
                                 default = newJBool(true))
  if valid_580566 != nil:
    section.add "prettyPrint", valid_580566
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580567: Call_BooksSeriesMembershipGet_580554; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Series membership data given the series id.
  ## 
  let valid = call_580567.validator(path, query, header, formData, body)
  let scheme = call_580567.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580567.url(scheme.get, call_580567.host, call_580567.base,
                         call_580567.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580567, url, valid)

proc call*(call_580568: Call_BooksSeriesMembershipGet_580554; seriesId: string;
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
  var query_580569 = newJObject()
  add(query_580569, "series_id", newJString(seriesId))
  add(query_580569, "fields", newJString(fields))
  add(query_580569, "page_token", newJString(pageToken))
  add(query_580569, "quotaUser", newJString(quotaUser))
  add(query_580569, "alt", newJString(alt))
  add(query_580569, "oauth_token", newJString(oauthToken))
  add(query_580569, "userIp", newJString(userIp))
  add(query_580569, "page_size", newJInt(pageSize))
  add(query_580569, "key", newJString(key))
  add(query_580569, "prettyPrint", newJBool(prettyPrint))
  result = call_580568.call(nil, query_580569, nil, nil, nil)

var booksSeriesMembershipGet* = Call_BooksSeriesMembershipGet_580554(
    name: "booksSeriesMembershipGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/series/membership/get",
    validator: validate_BooksSeriesMembershipGet_580555, base: "/books/v1",
    url: url_BooksSeriesMembershipGet_580556, schemes: {Scheme.Https})
type
  Call_BooksBookshelvesList_580570 = ref object of OpenApiRestCall_579437
proc url_BooksBookshelvesList_580572(protocol: Scheme; host: string; base: string;
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

proc validate_BooksBookshelvesList_580571(path: JsonNode; query: JsonNode;
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
  var valid_580573 = path.getOrDefault("userId")
  valid_580573 = validateParameter(valid_580573, JString, required = true,
                                 default = nil)
  if valid_580573 != nil:
    section.add "userId", valid_580573
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
  var valid_580574 = query.getOrDefault("fields")
  valid_580574 = validateParameter(valid_580574, JString, required = false,
                                 default = nil)
  if valid_580574 != nil:
    section.add "fields", valid_580574
  var valid_580575 = query.getOrDefault("quotaUser")
  valid_580575 = validateParameter(valid_580575, JString, required = false,
                                 default = nil)
  if valid_580575 != nil:
    section.add "quotaUser", valid_580575
  var valid_580576 = query.getOrDefault("alt")
  valid_580576 = validateParameter(valid_580576, JString, required = false,
                                 default = newJString("json"))
  if valid_580576 != nil:
    section.add "alt", valid_580576
  var valid_580577 = query.getOrDefault("oauth_token")
  valid_580577 = validateParameter(valid_580577, JString, required = false,
                                 default = nil)
  if valid_580577 != nil:
    section.add "oauth_token", valid_580577
  var valid_580578 = query.getOrDefault("userIp")
  valid_580578 = validateParameter(valid_580578, JString, required = false,
                                 default = nil)
  if valid_580578 != nil:
    section.add "userIp", valid_580578
  var valid_580579 = query.getOrDefault("source")
  valid_580579 = validateParameter(valid_580579, JString, required = false,
                                 default = nil)
  if valid_580579 != nil:
    section.add "source", valid_580579
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580582: Call_BooksBookshelvesList_580570; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of public bookshelves for the specified user.
  ## 
  let valid = call_580582.validator(path, query, header, formData, body)
  let scheme = call_580582.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580582.url(scheme.get, call_580582.host, call_580582.base,
                         call_580582.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580582, url, valid)

proc call*(call_580583: Call_BooksBookshelvesList_580570; userId: string;
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
  var path_580584 = newJObject()
  var query_580585 = newJObject()
  add(query_580585, "fields", newJString(fields))
  add(query_580585, "quotaUser", newJString(quotaUser))
  add(query_580585, "alt", newJString(alt))
  add(query_580585, "oauth_token", newJString(oauthToken))
  add(query_580585, "userIp", newJString(userIp))
  add(query_580585, "source", newJString(source))
  add(query_580585, "key", newJString(key))
  add(query_580585, "prettyPrint", newJBool(prettyPrint))
  add(path_580584, "userId", newJString(userId))
  result = call_580583.call(path_580584, query_580585, nil, nil, nil)

var booksBookshelvesList* = Call_BooksBookshelvesList_580570(
    name: "booksBookshelvesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userId}/bookshelves",
    validator: validate_BooksBookshelvesList_580571, base: "/books/v1",
    url: url_BooksBookshelvesList_580572, schemes: {Scheme.Https})
type
  Call_BooksBookshelvesGet_580586 = ref object of OpenApiRestCall_579437
proc url_BooksBookshelvesGet_580588(protocol: Scheme; host: string; base: string;
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

proc validate_BooksBookshelvesGet_580587(path: JsonNode; query: JsonNode;
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
  var valid_580589 = path.getOrDefault("shelf")
  valid_580589 = validateParameter(valid_580589, JString, required = true,
                                 default = nil)
  if valid_580589 != nil:
    section.add "shelf", valid_580589
  var valid_580590 = path.getOrDefault("userId")
  valid_580590 = validateParameter(valid_580590, JString, required = true,
                                 default = nil)
  if valid_580590 != nil:
    section.add "userId", valid_580590
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
  var valid_580591 = query.getOrDefault("fields")
  valid_580591 = validateParameter(valid_580591, JString, required = false,
                                 default = nil)
  if valid_580591 != nil:
    section.add "fields", valid_580591
  var valid_580592 = query.getOrDefault("quotaUser")
  valid_580592 = validateParameter(valid_580592, JString, required = false,
                                 default = nil)
  if valid_580592 != nil:
    section.add "quotaUser", valid_580592
  var valid_580593 = query.getOrDefault("alt")
  valid_580593 = validateParameter(valid_580593, JString, required = false,
                                 default = newJString("json"))
  if valid_580593 != nil:
    section.add "alt", valid_580593
  var valid_580594 = query.getOrDefault("oauth_token")
  valid_580594 = validateParameter(valid_580594, JString, required = false,
                                 default = nil)
  if valid_580594 != nil:
    section.add "oauth_token", valid_580594
  var valid_580595 = query.getOrDefault("userIp")
  valid_580595 = validateParameter(valid_580595, JString, required = false,
                                 default = nil)
  if valid_580595 != nil:
    section.add "userIp", valid_580595
  var valid_580596 = query.getOrDefault("source")
  valid_580596 = validateParameter(valid_580596, JString, required = false,
                                 default = nil)
  if valid_580596 != nil:
    section.add "source", valid_580596
  var valid_580597 = query.getOrDefault("key")
  valid_580597 = validateParameter(valid_580597, JString, required = false,
                                 default = nil)
  if valid_580597 != nil:
    section.add "key", valid_580597
  var valid_580598 = query.getOrDefault("prettyPrint")
  valid_580598 = validateParameter(valid_580598, JBool, required = false,
                                 default = newJBool(true))
  if valid_580598 != nil:
    section.add "prettyPrint", valid_580598
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580599: Call_BooksBookshelvesGet_580586; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves metadata for a specific bookshelf for the specified user.
  ## 
  let valid = call_580599.validator(path, query, header, formData, body)
  let scheme = call_580599.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580599.url(scheme.get, call_580599.host, call_580599.base,
                         call_580599.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580599, url, valid)

proc call*(call_580600: Call_BooksBookshelvesGet_580586; shelf: string;
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
  var path_580601 = newJObject()
  var query_580602 = newJObject()
  add(query_580602, "fields", newJString(fields))
  add(query_580602, "quotaUser", newJString(quotaUser))
  add(query_580602, "alt", newJString(alt))
  add(query_580602, "oauth_token", newJString(oauthToken))
  add(query_580602, "userIp", newJString(userIp))
  add(path_580601, "shelf", newJString(shelf))
  add(query_580602, "source", newJString(source))
  add(query_580602, "key", newJString(key))
  add(query_580602, "prettyPrint", newJBool(prettyPrint))
  add(path_580601, "userId", newJString(userId))
  result = call_580600.call(path_580601, query_580602, nil, nil, nil)

var booksBookshelvesGet* = Call_BooksBookshelvesGet_580586(
    name: "booksBookshelvesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userId}/bookshelves/{shelf}",
    validator: validate_BooksBookshelvesGet_580587, base: "/books/v1",
    url: url_BooksBookshelvesGet_580588, schemes: {Scheme.Https})
type
  Call_BooksBookshelvesVolumesList_580603 = ref object of OpenApiRestCall_579437
proc url_BooksBookshelvesVolumesList_580605(protocol: Scheme; host: string;
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

proc validate_BooksBookshelvesVolumesList_580604(path: JsonNode; query: JsonNode;
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
  var valid_580606 = path.getOrDefault("shelf")
  valid_580606 = validateParameter(valid_580606, JString, required = true,
                                 default = nil)
  if valid_580606 != nil:
    section.add "shelf", valid_580606
  var valid_580607 = path.getOrDefault("userId")
  valid_580607 = validateParameter(valid_580607, JString, required = true,
                                 default = nil)
  if valid_580607 != nil:
    section.add "userId", valid_580607
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
  var valid_580608 = query.getOrDefault("fields")
  valid_580608 = validateParameter(valid_580608, JString, required = false,
                                 default = nil)
  if valid_580608 != nil:
    section.add "fields", valid_580608
  var valid_580609 = query.getOrDefault("quotaUser")
  valid_580609 = validateParameter(valid_580609, JString, required = false,
                                 default = nil)
  if valid_580609 != nil:
    section.add "quotaUser", valid_580609
  var valid_580610 = query.getOrDefault("alt")
  valid_580610 = validateParameter(valid_580610, JString, required = false,
                                 default = newJString("json"))
  if valid_580610 != nil:
    section.add "alt", valid_580610
  var valid_580611 = query.getOrDefault("oauth_token")
  valid_580611 = validateParameter(valid_580611, JString, required = false,
                                 default = nil)
  if valid_580611 != nil:
    section.add "oauth_token", valid_580611
  var valid_580612 = query.getOrDefault("userIp")
  valid_580612 = validateParameter(valid_580612, JString, required = false,
                                 default = nil)
  if valid_580612 != nil:
    section.add "userIp", valid_580612
  var valid_580613 = query.getOrDefault("maxResults")
  valid_580613 = validateParameter(valid_580613, JInt, required = false, default = nil)
  if valid_580613 != nil:
    section.add "maxResults", valid_580613
  var valid_580614 = query.getOrDefault("source")
  valid_580614 = validateParameter(valid_580614, JString, required = false,
                                 default = nil)
  if valid_580614 != nil:
    section.add "source", valid_580614
  var valid_580615 = query.getOrDefault("key")
  valid_580615 = validateParameter(valid_580615, JString, required = false,
                                 default = nil)
  if valid_580615 != nil:
    section.add "key", valid_580615
  var valid_580616 = query.getOrDefault("prettyPrint")
  valid_580616 = validateParameter(valid_580616, JBool, required = false,
                                 default = newJBool(true))
  if valid_580616 != nil:
    section.add "prettyPrint", valid_580616
  var valid_580617 = query.getOrDefault("showPreorders")
  valid_580617 = validateParameter(valid_580617, JBool, required = false, default = nil)
  if valid_580617 != nil:
    section.add "showPreorders", valid_580617
  var valid_580618 = query.getOrDefault("startIndex")
  valid_580618 = validateParameter(valid_580618, JInt, required = false, default = nil)
  if valid_580618 != nil:
    section.add "startIndex", valid_580618
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580619: Call_BooksBookshelvesVolumesList_580603; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves volumes in a specific bookshelf for the specified user.
  ## 
  let valid = call_580619.validator(path, query, header, formData, body)
  let scheme = call_580619.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580619.url(scheme.get, call_580619.host, call_580619.base,
                         call_580619.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580619, url, valid)

proc call*(call_580620: Call_BooksBookshelvesVolumesList_580603; shelf: string;
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
  var path_580621 = newJObject()
  var query_580622 = newJObject()
  add(query_580622, "fields", newJString(fields))
  add(query_580622, "quotaUser", newJString(quotaUser))
  add(query_580622, "alt", newJString(alt))
  add(query_580622, "oauth_token", newJString(oauthToken))
  add(query_580622, "userIp", newJString(userIp))
  add(path_580621, "shelf", newJString(shelf))
  add(query_580622, "maxResults", newJInt(maxResults))
  add(query_580622, "source", newJString(source))
  add(query_580622, "key", newJString(key))
  add(query_580622, "prettyPrint", newJBool(prettyPrint))
  add(query_580622, "showPreorders", newJBool(showPreorders))
  add(path_580621, "userId", newJString(userId))
  add(query_580622, "startIndex", newJInt(startIndex))
  result = call_580620.call(path_580621, query_580622, nil, nil, nil)

var booksBookshelvesVolumesList* = Call_BooksBookshelvesVolumesList_580603(
    name: "booksBookshelvesVolumesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/users/{userId}/bookshelves/{shelf}/volumes",
    validator: validate_BooksBookshelvesVolumesList_580604, base: "/books/v1",
    url: url_BooksBookshelvesVolumesList_580605, schemes: {Scheme.Https})
type
  Call_BooksVolumesList_580623 = ref object of OpenApiRestCall_579437
proc url_BooksVolumesList_580625(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksVolumesList_580624(path: JsonNode; query: JsonNode;
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
  var valid_580626 = query.getOrDefault("libraryRestrict")
  valid_580626 = validateParameter(valid_580626, JString, required = false,
                                 default = newJString("my-library"))
  if valid_580626 != nil:
    section.add "libraryRestrict", valid_580626
  var valid_580627 = query.getOrDefault("fields")
  valid_580627 = validateParameter(valid_580627, JString, required = false,
                                 default = nil)
  if valid_580627 != nil:
    section.add "fields", valid_580627
  var valid_580628 = query.getOrDefault("quotaUser")
  valid_580628 = validateParameter(valid_580628, JString, required = false,
                                 default = nil)
  if valid_580628 != nil:
    section.add "quotaUser", valid_580628
  var valid_580629 = query.getOrDefault("alt")
  valid_580629 = validateParameter(valid_580629, JString, required = false,
                                 default = newJString("json"))
  if valid_580629 != nil:
    section.add "alt", valid_580629
  var valid_580630 = query.getOrDefault("oauth_token")
  valid_580630 = validateParameter(valid_580630, JString, required = false,
                                 default = nil)
  if valid_580630 != nil:
    section.add "oauth_token", valid_580630
  var valid_580631 = query.getOrDefault("userIp")
  valid_580631 = validateParameter(valid_580631, JString, required = false,
                                 default = nil)
  if valid_580631 != nil:
    section.add "userIp", valid_580631
  var valid_580632 = query.getOrDefault("langRestrict")
  valid_580632 = validateParameter(valid_580632, JString, required = false,
                                 default = nil)
  if valid_580632 != nil:
    section.add "langRestrict", valid_580632
  var valid_580633 = query.getOrDefault("maxResults")
  valid_580633 = validateParameter(valid_580633, JInt, required = false, default = nil)
  if valid_580633 != nil:
    section.add "maxResults", valid_580633
  var valid_580634 = query.getOrDefault("orderBy")
  valid_580634 = validateParameter(valid_580634, JString, required = false,
                                 default = newJString("newest"))
  if valid_580634 != nil:
    section.add "orderBy", valid_580634
  var valid_580635 = query.getOrDefault("source")
  valid_580635 = validateParameter(valid_580635, JString, required = false,
                                 default = nil)
  if valid_580635 != nil:
    section.add "source", valid_580635
  assert query != nil, "query argument is necessary due to required `q` field"
  var valid_580636 = query.getOrDefault("q")
  valid_580636 = validateParameter(valid_580636, JString, required = true,
                                 default = nil)
  if valid_580636 != nil:
    section.add "q", valid_580636
  var valid_580637 = query.getOrDefault("key")
  valid_580637 = validateParameter(valid_580637, JString, required = false,
                                 default = nil)
  if valid_580637 != nil:
    section.add "key", valid_580637
  var valid_580638 = query.getOrDefault("projection")
  valid_580638 = validateParameter(valid_580638, JString, required = false,
                                 default = newJString("full"))
  if valid_580638 != nil:
    section.add "projection", valid_580638
  var valid_580639 = query.getOrDefault("partner")
  valid_580639 = validateParameter(valid_580639, JString, required = false,
                                 default = nil)
  if valid_580639 != nil:
    section.add "partner", valid_580639
  var valid_580640 = query.getOrDefault("download")
  valid_580640 = validateParameter(valid_580640, JString, required = false,
                                 default = newJString("epub"))
  if valid_580640 != nil:
    section.add "download", valid_580640
  var valid_580641 = query.getOrDefault("prettyPrint")
  valid_580641 = validateParameter(valid_580641, JBool, required = false,
                                 default = newJBool(true))
  if valid_580641 != nil:
    section.add "prettyPrint", valid_580641
  var valid_580642 = query.getOrDefault("maxAllowedMaturityRating")
  valid_580642 = validateParameter(valid_580642, JString, required = false,
                                 default = newJString("mature"))
  if valid_580642 != nil:
    section.add "maxAllowedMaturityRating", valid_580642
  var valid_580643 = query.getOrDefault("showPreorders")
  valid_580643 = validateParameter(valid_580643, JBool, required = false, default = nil)
  if valid_580643 != nil:
    section.add "showPreorders", valid_580643
  var valid_580644 = query.getOrDefault("filter")
  valid_580644 = validateParameter(valid_580644, JString, required = false,
                                 default = newJString("ebooks"))
  if valid_580644 != nil:
    section.add "filter", valid_580644
  var valid_580645 = query.getOrDefault("printType")
  valid_580645 = validateParameter(valid_580645, JString, required = false,
                                 default = newJString("all"))
  if valid_580645 != nil:
    section.add "printType", valid_580645
  var valid_580646 = query.getOrDefault("startIndex")
  valid_580646 = validateParameter(valid_580646, JInt, required = false, default = nil)
  if valid_580646 != nil:
    section.add "startIndex", valid_580646
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580647: Call_BooksVolumesList_580623; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs a book search.
  ## 
  let valid = call_580647.validator(path, query, header, formData, body)
  let scheme = call_580647.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580647.url(scheme.get, call_580647.host, call_580647.base,
                         call_580647.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580647, url, valid)

proc call*(call_580648: Call_BooksVolumesList_580623; q: string;
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
  var query_580649 = newJObject()
  add(query_580649, "libraryRestrict", newJString(libraryRestrict))
  add(query_580649, "fields", newJString(fields))
  add(query_580649, "quotaUser", newJString(quotaUser))
  add(query_580649, "alt", newJString(alt))
  add(query_580649, "oauth_token", newJString(oauthToken))
  add(query_580649, "userIp", newJString(userIp))
  add(query_580649, "langRestrict", newJString(langRestrict))
  add(query_580649, "maxResults", newJInt(maxResults))
  add(query_580649, "orderBy", newJString(orderBy))
  add(query_580649, "source", newJString(source))
  add(query_580649, "q", newJString(q))
  add(query_580649, "key", newJString(key))
  add(query_580649, "projection", newJString(projection))
  add(query_580649, "partner", newJString(partner))
  add(query_580649, "download", newJString(download))
  add(query_580649, "prettyPrint", newJBool(prettyPrint))
  add(query_580649, "maxAllowedMaturityRating",
      newJString(maxAllowedMaturityRating))
  add(query_580649, "showPreorders", newJBool(showPreorders))
  add(query_580649, "filter", newJString(filter))
  add(query_580649, "printType", newJString(printType))
  add(query_580649, "startIndex", newJInt(startIndex))
  result = call_580648.call(nil, query_580649, nil, nil, nil)

var booksVolumesList* = Call_BooksVolumesList_580623(name: "booksVolumesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/volumes",
    validator: validate_BooksVolumesList_580624, base: "/books/v1",
    url: url_BooksVolumesList_580625, schemes: {Scheme.Https})
type
  Call_BooksVolumesMybooksList_580650 = ref object of OpenApiRestCall_579437
proc url_BooksVolumesMybooksList_580652(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksVolumesMybooksList_580651(path: JsonNode; query: JsonNode;
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
  var valid_580653 = query.getOrDefault("locale")
  valid_580653 = validateParameter(valid_580653, JString, required = false,
                                 default = nil)
  if valid_580653 != nil:
    section.add "locale", valid_580653
  var valid_580654 = query.getOrDefault("fields")
  valid_580654 = validateParameter(valid_580654, JString, required = false,
                                 default = nil)
  if valid_580654 != nil:
    section.add "fields", valid_580654
  var valid_580655 = query.getOrDefault("country")
  valid_580655 = validateParameter(valid_580655, JString, required = false,
                                 default = nil)
  if valid_580655 != nil:
    section.add "country", valid_580655
  var valid_580656 = query.getOrDefault("quotaUser")
  valid_580656 = validateParameter(valid_580656, JString, required = false,
                                 default = nil)
  if valid_580656 != nil:
    section.add "quotaUser", valid_580656
  var valid_580657 = query.getOrDefault("processingState")
  valid_580657 = validateParameter(valid_580657, JArray, required = false,
                                 default = nil)
  if valid_580657 != nil:
    section.add "processingState", valid_580657
  var valid_580658 = query.getOrDefault("alt")
  valid_580658 = validateParameter(valid_580658, JString, required = false,
                                 default = newJString("json"))
  if valid_580658 != nil:
    section.add "alt", valid_580658
  var valid_580659 = query.getOrDefault("oauth_token")
  valid_580659 = validateParameter(valid_580659, JString, required = false,
                                 default = nil)
  if valid_580659 != nil:
    section.add "oauth_token", valid_580659
  var valid_580660 = query.getOrDefault("userIp")
  valid_580660 = validateParameter(valid_580660, JString, required = false,
                                 default = nil)
  if valid_580660 != nil:
    section.add "userIp", valid_580660
  var valid_580661 = query.getOrDefault("maxResults")
  valid_580661 = validateParameter(valid_580661, JInt, required = false, default = nil)
  if valid_580661 != nil:
    section.add "maxResults", valid_580661
  var valid_580662 = query.getOrDefault("source")
  valid_580662 = validateParameter(valid_580662, JString, required = false,
                                 default = nil)
  if valid_580662 != nil:
    section.add "source", valid_580662
  var valid_580663 = query.getOrDefault("key")
  valid_580663 = validateParameter(valid_580663, JString, required = false,
                                 default = nil)
  if valid_580663 != nil:
    section.add "key", valid_580663
  var valid_580664 = query.getOrDefault("acquireMethod")
  valid_580664 = validateParameter(valid_580664, JArray, required = false,
                                 default = nil)
  if valid_580664 != nil:
    section.add "acquireMethod", valid_580664
  var valid_580665 = query.getOrDefault("prettyPrint")
  valid_580665 = validateParameter(valid_580665, JBool, required = false,
                                 default = newJBool(true))
  if valid_580665 != nil:
    section.add "prettyPrint", valid_580665
  var valid_580666 = query.getOrDefault("startIndex")
  valid_580666 = validateParameter(valid_580666, JInt, required = false, default = nil)
  if valid_580666 != nil:
    section.add "startIndex", valid_580666
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580667: Call_BooksVolumesMybooksList_580650; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return a list of books in My Library.
  ## 
  let valid = call_580667.validator(path, query, header, formData, body)
  let scheme = call_580667.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580667.url(scheme.get, call_580667.host, call_580667.base,
                         call_580667.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580667, url, valid)

proc call*(call_580668: Call_BooksVolumesMybooksList_580650; locale: string = "";
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
  var query_580669 = newJObject()
  add(query_580669, "locale", newJString(locale))
  add(query_580669, "fields", newJString(fields))
  add(query_580669, "country", newJString(country))
  add(query_580669, "quotaUser", newJString(quotaUser))
  if processingState != nil:
    query_580669.add "processingState", processingState
  add(query_580669, "alt", newJString(alt))
  add(query_580669, "oauth_token", newJString(oauthToken))
  add(query_580669, "userIp", newJString(userIp))
  add(query_580669, "maxResults", newJInt(maxResults))
  add(query_580669, "source", newJString(source))
  add(query_580669, "key", newJString(key))
  if acquireMethod != nil:
    query_580669.add "acquireMethod", acquireMethod
  add(query_580669, "prettyPrint", newJBool(prettyPrint))
  add(query_580669, "startIndex", newJInt(startIndex))
  result = call_580668.call(nil, query_580669, nil, nil, nil)

var booksVolumesMybooksList* = Call_BooksVolumesMybooksList_580650(
    name: "booksVolumesMybooksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/volumes/mybooks",
    validator: validate_BooksVolumesMybooksList_580651, base: "/books/v1",
    url: url_BooksVolumesMybooksList_580652, schemes: {Scheme.Https})
type
  Call_BooksVolumesRecommendedList_580670 = ref object of OpenApiRestCall_579437
proc url_BooksVolumesRecommendedList_580672(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksVolumesRecommendedList_580671(path: JsonNode; query: JsonNode;
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
  var valid_580673 = query.getOrDefault("locale")
  valid_580673 = validateParameter(valid_580673, JString, required = false,
                                 default = nil)
  if valid_580673 != nil:
    section.add "locale", valid_580673
  var valid_580674 = query.getOrDefault("fields")
  valid_580674 = validateParameter(valid_580674, JString, required = false,
                                 default = nil)
  if valid_580674 != nil:
    section.add "fields", valid_580674
  var valid_580675 = query.getOrDefault("quotaUser")
  valid_580675 = validateParameter(valid_580675, JString, required = false,
                                 default = nil)
  if valid_580675 != nil:
    section.add "quotaUser", valid_580675
  var valid_580676 = query.getOrDefault("alt")
  valid_580676 = validateParameter(valid_580676, JString, required = false,
                                 default = newJString("json"))
  if valid_580676 != nil:
    section.add "alt", valid_580676
  var valid_580677 = query.getOrDefault("oauth_token")
  valid_580677 = validateParameter(valid_580677, JString, required = false,
                                 default = nil)
  if valid_580677 != nil:
    section.add "oauth_token", valid_580677
  var valid_580678 = query.getOrDefault("userIp")
  valid_580678 = validateParameter(valid_580678, JString, required = false,
                                 default = nil)
  if valid_580678 != nil:
    section.add "userIp", valid_580678
  var valid_580679 = query.getOrDefault("source")
  valid_580679 = validateParameter(valid_580679, JString, required = false,
                                 default = nil)
  if valid_580679 != nil:
    section.add "source", valid_580679
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
  var valid_580682 = query.getOrDefault("maxAllowedMaturityRating")
  valid_580682 = validateParameter(valid_580682, JString, required = false,
                                 default = newJString("mature"))
  if valid_580682 != nil:
    section.add "maxAllowedMaturityRating", valid_580682
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580683: Call_BooksVolumesRecommendedList_580670; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return a list of recommended books for the current user.
  ## 
  let valid = call_580683.validator(path, query, header, formData, body)
  let scheme = call_580683.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580683.url(scheme.get, call_580683.host, call_580683.base,
                         call_580683.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580683, url, valid)

proc call*(call_580684: Call_BooksVolumesRecommendedList_580670;
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
  var query_580685 = newJObject()
  add(query_580685, "locale", newJString(locale))
  add(query_580685, "fields", newJString(fields))
  add(query_580685, "quotaUser", newJString(quotaUser))
  add(query_580685, "alt", newJString(alt))
  add(query_580685, "oauth_token", newJString(oauthToken))
  add(query_580685, "userIp", newJString(userIp))
  add(query_580685, "source", newJString(source))
  add(query_580685, "key", newJString(key))
  add(query_580685, "prettyPrint", newJBool(prettyPrint))
  add(query_580685, "maxAllowedMaturityRating",
      newJString(maxAllowedMaturityRating))
  result = call_580684.call(nil, query_580685, nil, nil, nil)

var booksVolumesRecommendedList* = Call_BooksVolumesRecommendedList_580670(
    name: "booksVolumesRecommendedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/volumes/recommended",
    validator: validate_BooksVolumesRecommendedList_580671, base: "/books/v1",
    url: url_BooksVolumesRecommendedList_580672, schemes: {Scheme.Https})
type
  Call_BooksVolumesRecommendedRate_580686 = ref object of OpenApiRestCall_579437
proc url_BooksVolumesRecommendedRate_580688(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksVolumesRecommendedRate_580687(path: JsonNode; query: JsonNode;
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
  var valid_580689 = query.getOrDefault("locale")
  valid_580689 = validateParameter(valid_580689, JString, required = false,
                                 default = nil)
  if valid_580689 != nil:
    section.add "locale", valid_580689
  var valid_580690 = query.getOrDefault("fields")
  valid_580690 = validateParameter(valid_580690, JString, required = false,
                                 default = nil)
  if valid_580690 != nil:
    section.add "fields", valid_580690
  var valid_580691 = query.getOrDefault("quotaUser")
  valid_580691 = validateParameter(valid_580691, JString, required = false,
                                 default = nil)
  if valid_580691 != nil:
    section.add "quotaUser", valid_580691
  var valid_580692 = query.getOrDefault("alt")
  valid_580692 = validateParameter(valid_580692, JString, required = false,
                                 default = newJString("json"))
  if valid_580692 != nil:
    section.add "alt", valid_580692
  assert query != nil, "query argument is necessary due to required `rating` field"
  var valid_580693 = query.getOrDefault("rating")
  valid_580693 = validateParameter(valid_580693, JString, required = true,
                                 default = newJString("HAVE_IT"))
  if valid_580693 != nil:
    section.add "rating", valid_580693
  var valid_580694 = query.getOrDefault("oauth_token")
  valid_580694 = validateParameter(valid_580694, JString, required = false,
                                 default = nil)
  if valid_580694 != nil:
    section.add "oauth_token", valid_580694
  var valid_580695 = query.getOrDefault("userIp")
  valid_580695 = validateParameter(valid_580695, JString, required = false,
                                 default = nil)
  if valid_580695 != nil:
    section.add "userIp", valid_580695
  var valid_580696 = query.getOrDefault("source")
  valid_580696 = validateParameter(valid_580696, JString, required = false,
                                 default = nil)
  if valid_580696 != nil:
    section.add "source", valid_580696
  var valid_580697 = query.getOrDefault("key")
  valid_580697 = validateParameter(valid_580697, JString, required = false,
                                 default = nil)
  if valid_580697 != nil:
    section.add "key", valid_580697
  var valid_580698 = query.getOrDefault("volumeId")
  valid_580698 = validateParameter(valid_580698, JString, required = true,
                                 default = nil)
  if valid_580698 != nil:
    section.add "volumeId", valid_580698
  var valid_580699 = query.getOrDefault("prettyPrint")
  valid_580699 = validateParameter(valid_580699, JBool, required = false,
                                 default = newJBool(true))
  if valid_580699 != nil:
    section.add "prettyPrint", valid_580699
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580700: Call_BooksVolumesRecommendedRate_580686; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rate a recommended book for the current user.
  ## 
  let valid = call_580700.validator(path, query, header, formData, body)
  let scheme = call_580700.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580700.url(scheme.get, call_580700.host, call_580700.base,
                         call_580700.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580700, url, valid)

proc call*(call_580701: Call_BooksVolumesRecommendedRate_580686; volumeId: string;
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
  var query_580702 = newJObject()
  add(query_580702, "locale", newJString(locale))
  add(query_580702, "fields", newJString(fields))
  add(query_580702, "quotaUser", newJString(quotaUser))
  add(query_580702, "alt", newJString(alt))
  add(query_580702, "rating", newJString(rating))
  add(query_580702, "oauth_token", newJString(oauthToken))
  add(query_580702, "userIp", newJString(userIp))
  add(query_580702, "source", newJString(source))
  add(query_580702, "key", newJString(key))
  add(query_580702, "volumeId", newJString(volumeId))
  add(query_580702, "prettyPrint", newJBool(prettyPrint))
  result = call_580701.call(nil, query_580702, nil, nil, nil)

var booksVolumesRecommendedRate* = Call_BooksVolumesRecommendedRate_580686(
    name: "booksVolumesRecommendedRate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/volumes/recommended/rate",
    validator: validate_BooksVolumesRecommendedRate_580687, base: "/books/v1",
    url: url_BooksVolumesRecommendedRate_580688, schemes: {Scheme.Https})
type
  Call_BooksVolumesUseruploadedList_580703 = ref object of OpenApiRestCall_579437
proc url_BooksVolumesUseruploadedList_580705(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksVolumesUseruploadedList_580704(path: JsonNode; query: JsonNode;
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
  var valid_580706 = query.getOrDefault("locale")
  valid_580706 = validateParameter(valid_580706, JString, required = false,
                                 default = nil)
  if valid_580706 != nil:
    section.add "locale", valid_580706
  var valid_580707 = query.getOrDefault("fields")
  valid_580707 = validateParameter(valid_580707, JString, required = false,
                                 default = nil)
  if valid_580707 != nil:
    section.add "fields", valid_580707
  var valid_580708 = query.getOrDefault("quotaUser")
  valid_580708 = validateParameter(valid_580708, JString, required = false,
                                 default = nil)
  if valid_580708 != nil:
    section.add "quotaUser", valid_580708
  var valid_580709 = query.getOrDefault("processingState")
  valid_580709 = validateParameter(valid_580709, JArray, required = false,
                                 default = nil)
  if valid_580709 != nil:
    section.add "processingState", valid_580709
  var valid_580710 = query.getOrDefault("alt")
  valid_580710 = validateParameter(valid_580710, JString, required = false,
                                 default = newJString("json"))
  if valid_580710 != nil:
    section.add "alt", valid_580710
  var valid_580711 = query.getOrDefault("oauth_token")
  valid_580711 = validateParameter(valid_580711, JString, required = false,
                                 default = nil)
  if valid_580711 != nil:
    section.add "oauth_token", valid_580711
  var valid_580712 = query.getOrDefault("userIp")
  valid_580712 = validateParameter(valid_580712, JString, required = false,
                                 default = nil)
  if valid_580712 != nil:
    section.add "userIp", valid_580712
  var valid_580713 = query.getOrDefault("maxResults")
  valid_580713 = validateParameter(valid_580713, JInt, required = false, default = nil)
  if valid_580713 != nil:
    section.add "maxResults", valid_580713
  var valid_580714 = query.getOrDefault("source")
  valid_580714 = validateParameter(valid_580714, JString, required = false,
                                 default = nil)
  if valid_580714 != nil:
    section.add "source", valid_580714
  var valid_580715 = query.getOrDefault("key")
  valid_580715 = validateParameter(valid_580715, JString, required = false,
                                 default = nil)
  if valid_580715 != nil:
    section.add "key", valid_580715
  var valid_580716 = query.getOrDefault("volumeId")
  valid_580716 = validateParameter(valid_580716, JArray, required = false,
                                 default = nil)
  if valid_580716 != nil:
    section.add "volumeId", valid_580716
  var valid_580717 = query.getOrDefault("prettyPrint")
  valid_580717 = validateParameter(valid_580717, JBool, required = false,
                                 default = newJBool(true))
  if valid_580717 != nil:
    section.add "prettyPrint", valid_580717
  var valid_580718 = query.getOrDefault("startIndex")
  valid_580718 = validateParameter(valid_580718, JInt, required = false, default = nil)
  if valid_580718 != nil:
    section.add "startIndex", valid_580718
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580719: Call_BooksVolumesUseruploadedList_580703; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return a list of books uploaded by the current user.
  ## 
  let valid = call_580719.validator(path, query, header, formData, body)
  let scheme = call_580719.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580719.url(scheme.get, call_580719.host, call_580719.base,
                         call_580719.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580719, url, valid)

proc call*(call_580720: Call_BooksVolumesUseruploadedList_580703;
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
  var query_580721 = newJObject()
  add(query_580721, "locale", newJString(locale))
  add(query_580721, "fields", newJString(fields))
  add(query_580721, "quotaUser", newJString(quotaUser))
  if processingState != nil:
    query_580721.add "processingState", processingState
  add(query_580721, "alt", newJString(alt))
  add(query_580721, "oauth_token", newJString(oauthToken))
  add(query_580721, "userIp", newJString(userIp))
  add(query_580721, "maxResults", newJInt(maxResults))
  add(query_580721, "source", newJString(source))
  add(query_580721, "key", newJString(key))
  if volumeId != nil:
    query_580721.add "volumeId", volumeId
  add(query_580721, "prettyPrint", newJBool(prettyPrint))
  add(query_580721, "startIndex", newJInt(startIndex))
  result = call_580720.call(nil, query_580721, nil, nil, nil)

var booksVolumesUseruploadedList* = Call_BooksVolumesUseruploadedList_580703(
    name: "booksVolumesUseruploadedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/volumes/useruploaded",
    validator: validate_BooksVolumesUseruploadedList_580704, base: "/books/v1",
    url: url_BooksVolumesUseruploadedList_580705, schemes: {Scheme.Https})
type
  Call_BooksVolumesGet_580722 = ref object of OpenApiRestCall_579437
proc url_BooksVolumesGet_580724(protocol: Scheme; host: string; base: string;
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

proc validate_BooksVolumesGet_580723(path: JsonNode; query: JsonNode;
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
  var valid_580725 = path.getOrDefault("volumeId")
  valid_580725 = validateParameter(valid_580725, JString, required = true,
                                 default = nil)
  if valid_580725 != nil:
    section.add "volumeId", valid_580725
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
  var valid_580726 = query.getOrDefault("fields")
  valid_580726 = validateParameter(valid_580726, JString, required = false,
                                 default = nil)
  if valid_580726 != nil:
    section.add "fields", valid_580726
  var valid_580727 = query.getOrDefault("country")
  valid_580727 = validateParameter(valid_580727, JString, required = false,
                                 default = nil)
  if valid_580727 != nil:
    section.add "country", valid_580727
  var valid_580728 = query.getOrDefault("quotaUser")
  valid_580728 = validateParameter(valid_580728, JString, required = false,
                                 default = nil)
  if valid_580728 != nil:
    section.add "quotaUser", valid_580728
  var valid_580729 = query.getOrDefault("alt")
  valid_580729 = validateParameter(valid_580729, JString, required = false,
                                 default = newJString("json"))
  if valid_580729 != nil:
    section.add "alt", valid_580729
  var valid_580730 = query.getOrDefault("oauth_token")
  valid_580730 = validateParameter(valid_580730, JString, required = false,
                                 default = nil)
  if valid_580730 != nil:
    section.add "oauth_token", valid_580730
  var valid_580731 = query.getOrDefault("includeNonComicsSeries")
  valid_580731 = validateParameter(valid_580731, JBool, required = false, default = nil)
  if valid_580731 != nil:
    section.add "includeNonComicsSeries", valid_580731
  var valid_580732 = query.getOrDefault("userIp")
  valid_580732 = validateParameter(valid_580732, JString, required = false,
                                 default = nil)
  if valid_580732 != nil:
    section.add "userIp", valid_580732
  var valid_580733 = query.getOrDefault("source")
  valid_580733 = validateParameter(valid_580733, JString, required = false,
                                 default = nil)
  if valid_580733 != nil:
    section.add "source", valid_580733
  var valid_580734 = query.getOrDefault("key")
  valid_580734 = validateParameter(valid_580734, JString, required = false,
                                 default = nil)
  if valid_580734 != nil:
    section.add "key", valid_580734
  var valid_580735 = query.getOrDefault("projection")
  valid_580735 = validateParameter(valid_580735, JString, required = false,
                                 default = newJString("full"))
  if valid_580735 != nil:
    section.add "projection", valid_580735
  var valid_580736 = query.getOrDefault("partner")
  valid_580736 = validateParameter(valid_580736, JString, required = false,
                                 default = nil)
  if valid_580736 != nil:
    section.add "partner", valid_580736
  var valid_580737 = query.getOrDefault("user_library_consistent_read")
  valid_580737 = validateParameter(valid_580737, JBool, required = false, default = nil)
  if valid_580737 != nil:
    section.add "user_library_consistent_read", valid_580737
  var valid_580738 = query.getOrDefault("prettyPrint")
  valid_580738 = validateParameter(valid_580738, JBool, required = false,
                                 default = newJBool(true))
  if valid_580738 != nil:
    section.add "prettyPrint", valid_580738
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580739: Call_BooksVolumesGet_580722; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets volume information for a single volume.
  ## 
  let valid = call_580739.validator(path, query, header, formData, body)
  let scheme = call_580739.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580739.url(scheme.get, call_580739.host, call_580739.base,
                         call_580739.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580739, url, valid)

proc call*(call_580740: Call_BooksVolumesGet_580722; volumeId: string;
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
  var path_580741 = newJObject()
  var query_580742 = newJObject()
  add(query_580742, "fields", newJString(fields))
  add(query_580742, "country", newJString(country))
  add(query_580742, "quotaUser", newJString(quotaUser))
  add(query_580742, "alt", newJString(alt))
  add(query_580742, "oauth_token", newJString(oauthToken))
  add(query_580742, "includeNonComicsSeries", newJBool(includeNonComicsSeries))
  add(query_580742, "userIp", newJString(userIp))
  add(query_580742, "source", newJString(source))
  add(query_580742, "key", newJString(key))
  add(path_580741, "volumeId", newJString(volumeId))
  add(query_580742, "projection", newJString(projection))
  add(query_580742, "partner", newJString(partner))
  add(query_580742, "user_library_consistent_read",
      newJBool(userLibraryConsistentRead))
  add(query_580742, "prettyPrint", newJBool(prettyPrint))
  result = call_580740.call(path_580741, query_580742, nil, nil, nil)

var booksVolumesGet* = Call_BooksVolumesGet_580722(name: "booksVolumesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/volumes/{volumeId}", validator: validate_BooksVolumesGet_580723,
    base: "/books/v1", url: url_BooksVolumesGet_580724, schemes: {Scheme.Https})
type
  Call_BooksVolumesAssociatedList_580743 = ref object of OpenApiRestCall_579437
proc url_BooksVolumesAssociatedList_580745(protocol: Scheme; host: string;
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

proc validate_BooksVolumesAssociatedList_580744(path: JsonNode; query: JsonNode;
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
  var valid_580746 = path.getOrDefault("volumeId")
  valid_580746 = validateParameter(valid_580746, JString, required = true,
                                 default = nil)
  if valid_580746 != nil:
    section.add "volumeId", valid_580746
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
  var valid_580747 = query.getOrDefault("association")
  valid_580747 = validateParameter(valid_580747, JString, required = false,
                                 default = newJString("end-of-sample"))
  if valid_580747 != nil:
    section.add "association", valid_580747
  var valid_580748 = query.getOrDefault("locale")
  valid_580748 = validateParameter(valid_580748, JString, required = false,
                                 default = nil)
  if valid_580748 != nil:
    section.add "locale", valid_580748
  var valid_580749 = query.getOrDefault("fields")
  valid_580749 = validateParameter(valid_580749, JString, required = false,
                                 default = nil)
  if valid_580749 != nil:
    section.add "fields", valid_580749
  var valid_580750 = query.getOrDefault("quotaUser")
  valid_580750 = validateParameter(valid_580750, JString, required = false,
                                 default = nil)
  if valid_580750 != nil:
    section.add "quotaUser", valid_580750
  var valid_580751 = query.getOrDefault("alt")
  valid_580751 = validateParameter(valid_580751, JString, required = false,
                                 default = newJString("json"))
  if valid_580751 != nil:
    section.add "alt", valid_580751
  var valid_580752 = query.getOrDefault("oauth_token")
  valid_580752 = validateParameter(valid_580752, JString, required = false,
                                 default = nil)
  if valid_580752 != nil:
    section.add "oauth_token", valid_580752
  var valid_580753 = query.getOrDefault("userIp")
  valid_580753 = validateParameter(valid_580753, JString, required = false,
                                 default = nil)
  if valid_580753 != nil:
    section.add "userIp", valid_580753
  var valid_580754 = query.getOrDefault("source")
  valid_580754 = validateParameter(valid_580754, JString, required = false,
                                 default = nil)
  if valid_580754 != nil:
    section.add "source", valid_580754
  var valid_580755 = query.getOrDefault("key")
  valid_580755 = validateParameter(valid_580755, JString, required = false,
                                 default = nil)
  if valid_580755 != nil:
    section.add "key", valid_580755
  var valid_580756 = query.getOrDefault("prettyPrint")
  valid_580756 = validateParameter(valid_580756, JBool, required = false,
                                 default = newJBool(true))
  if valid_580756 != nil:
    section.add "prettyPrint", valid_580756
  var valid_580757 = query.getOrDefault("maxAllowedMaturityRating")
  valid_580757 = validateParameter(valid_580757, JString, required = false,
                                 default = newJString("mature"))
  if valid_580757 != nil:
    section.add "maxAllowedMaturityRating", valid_580757
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580758: Call_BooksVolumesAssociatedList_580743; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return a list of associated books.
  ## 
  let valid = call_580758.validator(path, query, header, formData, body)
  let scheme = call_580758.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580758.url(scheme.get, call_580758.host, call_580758.base,
                         call_580758.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580758, url, valid)

proc call*(call_580759: Call_BooksVolumesAssociatedList_580743; volumeId: string;
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
  var path_580760 = newJObject()
  var query_580761 = newJObject()
  add(query_580761, "association", newJString(association))
  add(query_580761, "locale", newJString(locale))
  add(query_580761, "fields", newJString(fields))
  add(query_580761, "quotaUser", newJString(quotaUser))
  add(query_580761, "alt", newJString(alt))
  add(query_580761, "oauth_token", newJString(oauthToken))
  add(query_580761, "userIp", newJString(userIp))
  add(query_580761, "source", newJString(source))
  add(query_580761, "key", newJString(key))
  add(path_580760, "volumeId", newJString(volumeId))
  add(query_580761, "prettyPrint", newJBool(prettyPrint))
  add(query_580761, "maxAllowedMaturityRating",
      newJString(maxAllowedMaturityRating))
  result = call_580759.call(path_580760, query_580761, nil, nil, nil)

var booksVolumesAssociatedList* = Call_BooksVolumesAssociatedList_580743(
    name: "booksVolumesAssociatedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/volumes/{volumeId}/associated",
    validator: validate_BooksVolumesAssociatedList_580744, base: "/books/v1",
    url: url_BooksVolumesAssociatedList_580745, schemes: {Scheme.Https})
type
  Call_BooksLayersVolumeAnnotationsList_580762 = ref object of OpenApiRestCall_579437
proc url_BooksLayersVolumeAnnotationsList_580764(protocol: Scheme; host: string;
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

proc validate_BooksLayersVolumeAnnotationsList_580763(path: JsonNode;
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
  var valid_580765 = path.getOrDefault("volumeId")
  valid_580765 = validateParameter(valid_580765, JString, required = true,
                                 default = nil)
  if valid_580765 != nil:
    section.add "volumeId", valid_580765
  var valid_580766 = path.getOrDefault("layerId")
  valid_580766 = validateParameter(valid_580766, JString, required = true,
                                 default = nil)
  if valid_580766 != nil:
    section.add "layerId", valid_580766
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
  var valid_580767 = query.getOrDefault("locale")
  valid_580767 = validateParameter(valid_580767, JString, required = false,
                                 default = nil)
  if valid_580767 != nil:
    section.add "locale", valid_580767
  var valid_580768 = query.getOrDefault("fields")
  valid_580768 = validateParameter(valid_580768, JString, required = false,
                                 default = nil)
  if valid_580768 != nil:
    section.add "fields", valid_580768
  var valid_580769 = query.getOrDefault("pageToken")
  valid_580769 = validateParameter(valid_580769, JString, required = false,
                                 default = nil)
  if valid_580769 != nil:
    section.add "pageToken", valid_580769
  var valid_580770 = query.getOrDefault("quotaUser")
  valid_580770 = validateParameter(valid_580770, JString, required = false,
                                 default = nil)
  if valid_580770 != nil:
    section.add "quotaUser", valid_580770
  var valid_580771 = query.getOrDefault("alt")
  valid_580771 = validateParameter(valid_580771, JString, required = false,
                                 default = newJString("json"))
  if valid_580771 != nil:
    section.add "alt", valid_580771
  var valid_580772 = query.getOrDefault("updatedMax")
  valid_580772 = validateParameter(valid_580772, JString, required = false,
                                 default = nil)
  if valid_580772 != nil:
    section.add "updatedMax", valid_580772
  var valid_580773 = query.getOrDefault("oauth_token")
  valid_580773 = validateParameter(valid_580773, JString, required = false,
                                 default = nil)
  if valid_580773 != nil:
    section.add "oauth_token", valid_580773
  var valid_580774 = query.getOrDefault("userIp")
  valid_580774 = validateParameter(valid_580774, JString, required = false,
                                 default = nil)
  if valid_580774 != nil:
    section.add "userIp", valid_580774
  var valid_580775 = query.getOrDefault("maxResults")
  valid_580775 = validateParameter(valid_580775, JInt, required = false, default = nil)
  if valid_580775 != nil:
    section.add "maxResults", valid_580775
  assert query != nil,
        "query argument is necessary due to required `contentVersion` field"
  var valid_580776 = query.getOrDefault("contentVersion")
  valid_580776 = validateParameter(valid_580776, JString, required = true,
                                 default = nil)
  if valid_580776 != nil:
    section.add "contentVersion", valid_580776
  var valid_580777 = query.getOrDefault("showDeleted")
  valid_580777 = validateParameter(valid_580777, JBool, required = false, default = nil)
  if valid_580777 != nil:
    section.add "showDeleted", valid_580777
  var valid_580778 = query.getOrDefault("source")
  valid_580778 = validateParameter(valid_580778, JString, required = false,
                                 default = nil)
  if valid_580778 != nil:
    section.add "source", valid_580778
  var valid_580779 = query.getOrDefault("updatedMin")
  valid_580779 = validateParameter(valid_580779, JString, required = false,
                                 default = nil)
  if valid_580779 != nil:
    section.add "updatedMin", valid_580779
  var valid_580780 = query.getOrDefault("key")
  valid_580780 = validateParameter(valid_580780, JString, required = false,
                                 default = nil)
  if valid_580780 != nil:
    section.add "key", valid_580780
  var valid_580781 = query.getOrDefault("endOffset")
  valid_580781 = validateParameter(valid_580781, JString, required = false,
                                 default = nil)
  if valid_580781 != nil:
    section.add "endOffset", valid_580781
  var valid_580782 = query.getOrDefault("startOffset")
  valid_580782 = validateParameter(valid_580782, JString, required = false,
                                 default = nil)
  if valid_580782 != nil:
    section.add "startOffset", valid_580782
  var valid_580783 = query.getOrDefault("startPosition")
  valid_580783 = validateParameter(valid_580783, JString, required = false,
                                 default = nil)
  if valid_580783 != nil:
    section.add "startPosition", valid_580783
  var valid_580784 = query.getOrDefault("volumeAnnotationsVersion")
  valid_580784 = validateParameter(valid_580784, JString, required = false,
                                 default = nil)
  if valid_580784 != nil:
    section.add "volumeAnnotationsVersion", valid_580784
  var valid_580785 = query.getOrDefault("prettyPrint")
  valid_580785 = validateParameter(valid_580785, JBool, required = false,
                                 default = newJBool(true))
  if valid_580785 != nil:
    section.add "prettyPrint", valid_580785
  var valid_580786 = query.getOrDefault("endPosition")
  valid_580786 = validateParameter(valid_580786, JString, required = false,
                                 default = nil)
  if valid_580786 != nil:
    section.add "endPosition", valid_580786
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580787: Call_BooksLayersVolumeAnnotationsList_580762;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the volume annotations for a volume and layer.
  ## 
  let valid = call_580787.validator(path, query, header, formData, body)
  let scheme = call_580787.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580787.url(scheme.get, call_580787.host, call_580787.base,
                         call_580787.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580787, url, valid)

proc call*(call_580788: Call_BooksLayersVolumeAnnotationsList_580762;
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
  var path_580789 = newJObject()
  var query_580790 = newJObject()
  add(query_580790, "locale", newJString(locale))
  add(query_580790, "fields", newJString(fields))
  add(query_580790, "pageToken", newJString(pageToken))
  add(query_580790, "quotaUser", newJString(quotaUser))
  add(query_580790, "alt", newJString(alt))
  add(query_580790, "updatedMax", newJString(updatedMax))
  add(query_580790, "oauth_token", newJString(oauthToken))
  add(query_580790, "userIp", newJString(userIp))
  add(query_580790, "maxResults", newJInt(maxResults))
  add(query_580790, "contentVersion", newJString(contentVersion))
  add(query_580790, "showDeleted", newJBool(showDeleted))
  add(query_580790, "source", newJString(source))
  add(query_580790, "updatedMin", newJString(updatedMin))
  add(query_580790, "key", newJString(key))
  add(path_580789, "volumeId", newJString(volumeId))
  add(query_580790, "endOffset", newJString(endOffset))
  add(query_580790, "startOffset", newJString(startOffset))
  add(query_580790, "startPosition", newJString(startPosition))
  add(query_580790, "volumeAnnotationsVersion",
      newJString(volumeAnnotationsVersion))
  add(query_580790, "prettyPrint", newJBool(prettyPrint))
  add(query_580790, "endPosition", newJString(endPosition))
  add(path_580789, "layerId", newJString(layerId))
  result = call_580788.call(path_580789, query_580790, nil, nil, nil)

var booksLayersVolumeAnnotationsList* = Call_BooksLayersVolumeAnnotationsList_580762(
    name: "booksLayersVolumeAnnotationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/volumes/{volumeId}/layers/{layerId}",
    validator: validate_BooksLayersVolumeAnnotationsList_580763,
    base: "/books/v1", url: url_BooksLayersVolumeAnnotationsList_580764,
    schemes: {Scheme.Https})
type
  Call_BooksLayersVolumeAnnotationsGet_580791 = ref object of OpenApiRestCall_579437
proc url_BooksLayersVolumeAnnotationsGet_580793(protocol: Scheme; host: string;
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

proc validate_BooksLayersVolumeAnnotationsGet_580792(path: JsonNode;
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
  var valid_580794 = path.getOrDefault("annotationId")
  valid_580794 = validateParameter(valid_580794, JString, required = true,
                                 default = nil)
  if valid_580794 != nil:
    section.add "annotationId", valid_580794
  var valid_580795 = path.getOrDefault("volumeId")
  valid_580795 = validateParameter(valid_580795, JString, required = true,
                                 default = nil)
  if valid_580795 != nil:
    section.add "volumeId", valid_580795
  var valid_580796 = path.getOrDefault("layerId")
  valid_580796 = validateParameter(valid_580796, JString, required = true,
                                 default = nil)
  if valid_580796 != nil:
    section.add "layerId", valid_580796
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
  var valid_580797 = query.getOrDefault("locale")
  valid_580797 = validateParameter(valid_580797, JString, required = false,
                                 default = nil)
  if valid_580797 != nil:
    section.add "locale", valid_580797
  var valid_580798 = query.getOrDefault("fields")
  valid_580798 = validateParameter(valid_580798, JString, required = false,
                                 default = nil)
  if valid_580798 != nil:
    section.add "fields", valid_580798
  var valid_580799 = query.getOrDefault("quotaUser")
  valid_580799 = validateParameter(valid_580799, JString, required = false,
                                 default = nil)
  if valid_580799 != nil:
    section.add "quotaUser", valid_580799
  var valid_580800 = query.getOrDefault("alt")
  valid_580800 = validateParameter(valid_580800, JString, required = false,
                                 default = newJString("json"))
  if valid_580800 != nil:
    section.add "alt", valid_580800
  var valid_580801 = query.getOrDefault("oauth_token")
  valid_580801 = validateParameter(valid_580801, JString, required = false,
                                 default = nil)
  if valid_580801 != nil:
    section.add "oauth_token", valid_580801
  var valid_580802 = query.getOrDefault("userIp")
  valid_580802 = validateParameter(valid_580802, JString, required = false,
                                 default = nil)
  if valid_580802 != nil:
    section.add "userIp", valid_580802
  var valid_580803 = query.getOrDefault("source")
  valid_580803 = validateParameter(valid_580803, JString, required = false,
                                 default = nil)
  if valid_580803 != nil:
    section.add "source", valid_580803
  var valid_580804 = query.getOrDefault("key")
  valid_580804 = validateParameter(valid_580804, JString, required = false,
                                 default = nil)
  if valid_580804 != nil:
    section.add "key", valid_580804
  var valid_580805 = query.getOrDefault("prettyPrint")
  valid_580805 = validateParameter(valid_580805, JBool, required = false,
                                 default = newJBool(true))
  if valid_580805 != nil:
    section.add "prettyPrint", valid_580805
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580806: Call_BooksLayersVolumeAnnotationsGet_580791;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the volume annotation.
  ## 
  let valid = call_580806.validator(path, query, header, formData, body)
  let scheme = call_580806.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580806.url(scheme.get, call_580806.host, call_580806.base,
                         call_580806.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580806, url, valid)

proc call*(call_580807: Call_BooksLayersVolumeAnnotationsGet_580791;
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
  var path_580808 = newJObject()
  var query_580809 = newJObject()
  add(query_580809, "locale", newJString(locale))
  add(query_580809, "fields", newJString(fields))
  add(query_580809, "quotaUser", newJString(quotaUser))
  add(query_580809, "alt", newJString(alt))
  add(query_580809, "oauth_token", newJString(oauthToken))
  add(path_580808, "annotationId", newJString(annotationId))
  add(query_580809, "userIp", newJString(userIp))
  add(query_580809, "source", newJString(source))
  add(query_580809, "key", newJString(key))
  add(path_580808, "volumeId", newJString(volumeId))
  add(query_580809, "prettyPrint", newJBool(prettyPrint))
  add(path_580808, "layerId", newJString(layerId))
  result = call_580807.call(path_580808, query_580809, nil, nil, nil)

var booksLayersVolumeAnnotationsGet* = Call_BooksLayersVolumeAnnotationsGet_580791(
    name: "booksLayersVolumeAnnotationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/volumes/{volumeId}/layers/{layerId}/annotations/{annotationId}",
    validator: validate_BooksLayersVolumeAnnotationsGet_580792, base: "/books/v1",
    url: url_BooksLayersVolumeAnnotationsGet_580793, schemes: {Scheme.Https})
type
  Call_BooksLayersAnnotationDataList_580810 = ref object of OpenApiRestCall_579437
proc url_BooksLayersAnnotationDataList_580812(protocol: Scheme; host: string;
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

proc validate_BooksLayersAnnotationDataList_580811(path: JsonNode; query: JsonNode;
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
  var valid_580813 = path.getOrDefault("volumeId")
  valid_580813 = validateParameter(valid_580813, JString, required = true,
                                 default = nil)
  if valid_580813 != nil:
    section.add "volumeId", valid_580813
  var valid_580814 = path.getOrDefault("layerId")
  valid_580814 = validateParameter(valid_580814, JString, required = true,
                                 default = nil)
  if valid_580814 != nil:
    section.add "layerId", valid_580814
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
  var valid_580815 = query.getOrDefault("locale")
  valid_580815 = validateParameter(valid_580815, JString, required = false,
                                 default = nil)
  if valid_580815 != nil:
    section.add "locale", valid_580815
  var valid_580816 = query.getOrDefault("fields")
  valid_580816 = validateParameter(valid_580816, JString, required = false,
                                 default = nil)
  if valid_580816 != nil:
    section.add "fields", valid_580816
  var valid_580817 = query.getOrDefault("pageToken")
  valid_580817 = validateParameter(valid_580817, JString, required = false,
                                 default = nil)
  if valid_580817 != nil:
    section.add "pageToken", valid_580817
  var valid_580818 = query.getOrDefault("quotaUser")
  valid_580818 = validateParameter(valid_580818, JString, required = false,
                                 default = nil)
  if valid_580818 != nil:
    section.add "quotaUser", valid_580818
  var valid_580819 = query.getOrDefault("alt")
  valid_580819 = validateParameter(valid_580819, JString, required = false,
                                 default = newJString("json"))
  if valid_580819 != nil:
    section.add "alt", valid_580819
  var valid_580820 = query.getOrDefault("updatedMax")
  valid_580820 = validateParameter(valid_580820, JString, required = false,
                                 default = nil)
  if valid_580820 != nil:
    section.add "updatedMax", valid_580820
  var valid_580821 = query.getOrDefault("scale")
  valid_580821 = validateParameter(valid_580821, JInt, required = false, default = nil)
  if valid_580821 != nil:
    section.add "scale", valid_580821
  var valid_580822 = query.getOrDefault("oauth_token")
  valid_580822 = validateParameter(valid_580822, JString, required = false,
                                 default = nil)
  if valid_580822 != nil:
    section.add "oauth_token", valid_580822
  var valid_580823 = query.getOrDefault("userIp")
  valid_580823 = validateParameter(valid_580823, JString, required = false,
                                 default = nil)
  if valid_580823 != nil:
    section.add "userIp", valid_580823
  var valid_580824 = query.getOrDefault("maxResults")
  valid_580824 = validateParameter(valid_580824, JInt, required = false, default = nil)
  if valid_580824 != nil:
    section.add "maxResults", valid_580824
  assert query != nil,
        "query argument is necessary due to required `contentVersion` field"
  var valid_580825 = query.getOrDefault("contentVersion")
  valid_580825 = validateParameter(valid_580825, JString, required = true,
                                 default = nil)
  if valid_580825 != nil:
    section.add "contentVersion", valid_580825
  var valid_580826 = query.getOrDefault("source")
  valid_580826 = validateParameter(valid_580826, JString, required = false,
                                 default = nil)
  if valid_580826 != nil:
    section.add "source", valid_580826
  var valid_580827 = query.getOrDefault("updatedMin")
  valid_580827 = validateParameter(valid_580827, JString, required = false,
                                 default = nil)
  if valid_580827 != nil:
    section.add "updatedMin", valid_580827
  var valid_580828 = query.getOrDefault("key")
  valid_580828 = validateParameter(valid_580828, JString, required = false,
                                 default = nil)
  if valid_580828 != nil:
    section.add "key", valid_580828
  var valid_580829 = query.getOrDefault("w")
  valid_580829 = validateParameter(valid_580829, JInt, required = false, default = nil)
  if valid_580829 != nil:
    section.add "w", valid_580829
  var valid_580830 = query.getOrDefault("annotationDataId")
  valid_580830 = validateParameter(valid_580830, JArray, required = false,
                                 default = nil)
  if valid_580830 != nil:
    section.add "annotationDataId", valid_580830
  var valid_580831 = query.getOrDefault("prettyPrint")
  valid_580831 = validateParameter(valid_580831, JBool, required = false,
                                 default = newJBool(true))
  if valid_580831 != nil:
    section.add "prettyPrint", valid_580831
  var valid_580832 = query.getOrDefault("h")
  valid_580832 = validateParameter(valid_580832, JInt, required = false, default = nil)
  if valid_580832 != nil:
    section.add "h", valid_580832
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580833: Call_BooksLayersAnnotationDataList_580810; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the annotation data for a volume and layer.
  ## 
  let valid = call_580833.validator(path, query, header, formData, body)
  let scheme = call_580833.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580833.url(scheme.get, call_580833.host, call_580833.base,
                         call_580833.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580833, url, valid)

proc call*(call_580834: Call_BooksLayersAnnotationDataList_580810;
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
  var path_580835 = newJObject()
  var query_580836 = newJObject()
  add(query_580836, "locale", newJString(locale))
  add(query_580836, "fields", newJString(fields))
  add(query_580836, "pageToken", newJString(pageToken))
  add(query_580836, "quotaUser", newJString(quotaUser))
  add(query_580836, "alt", newJString(alt))
  add(query_580836, "updatedMax", newJString(updatedMax))
  add(query_580836, "scale", newJInt(scale))
  add(query_580836, "oauth_token", newJString(oauthToken))
  add(query_580836, "userIp", newJString(userIp))
  add(query_580836, "maxResults", newJInt(maxResults))
  add(query_580836, "contentVersion", newJString(contentVersion))
  add(query_580836, "source", newJString(source))
  add(query_580836, "updatedMin", newJString(updatedMin))
  add(query_580836, "key", newJString(key))
  add(path_580835, "volumeId", newJString(volumeId))
  add(query_580836, "w", newJInt(w))
  if annotationDataId != nil:
    query_580836.add "annotationDataId", annotationDataId
  add(query_580836, "prettyPrint", newJBool(prettyPrint))
  add(query_580836, "h", newJInt(h))
  add(path_580835, "layerId", newJString(layerId))
  result = call_580834.call(path_580835, query_580836, nil, nil, nil)

var booksLayersAnnotationDataList* = Call_BooksLayersAnnotationDataList_580810(
    name: "booksLayersAnnotationDataList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/volumes/{volumeId}/layers/{layerId}/data",
    validator: validate_BooksLayersAnnotationDataList_580811, base: "/books/v1",
    url: url_BooksLayersAnnotationDataList_580812, schemes: {Scheme.Https})
type
  Call_BooksLayersAnnotationDataGet_580837 = ref object of OpenApiRestCall_579437
proc url_BooksLayersAnnotationDataGet_580839(protocol: Scheme; host: string;
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

proc validate_BooksLayersAnnotationDataGet_580838(path: JsonNode; query: JsonNode;
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
  var valid_580840 = path.getOrDefault("annotationDataId")
  valid_580840 = validateParameter(valid_580840, JString, required = true,
                                 default = nil)
  if valid_580840 != nil:
    section.add "annotationDataId", valid_580840
  var valid_580841 = path.getOrDefault("volumeId")
  valid_580841 = validateParameter(valid_580841, JString, required = true,
                                 default = nil)
  if valid_580841 != nil:
    section.add "volumeId", valid_580841
  var valid_580842 = path.getOrDefault("layerId")
  valid_580842 = validateParameter(valid_580842, JString, required = true,
                                 default = nil)
  if valid_580842 != nil:
    section.add "layerId", valid_580842
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
  var valid_580843 = query.getOrDefault("locale")
  valid_580843 = validateParameter(valid_580843, JString, required = false,
                                 default = nil)
  if valid_580843 != nil:
    section.add "locale", valid_580843
  var valid_580844 = query.getOrDefault("fields")
  valid_580844 = validateParameter(valid_580844, JString, required = false,
                                 default = nil)
  if valid_580844 != nil:
    section.add "fields", valid_580844
  var valid_580845 = query.getOrDefault("quotaUser")
  valid_580845 = validateParameter(valid_580845, JString, required = false,
                                 default = nil)
  if valid_580845 != nil:
    section.add "quotaUser", valid_580845
  var valid_580846 = query.getOrDefault("alt")
  valid_580846 = validateParameter(valid_580846, JString, required = false,
                                 default = newJString("json"))
  if valid_580846 != nil:
    section.add "alt", valid_580846
  var valid_580847 = query.getOrDefault("scale")
  valid_580847 = validateParameter(valid_580847, JInt, required = false, default = nil)
  if valid_580847 != nil:
    section.add "scale", valid_580847
  var valid_580848 = query.getOrDefault("allowWebDefinitions")
  valid_580848 = validateParameter(valid_580848, JBool, required = false, default = nil)
  if valid_580848 != nil:
    section.add "allowWebDefinitions", valid_580848
  var valid_580849 = query.getOrDefault("oauth_token")
  valid_580849 = validateParameter(valid_580849, JString, required = false,
                                 default = nil)
  if valid_580849 != nil:
    section.add "oauth_token", valid_580849
  var valid_580850 = query.getOrDefault("userIp")
  valid_580850 = validateParameter(valid_580850, JString, required = false,
                                 default = nil)
  if valid_580850 != nil:
    section.add "userIp", valid_580850
  assert query != nil,
        "query argument is necessary due to required `contentVersion` field"
  var valid_580851 = query.getOrDefault("contentVersion")
  valid_580851 = validateParameter(valid_580851, JString, required = true,
                                 default = nil)
  if valid_580851 != nil:
    section.add "contentVersion", valid_580851
  var valid_580852 = query.getOrDefault("source")
  valid_580852 = validateParameter(valid_580852, JString, required = false,
                                 default = nil)
  if valid_580852 != nil:
    section.add "source", valid_580852
  var valid_580853 = query.getOrDefault("key")
  valid_580853 = validateParameter(valid_580853, JString, required = false,
                                 default = nil)
  if valid_580853 != nil:
    section.add "key", valid_580853
  var valid_580854 = query.getOrDefault("w")
  valid_580854 = validateParameter(valid_580854, JInt, required = false, default = nil)
  if valid_580854 != nil:
    section.add "w", valid_580854
  var valid_580855 = query.getOrDefault("prettyPrint")
  valid_580855 = validateParameter(valid_580855, JBool, required = false,
                                 default = newJBool(true))
  if valid_580855 != nil:
    section.add "prettyPrint", valid_580855
  var valid_580856 = query.getOrDefault("h")
  valid_580856 = validateParameter(valid_580856, JInt, required = false, default = nil)
  if valid_580856 != nil:
    section.add "h", valid_580856
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580857: Call_BooksLayersAnnotationDataGet_580837; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the annotation data.
  ## 
  let valid = call_580857.validator(path, query, header, formData, body)
  let scheme = call_580857.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580857.url(scheme.get, call_580857.host, call_580857.base,
                         call_580857.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580857, url, valid)

proc call*(call_580858: Call_BooksLayersAnnotationDataGet_580837;
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
  var path_580859 = newJObject()
  var query_580860 = newJObject()
  add(query_580860, "locale", newJString(locale))
  add(path_580859, "annotationDataId", newJString(annotationDataId))
  add(query_580860, "fields", newJString(fields))
  add(query_580860, "quotaUser", newJString(quotaUser))
  add(query_580860, "alt", newJString(alt))
  add(query_580860, "scale", newJInt(scale))
  add(query_580860, "allowWebDefinitions", newJBool(allowWebDefinitions))
  add(query_580860, "oauth_token", newJString(oauthToken))
  add(query_580860, "userIp", newJString(userIp))
  add(query_580860, "contentVersion", newJString(contentVersion))
  add(query_580860, "source", newJString(source))
  add(query_580860, "key", newJString(key))
  add(path_580859, "volumeId", newJString(volumeId))
  add(query_580860, "w", newJInt(w))
  add(query_580860, "prettyPrint", newJBool(prettyPrint))
  add(query_580860, "h", newJInt(h))
  add(path_580859, "layerId", newJString(layerId))
  result = call_580858.call(path_580859, query_580860, nil, nil, nil)

var booksLayersAnnotationDataGet* = Call_BooksLayersAnnotationDataGet_580837(
    name: "booksLayersAnnotationDataGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/volumes/{volumeId}/layers/{layerId}/data/{annotationDataId}",
    validator: validate_BooksLayersAnnotationDataGet_580838, base: "/books/v1",
    url: url_BooksLayersAnnotationDataGet_580839, schemes: {Scheme.Https})
type
  Call_BooksLayersList_580861 = ref object of OpenApiRestCall_579437
proc url_BooksLayersList_580863(protocol: Scheme; host: string; base: string;
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

proc validate_BooksLayersList_580862(path: JsonNode; query: JsonNode;
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
  var valid_580864 = path.getOrDefault("volumeId")
  valid_580864 = validateParameter(valid_580864, JString, required = true,
                                 default = nil)
  if valid_580864 != nil:
    section.add "volumeId", valid_580864
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
  var valid_580865 = query.getOrDefault("fields")
  valid_580865 = validateParameter(valid_580865, JString, required = false,
                                 default = nil)
  if valid_580865 != nil:
    section.add "fields", valid_580865
  var valid_580866 = query.getOrDefault("pageToken")
  valid_580866 = validateParameter(valid_580866, JString, required = false,
                                 default = nil)
  if valid_580866 != nil:
    section.add "pageToken", valid_580866
  var valid_580867 = query.getOrDefault("quotaUser")
  valid_580867 = validateParameter(valid_580867, JString, required = false,
                                 default = nil)
  if valid_580867 != nil:
    section.add "quotaUser", valid_580867
  var valid_580868 = query.getOrDefault("alt")
  valid_580868 = validateParameter(valid_580868, JString, required = false,
                                 default = newJString("json"))
  if valid_580868 != nil:
    section.add "alt", valid_580868
  var valid_580869 = query.getOrDefault("oauth_token")
  valid_580869 = validateParameter(valid_580869, JString, required = false,
                                 default = nil)
  if valid_580869 != nil:
    section.add "oauth_token", valid_580869
  var valid_580870 = query.getOrDefault("userIp")
  valid_580870 = validateParameter(valid_580870, JString, required = false,
                                 default = nil)
  if valid_580870 != nil:
    section.add "userIp", valid_580870
  var valid_580871 = query.getOrDefault("maxResults")
  valid_580871 = validateParameter(valid_580871, JInt, required = false, default = nil)
  if valid_580871 != nil:
    section.add "maxResults", valid_580871
  var valid_580872 = query.getOrDefault("contentVersion")
  valid_580872 = validateParameter(valid_580872, JString, required = false,
                                 default = nil)
  if valid_580872 != nil:
    section.add "contentVersion", valid_580872
  var valid_580873 = query.getOrDefault("source")
  valid_580873 = validateParameter(valid_580873, JString, required = false,
                                 default = nil)
  if valid_580873 != nil:
    section.add "source", valid_580873
  var valid_580874 = query.getOrDefault("key")
  valid_580874 = validateParameter(valid_580874, JString, required = false,
                                 default = nil)
  if valid_580874 != nil:
    section.add "key", valid_580874
  var valid_580875 = query.getOrDefault("prettyPrint")
  valid_580875 = validateParameter(valid_580875, JBool, required = false,
                                 default = newJBool(true))
  if valid_580875 != nil:
    section.add "prettyPrint", valid_580875
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580876: Call_BooksLayersList_580861; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the layer summaries for a volume.
  ## 
  let valid = call_580876.validator(path, query, header, formData, body)
  let scheme = call_580876.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580876.url(scheme.get, call_580876.host, call_580876.base,
                         call_580876.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580876, url, valid)

proc call*(call_580877: Call_BooksLayersList_580861; volumeId: string;
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
  var path_580878 = newJObject()
  var query_580879 = newJObject()
  add(query_580879, "fields", newJString(fields))
  add(query_580879, "pageToken", newJString(pageToken))
  add(query_580879, "quotaUser", newJString(quotaUser))
  add(query_580879, "alt", newJString(alt))
  add(query_580879, "oauth_token", newJString(oauthToken))
  add(query_580879, "userIp", newJString(userIp))
  add(query_580879, "maxResults", newJInt(maxResults))
  add(query_580879, "contentVersion", newJString(contentVersion))
  add(query_580879, "source", newJString(source))
  add(query_580879, "key", newJString(key))
  add(path_580878, "volumeId", newJString(volumeId))
  add(query_580879, "prettyPrint", newJBool(prettyPrint))
  result = call_580877.call(path_580878, query_580879, nil, nil, nil)

var booksLayersList* = Call_BooksLayersList_580861(name: "booksLayersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/volumes/{volumeId}/layersummary",
    validator: validate_BooksLayersList_580862, base: "/books/v1",
    url: url_BooksLayersList_580863, schemes: {Scheme.Https})
type
  Call_BooksLayersGet_580880 = ref object of OpenApiRestCall_579437
proc url_BooksLayersGet_580882(protocol: Scheme; host: string; base: string;
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

proc validate_BooksLayersGet_580881(path: JsonNode; query: JsonNode;
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
  var valid_580883 = path.getOrDefault("volumeId")
  valid_580883 = validateParameter(valid_580883, JString, required = true,
                                 default = nil)
  if valid_580883 != nil:
    section.add "volumeId", valid_580883
  var valid_580884 = path.getOrDefault("summaryId")
  valid_580884 = validateParameter(valid_580884, JString, required = true,
                                 default = nil)
  if valid_580884 != nil:
    section.add "summaryId", valid_580884
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
  var valid_580885 = query.getOrDefault("fields")
  valid_580885 = validateParameter(valid_580885, JString, required = false,
                                 default = nil)
  if valid_580885 != nil:
    section.add "fields", valid_580885
  var valid_580886 = query.getOrDefault("quotaUser")
  valid_580886 = validateParameter(valid_580886, JString, required = false,
                                 default = nil)
  if valid_580886 != nil:
    section.add "quotaUser", valid_580886
  var valid_580887 = query.getOrDefault("alt")
  valid_580887 = validateParameter(valid_580887, JString, required = false,
                                 default = newJString("json"))
  if valid_580887 != nil:
    section.add "alt", valid_580887
  var valid_580888 = query.getOrDefault("oauth_token")
  valid_580888 = validateParameter(valid_580888, JString, required = false,
                                 default = nil)
  if valid_580888 != nil:
    section.add "oauth_token", valid_580888
  var valid_580889 = query.getOrDefault("userIp")
  valid_580889 = validateParameter(valid_580889, JString, required = false,
                                 default = nil)
  if valid_580889 != nil:
    section.add "userIp", valid_580889
  var valid_580890 = query.getOrDefault("contentVersion")
  valid_580890 = validateParameter(valid_580890, JString, required = false,
                                 default = nil)
  if valid_580890 != nil:
    section.add "contentVersion", valid_580890
  var valid_580891 = query.getOrDefault("source")
  valid_580891 = validateParameter(valid_580891, JString, required = false,
                                 default = nil)
  if valid_580891 != nil:
    section.add "source", valid_580891
  var valid_580892 = query.getOrDefault("key")
  valid_580892 = validateParameter(valid_580892, JString, required = false,
                                 default = nil)
  if valid_580892 != nil:
    section.add "key", valid_580892
  var valid_580893 = query.getOrDefault("prettyPrint")
  valid_580893 = validateParameter(valid_580893, JBool, required = false,
                                 default = newJBool(true))
  if valid_580893 != nil:
    section.add "prettyPrint", valid_580893
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580894: Call_BooksLayersGet_580880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the layer summary for a volume.
  ## 
  let valid = call_580894.validator(path, query, header, formData, body)
  let scheme = call_580894.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580894.url(scheme.get, call_580894.host, call_580894.base,
                         call_580894.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580894, url, valid)

proc call*(call_580895: Call_BooksLayersGet_580880; volumeId: string;
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
  var path_580896 = newJObject()
  var query_580897 = newJObject()
  add(query_580897, "fields", newJString(fields))
  add(query_580897, "quotaUser", newJString(quotaUser))
  add(query_580897, "alt", newJString(alt))
  add(query_580897, "oauth_token", newJString(oauthToken))
  add(query_580897, "userIp", newJString(userIp))
  add(query_580897, "contentVersion", newJString(contentVersion))
  add(query_580897, "source", newJString(source))
  add(query_580897, "key", newJString(key))
  add(path_580896, "volumeId", newJString(volumeId))
  add(path_580896, "summaryId", newJString(summaryId))
  add(query_580897, "prettyPrint", newJBool(prettyPrint))
  result = call_580895.call(path_580896, query_580897, nil, nil, nil)

var booksLayersGet* = Call_BooksLayersGet_580880(name: "booksLayersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/volumes/{volumeId}/layersummary/{summaryId}",
    validator: validate_BooksLayersGet_580881, base: "/books/v1",
    url: url_BooksLayersGet_580882, schemes: {Scheme.Https})
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

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
