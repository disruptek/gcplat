
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Hangouts Chat
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Enables bots to fetch information and perform actions in Hangouts Chat.
## 
## https://developers.google.com/hangouts/chat
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

  OpenApiRestCall_597408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597408): Option[Scheme] {.used.} =
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
  gcpServiceName = "chat"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ChatSpacesList_597677 = ref object of OpenApiRestCall_597408
proc url_ChatSpacesList_597679(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ChatSpacesList_597678(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists spaces the caller is a member of.
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
  ##           : Requested page size. The value is capped at 1000.
  ## Server may return fewer results than requested.
  ## If unspecified, server will default to 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_597791 = query.getOrDefault("upload_protocol")
  valid_597791 = validateParameter(valid_597791, JString, required = false,
                                 default = nil)
  if valid_597791 != nil:
    section.add "upload_protocol", valid_597791
  var valid_597792 = query.getOrDefault("fields")
  valid_597792 = validateParameter(valid_597792, JString, required = false,
                                 default = nil)
  if valid_597792 != nil:
    section.add "fields", valid_597792
  var valid_597793 = query.getOrDefault("pageToken")
  valid_597793 = validateParameter(valid_597793, JString, required = false,
                                 default = nil)
  if valid_597793 != nil:
    section.add "pageToken", valid_597793
  var valid_597794 = query.getOrDefault("quotaUser")
  valid_597794 = validateParameter(valid_597794, JString, required = false,
                                 default = nil)
  if valid_597794 != nil:
    section.add "quotaUser", valid_597794
  var valid_597808 = query.getOrDefault("alt")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = newJString("json"))
  if valid_597808 != nil:
    section.add "alt", valid_597808
  var valid_597809 = query.getOrDefault("oauth_token")
  valid_597809 = validateParameter(valid_597809, JString, required = false,
                                 default = nil)
  if valid_597809 != nil:
    section.add "oauth_token", valid_597809
  var valid_597810 = query.getOrDefault("callback")
  valid_597810 = validateParameter(valid_597810, JString, required = false,
                                 default = nil)
  if valid_597810 != nil:
    section.add "callback", valid_597810
  var valid_597811 = query.getOrDefault("access_token")
  valid_597811 = validateParameter(valid_597811, JString, required = false,
                                 default = nil)
  if valid_597811 != nil:
    section.add "access_token", valid_597811
  var valid_597812 = query.getOrDefault("uploadType")
  valid_597812 = validateParameter(valid_597812, JString, required = false,
                                 default = nil)
  if valid_597812 != nil:
    section.add "uploadType", valid_597812
  var valid_597813 = query.getOrDefault("key")
  valid_597813 = validateParameter(valid_597813, JString, required = false,
                                 default = nil)
  if valid_597813 != nil:
    section.add "key", valid_597813
  var valid_597814 = query.getOrDefault("$.xgafv")
  valid_597814 = validateParameter(valid_597814, JString, required = false,
                                 default = newJString("1"))
  if valid_597814 != nil:
    section.add "$.xgafv", valid_597814
  var valid_597815 = query.getOrDefault("pageSize")
  valid_597815 = validateParameter(valid_597815, JInt, required = false, default = nil)
  if valid_597815 != nil:
    section.add "pageSize", valid_597815
  var valid_597816 = query.getOrDefault("prettyPrint")
  valid_597816 = validateParameter(valid_597816, JBool, required = false,
                                 default = newJBool(true))
  if valid_597816 != nil:
    section.add "prettyPrint", valid_597816
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597839: Call_ChatSpacesList_597677; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists spaces the caller is a member of.
  ## 
  let valid = call_597839.validator(path, query, header, formData, body)
  let scheme = call_597839.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597839.url(scheme.get, call_597839.host, call_597839.base,
                         call_597839.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597839, url, valid)

proc call*(call_597910: Call_ChatSpacesList_597677; uploadProtocol: string = "";
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## chatSpacesList
  ## Lists spaces the caller is a member of.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results the server should return.
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
  ##           : Requested page size. The value is capped at 1000.
  ## Server may return fewer results than requested.
  ## If unspecified, server will default to 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_597911 = newJObject()
  add(query_597911, "upload_protocol", newJString(uploadProtocol))
  add(query_597911, "fields", newJString(fields))
  add(query_597911, "pageToken", newJString(pageToken))
  add(query_597911, "quotaUser", newJString(quotaUser))
  add(query_597911, "alt", newJString(alt))
  add(query_597911, "oauth_token", newJString(oauthToken))
  add(query_597911, "callback", newJString(callback))
  add(query_597911, "access_token", newJString(accessToken))
  add(query_597911, "uploadType", newJString(uploadType))
  add(query_597911, "key", newJString(key))
  add(query_597911, "$.xgafv", newJString(Xgafv))
  add(query_597911, "pageSize", newJInt(pageSize))
  add(query_597911, "prettyPrint", newJBool(prettyPrint))
  result = call_597910.call(nil, query_597911, nil, nil, nil)

var chatSpacesList* = Call_ChatSpacesList_597677(name: "chatSpacesList",
    meth: HttpMethod.HttpGet, host: "chat.googleapis.com", route: "/v1/spaces",
    validator: validate_ChatSpacesList_597678, base: "/", url: url_ChatSpacesList_597679,
    schemes: {Scheme.Https})
type
  Call_ChatSpacesMessagesUpdate_597984 = ref object of OpenApiRestCall_597408
proc url_ChatSpacesMessagesUpdate_597986(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ChatSpacesMessagesUpdate_597985(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a message.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name, in the form "spaces/*/messages/*".
  ## 
  ## Example: spaces/AAAAMpdlehY/messages/UMxbHmzDlr4.UMxbHmzDlr4
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_597987 = path.getOrDefault("name")
  valid_597987 = validateParameter(valid_597987, JString, required = true,
                                 default = nil)
  if valid_597987 != nil:
    section.add "name", valid_597987
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
  ##   updateMask: JString
  ##             : Required. The field paths to be updated.
  ## 
  ## Currently supported field paths: "text", "cards".
  section = newJObject()
  var valid_597988 = query.getOrDefault("upload_protocol")
  valid_597988 = validateParameter(valid_597988, JString, required = false,
                                 default = nil)
  if valid_597988 != nil:
    section.add "upload_protocol", valid_597988
  var valid_597989 = query.getOrDefault("fields")
  valid_597989 = validateParameter(valid_597989, JString, required = false,
                                 default = nil)
  if valid_597989 != nil:
    section.add "fields", valid_597989
  var valid_597990 = query.getOrDefault("quotaUser")
  valid_597990 = validateParameter(valid_597990, JString, required = false,
                                 default = nil)
  if valid_597990 != nil:
    section.add "quotaUser", valid_597990
  var valid_597991 = query.getOrDefault("alt")
  valid_597991 = validateParameter(valid_597991, JString, required = false,
                                 default = newJString("json"))
  if valid_597991 != nil:
    section.add "alt", valid_597991
  var valid_597992 = query.getOrDefault("oauth_token")
  valid_597992 = validateParameter(valid_597992, JString, required = false,
                                 default = nil)
  if valid_597992 != nil:
    section.add "oauth_token", valid_597992
  var valid_597993 = query.getOrDefault("callback")
  valid_597993 = validateParameter(valid_597993, JString, required = false,
                                 default = nil)
  if valid_597993 != nil:
    section.add "callback", valid_597993
  var valid_597994 = query.getOrDefault("access_token")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "access_token", valid_597994
  var valid_597995 = query.getOrDefault("uploadType")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "uploadType", valid_597995
  var valid_597996 = query.getOrDefault("key")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "key", valid_597996
  var valid_597997 = query.getOrDefault("$.xgafv")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = newJString("1"))
  if valid_597997 != nil:
    section.add "$.xgafv", valid_597997
  var valid_597998 = query.getOrDefault("prettyPrint")
  valid_597998 = validateParameter(valid_597998, JBool, required = false,
                                 default = newJBool(true))
  if valid_597998 != nil:
    section.add "prettyPrint", valid_597998
  var valid_597999 = query.getOrDefault("updateMask")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = nil)
  if valid_597999 != nil:
    section.add "updateMask", valid_597999
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

proc call*(call_598001: Call_ChatSpacesMessagesUpdate_597984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a message.
  ## 
  let valid = call_598001.validator(path, query, header, formData, body)
  let scheme = call_598001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598001.url(scheme.get, call_598001.host, call_598001.base,
                         call_598001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598001, url, valid)

proc call*(call_598002: Call_ChatSpacesMessagesUpdate_597984; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          updateMask: string = ""): Recallable =
  ## chatSpacesMessagesUpdate
  ## Updates a message.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name, in the form "spaces/*/messages/*".
  ## 
  ## Example: spaces/AAAAMpdlehY/messages/UMxbHmzDlr4.UMxbHmzDlr4
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : Required. The field paths to be updated.
  ## 
  ## Currently supported field paths: "text", "cards".
  var path_598003 = newJObject()
  var query_598004 = newJObject()
  var body_598005 = newJObject()
  add(query_598004, "upload_protocol", newJString(uploadProtocol))
  add(query_598004, "fields", newJString(fields))
  add(query_598004, "quotaUser", newJString(quotaUser))
  add(path_598003, "name", newJString(name))
  add(query_598004, "alt", newJString(alt))
  add(query_598004, "oauth_token", newJString(oauthToken))
  add(query_598004, "callback", newJString(callback))
  add(query_598004, "access_token", newJString(accessToken))
  add(query_598004, "uploadType", newJString(uploadType))
  add(query_598004, "key", newJString(key))
  add(query_598004, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598005 = body
  add(query_598004, "prettyPrint", newJBool(prettyPrint))
  add(query_598004, "updateMask", newJString(updateMask))
  result = call_598002.call(path_598003, query_598004, nil, nil, body_598005)

var chatSpacesMessagesUpdate* = Call_ChatSpacesMessagesUpdate_597984(
    name: "chatSpacesMessagesUpdate", meth: HttpMethod.HttpPut,
    host: "chat.googleapis.com", route: "/v1/{name}",
    validator: validate_ChatSpacesMessagesUpdate_597985, base: "/",
    url: url_ChatSpacesMessagesUpdate_597986, schemes: {Scheme.Https})
type
  Call_ChatSpacesMessagesGet_597951 = ref object of OpenApiRestCall_597408
proc url_ChatSpacesMessagesGet_597953(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ChatSpacesMessagesGet_597952(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a message.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. Resource name of the message to be retrieved, in the form
  ## "spaces/*/messages/*".
  ## 
  ## Example: spaces/AAAAMpdlehY/messages/UMxbHmzDlr4.UMxbHmzDlr4
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_597968 = path.getOrDefault("name")
  valid_597968 = validateParameter(valid_597968, JString, required = true,
                                 default = nil)
  if valid_597968 != nil:
    section.add "name", valid_597968
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
  var valid_597969 = query.getOrDefault("upload_protocol")
  valid_597969 = validateParameter(valid_597969, JString, required = false,
                                 default = nil)
  if valid_597969 != nil:
    section.add "upload_protocol", valid_597969
  var valid_597970 = query.getOrDefault("fields")
  valid_597970 = validateParameter(valid_597970, JString, required = false,
                                 default = nil)
  if valid_597970 != nil:
    section.add "fields", valid_597970
  var valid_597971 = query.getOrDefault("quotaUser")
  valid_597971 = validateParameter(valid_597971, JString, required = false,
                                 default = nil)
  if valid_597971 != nil:
    section.add "quotaUser", valid_597971
  var valid_597972 = query.getOrDefault("alt")
  valid_597972 = validateParameter(valid_597972, JString, required = false,
                                 default = newJString("json"))
  if valid_597972 != nil:
    section.add "alt", valid_597972
  var valid_597973 = query.getOrDefault("oauth_token")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = nil)
  if valid_597973 != nil:
    section.add "oauth_token", valid_597973
  var valid_597974 = query.getOrDefault("callback")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = nil)
  if valid_597974 != nil:
    section.add "callback", valid_597974
  var valid_597975 = query.getOrDefault("access_token")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = nil)
  if valid_597975 != nil:
    section.add "access_token", valid_597975
  var valid_597976 = query.getOrDefault("uploadType")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "uploadType", valid_597976
  var valid_597977 = query.getOrDefault("key")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "key", valid_597977
  var valid_597978 = query.getOrDefault("$.xgafv")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = newJString("1"))
  if valid_597978 != nil:
    section.add "$.xgafv", valid_597978
  var valid_597979 = query.getOrDefault("prettyPrint")
  valid_597979 = validateParameter(valid_597979, JBool, required = false,
                                 default = newJBool(true))
  if valid_597979 != nil:
    section.add "prettyPrint", valid_597979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597980: Call_ChatSpacesMessagesGet_597951; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a message.
  ## 
  let valid = call_597980.validator(path, query, header, formData, body)
  let scheme = call_597980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597980.url(scheme.get, call_597980.host, call_597980.base,
                         call_597980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597980, url, valid)

proc call*(call_597981: Call_ChatSpacesMessagesGet_597951; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## chatSpacesMessagesGet
  ## Returns a message.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. Resource name of the message to be retrieved, in the form
  ## "spaces/*/messages/*".
  ## 
  ## Example: spaces/AAAAMpdlehY/messages/UMxbHmzDlr4.UMxbHmzDlr4
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
  var path_597982 = newJObject()
  var query_597983 = newJObject()
  add(query_597983, "upload_protocol", newJString(uploadProtocol))
  add(query_597983, "fields", newJString(fields))
  add(query_597983, "quotaUser", newJString(quotaUser))
  add(path_597982, "name", newJString(name))
  add(query_597983, "alt", newJString(alt))
  add(query_597983, "oauth_token", newJString(oauthToken))
  add(query_597983, "callback", newJString(callback))
  add(query_597983, "access_token", newJString(accessToken))
  add(query_597983, "uploadType", newJString(uploadType))
  add(query_597983, "key", newJString(key))
  add(query_597983, "$.xgafv", newJString(Xgafv))
  add(query_597983, "prettyPrint", newJBool(prettyPrint))
  result = call_597981.call(path_597982, query_597983, nil, nil, nil)

var chatSpacesMessagesGet* = Call_ChatSpacesMessagesGet_597951(
    name: "chatSpacesMessagesGet", meth: HttpMethod.HttpGet,
    host: "chat.googleapis.com", route: "/v1/{name}",
    validator: validate_ChatSpacesMessagesGet_597952, base: "/",
    url: url_ChatSpacesMessagesGet_597953, schemes: {Scheme.Https})
type
  Call_ChatSpacesMessagesDelete_598006 = ref object of OpenApiRestCall_597408
proc url_ChatSpacesMessagesDelete_598008(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ChatSpacesMessagesDelete_598007(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a message.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. Resource name of the message to be deleted, in the form
  ## "spaces/*/messages/*"
  ## 
  ## Example: spaces/AAAAMpdlehY/messages/UMxbHmzDlr4.UMxbHmzDlr4
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_598009 = path.getOrDefault("name")
  valid_598009 = validateParameter(valid_598009, JString, required = true,
                                 default = nil)
  if valid_598009 != nil:
    section.add "name", valid_598009
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
  var valid_598010 = query.getOrDefault("upload_protocol")
  valid_598010 = validateParameter(valid_598010, JString, required = false,
                                 default = nil)
  if valid_598010 != nil:
    section.add "upload_protocol", valid_598010
  var valid_598011 = query.getOrDefault("fields")
  valid_598011 = validateParameter(valid_598011, JString, required = false,
                                 default = nil)
  if valid_598011 != nil:
    section.add "fields", valid_598011
  var valid_598012 = query.getOrDefault("quotaUser")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "quotaUser", valid_598012
  var valid_598013 = query.getOrDefault("alt")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = newJString("json"))
  if valid_598013 != nil:
    section.add "alt", valid_598013
  var valid_598014 = query.getOrDefault("oauth_token")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = nil)
  if valid_598014 != nil:
    section.add "oauth_token", valid_598014
  var valid_598015 = query.getOrDefault("callback")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "callback", valid_598015
  var valid_598016 = query.getOrDefault("access_token")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "access_token", valid_598016
  var valid_598017 = query.getOrDefault("uploadType")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "uploadType", valid_598017
  var valid_598018 = query.getOrDefault("key")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = nil)
  if valid_598018 != nil:
    section.add "key", valid_598018
  var valid_598019 = query.getOrDefault("$.xgafv")
  valid_598019 = validateParameter(valid_598019, JString, required = false,
                                 default = newJString("1"))
  if valid_598019 != nil:
    section.add "$.xgafv", valid_598019
  var valid_598020 = query.getOrDefault("prettyPrint")
  valid_598020 = validateParameter(valid_598020, JBool, required = false,
                                 default = newJBool(true))
  if valid_598020 != nil:
    section.add "prettyPrint", valid_598020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598021: Call_ChatSpacesMessagesDelete_598006; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a message.
  ## 
  let valid = call_598021.validator(path, query, header, formData, body)
  let scheme = call_598021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598021.url(scheme.get, call_598021.host, call_598021.base,
                         call_598021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598021, url, valid)

proc call*(call_598022: Call_ChatSpacesMessagesDelete_598006; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## chatSpacesMessagesDelete
  ## Deletes a message.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. Resource name of the message to be deleted, in the form
  ## "spaces/*/messages/*"
  ## 
  ## Example: spaces/AAAAMpdlehY/messages/UMxbHmzDlr4.UMxbHmzDlr4
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
  var path_598023 = newJObject()
  var query_598024 = newJObject()
  add(query_598024, "upload_protocol", newJString(uploadProtocol))
  add(query_598024, "fields", newJString(fields))
  add(query_598024, "quotaUser", newJString(quotaUser))
  add(path_598023, "name", newJString(name))
  add(query_598024, "alt", newJString(alt))
  add(query_598024, "oauth_token", newJString(oauthToken))
  add(query_598024, "callback", newJString(callback))
  add(query_598024, "access_token", newJString(accessToken))
  add(query_598024, "uploadType", newJString(uploadType))
  add(query_598024, "key", newJString(key))
  add(query_598024, "$.xgafv", newJString(Xgafv))
  add(query_598024, "prettyPrint", newJBool(prettyPrint))
  result = call_598022.call(path_598023, query_598024, nil, nil, nil)

var chatSpacesMessagesDelete* = Call_ChatSpacesMessagesDelete_598006(
    name: "chatSpacesMessagesDelete", meth: HttpMethod.HttpDelete,
    host: "chat.googleapis.com", route: "/v1/{name}",
    validator: validate_ChatSpacesMessagesDelete_598007, base: "/",
    url: url_ChatSpacesMessagesDelete_598008, schemes: {Scheme.Https})
type
  Call_ChatSpacesMembersList_598025 = ref object of OpenApiRestCall_597408
proc url_ChatSpacesMembersList_598027(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/members")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ChatSpacesMembersList_598026(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists human memberships in a space.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The resource name of the space for which membership list is to be
  ## fetched, in the form "spaces/*".
  ## 
  ## Example: spaces/AAAAMpdlehY
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_598028 = path.getOrDefault("parent")
  valid_598028 = validateParameter(valid_598028, JString, required = true,
                                 default = nil)
  if valid_598028 != nil:
    section.add "parent", valid_598028
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token identifying a page of results the server should return.
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
  ##           : Requested page size. The value is capped at 1000.
  ## Server may return fewer results than requested.
  ## If unspecified, server will default to 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598029 = query.getOrDefault("upload_protocol")
  valid_598029 = validateParameter(valid_598029, JString, required = false,
                                 default = nil)
  if valid_598029 != nil:
    section.add "upload_protocol", valid_598029
  var valid_598030 = query.getOrDefault("fields")
  valid_598030 = validateParameter(valid_598030, JString, required = false,
                                 default = nil)
  if valid_598030 != nil:
    section.add "fields", valid_598030
  var valid_598031 = query.getOrDefault("pageToken")
  valid_598031 = validateParameter(valid_598031, JString, required = false,
                                 default = nil)
  if valid_598031 != nil:
    section.add "pageToken", valid_598031
  var valid_598032 = query.getOrDefault("quotaUser")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "quotaUser", valid_598032
  var valid_598033 = query.getOrDefault("alt")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = newJString("json"))
  if valid_598033 != nil:
    section.add "alt", valid_598033
  var valid_598034 = query.getOrDefault("oauth_token")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "oauth_token", valid_598034
  var valid_598035 = query.getOrDefault("callback")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = nil)
  if valid_598035 != nil:
    section.add "callback", valid_598035
  var valid_598036 = query.getOrDefault("access_token")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "access_token", valid_598036
  var valid_598037 = query.getOrDefault("uploadType")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = nil)
  if valid_598037 != nil:
    section.add "uploadType", valid_598037
  var valid_598038 = query.getOrDefault("key")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = nil)
  if valid_598038 != nil:
    section.add "key", valid_598038
  var valid_598039 = query.getOrDefault("$.xgafv")
  valid_598039 = validateParameter(valid_598039, JString, required = false,
                                 default = newJString("1"))
  if valid_598039 != nil:
    section.add "$.xgafv", valid_598039
  var valid_598040 = query.getOrDefault("pageSize")
  valid_598040 = validateParameter(valid_598040, JInt, required = false, default = nil)
  if valid_598040 != nil:
    section.add "pageSize", valid_598040
  var valid_598041 = query.getOrDefault("prettyPrint")
  valid_598041 = validateParameter(valid_598041, JBool, required = false,
                                 default = newJBool(true))
  if valid_598041 != nil:
    section.add "prettyPrint", valid_598041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598042: Call_ChatSpacesMembersList_598025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists human memberships in a space.
  ## 
  let valid = call_598042.validator(path, query, header, formData, body)
  let scheme = call_598042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598042.url(scheme.get, call_598042.host, call_598042.base,
                         call_598042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598042, url, valid)

proc call*(call_598043: Call_ChatSpacesMembersList_598025; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## chatSpacesMembersList
  ## Lists human memberships in a space.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results the server should return.
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
  ##         : Required. The resource name of the space for which membership list is to be
  ## fetched, in the form "spaces/*".
  ## 
  ## Example: spaces/AAAAMpdlehY
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested page size. The value is capped at 1000.
  ## Server may return fewer results than requested.
  ## If unspecified, server will default to 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598044 = newJObject()
  var query_598045 = newJObject()
  add(query_598045, "upload_protocol", newJString(uploadProtocol))
  add(query_598045, "fields", newJString(fields))
  add(query_598045, "pageToken", newJString(pageToken))
  add(query_598045, "quotaUser", newJString(quotaUser))
  add(query_598045, "alt", newJString(alt))
  add(query_598045, "oauth_token", newJString(oauthToken))
  add(query_598045, "callback", newJString(callback))
  add(query_598045, "access_token", newJString(accessToken))
  add(query_598045, "uploadType", newJString(uploadType))
  add(path_598044, "parent", newJString(parent))
  add(query_598045, "key", newJString(key))
  add(query_598045, "$.xgafv", newJString(Xgafv))
  add(query_598045, "pageSize", newJInt(pageSize))
  add(query_598045, "prettyPrint", newJBool(prettyPrint))
  result = call_598043.call(path_598044, query_598045, nil, nil, nil)

var chatSpacesMembersList* = Call_ChatSpacesMembersList_598025(
    name: "chatSpacesMembersList", meth: HttpMethod.HttpGet,
    host: "chat.googleapis.com", route: "/v1/{parent}/members",
    validator: validate_ChatSpacesMembersList_598026, base: "/",
    url: url_ChatSpacesMembersList_598027, schemes: {Scheme.Https})
type
  Call_ChatSpacesMessagesCreate_598046 = ref object of OpenApiRestCall_597408
proc url_ChatSpacesMessagesCreate_598048(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/messages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ChatSpacesMessagesCreate_598047(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a message.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. Space resource name, in the form "spaces/*".
  ## Example: spaces/AAAAMpdlehY
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_598049 = path.getOrDefault("parent")
  valid_598049 = validateParameter(valid_598049, JString, required = true,
                                 default = nil)
  if valid_598049 != nil:
    section.add "parent", valid_598049
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
  ##   threadKey: JString
  ##            : Opaque thread identifier string that can be specified to group messages
  ## into a single thread. If this is the first message with a given thread
  ## identifier, a new thread is created. Subsequent messages with the same
  ## thread identifier will be posted into the same thread. This relieves bots
  ## and webhooks from having to store the Hangouts Chat thread ID of a thread (created earlier by them) to post
  ## further updates to it.
  ## 
  ## Has no effect if thread field,
  ## corresponding to an existing thread, is set in message.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598050 = query.getOrDefault("upload_protocol")
  valid_598050 = validateParameter(valid_598050, JString, required = false,
                                 default = nil)
  if valid_598050 != nil:
    section.add "upload_protocol", valid_598050
  var valid_598051 = query.getOrDefault("fields")
  valid_598051 = validateParameter(valid_598051, JString, required = false,
                                 default = nil)
  if valid_598051 != nil:
    section.add "fields", valid_598051
  var valid_598052 = query.getOrDefault("quotaUser")
  valid_598052 = validateParameter(valid_598052, JString, required = false,
                                 default = nil)
  if valid_598052 != nil:
    section.add "quotaUser", valid_598052
  var valid_598053 = query.getOrDefault("alt")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = newJString("json"))
  if valid_598053 != nil:
    section.add "alt", valid_598053
  var valid_598054 = query.getOrDefault("oauth_token")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = nil)
  if valid_598054 != nil:
    section.add "oauth_token", valid_598054
  var valid_598055 = query.getOrDefault("callback")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = nil)
  if valid_598055 != nil:
    section.add "callback", valid_598055
  var valid_598056 = query.getOrDefault("access_token")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = nil)
  if valid_598056 != nil:
    section.add "access_token", valid_598056
  var valid_598057 = query.getOrDefault("uploadType")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = nil)
  if valid_598057 != nil:
    section.add "uploadType", valid_598057
  var valid_598058 = query.getOrDefault("threadKey")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = nil)
  if valid_598058 != nil:
    section.add "threadKey", valid_598058
  var valid_598059 = query.getOrDefault("key")
  valid_598059 = validateParameter(valid_598059, JString, required = false,
                                 default = nil)
  if valid_598059 != nil:
    section.add "key", valid_598059
  var valid_598060 = query.getOrDefault("$.xgafv")
  valid_598060 = validateParameter(valid_598060, JString, required = false,
                                 default = newJString("1"))
  if valid_598060 != nil:
    section.add "$.xgafv", valid_598060
  var valid_598061 = query.getOrDefault("prettyPrint")
  valid_598061 = validateParameter(valid_598061, JBool, required = false,
                                 default = newJBool(true))
  if valid_598061 != nil:
    section.add "prettyPrint", valid_598061
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

proc call*(call_598063: Call_ChatSpacesMessagesCreate_598046; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a message.
  ## 
  let valid = call_598063.validator(path, query, header, formData, body)
  let scheme = call_598063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598063.url(scheme.get, call_598063.host, call_598063.base,
                         call_598063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598063, url, valid)

proc call*(call_598064: Call_ChatSpacesMessagesCreate_598046; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; threadKey: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## chatSpacesMessagesCreate
  ## Creates a message.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
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
  ##         : Required. Space resource name, in the form "spaces/*".
  ## Example: spaces/AAAAMpdlehY
  ##   threadKey: string
  ##            : Opaque thread identifier string that can be specified to group messages
  ## into a single thread. If this is the first message with a given thread
  ## identifier, a new thread is created. Subsequent messages with the same
  ## thread identifier will be posted into the same thread. This relieves bots
  ## and webhooks from having to store the Hangouts Chat thread ID of a thread (created earlier by them) to post
  ## further updates to it.
  ## 
  ## Has no effect if thread field,
  ## corresponding to an existing thread, is set in message.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598065 = newJObject()
  var query_598066 = newJObject()
  var body_598067 = newJObject()
  add(query_598066, "upload_protocol", newJString(uploadProtocol))
  add(query_598066, "fields", newJString(fields))
  add(query_598066, "quotaUser", newJString(quotaUser))
  add(query_598066, "alt", newJString(alt))
  add(query_598066, "oauth_token", newJString(oauthToken))
  add(query_598066, "callback", newJString(callback))
  add(query_598066, "access_token", newJString(accessToken))
  add(query_598066, "uploadType", newJString(uploadType))
  add(path_598065, "parent", newJString(parent))
  add(query_598066, "threadKey", newJString(threadKey))
  add(query_598066, "key", newJString(key))
  add(query_598066, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598067 = body
  add(query_598066, "prettyPrint", newJBool(prettyPrint))
  result = call_598064.call(path_598065, query_598066, nil, nil, body_598067)

var chatSpacesMessagesCreate* = Call_ChatSpacesMessagesCreate_598046(
    name: "chatSpacesMessagesCreate", meth: HttpMethod.HttpPost,
    host: "chat.googleapis.com", route: "/v1/{parent}/messages",
    validator: validate_ChatSpacesMessagesCreate_598047, base: "/",
    url: url_ChatSpacesMessagesCreate_598048, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
