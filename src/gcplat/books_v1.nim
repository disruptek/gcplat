
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

  OpenApiRestCall_578364 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578364](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578364): Option[Scheme] {.used.} =
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
  Call_BooksCloudloadingAddBook_578634 = ref object of OpenApiRestCall_578364
proc url_BooksCloudloadingAddBook_578636(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksCloudloadingAddBook_578635(path: JsonNode; query: JsonNode;
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
  var valid_578748 = query.getOrDefault("key")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "key", valid_578748
  var valid_578762 = query.getOrDefault("prettyPrint")
  valid_578762 = validateParameter(valid_578762, JBool, required = false,
                                 default = newJBool(true))
  if valid_578762 != nil:
    section.add "prettyPrint", valid_578762
  var valid_578763 = query.getOrDefault("oauth_token")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "oauth_token", valid_578763
  var valid_578764 = query.getOrDefault("name")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = nil)
  if valid_578764 != nil:
    section.add "name", valid_578764
  var valid_578765 = query.getOrDefault("drive_document_id")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = nil)
  if valid_578765 != nil:
    section.add "drive_document_id", valid_578765
  var valid_578766 = query.getOrDefault("alt")
  valid_578766 = validateParameter(valid_578766, JString, required = false,
                                 default = newJString("json"))
  if valid_578766 != nil:
    section.add "alt", valid_578766
  var valid_578767 = query.getOrDefault("userIp")
  valid_578767 = validateParameter(valid_578767, JString, required = false,
                                 default = nil)
  if valid_578767 != nil:
    section.add "userIp", valid_578767
  var valid_578768 = query.getOrDefault("quotaUser")
  valid_578768 = validateParameter(valid_578768, JString, required = false,
                                 default = nil)
  if valid_578768 != nil:
    section.add "quotaUser", valid_578768
  var valid_578769 = query.getOrDefault("mime_type")
  valid_578769 = validateParameter(valid_578769, JString, required = false,
                                 default = nil)
  if valid_578769 != nil:
    section.add "mime_type", valid_578769
  var valid_578770 = query.getOrDefault("fields")
  valid_578770 = validateParameter(valid_578770, JString, required = false,
                                 default = nil)
  if valid_578770 != nil:
    section.add "fields", valid_578770
  var valid_578771 = query.getOrDefault("upload_client_token")
  valid_578771 = validateParameter(valid_578771, JString, required = false,
                                 default = nil)
  if valid_578771 != nil:
    section.add "upload_client_token", valid_578771
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578794: Call_BooksCloudloadingAddBook_578634; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_578794.validator(path, query, header, formData, body)
  let scheme = call_578794.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578794.url(scheme.get, call_578794.host, call_578794.base,
                         call_578794.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578794, url, valid)

proc call*(call_578865: Call_BooksCloudloadingAddBook_578634; key: string = "";
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
  var query_578866 = newJObject()
  add(query_578866, "key", newJString(key))
  add(query_578866, "prettyPrint", newJBool(prettyPrint))
  add(query_578866, "oauth_token", newJString(oauthToken))
  add(query_578866, "name", newJString(name))
  add(query_578866, "drive_document_id", newJString(driveDocumentId))
  add(query_578866, "alt", newJString(alt))
  add(query_578866, "userIp", newJString(userIp))
  add(query_578866, "quotaUser", newJString(quotaUser))
  add(query_578866, "mime_type", newJString(mimeType))
  add(query_578866, "fields", newJString(fields))
  add(query_578866, "upload_client_token", newJString(uploadClientToken))
  result = call_578865.call(nil, query_578866, nil, nil, nil)

var booksCloudloadingAddBook* = Call_BooksCloudloadingAddBook_578634(
    name: "booksCloudloadingAddBook", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/cloudloading/addBook",
    validator: validate_BooksCloudloadingAddBook_578635, base: "/books/v1",
    url: url_BooksCloudloadingAddBook_578636, schemes: {Scheme.Https})
type
  Call_BooksCloudloadingDeleteBook_578906 = ref object of OpenApiRestCall_578364
proc url_BooksCloudloadingDeleteBook_578908(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksCloudloadingDeleteBook_578907(path: JsonNode; query: JsonNode;
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
  var valid_578909 = query.getOrDefault("key")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "key", valid_578909
  var valid_578910 = query.getOrDefault("prettyPrint")
  valid_578910 = validateParameter(valid_578910, JBool, required = false,
                                 default = newJBool(true))
  if valid_578910 != nil:
    section.add "prettyPrint", valid_578910
  var valid_578911 = query.getOrDefault("oauth_token")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "oauth_token", valid_578911
  assert query != nil,
        "query argument is necessary due to required `volumeId` field"
  var valid_578912 = query.getOrDefault("volumeId")
  valid_578912 = validateParameter(valid_578912, JString, required = true,
                                 default = nil)
  if valid_578912 != nil:
    section.add "volumeId", valid_578912
  var valid_578913 = query.getOrDefault("alt")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = newJString("json"))
  if valid_578913 != nil:
    section.add "alt", valid_578913
  var valid_578914 = query.getOrDefault("userIp")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "userIp", valid_578914
  var valid_578915 = query.getOrDefault("quotaUser")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "quotaUser", valid_578915
  var valid_578916 = query.getOrDefault("fields")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "fields", valid_578916
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578917: Call_BooksCloudloadingDeleteBook_578906; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove the book and its contents
  ## 
  let valid = call_578917.validator(path, query, header, formData, body)
  let scheme = call_578917.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578917.url(scheme.get, call_578917.host, call_578917.base,
                         call_578917.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578917, url, valid)

proc call*(call_578918: Call_BooksCloudloadingDeleteBook_578906; volumeId: string;
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
  var query_578919 = newJObject()
  add(query_578919, "key", newJString(key))
  add(query_578919, "prettyPrint", newJBool(prettyPrint))
  add(query_578919, "oauth_token", newJString(oauthToken))
  add(query_578919, "volumeId", newJString(volumeId))
  add(query_578919, "alt", newJString(alt))
  add(query_578919, "userIp", newJString(userIp))
  add(query_578919, "quotaUser", newJString(quotaUser))
  add(query_578919, "fields", newJString(fields))
  result = call_578918.call(nil, query_578919, nil, nil, nil)

var booksCloudloadingDeleteBook* = Call_BooksCloudloadingDeleteBook_578906(
    name: "booksCloudloadingDeleteBook", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/cloudloading/deleteBook",
    validator: validate_BooksCloudloadingDeleteBook_578907, base: "/books/v1",
    url: url_BooksCloudloadingDeleteBook_578908, schemes: {Scheme.Https})
type
  Call_BooksCloudloadingUpdateBook_578920 = ref object of OpenApiRestCall_578364
proc url_BooksCloudloadingUpdateBook_578922(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksCloudloadingUpdateBook_578921(path: JsonNode; query: JsonNode;
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
  var valid_578923 = query.getOrDefault("key")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "key", valid_578923
  var valid_578924 = query.getOrDefault("prettyPrint")
  valid_578924 = validateParameter(valid_578924, JBool, required = false,
                                 default = newJBool(true))
  if valid_578924 != nil:
    section.add "prettyPrint", valid_578924
  var valid_578925 = query.getOrDefault("oauth_token")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "oauth_token", valid_578925
  var valid_578926 = query.getOrDefault("alt")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = newJString("json"))
  if valid_578926 != nil:
    section.add "alt", valid_578926
  var valid_578927 = query.getOrDefault("userIp")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "userIp", valid_578927
  var valid_578928 = query.getOrDefault("quotaUser")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "quotaUser", valid_578928
  var valid_578929 = query.getOrDefault("fields")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "fields", valid_578929
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

proc call*(call_578931: Call_BooksCloudloadingUpdateBook_578920; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_578931.validator(path, query, header, formData, body)
  let scheme = call_578931.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578931.url(scheme.get, call_578931.host, call_578931.base,
                         call_578931.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578931, url, valid)

proc call*(call_578932: Call_BooksCloudloadingUpdateBook_578920; key: string = "";
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
  var query_578933 = newJObject()
  var body_578934 = newJObject()
  add(query_578933, "key", newJString(key))
  add(query_578933, "prettyPrint", newJBool(prettyPrint))
  add(query_578933, "oauth_token", newJString(oauthToken))
  add(query_578933, "alt", newJString(alt))
  add(query_578933, "userIp", newJString(userIp))
  add(query_578933, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578934 = body
  add(query_578933, "fields", newJString(fields))
  result = call_578932.call(nil, query_578933, nil, nil, body_578934)

var booksCloudloadingUpdateBook* = Call_BooksCloudloadingUpdateBook_578920(
    name: "booksCloudloadingUpdateBook", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/cloudloading/updateBook",
    validator: validate_BooksCloudloadingUpdateBook_578921, base: "/books/v1",
    url: url_BooksCloudloadingUpdateBook_578922, schemes: {Scheme.Https})
type
  Call_BooksDictionaryListOfflineMetadata_578935 = ref object of OpenApiRestCall_578364
proc url_BooksDictionaryListOfflineMetadata_578937(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksDictionaryListOfflineMetadata_578936(path: JsonNode;
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
  var valid_578938 = query.getOrDefault("key")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "key", valid_578938
  var valid_578939 = query.getOrDefault("prettyPrint")
  valid_578939 = validateParameter(valid_578939, JBool, required = false,
                                 default = newJBool(true))
  if valid_578939 != nil:
    section.add "prettyPrint", valid_578939
  var valid_578940 = query.getOrDefault("oauth_token")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "oauth_token", valid_578940
  var valid_578941 = query.getOrDefault("alt")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = newJString("json"))
  if valid_578941 != nil:
    section.add "alt", valid_578941
  var valid_578942 = query.getOrDefault("userIp")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "userIp", valid_578942
  var valid_578943 = query.getOrDefault("quotaUser")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "quotaUser", valid_578943
  var valid_578944 = query.getOrDefault("fields")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "fields", valid_578944
  assert query != nil, "query argument is necessary due to required `cpksver` field"
  var valid_578945 = query.getOrDefault("cpksver")
  valid_578945 = validateParameter(valid_578945, JString, required = true,
                                 default = nil)
  if valid_578945 != nil:
    section.add "cpksver", valid_578945
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578946: Call_BooksDictionaryListOfflineMetadata_578935;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of offline dictionary metadata available
  ## 
  let valid = call_578946.validator(path, query, header, formData, body)
  let scheme = call_578946.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578946.url(scheme.get, call_578946.host, call_578946.base,
                         call_578946.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578946, url, valid)

proc call*(call_578947: Call_BooksDictionaryListOfflineMetadata_578935;
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
  var query_578948 = newJObject()
  add(query_578948, "key", newJString(key))
  add(query_578948, "prettyPrint", newJBool(prettyPrint))
  add(query_578948, "oauth_token", newJString(oauthToken))
  add(query_578948, "alt", newJString(alt))
  add(query_578948, "userIp", newJString(userIp))
  add(query_578948, "quotaUser", newJString(quotaUser))
  add(query_578948, "fields", newJString(fields))
  add(query_578948, "cpksver", newJString(cpksver))
  result = call_578947.call(nil, query_578948, nil, nil, nil)

var booksDictionaryListOfflineMetadata* = Call_BooksDictionaryListOfflineMetadata_578935(
    name: "booksDictionaryListOfflineMetadata", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/dictionary/listOfflineMetadata",
    validator: validate_BooksDictionaryListOfflineMetadata_578936,
    base: "/books/v1", url: url_BooksDictionaryListOfflineMetadata_578937,
    schemes: {Scheme.Https})
type
  Call_BooksFamilysharingGetFamilyInfo_578949 = ref object of OpenApiRestCall_578364
proc url_BooksFamilysharingGetFamilyInfo_578951(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksFamilysharingGetFamilyInfo_578950(path: JsonNode;
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
  var valid_578952 = query.getOrDefault("key")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "key", valid_578952
  var valid_578953 = query.getOrDefault("prettyPrint")
  valid_578953 = validateParameter(valid_578953, JBool, required = false,
                                 default = newJBool(true))
  if valid_578953 != nil:
    section.add "prettyPrint", valid_578953
  var valid_578954 = query.getOrDefault("oauth_token")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "oauth_token", valid_578954
  var valid_578955 = query.getOrDefault("source")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "source", valid_578955
  var valid_578956 = query.getOrDefault("alt")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = newJString("json"))
  if valid_578956 != nil:
    section.add "alt", valid_578956
  var valid_578957 = query.getOrDefault("userIp")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "userIp", valid_578957
  var valid_578958 = query.getOrDefault("quotaUser")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "quotaUser", valid_578958
  var valid_578959 = query.getOrDefault("fields")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "fields", valid_578959
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578960: Call_BooksFamilysharingGetFamilyInfo_578949;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information regarding the family that the user is part of.
  ## 
  let valid = call_578960.validator(path, query, header, formData, body)
  let scheme = call_578960.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578960.url(scheme.get, call_578960.host, call_578960.base,
                         call_578960.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578960, url, valid)

proc call*(call_578961: Call_BooksFamilysharingGetFamilyInfo_578949;
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
  var query_578962 = newJObject()
  add(query_578962, "key", newJString(key))
  add(query_578962, "prettyPrint", newJBool(prettyPrint))
  add(query_578962, "oauth_token", newJString(oauthToken))
  add(query_578962, "source", newJString(source))
  add(query_578962, "alt", newJString(alt))
  add(query_578962, "userIp", newJString(userIp))
  add(query_578962, "quotaUser", newJString(quotaUser))
  add(query_578962, "fields", newJString(fields))
  result = call_578961.call(nil, query_578962, nil, nil, nil)

var booksFamilysharingGetFamilyInfo* = Call_BooksFamilysharingGetFamilyInfo_578949(
    name: "booksFamilysharingGetFamilyInfo", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/familysharing/getFamilyInfo",
    validator: validate_BooksFamilysharingGetFamilyInfo_578950, base: "/books/v1",
    url: url_BooksFamilysharingGetFamilyInfo_578951, schemes: {Scheme.Https})
type
  Call_BooksFamilysharingShare_578963 = ref object of OpenApiRestCall_578364
proc url_BooksFamilysharingShare_578965(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksFamilysharingShare_578964(path: JsonNode; query: JsonNode;
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
  var valid_578966 = query.getOrDefault("key")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "key", valid_578966
  var valid_578967 = query.getOrDefault("docId")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "docId", valid_578967
  var valid_578968 = query.getOrDefault("prettyPrint")
  valid_578968 = validateParameter(valid_578968, JBool, required = false,
                                 default = newJBool(true))
  if valid_578968 != nil:
    section.add "prettyPrint", valid_578968
  var valid_578969 = query.getOrDefault("oauth_token")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "oauth_token", valid_578969
  var valid_578970 = query.getOrDefault("volumeId")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "volumeId", valid_578970
  var valid_578971 = query.getOrDefault("source")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "source", valid_578971
  var valid_578972 = query.getOrDefault("alt")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = newJString("json"))
  if valid_578972 != nil:
    section.add "alt", valid_578972
  var valid_578973 = query.getOrDefault("userIp")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "userIp", valid_578973
  var valid_578974 = query.getOrDefault("quotaUser")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "quotaUser", valid_578974
  var valid_578975 = query.getOrDefault("fields")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "fields", valid_578975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578976: Call_BooksFamilysharingShare_578963; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Initiates sharing of the content with the user's family. Empty response indicates success.
  ## 
  let valid = call_578976.validator(path, query, header, formData, body)
  let scheme = call_578976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578976.url(scheme.get, call_578976.host, call_578976.base,
                         call_578976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578976, url, valid)

proc call*(call_578977: Call_BooksFamilysharingShare_578963; key: string = "";
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
  var query_578978 = newJObject()
  add(query_578978, "key", newJString(key))
  add(query_578978, "docId", newJString(docId))
  add(query_578978, "prettyPrint", newJBool(prettyPrint))
  add(query_578978, "oauth_token", newJString(oauthToken))
  add(query_578978, "volumeId", newJString(volumeId))
  add(query_578978, "source", newJString(source))
  add(query_578978, "alt", newJString(alt))
  add(query_578978, "userIp", newJString(userIp))
  add(query_578978, "quotaUser", newJString(quotaUser))
  add(query_578978, "fields", newJString(fields))
  result = call_578977.call(nil, query_578978, nil, nil, nil)

var booksFamilysharingShare* = Call_BooksFamilysharingShare_578963(
    name: "booksFamilysharingShare", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/familysharing/share",
    validator: validate_BooksFamilysharingShare_578964, base: "/books/v1",
    url: url_BooksFamilysharingShare_578965, schemes: {Scheme.Https})
type
  Call_BooksFamilysharingUnshare_578979 = ref object of OpenApiRestCall_578364
proc url_BooksFamilysharingUnshare_578981(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksFamilysharingUnshare_578980(path: JsonNode; query: JsonNode;
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
  var valid_578982 = query.getOrDefault("key")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "key", valid_578982
  var valid_578983 = query.getOrDefault("docId")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "docId", valid_578983
  var valid_578984 = query.getOrDefault("prettyPrint")
  valid_578984 = validateParameter(valid_578984, JBool, required = false,
                                 default = newJBool(true))
  if valid_578984 != nil:
    section.add "prettyPrint", valid_578984
  var valid_578985 = query.getOrDefault("oauth_token")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "oauth_token", valid_578985
  var valid_578986 = query.getOrDefault("volumeId")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "volumeId", valid_578986
  var valid_578987 = query.getOrDefault("source")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "source", valid_578987
  var valid_578988 = query.getOrDefault("alt")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = newJString("json"))
  if valid_578988 != nil:
    section.add "alt", valid_578988
  var valid_578989 = query.getOrDefault("userIp")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "userIp", valid_578989
  var valid_578990 = query.getOrDefault("quotaUser")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "quotaUser", valid_578990
  var valid_578991 = query.getOrDefault("fields")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "fields", valid_578991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578992: Call_BooksFamilysharingUnshare_578979; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Initiates revoking content that has already been shared with the user's family. Empty response indicates success.
  ## 
  let valid = call_578992.validator(path, query, header, formData, body)
  let scheme = call_578992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578992.url(scheme.get, call_578992.host, call_578992.base,
                         call_578992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578992, url, valid)

proc call*(call_578993: Call_BooksFamilysharingUnshare_578979; key: string = "";
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
  var query_578994 = newJObject()
  add(query_578994, "key", newJString(key))
  add(query_578994, "docId", newJString(docId))
  add(query_578994, "prettyPrint", newJBool(prettyPrint))
  add(query_578994, "oauth_token", newJString(oauthToken))
  add(query_578994, "volumeId", newJString(volumeId))
  add(query_578994, "source", newJString(source))
  add(query_578994, "alt", newJString(alt))
  add(query_578994, "userIp", newJString(userIp))
  add(query_578994, "quotaUser", newJString(quotaUser))
  add(query_578994, "fields", newJString(fields))
  result = call_578993.call(nil, query_578994, nil, nil, nil)

var booksFamilysharingUnshare* = Call_BooksFamilysharingUnshare_578979(
    name: "booksFamilysharingUnshare", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/familysharing/unshare",
    validator: validate_BooksFamilysharingUnshare_578980, base: "/books/v1",
    url: url_BooksFamilysharingUnshare_578981, schemes: {Scheme.Https})
type
  Call_BooksMyconfigGetUserSettings_578995 = ref object of OpenApiRestCall_578364
proc url_BooksMyconfigGetUserSettings_578997(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksMyconfigGetUserSettings_578996(path: JsonNode; query: JsonNode;
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
  var valid_578998 = query.getOrDefault("key")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "key", valid_578998
  var valid_578999 = query.getOrDefault("prettyPrint")
  valid_578999 = validateParameter(valid_578999, JBool, required = false,
                                 default = newJBool(true))
  if valid_578999 != nil:
    section.add "prettyPrint", valid_578999
  var valid_579000 = query.getOrDefault("oauth_token")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "oauth_token", valid_579000
  var valid_579001 = query.getOrDefault("alt")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = newJString("json"))
  if valid_579001 != nil:
    section.add "alt", valid_579001
  var valid_579002 = query.getOrDefault("userIp")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "userIp", valid_579002
  var valid_579003 = query.getOrDefault("quotaUser")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "quotaUser", valid_579003
  var valid_579004 = query.getOrDefault("fields")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "fields", valid_579004
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579005: Call_BooksMyconfigGetUserSettings_578995; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current settings for the user.
  ## 
  let valid = call_579005.validator(path, query, header, formData, body)
  let scheme = call_579005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579005.url(scheme.get, call_579005.host, call_579005.base,
                         call_579005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579005, url, valid)

proc call*(call_579006: Call_BooksMyconfigGetUserSettings_578995; key: string = "";
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
  var query_579007 = newJObject()
  add(query_579007, "key", newJString(key))
  add(query_579007, "prettyPrint", newJBool(prettyPrint))
  add(query_579007, "oauth_token", newJString(oauthToken))
  add(query_579007, "alt", newJString(alt))
  add(query_579007, "userIp", newJString(userIp))
  add(query_579007, "quotaUser", newJString(quotaUser))
  add(query_579007, "fields", newJString(fields))
  result = call_579006.call(nil, query_579007, nil, nil, nil)

var booksMyconfigGetUserSettings* = Call_BooksMyconfigGetUserSettings_578995(
    name: "booksMyconfigGetUserSettings", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/myconfig/getUserSettings",
    validator: validate_BooksMyconfigGetUserSettings_578996, base: "/books/v1",
    url: url_BooksMyconfigGetUserSettings_578997, schemes: {Scheme.Https})
type
  Call_BooksMyconfigReleaseDownloadAccess_579008 = ref object of OpenApiRestCall_578364
proc url_BooksMyconfigReleaseDownloadAccess_579010(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksMyconfigReleaseDownloadAccess_579009(path: JsonNode;
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
  var valid_579011 = query.getOrDefault("key")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "key", valid_579011
  var valid_579012 = query.getOrDefault("prettyPrint")
  valid_579012 = validateParameter(valid_579012, JBool, required = false,
                                 default = newJBool(true))
  if valid_579012 != nil:
    section.add "prettyPrint", valid_579012
  var valid_579013 = query.getOrDefault("oauth_token")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "oauth_token", valid_579013
  var valid_579014 = query.getOrDefault("locale")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "locale", valid_579014
  var valid_579015 = query.getOrDefault("source")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "source", valid_579015
  var valid_579016 = query.getOrDefault("alt")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = newJString("json"))
  if valid_579016 != nil:
    section.add "alt", valid_579016
  var valid_579017 = query.getOrDefault("userIp")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "userIp", valid_579017
  var valid_579018 = query.getOrDefault("quotaUser")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "quotaUser", valid_579018
  var valid_579019 = query.getOrDefault("fields")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "fields", valid_579019
  assert query != nil, "query argument is necessary due to required `cpksver` field"
  var valid_579020 = query.getOrDefault("cpksver")
  valid_579020 = validateParameter(valid_579020, JString, required = true,
                                 default = nil)
  if valid_579020 != nil:
    section.add "cpksver", valid_579020
  var valid_579021 = query.getOrDefault("volumeIds")
  valid_579021 = validateParameter(valid_579021, JArray, required = true, default = nil)
  if valid_579021 != nil:
    section.add "volumeIds", valid_579021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579022: Call_BooksMyconfigReleaseDownloadAccess_579008;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Release downloaded content access restriction.
  ## 
  let valid = call_579022.validator(path, query, header, formData, body)
  let scheme = call_579022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579022.url(scheme.get, call_579022.host, call_579022.base,
                         call_579022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579022, url, valid)

proc call*(call_579023: Call_BooksMyconfigReleaseDownloadAccess_579008;
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
  var query_579024 = newJObject()
  add(query_579024, "key", newJString(key))
  add(query_579024, "prettyPrint", newJBool(prettyPrint))
  add(query_579024, "oauth_token", newJString(oauthToken))
  add(query_579024, "locale", newJString(locale))
  add(query_579024, "source", newJString(source))
  add(query_579024, "alt", newJString(alt))
  add(query_579024, "userIp", newJString(userIp))
  add(query_579024, "quotaUser", newJString(quotaUser))
  add(query_579024, "fields", newJString(fields))
  add(query_579024, "cpksver", newJString(cpksver))
  if volumeIds != nil:
    query_579024.add "volumeIds", volumeIds
  result = call_579023.call(nil, query_579024, nil, nil, nil)

var booksMyconfigReleaseDownloadAccess* = Call_BooksMyconfigReleaseDownloadAccess_579008(
    name: "booksMyconfigReleaseDownloadAccess", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/myconfig/releaseDownloadAccess",
    validator: validate_BooksMyconfigReleaseDownloadAccess_579009,
    base: "/books/v1", url: url_BooksMyconfigReleaseDownloadAccess_579010,
    schemes: {Scheme.Https})
type
  Call_BooksMyconfigRequestAccess_579025 = ref object of OpenApiRestCall_578364
proc url_BooksMyconfigRequestAccess_579027(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksMyconfigRequestAccess_579026(path: JsonNode; query: JsonNode;
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
  var valid_579028 = query.getOrDefault("key")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "key", valid_579028
  var valid_579029 = query.getOrDefault("prettyPrint")
  valid_579029 = validateParameter(valid_579029, JBool, required = false,
                                 default = newJBool(true))
  if valid_579029 != nil:
    section.add "prettyPrint", valid_579029
  var valid_579030 = query.getOrDefault("oauth_token")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "oauth_token", valid_579030
  var valid_579031 = query.getOrDefault("locale")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "locale", valid_579031
  assert query != nil,
        "query argument is necessary due to required `volumeId` field"
  var valid_579032 = query.getOrDefault("volumeId")
  valid_579032 = validateParameter(valid_579032, JString, required = true,
                                 default = nil)
  if valid_579032 != nil:
    section.add "volumeId", valid_579032
  var valid_579033 = query.getOrDefault("source")
  valid_579033 = validateParameter(valid_579033, JString, required = true,
                                 default = nil)
  if valid_579033 != nil:
    section.add "source", valid_579033
  var valid_579034 = query.getOrDefault("alt")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = newJString("json"))
  if valid_579034 != nil:
    section.add "alt", valid_579034
  var valid_579035 = query.getOrDefault("userIp")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "userIp", valid_579035
  var valid_579036 = query.getOrDefault("quotaUser")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "quotaUser", valid_579036
  var valid_579037 = query.getOrDefault("nonce")
  valid_579037 = validateParameter(valid_579037, JString, required = true,
                                 default = nil)
  if valid_579037 != nil:
    section.add "nonce", valid_579037
  var valid_579038 = query.getOrDefault("fields")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "fields", valid_579038
  var valid_579039 = query.getOrDefault("cpksver")
  valid_579039 = validateParameter(valid_579039, JString, required = true,
                                 default = nil)
  if valid_579039 != nil:
    section.add "cpksver", valid_579039
  var valid_579040 = query.getOrDefault("licenseTypes")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = newJString("BOTH"))
  if valid_579040 != nil:
    section.add "licenseTypes", valid_579040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579041: Call_BooksMyconfigRequestAccess_579025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Request concurrent and download access restrictions.
  ## 
  let valid = call_579041.validator(path, query, header, formData, body)
  let scheme = call_579041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579041.url(scheme.get, call_579041.host, call_579041.base,
                         call_579041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579041, url, valid)

proc call*(call_579042: Call_BooksMyconfigRequestAccess_579025; volumeId: string;
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
  var query_579043 = newJObject()
  add(query_579043, "key", newJString(key))
  add(query_579043, "prettyPrint", newJBool(prettyPrint))
  add(query_579043, "oauth_token", newJString(oauthToken))
  add(query_579043, "locale", newJString(locale))
  add(query_579043, "volumeId", newJString(volumeId))
  add(query_579043, "source", newJString(source))
  add(query_579043, "alt", newJString(alt))
  add(query_579043, "userIp", newJString(userIp))
  add(query_579043, "quotaUser", newJString(quotaUser))
  add(query_579043, "nonce", newJString(nonce))
  add(query_579043, "fields", newJString(fields))
  add(query_579043, "cpksver", newJString(cpksver))
  add(query_579043, "licenseTypes", newJString(licenseTypes))
  result = call_579042.call(nil, query_579043, nil, nil, nil)

var booksMyconfigRequestAccess* = Call_BooksMyconfigRequestAccess_579025(
    name: "booksMyconfigRequestAccess", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/myconfig/requestAccess",
    validator: validate_BooksMyconfigRequestAccess_579026, base: "/books/v1",
    url: url_BooksMyconfigRequestAccess_579027, schemes: {Scheme.Https})
type
  Call_BooksMyconfigSyncVolumeLicenses_579044 = ref object of OpenApiRestCall_578364
proc url_BooksMyconfigSyncVolumeLicenses_579046(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksMyconfigSyncVolumeLicenses_579045(path: JsonNode;
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
  var valid_579047 = query.getOrDefault("key")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "key", valid_579047
  var valid_579048 = query.getOrDefault("prettyPrint")
  valid_579048 = validateParameter(valid_579048, JBool, required = false,
                                 default = newJBool(true))
  if valid_579048 != nil:
    section.add "prettyPrint", valid_579048
  var valid_579049 = query.getOrDefault("oauth_token")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "oauth_token", valid_579049
  var valid_579050 = query.getOrDefault("locale")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "locale", valid_579050
  var valid_579051 = query.getOrDefault("includeNonComicsSeries")
  valid_579051 = validateParameter(valid_579051, JBool, required = false, default = nil)
  if valid_579051 != nil:
    section.add "includeNonComicsSeries", valid_579051
  assert query != nil, "query argument is necessary due to required `source` field"
  var valid_579052 = query.getOrDefault("source")
  valid_579052 = validateParameter(valid_579052, JString, required = true,
                                 default = nil)
  if valid_579052 != nil:
    section.add "source", valid_579052
  var valid_579053 = query.getOrDefault("showPreorders")
  valid_579053 = validateParameter(valid_579053, JBool, required = false, default = nil)
  if valid_579053 != nil:
    section.add "showPreorders", valid_579053
  var valid_579054 = query.getOrDefault("alt")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = newJString("json"))
  if valid_579054 != nil:
    section.add "alt", valid_579054
  var valid_579055 = query.getOrDefault("userIp")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "userIp", valid_579055
  var valid_579056 = query.getOrDefault("quotaUser")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "quotaUser", valid_579056
  var valid_579057 = query.getOrDefault("nonce")
  valid_579057 = validateParameter(valid_579057, JString, required = true,
                                 default = nil)
  if valid_579057 != nil:
    section.add "nonce", valid_579057
  var valid_579058 = query.getOrDefault("features")
  valid_579058 = validateParameter(valid_579058, JArray, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "features", valid_579058
  var valid_579059 = query.getOrDefault("fields")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "fields", valid_579059
  var valid_579060 = query.getOrDefault("cpksver")
  valid_579060 = validateParameter(valid_579060, JString, required = true,
                                 default = nil)
  if valid_579060 != nil:
    section.add "cpksver", valid_579060
  var valid_579061 = query.getOrDefault("volumeIds")
  valid_579061 = validateParameter(valid_579061, JArray, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "volumeIds", valid_579061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579062: Call_BooksMyconfigSyncVolumeLicenses_579044;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Request downloaded content access for specified volumes on the My eBooks shelf.
  ## 
  let valid = call_579062.validator(path, query, header, formData, body)
  let scheme = call_579062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579062.url(scheme.get, call_579062.host, call_579062.base,
                         call_579062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579062, url, valid)

proc call*(call_579063: Call_BooksMyconfigSyncVolumeLicenses_579044;
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
  var query_579064 = newJObject()
  add(query_579064, "key", newJString(key))
  add(query_579064, "prettyPrint", newJBool(prettyPrint))
  add(query_579064, "oauth_token", newJString(oauthToken))
  add(query_579064, "locale", newJString(locale))
  add(query_579064, "includeNonComicsSeries", newJBool(includeNonComicsSeries))
  add(query_579064, "source", newJString(source))
  add(query_579064, "showPreorders", newJBool(showPreorders))
  add(query_579064, "alt", newJString(alt))
  add(query_579064, "userIp", newJString(userIp))
  add(query_579064, "quotaUser", newJString(quotaUser))
  add(query_579064, "nonce", newJString(nonce))
  if features != nil:
    query_579064.add "features", features
  add(query_579064, "fields", newJString(fields))
  add(query_579064, "cpksver", newJString(cpksver))
  if volumeIds != nil:
    query_579064.add "volumeIds", volumeIds
  result = call_579063.call(nil, query_579064, nil, nil, nil)

var booksMyconfigSyncVolumeLicenses* = Call_BooksMyconfigSyncVolumeLicenses_579044(
    name: "booksMyconfigSyncVolumeLicenses", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/myconfig/syncVolumeLicenses",
    validator: validate_BooksMyconfigSyncVolumeLicenses_579045, base: "/books/v1",
    url: url_BooksMyconfigSyncVolumeLicenses_579046, schemes: {Scheme.Https})
type
  Call_BooksMyconfigUpdateUserSettings_579065 = ref object of OpenApiRestCall_578364
proc url_BooksMyconfigUpdateUserSettings_579067(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksMyconfigUpdateUserSettings_579066(path: JsonNode;
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
  var valid_579068 = query.getOrDefault("key")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "key", valid_579068
  var valid_579069 = query.getOrDefault("prettyPrint")
  valid_579069 = validateParameter(valid_579069, JBool, required = false,
                                 default = newJBool(true))
  if valid_579069 != nil:
    section.add "prettyPrint", valid_579069
  var valid_579070 = query.getOrDefault("oauth_token")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = nil)
  if valid_579070 != nil:
    section.add "oauth_token", valid_579070
  var valid_579071 = query.getOrDefault("alt")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = newJString("json"))
  if valid_579071 != nil:
    section.add "alt", valid_579071
  var valid_579072 = query.getOrDefault("userIp")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "userIp", valid_579072
  var valid_579073 = query.getOrDefault("quotaUser")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "quotaUser", valid_579073
  var valid_579074 = query.getOrDefault("fields")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "fields", valid_579074
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

proc call*(call_579076: Call_BooksMyconfigUpdateUserSettings_579065;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the settings for the user. If a sub-object is specified, it will overwrite the existing sub-object stored in the server. Unspecified sub-objects will retain the existing value.
  ## 
  let valid = call_579076.validator(path, query, header, formData, body)
  let scheme = call_579076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579076.url(scheme.get, call_579076.host, call_579076.base,
                         call_579076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579076, url, valid)

proc call*(call_579077: Call_BooksMyconfigUpdateUserSettings_579065;
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
  var query_579078 = newJObject()
  var body_579079 = newJObject()
  add(query_579078, "key", newJString(key))
  add(query_579078, "prettyPrint", newJBool(prettyPrint))
  add(query_579078, "oauth_token", newJString(oauthToken))
  add(query_579078, "alt", newJString(alt))
  add(query_579078, "userIp", newJString(userIp))
  add(query_579078, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579079 = body
  add(query_579078, "fields", newJString(fields))
  result = call_579077.call(nil, query_579078, nil, nil, body_579079)

var booksMyconfigUpdateUserSettings* = Call_BooksMyconfigUpdateUserSettings_579065(
    name: "booksMyconfigUpdateUserSettings", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/myconfig/updateUserSettings",
    validator: validate_BooksMyconfigUpdateUserSettings_579066, base: "/books/v1",
    url: url_BooksMyconfigUpdateUserSettings_579067, schemes: {Scheme.Https})
type
  Call_BooksMylibraryAnnotationsInsert_579103 = ref object of OpenApiRestCall_578364
proc url_BooksMylibraryAnnotationsInsert_579105(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksMylibraryAnnotationsInsert_579104(path: JsonNode;
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
  var valid_579106 = query.getOrDefault("key")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "key", valid_579106
  var valid_579107 = query.getOrDefault("prettyPrint")
  valid_579107 = validateParameter(valid_579107, JBool, required = false,
                                 default = newJBool(true))
  if valid_579107 != nil:
    section.add "prettyPrint", valid_579107
  var valid_579108 = query.getOrDefault("oauth_token")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "oauth_token", valid_579108
  var valid_579109 = query.getOrDefault("showOnlySummaryInResponse")
  valid_579109 = validateParameter(valid_579109, JBool, required = false, default = nil)
  if valid_579109 != nil:
    section.add "showOnlySummaryInResponse", valid_579109
  var valid_579110 = query.getOrDefault("source")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "source", valid_579110
  var valid_579111 = query.getOrDefault("annotationId")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "annotationId", valid_579111
  var valid_579112 = query.getOrDefault("alt")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = newJString("json"))
  if valid_579112 != nil:
    section.add "alt", valid_579112
  var valid_579113 = query.getOrDefault("userIp")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "userIp", valid_579113
  var valid_579114 = query.getOrDefault("quotaUser")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "quotaUser", valid_579114
  var valid_579115 = query.getOrDefault("country")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = nil)
  if valid_579115 != nil:
    section.add "country", valid_579115
  var valid_579116 = query.getOrDefault("fields")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "fields", valid_579116
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

proc call*(call_579118: Call_BooksMylibraryAnnotationsInsert_579103;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a new annotation.
  ## 
  let valid = call_579118.validator(path, query, header, formData, body)
  let scheme = call_579118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579118.url(scheme.get, call_579118.host, call_579118.base,
                         call_579118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579118, url, valid)

proc call*(call_579119: Call_BooksMylibraryAnnotationsInsert_579103;
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
  var query_579120 = newJObject()
  var body_579121 = newJObject()
  add(query_579120, "key", newJString(key))
  add(query_579120, "prettyPrint", newJBool(prettyPrint))
  add(query_579120, "oauth_token", newJString(oauthToken))
  add(query_579120, "showOnlySummaryInResponse",
      newJBool(showOnlySummaryInResponse))
  add(query_579120, "source", newJString(source))
  add(query_579120, "annotationId", newJString(annotationId))
  add(query_579120, "alt", newJString(alt))
  add(query_579120, "userIp", newJString(userIp))
  add(query_579120, "quotaUser", newJString(quotaUser))
  add(query_579120, "country", newJString(country))
  if body != nil:
    body_579121 = body
  add(query_579120, "fields", newJString(fields))
  result = call_579119.call(nil, query_579120, nil, nil, body_579121)

var booksMylibraryAnnotationsInsert* = Call_BooksMylibraryAnnotationsInsert_579103(
    name: "booksMylibraryAnnotationsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/mylibrary/annotations",
    validator: validate_BooksMylibraryAnnotationsInsert_579104, base: "/books/v1",
    url: url_BooksMylibraryAnnotationsInsert_579105, schemes: {Scheme.Https})
type
  Call_BooksMylibraryAnnotationsList_579080 = ref object of OpenApiRestCall_578364
proc url_BooksMylibraryAnnotationsList_579082(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksMylibraryAnnotationsList_579081(path: JsonNode; query: JsonNode;
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
  var valid_579083 = query.getOrDefault("key")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "key", valid_579083
  var valid_579084 = query.getOrDefault("prettyPrint")
  valid_579084 = validateParameter(valid_579084, JBool, required = false,
                                 default = newJBool(true))
  if valid_579084 != nil:
    section.add "prettyPrint", valid_579084
  var valid_579085 = query.getOrDefault("oauth_token")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "oauth_token", valid_579085
  var valid_579086 = query.getOrDefault("volumeId")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "volumeId", valid_579086
  var valid_579087 = query.getOrDefault("layerId")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "layerId", valid_579087
  var valid_579088 = query.getOrDefault("source")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "source", valid_579088
  var valid_579089 = query.getOrDefault("layerIds")
  valid_579089 = validateParameter(valid_579089, JArray, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "layerIds", valid_579089
  var valid_579090 = query.getOrDefault("alt")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = newJString("json"))
  if valid_579090 != nil:
    section.add "alt", valid_579090
  var valid_579091 = query.getOrDefault("userIp")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "userIp", valid_579091
  var valid_579092 = query.getOrDefault("contentVersion")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "contentVersion", valid_579092
  var valid_579093 = query.getOrDefault("quotaUser")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "quotaUser", valid_579093
  var valid_579094 = query.getOrDefault("pageToken")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "pageToken", valid_579094
  var valid_579095 = query.getOrDefault("updatedMax")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "updatedMax", valid_579095
  var valid_579096 = query.getOrDefault("updatedMin")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "updatedMin", valid_579096
  var valid_579097 = query.getOrDefault("fields")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "fields", valid_579097
  var valid_579098 = query.getOrDefault("showDeleted")
  valid_579098 = validateParameter(valid_579098, JBool, required = false, default = nil)
  if valid_579098 != nil:
    section.add "showDeleted", valid_579098
  var valid_579099 = query.getOrDefault("maxResults")
  valid_579099 = validateParameter(valid_579099, JInt, required = false, default = nil)
  if valid_579099 != nil:
    section.add "maxResults", valid_579099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579100: Call_BooksMylibraryAnnotationsList_579080; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of annotations, possibly filtered.
  ## 
  let valid = call_579100.validator(path, query, header, formData, body)
  let scheme = call_579100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579100.url(scheme.get, call_579100.host, call_579100.base,
                         call_579100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579100, url, valid)

proc call*(call_579101: Call_BooksMylibraryAnnotationsList_579080;
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
  var query_579102 = newJObject()
  add(query_579102, "key", newJString(key))
  add(query_579102, "prettyPrint", newJBool(prettyPrint))
  add(query_579102, "oauth_token", newJString(oauthToken))
  add(query_579102, "volumeId", newJString(volumeId))
  add(query_579102, "layerId", newJString(layerId))
  add(query_579102, "source", newJString(source))
  if layerIds != nil:
    query_579102.add "layerIds", layerIds
  add(query_579102, "alt", newJString(alt))
  add(query_579102, "userIp", newJString(userIp))
  add(query_579102, "contentVersion", newJString(contentVersion))
  add(query_579102, "quotaUser", newJString(quotaUser))
  add(query_579102, "pageToken", newJString(pageToken))
  add(query_579102, "updatedMax", newJString(updatedMax))
  add(query_579102, "updatedMin", newJString(updatedMin))
  add(query_579102, "fields", newJString(fields))
  add(query_579102, "showDeleted", newJBool(showDeleted))
  add(query_579102, "maxResults", newJInt(maxResults))
  result = call_579101.call(nil, query_579102, nil, nil, nil)

var booksMylibraryAnnotationsList* = Call_BooksMylibraryAnnotationsList_579080(
    name: "booksMylibraryAnnotationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/mylibrary/annotations",
    validator: validate_BooksMylibraryAnnotationsList_579081, base: "/books/v1",
    url: url_BooksMylibraryAnnotationsList_579082, schemes: {Scheme.Https})
type
  Call_BooksMylibraryAnnotationsSummary_579122 = ref object of OpenApiRestCall_578364
proc url_BooksMylibraryAnnotationsSummary_579124(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksMylibraryAnnotationsSummary_579123(path: JsonNode;
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
  var valid_579125 = query.getOrDefault("key")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "key", valid_579125
  var valid_579126 = query.getOrDefault("prettyPrint")
  valid_579126 = validateParameter(valid_579126, JBool, required = false,
                                 default = newJBool(true))
  if valid_579126 != nil:
    section.add "prettyPrint", valid_579126
  var valid_579127 = query.getOrDefault("oauth_token")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "oauth_token", valid_579127
  assert query != nil,
        "query argument is necessary due to required `volumeId` field"
  var valid_579128 = query.getOrDefault("volumeId")
  valid_579128 = validateParameter(valid_579128, JString, required = true,
                                 default = nil)
  if valid_579128 != nil:
    section.add "volumeId", valid_579128
  var valid_579129 = query.getOrDefault("layerIds")
  valid_579129 = validateParameter(valid_579129, JArray, required = true, default = nil)
  if valid_579129 != nil:
    section.add "layerIds", valid_579129
  var valid_579130 = query.getOrDefault("alt")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = newJString("json"))
  if valid_579130 != nil:
    section.add "alt", valid_579130
  var valid_579131 = query.getOrDefault("userIp")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "userIp", valid_579131
  var valid_579132 = query.getOrDefault("quotaUser")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "quotaUser", valid_579132
  var valid_579133 = query.getOrDefault("fields")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "fields", valid_579133
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579134: Call_BooksMylibraryAnnotationsSummary_579122;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the summary of specified layers.
  ## 
  let valid = call_579134.validator(path, query, header, formData, body)
  let scheme = call_579134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579134.url(scheme.get, call_579134.host, call_579134.base,
                         call_579134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579134, url, valid)

proc call*(call_579135: Call_BooksMylibraryAnnotationsSummary_579122;
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
  var query_579136 = newJObject()
  add(query_579136, "key", newJString(key))
  add(query_579136, "prettyPrint", newJBool(prettyPrint))
  add(query_579136, "oauth_token", newJString(oauthToken))
  add(query_579136, "volumeId", newJString(volumeId))
  if layerIds != nil:
    query_579136.add "layerIds", layerIds
  add(query_579136, "alt", newJString(alt))
  add(query_579136, "userIp", newJString(userIp))
  add(query_579136, "quotaUser", newJString(quotaUser))
  add(query_579136, "fields", newJString(fields))
  result = call_579135.call(nil, query_579136, nil, nil, nil)

var booksMylibraryAnnotationsSummary* = Call_BooksMylibraryAnnotationsSummary_579122(
    name: "booksMylibraryAnnotationsSummary", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/mylibrary/annotations/summary",
    validator: validate_BooksMylibraryAnnotationsSummary_579123,
    base: "/books/v1", url: url_BooksMylibraryAnnotationsSummary_579124,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryAnnotationsUpdate_579137 = ref object of OpenApiRestCall_578364
proc url_BooksMylibraryAnnotationsUpdate_579139(protocol: Scheme; host: string;
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

proc validate_BooksMylibraryAnnotationsUpdate_579138(path: JsonNode;
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
  var valid_579154 = path.getOrDefault("annotationId")
  valid_579154 = validateParameter(valid_579154, JString, required = true,
                                 default = nil)
  if valid_579154 != nil:
    section.add "annotationId", valid_579154
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
  var valid_579155 = query.getOrDefault("key")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = nil)
  if valid_579155 != nil:
    section.add "key", valid_579155
  var valid_579156 = query.getOrDefault("prettyPrint")
  valid_579156 = validateParameter(valid_579156, JBool, required = false,
                                 default = newJBool(true))
  if valid_579156 != nil:
    section.add "prettyPrint", valid_579156
  var valid_579157 = query.getOrDefault("oauth_token")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = nil)
  if valid_579157 != nil:
    section.add "oauth_token", valid_579157
  var valid_579158 = query.getOrDefault("source")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "source", valid_579158
  var valid_579159 = query.getOrDefault("alt")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = newJString("json"))
  if valid_579159 != nil:
    section.add "alt", valid_579159
  var valid_579160 = query.getOrDefault("userIp")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "userIp", valid_579160
  var valid_579161 = query.getOrDefault("quotaUser")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = nil)
  if valid_579161 != nil:
    section.add "quotaUser", valid_579161
  var valid_579162 = query.getOrDefault("fields")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "fields", valid_579162
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

proc call*(call_579164: Call_BooksMylibraryAnnotationsUpdate_579137;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing annotation.
  ## 
  let valid = call_579164.validator(path, query, header, formData, body)
  let scheme = call_579164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579164.url(scheme.get, call_579164.host, call_579164.base,
                         call_579164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579164, url, valid)

proc call*(call_579165: Call_BooksMylibraryAnnotationsUpdate_579137;
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
  var path_579166 = newJObject()
  var query_579167 = newJObject()
  var body_579168 = newJObject()
  add(query_579167, "key", newJString(key))
  add(query_579167, "prettyPrint", newJBool(prettyPrint))
  add(query_579167, "oauth_token", newJString(oauthToken))
  add(query_579167, "source", newJString(source))
  add(path_579166, "annotationId", newJString(annotationId))
  add(query_579167, "alt", newJString(alt))
  add(query_579167, "userIp", newJString(userIp))
  add(query_579167, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579168 = body
  add(query_579167, "fields", newJString(fields))
  result = call_579165.call(path_579166, query_579167, nil, nil, body_579168)

var booksMylibraryAnnotationsUpdate* = Call_BooksMylibraryAnnotationsUpdate_579137(
    name: "booksMylibraryAnnotationsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/mylibrary/annotations/{annotationId}",
    validator: validate_BooksMylibraryAnnotationsUpdate_579138, base: "/books/v1",
    url: url_BooksMylibraryAnnotationsUpdate_579139, schemes: {Scheme.Https})
type
  Call_BooksMylibraryAnnotationsDelete_579169 = ref object of OpenApiRestCall_578364
proc url_BooksMylibraryAnnotationsDelete_579171(protocol: Scheme; host: string;
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

proc validate_BooksMylibraryAnnotationsDelete_579170(path: JsonNode;
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
  var valid_579172 = path.getOrDefault("annotationId")
  valid_579172 = validateParameter(valid_579172, JString, required = true,
                                 default = nil)
  if valid_579172 != nil:
    section.add "annotationId", valid_579172
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
  var valid_579173 = query.getOrDefault("key")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "key", valid_579173
  var valid_579174 = query.getOrDefault("prettyPrint")
  valid_579174 = validateParameter(valid_579174, JBool, required = false,
                                 default = newJBool(true))
  if valid_579174 != nil:
    section.add "prettyPrint", valid_579174
  var valid_579175 = query.getOrDefault("oauth_token")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "oauth_token", valid_579175
  var valid_579176 = query.getOrDefault("source")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "source", valid_579176
  var valid_579177 = query.getOrDefault("alt")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = newJString("json"))
  if valid_579177 != nil:
    section.add "alt", valid_579177
  var valid_579178 = query.getOrDefault("userIp")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "userIp", valid_579178
  var valid_579179 = query.getOrDefault("quotaUser")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "quotaUser", valid_579179
  var valid_579180 = query.getOrDefault("fields")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = nil)
  if valid_579180 != nil:
    section.add "fields", valid_579180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579181: Call_BooksMylibraryAnnotationsDelete_579169;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an annotation.
  ## 
  let valid = call_579181.validator(path, query, header, formData, body)
  let scheme = call_579181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579181.url(scheme.get, call_579181.host, call_579181.base,
                         call_579181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579181, url, valid)

proc call*(call_579182: Call_BooksMylibraryAnnotationsDelete_579169;
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
  var path_579183 = newJObject()
  var query_579184 = newJObject()
  add(query_579184, "key", newJString(key))
  add(query_579184, "prettyPrint", newJBool(prettyPrint))
  add(query_579184, "oauth_token", newJString(oauthToken))
  add(query_579184, "source", newJString(source))
  add(path_579183, "annotationId", newJString(annotationId))
  add(query_579184, "alt", newJString(alt))
  add(query_579184, "userIp", newJString(userIp))
  add(query_579184, "quotaUser", newJString(quotaUser))
  add(query_579184, "fields", newJString(fields))
  result = call_579182.call(path_579183, query_579184, nil, nil, nil)

var booksMylibraryAnnotationsDelete* = Call_BooksMylibraryAnnotationsDelete_579169(
    name: "booksMylibraryAnnotationsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/mylibrary/annotations/{annotationId}",
    validator: validate_BooksMylibraryAnnotationsDelete_579170, base: "/books/v1",
    url: url_BooksMylibraryAnnotationsDelete_579171, schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesList_579185 = ref object of OpenApiRestCall_578364
proc url_BooksMylibraryBookshelvesList_579187(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksMylibraryBookshelvesList_579186(path: JsonNode; query: JsonNode;
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
  var valid_579188 = query.getOrDefault("key")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = nil)
  if valid_579188 != nil:
    section.add "key", valid_579188
  var valid_579189 = query.getOrDefault("prettyPrint")
  valid_579189 = validateParameter(valid_579189, JBool, required = false,
                                 default = newJBool(true))
  if valid_579189 != nil:
    section.add "prettyPrint", valid_579189
  var valid_579190 = query.getOrDefault("oauth_token")
  valid_579190 = validateParameter(valid_579190, JString, required = false,
                                 default = nil)
  if valid_579190 != nil:
    section.add "oauth_token", valid_579190
  var valid_579191 = query.getOrDefault("source")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "source", valid_579191
  var valid_579192 = query.getOrDefault("alt")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = newJString("json"))
  if valid_579192 != nil:
    section.add "alt", valid_579192
  var valid_579193 = query.getOrDefault("userIp")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = nil)
  if valid_579193 != nil:
    section.add "userIp", valid_579193
  var valid_579194 = query.getOrDefault("quotaUser")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "quotaUser", valid_579194
  var valid_579195 = query.getOrDefault("fields")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "fields", valid_579195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579196: Call_BooksMylibraryBookshelvesList_579185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of bookshelves belonging to the authenticated user.
  ## 
  let valid = call_579196.validator(path, query, header, formData, body)
  let scheme = call_579196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579196.url(scheme.get, call_579196.host, call_579196.base,
                         call_579196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579196, url, valid)

proc call*(call_579197: Call_BooksMylibraryBookshelvesList_579185;
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
  var query_579198 = newJObject()
  add(query_579198, "key", newJString(key))
  add(query_579198, "prettyPrint", newJBool(prettyPrint))
  add(query_579198, "oauth_token", newJString(oauthToken))
  add(query_579198, "source", newJString(source))
  add(query_579198, "alt", newJString(alt))
  add(query_579198, "userIp", newJString(userIp))
  add(query_579198, "quotaUser", newJString(quotaUser))
  add(query_579198, "fields", newJString(fields))
  result = call_579197.call(nil, query_579198, nil, nil, nil)

var booksMylibraryBookshelvesList* = Call_BooksMylibraryBookshelvesList_579185(
    name: "booksMylibraryBookshelvesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/mylibrary/bookshelves",
    validator: validate_BooksMylibraryBookshelvesList_579186, base: "/books/v1",
    url: url_BooksMylibraryBookshelvesList_579187, schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesGet_579199 = ref object of OpenApiRestCall_578364
proc url_BooksMylibraryBookshelvesGet_579201(protocol: Scheme; host: string;
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

proc validate_BooksMylibraryBookshelvesGet_579200(path: JsonNode; query: JsonNode;
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
  var valid_579202 = path.getOrDefault("shelf")
  valid_579202 = validateParameter(valid_579202, JString, required = true,
                                 default = nil)
  if valid_579202 != nil:
    section.add "shelf", valid_579202
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
  var valid_579203 = query.getOrDefault("key")
  valid_579203 = validateParameter(valid_579203, JString, required = false,
                                 default = nil)
  if valid_579203 != nil:
    section.add "key", valid_579203
  var valid_579204 = query.getOrDefault("prettyPrint")
  valid_579204 = validateParameter(valid_579204, JBool, required = false,
                                 default = newJBool(true))
  if valid_579204 != nil:
    section.add "prettyPrint", valid_579204
  var valid_579205 = query.getOrDefault("oauth_token")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = nil)
  if valid_579205 != nil:
    section.add "oauth_token", valid_579205
  var valid_579206 = query.getOrDefault("source")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = nil)
  if valid_579206 != nil:
    section.add "source", valid_579206
  var valid_579207 = query.getOrDefault("alt")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = newJString("json"))
  if valid_579207 != nil:
    section.add "alt", valid_579207
  var valid_579208 = query.getOrDefault("userIp")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = nil)
  if valid_579208 != nil:
    section.add "userIp", valid_579208
  var valid_579209 = query.getOrDefault("quotaUser")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = nil)
  if valid_579209 != nil:
    section.add "quotaUser", valid_579209
  var valid_579210 = query.getOrDefault("fields")
  valid_579210 = validateParameter(valid_579210, JString, required = false,
                                 default = nil)
  if valid_579210 != nil:
    section.add "fields", valid_579210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579211: Call_BooksMylibraryBookshelvesGet_579199; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves metadata for a specific bookshelf belonging to the authenticated user.
  ## 
  let valid = call_579211.validator(path, query, header, formData, body)
  let scheme = call_579211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579211.url(scheme.get, call_579211.host, call_579211.base,
                         call_579211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579211, url, valid)

proc call*(call_579212: Call_BooksMylibraryBookshelvesGet_579199; shelf: string;
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
  var path_579213 = newJObject()
  var query_579214 = newJObject()
  add(query_579214, "key", newJString(key))
  add(query_579214, "prettyPrint", newJBool(prettyPrint))
  add(query_579214, "oauth_token", newJString(oauthToken))
  add(query_579214, "source", newJString(source))
  add(query_579214, "alt", newJString(alt))
  add(query_579214, "userIp", newJString(userIp))
  add(query_579214, "quotaUser", newJString(quotaUser))
  add(path_579213, "shelf", newJString(shelf))
  add(query_579214, "fields", newJString(fields))
  result = call_579212.call(path_579213, query_579214, nil, nil, nil)

var booksMylibraryBookshelvesGet* = Call_BooksMylibraryBookshelvesGet_579199(
    name: "booksMylibraryBookshelvesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/mylibrary/bookshelves/{shelf}",
    validator: validate_BooksMylibraryBookshelvesGet_579200, base: "/books/v1",
    url: url_BooksMylibraryBookshelvesGet_579201, schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesAddVolume_579215 = ref object of OpenApiRestCall_578364
proc url_BooksMylibraryBookshelvesAddVolume_579217(protocol: Scheme; host: string;
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

proc validate_BooksMylibraryBookshelvesAddVolume_579216(path: JsonNode;
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
  var valid_579218 = path.getOrDefault("shelf")
  valid_579218 = validateParameter(valid_579218, JString, required = true,
                                 default = nil)
  if valid_579218 != nil:
    section.add "shelf", valid_579218
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
  var valid_579219 = query.getOrDefault("key")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "key", valid_579219
  var valid_579220 = query.getOrDefault("prettyPrint")
  valid_579220 = validateParameter(valid_579220, JBool, required = false,
                                 default = newJBool(true))
  if valid_579220 != nil:
    section.add "prettyPrint", valid_579220
  var valid_579221 = query.getOrDefault("oauth_token")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = nil)
  if valid_579221 != nil:
    section.add "oauth_token", valid_579221
  assert query != nil,
        "query argument is necessary due to required `volumeId` field"
  var valid_579222 = query.getOrDefault("volumeId")
  valid_579222 = validateParameter(valid_579222, JString, required = true,
                                 default = nil)
  if valid_579222 != nil:
    section.add "volumeId", valid_579222
  var valid_579223 = query.getOrDefault("source")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = nil)
  if valid_579223 != nil:
    section.add "source", valid_579223
  var valid_579224 = query.getOrDefault("alt")
  valid_579224 = validateParameter(valid_579224, JString, required = false,
                                 default = newJString("json"))
  if valid_579224 != nil:
    section.add "alt", valid_579224
  var valid_579225 = query.getOrDefault("userIp")
  valid_579225 = validateParameter(valid_579225, JString, required = false,
                                 default = nil)
  if valid_579225 != nil:
    section.add "userIp", valid_579225
  var valid_579226 = query.getOrDefault("quotaUser")
  valid_579226 = validateParameter(valid_579226, JString, required = false,
                                 default = nil)
  if valid_579226 != nil:
    section.add "quotaUser", valid_579226
  var valid_579227 = query.getOrDefault("fields")
  valid_579227 = validateParameter(valid_579227, JString, required = false,
                                 default = nil)
  if valid_579227 != nil:
    section.add "fields", valid_579227
  var valid_579228 = query.getOrDefault("reason")
  valid_579228 = validateParameter(valid_579228, JString, required = false,
                                 default = newJString("IOS_PREX"))
  if valid_579228 != nil:
    section.add "reason", valid_579228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579229: Call_BooksMylibraryBookshelvesAddVolume_579215;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a volume to a bookshelf.
  ## 
  let valid = call_579229.validator(path, query, header, formData, body)
  let scheme = call_579229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579229.url(scheme.get, call_579229.host, call_579229.base,
                         call_579229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579229, url, valid)

proc call*(call_579230: Call_BooksMylibraryBookshelvesAddVolume_579215;
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
  var path_579231 = newJObject()
  var query_579232 = newJObject()
  add(query_579232, "key", newJString(key))
  add(query_579232, "prettyPrint", newJBool(prettyPrint))
  add(query_579232, "oauth_token", newJString(oauthToken))
  add(query_579232, "volumeId", newJString(volumeId))
  add(query_579232, "source", newJString(source))
  add(query_579232, "alt", newJString(alt))
  add(query_579232, "userIp", newJString(userIp))
  add(query_579232, "quotaUser", newJString(quotaUser))
  add(path_579231, "shelf", newJString(shelf))
  add(query_579232, "fields", newJString(fields))
  add(query_579232, "reason", newJString(reason))
  result = call_579230.call(path_579231, query_579232, nil, nil, nil)

var booksMylibraryBookshelvesAddVolume* = Call_BooksMylibraryBookshelvesAddVolume_579215(
    name: "booksMylibraryBookshelvesAddVolume", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/mylibrary/bookshelves/{shelf}/addVolume",
    validator: validate_BooksMylibraryBookshelvesAddVolume_579216,
    base: "/books/v1", url: url_BooksMylibraryBookshelvesAddVolume_579217,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesClearVolumes_579233 = ref object of OpenApiRestCall_578364
proc url_BooksMylibraryBookshelvesClearVolumes_579235(protocol: Scheme;
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

proc validate_BooksMylibraryBookshelvesClearVolumes_579234(path: JsonNode;
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
  var valid_579236 = path.getOrDefault("shelf")
  valid_579236 = validateParameter(valid_579236, JString, required = true,
                                 default = nil)
  if valid_579236 != nil:
    section.add "shelf", valid_579236
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
  var valid_579237 = query.getOrDefault("key")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = nil)
  if valid_579237 != nil:
    section.add "key", valid_579237
  var valid_579238 = query.getOrDefault("prettyPrint")
  valid_579238 = validateParameter(valid_579238, JBool, required = false,
                                 default = newJBool(true))
  if valid_579238 != nil:
    section.add "prettyPrint", valid_579238
  var valid_579239 = query.getOrDefault("oauth_token")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = nil)
  if valid_579239 != nil:
    section.add "oauth_token", valid_579239
  var valid_579240 = query.getOrDefault("source")
  valid_579240 = validateParameter(valid_579240, JString, required = false,
                                 default = nil)
  if valid_579240 != nil:
    section.add "source", valid_579240
  var valid_579241 = query.getOrDefault("alt")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = newJString("json"))
  if valid_579241 != nil:
    section.add "alt", valid_579241
  var valid_579242 = query.getOrDefault("userIp")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = nil)
  if valid_579242 != nil:
    section.add "userIp", valid_579242
  var valid_579243 = query.getOrDefault("quotaUser")
  valid_579243 = validateParameter(valid_579243, JString, required = false,
                                 default = nil)
  if valid_579243 != nil:
    section.add "quotaUser", valid_579243
  var valid_579244 = query.getOrDefault("fields")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = nil)
  if valid_579244 != nil:
    section.add "fields", valid_579244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579245: Call_BooksMylibraryBookshelvesClearVolumes_579233;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Clears all volumes from a bookshelf.
  ## 
  let valid = call_579245.validator(path, query, header, formData, body)
  let scheme = call_579245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579245.url(scheme.get, call_579245.host, call_579245.base,
                         call_579245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579245, url, valid)

proc call*(call_579246: Call_BooksMylibraryBookshelvesClearVolumes_579233;
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
  var path_579247 = newJObject()
  var query_579248 = newJObject()
  add(query_579248, "key", newJString(key))
  add(query_579248, "prettyPrint", newJBool(prettyPrint))
  add(query_579248, "oauth_token", newJString(oauthToken))
  add(query_579248, "source", newJString(source))
  add(query_579248, "alt", newJString(alt))
  add(query_579248, "userIp", newJString(userIp))
  add(query_579248, "quotaUser", newJString(quotaUser))
  add(path_579247, "shelf", newJString(shelf))
  add(query_579248, "fields", newJString(fields))
  result = call_579246.call(path_579247, query_579248, nil, nil, nil)

var booksMylibraryBookshelvesClearVolumes* = Call_BooksMylibraryBookshelvesClearVolumes_579233(
    name: "booksMylibraryBookshelvesClearVolumes", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/mylibrary/bookshelves/{shelf}/clearVolumes",
    validator: validate_BooksMylibraryBookshelvesClearVolumes_579234,
    base: "/books/v1", url: url_BooksMylibraryBookshelvesClearVolumes_579235,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesMoveVolume_579249 = ref object of OpenApiRestCall_578364
proc url_BooksMylibraryBookshelvesMoveVolume_579251(protocol: Scheme; host: string;
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

proc validate_BooksMylibraryBookshelvesMoveVolume_579250(path: JsonNode;
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
  var valid_579252 = path.getOrDefault("shelf")
  valid_579252 = validateParameter(valid_579252, JString, required = true,
                                 default = nil)
  if valid_579252 != nil:
    section.add "shelf", valid_579252
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
  var valid_579253 = query.getOrDefault("key")
  valid_579253 = validateParameter(valid_579253, JString, required = false,
                                 default = nil)
  if valid_579253 != nil:
    section.add "key", valid_579253
  var valid_579254 = query.getOrDefault("prettyPrint")
  valid_579254 = validateParameter(valid_579254, JBool, required = false,
                                 default = newJBool(true))
  if valid_579254 != nil:
    section.add "prettyPrint", valid_579254
  var valid_579255 = query.getOrDefault("oauth_token")
  valid_579255 = validateParameter(valid_579255, JString, required = false,
                                 default = nil)
  if valid_579255 != nil:
    section.add "oauth_token", valid_579255
  assert query != nil,
        "query argument is necessary due to required `volumeId` field"
  var valid_579256 = query.getOrDefault("volumeId")
  valid_579256 = validateParameter(valid_579256, JString, required = true,
                                 default = nil)
  if valid_579256 != nil:
    section.add "volumeId", valid_579256
  var valid_579257 = query.getOrDefault("source")
  valid_579257 = validateParameter(valid_579257, JString, required = false,
                                 default = nil)
  if valid_579257 != nil:
    section.add "source", valid_579257
  var valid_579258 = query.getOrDefault("alt")
  valid_579258 = validateParameter(valid_579258, JString, required = false,
                                 default = newJString("json"))
  if valid_579258 != nil:
    section.add "alt", valid_579258
  var valid_579259 = query.getOrDefault("userIp")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = nil)
  if valid_579259 != nil:
    section.add "userIp", valid_579259
  var valid_579260 = query.getOrDefault("quotaUser")
  valid_579260 = validateParameter(valid_579260, JString, required = false,
                                 default = nil)
  if valid_579260 != nil:
    section.add "quotaUser", valid_579260
  var valid_579261 = query.getOrDefault("volumePosition")
  valid_579261 = validateParameter(valid_579261, JInt, required = true, default = nil)
  if valid_579261 != nil:
    section.add "volumePosition", valid_579261
  var valid_579262 = query.getOrDefault("fields")
  valid_579262 = validateParameter(valid_579262, JString, required = false,
                                 default = nil)
  if valid_579262 != nil:
    section.add "fields", valid_579262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579263: Call_BooksMylibraryBookshelvesMoveVolume_579249;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Moves a volume within a bookshelf.
  ## 
  let valid = call_579263.validator(path, query, header, formData, body)
  let scheme = call_579263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579263.url(scheme.get, call_579263.host, call_579263.base,
                         call_579263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579263, url, valid)

proc call*(call_579264: Call_BooksMylibraryBookshelvesMoveVolume_579249;
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
  var path_579265 = newJObject()
  var query_579266 = newJObject()
  add(query_579266, "key", newJString(key))
  add(query_579266, "prettyPrint", newJBool(prettyPrint))
  add(query_579266, "oauth_token", newJString(oauthToken))
  add(query_579266, "volumeId", newJString(volumeId))
  add(query_579266, "source", newJString(source))
  add(query_579266, "alt", newJString(alt))
  add(query_579266, "userIp", newJString(userIp))
  add(query_579266, "quotaUser", newJString(quotaUser))
  add(query_579266, "volumePosition", newJInt(volumePosition))
  add(path_579265, "shelf", newJString(shelf))
  add(query_579266, "fields", newJString(fields))
  result = call_579264.call(path_579265, query_579266, nil, nil, nil)

var booksMylibraryBookshelvesMoveVolume* = Call_BooksMylibraryBookshelvesMoveVolume_579249(
    name: "booksMylibraryBookshelvesMoveVolume", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/mylibrary/bookshelves/{shelf}/moveVolume",
    validator: validate_BooksMylibraryBookshelvesMoveVolume_579250,
    base: "/books/v1", url: url_BooksMylibraryBookshelvesMoveVolume_579251,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesRemoveVolume_579267 = ref object of OpenApiRestCall_578364
proc url_BooksMylibraryBookshelvesRemoveVolume_579269(protocol: Scheme;
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

proc validate_BooksMylibraryBookshelvesRemoveVolume_579268(path: JsonNode;
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
  var valid_579270 = path.getOrDefault("shelf")
  valid_579270 = validateParameter(valid_579270, JString, required = true,
                                 default = nil)
  if valid_579270 != nil:
    section.add "shelf", valid_579270
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
  var valid_579271 = query.getOrDefault("key")
  valid_579271 = validateParameter(valid_579271, JString, required = false,
                                 default = nil)
  if valid_579271 != nil:
    section.add "key", valid_579271
  var valid_579272 = query.getOrDefault("prettyPrint")
  valid_579272 = validateParameter(valid_579272, JBool, required = false,
                                 default = newJBool(true))
  if valid_579272 != nil:
    section.add "prettyPrint", valid_579272
  var valid_579273 = query.getOrDefault("oauth_token")
  valid_579273 = validateParameter(valid_579273, JString, required = false,
                                 default = nil)
  if valid_579273 != nil:
    section.add "oauth_token", valid_579273
  assert query != nil,
        "query argument is necessary due to required `volumeId` field"
  var valid_579274 = query.getOrDefault("volumeId")
  valid_579274 = validateParameter(valid_579274, JString, required = true,
                                 default = nil)
  if valid_579274 != nil:
    section.add "volumeId", valid_579274
  var valid_579275 = query.getOrDefault("source")
  valid_579275 = validateParameter(valid_579275, JString, required = false,
                                 default = nil)
  if valid_579275 != nil:
    section.add "source", valid_579275
  var valid_579276 = query.getOrDefault("alt")
  valid_579276 = validateParameter(valid_579276, JString, required = false,
                                 default = newJString("json"))
  if valid_579276 != nil:
    section.add "alt", valid_579276
  var valid_579277 = query.getOrDefault("userIp")
  valid_579277 = validateParameter(valid_579277, JString, required = false,
                                 default = nil)
  if valid_579277 != nil:
    section.add "userIp", valid_579277
  var valid_579278 = query.getOrDefault("quotaUser")
  valid_579278 = validateParameter(valid_579278, JString, required = false,
                                 default = nil)
  if valid_579278 != nil:
    section.add "quotaUser", valid_579278
  var valid_579279 = query.getOrDefault("fields")
  valid_579279 = validateParameter(valid_579279, JString, required = false,
                                 default = nil)
  if valid_579279 != nil:
    section.add "fields", valid_579279
  var valid_579280 = query.getOrDefault("reason")
  valid_579280 = validateParameter(valid_579280, JString, required = false,
                                 default = newJString("ONBOARDING"))
  if valid_579280 != nil:
    section.add "reason", valid_579280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579281: Call_BooksMylibraryBookshelvesRemoveVolume_579267;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a volume from a bookshelf.
  ## 
  let valid = call_579281.validator(path, query, header, formData, body)
  let scheme = call_579281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579281.url(scheme.get, call_579281.host, call_579281.base,
                         call_579281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579281, url, valid)

proc call*(call_579282: Call_BooksMylibraryBookshelvesRemoveVolume_579267;
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
  var path_579283 = newJObject()
  var query_579284 = newJObject()
  add(query_579284, "key", newJString(key))
  add(query_579284, "prettyPrint", newJBool(prettyPrint))
  add(query_579284, "oauth_token", newJString(oauthToken))
  add(query_579284, "volumeId", newJString(volumeId))
  add(query_579284, "source", newJString(source))
  add(query_579284, "alt", newJString(alt))
  add(query_579284, "userIp", newJString(userIp))
  add(query_579284, "quotaUser", newJString(quotaUser))
  add(path_579283, "shelf", newJString(shelf))
  add(query_579284, "fields", newJString(fields))
  add(query_579284, "reason", newJString(reason))
  result = call_579282.call(path_579283, query_579284, nil, nil, nil)

var booksMylibraryBookshelvesRemoveVolume* = Call_BooksMylibraryBookshelvesRemoveVolume_579267(
    name: "booksMylibraryBookshelvesRemoveVolume", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/mylibrary/bookshelves/{shelf}/removeVolume",
    validator: validate_BooksMylibraryBookshelvesRemoveVolume_579268,
    base: "/books/v1", url: url_BooksMylibraryBookshelvesRemoveVolume_579269,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryBookshelvesVolumesList_579285 = ref object of OpenApiRestCall_578364
proc url_BooksMylibraryBookshelvesVolumesList_579287(protocol: Scheme;
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

proc validate_BooksMylibraryBookshelvesVolumesList_579286(path: JsonNode;
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
  var valid_579288 = path.getOrDefault("shelf")
  valid_579288 = validateParameter(valid_579288, JString, required = true,
                                 default = nil)
  if valid_579288 != nil:
    section.add "shelf", valid_579288
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
  var valid_579289 = query.getOrDefault("key")
  valid_579289 = validateParameter(valid_579289, JString, required = false,
                                 default = nil)
  if valid_579289 != nil:
    section.add "key", valid_579289
  var valid_579290 = query.getOrDefault("prettyPrint")
  valid_579290 = validateParameter(valid_579290, JBool, required = false,
                                 default = newJBool(true))
  if valid_579290 != nil:
    section.add "prettyPrint", valid_579290
  var valid_579291 = query.getOrDefault("oauth_token")
  valid_579291 = validateParameter(valid_579291, JString, required = false,
                                 default = nil)
  if valid_579291 != nil:
    section.add "oauth_token", valid_579291
  var valid_579292 = query.getOrDefault("q")
  valid_579292 = validateParameter(valid_579292, JString, required = false,
                                 default = nil)
  if valid_579292 != nil:
    section.add "q", valid_579292
  var valid_579293 = query.getOrDefault("source")
  valid_579293 = validateParameter(valid_579293, JString, required = false,
                                 default = nil)
  if valid_579293 != nil:
    section.add "source", valid_579293
  var valid_579294 = query.getOrDefault("showPreorders")
  valid_579294 = validateParameter(valid_579294, JBool, required = false, default = nil)
  if valid_579294 != nil:
    section.add "showPreorders", valid_579294
  var valid_579295 = query.getOrDefault("alt")
  valid_579295 = validateParameter(valid_579295, JString, required = false,
                                 default = newJString("json"))
  if valid_579295 != nil:
    section.add "alt", valid_579295
  var valid_579296 = query.getOrDefault("userIp")
  valid_579296 = validateParameter(valid_579296, JString, required = false,
                                 default = nil)
  if valid_579296 != nil:
    section.add "userIp", valid_579296
  var valid_579297 = query.getOrDefault("quotaUser")
  valid_579297 = validateParameter(valid_579297, JString, required = false,
                                 default = nil)
  if valid_579297 != nil:
    section.add "quotaUser", valid_579297
  var valid_579298 = query.getOrDefault("startIndex")
  valid_579298 = validateParameter(valid_579298, JInt, required = false, default = nil)
  if valid_579298 != nil:
    section.add "startIndex", valid_579298
  var valid_579299 = query.getOrDefault("country")
  valid_579299 = validateParameter(valid_579299, JString, required = false,
                                 default = nil)
  if valid_579299 != nil:
    section.add "country", valid_579299
  var valid_579300 = query.getOrDefault("projection")
  valid_579300 = validateParameter(valid_579300, JString, required = false,
                                 default = newJString("full"))
  if valid_579300 != nil:
    section.add "projection", valid_579300
  var valid_579301 = query.getOrDefault("fields")
  valid_579301 = validateParameter(valid_579301, JString, required = false,
                                 default = nil)
  if valid_579301 != nil:
    section.add "fields", valid_579301
  var valid_579302 = query.getOrDefault("maxResults")
  valid_579302 = validateParameter(valid_579302, JInt, required = false, default = nil)
  if valid_579302 != nil:
    section.add "maxResults", valid_579302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579303: Call_BooksMylibraryBookshelvesVolumesList_579285;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets volume information for volumes on a bookshelf.
  ## 
  let valid = call_579303.validator(path, query, header, formData, body)
  let scheme = call_579303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579303.url(scheme.get, call_579303.host, call_579303.base,
                         call_579303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579303, url, valid)

proc call*(call_579304: Call_BooksMylibraryBookshelvesVolumesList_579285;
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
  var path_579305 = newJObject()
  var query_579306 = newJObject()
  add(query_579306, "key", newJString(key))
  add(query_579306, "prettyPrint", newJBool(prettyPrint))
  add(query_579306, "oauth_token", newJString(oauthToken))
  add(query_579306, "q", newJString(q))
  add(query_579306, "source", newJString(source))
  add(query_579306, "showPreorders", newJBool(showPreorders))
  add(query_579306, "alt", newJString(alt))
  add(query_579306, "userIp", newJString(userIp))
  add(query_579306, "quotaUser", newJString(quotaUser))
  add(query_579306, "startIndex", newJInt(startIndex))
  add(query_579306, "country", newJString(country))
  add(path_579305, "shelf", newJString(shelf))
  add(query_579306, "projection", newJString(projection))
  add(query_579306, "fields", newJString(fields))
  add(query_579306, "maxResults", newJInt(maxResults))
  result = call_579304.call(path_579305, query_579306, nil, nil, nil)

var booksMylibraryBookshelvesVolumesList* = Call_BooksMylibraryBookshelvesVolumesList_579285(
    name: "booksMylibraryBookshelvesVolumesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/mylibrary/bookshelves/{shelf}/volumes",
    validator: validate_BooksMylibraryBookshelvesVolumesList_579286,
    base: "/books/v1", url: url_BooksMylibraryBookshelvesVolumesList_579287,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryReadingpositionsGet_579307 = ref object of OpenApiRestCall_578364
proc url_BooksMylibraryReadingpositionsGet_579309(protocol: Scheme; host: string;
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

proc validate_BooksMylibraryReadingpositionsGet_579308(path: JsonNode;
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
  var valid_579310 = path.getOrDefault("volumeId")
  valid_579310 = validateParameter(valid_579310, JString, required = true,
                                 default = nil)
  if valid_579310 != nil:
    section.add "volumeId", valid_579310
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
  var valid_579311 = query.getOrDefault("key")
  valid_579311 = validateParameter(valid_579311, JString, required = false,
                                 default = nil)
  if valid_579311 != nil:
    section.add "key", valid_579311
  var valid_579312 = query.getOrDefault("prettyPrint")
  valid_579312 = validateParameter(valid_579312, JBool, required = false,
                                 default = newJBool(true))
  if valid_579312 != nil:
    section.add "prettyPrint", valid_579312
  var valid_579313 = query.getOrDefault("oauth_token")
  valid_579313 = validateParameter(valid_579313, JString, required = false,
                                 default = nil)
  if valid_579313 != nil:
    section.add "oauth_token", valid_579313
  var valid_579314 = query.getOrDefault("source")
  valid_579314 = validateParameter(valid_579314, JString, required = false,
                                 default = nil)
  if valid_579314 != nil:
    section.add "source", valid_579314
  var valid_579315 = query.getOrDefault("alt")
  valid_579315 = validateParameter(valid_579315, JString, required = false,
                                 default = newJString("json"))
  if valid_579315 != nil:
    section.add "alt", valid_579315
  var valid_579316 = query.getOrDefault("userIp")
  valid_579316 = validateParameter(valid_579316, JString, required = false,
                                 default = nil)
  if valid_579316 != nil:
    section.add "userIp", valid_579316
  var valid_579317 = query.getOrDefault("contentVersion")
  valid_579317 = validateParameter(valid_579317, JString, required = false,
                                 default = nil)
  if valid_579317 != nil:
    section.add "contentVersion", valid_579317
  var valid_579318 = query.getOrDefault("quotaUser")
  valid_579318 = validateParameter(valid_579318, JString, required = false,
                                 default = nil)
  if valid_579318 != nil:
    section.add "quotaUser", valid_579318
  var valid_579319 = query.getOrDefault("fields")
  valid_579319 = validateParameter(valid_579319, JString, required = false,
                                 default = nil)
  if valid_579319 != nil:
    section.add "fields", valid_579319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579320: Call_BooksMylibraryReadingpositionsGet_579307;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves my reading position information for a volume.
  ## 
  let valid = call_579320.validator(path, query, header, formData, body)
  let scheme = call_579320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579320.url(scheme.get, call_579320.host, call_579320.base,
                         call_579320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579320, url, valid)

proc call*(call_579321: Call_BooksMylibraryReadingpositionsGet_579307;
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
  var path_579322 = newJObject()
  var query_579323 = newJObject()
  add(query_579323, "key", newJString(key))
  add(query_579323, "prettyPrint", newJBool(prettyPrint))
  add(query_579323, "oauth_token", newJString(oauthToken))
  add(query_579323, "source", newJString(source))
  add(query_579323, "alt", newJString(alt))
  add(query_579323, "userIp", newJString(userIp))
  add(query_579323, "contentVersion", newJString(contentVersion))
  add(query_579323, "quotaUser", newJString(quotaUser))
  add(path_579322, "volumeId", newJString(volumeId))
  add(query_579323, "fields", newJString(fields))
  result = call_579321.call(path_579322, query_579323, nil, nil, nil)

var booksMylibraryReadingpositionsGet* = Call_BooksMylibraryReadingpositionsGet_579307(
    name: "booksMylibraryReadingpositionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/mylibrary/readingpositions/{volumeId}",
    validator: validate_BooksMylibraryReadingpositionsGet_579308,
    base: "/books/v1", url: url_BooksMylibraryReadingpositionsGet_579309,
    schemes: {Scheme.Https})
type
  Call_BooksMylibraryReadingpositionsSetPosition_579324 = ref object of OpenApiRestCall_578364
proc url_BooksMylibraryReadingpositionsSetPosition_579326(protocol: Scheme;
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

proc validate_BooksMylibraryReadingpositionsSetPosition_579325(path: JsonNode;
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
  var valid_579327 = path.getOrDefault("volumeId")
  valid_579327 = validateParameter(valid_579327, JString, required = true,
                                 default = nil)
  if valid_579327 != nil:
    section.add "volumeId", valid_579327
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
  var valid_579328 = query.getOrDefault("key")
  valid_579328 = validateParameter(valid_579328, JString, required = false,
                                 default = nil)
  if valid_579328 != nil:
    section.add "key", valid_579328
  var valid_579329 = query.getOrDefault("prettyPrint")
  valid_579329 = validateParameter(valid_579329, JBool, required = false,
                                 default = newJBool(true))
  if valid_579329 != nil:
    section.add "prettyPrint", valid_579329
  var valid_579330 = query.getOrDefault("oauth_token")
  valid_579330 = validateParameter(valid_579330, JString, required = false,
                                 default = nil)
  if valid_579330 != nil:
    section.add "oauth_token", valid_579330
  var valid_579331 = query.getOrDefault("action")
  valid_579331 = validateParameter(valid_579331, JString, required = false,
                                 default = newJString("bookmark"))
  if valid_579331 != nil:
    section.add "action", valid_579331
  var valid_579332 = query.getOrDefault("source")
  valid_579332 = validateParameter(valid_579332, JString, required = false,
                                 default = nil)
  if valid_579332 != nil:
    section.add "source", valid_579332
  var valid_579333 = query.getOrDefault("alt")
  valid_579333 = validateParameter(valid_579333, JString, required = false,
                                 default = newJString("json"))
  if valid_579333 != nil:
    section.add "alt", valid_579333
  var valid_579334 = query.getOrDefault("userIp")
  valid_579334 = validateParameter(valid_579334, JString, required = false,
                                 default = nil)
  if valid_579334 != nil:
    section.add "userIp", valid_579334
  var valid_579335 = query.getOrDefault("contentVersion")
  valid_579335 = validateParameter(valid_579335, JString, required = false,
                                 default = nil)
  if valid_579335 != nil:
    section.add "contentVersion", valid_579335
  var valid_579336 = query.getOrDefault("quotaUser")
  valid_579336 = validateParameter(valid_579336, JString, required = false,
                                 default = nil)
  if valid_579336 != nil:
    section.add "quotaUser", valid_579336
  assert query != nil,
        "query argument is necessary due to required `position` field"
  var valid_579337 = query.getOrDefault("position")
  valid_579337 = validateParameter(valid_579337, JString, required = true,
                                 default = nil)
  if valid_579337 != nil:
    section.add "position", valid_579337
  var valid_579338 = query.getOrDefault("timestamp")
  valid_579338 = validateParameter(valid_579338, JString, required = true,
                                 default = nil)
  if valid_579338 != nil:
    section.add "timestamp", valid_579338
  var valid_579339 = query.getOrDefault("fields")
  valid_579339 = validateParameter(valid_579339, JString, required = false,
                                 default = nil)
  if valid_579339 != nil:
    section.add "fields", valid_579339
  var valid_579340 = query.getOrDefault("deviceCookie")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = nil)
  if valid_579340 != nil:
    section.add "deviceCookie", valid_579340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579341: Call_BooksMylibraryReadingpositionsSetPosition_579324;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets my reading position information for a volume.
  ## 
  let valid = call_579341.validator(path, query, header, formData, body)
  let scheme = call_579341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579341.url(scheme.get, call_579341.host, call_579341.base,
                         call_579341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579341, url, valid)

proc call*(call_579342: Call_BooksMylibraryReadingpositionsSetPosition_579324;
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
  var path_579343 = newJObject()
  var query_579344 = newJObject()
  add(query_579344, "key", newJString(key))
  add(query_579344, "prettyPrint", newJBool(prettyPrint))
  add(query_579344, "oauth_token", newJString(oauthToken))
  add(query_579344, "action", newJString(action))
  add(query_579344, "source", newJString(source))
  add(query_579344, "alt", newJString(alt))
  add(query_579344, "userIp", newJString(userIp))
  add(query_579344, "contentVersion", newJString(contentVersion))
  add(query_579344, "quotaUser", newJString(quotaUser))
  add(query_579344, "position", newJString(position))
  add(path_579343, "volumeId", newJString(volumeId))
  add(query_579344, "timestamp", newJString(timestamp))
  add(query_579344, "fields", newJString(fields))
  add(query_579344, "deviceCookie", newJString(deviceCookie))
  result = call_579342.call(path_579343, query_579344, nil, nil, nil)

var booksMylibraryReadingpositionsSetPosition* = Call_BooksMylibraryReadingpositionsSetPosition_579324(
    name: "booksMylibraryReadingpositionsSetPosition", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/mylibrary/readingpositions/{volumeId}/setPosition",
    validator: validate_BooksMylibraryReadingpositionsSetPosition_579325,
    base: "/books/v1", url: url_BooksMylibraryReadingpositionsSetPosition_579326,
    schemes: {Scheme.Https})
type
  Call_BooksNotificationGet_579345 = ref object of OpenApiRestCall_578364
proc url_BooksNotificationGet_579347(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksNotificationGet_579346(path: JsonNode; query: JsonNode;
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
  var valid_579348 = query.getOrDefault("key")
  valid_579348 = validateParameter(valid_579348, JString, required = false,
                                 default = nil)
  if valid_579348 != nil:
    section.add "key", valid_579348
  var valid_579349 = query.getOrDefault("prettyPrint")
  valid_579349 = validateParameter(valid_579349, JBool, required = false,
                                 default = newJBool(true))
  if valid_579349 != nil:
    section.add "prettyPrint", valid_579349
  var valid_579350 = query.getOrDefault("oauth_token")
  valid_579350 = validateParameter(valid_579350, JString, required = false,
                                 default = nil)
  if valid_579350 != nil:
    section.add "oauth_token", valid_579350
  var valid_579351 = query.getOrDefault("locale")
  valid_579351 = validateParameter(valid_579351, JString, required = false,
                                 default = nil)
  if valid_579351 != nil:
    section.add "locale", valid_579351
  var valid_579352 = query.getOrDefault("source")
  valid_579352 = validateParameter(valid_579352, JString, required = false,
                                 default = nil)
  if valid_579352 != nil:
    section.add "source", valid_579352
  var valid_579353 = query.getOrDefault("alt")
  valid_579353 = validateParameter(valid_579353, JString, required = false,
                                 default = newJString("json"))
  if valid_579353 != nil:
    section.add "alt", valid_579353
  var valid_579354 = query.getOrDefault("userIp")
  valid_579354 = validateParameter(valid_579354, JString, required = false,
                                 default = nil)
  if valid_579354 != nil:
    section.add "userIp", valid_579354
  var valid_579355 = query.getOrDefault("quotaUser")
  valid_579355 = validateParameter(valid_579355, JString, required = false,
                                 default = nil)
  if valid_579355 != nil:
    section.add "quotaUser", valid_579355
  var valid_579356 = query.getOrDefault("fields")
  valid_579356 = validateParameter(valid_579356, JString, required = false,
                                 default = nil)
  if valid_579356 != nil:
    section.add "fields", valid_579356
  assert query != nil,
        "query argument is necessary due to required `notification_id` field"
  var valid_579357 = query.getOrDefault("notification_id")
  valid_579357 = validateParameter(valid_579357, JString, required = true,
                                 default = nil)
  if valid_579357 != nil:
    section.add "notification_id", valid_579357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579358: Call_BooksNotificationGet_579345; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns notification details for a given notification id.
  ## 
  let valid = call_579358.validator(path, query, header, formData, body)
  let scheme = call_579358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579358.url(scheme.get, call_579358.host, call_579358.base,
                         call_579358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579358, url, valid)

proc call*(call_579359: Call_BooksNotificationGet_579345; notificationId: string;
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
  var query_579360 = newJObject()
  add(query_579360, "key", newJString(key))
  add(query_579360, "prettyPrint", newJBool(prettyPrint))
  add(query_579360, "oauth_token", newJString(oauthToken))
  add(query_579360, "locale", newJString(locale))
  add(query_579360, "source", newJString(source))
  add(query_579360, "alt", newJString(alt))
  add(query_579360, "userIp", newJString(userIp))
  add(query_579360, "quotaUser", newJString(quotaUser))
  add(query_579360, "fields", newJString(fields))
  add(query_579360, "notification_id", newJString(notificationId))
  result = call_579359.call(nil, query_579360, nil, nil, nil)

var booksNotificationGet* = Call_BooksNotificationGet_579345(
    name: "booksNotificationGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/notification/get",
    validator: validate_BooksNotificationGet_579346, base: "/books/v1",
    url: url_BooksNotificationGet_579347, schemes: {Scheme.Https})
type
  Call_BooksOnboardingListCategories_579361 = ref object of OpenApiRestCall_578364
proc url_BooksOnboardingListCategories_579363(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksOnboardingListCategories_579362(path: JsonNode; query: JsonNode;
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
  var valid_579364 = query.getOrDefault("key")
  valid_579364 = validateParameter(valid_579364, JString, required = false,
                                 default = nil)
  if valid_579364 != nil:
    section.add "key", valid_579364
  var valid_579365 = query.getOrDefault("prettyPrint")
  valid_579365 = validateParameter(valid_579365, JBool, required = false,
                                 default = newJBool(true))
  if valid_579365 != nil:
    section.add "prettyPrint", valid_579365
  var valid_579366 = query.getOrDefault("oauth_token")
  valid_579366 = validateParameter(valid_579366, JString, required = false,
                                 default = nil)
  if valid_579366 != nil:
    section.add "oauth_token", valid_579366
  var valid_579367 = query.getOrDefault("locale")
  valid_579367 = validateParameter(valid_579367, JString, required = false,
                                 default = nil)
  if valid_579367 != nil:
    section.add "locale", valid_579367
  var valid_579368 = query.getOrDefault("alt")
  valid_579368 = validateParameter(valid_579368, JString, required = false,
                                 default = newJString("json"))
  if valid_579368 != nil:
    section.add "alt", valid_579368
  var valid_579369 = query.getOrDefault("userIp")
  valid_579369 = validateParameter(valid_579369, JString, required = false,
                                 default = nil)
  if valid_579369 != nil:
    section.add "userIp", valid_579369
  var valid_579370 = query.getOrDefault("quotaUser")
  valid_579370 = validateParameter(valid_579370, JString, required = false,
                                 default = nil)
  if valid_579370 != nil:
    section.add "quotaUser", valid_579370
  var valid_579371 = query.getOrDefault("fields")
  valid_579371 = validateParameter(valid_579371, JString, required = false,
                                 default = nil)
  if valid_579371 != nil:
    section.add "fields", valid_579371
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579372: Call_BooksOnboardingListCategories_579361; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List categories for onboarding experience.
  ## 
  let valid = call_579372.validator(path, query, header, formData, body)
  let scheme = call_579372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579372.url(scheme.get, call_579372.host, call_579372.base,
                         call_579372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579372, url, valid)

proc call*(call_579373: Call_BooksOnboardingListCategories_579361;
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
  var query_579374 = newJObject()
  add(query_579374, "key", newJString(key))
  add(query_579374, "prettyPrint", newJBool(prettyPrint))
  add(query_579374, "oauth_token", newJString(oauthToken))
  add(query_579374, "locale", newJString(locale))
  add(query_579374, "alt", newJString(alt))
  add(query_579374, "userIp", newJString(userIp))
  add(query_579374, "quotaUser", newJString(quotaUser))
  add(query_579374, "fields", newJString(fields))
  result = call_579373.call(nil, query_579374, nil, nil, nil)

var booksOnboardingListCategories* = Call_BooksOnboardingListCategories_579361(
    name: "booksOnboardingListCategories", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/onboarding/listCategories",
    validator: validate_BooksOnboardingListCategories_579362, base: "/books/v1",
    url: url_BooksOnboardingListCategories_579363, schemes: {Scheme.Https})
type
  Call_BooksOnboardingListCategoryVolumes_579375 = ref object of OpenApiRestCall_578364
proc url_BooksOnboardingListCategoryVolumes_579377(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksOnboardingListCategoryVolumes_579376(path: JsonNode;
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
  var valid_579378 = query.getOrDefault("key")
  valid_579378 = validateParameter(valid_579378, JString, required = false,
                                 default = nil)
  if valid_579378 != nil:
    section.add "key", valid_579378
  var valid_579379 = query.getOrDefault("prettyPrint")
  valid_579379 = validateParameter(valid_579379, JBool, required = false,
                                 default = newJBool(true))
  if valid_579379 != nil:
    section.add "prettyPrint", valid_579379
  var valid_579380 = query.getOrDefault("oauth_token")
  valid_579380 = validateParameter(valid_579380, JString, required = false,
                                 default = nil)
  if valid_579380 != nil:
    section.add "oauth_token", valid_579380
  var valid_579381 = query.getOrDefault("locale")
  valid_579381 = validateParameter(valid_579381, JString, required = false,
                                 default = nil)
  if valid_579381 != nil:
    section.add "locale", valid_579381
  var valid_579382 = query.getOrDefault("pageSize")
  valid_579382 = validateParameter(valid_579382, JInt, required = false, default = nil)
  if valid_579382 != nil:
    section.add "pageSize", valid_579382
  var valid_579383 = query.getOrDefault("alt")
  valid_579383 = validateParameter(valid_579383, JString, required = false,
                                 default = newJString("json"))
  if valid_579383 != nil:
    section.add "alt", valid_579383
  var valid_579384 = query.getOrDefault("userIp")
  valid_579384 = validateParameter(valid_579384, JString, required = false,
                                 default = nil)
  if valid_579384 != nil:
    section.add "userIp", valid_579384
  var valid_579385 = query.getOrDefault("quotaUser")
  valid_579385 = validateParameter(valid_579385, JString, required = false,
                                 default = nil)
  if valid_579385 != nil:
    section.add "quotaUser", valid_579385
  var valid_579386 = query.getOrDefault("categoryId")
  valid_579386 = validateParameter(valid_579386, JArray, required = false,
                                 default = nil)
  if valid_579386 != nil:
    section.add "categoryId", valid_579386
  var valid_579387 = query.getOrDefault("pageToken")
  valid_579387 = validateParameter(valid_579387, JString, required = false,
                                 default = nil)
  if valid_579387 != nil:
    section.add "pageToken", valid_579387
  var valid_579388 = query.getOrDefault("maxAllowedMaturityRating")
  valid_579388 = validateParameter(valid_579388, JString, required = false,
                                 default = newJString("mature"))
  if valid_579388 != nil:
    section.add "maxAllowedMaturityRating", valid_579388
  var valid_579389 = query.getOrDefault("fields")
  valid_579389 = validateParameter(valid_579389, JString, required = false,
                                 default = nil)
  if valid_579389 != nil:
    section.add "fields", valid_579389
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579390: Call_BooksOnboardingListCategoryVolumes_579375;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List available volumes under categories for onboarding experience.
  ## 
  let valid = call_579390.validator(path, query, header, formData, body)
  let scheme = call_579390.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579390.url(scheme.get, call_579390.host, call_579390.base,
                         call_579390.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579390, url, valid)

proc call*(call_579391: Call_BooksOnboardingListCategoryVolumes_579375;
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
  var query_579392 = newJObject()
  add(query_579392, "key", newJString(key))
  add(query_579392, "prettyPrint", newJBool(prettyPrint))
  add(query_579392, "oauth_token", newJString(oauthToken))
  add(query_579392, "locale", newJString(locale))
  add(query_579392, "pageSize", newJInt(pageSize))
  add(query_579392, "alt", newJString(alt))
  add(query_579392, "userIp", newJString(userIp))
  add(query_579392, "quotaUser", newJString(quotaUser))
  if categoryId != nil:
    query_579392.add "categoryId", categoryId
  add(query_579392, "pageToken", newJString(pageToken))
  add(query_579392, "maxAllowedMaturityRating",
      newJString(maxAllowedMaturityRating))
  add(query_579392, "fields", newJString(fields))
  result = call_579391.call(nil, query_579392, nil, nil, nil)

var booksOnboardingListCategoryVolumes* = Call_BooksOnboardingListCategoryVolumes_579375(
    name: "booksOnboardingListCategoryVolumes", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/onboarding/listCategoryVolumes",
    validator: validate_BooksOnboardingListCategoryVolumes_579376,
    base: "/books/v1", url: url_BooksOnboardingListCategoryVolumes_579377,
    schemes: {Scheme.Https})
type
  Call_BooksPersonalizedstreamGet_579393 = ref object of OpenApiRestCall_578364
proc url_BooksPersonalizedstreamGet_579395(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksPersonalizedstreamGet_579394(path: JsonNode; query: JsonNode;
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
  var valid_579396 = query.getOrDefault("key")
  valid_579396 = validateParameter(valid_579396, JString, required = false,
                                 default = nil)
  if valid_579396 != nil:
    section.add "key", valid_579396
  var valid_579397 = query.getOrDefault("prettyPrint")
  valid_579397 = validateParameter(valid_579397, JBool, required = false,
                                 default = newJBool(true))
  if valid_579397 != nil:
    section.add "prettyPrint", valid_579397
  var valid_579398 = query.getOrDefault("oauth_token")
  valid_579398 = validateParameter(valid_579398, JString, required = false,
                                 default = nil)
  if valid_579398 != nil:
    section.add "oauth_token", valid_579398
  var valid_579399 = query.getOrDefault("locale")
  valid_579399 = validateParameter(valid_579399, JString, required = false,
                                 default = nil)
  if valid_579399 != nil:
    section.add "locale", valid_579399
  var valid_579400 = query.getOrDefault("source")
  valid_579400 = validateParameter(valid_579400, JString, required = false,
                                 default = nil)
  if valid_579400 != nil:
    section.add "source", valid_579400
  var valid_579401 = query.getOrDefault("alt")
  valid_579401 = validateParameter(valid_579401, JString, required = false,
                                 default = newJString("json"))
  if valid_579401 != nil:
    section.add "alt", valid_579401
  var valid_579402 = query.getOrDefault("userIp")
  valid_579402 = validateParameter(valid_579402, JString, required = false,
                                 default = nil)
  if valid_579402 != nil:
    section.add "userIp", valid_579402
  var valid_579403 = query.getOrDefault("quotaUser")
  valid_579403 = validateParameter(valid_579403, JString, required = false,
                                 default = nil)
  if valid_579403 != nil:
    section.add "quotaUser", valid_579403
  var valid_579404 = query.getOrDefault("maxAllowedMaturityRating")
  valid_579404 = validateParameter(valid_579404, JString, required = false,
                                 default = newJString("mature"))
  if valid_579404 != nil:
    section.add "maxAllowedMaturityRating", valid_579404
  var valid_579405 = query.getOrDefault("fields")
  valid_579405 = validateParameter(valid_579405, JString, required = false,
                                 default = nil)
  if valid_579405 != nil:
    section.add "fields", valid_579405
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579406: Call_BooksPersonalizedstreamGet_579393; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a stream of personalized book clusters
  ## 
  let valid = call_579406.validator(path, query, header, formData, body)
  let scheme = call_579406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579406.url(scheme.get, call_579406.host, call_579406.base,
                         call_579406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579406, url, valid)

proc call*(call_579407: Call_BooksPersonalizedstreamGet_579393; key: string = "";
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
  var query_579408 = newJObject()
  add(query_579408, "key", newJString(key))
  add(query_579408, "prettyPrint", newJBool(prettyPrint))
  add(query_579408, "oauth_token", newJString(oauthToken))
  add(query_579408, "locale", newJString(locale))
  add(query_579408, "source", newJString(source))
  add(query_579408, "alt", newJString(alt))
  add(query_579408, "userIp", newJString(userIp))
  add(query_579408, "quotaUser", newJString(quotaUser))
  add(query_579408, "maxAllowedMaturityRating",
      newJString(maxAllowedMaturityRating))
  add(query_579408, "fields", newJString(fields))
  result = call_579407.call(nil, query_579408, nil, nil, nil)

var booksPersonalizedstreamGet* = Call_BooksPersonalizedstreamGet_579393(
    name: "booksPersonalizedstreamGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/personalizedstream/get",
    validator: validate_BooksPersonalizedstreamGet_579394, base: "/books/v1",
    url: url_BooksPersonalizedstreamGet_579395, schemes: {Scheme.Https})
type
  Call_BooksPromoofferAccept_579409 = ref object of OpenApiRestCall_578364
proc url_BooksPromoofferAccept_579411(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksPromoofferAccept_579410(path: JsonNode; query: JsonNode;
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
  var valid_579412 = query.getOrDefault("key")
  valid_579412 = validateParameter(valid_579412, JString, required = false,
                                 default = nil)
  if valid_579412 != nil:
    section.add "key", valid_579412
  var valid_579413 = query.getOrDefault("prettyPrint")
  valid_579413 = validateParameter(valid_579413, JBool, required = false,
                                 default = newJBool(true))
  if valid_579413 != nil:
    section.add "prettyPrint", valid_579413
  var valid_579414 = query.getOrDefault("oauth_token")
  valid_579414 = validateParameter(valid_579414, JString, required = false,
                                 default = nil)
  if valid_579414 != nil:
    section.add "oauth_token", valid_579414
  var valid_579415 = query.getOrDefault("model")
  valid_579415 = validateParameter(valid_579415, JString, required = false,
                                 default = nil)
  if valid_579415 != nil:
    section.add "model", valid_579415
  var valid_579416 = query.getOrDefault("serial")
  valid_579416 = validateParameter(valid_579416, JString, required = false,
                                 default = nil)
  if valid_579416 != nil:
    section.add "serial", valid_579416
  var valid_579417 = query.getOrDefault("volumeId")
  valid_579417 = validateParameter(valid_579417, JString, required = false,
                                 default = nil)
  if valid_579417 != nil:
    section.add "volumeId", valid_579417
  var valid_579418 = query.getOrDefault("manufacturer")
  valid_579418 = validateParameter(valid_579418, JString, required = false,
                                 default = nil)
  if valid_579418 != nil:
    section.add "manufacturer", valid_579418
  var valid_579419 = query.getOrDefault("alt")
  valid_579419 = validateParameter(valid_579419, JString, required = false,
                                 default = newJString("json"))
  if valid_579419 != nil:
    section.add "alt", valid_579419
  var valid_579420 = query.getOrDefault("userIp")
  valid_579420 = validateParameter(valid_579420, JString, required = false,
                                 default = nil)
  if valid_579420 != nil:
    section.add "userIp", valid_579420
  var valid_579421 = query.getOrDefault("offerId")
  valid_579421 = validateParameter(valid_579421, JString, required = false,
                                 default = nil)
  if valid_579421 != nil:
    section.add "offerId", valid_579421
  var valid_579422 = query.getOrDefault("quotaUser")
  valid_579422 = validateParameter(valid_579422, JString, required = false,
                                 default = nil)
  if valid_579422 != nil:
    section.add "quotaUser", valid_579422
  var valid_579423 = query.getOrDefault("device")
  valid_579423 = validateParameter(valid_579423, JString, required = false,
                                 default = nil)
  if valid_579423 != nil:
    section.add "device", valid_579423
  var valid_579424 = query.getOrDefault("product")
  valid_579424 = validateParameter(valid_579424, JString, required = false,
                                 default = nil)
  if valid_579424 != nil:
    section.add "product", valid_579424
  var valid_579425 = query.getOrDefault("androidId")
  valid_579425 = validateParameter(valid_579425, JString, required = false,
                                 default = nil)
  if valid_579425 != nil:
    section.add "androidId", valid_579425
  var valid_579426 = query.getOrDefault("fields")
  valid_579426 = validateParameter(valid_579426, JString, required = false,
                                 default = nil)
  if valid_579426 != nil:
    section.add "fields", valid_579426
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579427: Call_BooksPromoofferAccept_579409; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_579427.validator(path, query, header, formData, body)
  let scheme = call_579427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579427.url(scheme.get, call_579427.host, call_579427.base,
                         call_579427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579427, url, valid)

proc call*(call_579428: Call_BooksPromoofferAccept_579409; key: string = "";
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
  var query_579429 = newJObject()
  add(query_579429, "key", newJString(key))
  add(query_579429, "prettyPrint", newJBool(prettyPrint))
  add(query_579429, "oauth_token", newJString(oauthToken))
  add(query_579429, "model", newJString(model))
  add(query_579429, "serial", newJString(serial))
  add(query_579429, "volumeId", newJString(volumeId))
  add(query_579429, "manufacturer", newJString(manufacturer))
  add(query_579429, "alt", newJString(alt))
  add(query_579429, "userIp", newJString(userIp))
  add(query_579429, "offerId", newJString(offerId))
  add(query_579429, "quotaUser", newJString(quotaUser))
  add(query_579429, "device", newJString(device))
  add(query_579429, "product", newJString(product))
  add(query_579429, "androidId", newJString(androidId))
  add(query_579429, "fields", newJString(fields))
  result = call_579428.call(nil, query_579429, nil, nil, nil)

var booksPromoofferAccept* = Call_BooksPromoofferAccept_579409(
    name: "booksPromoofferAccept", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/promooffer/accept",
    validator: validate_BooksPromoofferAccept_579410, base: "/books/v1",
    url: url_BooksPromoofferAccept_579411, schemes: {Scheme.Https})
type
  Call_BooksPromoofferDismiss_579430 = ref object of OpenApiRestCall_578364
proc url_BooksPromoofferDismiss_579432(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksPromoofferDismiss_579431(path: JsonNode; query: JsonNode;
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
  var valid_579433 = query.getOrDefault("key")
  valid_579433 = validateParameter(valid_579433, JString, required = false,
                                 default = nil)
  if valid_579433 != nil:
    section.add "key", valid_579433
  var valid_579434 = query.getOrDefault("prettyPrint")
  valid_579434 = validateParameter(valid_579434, JBool, required = false,
                                 default = newJBool(true))
  if valid_579434 != nil:
    section.add "prettyPrint", valid_579434
  var valid_579435 = query.getOrDefault("oauth_token")
  valid_579435 = validateParameter(valid_579435, JString, required = false,
                                 default = nil)
  if valid_579435 != nil:
    section.add "oauth_token", valid_579435
  var valid_579436 = query.getOrDefault("model")
  valid_579436 = validateParameter(valid_579436, JString, required = false,
                                 default = nil)
  if valid_579436 != nil:
    section.add "model", valid_579436
  var valid_579437 = query.getOrDefault("serial")
  valid_579437 = validateParameter(valid_579437, JString, required = false,
                                 default = nil)
  if valid_579437 != nil:
    section.add "serial", valid_579437
  var valid_579438 = query.getOrDefault("manufacturer")
  valid_579438 = validateParameter(valid_579438, JString, required = false,
                                 default = nil)
  if valid_579438 != nil:
    section.add "manufacturer", valid_579438
  var valid_579439 = query.getOrDefault("alt")
  valid_579439 = validateParameter(valid_579439, JString, required = false,
                                 default = newJString("json"))
  if valid_579439 != nil:
    section.add "alt", valid_579439
  var valid_579440 = query.getOrDefault("userIp")
  valid_579440 = validateParameter(valid_579440, JString, required = false,
                                 default = nil)
  if valid_579440 != nil:
    section.add "userIp", valid_579440
  var valid_579441 = query.getOrDefault("offerId")
  valid_579441 = validateParameter(valid_579441, JString, required = false,
                                 default = nil)
  if valid_579441 != nil:
    section.add "offerId", valid_579441
  var valid_579442 = query.getOrDefault("quotaUser")
  valid_579442 = validateParameter(valid_579442, JString, required = false,
                                 default = nil)
  if valid_579442 != nil:
    section.add "quotaUser", valid_579442
  var valid_579443 = query.getOrDefault("device")
  valid_579443 = validateParameter(valid_579443, JString, required = false,
                                 default = nil)
  if valid_579443 != nil:
    section.add "device", valid_579443
  var valid_579444 = query.getOrDefault("product")
  valid_579444 = validateParameter(valid_579444, JString, required = false,
                                 default = nil)
  if valid_579444 != nil:
    section.add "product", valid_579444
  var valid_579445 = query.getOrDefault("androidId")
  valid_579445 = validateParameter(valid_579445, JString, required = false,
                                 default = nil)
  if valid_579445 != nil:
    section.add "androidId", valid_579445
  var valid_579446 = query.getOrDefault("fields")
  valid_579446 = validateParameter(valid_579446, JString, required = false,
                                 default = nil)
  if valid_579446 != nil:
    section.add "fields", valid_579446
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579447: Call_BooksPromoofferDismiss_579430; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_579447.validator(path, query, header, formData, body)
  let scheme = call_579447.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579447.url(scheme.get, call_579447.host, call_579447.base,
                         call_579447.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579447, url, valid)

proc call*(call_579448: Call_BooksPromoofferDismiss_579430; key: string = "";
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
  var query_579449 = newJObject()
  add(query_579449, "key", newJString(key))
  add(query_579449, "prettyPrint", newJBool(prettyPrint))
  add(query_579449, "oauth_token", newJString(oauthToken))
  add(query_579449, "model", newJString(model))
  add(query_579449, "serial", newJString(serial))
  add(query_579449, "manufacturer", newJString(manufacturer))
  add(query_579449, "alt", newJString(alt))
  add(query_579449, "userIp", newJString(userIp))
  add(query_579449, "offerId", newJString(offerId))
  add(query_579449, "quotaUser", newJString(quotaUser))
  add(query_579449, "device", newJString(device))
  add(query_579449, "product", newJString(product))
  add(query_579449, "androidId", newJString(androidId))
  add(query_579449, "fields", newJString(fields))
  result = call_579448.call(nil, query_579449, nil, nil, nil)

var booksPromoofferDismiss* = Call_BooksPromoofferDismiss_579430(
    name: "booksPromoofferDismiss", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/promooffer/dismiss",
    validator: validate_BooksPromoofferDismiss_579431, base: "/books/v1",
    url: url_BooksPromoofferDismiss_579432, schemes: {Scheme.Https})
type
  Call_BooksPromoofferGet_579450 = ref object of OpenApiRestCall_578364
proc url_BooksPromoofferGet_579452(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksPromoofferGet_579451(path: JsonNode; query: JsonNode;
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
  var valid_579453 = query.getOrDefault("key")
  valid_579453 = validateParameter(valid_579453, JString, required = false,
                                 default = nil)
  if valid_579453 != nil:
    section.add "key", valid_579453
  var valid_579454 = query.getOrDefault("prettyPrint")
  valid_579454 = validateParameter(valid_579454, JBool, required = false,
                                 default = newJBool(true))
  if valid_579454 != nil:
    section.add "prettyPrint", valid_579454
  var valid_579455 = query.getOrDefault("oauth_token")
  valid_579455 = validateParameter(valid_579455, JString, required = false,
                                 default = nil)
  if valid_579455 != nil:
    section.add "oauth_token", valid_579455
  var valid_579456 = query.getOrDefault("model")
  valid_579456 = validateParameter(valid_579456, JString, required = false,
                                 default = nil)
  if valid_579456 != nil:
    section.add "model", valid_579456
  var valid_579457 = query.getOrDefault("serial")
  valid_579457 = validateParameter(valid_579457, JString, required = false,
                                 default = nil)
  if valid_579457 != nil:
    section.add "serial", valid_579457
  var valid_579458 = query.getOrDefault("manufacturer")
  valid_579458 = validateParameter(valid_579458, JString, required = false,
                                 default = nil)
  if valid_579458 != nil:
    section.add "manufacturer", valid_579458
  var valid_579459 = query.getOrDefault("alt")
  valid_579459 = validateParameter(valid_579459, JString, required = false,
                                 default = newJString("json"))
  if valid_579459 != nil:
    section.add "alt", valid_579459
  var valid_579460 = query.getOrDefault("userIp")
  valid_579460 = validateParameter(valid_579460, JString, required = false,
                                 default = nil)
  if valid_579460 != nil:
    section.add "userIp", valid_579460
  var valid_579461 = query.getOrDefault("quotaUser")
  valid_579461 = validateParameter(valid_579461, JString, required = false,
                                 default = nil)
  if valid_579461 != nil:
    section.add "quotaUser", valid_579461
  var valid_579462 = query.getOrDefault("device")
  valid_579462 = validateParameter(valid_579462, JString, required = false,
                                 default = nil)
  if valid_579462 != nil:
    section.add "device", valid_579462
  var valid_579463 = query.getOrDefault("product")
  valid_579463 = validateParameter(valid_579463, JString, required = false,
                                 default = nil)
  if valid_579463 != nil:
    section.add "product", valid_579463
  var valid_579464 = query.getOrDefault("androidId")
  valid_579464 = validateParameter(valid_579464, JString, required = false,
                                 default = nil)
  if valid_579464 != nil:
    section.add "androidId", valid_579464
  var valid_579465 = query.getOrDefault("fields")
  valid_579465 = validateParameter(valid_579465, JString, required = false,
                                 default = nil)
  if valid_579465 != nil:
    section.add "fields", valid_579465
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579466: Call_BooksPromoofferGet_579450; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of promo offers available to the user
  ## 
  let valid = call_579466.validator(path, query, header, formData, body)
  let scheme = call_579466.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579466.url(scheme.get, call_579466.host, call_579466.base,
                         call_579466.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579466, url, valid)

proc call*(call_579467: Call_BooksPromoofferGet_579450; key: string = "";
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
  var query_579468 = newJObject()
  add(query_579468, "key", newJString(key))
  add(query_579468, "prettyPrint", newJBool(prettyPrint))
  add(query_579468, "oauth_token", newJString(oauthToken))
  add(query_579468, "model", newJString(model))
  add(query_579468, "serial", newJString(serial))
  add(query_579468, "manufacturer", newJString(manufacturer))
  add(query_579468, "alt", newJString(alt))
  add(query_579468, "userIp", newJString(userIp))
  add(query_579468, "quotaUser", newJString(quotaUser))
  add(query_579468, "device", newJString(device))
  add(query_579468, "product", newJString(product))
  add(query_579468, "androidId", newJString(androidId))
  add(query_579468, "fields", newJString(fields))
  result = call_579467.call(nil, query_579468, nil, nil, nil)

var booksPromoofferGet* = Call_BooksPromoofferGet_579450(
    name: "booksPromoofferGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/promooffer/get",
    validator: validate_BooksPromoofferGet_579451, base: "/books/v1",
    url: url_BooksPromoofferGet_579452, schemes: {Scheme.Https})
type
  Call_BooksSeriesGet_579469 = ref object of OpenApiRestCall_578364
proc url_BooksSeriesGet_579471(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksSeriesGet_579470(path: JsonNode; query: JsonNode;
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
  var valid_579472 = query.getOrDefault("key")
  valid_579472 = validateParameter(valid_579472, JString, required = false,
                                 default = nil)
  if valid_579472 != nil:
    section.add "key", valid_579472
  var valid_579473 = query.getOrDefault("prettyPrint")
  valid_579473 = validateParameter(valid_579473, JBool, required = false,
                                 default = newJBool(true))
  if valid_579473 != nil:
    section.add "prettyPrint", valid_579473
  var valid_579474 = query.getOrDefault("oauth_token")
  valid_579474 = validateParameter(valid_579474, JString, required = false,
                                 default = nil)
  if valid_579474 != nil:
    section.add "oauth_token", valid_579474
  assert query != nil,
        "query argument is necessary due to required `series_id` field"
  var valid_579475 = query.getOrDefault("series_id")
  valid_579475 = validateParameter(valid_579475, JArray, required = true, default = nil)
  if valid_579475 != nil:
    section.add "series_id", valid_579475
  var valid_579476 = query.getOrDefault("alt")
  valid_579476 = validateParameter(valid_579476, JString, required = false,
                                 default = newJString("json"))
  if valid_579476 != nil:
    section.add "alt", valid_579476
  var valid_579477 = query.getOrDefault("userIp")
  valid_579477 = validateParameter(valid_579477, JString, required = false,
                                 default = nil)
  if valid_579477 != nil:
    section.add "userIp", valid_579477
  var valid_579478 = query.getOrDefault("quotaUser")
  valid_579478 = validateParameter(valid_579478, JString, required = false,
                                 default = nil)
  if valid_579478 != nil:
    section.add "quotaUser", valid_579478
  var valid_579479 = query.getOrDefault("fields")
  valid_579479 = validateParameter(valid_579479, JString, required = false,
                                 default = nil)
  if valid_579479 != nil:
    section.add "fields", valid_579479
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579480: Call_BooksSeriesGet_579469; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Series metadata for the given series ids.
  ## 
  let valid = call_579480.validator(path, query, header, formData, body)
  let scheme = call_579480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579480.url(scheme.get, call_579480.host, call_579480.base,
                         call_579480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579480, url, valid)

proc call*(call_579481: Call_BooksSeriesGet_579469; seriesId: JsonNode;
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
  var query_579482 = newJObject()
  add(query_579482, "key", newJString(key))
  add(query_579482, "prettyPrint", newJBool(prettyPrint))
  add(query_579482, "oauth_token", newJString(oauthToken))
  if seriesId != nil:
    query_579482.add "series_id", seriesId
  add(query_579482, "alt", newJString(alt))
  add(query_579482, "userIp", newJString(userIp))
  add(query_579482, "quotaUser", newJString(quotaUser))
  add(query_579482, "fields", newJString(fields))
  result = call_579481.call(nil, query_579482, nil, nil, nil)

var booksSeriesGet* = Call_BooksSeriesGet_579469(name: "booksSeriesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/series/get",
    validator: validate_BooksSeriesGet_579470, base: "/books/v1",
    url: url_BooksSeriesGet_579471, schemes: {Scheme.Https})
type
  Call_BooksSeriesMembershipGet_579483 = ref object of OpenApiRestCall_578364
proc url_BooksSeriesMembershipGet_579485(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksSeriesMembershipGet_579484(path: JsonNode; query: JsonNode;
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
  var valid_579486 = query.getOrDefault("key")
  valid_579486 = validateParameter(valid_579486, JString, required = false,
                                 default = nil)
  if valid_579486 != nil:
    section.add "key", valid_579486
  var valid_579487 = query.getOrDefault("prettyPrint")
  valid_579487 = validateParameter(valid_579487, JBool, required = false,
                                 default = newJBool(true))
  if valid_579487 != nil:
    section.add "prettyPrint", valid_579487
  var valid_579488 = query.getOrDefault("oauth_token")
  valid_579488 = validateParameter(valid_579488, JString, required = false,
                                 default = nil)
  if valid_579488 != nil:
    section.add "oauth_token", valid_579488
  var valid_579489 = query.getOrDefault("page_size")
  valid_579489 = validateParameter(valid_579489, JInt, required = false, default = nil)
  if valid_579489 != nil:
    section.add "page_size", valid_579489
  assert query != nil,
        "query argument is necessary due to required `series_id` field"
  var valid_579490 = query.getOrDefault("series_id")
  valid_579490 = validateParameter(valid_579490, JString, required = true,
                                 default = nil)
  if valid_579490 != nil:
    section.add "series_id", valid_579490
  var valid_579491 = query.getOrDefault("alt")
  valid_579491 = validateParameter(valid_579491, JString, required = false,
                                 default = newJString("json"))
  if valid_579491 != nil:
    section.add "alt", valid_579491
  var valid_579492 = query.getOrDefault("userIp")
  valid_579492 = validateParameter(valid_579492, JString, required = false,
                                 default = nil)
  if valid_579492 != nil:
    section.add "userIp", valid_579492
  var valid_579493 = query.getOrDefault("quotaUser")
  valid_579493 = validateParameter(valid_579493, JString, required = false,
                                 default = nil)
  if valid_579493 != nil:
    section.add "quotaUser", valid_579493
  var valid_579494 = query.getOrDefault("page_token")
  valid_579494 = validateParameter(valid_579494, JString, required = false,
                                 default = nil)
  if valid_579494 != nil:
    section.add "page_token", valid_579494
  var valid_579495 = query.getOrDefault("fields")
  valid_579495 = validateParameter(valid_579495, JString, required = false,
                                 default = nil)
  if valid_579495 != nil:
    section.add "fields", valid_579495
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579496: Call_BooksSeriesMembershipGet_579483; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Series membership data given the series id.
  ## 
  let valid = call_579496.validator(path, query, header, formData, body)
  let scheme = call_579496.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579496.url(scheme.get, call_579496.host, call_579496.base,
                         call_579496.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579496, url, valid)

proc call*(call_579497: Call_BooksSeriesMembershipGet_579483; seriesId: string;
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
  var query_579498 = newJObject()
  add(query_579498, "key", newJString(key))
  add(query_579498, "prettyPrint", newJBool(prettyPrint))
  add(query_579498, "oauth_token", newJString(oauthToken))
  add(query_579498, "page_size", newJInt(pageSize))
  add(query_579498, "series_id", newJString(seriesId))
  add(query_579498, "alt", newJString(alt))
  add(query_579498, "userIp", newJString(userIp))
  add(query_579498, "quotaUser", newJString(quotaUser))
  add(query_579498, "page_token", newJString(pageToken))
  add(query_579498, "fields", newJString(fields))
  result = call_579497.call(nil, query_579498, nil, nil, nil)

var booksSeriesMembershipGet* = Call_BooksSeriesMembershipGet_579483(
    name: "booksSeriesMembershipGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/series/membership/get",
    validator: validate_BooksSeriesMembershipGet_579484, base: "/books/v1",
    url: url_BooksSeriesMembershipGet_579485, schemes: {Scheme.Https})
type
  Call_BooksBookshelvesList_579499 = ref object of OpenApiRestCall_578364
proc url_BooksBookshelvesList_579501(protocol: Scheme; host: string; base: string;
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

proc validate_BooksBookshelvesList_579500(path: JsonNode; query: JsonNode;
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
  var valid_579502 = path.getOrDefault("userId")
  valid_579502 = validateParameter(valid_579502, JString, required = true,
                                 default = nil)
  if valid_579502 != nil:
    section.add "userId", valid_579502
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
  var valid_579503 = query.getOrDefault("key")
  valid_579503 = validateParameter(valid_579503, JString, required = false,
                                 default = nil)
  if valid_579503 != nil:
    section.add "key", valid_579503
  var valid_579504 = query.getOrDefault("prettyPrint")
  valid_579504 = validateParameter(valid_579504, JBool, required = false,
                                 default = newJBool(true))
  if valid_579504 != nil:
    section.add "prettyPrint", valid_579504
  var valid_579505 = query.getOrDefault("oauth_token")
  valid_579505 = validateParameter(valid_579505, JString, required = false,
                                 default = nil)
  if valid_579505 != nil:
    section.add "oauth_token", valid_579505
  var valid_579506 = query.getOrDefault("source")
  valid_579506 = validateParameter(valid_579506, JString, required = false,
                                 default = nil)
  if valid_579506 != nil:
    section.add "source", valid_579506
  var valid_579507 = query.getOrDefault("alt")
  valid_579507 = validateParameter(valid_579507, JString, required = false,
                                 default = newJString("json"))
  if valid_579507 != nil:
    section.add "alt", valid_579507
  var valid_579508 = query.getOrDefault("userIp")
  valid_579508 = validateParameter(valid_579508, JString, required = false,
                                 default = nil)
  if valid_579508 != nil:
    section.add "userIp", valid_579508
  var valid_579509 = query.getOrDefault("quotaUser")
  valid_579509 = validateParameter(valid_579509, JString, required = false,
                                 default = nil)
  if valid_579509 != nil:
    section.add "quotaUser", valid_579509
  var valid_579510 = query.getOrDefault("fields")
  valid_579510 = validateParameter(valid_579510, JString, required = false,
                                 default = nil)
  if valid_579510 != nil:
    section.add "fields", valid_579510
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579511: Call_BooksBookshelvesList_579499; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of public bookshelves for the specified user.
  ## 
  let valid = call_579511.validator(path, query, header, formData, body)
  let scheme = call_579511.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579511.url(scheme.get, call_579511.host, call_579511.base,
                         call_579511.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579511, url, valid)

proc call*(call_579512: Call_BooksBookshelvesList_579499; userId: string;
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
  var path_579513 = newJObject()
  var query_579514 = newJObject()
  add(query_579514, "key", newJString(key))
  add(query_579514, "prettyPrint", newJBool(prettyPrint))
  add(query_579514, "oauth_token", newJString(oauthToken))
  add(query_579514, "source", newJString(source))
  add(query_579514, "alt", newJString(alt))
  add(query_579514, "userIp", newJString(userIp))
  add(query_579514, "quotaUser", newJString(quotaUser))
  add(path_579513, "userId", newJString(userId))
  add(query_579514, "fields", newJString(fields))
  result = call_579512.call(path_579513, query_579514, nil, nil, nil)

var booksBookshelvesList* = Call_BooksBookshelvesList_579499(
    name: "booksBookshelvesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userId}/bookshelves",
    validator: validate_BooksBookshelvesList_579500, base: "/books/v1",
    url: url_BooksBookshelvesList_579501, schemes: {Scheme.Https})
type
  Call_BooksBookshelvesGet_579515 = ref object of OpenApiRestCall_578364
proc url_BooksBookshelvesGet_579517(protocol: Scheme; host: string; base: string;
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

proc validate_BooksBookshelvesGet_579516(path: JsonNode; query: JsonNode;
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
  var valid_579518 = path.getOrDefault("userId")
  valid_579518 = validateParameter(valid_579518, JString, required = true,
                                 default = nil)
  if valid_579518 != nil:
    section.add "userId", valid_579518
  var valid_579519 = path.getOrDefault("shelf")
  valid_579519 = validateParameter(valid_579519, JString, required = true,
                                 default = nil)
  if valid_579519 != nil:
    section.add "shelf", valid_579519
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
  var valid_579520 = query.getOrDefault("key")
  valid_579520 = validateParameter(valid_579520, JString, required = false,
                                 default = nil)
  if valid_579520 != nil:
    section.add "key", valid_579520
  var valid_579521 = query.getOrDefault("prettyPrint")
  valid_579521 = validateParameter(valid_579521, JBool, required = false,
                                 default = newJBool(true))
  if valid_579521 != nil:
    section.add "prettyPrint", valid_579521
  var valid_579522 = query.getOrDefault("oauth_token")
  valid_579522 = validateParameter(valid_579522, JString, required = false,
                                 default = nil)
  if valid_579522 != nil:
    section.add "oauth_token", valid_579522
  var valid_579523 = query.getOrDefault("source")
  valid_579523 = validateParameter(valid_579523, JString, required = false,
                                 default = nil)
  if valid_579523 != nil:
    section.add "source", valid_579523
  var valid_579524 = query.getOrDefault("alt")
  valid_579524 = validateParameter(valid_579524, JString, required = false,
                                 default = newJString("json"))
  if valid_579524 != nil:
    section.add "alt", valid_579524
  var valid_579525 = query.getOrDefault("userIp")
  valid_579525 = validateParameter(valid_579525, JString, required = false,
                                 default = nil)
  if valid_579525 != nil:
    section.add "userIp", valid_579525
  var valid_579526 = query.getOrDefault("quotaUser")
  valid_579526 = validateParameter(valid_579526, JString, required = false,
                                 default = nil)
  if valid_579526 != nil:
    section.add "quotaUser", valid_579526
  var valid_579527 = query.getOrDefault("fields")
  valid_579527 = validateParameter(valid_579527, JString, required = false,
                                 default = nil)
  if valid_579527 != nil:
    section.add "fields", valid_579527
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579528: Call_BooksBookshelvesGet_579515; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves metadata for a specific bookshelf for the specified user.
  ## 
  let valid = call_579528.validator(path, query, header, formData, body)
  let scheme = call_579528.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579528.url(scheme.get, call_579528.host, call_579528.base,
                         call_579528.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579528, url, valid)

proc call*(call_579529: Call_BooksBookshelvesGet_579515; userId: string;
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
  var path_579530 = newJObject()
  var query_579531 = newJObject()
  add(query_579531, "key", newJString(key))
  add(query_579531, "prettyPrint", newJBool(prettyPrint))
  add(query_579531, "oauth_token", newJString(oauthToken))
  add(query_579531, "source", newJString(source))
  add(query_579531, "alt", newJString(alt))
  add(query_579531, "userIp", newJString(userIp))
  add(query_579531, "quotaUser", newJString(quotaUser))
  add(path_579530, "userId", newJString(userId))
  add(path_579530, "shelf", newJString(shelf))
  add(query_579531, "fields", newJString(fields))
  result = call_579529.call(path_579530, query_579531, nil, nil, nil)

var booksBookshelvesGet* = Call_BooksBookshelvesGet_579515(
    name: "booksBookshelvesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userId}/bookshelves/{shelf}",
    validator: validate_BooksBookshelvesGet_579516, base: "/books/v1",
    url: url_BooksBookshelvesGet_579517, schemes: {Scheme.Https})
type
  Call_BooksBookshelvesVolumesList_579532 = ref object of OpenApiRestCall_578364
proc url_BooksBookshelvesVolumesList_579534(protocol: Scheme; host: string;
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

proc validate_BooksBookshelvesVolumesList_579533(path: JsonNode; query: JsonNode;
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
  var valid_579535 = path.getOrDefault("userId")
  valid_579535 = validateParameter(valid_579535, JString, required = true,
                                 default = nil)
  if valid_579535 != nil:
    section.add "userId", valid_579535
  var valid_579536 = path.getOrDefault("shelf")
  valid_579536 = validateParameter(valid_579536, JString, required = true,
                                 default = nil)
  if valid_579536 != nil:
    section.add "shelf", valid_579536
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
  var valid_579537 = query.getOrDefault("key")
  valid_579537 = validateParameter(valid_579537, JString, required = false,
                                 default = nil)
  if valid_579537 != nil:
    section.add "key", valid_579537
  var valid_579538 = query.getOrDefault("prettyPrint")
  valid_579538 = validateParameter(valid_579538, JBool, required = false,
                                 default = newJBool(true))
  if valid_579538 != nil:
    section.add "prettyPrint", valid_579538
  var valid_579539 = query.getOrDefault("oauth_token")
  valid_579539 = validateParameter(valid_579539, JString, required = false,
                                 default = nil)
  if valid_579539 != nil:
    section.add "oauth_token", valid_579539
  var valid_579540 = query.getOrDefault("source")
  valid_579540 = validateParameter(valid_579540, JString, required = false,
                                 default = nil)
  if valid_579540 != nil:
    section.add "source", valid_579540
  var valid_579541 = query.getOrDefault("showPreorders")
  valid_579541 = validateParameter(valid_579541, JBool, required = false, default = nil)
  if valid_579541 != nil:
    section.add "showPreorders", valid_579541
  var valid_579542 = query.getOrDefault("alt")
  valid_579542 = validateParameter(valid_579542, JString, required = false,
                                 default = newJString("json"))
  if valid_579542 != nil:
    section.add "alt", valid_579542
  var valid_579543 = query.getOrDefault("userIp")
  valid_579543 = validateParameter(valid_579543, JString, required = false,
                                 default = nil)
  if valid_579543 != nil:
    section.add "userIp", valid_579543
  var valid_579544 = query.getOrDefault("quotaUser")
  valid_579544 = validateParameter(valid_579544, JString, required = false,
                                 default = nil)
  if valid_579544 != nil:
    section.add "quotaUser", valid_579544
  var valid_579545 = query.getOrDefault("startIndex")
  valid_579545 = validateParameter(valid_579545, JInt, required = false, default = nil)
  if valid_579545 != nil:
    section.add "startIndex", valid_579545
  var valid_579546 = query.getOrDefault("fields")
  valid_579546 = validateParameter(valid_579546, JString, required = false,
                                 default = nil)
  if valid_579546 != nil:
    section.add "fields", valid_579546
  var valid_579547 = query.getOrDefault("maxResults")
  valid_579547 = validateParameter(valid_579547, JInt, required = false, default = nil)
  if valid_579547 != nil:
    section.add "maxResults", valid_579547
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579548: Call_BooksBookshelvesVolumesList_579532; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves volumes in a specific bookshelf for the specified user.
  ## 
  let valid = call_579548.validator(path, query, header, formData, body)
  let scheme = call_579548.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579548.url(scheme.get, call_579548.host, call_579548.base,
                         call_579548.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579548, url, valid)

proc call*(call_579549: Call_BooksBookshelvesVolumesList_579532; userId: string;
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
  var path_579550 = newJObject()
  var query_579551 = newJObject()
  add(query_579551, "key", newJString(key))
  add(query_579551, "prettyPrint", newJBool(prettyPrint))
  add(query_579551, "oauth_token", newJString(oauthToken))
  add(query_579551, "source", newJString(source))
  add(query_579551, "showPreorders", newJBool(showPreorders))
  add(query_579551, "alt", newJString(alt))
  add(query_579551, "userIp", newJString(userIp))
  add(query_579551, "quotaUser", newJString(quotaUser))
  add(query_579551, "startIndex", newJInt(startIndex))
  add(path_579550, "userId", newJString(userId))
  add(path_579550, "shelf", newJString(shelf))
  add(query_579551, "fields", newJString(fields))
  add(query_579551, "maxResults", newJInt(maxResults))
  result = call_579549.call(path_579550, query_579551, nil, nil, nil)

var booksBookshelvesVolumesList* = Call_BooksBookshelvesVolumesList_579532(
    name: "booksBookshelvesVolumesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/users/{userId}/bookshelves/{shelf}/volumes",
    validator: validate_BooksBookshelvesVolumesList_579533, base: "/books/v1",
    url: url_BooksBookshelvesVolumesList_579534, schemes: {Scheme.Https})
type
  Call_BooksVolumesList_579552 = ref object of OpenApiRestCall_578364
proc url_BooksVolumesList_579554(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksVolumesList_579553(path: JsonNode; query: JsonNode;
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
  var valid_579555 = query.getOrDefault("key")
  valid_579555 = validateParameter(valid_579555, JString, required = false,
                                 default = nil)
  if valid_579555 != nil:
    section.add "key", valid_579555
  var valid_579556 = query.getOrDefault("prettyPrint")
  valid_579556 = validateParameter(valid_579556, JBool, required = false,
                                 default = newJBool(true))
  if valid_579556 != nil:
    section.add "prettyPrint", valid_579556
  var valid_579557 = query.getOrDefault("oauth_token")
  valid_579557 = validateParameter(valid_579557, JString, required = false,
                                 default = nil)
  if valid_579557 != nil:
    section.add "oauth_token", valid_579557
  var valid_579558 = query.getOrDefault("libraryRestrict")
  valid_579558 = validateParameter(valid_579558, JString, required = false,
                                 default = newJString("my-library"))
  if valid_579558 != nil:
    section.add "libraryRestrict", valid_579558
  var valid_579559 = query.getOrDefault("printType")
  valid_579559 = validateParameter(valid_579559, JString, required = false,
                                 default = newJString("all"))
  if valid_579559 != nil:
    section.add "printType", valid_579559
  assert query != nil, "query argument is necessary due to required `q` field"
  var valid_579560 = query.getOrDefault("q")
  valid_579560 = validateParameter(valid_579560, JString, required = true,
                                 default = nil)
  if valid_579560 != nil:
    section.add "q", valid_579560
  var valid_579561 = query.getOrDefault("source")
  valid_579561 = validateParameter(valid_579561, JString, required = false,
                                 default = nil)
  if valid_579561 != nil:
    section.add "source", valid_579561
  var valid_579562 = query.getOrDefault("showPreorders")
  valid_579562 = validateParameter(valid_579562, JBool, required = false, default = nil)
  if valid_579562 != nil:
    section.add "showPreorders", valid_579562
  var valid_579563 = query.getOrDefault("alt")
  valid_579563 = validateParameter(valid_579563, JString, required = false,
                                 default = newJString("json"))
  if valid_579563 != nil:
    section.add "alt", valid_579563
  var valid_579564 = query.getOrDefault("userIp")
  valid_579564 = validateParameter(valid_579564, JString, required = false,
                                 default = nil)
  if valid_579564 != nil:
    section.add "userIp", valid_579564
  var valid_579565 = query.getOrDefault("quotaUser")
  valid_579565 = validateParameter(valid_579565, JString, required = false,
                                 default = nil)
  if valid_579565 != nil:
    section.add "quotaUser", valid_579565
  var valid_579566 = query.getOrDefault("download")
  valid_579566 = validateParameter(valid_579566, JString, required = false,
                                 default = newJString("epub"))
  if valid_579566 != nil:
    section.add "download", valid_579566
  var valid_579567 = query.getOrDefault("orderBy")
  valid_579567 = validateParameter(valid_579567, JString, required = false,
                                 default = newJString("newest"))
  if valid_579567 != nil:
    section.add "orderBy", valid_579567
  var valid_579568 = query.getOrDefault("filter")
  valid_579568 = validateParameter(valid_579568, JString, required = false,
                                 default = newJString("ebooks"))
  if valid_579568 != nil:
    section.add "filter", valid_579568
  var valid_579569 = query.getOrDefault("startIndex")
  valid_579569 = validateParameter(valid_579569, JInt, required = false, default = nil)
  if valid_579569 != nil:
    section.add "startIndex", valid_579569
  var valid_579570 = query.getOrDefault("partner")
  valid_579570 = validateParameter(valid_579570, JString, required = false,
                                 default = nil)
  if valid_579570 != nil:
    section.add "partner", valid_579570
  var valid_579571 = query.getOrDefault("maxAllowedMaturityRating")
  valid_579571 = validateParameter(valid_579571, JString, required = false,
                                 default = newJString("mature"))
  if valid_579571 != nil:
    section.add "maxAllowedMaturityRating", valid_579571
  var valid_579572 = query.getOrDefault("langRestrict")
  valid_579572 = validateParameter(valid_579572, JString, required = false,
                                 default = nil)
  if valid_579572 != nil:
    section.add "langRestrict", valid_579572
  var valid_579573 = query.getOrDefault("projection")
  valid_579573 = validateParameter(valid_579573, JString, required = false,
                                 default = newJString("full"))
  if valid_579573 != nil:
    section.add "projection", valid_579573
  var valid_579574 = query.getOrDefault("fields")
  valid_579574 = validateParameter(valid_579574, JString, required = false,
                                 default = nil)
  if valid_579574 != nil:
    section.add "fields", valid_579574
  var valid_579575 = query.getOrDefault("maxResults")
  valid_579575 = validateParameter(valid_579575, JInt, required = false, default = nil)
  if valid_579575 != nil:
    section.add "maxResults", valid_579575
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579576: Call_BooksVolumesList_579552; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs a book search.
  ## 
  let valid = call_579576.validator(path, query, header, formData, body)
  let scheme = call_579576.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579576.url(scheme.get, call_579576.host, call_579576.base,
                         call_579576.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579576, url, valid)

proc call*(call_579577: Call_BooksVolumesList_579552; q: string; key: string = "";
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
  var query_579578 = newJObject()
  add(query_579578, "key", newJString(key))
  add(query_579578, "prettyPrint", newJBool(prettyPrint))
  add(query_579578, "oauth_token", newJString(oauthToken))
  add(query_579578, "libraryRestrict", newJString(libraryRestrict))
  add(query_579578, "printType", newJString(printType))
  add(query_579578, "q", newJString(q))
  add(query_579578, "source", newJString(source))
  add(query_579578, "showPreorders", newJBool(showPreorders))
  add(query_579578, "alt", newJString(alt))
  add(query_579578, "userIp", newJString(userIp))
  add(query_579578, "quotaUser", newJString(quotaUser))
  add(query_579578, "download", newJString(download))
  add(query_579578, "orderBy", newJString(orderBy))
  add(query_579578, "filter", newJString(filter))
  add(query_579578, "startIndex", newJInt(startIndex))
  add(query_579578, "partner", newJString(partner))
  add(query_579578, "maxAllowedMaturityRating",
      newJString(maxAllowedMaturityRating))
  add(query_579578, "langRestrict", newJString(langRestrict))
  add(query_579578, "projection", newJString(projection))
  add(query_579578, "fields", newJString(fields))
  add(query_579578, "maxResults", newJInt(maxResults))
  result = call_579577.call(nil, query_579578, nil, nil, nil)

var booksVolumesList* = Call_BooksVolumesList_579552(name: "booksVolumesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/volumes",
    validator: validate_BooksVolumesList_579553, base: "/books/v1",
    url: url_BooksVolumesList_579554, schemes: {Scheme.Https})
type
  Call_BooksVolumesMybooksList_579579 = ref object of OpenApiRestCall_578364
proc url_BooksVolumesMybooksList_579581(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksVolumesMybooksList_579580(path: JsonNode; query: JsonNode;
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
  var valid_579582 = query.getOrDefault("key")
  valid_579582 = validateParameter(valid_579582, JString, required = false,
                                 default = nil)
  if valid_579582 != nil:
    section.add "key", valid_579582
  var valid_579583 = query.getOrDefault("prettyPrint")
  valid_579583 = validateParameter(valid_579583, JBool, required = false,
                                 default = newJBool(true))
  if valid_579583 != nil:
    section.add "prettyPrint", valid_579583
  var valid_579584 = query.getOrDefault("oauth_token")
  valid_579584 = validateParameter(valid_579584, JString, required = false,
                                 default = nil)
  if valid_579584 != nil:
    section.add "oauth_token", valid_579584
  var valid_579585 = query.getOrDefault("locale")
  valid_579585 = validateParameter(valid_579585, JString, required = false,
                                 default = nil)
  if valid_579585 != nil:
    section.add "locale", valid_579585
  var valid_579586 = query.getOrDefault("source")
  valid_579586 = validateParameter(valid_579586, JString, required = false,
                                 default = nil)
  if valid_579586 != nil:
    section.add "source", valid_579586
  var valid_579587 = query.getOrDefault("alt")
  valid_579587 = validateParameter(valid_579587, JString, required = false,
                                 default = newJString("json"))
  if valid_579587 != nil:
    section.add "alt", valid_579587
  var valid_579588 = query.getOrDefault("userIp")
  valid_579588 = validateParameter(valid_579588, JString, required = false,
                                 default = nil)
  if valid_579588 != nil:
    section.add "userIp", valid_579588
  var valid_579589 = query.getOrDefault("acquireMethod")
  valid_579589 = validateParameter(valid_579589, JArray, required = false,
                                 default = nil)
  if valid_579589 != nil:
    section.add "acquireMethod", valid_579589
  var valid_579590 = query.getOrDefault("quotaUser")
  valid_579590 = validateParameter(valid_579590, JString, required = false,
                                 default = nil)
  if valid_579590 != nil:
    section.add "quotaUser", valid_579590
  var valid_579591 = query.getOrDefault("startIndex")
  valid_579591 = validateParameter(valid_579591, JInt, required = false, default = nil)
  if valid_579591 != nil:
    section.add "startIndex", valid_579591
  var valid_579592 = query.getOrDefault("country")
  valid_579592 = validateParameter(valid_579592, JString, required = false,
                                 default = nil)
  if valid_579592 != nil:
    section.add "country", valid_579592
  var valid_579593 = query.getOrDefault("processingState")
  valid_579593 = validateParameter(valid_579593, JArray, required = false,
                                 default = nil)
  if valid_579593 != nil:
    section.add "processingState", valid_579593
  var valid_579594 = query.getOrDefault("fields")
  valid_579594 = validateParameter(valid_579594, JString, required = false,
                                 default = nil)
  if valid_579594 != nil:
    section.add "fields", valid_579594
  var valid_579595 = query.getOrDefault("maxResults")
  valid_579595 = validateParameter(valid_579595, JInt, required = false, default = nil)
  if valid_579595 != nil:
    section.add "maxResults", valid_579595
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579596: Call_BooksVolumesMybooksList_579579; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return a list of books in My Library.
  ## 
  let valid = call_579596.validator(path, query, header, formData, body)
  let scheme = call_579596.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579596.url(scheme.get, call_579596.host, call_579596.base,
                         call_579596.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579596, url, valid)

proc call*(call_579597: Call_BooksVolumesMybooksList_579579; key: string = "";
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
  var query_579598 = newJObject()
  add(query_579598, "key", newJString(key))
  add(query_579598, "prettyPrint", newJBool(prettyPrint))
  add(query_579598, "oauth_token", newJString(oauthToken))
  add(query_579598, "locale", newJString(locale))
  add(query_579598, "source", newJString(source))
  add(query_579598, "alt", newJString(alt))
  add(query_579598, "userIp", newJString(userIp))
  if acquireMethod != nil:
    query_579598.add "acquireMethod", acquireMethod
  add(query_579598, "quotaUser", newJString(quotaUser))
  add(query_579598, "startIndex", newJInt(startIndex))
  add(query_579598, "country", newJString(country))
  if processingState != nil:
    query_579598.add "processingState", processingState
  add(query_579598, "fields", newJString(fields))
  add(query_579598, "maxResults", newJInt(maxResults))
  result = call_579597.call(nil, query_579598, nil, nil, nil)

var booksVolumesMybooksList* = Call_BooksVolumesMybooksList_579579(
    name: "booksVolumesMybooksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/volumes/mybooks",
    validator: validate_BooksVolumesMybooksList_579580, base: "/books/v1",
    url: url_BooksVolumesMybooksList_579581, schemes: {Scheme.Https})
type
  Call_BooksVolumesRecommendedList_579599 = ref object of OpenApiRestCall_578364
proc url_BooksVolumesRecommendedList_579601(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksVolumesRecommendedList_579600(path: JsonNode; query: JsonNode;
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
  var valid_579602 = query.getOrDefault("key")
  valid_579602 = validateParameter(valid_579602, JString, required = false,
                                 default = nil)
  if valid_579602 != nil:
    section.add "key", valid_579602
  var valid_579603 = query.getOrDefault("prettyPrint")
  valid_579603 = validateParameter(valid_579603, JBool, required = false,
                                 default = newJBool(true))
  if valid_579603 != nil:
    section.add "prettyPrint", valid_579603
  var valid_579604 = query.getOrDefault("oauth_token")
  valid_579604 = validateParameter(valid_579604, JString, required = false,
                                 default = nil)
  if valid_579604 != nil:
    section.add "oauth_token", valid_579604
  var valid_579605 = query.getOrDefault("locale")
  valid_579605 = validateParameter(valid_579605, JString, required = false,
                                 default = nil)
  if valid_579605 != nil:
    section.add "locale", valid_579605
  var valid_579606 = query.getOrDefault("source")
  valid_579606 = validateParameter(valid_579606, JString, required = false,
                                 default = nil)
  if valid_579606 != nil:
    section.add "source", valid_579606
  var valid_579607 = query.getOrDefault("alt")
  valid_579607 = validateParameter(valid_579607, JString, required = false,
                                 default = newJString("json"))
  if valid_579607 != nil:
    section.add "alt", valid_579607
  var valid_579608 = query.getOrDefault("userIp")
  valid_579608 = validateParameter(valid_579608, JString, required = false,
                                 default = nil)
  if valid_579608 != nil:
    section.add "userIp", valid_579608
  var valid_579609 = query.getOrDefault("quotaUser")
  valid_579609 = validateParameter(valid_579609, JString, required = false,
                                 default = nil)
  if valid_579609 != nil:
    section.add "quotaUser", valid_579609
  var valid_579610 = query.getOrDefault("maxAllowedMaturityRating")
  valid_579610 = validateParameter(valid_579610, JString, required = false,
                                 default = newJString("mature"))
  if valid_579610 != nil:
    section.add "maxAllowedMaturityRating", valid_579610
  var valid_579611 = query.getOrDefault("fields")
  valid_579611 = validateParameter(valid_579611, JString, required = false,
                                 default = nil)
  if valid_579611 != nil:
    section.add "fields", valid_579611
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579612: Call_BooksVolumesRecommendedList_579599; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return a list of recommended books for the current user.
  ## 
  let valid = call_579612.validator(path, query, header, formData, body)
  let scheme = call_579612.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579612.url(scheme.get, call_579612.host, call_579612.base,
                         call_579612.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579612, url, valid)

proc call*(call_579613: Call_BooksVolumesRecommendedList_579599; key: string = "";
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
  var query_579614 = newJObject()
  add(query_579614, "key", newJString(key))
  add(query_579614, "prettyPrint", newJBool(prettyPrint))
  add(query_579614, "oauth_token", newJString(oauthToken))
  add(query_579614, "locale", newJString(locale))
  add(query_579614, "source", newJString(source))
  add(query_579614, "alt", newJString(alt))
  add(query_579614, "userIp", newJString(userIp))
  add(query_579614, "quotaUser", newJString(quotaUser))
  add(query_579614, "maxAllowedMaturityRating",
      newJString(maxAllowedMaturityRating))
  add(query_579614, "fields", newJString(fields))
  result = call_579613.call(nil, query_579614, nil, nil, nil)

var booksVolumesRecommendedList* = Call_BooksVolumesRecommendedList_579599(
    name: "booksVolumesRecommendedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/volumes/recommended",
    validator: validate_BooksVolumesRecommendedList_579600, base: "/books/v1",
    url: url_BooksVolumesRecommendedList_579601, schemes: {Scheme.Https})
type
  Call_BooksVolumesRecommendedRate_579615 = ref object of OpenApiRestCall_578364
proc url_BooksVolumesRecommendedRate_579617(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksVolumesRecommendedRate_579616(path: JsonNode; query: JsonNode;
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
  var valid_579618 = query.getOrDefault("key")
  valid_579618 = validateParameter(valid_579618, JString, required = false,
                                 default = nil)
  if valid_579618 != nil:
    section.add "key", valid_579618
  var valid_579619 = query.getOrDefault("prettyPrint")
  valid_579619 = validateParameter(valid_579619, JBool, required = false,
                                 default = newJBool(true))
  if valid_579619 != nil:
    section.add "prettyPrint", valid_579619
  var valid_579620 = query.getOrDefault("oauth_token")
  valid_579620 = validateParameter(valid_579620, JString, required = false,
                                 default = nil)
  if valid_579620 != nil:
    section.add "oauth_token", valid_579620
  var valid_579621 = query.getOrDefault("locale")
  valid_579621 = validateParameter(valid_579621, JString, required = false,
                                 default = nil)
  if valid_579621 != nil:
    section.add "locale", valid_579621
  assert query != nil, "query argument is necessary due to required `rating` field"
  var valid_579622 = query.getOrDefault("rating")
  valid_579622 = validateParameter(valid_579622, JString, required = true,
                                 default = newJString("HAVE_IT"))
  if valid_579622 != nil:
    section.add "rating", valid_579622
  var valid_579623 = query.getOrDefault("volumeId")
  valid_579623 = validateParameter(valid_579623, JString, required = true,
                                 default = nil)
  if valid_579623 != nil:
    section.add "volumeId", valid_579623
  var valid_579624 = query.getOrDefault("source")
  valid_579624 = validateParameter(valid_579624, JString, required = false,
                                 default = nil)
  if valid_579624 != nil:
    section.add "source", valid_579624
  var valid_579625 = query.getOrDefault("alt")
  valid_579625 = validateParameter(valid_579625, JString, required = false,
                                 default = newJString("json"))
  if valid_579625 != nil:
    section.add "alt", valid_579625
  var valid_579626 = query.getOrDefault("userIp")
  valid_579626 = validateParameter(valid_579626, JString, required = false,
                                 default = nil)
  if valid_579626 != nil:
    section.add "userIp", valid_579626
  var valid_579627 = query.getOrDefault("quotaUser")
  valid_579627 = validateParameter(valid_579627, JString, required = false,
                                 default = nil)
  if valid_579627 != nil:
    section.add "quotaUser", valid_579627
  var valid_579628 = query.getOrDefault("fields")
  valid_579628 = validateParameter(valid_579628, JString, required = false,
                                 default = nil)
  if valid_579628 != nil:
    section.add "fields", valid_579628
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579629: Call_BooksVolumesRecommendedRate_579615; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rate a recommended book for the current user.
  ## 
  let valid = call_579629.validator(path, query, header, formData, body)
  let scheme = call_579629.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579629.url(scheme.get, call_579629.host, call_579629.base,
                         call_579629.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579629, url, valid)

proc call*(call_579630: Call_BooksVolumesRecommendedRate_579615; volumeId: string;
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
  var query_579631 = newJObject()
  add(query_579631, "key", newJString(key))
  add(query_579631, "prettyPrint", newJBool(prettyPrint))
  add(query_579631, "oauth_token", newJString(oauthToken))
  add(query_579631, "locale", newJString(locale))
  add(query_579631, "rating", newJString(rating))
  add(query_579631, "volumeId", newJString(volumeId))
  add(query_579631, "source", newJString(source))
  add(query_579631, "alt", newJString(alt))
  add(query_579631, "userIp", newJString(userIp))
  add(query_579631, "quotaUser", newJString(quotaUser))
  add(query_579631, "fields", newJString(fields))
  result = call_579630.call(nil, query_579631, nil, nil, nil)

var booksVolumesRecommendedRate* = Call_BooksVolumesRecommendedRate_579615(
    name: "booksVolumesRecommendedRate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/volumes/recommended/rate",
    validator: validate_BooksVolumesRecommendedRate_579616, base: "/books/v1",
    url: url_BooksVolumesRecommendedRate_579617, schemes: {Scheme.Https})
type
  Call_BooksVolumesUseruploadedList_579632 = ref object of OpenApiRestCall_578364
proc url_BooksVolumesUseruploadedList_579634(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BooksVolumesUseruploadedList_579633(path: JsonNode; query: JsonNode;
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
  var valid_579635 = query.getOrDefault("key")
  valid_579635 = validateParameter(valid_579635, JString, required = false,
                                 default = nil)
  if valid_579635 != nil:
    section.add "key", valid_579635
  var valid_579636 = query.getOrDefault("prettyPrint")
  valid_579636 = validateParameter(valid_579636, JBool, required = false,
                                 default = newJBool(true))
  if valid_579636 != nil:
    section.add "prettyPrint", valid_579636
  var valid_579637 = query.getOrDefault("oauth_token")
  valid_579637 = validateParameter(valid_579637, JString, required = false,
                                 default = nil)
  if valid_579637 != nil:
    section.add "oauth_token", valid_579637
  var valid_579638 = query.getOrDefault("locale")
  valid_579638 = validateParameter(valid_579638, JString, required = false,
                                 default = nil)
  if valid_579638 != nil:
    section.add "locale", valid_579638
  var valid_579639 = query.getOrDefault("volumeId")
  valid_579639 = validateParameter(valid_579639, JArray, required = false,
                                 default = nil)
  if valid_579639 != nil:
    section.add "volumeId", valid_579639
  var valid_579640 = query.getOrDefault("source")
  valid_579640 = validateParameter(valid_579640, JString, required = false,
                                 default = nil)
  if valid_579640 != nil:
    section.add "source", valid_579640
  var valid_579641 = query.getOrDefault("alt")
  valid_579641 = validateParameter(valid_579641, JString, required = false,
                                 default = newJString("json"))
  if valid_579641 != nil:
    section.add "alt", valid_579641
  var valid_579642 = query.getOrDefault("userIp")
  valid_579642 = validateParameter(valid_579642, JString, required = false,
                                 default = nil)
  if valid_579642 != nil:
    section.add "userIp", valid_579642
  var valid_579643 = query.getOrDefault("quotaUser")
  valid_579643 = validateParameter(valid_579643, JString, required = false,
                                 default = nil)
  if valid_579643 != nil:
    section.add "quotaUser", valid_579643
  var valid_579644 = query.getOrDefault("startIndex")
  valid_579644 = validateParameter(valid_579644, JInt, required = false, default = nil)
  if valid_579644 != nil:
    section.add "startIndex", valid_579644
  var valid_579645 = query.getOrDefault("processingState")
  valid_579645 = validateParameter(valid_579645, JArray, required = false,
                                 default = nil)
  if valid_579645 != nil:
    section.add "processingState", valid_579645
  var valid_579646 = query.getOrDefault("fields")
  valid_579646 = validateParameter(valid_579646, JString, required = false,
                                 default = nil)
  if valid_579646 != nil:
    section.add "fields", valid_579646
  var valid_579647 = query.getOrDefault("maxResults")
  valid_579647 = validateParameter(valid_579647, JInt, required = false, default = nil)
  if valid_579647 != nil:
    section.add "maxResults", valid_579647
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579648: Call_BooksVolumesUseruploadedList_579632; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return a list of books uploaded by the current user.
  ## 
  let valid = call_579648.validator(path, query, header, formData, body)
  let scheme = call_579648.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579648.url(scheme.get, call_579648.host, call_579648.base,
                         call_579648.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579648, url, valid)

proc call*(call_579649: Call_BooksVolumesUseruploadedList_579632; key: string = "";
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
  var query_579650 = newJObject()
  add(query_579650, "key", newJString(key))
  add(query_579650, "prettyPrint", newJBool(prettyPrint))
  add(query_579650, "oauth_token", newJString(oauthToken))
  add(query_579650, "locale", newJString(locale))
  if volumeId != nil:
    query_579650.add "volumeId", volumeId
  add(query_579650, "source", newJString(source))
  add(query_579650, "alt", newJString(alt))
  add(query_579650, "userIp", newJString(userIp))
  add(query_579650, "quotaUser", newJString(quotaUser))
  add(query_579650, "startIndex", newJInt(startIndex))
  if processingState != nil:
    query_579650.add "processingState", processingState
  add(query_579650, "fields", newJString(fields))
  add(query_579650, "maxResults", newJInt(maxResults))
  result = call_579649.call(nil, query_579650, nil, nil, nil)

var booksVolumesUseruploadedList* = Call_BooksVolumesUseruploadedList_579632(
    name: "booksVolumesUseruploadedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/volumes/useruploaded",
    validator: validate_BooksVolumesUseruploadedList_579633, base: "/books/v1",
    url: url_BooksVolumesUseruploadedList_579634, schemes: {Scheme.Https})
type
  Call_BooksVolumesGet_579651 = ref object of OpenApiRestCall_578364
proc url_BooksVolumesGet_579653(protocol: Scheme; host: string; base: string;
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

proc validate_BooksVolumesGet_579652(path: JsonNode; query: JsonNode;
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
  var valid_579654 = path.getOrDefault("volumeId")
  valid_579654 = validateParameter(valid_579654, JString, required = true,
                                 default = nil)
  if valid_579654 != nil:
    section.add "volumeId", valid_579654
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
  var valid_579655 = query.getOrDefault("key")
  valid_579655 = validateParameter(valid_579655, JString, required = false,
                                 default = nil)
  if valid_579655 != nil:
    section.add "key", valid_579655
  var valid_579656 = query.getOrDefault("prettyPrint")
  valid_579656 = validateParameter(valid_579656, JBool, required = false,
                                 default = newJBool(true))
  if valid_579656 != nil:
    section.add "prettyPrint", valid_579656
  var valid_579657 = query.getOrDefault("oauth_token")
  valid_579657 = validateParameter(valid_579657, JString, required = false,
                                 default = nil)
  if valid_579657 != nil:
    section.add "oauth_token", valid_579657
  var valid_579658 = query.getOrDefault("includeNonComicsSeries")
  valid_579658 = validateParameter(valid_579658, JBool, required = false, default = nil)
  if valid_579658 != nil:
    section.add "includeNonComicsSeries", valid_579658
  var valid_579659 = query.getOrDefault("source")
  valid_579659 = validateParameter(valid_579659, JString, required = false,
                                 default = nil)
  if valid_579659 != nil:
    section.add "source", valid_579659
  var valid_579660 = query.getOrDefault("alt")
  valid_579660 = validateParameter(valid_579660, JString, required = false,
                                 default = newJString("json"))
  if valid_579660 != nil:
    section.add "alt", valid_579660
  var valid_579661 = query.getOrDefault("userIp")
  valid_579661 = validateParameter(valid_579661, JString, required = false,
                                 default = nil)
  if valid_579661 != nil:
    section.add "userIp", valid_579661
  var valid_579662 = query.getOrDefault("quotaUser")
  valid_579662 = validateParameter(valid_579662, JString, required = false,
                                 default = nil)
  if valid_579662 != nil:
    section.add "quotaUser", valid_579662
  var valid_579663 = query.getOrDefault("partner")
  valid_579663 = validateParameter(valid_579663, JString, required = false,
                                 default = nil)
  if valid_579663 != nil:
    section.add "partner", valid_579663
  var valid_579664 = query.getOrDefault("user_library_consistent_read")
  valid_579664 = validateParameter(valid_579664, JBool, required = false, default = nil)
  if valid_579664 != nil:
    section.add "user_library_consistent_read", valid_579664
  var valid_579665 = query.getOrDefault("country")
  valid_579665 = validateParameter(valid_579665, JString, required = false,
                                 default = nil)
  if valid_579665 != nil:
    section.add "country", valid_579665
  var valid_579666 = query.getOrDefault("projection")
  valid_579666 = validateParameter(valid_579666, JString, required = false,
                                 default = newJString("full"))
  if valid_579666 != nil:
    section.add "projection", valid_579666
  var valid_579667 = query.getOrDefault("fields")
  valid_579667 = validateParameter(valid_579667, JString, required = false,
                                 default = nil)
  if valid_579667 != nil:
    section.add "fields", valid_579667
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579668: Call_BooksVolumesGet_579651; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets volume information for a single volume.
  ## 
  let valid = call_579668.validator(path, query, header, formData, body)
  let scheme = call_579668.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579668.url(scheme.get, call_579668.host, call_579668.base,
                         call_579668.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579668, url, valid)

proc call*(call_579669: Call_BooksVolumesGet_579651; volumeId: string;
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
  var path_579670 = newJObject()
  var query_579671 = newJObject()
  add(query_579671, "key", newJString(key))
  add(query_579671, "prettyPrint", newJBool(prettyPrint))
  add(query_579671, "oauth_token", newJString(oauthToken))
  add(query_579671, "includeNonComicsSeries", newJBool(includeNonComicsSeries))
  add(query_579671, "source", newJString(source))
  add(query_579671, "alt", newJString(alt))
  add(query_579671, "userIp", newJString(userIp))
  add(query_579671, "quotaUser", newJString(quotaUser))
  add(query_579671, "partner", newJString(partner))
  add(path_579670, "volumeId", newJString(volumeId))
  add(query_579671, "user_library_consistent_read",
      newJBool(userLibraryConsistentRead))
  add(query_579671, "country", newJString(country))
  add(query_579671, "projection", newJString(projection))
  add(query_579671, "fields", newJString(fields))
  result = call_579669.call(path_579670, query_579671, nil, nil, nil)

var booksVolumesGet* = Call_BooksVolumesGet_579651(name: "booksVolumesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/volumes/{volumeId}", validator: validate_BooksVolumesGet_579652,
    base: "/books/v1", url: url_BooksVolumesGet_579653, schemes: {Scheme.Https})
type
  Call_BooksVolumesAssociatedList_579672 = ref object of OpenApiRestCall_578364
proc url_BooksVolumesAssociatedList_579674(protocol: Scheme; host: string;
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

proc validate_BooksVolumesAssociatedList_579673(path: JsonNode; query: JsonNode;
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
  var valid_579675 = path.getOrDefault("volumeId")
  valid_579675 = validateParameter(valid_579675, JString, required = true,
                                 default = nil)
  if valid_579675 != nil:
    section.add "volumeId", valid_579675
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
  var valid_579676 = query.getOrDefault("key")
  valid_579676 = validateParameter(valid_579676, JString, required = false,
                                 default = nil)
  if valid_579676 != nil:
    section.add "key", valid_579676
  var valid_579677 = query.getOrDefault("association")
  valid_579677 = validateParameter(valid_579677, JString, required = false,
                                 default = newJString("end-of-sample"))
  if valid_579677 != nil:
    section.add "association", valid_579677
  var valid_579678 = query.getOrDefault("prettyPrint")
  valid_579678 = validateParameter(valid_579678, JBool, required = false,
                                 default = newJBool(true))
  if valid_579678 != nil:
    section.add "prettyPrint", valid_579678
  var valid_579679 = query.getOrDefault("oauth_token")
  valid_579679 = validateParameter(valid_579679, JString, required = false,
                                 default = nil)
  if valid_579679 != nil:
    section.add "oauth_token", valid_579679
  var valid_579680 = query.getOrDefault("locale")
  valid_579680 = validateParameter(valid_579680, JString, required = false,
                                 default = nil)
  if valid_579680 != nil:
    section.add "locale", valid_579680
  var valid_579681 = query.getOrDefault("source")
  valid_579681 = validateParameter(valid_579681, JString, required = false,
                                 default = nil)
  if valid_579681 != nil:
    section.add "source", valid_579681
  var valid_579682 = query.getOrDefault("alt")
  valid_579682 = validateParameter(valid_579682, JString, required = false,
                                 default = newJString("json"))
  if valid_579682 != nil:
    section.add "alt", valid_579682
  var valid_579683 = query.getOrDefault("userIp")
  valid_579683 = validateParameter(valid_579683, JString, required = false,
                                 default = nil)
  if valid_579683 != nil:
    section.add "userIp", valid_579683
  var valid_579684 = query.getOrDefault("quotaUser")
  valid_579684 = validateParameter(valid_579684, JString, required = false,
                                 default = nil)
  if valid_579684 != nil:
    section.add "quotaUser", valid_579684
  var valid_579685 = query.getOrDefault("maxAllowedMaturityRating")
  valid_579685 = validateParameter(valid_579685, JString, required = false,
                                 default = newJString("mature"))
  if valid_579685 != nil:
    section.add "maxAllowedMaturityRating", valid_579685
  var valid_579686 = query.getOrDefault("fields")
  valid_579686 = validateParameter(valid_579686, JString, required = false,
                                 default = nil)
  if valid_579686 != nil:
    section.add "fields", valid_579686
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579687: Call_BooksVolumesAssociatedList_579672; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return a list of associated books.
  ## 
  let valid = call_579687.validator(path, query, header, formData, body)
  let scheme = call_579687.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579687.url(scheme.get, call_579687.host, call_579687.base,
                         call_579687.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579687, url, valid)

proc call*(call_579688: Call_BooksVolumesAssociatedList_579672; volumeId: string;
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
  var path_579689 = newJObject()
  var query_579690 = newJObject()
  add(query_579690, "key", newJString(key))
  add(query_579690, "association", newJString(association))
  add(query_579690, "prettyPrint", newJBool(prettyPrint))
  add(query_579690, "oauth_token", newJString(oauthToken))
  add(query_579690, "locale", newJString(locale))
  add(query_579690, "source", newJString(source))
  add(query_579690, "alt", newJString(alt))
  add(query_579690, "userIp", newJString(userIp))
  add(query_579690, "quotaUser", newJString(quotaUser))
  add(query_579690, "maxAllowedMaturityRating",
      newJString(maxAllowedMaturityRating))
  add(path_579689, "volumeId", newJString(volumeId))
  add(query_579690, "fields", newJString(fields))
  result = call_579688.call(path_579689, query_579690, nil, nil, nil)

var booksVolumesAssociatedList* = Call_BooksVolumesAssociatedList_579672(
    name: "booksVolumesAssociatedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/volumes/{volumeId}/associated",
    validator: validate_BooksVolumesAssociatedList_579673, base: "/books/v1",
    url: url_BooksVolumesAssociatedList_579674, schemes: {Scheme.Https})
type
  Call_BooksLayersVolumeAnnotationsList_579691 = ref object of OpenApiRestCall_578364
proc url_BooksLayersVolumeAnnotationsList_579693(protocol: Scheme; host: string;
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

proc validate_BooksLayersVolumeAnnotationsList_579692(path: JsonNode;
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
  var valid_579694 = path.getOrDefault("volumeId")
  valid_579694 = validateParameter(valid_579694, JString, required = true,
                                 default = nil)
  if valid_579694 != nil:
    section.add "volumeId", valid_579694
  var valid_579695 = path.getOrDefault("layerId")
  valid_579695 = validateParameter(valid_579695, JString, required = true,
                                 default = nil)
  if valid_579695 != nil:
    section.add "layerId", valid_579695
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
  var valid_579696 = query.getOrDefault("key")
  valid_579696 = validateParameter(valid_579696, JString, required = false,
                                 default = nil)
  if valid_579696 != nil:
    section.add "key", valid_579696
  var valid_579697 = query.getOrDefault("endOffset")
  valid_579697 = validateParameter(valid_579697, JString, required = false,
                                 default = nil)
  if valid_579697 != nil:
    section.add "endOffset", valid_579697
  var valid_579698 = query.getOrDefault("prettyPrint")
  valid_579698 = validateParameter(valid_579698, JBool, required = false,
                                 default = newJBool(true))
  if valid_579698 != nil:
    section.add "prettyPrint", valid_579698
  var valid_579699 = query.getOrDefault("oauth_token")
  valid_579699 = validateParameter(valid_579699, JString, required = false,
                                 default = nil)
  if valid_579699 != nil:
    section.add "oauth_token", valid_579699
  var valid_579700 = query.getOrDefault("locale")
  valid_579700 = validateParameter(valid_579700, JString, required = false,
                                 default = nil)
  if valid_579700 != nil:
    section.add "locale", valid_579700
  var valid_579701 = query.getOrDefault("startPosition")
  valid_579701 = validateParameter(valid_579701, JString, required = false,
                                 default = nil)
  if valid_579701 != nil:
    section.add "startPosition", valid_579701
  var valid_579702 = query.getOrDefault("source")
  valid_579702 = validateParameter(valid_579702, JString, required = false,
                                 default = nil)
  if valid_579702 != nil:
    section.add "source", valid_579702
  var valid_579703 = query.getOrDefault("volumeAnnotationsVersion")
  valid_579703 = validateParameter(valid_579703, JString, required = false,
                                 default = nil)
  if valid_579703 != nil:
    section.add "volumeAnnotationsVersion", valid_579703
  var valid_579704 = query.getOrDefault("alt")
  valid_579704 = validateParameter(valid_579704, JString, required = false,
                                 default = newJString("json"))
  if valid_579704 != nil:
    section.add "alt", valid_579704
  var valid_579705 = query.getOrDefault("userIp")
  valid_579705 = validateParameter(valid_579705, JString, required = false,
                                 default = nil)
  if valid_579705 != nil:
    section.add "userIp", valid_579705
  assert query != nil,
        "query argument is necessary due to required `contentVersion` field"
  var valid_579706 = query.getOrDefault("contentVersion")
  valid_579706 = validateParameter(valid_579706, JString, required = true,
                                 default = nil)
  if valid_579706 != nil:
    section.add "contentVersion", valid_579706
  var valid_579707 = query.getOrDefault("quotaUser")
  valid_579707 = validateParameter(valid_579707, JString, required = false,
                                 default = nil)
  if valid_579707 != nil:
    section.add "quotaUser", valid_579707
  var valid_579708 = query.getOrDefault("pageToken")
  valid_579708 = validateParameter(valid_579708, JString, required = false,
                                 default = nil)
  if valid_579708 != nil:
    section.add "pageToken", valid_579708
  var valid_579709 = query.getOrDefault("updatedMax")
  valid_579709 = validateParameter(valid_579709, JString, required = false,
                                 default = nil)
  if valid_579709 != nil:
    section.add "updatedMax", valid_579709
  var valid_579710 = query.getOrDefault("endPosition")
  valid_579710 = validateParameter(valid_579710, JString, required = false,
                                 default = nil)
  if valid_579710 != nil:
    section.add "endPosition", valid_579710
  var valid_579711 = query.getOrDefault("startOffset")
  valid_579711 = validateParameter(valid_579711, JString, required = false,
                                 default = nil)
  if valid_579711 != nil:
    section.add "startOffset", valid_579711
  var valid_579712 = query.getOrDefault("updatedMin")
  valid_579712 = validateParameter(valid_579712, JString, required = false,
                                 default = nil)
  if valid_579712 != nil:
    section.add "updatedMin", valid_579712
  var valid_579713 = query.getOrDefault("fields")
  valid_579713 = validateParameter(valid_579713, JString, required = false,
                                 default = nil)
  if valid_579713 != nil:
    section.add "fields", valid_579713
  var valid_579714 = query.getOrDefault("showDeleted")
  valid_579714 = validateParameter(valid_579714, JBool, required = false, default = nil)
  if valid_579714 != nil:
    section.add "showDeleted", valid_579714
  var valid_579715 = query.getOrDefault("maxResults")
  valid_579715 = validateParameter(valid_579715, JInt, required = false, default = nil)
  if valid_579715 != nil:
    section.add "maxResults", valid_579715
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579716: Call_BooksLayersVolumeAnnotationsList_579691;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the volume annotations for a volume and layer.
  ## 
  let valid = call_579716.validator(path, query, header, formData, body)
  let scheme = call_579716.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579716.url(scheme.get, call_579716.host, call_579716.base,
                         call_579716.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579716, url, valid)

proc call*(call_579717: Call_BooksLayersVolumeAnnotationsList_579691;
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
  var path_579718 = newJObject()
  var query_579719 = newJObject()
  add(query_579719, "key", newJString(key))
  add(query_579719, "endOffset", newJString(endOffset))
  add(query_579719, "prettyPrint", newJBool(prettyPrint))
  add(query_579719, "oauth_token", newJString(oauthToken))
  add(query_579719, "locale", newJString(locale))
  add(query_579719, "startPosition", newJString(startPosition))
  add(query_579719, "source", newJString(source))
  add(query_579719, "volumeAnnotationsVersion",
      newJString(volumeAnnotationsVersion))
  add(query_579719, "alt", newJString(alt))
  add(query_579719, "userIp", newJString(userIp))
  add(query_579719, "contentVersion", newJString(contentVersion))
  add(query_579719, "quotaUser", newJString(quotaUser))
  add(query_579719, "pageToken", newJString(pageToken))
  add(path_579718, "volumeId", newJString(volumeId))
  add(path_579718, "layerId", newJString(layerId))
  add(query_579719, "updatedMax", newJString(updatedMax))
  add(query_579719, "endPosition", newJString(endPosition))
  add(query_579719, "startOffset", newJString(startOffset))
  add(query_579719, "updatedMin", newJString(updatedMin))
  add(query_579719, "fields", newJString(fields))
  add(query_579719, "showDeleted", newJBool(showDeleted))
  add(query_579719, "maxResults", newJInt(maxResults))
  result = call_579717.call(path_579718, query_579719, nil, nil, nil)

var booksLayersVolumeAnnotationsList* = Call_BooksLayersVolumeAnnotationsList_579691(
    name: "booksLayersVolumeAnnotationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/volumes/{volumeId}/layers/{layerId}",
    validator: validate_BooksLayersVolumeAnnotationsList_579692,
    base: "/books/v1", url: url_BooksLayersVolumeAnnotationsList_579693,
    schemes: {Scheme.Https})
type
  Call_BooksLayersVolumeAnnotationsGet_579720 = ref object of OpenApiRestCall_578364
proc url_BooksLayersVolumeAnnotationsGet_579722(protocol: Scheme; host: string;
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

proc validate_BooksLayersVolumeAnnotationsGet_579721(path: JsonNode;
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
  var valid_579723 = path.getOrDefault("annotationId")
  valid_579723 = validateParameter(valid_579723, JString, required = true,
                                 default = nil)
  if valid_579723 != nil:
    section.add "annotationId", valid_579723
  var valid_579724 = path.getOrDefault("volumeId")
  valid_579724 = validateParameter(valid_579724, JString, required = true,
                                 default = nil)
  if valid_579724 != nil:
    section.add "volumeId", valid_579724
  var valid_579725 = path.getOrDefault("layerId")
  valid_579725 = validateParameter(valid_579725, JString, required = true,
                                 default = nil)
  if valid_579725 != nil:
    section.add "layerId", valid_579725
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
  var valid_579726 = query.getOrDefault("key")
  valid_579726 = validateParameter(valid_579726, JString, required = false,
                                 default = nil)
  if valid_579726 != nil:
    section.add "key", valid_579726
  var valid_579727 = query.getOrDefault("prettyPrint")
  valid_579727 = validateParameter(valid_579727, JBool, required = false,
                                 default = newJBool(true))
  if valid_579727 != nil:
    section.add "prettyPrint", valid_579727
  var valid_579728 = query.getOrDefault("oauth_token")
  valid_579728 = validateParameter(valid_579728, JString, required = false,
                                 default = nil)
  if valid_579728 != nil:
    section.add "oauth_token", valid_579728
  var valid_579729 = query.getOrDefault("locale")
  valid_579729 = validateParameter(valid_579729, JString, required = false,
                                 default = nil)
  if valid_579729 != nil:
    section.add "locale", valid_579729
  var valid_579730 = query.getOrDefault("source")
  valid_579730 = validateParameter(valid_579730, JString, required = false,
                                 default = nil)
  if valid_579730 != nil:
    section.add "source", valid_579730
  var valid_579731 = query.getOrDefault("alt")
  valid_579731 = validateParameter(valid_579731, JString, required = false,
                                 default = newJString("json"))
  if valid_579731 != nil:
    section.add "alt", valid_579731
  var valid_579732 = query.getOrDefault("userIp")
  valid_579732 = validateParameter(valid_579732, JString, required = false,
                                 default = nil)
  if valid_579732 != nil:
    section.add "userIp", valid_579732
  var valid_579733 = query.getOrDefault("quotaUser")
  valid_579733 = validateParameter(valid_579733, JString, required = false,
                                 default = nil)
  if valid_579733 != nil:
    section.add "quotaUser", valid_579733
  var valid_579734 = query.getOrDefault("fields")
  valid_579734 = validateParameter(valid_579734, JString, required = false,
                                 default = nil)
  if valid_579734 != nil:
    section.add "fields", valid_579734
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579735: Call_BooksLayersVolumeAnnotationsGet_579720;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the volume annotation.
  ## 
  let valid = call_579735.validator(path, query, header, formData, body)
  let scheme = call_579735.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579735.url(scheme.get, call_579735.host, call_579735.base,
                         call_579735.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579735, url, valid)

proc call*(call_579736: Call_BooksLayersVolumeAnnotationsGet_579720;
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
  var path_579737 = newJObject()
  var query_579738 = newJObject()
  add(query_579738, "key", newJString(key))
  add(query_579738, "prettyPrint", newJBool(prettyPrint))
  add(query_579738, "oauth_token", newJString(oauthToken))
  add(query_579738, "locale", newJString(locale))
  add(query_579738, "source", newJString(source))
  add(path_579737, "annotationId", newJString(annotationId))
  add(query_579738, "alt", newJString(alt))
  add(query_579738, "userIp", newJString(userIp))
  add(query_579738, "quotaUser", newJString(quotaUser))
  add(path_579737, "volumeId", newJString(volumeId))
  add(path_579737, "layerId", newJString(layerId))
  add(query_579738, "fields", newJString(fields))
  result = call_579736.call(path_579737, query_579738, nil, nil, nil)

var booksLayersVolumeAnnotationsGet* = Call_BooksLayersVolumeAnnotationsGet_579720(
    name: "booksLayersVolumeAnnotationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/volumes/{volumeId}/layers/{layerId}/annotations/{annotationId}",
    validator: validate_BooksLayersVolumeAnnotationsGet_579721, base: "/books/v1",
    url: url_BooksLayersVolumeAnnotationsGet_579722, schemes: {Scheme.Https})
type
  Call_BooksLayersAnnotationDataList_579739 = ref object of OpenApiRestCall_578364
proc url_BooksLayersAnnotationDataList_579741(protocol: Scheme; host: string;
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

proc validate_BooksLayersAnnotationDataList_579740(path: JsonNode; query: JsonNode;
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
  var valid_579742 = path.getOrDefault("volumeId")
  valid_579742 = validateParameter(valid_579742, JString, required = true,
                                 default = nil)
  if valid_579742 != nil:
    section.add "volumeId", valid_579742
  var valid_579743 = path.getOrDefault("layerId")
  valid_579743 = validateParameter(valid_579743, JString, required = true,
                                 default = nil)
  if valid_579743 != nil:
    section.add "layerId", valid_579743
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
  var valid_579744 = query.getOrDefault("key")
  valid_579744 = validateParameter(valid_579744, JString, required = false,
                                 default = nil)
  if valid_579744 != nil:
    section.add "key", valid_579744
  var valid_579745 = query.getOrDefault("prettyPrint")
  valid_579745 = validateParameter(valid_579745, JBool, required = false,
                                 default = newJBool(true))
  if valid_579745 != nil:
    section.add "prettyPrint", valid_579745
  var valid_579746 = query.getOrDefault("oauth_token")
  valid_579746 = validateParameter(valid_579746, JString, required = false,
                                 default = nil)
  if valid_579746 != nil:
    section.add "oauth_token", valid_579746
  var valid_579747 = query.getOrDefault("h")
  valid_579747 = validateParameter(valid_579747, JInt, required = false, default = nil)
  if valid_579747 != nil:
    section.add "h", valid_579747
  var valid_579748 = query.getOrDefault("locale")
  valid_579748 = validateParameter(valid_579748, JString, required = false,
                                 default = nil)
  if valid_579748 != nil:
    section.add "locale", valid_579748
  var valid_579749 = query.getOrDefault("source")
  valid_579749 = validateParameter(valid_579749, JString, required = false,
                                 default = nil)
  if valid_579749 != nil:
    section.add "source", valid_579749
  var valid_579750 = query.getOrDefault("alt")
  valid_579750 = validateParameter(valid_579750, JString, required = false,
                                 default = newJString("json"))
  if valid_579750 != nil:
    section.add "alt", valid_579750
  var valid_579751 = query.getOrDefault("userIp")
  valid_579751 = validateParameter(valid_579751, JString, required = false,
                                 default = nil)
  if valid_579751 != nil:
    section.add "userIp", valid_579751
  assert query != nil,
        "query argument is necessary due to required `contentVersion` field"
  var valid_579752 = query.getOrDefault("contentVersion")
  valid_579752 = validateParameter(valid_579752, JString, required = true,
                                 default = nil)
  if valid_579752 != nil:
    section.add "contentVersion", valid_579752
  var valid_579753 = query.getOrDefault("quotaUser")
  valid_579753 = validateParameter(valid_579753, JString, required = false,
                                 default = nil)
  if valid_579753 != nil:
    section.add "quotaUser", valid_579753
  var valid_579754 = query.getOrDefault("pageToken")
  valid_579754 = validateParameter(valid_579754, JString, required = false,
                                 default = nil)
  if valid_579754 != nil:
    section.add "pageToken", valid_579754
  var valid_579755 = query.getOrDefault("scale")
  valid_579755 = validateParameter(valid_579755, JInt, required = false, default = nil)
  if valid_579755 != nil:
    section.add "scale", valid_579755
  var valid_579756 = query.getOrDefault("updatedMax")
  valid_579756 = validateParameter(valid_579756, JString, required = false,
                                 default = nil)
  if valid_579756 != nil:
    section.add "updatedMax", valid_579756
  var valid_579757 = query.getOrDefault("annotationDataId")
  valid_579757 = validateParameter(valid_579757, JArray, required = false,
                                 default = nil)
  if valid_579757 != nil:
    section.add "annotationDataId", valid_579757
  var valid_579758 = query.getOrDefault("w")
  valid_579758 = validateParameter(valid_579758, JInt, required = false, default = nil)
  if valid_579758 != nil:
    section.add "w", valid_579758
  var valid_579759 = query.getOrDefault("updatedMin")
  valid_579759 = validateParameter(valid_579759, JString, required = false,
                                 default = nil)
  if valid_579759 != nil:
    section.add "updatedMin", valid_579759
  var valid_579760 = query.getOrDefault("fields")
  valid_579760 = validateParameter(valid_579760, JString, required = false,
                                 default = nil)
  if valid_579760 != nil:
    section.add "fields", valid_579760
  var valid_579761 = query.getOrDefault("maxResults")
  valid_579761 = validateParameter(valid_579761, JInt, required = false, default = nil)
  if valid_579761 != nil:
    section.add "maxResults", valid_579761
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579762: Call_BooksLayersAnnotationDataList_579739; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the annotation data for a volume and layer.
  ## 
  let valid = call_579762.validator(path, query, header, formData, body)
  let scheme = call_579762.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579762.url(scheme.get, call_579762.host, call_579762.base,
                         call_579762.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579762, url, valid)

proc call*(call_579763: Call_BooksLayersAnnotationDataList_579739;
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
  var path_579764 = newJObject()
  var query_579765 = newJObject()
  add(query_579765, "key", newJString(key))
  add(query_579765, "prettyPrint", newJBool(prettyPrint))
  add(query_579765, "oauth_token", newJString(oauthToken))
  add(query_579765, "h", newJInt(h))
  add(query_579765, "locale", newJString(locale))
  add(query_579765, "source", newJString(source))
  add(query_579765, "alt", newJString(alt))
  add(query_579765, "userIp", newJString(userIp))
  add(query_579765, "contentVersion", newJString(contentVersion))
  add(query_579765, "quotaUser", newJString(quotaUser))
  add(query_579765, "pageToken", newJString(pageToken))
  add(query_579765, "scale", newJInt(scale))
  add(path_579764, "volumeId", newJString(volumeId))
  add(path_579764, "layerId", newJString(layerId))
  add(query_579765, "updatedMax", newJString(updatedMax))
  if annotationDataId != nil:
    query_579765.add "annotationDataId", annotationDataId
  add(query_579765, "w", newJInt(w))
  add(query_579765, "updatedMin", newJString(updatedMin))
  add(query_579765, "fields", newJString(fields))
  add(query_579765, "maxResults", newJInt(maxResults))
  result = call_579763.call(path_579764, query_579765, nil, nil, nil)

var booksLayersAnnotationDataList* = Call_BooksLayersAnnotationDataList_579739(
    name: "booksLayersAnnotationDataList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/volumes/{volumeId}/layers/{layerId}/data",
    validator: validate_BooksLayersAnnotationDataList_579740, base: "/books/v1",
    url: url_BooksLayersAnnotationDataList_579741, schemes: {Scheme.Https})
type
  Call_BooksLayersAnnotationDataGet_579766 = ref object of OpenApiRestCall_578364
proc url_BooksLayersAnnotationDataGet_579768(protocol: Scheme; host: string;
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

proc validate_BooksLayersAnnotationDataGet_579767(path: JsonNode; query: JsonNode;
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
  var valid_579769 = path.getOrDefault("volumeId")
  valid_579769 = validateParameter(valid_579769, JString, required = true,
                                 default = nil)
  if valid_579769 != nil:
    section.add "volumeId", valid_579769
  var valid_579770 = path.getOrDefault("layerId")
  valid_579770 = validateParameter(valid_579770, JString, required = true,
                                 default = nil)
  if valid_579770 != nil:
    section.add "layerId", valid_579770
  var valid_579771 = path.getOrDefault("annotationDataId")
  valid_579771 = validateParameter(valid_579771, JString, required = true,
                                 default = nil)
  if valid_579771 != nil:
    section.add "annotationDataId", valid_579771
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
  var valid_579772 = query.getOrDefault("key")
  valid_579772 = validateParameter(valid_579772, JString, required = false,
                                 default = nil)
  if valid_579772 != nil:
    section.add "key", valid_579772
  var valid_579773 = query.getOrDefault("prettyPrint")
  valid_579773 = validateParameter(valid_579773, JBool, required = false,
                                 default = newJBool(true))
  if valid_579773 != nil:
    section.add "prettyPrint", valid_579773
  var valid_579774 = query.getOrDefault("oauth_token")
  valid_579774 = validateParameter(valid_579774, JString, required = false,
                                 default = nil)
  if valid_579774 != nil:
    section.add "oauth_token", valid_579774
  var valid_579775 = query.getOrDefault("h")
  valid_579775 = validateParameter(valid_579775, JInt, required = false, default = nil)
  if valid_579775 != nil:
    section.add "h", valid_579775
  var valid_579776 = query.getOrDefault("locale")
  valid_579776 = validateParameter(valid_579776, JString, required = false,
                                 default = nil)
  if valid_579776 != nil:
    section.add "locale", valid_579776
  var valid_579777 = query.getOrDefault("source")
  valid_579777 = validateParameter(valid_579777, JString, required = false,
                                 default = nil)
  if valid_579777 != nil:
    section.add "source", valid_579777
  var valid_579778 = query.getOrDefault("alt")
  valid_579778 = validateParameter(valid_579778, JString, required = false,
                                 default = newJString("json"))
  if valid_579778 != nil:
    section.add "alt", valid_579778
  var valid_579779 = query.getOrDefault("userIp")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "userIp", valid_579779
  assert query != nil,
        "query argument is necessary due to required `contentVersion` field"
  var valid_579780 = query.getOrDefault("contentVersion")
  valid_579780 = validateParameter(valid_579780, JString, required = true,
                                 default = nil)
  if valid_579780 != nil:
    section.add "contentVersion", valid_579780
  var valid_579781 = query.getOrDefault("quotaUser")
  valid_579781 = validateParameter(valid_579781, JString, required = false,
                                 default = nil)
  if valid_579781 != nil:
    section.add "quotaUser", valid_579781
  var valid_579782 = query.getOrDefault("scale")
  valid_579782 = validateParameter(valid_579782, JInt, required = false, default = nil)
  if valid_579782 != nil:
    section.add "scale", valid_579782
  var valid_579783 = query.getOrDefault("allowWebDefinitions")
  valid_579783 = validateParameter(valid_579783, JBool, required = false, default = nil)
  if valid_579783 != nil:
    section.add "allowWebDefinitions", valid_579783
  var valid_579784 = query.getOrDefault("w")
  valid_579784 = validateParameter(valid_579784, JInt, required = false, default = nil)
  if valid_579784 != nil:
    section.add "w", valid_579784
  var valid_579785 = query.getOrDefault("fields")
  valid_579785 = validateParameter(valid_579785, JString, required = false,
                                 default = nil)
  if valid_579785 != nil:
    section.add "fields", valid_579785
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579786: Call_BooksLayersAnnotationDataGet_579766; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the annotation data.
  ## 
  let valid = call_579786.validator(path, query, header, formData, body)
  let scheme = call_579786.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579786.url(scheme.get, call_579786.host, call_579786.base,
                         call_579786.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579786, url, valid)

proc call*(call_579787: Call_BooksLayersAnnotationDataGet_579766;
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
  var path_579788 = newJObject()
  var query_579789 = newJObject()
  add(query_579789, "key", newJString(key))
  add(query_579789, "prettyPrint", newJBool(prettyPrint))
  add(query_579789, "oauth_token", newJString(oauthToken))
  add(query_579789, "h", newJInt(h))
  add(query_579789, "locale", newJString(locale))
  add(query_579789, "source", newJString(source))
  add(query_579789, "alt", newJString(alt))
  add(query_579789, "userIp", newJString(userIp))
  add(query_579789, "contentVersion", newJString(contentVersion))
  add(query_579789, "quotaUser", newJString(quotaUser))
  add(query_579789, "scale", newJInt(scale))
  add(query_579789, "allowWebDefinitions", newJBool(allowWebDefinitions))
  add(path_579788, "volumeId", newJString(volumeId))
  add(path_579788, "layerId", newJString(layerId))
  add(path_579788, "annotationDataId", newJString(annotationDataId))
  add(query_579789, "w", newJInt(w))
  add(query_579789, "fields", newJString(fields))
  result = call_579787.call(path_579788, query_579789, nil, nil, nil)

var booksLayersAnnotationDataGet* = Call_BooksLayersAnnotationDataGet_579766(
    name: "booksLayersAnnotationDataGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/volumes/{volumeId}/layers/{layerId}/data/{annotationDataId}",
    validator: validate_BooksLayersAnnotationDataGet_579767, base: "/books/v1",
    url: url_BooksLayersAnnotationDataGet_579768, schemes: {Scheme.Https})
type
  Call_BooksLayersList_579790 = ref object of OpenApiRestCall_578364
proc url_BooksLayersList_579792(protocol: Scheme; host: string; base: string;
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

proc validate_BooksLayersList_579791(path: JsonNode; query: JsonNode;
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
  var valid_579793 = path.getOrDefault("volumeId")
  valid_579793 = validateParameter(valid_579793, JString, required = true,
                                 default = nil)
  if valid_579793 != nil:
    section.add "volumeId", valid_579793
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
  var valid_579794 = query.getOrDefault("key")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = nil)
  if valid_579794 != nil:
    section.add "key", valid_579794
  var valid_579795 = query.getOrDefault("prettyPrint")
  valid_579795 = validateParameter(valid_579795, JBool, required = false,
                                 default = newJBool(true))
  if valid_579795 != nil:
    section.add "prettyPrint", valid_579795
  var valid_579796 = query.getOrDefault("oauth_token")
  valid_579796 = validateParameter(valid_579796, JString, required = false,
                                 default = nil)
  if valid_579796 != nil:
    section.add "oauth_token", valid_579796
  var valid_579797 = query.getOrDefault("source")
  valid_579797 = validateParameter(valid_579797, JString, required = false,
                                 default = nil)
  if valid_579797 != nil:
    section.add "source", valid_579797
  var valid_579798 = query.getOrDefault("alt")
  valid_579798 = validateParameter(valid_579798, JString, required = false,
                                 default = newJString("json"))
  if valid_579798 != nil:
    section.add "alt", valid_579798
  var valid_579799 = query.getOrDefault("userIp")
  valid_579799 = validateParameter(valid_579799, JString, required = false,
                                 default = nil)
  if valid_579799 != nil:
    section.add "userIp", valid_579799
  var valid_579800 = query.getOrDefault("contentVersion")
  valid_579800 = validateParameter(valid_579800, JString, required = false,
                                 default = nil)
  if valid_579800 != nil:
    section.add "contentVersion", valid_579800
  var valid_579801 = query.getOrDefault("quotaUser")
  valid_579801 = validateParameter(valid_579801, JString, required = false,
                                 default = nil)
  if valid_579801 != nil:
    section.add "quotaUser", valid_579801
  var valid_579802 = query.getOrDefault("pageToken")
  valid_579802 = validateParameter(valid_579802, JString, required = false,
                                 default = nil)
  if valid_579802 != nil:
    section.add "pageToken", valid_579802
  var valid_579803 = query.getOrDefault("fields")
  valid_579803 = validateParameter(valid_579803, JString, required = false,
                                 default = nil)
  if valid_579803 != nil:
    section.add "fields", valid_579803
  var valid_579804 = query.getOrDefault("maxResults")
  valid_579804 = validateParameter(valid_579804, JInt, required = false, default = nil)
  if valid_579804 != nil:
    section.add "maxResults", valid_579804
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579805: Call_BooksLayersList_579790; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the layer summaries for a volume.
  ## 
  let valid = call_579805.validator(path, query, header, formData, body)
  let scheme = call_579805.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579805.url(scheme.get, call_579805.host, call_579805.base,
                         call_579805.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579805, url, valid)

proc call*(call_579806: Call_BooksLayersList_579790; volumeId: string;
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
  var path_579807 = newJObject()
  var query_579808 = newJObject()
  add(query_579808, "key", newJString(key))
  add(query_579808, "prettyPrint", newJBool(prettyPrint))
  add(query_579808, "oauth_token", newJString(oauthToken))
  add(query_579808, "source", newJString(source))
  add(query_579808, "alt", newJString(alt))
  add(query_579808, "userIp", newJString(userIp))
  add(query_579808, "contentVersion", newJString(contentVersion))
  add(query_579808, "quotaUser", newJString(quotaUser))
  add(query_579808, "pageToken", newJString(pageToken))
  add(path_579807, "volumeId", newJString(volumeId))
  add(query_579808, "fields", newJString(fields))
  add(query_579808, "maxResults", newJInt(maxResults))
  result = call_579806.call(path_579807, query_579808, nil, nil, nil)

var booksLayersList* = Call_BooksLayersList_579790(name: "booksLayersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/volumes/{volumeId}/layersummary",
    validator: validate_BooksLayersList_579791, base: "/books/v1",
    url: url_BooksLayersList_579792, schemes: {Scheme.Https})
type
  Call_BooksLayersGet_579809 = ref object of OpenApiRestCall_578364
proc url_BooksLayersGet_579811(protocol: Scheme; host: string; base: string;
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

proc validate_BooksLayersGet_579810(path: JsonNode; query: JsonNode;
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
  var valid_579812 = path.getOrDefault("volumeId")
  valid_579812 = validateParameter(valid_579812, JString, required = true,
                                 default = nil)
  if valid_579812 != nil:
    section.add "volumeId", valid_579812
  var valid_579813 = path.getOrDefault("summaryId")
  valid_579813 = validateParameter(valid_579813, JString, required = true,
                                 default = nil)
  if valid_579813 != nil:
    section.add "summaryId", valid_579813
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
  var valid_579814 = query.getOrDefault("key")
  valid_579814 = validateParameter(valid_579814, JString, required = false,
                                 default = nil)
  if valid_579814 != nil:
    section.add "key", valid_579814
  var valid_579815 = query.getOrDefault("prettyPrint")
  valid_579815 = validateParameter(valid_579815, JBool, required = false,
                                 default = newJBool(true))
  if valid_579815 != nil:
    section.add "prettyPrint", valid_579815
  var valid_579816 = query.getOrDefault("oauth_token")
  valid_579816 = validateParameter(valid_579816, JString, required = false,
                                 default = nil)
  if valid_579816 != nil:
    section.add "oauth_token", valid_579816
  var valid_579817 = query.getOrDefault("source")
  valid_579817 = validateParameter(valid_579817, JString, required = false,
                                 default = nil)
  if valid_579817 != nil:
    section.add "source", valid_579817
  var valid_579818 = query.getOrDefault("alt")
  valid_579818 = validateParameter(valid_579818, JString, required = false,
                                 default = newJString("json"))
  if valid_579818 != nil:
    section.add "alt", valid_579818
  var valid_579819 = query.getOrDefault("userIp")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = nil)
  if valid_579819 != nil:
    section.add "userIp", valid_579819
  var valid_579820 = query.getOrDefault("contentVersion")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "contentVersion", valid_579820
  var valid_579821 = query.getOrDefault("quotaUser")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "quotaUser", valid_579821
  var valid_579822 = query.getOrDefault("fields")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "fields", valid_579822
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579823: Call_BooksLayersGet_579809; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the layer summary for a volume.
  ## 
  let valid = call_579823.validator(path, query, header, formData, body)
  let scheme = call_579823.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579823.url(scheme.get, call_579823.host, call_579823.base,
                         call_579823.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579823, url, valid)

proc call*(call_579824: Call_BooksLayersGet_579809; volumeId: string;
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
  var path_579825 = newJObject()
  var query_579826 = newJObject()
  add(query_579826, "key", newJString(key))
  add(query_579826, "prettyPrint", newJBool(prettyPrint))
  add(query_579826, "oauth_token", newJString(oauthToken))
  add(query_579826, "source", newJString(source))
  add(query_579826, "alt", newJString(alt))
  add(query_579826, "userIp", newJString(userIp))
  add(query_579826, "contentVersion", newJString(contentVersion))
  add(query_579826, "quotaUser", newJString(quotaUser))
  add(path_579825, "volumeId", newJString(volumeId))
  add(path_579825, "summaryId", newJString(summaryId))
  add(query_579826, "fields", newJString(fields))
  result = call_579824.call(path_579825, query_579826, nil, nil, nil)

var booksLayersGet* = Call_BooksLayersGet_579809(name: "booksLayersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/volumes/{volumeId}/layersummary/{summaryId}",
    validator: validate_BooksLayersGet_579810, base: "/books/v1",
    url: url_BooksLayersGet_579811, schemes: {Scheme.Https})
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
