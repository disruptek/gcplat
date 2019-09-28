
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Library Agent
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## A simple Google Example Library API.
## 
## https://cloud.google.com/docs/quota
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

  OpenApiRestCall_579408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579408): Option[Scheme] {.used.} =
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
  gcpServiceName = "libraryagent"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LibraryagentShelvesList_579677 = ref object of OpenApiRestCall_579408
proc url_LibraryagentShelvesList_579679(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_LibraryagentShelvesList_579678(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists shelves. The order is unspecified but deterministic. Newly created
  ## shelves will not necessarily be added to the end of this list.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token identifying a page of results the server should return.
  ## Typically, this is the value of
  ## ListShelvesResponse.next_page_token
  ## returned from the previous call to `ListShelves` method.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Requested page size. Server may return fewer shelves than requested.
  ## If unspecified, server will pick an appropriate default.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579791 = query.getOrDefault("upload_protocol")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "upload_protocol", valid_579791
  var valid_579792 = query.getOrDefault("fields")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "fields", valid_579792
  var valid_579793 = query.getOrDefault("pageToken")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "pageToken", valid_579793
  var valid_579794 = query.getOrDefault("quotaUser")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = nil)
  if valid_579794 != nil:
    section.add "quotaUser", valid_579794
  var valid_579808 = query.getOrDefault("alt")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = newJString("json"))
  if valid_579808 != nil:
    section.add "alt", valid_579808
  var valid_579809 = query.getOrDefault("oauth_token")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "oauth_token", valid_579809
  var valid_579810 = query.getOrDefault("callback")
  valid_579810 = validateParameter(valid_579810, JString, required = false,
                                 default = nil)
  if valid_579810 != nil:
    section.add "callback", valid_579810
  var valid_579811 = query.getOrDefault("access_token")
  valid_579811 = validateParameter(valid_579811, JString, required = false,
                                 default = nil)
  if valid_579811 != nil:
    section.add "access_token", valid_579811
  var valid_579812 = query.getOrDefault("uploadType")
  valid_579812 = validateParameter(valid_579812, JString, required = false,
                                 default = nil)
  if valid_579812 != nil:
    section.add "uploadType", valid_579812
  var valid_579813 = query.getOrDefault("key")
  valid_579813 = validateParameter(valid_579813, JString, required = false,
                                 default = nil)
  if valid_579813 != nil:
    section.add "key", valid_579813
  var valid_579814 = query.getOrDefault("$.xgafv")
  valid_579814 = validateParameter(valid_579814, JString, required = false,
                                 default = newJString("1"))
  if valid_579814 != nil:
    section.add "$.xgafv", valid_579814
  var valid_579815 = query.getOrDefault("pageSize")
  valid_579815 = validateParameter(valid_579815, JInt, required = false, default = nil)
  if valid_579815 != nil:
    section.add "pageSize", valid_579815
  var valid_579816 = query.getOrDefault("prettyPrint")
  valid_579816 = validateParameter(valid_579816, JBool, required = false,
                                 default = newJBool(true))
  if valid_579816 != nil:
    section.add "prettyPrint", valid_579816
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579839: Call_LibraryagentShelvesList_579677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists shelves. The order is unspecified but deterministic. Newly created
  ## shelves will not necessarily be added to the end of this list.
  ## 
  let valid = call_579839.validator(path, query, header, formData, body)
  let scheme = call_579839.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579839.url(scheme.get, call_579839.host, call_579839.base,
                         call_579839.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579839, url, valid)

proc call*(call_579910: Call_LibraryagentShelvesList_579677;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## libraryagentShelvesList
  ## Lists shelves. The order is unspecified but deterministic. Newly created
  ## shelves will not necessarily be added to the end of this list.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results the server should return.
  ## Typically, this is the value of
  ## ListShelvesResponse.next_page_token
  ## returned from the previous call to `ListShelves` method.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested page size. Server may return fewer shelves than requested.
  ## If unspecified, server will pick an appropriate default.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579911 = newJObject()
  add(query_579911, "upload_protocol", newJString(uploadProtocol))
  add(query_579911, "fields", newJString(fields))
  add(query_579911, "pageToken", newJString(pageToken))
  add(query_579911, "quotaUser", newJString(quotaUser))
  add(query_579911, "alt", newJString(alt))
  add(query_579911, "oauth_token", newJString(oauthToken))
  add(query_579911, "callback", newJString(callback))
  add(query_579911, "access_token", newJString(accessToken))
  add(query_579911, "uploadType", newJString(uploadType))
  add(query_579911, "key", newJString(key))
  add(query_579911, "$.xgafv", newJString(Xgafv))
  add(query_579911, "pageSize", newJInt(pageSize))
  add(query_579911, "prettyPrint", newJBool(prettyPrint))
  result = call_579910.call(nil, query_579911, nil, nil, nil)

var libraryagentShelvesList* = Call_LibraryagentShelvesList_579677(
    name: "libraryagentShelvesList", meth: HttpMethod.HttpGet,
    host: "libraryagent.googleapis.com", route: "/v1/shelves",
    validator: validate_LibraryagentShelvesList_579678, base: "/",
    url: url_LibraryagentShelvesList_579679, schemes: {Scheme.Https})
type
  Call_LibraryagentShelvesBooksGet_579951 = ref object of OpenApiRestCall_579408
proc url_LibraryagentShelvesBooksGet_579953(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LibraryagentShelvesBooksGet_579952(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a book. Returns NOT_FOUND if the book does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The name of the book to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579968 = path.getOrDefault("name")
  valid_579968 = validateParameter(valid_579968, JString, required = true,
                                 default = nil)
  if valid_579968 != nil:
    section.add "name", valid_579968
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579969 = query.getOrDefault("upload_protocol")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "upload_protocol", valid_579969
  var valid_579970 = query.getOrDefault("fields")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "fields", valid_579970
  var valid_579971 = query.getOrDefault("quotaUser")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "quotaUser", valid_579971
  var valid_579972 = query.getOrDefault("alt")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = newJString("json"))
  if valid_579972 != nil:
    section.add "alt", valid_579972
  var valid_579973 = query.getOrDefault("oauth_token")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "oauth_token", valid_579973
  var valid_579974 = query.getOrDefault("callback")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "callback", valid_579974
  var valid_579975 = query.getOrDefault("access_token")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "access_token", valid_579975
  var valid_579976 = query.getOrDefault("uploadType")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "uploadType", valid_579976
  var valid_579977 = query.getOrDefault("key")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "key", valid_579977
  var valid_579978 = query.getOrDefault("$.xgafv")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = newJString("1"))
  if valid_579978 != nil:
    section.add "$.xgafv", valid_579978
  var valid_579979 = query.getOrDefault("prettyPrint")
  valid_579979 = validateParameter(valid_579979, JBool, required = false,
                                 default = newJBool(true))
  if valid_579979 != nil:
    section.add "prettyPrint", valid_579979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579980: Call_LibraryagentShelvesBooksGet_579951; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a book. Returns NOT_FOUND if the book does not exist.
  ## 
  let valid = call_579980.validator(path, query, header, formData, body)
  let scheme = call_579980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579980.url(scheme.get, call_579980.host, call_579980.base,
                         call_579980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579980, url, valid)

proc call*(call_579981: Call_LibraryagentShelvesBooksGet_579951; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## libraryagentShelvesBooksGet
  ## Gets a book. Returns NOT_FOUND if the book does not exist.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the book to retrieve.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579982 = newJObject()
  var query_579983 = newJObject()
  add(query_579983, "upload_protocol", newJString(uploadProtocol))
  add(query_579983, "fields", newJString(fields))
  add(query_579983, "quotaUser", newJString(quotaUser))
  add(path_579982, "name", newJString(name))
  add(query_579983, "alt", newJString(alt))
  add(query_579983, "oauth_token", newJString(oauthToken))
  add(query_579983, "callback", newJString(callback))
  add(query_579983, "access_token", newJString(accessToken))
  add(query_579983, "uploadType", newJString(uploadType))
  add(query_579983, "key", newJString(key))
  add(query_579983, "$.xgafv", newJString(Xgafv))
  add(query_579983, "prettyPrint", newJBool(prettyPrint))
  result = call_579981.call(path_579982, query_579983, nil, nil, nil)

var libraryagentShelvesBooksGet* = Call_LibraryagentShelvesBooksGet_579951(
    name: "libraryagentShelvesBooksGet", meth: HttpMethod.HttpGet,
    host: "libraryagent.googleapis.com", route: "/v1/{name}",
    validator: validate_LibraryagentShelvesBooksGet_579952, base: "/",
    url: url_LibraryagentShelvesBooksGet_579953, schemes: {Scheme.Https})
type
  Call_LibraryagentShelvesBooksBorrow_579984 = ref object of OpenApiRestCall_579408
proc url_LibraryagentShelvesBooksBorrow_579986(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":borrow")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LibraryagentShelvesBooksBorrow_579985(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Borrow a book from the library. Returns the book if it is borrowed
  ## successfully. Returns NOT_FOUND if the book does not exist in the library.
  ## Returns quota exceeded error if the amount of books borrowed exceeds
  ## allocation quota in any dimensions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The name of the book to borrow.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579987 = path.getOrDefault("name")
  valid_579987 = validateParameter(valid_579987, JString, required = true,
                                 default = nil)
  if valid_579987 != nil:
    section.add "name", valid_579987
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579988 = query.getOrDefault("upload_protocol")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "upload_protocol", valid_579988
  var valid_579989 = query.getOrDefault("fields")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "fields", valid_579989
  var valid_579990 = query.getOrDefault("quotaUser")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "quotaUser", valid_579990
  var valid_579991 = query.getOrDefault("alt")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = newJString("json"))
  if valid_579991 != nil:
    section.add "alt", valid_579991
  var valid_579992 = query.getOrDefault("oauth_token")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "oauth_token", valid_579992
  var valid_579993 = query.getOrDefault("callback")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "callback", valid_579993
  var valid_579994 = query.getOrDefault("access_token")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "access_token", valid_579994
  var valid_579995 = query.getOrDefault("uploadType")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "uploadType", valid_579995
  var valid_579996 = query.getOrDefault("key")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "key", valid_579996
  var valid_579997 = query.getOrDefault("$.xgafv")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = newJString("1"))
  if valid_579997 != nil:
    section.add "$.xgafv", valid_579997
  var valid_579998 = query.getOrDefault("prettyPrint")
  valid_579998 = validateParameter(valid_579998, JBool, required = false,
                                 default = newJBool(true))
  if valid_579998 != nil:
    section.add "prettyPrint", valid_579998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579999: Call_LibraryagentShelvesBooksBorrow_579984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Borrow a book from the library. Returns the book if it is borrowed
  ## successfully. Returns NOT_FOUND if the book does not exist in the library.
  ## Returns quota exceeded error if the amount of books borrowed exceeds
  ## allocation quota in any dimensions.
  ## 
  let valid = call_579999.validator(path, query, header, formData, body)
  let scheme = call_579999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579999.url(scheme.get, call_579999.host, call_579999.base,
                         call_579999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579999, url, valid)

proc call*(call_580000: Call_LibraryagentShelvesBooksBorrow_579984; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## libraryagentShelvesBooksBorrow
  ## Borrow a book from the library. Returns the book if it is borrowed
  ## successfully. Returns NOT_FOUND if the book does not exist in the library.
  ## Returns quota exceeded error if the amount of books borrowed exceeds
  ## allocation quota in any dimensions.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the book to borrow.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580001 = newJObject()
  var query_580002 = newJObject()
  add(query_580002, "upload_protocol", newJString(uploadProtocol))
  add(query_580002, "fields", newJString(fields))
  add(query_580002, "quotaUser", newJString(quotaUser))
  add(path_580001, "name", newJString(name))
  add(query_580002, "alt", newJString(alt))
  add(query_580002, "oauth_token", newJString(oauthToken))
  add(query_580002, "callback", newJString(callback))
  add(query_580002, "access_token", newJString(accessToken))
  add(query_580002, "uploadType", newJString(uploadType))
  add(query_580002, "key", newJString(key))
  add(query_580002, "$.xgafv", newJString(Xgafv))
  add(query_580002, "prettyPrint", newJBool(prettyPrint))
  result = call_580000.call(path_580001, query_580002, nil, nil, nil)

var libraryagentShelvesBooksBorrow* = Call_LibraryagentShelvesBooksBorrow_579984(
    name: "libraryagentShelvesBooksBorrow", meth: HttpMethod.HttpPost,
    host: "libraryagent.googleapis.com", route: "/v1/{name}:borrow",
    validator: validate_LibraryagentShelvesBooksBorrow_579985, base: "/",
    url: url_LibraryagentShelvesBooksBorrow_579986, schemes: {Scheme.Https})
type
  Call_LibraryagentShelvesBooksReturn_580003 = ref object of OpenApiRestCall_579408
proc url_LibraryagentShelvesBooksReturn_580005(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":return")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LibraryagentShelvesBooksReturn_580004(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Return a book to the library. Returns the book if it is returned to the
  ## library successfully.
  ## Returns error if the book does not belong to the library
  ## or the users didn't borrow before.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The name of the book to return.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580006 = path.getOrDefault("name")
  valid_580006 = validateParameter(valid_580006, JString, required = true,
                                 default = nil)
  if valid_580006 != nil:
    section.add "name", valid_580006
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580007 = query.getOrDefault("upload_protocol")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "upload_protocol", valid_580007
  var valid_580008 = query.getOrDefault("fields")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "fields", valid_580008
  var valid_580009 = query.getOrDefault("quotaUser")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "quotaUser", valid_580009
  var valid_580010 = query.getOrDefault("alt")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = newJString("json"))
  if valid_580010 != nil:
    section.add "alt", valid_580010
  var valid_580011 = query.getOrDefault("oauth_token")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "oauth_token", valid_580011
  var valid_580012 = query.getOrDefault("callback")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "callback", valid_580012
  var valid_580013 = query.getOrDefault("access_token")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "access_token", valid_580013
  var valid_580014 = query.getOrDefault("uploadType")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "uploadType", valid_580014
  var valid_580015 = query.getOrDefault("key")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "key", valid_580015
  var valid_580016 = query.getOrDefault("$.xgafv")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = newJString("1"))
  if valid_580016 != nil:
    section.add "$.xgafv", valid_580016
  var valid_580017 = query.getOrDefault("prettyPrint")
  valid_580017 = validateParameter(valid_580017, JBool, required = false,
                                 default = newJBool(true))
  if valid_580017 != nil:
    section.add "prettyPrint", valid_580017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580018: Call_LibraryagentShelvesBooksReturn_580003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return a book to the library. Returns the book if it is returned to the
  ## library successfully.
  ## Returns error if the book does not belong to the library
  ## or the users didn't borrow before.
  ## 
  let valid = call_580018.validator(path, query, header, formData, body)
  let scheme = call_580018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580018.url(scheme.get, call_580018.host, call_580018.base,
                         call_580018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580018, url, valid)

proc call*(call_580019: Call_LibraryagentShelvesBooksReturn_580003; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## libraryagentShelvesBooksReturn
  ## Return a book to the library. Returns the book if it is returned to the
  ## library successfully.
  ## Returns error if the book does not belong to the library
  ## or the users didn't borrow before.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the book to return.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580020 = newJObject()
  var query_580021 = newJObject()
  add(query_580021, "upload_protocol", newJString(uploadProtocol))
  add(query_580021, "fields", newJString(fields))
  add(query_580021, "quotaUser", newJString(quotaUser))
  add(path_580020, "name", newJString(name))
  add(query_580021, "alt", newJString(alt))
  add(query_580021, "oauth_token", newJString(oauthToken))
  add(query_580021, "callback", newJString(callback))
  add(query_580021, "access_token", newJString(accessToken))
  add(query_580021, "uploadType", newJString(uploadType))
  add(query_580021, "key", newJString(key))
  add(query_580021, "$.xgafv", newJString(Xgafv))
  add(query_580021, "prettyPrint", newJBool(prettyPrint))
  result = call_580019.call(path_580020, query_580021, nil, nil, nil)

var libraryagentShelvesBooksReturn* = Call_LibraryagentShelvesBooksReturn_580003(
    name: "libraryagentShelvesBooksReturn", meth: HttpMethod.HttpPost,
    host: "libraryagent.googleapis.com", route: "/v1/{name}:return",
    validator: validate_LibraryagentShelvesBooksReturn_580004, base: "/",
    url: url_LibraryagentShelvesBooksReturn_580005, schemes: {Scheme.Https})
type
  Call_LibraryagentShelvesBooksList_580022 = ref object of OpenApiRestCall_579408
proc url_LibraryagentShelvesBooksList_580024(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/books")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LibraryagentShelvesBooksList_580023(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists books in a shelf. The order is unspecified but deterministic. Newly
  ## created books will not necessarily be added to the end of this list.
  ## Returns NOT_FOUND if the shelf does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the shelf whose books we'd like to list.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580025 = path.getOrDefault("parent")
  valid_580025 = validateParameter(valid_580025, JString, required = true,
                                 default = nil)
  if valid_580025 != nil:
    section.add "parent", valid_580025
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token identifying a page of results the server should return.
  ## Typically, this is the value of
  ## ListBooksResponse.next_page_token.
  ## returned from the previous call to `ListBooks` method.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Requested page size. Server may return fewer books than requested.
  ## If unspecified, server will pick an appropriate default.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580026 = query.getOrDefault("upload_protocol")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "upload_protocol", valid_580026
  var valid_580027 = query.getOrDefault("fields")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "fields", valid_580027
  var valid_580028 = query.getOrDefault("pageToken")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "pageToken", valid_580028
  var valid_580029 = query.getOrDefault("quotaUser")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "quotaUser", valid_580029
  var valid_580030 = query.getOrDefault("alt")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = newJString("json"))
  if valid_580030 != nil:
    section.add "alt", valid_580030
  var valid_580031 = query.getOrDefault("oauth_token")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "oauth_token", valid_580031
  var valid_580032 = query.getOrDefault("callback")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "callback", valid_580032
  var valid_580033 = query.getOrDefault("access_token")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "access_token", valid_580033
  var valid_580034 = query.getOrDefault("uploadType")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "uploadType", valid_580034
  var valid_580035 = query.getOrDefault("key")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "key", valid_580035
  var valid_580036 = query.getOrDefault("$.xgafv")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = newJString("1"))
  if valid_580036 != nil:
    section.add "$.xgafv", valid_580036
  var valid_580037 = query.getOrDefault("pageSize")
  valid_580037 = validateParameter(valid_580037, JInt, required = false, default = nil)
  if valid_580037 != nil:
    section.add "pageSize", valid_580037
  var valid_580038 = query.getOrDefault("prettyPrint")
  valid_580038 = validateParameter(valid_580038, JBool, required = false,
                                 default = newJBool(true))
  if valid_580038 != nil:
    section.add "prettyPrint", valid_580038
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580039: Call_LibraryagentShelvesBooksList_580022; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists books in a shelf. The order is unspecified but deterministic. Newly
  ## created books will not necessarily be added to the end of this list.
  ## Returns NOT_FOUND if the shelf does not exist.
  ## 
  let valid = call_580039.validator(path, query, header, formData, body)
  let scheme = call_580039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580039.url(scheme.get, call_580039.host, call_580039.base,
                         call_580039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580039, url, valid)

proc call*(call_580040: Call_LibraryagentShelvesBooksList_580022; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## libraryagentShelvesBooksList
  ## Lists books in a shelf. The order is unspecified but deterministic. Newly
  ## created books will not necessarily be added to the end of this list.
  ## Returns NOT_FOUND if the shelf does not exist.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results the server should return.
  ## Typically, this is the value of
  ## ListBooksResponse.next_page_token.
  ## returned from the previous call to `ListBooks` method.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The name of the shelf whose books we'd like to list.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested page size. Server may return fewer books than requested.
  ## If unspecified, server will pick an appropriate default.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580041 = newJObject()
  var query_580042 = newJObject()
  add(query_580042, "upload_protocol", newJString(uploadProtocol))
  add(query_580042, "fields", newJString(fields))
  add(query_580042, "pageToken", newJString(pageToken))
  add(query_580042, "quotaUser", newJString(quotaUser))
  add(query_580042, "alt", newJString(alt))
  add(query_580042, "oauth_token", newJString(oauthToken))
  add(query_580042, "callback", newJString(callback))
  add(query_580042, "access_token", newJString(accessToken))
  add(query_580042, "uploadType", newJString(uploadType))
  add(path_580041, "parent", newJString(parent))
  add(query_580042, "key", newJString(key))
  add(query_580042, "$.xgafv", newJString(Xgafv))
  add(query_580042, "pageSize", newJInt(pageSize))
  add(query_580042, "prettyPrint", newJBool(prettyPrint))
  result = call_580040.call(path_580041, query_580042, nil, nil, nil)

var libraryagentShelvesBooksList* = Call_LibraryagentShelvesBooksList_580022(
    name: "libraryagentShelvesBooksList", meth: HttpMethod.HttpGet,
    host: "libraryagent.googleapis.com", route: "/v1/{parent}/books",
    validator: validate_LibraryagentShelvesBooksList_580023, base: "/",
    url: url_LibraryagentShelvesBooksList_580024, schemes: {Scheme.Https})
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
