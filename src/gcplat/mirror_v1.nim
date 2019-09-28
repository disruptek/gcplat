
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Mirror
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Interacts with Glass users via the timeline.
## 
## https://developers.google.com/glass
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
  gcpServiceName = "mirror"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_MirrorAccountsInsert_579676 = ref object of OpenApiRestCall_579408
proc url_MirrorAccountsInsert_579678(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userToken" in path, "`userToken` is a required path parameter"
  assert "accountType" in path, "`accountType` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "userToken"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "accountType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorAccountsInsert_579677(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts a new account for a user
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountType: JString (required)
  ##              : Account type to be passed to Android Account Manager.
  ##   userToken: JString (required)
  ##            : The ID for the user.
  ##   accountName: JString (required)
  ##              : The name of the account to be passed to the Android Account Manager.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `accountType` field"
  var valid_579804 = path.getOrDefault("accountType")
  valid_579804 = validateParameter(valid_579804, JString, required = true,
                                 default = nil)
  if valid_579804 != nil:
    section.add "accountType", valid_579804
  var valid_579805 = path.getOrDefault("userToken")
  valid_579805 = validateParameter(valid_579805, JString, required = true,
                                 default = nil)
  if valid_579805 != nil:
    section.add "userToken", valid_579805
  var valid_579806 = path.getOrDefault("accountName")
  valid_579806 = validateParameter(valid_579806, JString, required = true,
                                 default = nil)
  if valid_579806 != nil:
    section.add "accountName", valid_579806
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
  var valid_579807 = query.getOrDefault("fields")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "fields", valid_579807
  var valid_579808 = query.getOrDefault("quotaUser")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "quotaUser", valid_579808
  var valid_579822 = query.getOrDefault("alt")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = newJString("json"))
  if valid_579822 != nil:
    section.add "alt", valid_579822
  var valid_579823 = query.getOrDefault("oauth_token")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "oauth_token", valid_579823
  var valid_579824 = query.getOrDefault("userIp")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "userIp", valid_579824
  var valid_579825 = query.getOrDefault("key")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "key", valid_579825
  var valid_579826 = query.getOrDefault("prettyPrint")
  valid_579826 = validateParameter(valid_579826, JBool, required = false,
                                 default = newJBool(true))
  if valid_579826 != nil:
    section.add "prettyPrint", valid_579826
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

proc call*(call_579850: Call_MirrorAccountsInsert_579676; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a new account for a user
  ## 
  let valid = call_579850.validator(path, query, header, formData, body)
  let scheme = call_579850.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579850.url(scheme.get, call_579850.host, call_579850.base,
                         call_579850.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579850, url, valid)

proc call*(call_579921: Call_MirrorAccountsInsert_579676; accountType: string;
          userToken: string; accountName: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## mirrorAccountsInsert
  ## Inserts a new account for a user
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   accountType: string (required)
  ##              : Account type to be passed to Android Account Manager.
  ##   userToken: string (required)
  ##            : The ID for the user.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   accountName: string (required)
  ##              : The name of the account to be passed to the Android Account Manager.
  var path_579922 = newJObject()
  var query_579924 = newJObject()
  var body_579925 = newJObject()
  add(query_579924, "fields", newJString(fields))
  add(query_579924, "quotaUser", newJString(quotaUser))
  add(query_579924, "alt", newJString(alt))
  add(path_579922, "accountType", newJString(accountType))
  add(path_579922, "userToken", newJString(userToken))
  add(query_579924, "oauth_token", newJString(oauthToken))
  add(query_579924, "userIp", newJString(userIp))
  add(query_579924, "key", newJString(key))
  if body != nil:
    body_579925 = body
  add(query_579924, "prettyPrint", newJBool(prettyPrint))
  add(path_579922, "accountName", newJString(accountName))
  result = call_579921.call(path_579922, query_579924, nil, nil, body_579925)

var mirrorAccountsInsert* = Call_MirrorAccountsInsert_579676(
    name: "mirrorAccountsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/accounts/{userToken}/{accountType}/{accountName}",
    validator: validate_MirrorAccountsInsert_579677, base: "/mirror/v1",
    url: url_MirrorAccountsInsert_579678, schemes: {Scheme.Https})
type
  Call_MirrorContactsInsert_579977 = ref object of OpenApiRestCall_579408
proc url_MirrorContactsInsert_579979(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_MirrorContactsInsert_579978(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts a new contact.
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
  var valid_579986 = query.getOrDefault("prettyPrint")
  valid_579986 = validateParameter(valid_579986, JBool, required = false,
                                 default = newJBool(true))
  if valid_579986 != nil:
    section.add "prettyPrint", valid_579986
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

proc call*(call_579988: Call_MirrorContactsInsert_579977; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a new contact.
  ## 
  let valid = call_579988.validator(path, query, header, formData, body)
  let scheme = call_579988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579988.url(scheme.get, call_579988.host, call_579988.base,
                         call_579988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579988, url, valid)

proc call*(call_579989: Call_MirrorContactsInsert_579977; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## mirrorContactsInsert
  ## Inserts a new contact.
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
  var query_579990 = newJObject()
  var body_579991 = newJObject()
  add(query_579990, "fields", newJString(fields))
  add(query_579990, "quotaUser", newJString(quotaUser))
  add(query_579990, "alt", newJString(alt))
  add(query_579990, "oauth_token", newJString(oauthToken))
  add(query_579990, "userIp", newJString(userIp))
  add(query_579990, "key", newJString(key))
  if body != nil:
    body_579991 = body
  add(query_579990, "prettyPrint", newJBool(prettyPrint))
  result = call_579989.call(nil, query_579990, nil, nil, body_579991)

var mirrorContactsInsert* = Call_MirrorContactsInsert_579977(
    name: "mirrorContactsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/contacts",
    validator: validate_MirrorContactsInsert_579978, base: "/mirror/v1",
    url: url_MirrorContactsInsert_579979, schemes: {Scheme.Https})
type
  Call_MirrorContactsList_579964 = ref object of OpenApiRestCall_579408
proc url_MirrorContactsList_579966(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_MirrorContactsList_579965(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves a list of contacts for the authenticated user.
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
  var valid_579967 = query.getOrDefault("fields")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "fields", valid_579967
  var valid_579968 = query.getOrDefault("quotaUser")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "quotaUser", valid_579968
  var valid_579969 = query.getOrDefault("alt")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = newJString("json"))
  if valid_579969 != nil:
    section.add "alt", valid_579969
  var valid_579970 = query.getOrDefault("oauth_token")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "oauth_token", valid_579970
  var valid_579971 = query.getOrDefault("userIp")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "userIp", valid_579971
  var valid_579972 = query.getOrDefault("key")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "key", valid_579972
  var valid_579973 = query.getOrDefault("prettyPrint")
  valid_579973 = validateParameter(valid_579973, JBool, required = false,
                                 default = newJBool(true))
  if valid_579973 != nil:
    section.add "prettyPrint", valid_579973
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579974: Call_MirrorContactsList_579964; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of contacts for the authenticated user.
  ## 
  let valid = call_579974.validator(path, query, header, formData, body)
  let scheme = call_579974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579974.url(scheme.get, call_579974.host, call_579974.base,
                         call_579974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579974, url, valid)

proc call*(call_579975: Call_MirrorContactsList_579964; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## mirrorContactsList
  ## Retrieves a list of contacts for the authenticated user.
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
  var query_579976 = newJObject()
  add(query_579976, "fields", newJString(fields))
  add(query_579976, "quotaUser", newJString(quotaUser))
  add(query_579976, "alt", newJString(alt))
  add(query_579976, "oauth_token", newJString(oauthToken))
  add(query_579976, "userIp", newJString(userIp))
  add(query_579976, "key", newJString(key))
  add(query_579976, "prettyPrint", newJBool(prettyPrint))
  result = call_579975.call(nil, query_579976, nil, nil, nil)

var mirrorContactsList* = Call_MirrorContactsList_579964(
    name: "mirrorContactsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/contacts",
    validator: validate_MirrorContactsList_579965, base: "/mirror/v1",
    url: url_MirrorContactsList_579966, schemes: {Scheme.Https})
type
  Call_MirrorContactsUpdate_580007 = ref object of OpenApiRestCall_579408
proc url_MirrorContactsUpdate_580009(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/contacts/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorContactsUpdate_580008(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a contact in place.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the contact.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_580010 = path.getOrDefault("id")
  valid_580010 = validateParameter(valid_580010, JString, required = true,
                                 default = nil)
  if valid_580010 != nil:
    section.add "id", valid_580010
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
  var valid_580011 = query.getOrDefault("fields")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "fields", valid_580011
  var valid_580012 = query.getOrDefault("quotaUser")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "quotaUser", valid_580012
  var valid_580013 = query.getOrDefault("alt")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = newJString("json"))
  if valid_580013 != nil:
    section.add "alt", valid_580013
  var valid_580014 = query.getOrDefault("oauth_token")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "oauth_token", valid_580014
  var valid_580015 = query.getOrDefault("userIp")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "userIp", valid_580015
  var valid_580016 = query.getOrDefault("key")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "key", valid_580016
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580019: Call_MirrorContactsUpdate_580007; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a contact in place.
  ## 
  let valid = call_580019.validator(path, query, header, formData, body)
  let scheme = call_580019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580019.url(scheme.get, call_580019.host, call_580019.base,
                         call_580019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580019, url, valid)

proc call*(call_580020: Call_MirrorContactsUpdate_580007; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## mirrorContactsUpdate
  ## Updates a contact in place.
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
  ##   id: string (required)
  ##     : The ID of the contact.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580021 = newJObject()
  var query_580022 = newJObject()
  var body_580023 = newJObject()
  add(query_580022, "fields", newJString(fields))
  add(query_580022, "quotaUser", newJString(quotaUser))
  add(query_580022, "alt", newJString(alt))
  add(query_580022, "oauth_token", newJString(oauthToken))
  add(query_580022, "userIp", newJString(userIp))
  add(path_580021, "id", newJString(id))
  add(query_580022, "key", newJString(key))
  if body != nil:
    body_580023 = body
  add(query_580022, "prettyPrint", newJBool(prettyPrint))
  result = call_580020.call(path_580021, query_580022, nil, nil, body_580023)

var mirrorContactsUpdate* = Call_MirrorContactsUpdate_580007(
    name: "mirrorContactsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/contacts/{id}",
    validator: validate_MirrorContactsUpdate_580008, base: "/mirror/v1",
    url: url_MirrorContactsUpdate_580009, schemes: {Scheme.Https})
type
  Call_MirrorContactsGet_579992 = ref object of OpenApiRestCall_579408
proc url_MirrorContactsGet_579994(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/contacts/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorContactsGet_579993(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a single contact by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the contact.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_579995 = path.getOrDefault("id")
  valid_579995 = validateParameter(valid_579995, JString, required = true,
                                 default = nil)
  if valid_579995 != nil:
    section.add "id", valid_579995
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
  var valid_579996 = query.getOrDefault("fields")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "fields", valid_579996
  var valid_579997 = query.getOrDefault("quotaUser")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "quotaUser", valid_579997
  var valid_579998 = query.getOrDefault("alt")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = newJString("json"))
  if valid_579998 != nil:
    section.add "alt", valid_579998
  var valid_579999 = query.getOrDefault("oauth_token")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "oauth_token", valid_579999
  var valid_580000 = query.getOrDefault("userIp")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "userIp", valid_580000
  var valid_580001 = query.getOrDefault("key")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "key", valid_580001
  var valid_580002 = query.getOrDefault("prettyPrint")
  valid_580002 = validateParameter(valid_580002, JBool, required = false,
                                 default = newJBool(true))
  if valid_580002 != nil:
    section.add "prettyPrint", valid_580002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580003: Call_MirrorContactsGet_579992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a single contact by ID.
  ## 
  let valid = call_580003.validator(path, query, header, formData, body)
  let scheme = call_580003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580003.url(scheme.get, call_580003.host, call_580003.base,
                         call_580003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580003, url, valid)

proc call*(call_580004: Call_MirrorContactsGet_579992; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## mirrorContactsGet
  ## Gets a single contact by ID.
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
  ##   id: string (required)
  ##     : The ID of the contact.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580005 = newJObject()
  var query_580006 = newJObject()
  add(query_580006, "fields", newJString(fields))
  add(query_580006, "quotaUser", newJString(quotaUser))
  add(query_580006, "alt", newJString(alt))
  add(query_580006, "oauth_token", newJString(oauthToken))
  add(query_580006, "userIp", newJString(userIp))
  add(path_580005, "id", newJString(id))
  add(query_580006, "key", newJString(key))
  add(query_580006, "prettyPrint", newJBool(prettyPrint))
  result = call_580004.call(path_580005, query_580006, nil, nil, nil)

var mirrorContactsGet* = Call_MirrorContactsGet_579992(name: "mirrorContactsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/contacts/{id}",
    validator: validate_MirrorContactsGet_579993, base: "/mirror/v1",
    url: url_MirrorContactsGet_579994, schemes: {Scheme.Https})
type
  Call_MirrorContactsPatch_580039 = ref object of OpenApiRestCall_579408
proc url_MirrorContactsPatch_580041(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/contacts/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorContactsPatch_580040(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates a contact in place. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the contact.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_580042 = path.getOrDefault("id")
  valid_580042 = validateParameter(valid_580042, JString, required = true,
                                 default = nil)
  if valid_580042 != nil:
    section.add "id", valid_580042
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
  var valid_580043 = query.getOrDefault("fields")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "fields", valid_580043
  var valid_580044 = query.getOrDefault("quotaUser")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "quotaUser", valid_580044
  var valid_580045 = query.getOrDefault("alt")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = newJString("json"))
  if valid_580045 != nil:
    section.add "alt", valid_580045
  var valid_580046 = query.getOrDefault("oauth_token")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "oauth_token", valid_580046
  var valid_580047 = query.getOrDefault("userIp")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "userIp", valid_580047
  var valid_580048 = query.getOrDefault("key")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "key", valid_580048
  var valid_580049 = query.getOrDefault("prettyPrint")
  valid_580049 = validateParameter(valid_580049, JBool, required = false,
                                 default = newJBool(true))
  if valid_580049 != nil:
    section.add "prettyPrint", valid_580049
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

proc call*(call_580051: Call_MirrorContactsPatch_580039; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a contact in place. This method supports patch semantics.
  ## 
  let valid = call_580051.validator(path, query, header, formData, body)
  let scheme = call_580051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580051.url(scheme.get, call_580051.host, call_580051.base,
                         call_580051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580051, url, valid)

proc call*(call_580052: Call_MirrorContactsPatch_580039; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## mirrorContactsPatch
  ## Updates a contact in place. This method supports patch semantics.
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
  ##   id: string (required)
  ##     : The ID of the contact.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580053 = newJObject()
  var query_580054 = newJObject()
  var body_580055 = newJObject()
  add(query_580054, "fields", newJString(fields))
  add(query_580054, "quotaUser", newJString(quotaUser))
  add(query_580054, "alt", newJString(alt))
  add(query_580054, "oauth_token", newJString(oauthToken))
  add(query_580054, "userIp", newJString(userIp))
  add(path_580053, "id", newJString(id))
  add(query_580054, "key", newJString(key))
  if body != nil:
    body_580055 = body
  add(query_580054, "prettyPrint", newJBool(prettyPrint))
  result = call_580052.call(path_580053, query_580054, nil, nil, body_580055)

var mirrorContactsPatch* = Call_MirrorContactsPatch_580039(
    name: "mirrorContactsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/contacts/{id}",
    validator: validate_MirrorContactsPatch_580040, base: "/mirror/v1",
    url: url_MirrorContactsPatch_580041, schemes: {Scheme.Https})
type
  Call_MirrorContactsDelete_580024 = ref object of OpenApiRestCall_579408
proc url_MirrorContactsDelete_580026(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/contacts/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorContactsDelete_580025(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a contact.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the contact.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_580027 = path.getOrDefault("id")
  valid_580027 = validateParameter(valid_580027, JString, required = true,
                                 default = nil)
  if valid_580027 != nil:
    section.add "id", valid_580027
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
  var valid_580028 = query.getOrDefault("fields")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "fields", valid_580028
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
  var valid_580032 = query.getOrDefault("userIp")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "userIp", valid_580032
  var valid_580033 = query.getOrDefault("key")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "key", valid_580033
  var valid_580034 = query.getOrDefault("prettyPrint")
  valid_580034 = validateParameter(valid_580034, JBool, required = false,
                                 default = newJBool(true))
  if valid_580034 != nil:
    section.add "prettyPrint", valid_580034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580035: Call_MirrorContactsDelete_580024; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a contact.
  ## 
  let valid = call_580035.validator(path, query, header, formData, body)
  let scheme = call_580035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580035.url(scheme.get, call_580035.host, call_580035.base,
                         call_580035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580035, url, valid)

proc call*(call_580036: Call_MirrorContactsDelete_580024; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## mirrorContactsDelete
  ## Deletes a contact.
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
  ##   id: string (required)
  ##     : The ID of the contact.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580037 = newJObject()
  var query_580038 = newJObject()
  add(query_580038, "fields", newJString(fields))
  add(query_580038, "quotaUser", newJString(quotaUser))
  add(query_580038, "alt", newJString(alt))
  add(query_580038, "oauth_token", newJString(oauthToken))
  add(query_580038, "userIp", newJString(userIp))
  add(path_580037, "id", newJString(id))
  add(query_580038, "key", newJString(key))
  add(query_580038, "prettyPrint", newJBool(prettyPrint))
  result = call_580036.call(path_580037, query_580038, nil, nil, nil)

var mirrorContactsDelete* = Call_MirrorContactsDelete_580024(
    name: "mirrorContactsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/contacts/{id}",
    validator: validate_MirrorContactsDelete_580025, base: "/mirror/v1",
    url: url_MirrorContactsDelete_580026, schemes: {Scheme.Https})
type
  Call_MirrorLocationsList_580056 = ref object of OpenApiRestCall_579408
proc url_MirrorLocationsList_580058(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_MirrorLocationsList_580057(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves a list of locations for the user.
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
  var valid_580059 = query.getOrDefault("fields")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "fields", valid_580059
  var valid_580060 = query.getOrDefault("quotaUser")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "quotaUser", valid_580060
  var valid_580061 = query.getOrDefault("alt")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = newJString("json"))
  if valid_580061 != nil:
    section.add "alt", valid_580061
  var valid_580062 = query.getOrDefault("oauth_token")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "oauth_token", valid_580062
  var valid_580063 = query.getOrDefault("userIp")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "userIp", valid_580063
  var valid_580064 = query.getOrDefault("key")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "key", valid_580064
  var valid_580065 = query.getOrDefault("prettyPrint")
  valid_580065 = validateParameter(valid_580065, JBool, required = false,
                                 default = newJBool(true))
  if valid_580065 != nil:
    section.add "prettyPrint", valid_580065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580066: Call_MirrorLocationsList_580056; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of locations for the user.
  ## 
  let valid = call_580066.validator(path, query, header, formData, body)
  let scheme = call_580066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580066.url(scheme.get, call_580066.host, call_580066.base,
                         call_580066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580066, url, valid)

proc call*(call_580067: Call_MirrorLocationsList_580056; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## mirrorLocationsList
  ## Retrieves a list of locations for the user.
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
  var query_580068 = newJObject()
  add(query_580068, "fields", newJString(fields))
  add(query_580068, "quotaUser", newJString(quotaUser))
  add(query_580068, "alt", newJString(alt))
  add(query_580068, "oauth_token", newJString(oauthToken))
  add(query_580068, "userIp", newJString(userIp))
  add(query_580068, "key", newJString(key))
  add(query_580068, "prettyPrint", newJBool(prettyPrint))
  result = call_580067.call(nil, query_580068, nil, nil, nil)

var mirrorLocationsList* = Call_MirrorLocationsList_580056(
    name: "mirrorLocationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/locations",
    validator: validate_MirrorLocationsList_580057, base: "/mirror/v1",
    url: url_MirrorLocationsList_580058, schemes: {Scheme.Https})
type
  Call_MirrorLocationsGet_580069 = ref object of OpenApiRestCall_579408
proc url_MirrorLocationsGet_580071(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorLocationsGet_580070(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets a single location by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the location or latest for the last known location.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_580072 = path.getOrDefault("id")
  valid_580072 = validateParameter(valid_580072, JString, required = true,
                                 default = nil)
  if valid_580072 != nil:
    section.add "id", valid_580072
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
  var valid_580073 = query.getOrDefault("fields")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "fields", valid_580073
  var valid_580074 = query.getOrDefault("quotaUser")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "quotaUser", valid_580074
  var valid_580075 = query.getOrDefault("alt")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = newJString("json"))
  if valid_580075 != nil:
    section.add "alt", valid_580075
  var valid_580076 = query.getOrDefault("oauth_token")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "oauth_token", valid_580076
  var valid_580077 = query.getOrDefault("userIp")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "userIp", valid_580077
  var valid_580078 = query.getOrDefault("key")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "key", valid_580078
  var valid_580079 = query.getOrDefault("prettyPrint")
  valid_580079 = validateParameter(valid_580079, JBool, required = false,
                                 default = newJBool(true))
  if valid_580079 != nil:
    section.add "prettyPrint", valid_580079
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580080: Call_MirrorLocationsGet_580069; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a single location by ID.
  ## 
  let valid = call_580080.validator(path, query, header, formData, body)
  let scheme = call_580080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580080.url(scheme.get, call_580080.host, call_580080.base,
                         call_580080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580080, url, valid)

proc call*(call_580081: Call_MirrorLocationsGet_580069; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## mirrorLocationsGet
  ## Gets a single location by ID.
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
  ##   id: string (required)
  ##     : The ID of the location or latest for the last known location.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580082 = newJObject()
  var query_580083 = newJObject()
  add(query_580083, "fields", newJString(fields))
  add(query_580083, "quotaUser", newJString(quotaUser))
  add(query_580083, "alt", newJString(alt))
  add(query_580083, "oauth_token", newJString(oauthToken))
  add(query_580083, "userIp", newJString(userIp))
  add(path_580082, "id", newJString(id))
  add(query_580083, "key", newJString(key))
  add(query_580083, "prettyPrint", newJBool(prettyPrint))
  result = call_580081.call(path_580082, query_580083, nil, nil, nil)

var mirrorLocationsGet* = Call_MirrorLocationsGet_580069(
    name: "mirrorLocationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/locations/{id}",
    validator: validate_MirrorLocationsGet_580070, base: "/mirror/v1",
    url: url_MirrorLocationsGet_580071, schemes: {Scheme.Https})
type
  Call_MirrorSettingsGet_580084 = ref object of OpenApiRestCall_579408
proc url_MirrorSettingsGet_580086(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/settings/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorSettingsGet_580085(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a single setting by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the setting. The following IDs are valid: 
  ## - locale - The key to the user’s language/locale (BCP 47 identifier) that Glassware should use to render localized content. 
  ## - timezone - The key to the user’s current time zone region as defined in the tz database. Example: America/Los_Angeles.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_580087 = path.getOrDefault("id")
  valid_580087 = validateParameter(valid_580087, JString, required = true,
                                 default = nil)
  if valid_580087 != nil:
    section.add "id", valid_580087
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
  var valid_580088 = query.getOrDefault("fields")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "fields", valid_580088
  var valid_580089 = query.getOrDefault("quotaUser")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "quotaUser", valid_580089
  var valid_580090 = query.getOrDefault("alt")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = newJString("json"))
  if valid_580090 != nil:
    section.add "alt", valid_580090
  var valid_580091 = query.getOrDefault("oauth_token")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "oauth_token", valid_580091
  var valid_580092 = query.getOrDefault("userIp")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "userIp", valid_580092
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580095: Call_MirrorSettingsGet_580084; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a single setting by ID.
  ## 
  let valid = call_580095.validator(path, query, header, formData, body)
  let scheme = call_580095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580095.url(scheme.get, call_580095.host, call_580095.base,
                         call_580095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580095, url, valid)

proc call*(call_580096: Call_MirrorSettingsGet_580084; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## mirrorSettingsGet
  ## Gets a single setting by ID.
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
  ##   id: string (required)
  ##     : The ID of the setting. The following IDs are valid: 
  ## - locale - The key to the user’s language/locale (BCP 47 identifier) that Glassware should use to render localized content. 
  ## - timezone - The key to the user’s current time zone region as defined in the tz database. Example: America/Los_Angeles.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580097 = newJObject()
  var query_580098 = newJObject()
  add(query_580098, "fields", newJString(fields))
  add(query_580098, "quotaUser", newJString(quotaUser))
  add(query_580098, "alt", newJString(alt))
  add(query_580098, "oauth_token", newJString(oauthToken))
  add(query_580098, "userIp", newJString(userIp))
  add(path_580097, "id", newJString(id))
  add(query_580098, "key", newJString(key))
  add(query_580098, "prettyPrint", newJBool(prettyPrint))
  result = call_580096.call(path_580097, query_580098, nil, nil, nil)

var mirrorSettingsGet* = Call_MirrorSettingsGet_580084(name: "mirrorSettingsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/settings/{id}",
    validator: validate_MirrorSettingsGet_580085, base: "/mirror/v1",
    url: url_MirrorSettingsGet_580086, schemes: {Scheme.Https})
type
  Call_MirrorSubscriptionsInsert_580112 = ref object of OpenApiRestCall_579408
proc url_MirrorSubscriptionsInsert_580114(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_MirrorSubscriptionsInsert_580113(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new subscription.
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
  var valid_580115 = query.getOrDefault("fields")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "fields", valid_580115
  var valid_580116 = query.getOrDefault("quotaUser")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "quotaUser", valid_580116
  var valid_580117 = query.getOrDefault("alt")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = newJString("json"))
  if valid_580117 != nil:
    section.add "alt", valid_580117
  var valid_580118 = query.getOrDefault("oauth_token")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "oauth_token", valid_580118
  var valid_580119 = query.getOrDefault("userIp")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "userIp", valid_580119
  var valid_580120 = query.getOrDefault("key")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "key", valid_580120
  var valid_580121 = query.getOrDefault("prettyPrint")
  valid_580121 = validateParameter(valid_580121, JBool, required = false,
                                 default = newJBool(true))
  if valid_580121 != nil:
    section.add "prettyPrint", valid_580121
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

proc call*(call_580123: Call_MirrorSubscriptionsInsert_580112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new subscription.
  ## 
  let valid = call_580123.validator(path, query, header, formData, body)
  let scheme = call_580123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580123.url(scheme.get, call_580123.host, call_580123.base,
                         call_580123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580123, url, valid)

proc call*(call_580124: Call_MirrorSubscriptionsInsert_580112; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## mirrorSubscriptionsInsert
  ## Creates a new subscription.
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
  var query_580125 = newJObject()
  var body_580126 = newJObject()
  add(query_580125, "fields", newJString(fields))
  add(query_580125, "quotaUser", newJString(quotaUser))
  add(query_580125, "alt", newJString(alt))
  add(query_580125, "oauth_token", newJString(oauthToken))
  add(query_580125, "userIp", newJString(userIp))
  add(query_580125, "key", newJString(key))
  if body != nil:
    body_580126 = body
  add(query_580125, "prettyPrint", newJBool(prettyPrint))
  result = call_580124.call(nil, query_580125, nil, nil, body_580126)

var mirrorSubscriptionsInsert* = Call_MirrorSubscriptionsInsert_580112(
    name: "mirrorSubscriptionsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/subscriptions",
    validator: validate_MirrorSubscriptionsInsert_580113, base: "/mirror/v1",
    url: url_MirrorSubscriptionsInsert_580114, schemes: {Scheme.Https})
type
  Call_MirrorSubscriptionsList_580099 = ref object of OpenApiRestCall_579408
proc url_MirrorSubscriptionsList_580101(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_MirrorSubscriptionsList_580100(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of subscriptions for the authenticated user and service.
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
  var valid_580102 = query.getOrDefault("fields")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "fields", valid_580102
  var valid_580103 = query.getOrDefault("quotaUser")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "quotaUser", valid_580103
  var valid_580104 = query.getOrDefault("alt")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = newJString("json"))
  if valid_580104 != nil:
    section.add "alt", valid_580104
  var valid_580105 = query.getOrDefault("oauth_token")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "oauth_token", valid_580105
  var valid_580106 = query.getOrDefault("userIp")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "userIp", valid_580106
  var valid_580107 = query.getOrDefault("key")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "key", valid_580107
  var valid_580108 = query.getOrDefault("prettyPrint")
  valid_580108 = validateParameter(valid_580108, JBool, required = false,
                                 default = newJBool(true))
  if valid_580108 != nil:
    section.add "prettyPrint", valid_580108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580109: Call_MirrorSubscriptionsList_580099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of subscriptions for the authenticated user and service.
  ## 
  let valid = call_580109.validator(path, query, header, formData, body)
  let scheme = call_580109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580109.url(scheme.get, call_580109.host, call_580109.base,
                         call_580109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580109, url, valid)

proc call*(call_580110: Call_MirrorSubscriptionsList_580099; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## mirrorSubscriptionsList
  ## Retrieves a list of subscriptions for the authenticated user and service.
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
  var query_580111 = newJObject()
  add(query_580111, "fields", newJString(fields))
  add(query_580111, "quotaUser", newJString(quotaUser))
  add(query_580111, "alt", newJString(alt))
  add(query_580111, "oauth_token", newJString(oauthToken))
  add(query_580111, "userIp", newJString(userIp))
  add(query_580111, "key", newJString(key))
  add(query_580111, "prettyPrint", newJBool(prettyPrint))
  result = call_580110.call(nil, query_580111, nil, nil, nil)

var mirrorSubscriptionsList* = Call_MirrorSubscriptionsList_580099(
    name: "mirrorSubscriptionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/subscriptions",
    validator: validate_MirrorSubscriptionsList_580100, base: "/mirror/v1",
    url: url_MirrorSubscriptionsList_580101, schemes: {Scheme.Https})
type
  Call_MirrorSubscriptionsUpdate_580127 = ref object of OpenApiRestCall_579408
proc url_MirrorSubscriptionsUpdate_580129(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorSubscriptionsUpdate_580128(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing subscription in place.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_580130 = path.getOrDefault("id")
  valid_580130 = validateParameter(valid_580130, JString, required = true,
                                 default = nil)
  if valid_580130 != nil:
    section.add "id", valid_580130
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
  var valid_580131 = query.getOrDefault("fields")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "fields", valid_580131
  var valid_580132 = query.getOrDefault("quotaUser")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "quotaUser", valid_580132
  var valid_580133 = query.getOrDefault("alt")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = newJString("json"))
  if valid_580133 != nil:
    section.add "alt", valid_580133
  var valid_580134 = query.getOrDefault("oauth_token")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "oauth_token", valid_580134
  var valid_580135 = query.getOrDefault("userIp")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "userIp", valid_580135
  var valid_580136 = query.getOrDefault("key")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "key", valid_580136
  var valid_580137 = query.getOrDefault("prettyPrint")
  valid_580137 = validateParameter(valid_580137, JBool, required = false,
                                 default = newJBool(true))
  if valid_580137 != nil:
    section.add "prettyPrint", valid_580137
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

proc call*(call_580139: Call_MirrorSubscriptionsUpdate_580127; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing subscription in place.
  ## 
  let valid = call_580139.validator(path, query, header, formData, body)
  let scheme = call_580139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580139.url(scheme.get, call_580139.host, call_580139.base,
                         call_580139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580139, url, valid)

proc call*(call_580140: Call_MirrorSubscriptionsUpdate_580127; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## mirrorSubscriptionsUpdate
  ## Updates an existing subscription in place.
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
  ##   id: string (required)
  ##     : The ID of the subscription.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580141 = newJObject()
  var query_580142 = newJObject()
  var body_580143 = newJObject()
  add(query_580142, "fields", newJString(fields))
  add(query_580142, "quotaUser", newJString(quotaUser))
  add(query_580142, "alt", newJString(alt))
  add(query_580142, "oauth_token", newJString(oauthToken))
  add(query_580142, "userIp", newJString(userIp))
  add(path_580141, "id", newJString(id))
  add(query_580142, "key", newJString(key))
  if body != nil:
    body_580143 = body
  add(query_580142, "prettyPrint", newJBool(prettyPrint))
  result = call_580140.call(path_580141, query_580142, nil, nil, body_580143)

var mirrorSubscriptionsUpdate* = Call_MirrorSubscriptionsUpdate_580127(
    name: "mirrorSubscriptionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/subscriptions/{id}",
    validator: validate_MirrorSubscriptionsUpdate_580128, base: "/mirror/v1",
    url: url_MirrorSubscriptionsUpdate_580129, schemes: {Scheme.Https})
type
  Call_MirrorSubscriptionsDelete_580144 = ref object of OpenApiRestCall_579408
proc url_MirrorSubscriptionsDelete_580146(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorSubscriptionsDelete_580145(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_580147 = path.getOrDefault("id")
  valid_580147 = validateParameter(valid_580147, JString, required = true,
                                 default = nil)
  if valid_580147 != nil:
    section.add "id", valid_580147
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
  var valid_580148 = query.getOrDefault("fields")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "fields", valid_580148
  var valid_580149 = query.getOrDefault("quotaUser")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "quotaUser", valid_580149
  var valid_580150 = query.getOrDefault("alt")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = newJString("json"))
  if valid_580150 != nil:
    section.add "alt", valid_580150
  var valid_580151 = query.getOrDefault("oauth_token")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "oauth_token", valid_580151
  var valid_580152 = query.getOrDefault("userIp")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "userIp", valid_580152
  var valid_580153 = query.getOrDefault("key")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "key", valid_580153
  var valid_580154 = query.getOrDefault("prettyPrint")
  valid_580154 = validateParameter(valid_580154, JBool, required = false,
                                 default = newJBool(true))
  if valid_580154 != nil:
    section.add "prettyPrint", valid_580154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580155: Call_MirrorSubscriptionsDelete_580144; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a subscription.
  ## 
  let valid = call_580155.validator(path, query, header, formData, body)
  let scheme = call_580155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580155.url(scheme.get, call_580155.host, call_580155.base,
                         call_580155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580155, url, valid)

proc call*(call_580156: Call_MirrorSubscriptionsDelete_580144; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## mirrorSubscriptionsDelete
  ## Deletes a subscription.
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
  ##   id: string (required)
  ##     : The ID of the subscription.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580157 = newJObject()
  var query_580158 = newJObject()
  add(query_580158, "fields", newJString(fields))
  add(query_580158, "quotaUser", newJString(quotaUser))
  add(query_580158, "alt", newJString(alt))
  add(query_580158, "oauth_token", newJString(oauthToken))
  add(query_580158, "userIp", newJString(userIp))
  add(path_580157, "id", newJString(id))
  add(query_580158, "key", newJString(key))
  add(query_580158, "prettyPrint", newJBool(prettyPrint))
  result = call_580156.call(path_580157, query_580158, nil, nil, nil)

var mirrorSubscriptionsDelete* = Call_MirrorSubscriptionsDelete_580144(
    name: "mirrorSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/subscriptions/{id}",
    validator: validate_MirrorSubscriptionsDelete_580145, base: "/mirror/v1",
    url: url_MirrorSubscriptionsDelete_580146, schemes: {Scheme.Https})
type
  Call_MirrorTimelineInsert_580179 = ref object of OpenApiRestCall_579408
proc url_MirrorTimelineInsert_580181(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_MirrorTimelineInsert_580180(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts a new item into the timeline.
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
  var valid_580182 = query.getOrDefault("fields")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "fields", valid_580182
  var valid_580183 = query.getOrDefault("quotaUser")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "quotaUser", valid_580183
  var valid_580184 = query.getOrDefault("alt")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = newJString("json"))
  if valid_580184 != nil:
    section.add "alt", valid_580184
  var valid_580185 = query.getOrDefault("oauth_token")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "oauth_token", valid_580185
  var valid_580186 = query.getOrDefault("userIp")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "userIp", valid_580186
  var valid_580187 = query.getOrDefault("key")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "key", valid_580187
  var valid_580188 = query.getOrDefault("prettyPrint")
  valid_580188 = validateParameter(valid_580188, JBool, required = false,
                                 default = newJBool(true))
  if valid_580188 != nil:
    section.add "prettyPrint", valid_580188
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

proc call*(call_580190: Call_MirrorTimelineInsert_580179; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a new item into the timeline.
  ## 
  let valid = call_580190.validator(path, query, header, formData, body)
  let scheme = call_580190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580190.url(scheme.get, call_580190.host, call_580190.base,
                         call_580190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580190, url, valid)

proc call*(call_580191: Call_MirrorTimelineInsert_580179; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## mirrorTimelineInsert
  ## Inserts a new item into the timeline.
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
  var query_580192 = newJObject()
  var body_580193 = newJObject()
  add(query_580192, "fields", newJString(fields))
  add(query_580192, "quotaUser", newJString(quotaUser))
  add(query_580192, "alt", newJString(alt))
  add(query_580192, "oauth_token", newJString(oauthToken))
  add(query_580192, "userIp", newJString(userIp))
  add(query_580192, "key", newJString(key))
  if body != nil:
    body_580193 = body
  add(query_580192, "prettyPrint", newJBool(prettyPrint))
  result = call_580191.call(nil, query_580192, nil, nil, body_580193)

var mirrorTimelineInsert* = Call_MirrorTimelineInsert_580179(
    name: "mirrorTimelineInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/timeline",
    validator: validate_MirrorTimelineInsert_580180, base: "/mirror/v1",
    url: url_MirrorTimelineInsert_580181, schemes: {Scheme.Https})
type
  Call_MirrorTimelineList_580159 = ref object of OpenApiRestCall_579408
proc url_MirrorTimelineList_580161(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_MirrorTimelineList_580160(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves a list of timeline items for the authenticated user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token for the page of results to return.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   bundleId: JString
  ##           : If provided, only items with the given bundleId will be returned.
  ##   maxResults: JInt
  ##             : The maximum number of items to include in the response, used for paging.
  ##   orderBy: JString
  ##          : Controls the order in which timeline items are returned.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeDeleted: JBool
  ##                 : If true, tombstone records for deleted items will be returned.
  ##   pinnedOnly: JBool
  ##             : If true, only pinned items will be returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   sourceItemId: JString
  ##               : If provided, only items with the given sourceItemId will be returned.
  section = newJObject()
  var valid_580162 = query.getOrDefault("fields")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "fields", valid_580162
  var valid_580163 = query.getOrDefault("pageToken")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "pageToken", valid_580163
  var valid_580164 = query.getOrDefault("quotaUser")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "quotaUser", valid_580164
  var valid_580165 = query.getOrDefault("alt")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = newJString("json"))
  if valid_580165 != nil:
    section.add "alt", valid_580165
  var valid_580166 = query.getOrDefault("oauth_token")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "oauth_token", valid_580166
  var valid_580167 = query.getOrDefault("userIp")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "userIp", valid_580167
  var valid_580168 = query.getOrDefault("bundleId")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "bundleId", valid_580168
  var valid_580169 = query.getOrDefault("maxResults")
  valid_580169 = validateParameter(valid_580169, JInt, required = false, default = nil)
  if valid_580169 != nil:
    section.add "maxResults", valid_580169
  var valid_580170 = query.getOrDefault("orderBy")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = newJString("displayTime"))
  if valid_580170 != nil:
    section.add "orderBy", valid_580170
  var valid_580171 = query.getOrDefault("key")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "key", valid_580171
  var valid_580172 = query.getOrDefault("includeDeleted")
  valid_580172 = validateParameter(valid_580172, JBool, required = false, default = nil)
  if valid_580172 != nil:
    section.add "includeDeleted", valid_580172
  var valid_580173 = query.getOrDefault("pinnedOnly")
  valid_580173 = validateParameter(valid_580173, JBool, required = false, default = nil)
  if valid_580173 != nil:
    section.add "pinnedOnly", valid_580173
  var valid_580174 = query.getOrDefault("prettyPrint")
  valid_580174 = validateParameter(valid_580174, JBool, required = false,
                                 default = newJBool(true))
  if valid_580174 != nil:
    section.add "prettyPrint", valid_580174
  var valid_580175 = query.getOrDefault("sourceItemId")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "sourceItemId", valid_580175
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580176: Call_MirrorTimelineList_580159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of timeline items for the authenticated user.
  ## 
  let valid = call_580176.validator(path, query, header, formData, body)
  let scheme = call_580176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580176.url(scheme.get, call_580176.host, call_580176.base,
                         call_580176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580176, url, valid)

proc call*(call_580177: Call_MirrorTimelineList_580159; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; bundleId: string = "";
          maxResults: int = 0; orderBy: string = "displayTime"; key: string = "";
          includeDeleted: bool = false; pinnedOnly: bool = false;
          prettyPrint: bool = true; sourceItemId: string = ""): Recallable =
  ## mirrorTimelineList
  ## Retrieves a list of timeline items for the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token for the page of results to return.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   bundleId: string
  ##           : If provided, only items with the given bundleId will be returned.
  ##   maxResults: int
  ##             : The maximum number of items to include in the response, used for paging.
  ##   orderBy: string
  ##          : Controls the order in which timeline items are returned.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeDeleted: bool
  ##                 : If true, tombstone records for deleted items will be returned.
  ##   pinnedOnly: bool
  ##             : If true, only pinned items will be returned.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   sourceItemId: string
  ##               : If provided, only items with the given sourceItemId will be returned.
  var query_580178 = newJObject()
  add(query_580178, "fields", newJString(fields))
  add(query_580178, "pageToken", newJString(pageToken))
  add(query_580178, "quotaUser", newJString(quotaUser))
  add(query_580178, "alt", newJString(alt))
  add(query_580178, "oauth_token", newJString(oauthToken))
  add(query_580178, "userIp", newJString(userIp))
  add(query_580178, "bundleId", newJString(bundleId))
  add(query_580178, "maxResults", newJInt(maxResults))
  add(query_580178, "orderBy", newJString(orderBy))
  add(query_580178, "key", newJString(key))
  add(query_580178, "includeDeleted", newJBool(includeDeleted))
  add(query_580178, "pinnedOnly", newJBool(pinnedOnly))
  add(query_580178, "prettyPrint", newJBool(prettyPrint))
  add(query_580178, "sourceItemId", newJString(sourceItemId))
  result = call_580177.call(nil, query_580178, nil, nil, nil)

var mirrorTimelineList* = Call_MirrorTimelineList_580159(
    name: "mirrorTimelineList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/timeline",
    validator: validate_MirrorTimelineList_580160, base: "/mirror/v1",
    url: url_MirrorTimelineList_580161, schemes: {Scheme.Https})
type
  Call_MirrorTimelineUpdate_580209 = ref object of OpenApiRestCall_579408
proc url_MirrorTimelineUpdate_580211(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/timeline/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorTimelineUpdate_580210(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a timeline item in place.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the timeline item.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_580212 = path.getOrDefault("id")
  valid_580212 = validateParameter(valid_580212, JString, required = true,
                                 default = nil)
  if valid_580212 != nil:
    section.add "id", valid_580212
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
  var valid_580213 = query.getOrDefault("fields")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "fields", valid_580213
  var valid_580214 = query.getOrDefault("quotaUser")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "quotaUser", valid_580214
  var valid_580215 = query.getOrDefault("alt")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = newJString("json"))
  if valid_580215 != nil:
    section.add "alt", valid_580215
  var valid_580216 = query.getOrDefault("oauth_token")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "oauth_token", valid_580216
  var valid_580217 = query.getOrDefault("userIp")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "userIp", valid_580217
  var valid_580218 = query.getOrDefault("key")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "key", valid_580218
  var valid_580219 = query.getOrDefault("prettyPrint")
  valid_580219 = validateParameter(valid_580219, JBool, required = false,
                                 default = newJBool(true))
  if valid_580219 != nil:
    section.add "prettyPrint", valid_580219
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

proc call*(call_580221: Call_MirrorTimelineUpdate_580209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a timeline item in place.
  ## 
  let valid = call_580221.validator(path, query, header, formData, body)
  let scheme = call_580221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580221.url(scheme.get, call_580221.host, call_580221.base,
                         call_580221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580221, url, valid)

proc call*(call_580222: Call_MirrorTimelineUpdate_580209; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## mirrorTimelineUpdate
  ## Updates a timeline item in place.
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
  ##   id: string (required)
  ##     : The ID of the timeline item.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580223 = newJObject()
  var query_580224 = newJObject()
  var body_580225 = newJObject()
  add(query_580224, "fields", newJString(fields))
  add(query_580224, "quotaUser", newJString(quotaUser))
  add(query_580224, "alt", newJString(alt))
  add(query_580224, "oauth_token", newJString(oauthToken))
  add(query_580224, "userIp", newJString(userIp))
  add(path_580223, "id", newJString(id))
  add(query_580224, "key", newJString(key))
  if body != nil:
    body_580225 = body
  add(query_580224, "prettyPrint", newJBool(prettyPrint))
  result = call_580222.call(path_580223, query_580224, nil, nil, body_580225)

var mirrorTimelineUpdate* = Call_MirrorTimelineUpdate_580209(
    name: "mirrorTimelineUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/timeline/{id}",
    validator: validate_MirrorTimelineUpdate_580210, base: "/mirror/v1",
    url: url_MirrorTimelineUpdate_580211, schemes: {Scheme.Https})
type
  Call_MirrorTimelineGet_580194 = ref object of OpenApiRestCall_579408
proc url_MirrorTimelineGet_580196(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/timeline/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorTimelineGet_580195(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a single timeline item by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the timeline item.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_580197 = path.getOrDefault("id")
  valid_580197 = validateParameter(valid_580197, JString, required = true,
                                 default = nil)
  if valid_580197 != nil:
    section.add "id", valid_580197
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
  var valid_580198 = query.getOrDefault("fields")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "fields", valid_580198
  var valid_580199 = query.getOrDefault("quotaUser")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "quotaUser", valid_580199
  var valid_580200 = query.getOrDefault("alt")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = newJString("json"))
  if valid_580200 != nil:
    section.add "alt", valid_580200
  var valid_580201 = query.getOrDefault("oauth_token")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "oauth_token", valid_580201
  var valid_580202 = query.getOrDefault("userIp")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "userIp", valid_580202
  var valid_580203 = query.getOrDefault("key")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "key", valid_580203
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

proc call*(call_580205: Call_MirrorTimelineGet_580194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a single timeline item by ID.
  ## 
  let valid = call_580205.validator(path, query, header, formData, body)
  let scheme = call_580205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580205.url(scheme.get, call_580205.host, call_580205.base,
                         call_580205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580205, url, valid)

proc call*(call_580206: Call_MirrorTimelineGet_580194; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## mirrorTimelineGet
  ## Gets a single timeline item by ID.
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
  ##   id: string (required)
  ##     : The ID of the timeline item.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580207 = newJObject()
  var query_580208 = newJObject()
  add(query_580208, "fields", newJString(fields))
  add(query_580208, "quotaUser", newJString(quotaUser))
  add(query_580208, "alt", newJString(alt))
  add(query_580208, "oauth_token", newJString(oauthToken))
  add(query_580208, "userIp", newJString(userIp))
  add(path_580207, "id", newJString(id))
  add(query_580208, "key", newJString(key))
  add(query_580208, "prettyPrint", newJBool(prettyPrint))
  result = call_580206.call(path_580207, query_580208, nil, nil, nil)

var mirrorTimelineGet* = Call_MirrorTimelineGet_580194(name: "mirrorTimelineGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/timeline/{id}",
    validator: validate_MirrorTimelineGet_580195, base: "/mirror/v1",
    url: url_MirrorTimelineGet_580196, schemes: {Scheme.Https})
type
  Call_MirrorTimelinePatch_580241 = ref object of OpenApiRestCall_579408
proc url_MirrorTimelinePatch_580243(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/timeline/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorTimelinePatch_580242(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates a timeline item in place. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the timeline item.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_580244 = path.getOrDefault("id")
  valid_580244 = validateParameter(valid_580244, JString, required = true,
                                 default = nil)
  if valid_580244 != nil:
    section.add "id", valid_580244
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
  var valid_580245 = query.getOrDefault("fields")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "fields", valid_580245
  var valid_580246 = query.getOrDefault("quotaUser")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "quotaUser", valid_580246
  var valid_580247 = query.getOrDefault("alt")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = newJString("json"))
  if valid_580247 != nil:
    section.add "alt", valid_580247
  var valid_580248 = query.getOrDefault("oauth_token")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "oauth_token", valid_580248
  var valid_580249 = query.getOrDefault("userIp")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "userIp", valid_580249
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580253: Call_MirrorTimelinePatch_580241; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a timeline item in place. This method supports patch semantics.
  ## 
  let valid = call_580253.validator(path, query, header, formData, body)
  let scheme = call_580253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580253.url(scheme.get, call_580253.host, call_580253.base,
                         call_580253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580253, url, valid)

proc call*(call_580254: Call_MirrorTimelinePatch_580241; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## mirrorTimelinePatch
  ## Updates a timeline item in place. This method supports patch semantics.
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
  ##   id: string (required)
  ##     : The ID of the timeline item.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580255 = newJObject()
  var query_580256 = newJObject()
  var body_580257 = newJObject()
  add(query_580256, "fields", newJString(fields))
  add(query_580256, "quotaUser", newJString(quotaUser))
  add(query_580256, "alt", newJString(alt))
  add(query_580256, "oauth_token", newJString(oauthToken))
  add(query_580256, "userIp", newJString(userIp))
  add(path_580255, "id", newJString(id))
  add(query_580256, "key", newJString(key))
  if body != nil:
    body_580257 = body
  add(query_580256, "prettyPrint", newJBool(prettyPrint))
  result = call_580254.call(path_580255, query_580256, nil, nil, body_580257)

var mirrorTimelinePatch* = Call_MirrorTimelinePatch_580241(
    name: "mirrorTimelinePatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/timeline/{id}",
    validator: validate_MirrorTimelinePatch_580242, base: "/mirror/v1",
    url: url_MirrorTimelinePatch_580243, schemes: {Scheme.Https})
type
  Call_MirrorTimelineDelete_580226 = ref object of OpenApiRestCall_579408
proc url_MirrorTimelineDelete_580228(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/timeline/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorTimelineDelete_580227(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a timeline item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the timeline item.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_580229 = path.getOrDefault("id")
  valid_580229 = validateParameter(valid_580229, JString, required = true,
                                 default = nil)
  if valid_580229 != nil:
    section.add "id", valid_580229
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
  var valid_580230 = query.getOrDefault("fields")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "fields", valid_580230
  var valid_580231 = query.getOrDefault("quotaUser")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "quotaUser", valid_580231
  var valid_580232 = query.getOrDefault("alt")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = newJString("json"))
  if valid_580232 != nil:
    section.add "alt", valid_580232
  var valid_580233 = query.getOrDefault("oauth_token")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "oauth_token", valid_580233
  var valid_580234 = query.getOrDefault("userIp")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "userIp", valid_580234
  var valid_580235 = query.getOrDefault("key")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "key", valid_580235
  var valid_580236 = query.getOrDefault("prettyPrint")
  valid_580236 = validateParameter(valid_580236, JBool, required = false,
                                 default = newJBool(true))
  if valid_580236 != nil:
    section.add "prettyPrint", valid_580236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580237: Call_MirrorTimelineDelete_580226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a timeline item.
  ## 
  let valid = call_580237.validator(path, query, header, formData, body)
  let scheme = call_580237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580237.url(scheme.get, call_580237.host, call_580237.base,
                         call_580237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580237, url, valid)

proc call*(call_580238: Call_MirrorTimelineDelete_580226; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## mirrorTimelineDelete
  ## Deletes a timeline item.
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
  ##   id: string (required)
  ##     : The ID of the timeline item.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580239 = newJObject()
  var query_580240 = newJObject()
  add(query_580240, "fields", newJString(fields))
  add(query_580240, "quotaUser", newJString(quotaUser))
  add(query_580240, "alt", newJString(alt))
  add(query_580240, "oauth_token", newJString(oauthToken))
  add(query_580240, "userIp", newJString(userIp))
  add(path_580239, "id", newJString(id))
  add(query_580240, "key", newJString(key))
  add(query_580240, "prettyPrint", newJBool(prettyPrint))
  result = call_580238.call(path_580239, query_580240, nil, nil, nil)

var mirrorTimelineDelete* = Call_MirrorTimelineDelete_580226(
    name: "mirrorTimelineDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/timeline/{id}",
    validator: validate_MirrorTimelineDelete_580227, base: "/mirror/v1",
    url: url_MirrorTimelineDelete_580228, schemes: {Scheme.Https})
type
  Call_MirrorTimelineAttachmentsInsert_580273 = ref object of OpenApiRestCall_579408
proc url_MirrorTimelineAttachmentsInsert_580275(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "itemId" in path, "`itemId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/timeline/"),
               (kind: VariableSegment, value: "itemId"),
               (kind: ConstantSegment, value: "/attachments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorTimelineAttachmentsInsert_580274(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a new attachment to a timeline item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   itemId: JString (required)
  ##         : The ID of the timeline item the attachment belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `itemId` field"
  var valid_580276 = path.getOrDefault("itemId")
  valid_580276 = validateParameter(valid_580276, JString, required = true,
                                 default = nil)
  if valid_580276 != nil:
    section.add "itemId", valid_580276
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
  var valid_580277 = query.getOrDefault("fields")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "fields", valid_580277
  var valid_580278 = query.getOrDefault("quotaUser")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "quotaUser", valid_580278
  var valid_580279 = query.getOrDefault("alt")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = newJString("json"))
  if valid_580279 != nil:
    section.add "alt", valid_580279
  var valid_580280 = query.getOrDefault("oauth_token")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "oauth_token", valid_580280
  var valid_580281 = query.getOrDefault("userIp")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "userIp", valid_580281
  var valid_580282 = query.getOrDefault("key")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "key", valid_580282
  var valid_580283 = query.getOrDefault("prettyPrint")
  valid_580283 = validateParameter(valid_580283, JBool, required = false,
                                 default = newJBool(true))
  if valid_580283 != nil:
    section.add "prettyPrint", valid_580283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580284: Call_MirrorTimelineAttachmentsInsert_580273;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a new attachment to a timeline item.
  ## 
  let valid = call_580284.validator(path, query, header, formData, body)
  let scheme = call_580284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580284.url(scheme.get, call_580284.host, call_580284.base,
                         call_580284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580284, url, valid)

proc call*(call_580285: Call_MirrorTimelineAttachmentsInsert_580273;
          itemId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## mirrorTimelineAttachmentsInsert
  ## Adds a new attachment to a timeline item.
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
  ##   itemId: string (required)
  ##         : The ID of the timeline item the attachment belongs to.
  var path_580286 = newJObject()
  var query_580287 = newJObject()
  add(query_580287, "fields", newJString(fields))
  add(query_580287, "quotaUser", newJString(quotaUser))
  add(query_580287, "alt", newJString(alt))
  add(query_580287, "oauth_token", newJString(oauthToken))
  add(query_580287, "userIp", newJString(userIp))
  add(query_580287, "key", newJString(key))
  add(query_580287, "prettyPrint", newJBool(prettyPrint))
  add(path_580286, "itemId", newJString(itemId))
  result = call_580285.call(path_580286, query_580287, nil, nil, nil)

var mirrorTimelineAttachmentsInsert* = Call_MirrorTimelineAttachmentsInsert_580273(
    name: "mirrorTimelineAttachmentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/timeline/{itemId}/attachments",
    validator: validate_MirrorTimelineAttachmentsInsert_580274,
    base: "/mirror/v1", url: url_MirrorTimelineAttachmentsInsert_580275,
    schemes: {Scheme.Https})
type
  Call_MirrorTimelineAttachmentsList_580258 = ref object of OpenApiRestCall_579408
proc url_MirrorTimelineAttachmentsList_580260(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "itemId" in path, "`itemId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/timeline/"),
               (kind: VariableSegment, value: "itemId"),
               (kind: ConstantSegment, value: "/attachments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorTimelineAttachmentsList_580259(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of attachments for a timeline item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   itemId: JString (required)
  ##         : The ID of the timeline item whose attachments should be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `itemId` field"
  var valid_580261 = path.getOrDefault("itemId")
  valid_580261 = validateParameter(valid_580261, JString, required = true,
                                 default = nil)
  if valid_580261 != nil:
    section.add "itemId", valid_580261
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
  var valid_580262 = query.getOrDefault("fields")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "fields", valid_580262
  var valid_580263 = query.getOrDefault("quotaUser")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "quotaUser", valid_580263
  var valid_580264 = query.getOrDefault("alt")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = newJString("json"))
  if valid_580264 != nil:
    section.add "alt", valid_580264
  var valid_580265 = query.getOrDefault("oauth_token")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "oauth_token", valid_580265
  var valid_580266 = query.getOrDefault("userIp")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "userIp", valid_580266
  var valid_580267 = query.getOrDefault("key")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "key", valid_580267
  var valid_580268 = query.getOrDefault("prettyPrint")
  valid_580268 = validateParameter(valid_580268, JBool, required = false,
                                 default = newJBool(true))
  if valid_580268 != nil:
    section.add "prettyPrint", valid_580268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580269: Call_MirrorTimelineAttachmentsList_580258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of attachments for a timeline item.
  ## 
  let valid = call_580269.validator(path, query, header, formData, body)
  let scheme = call_580269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580269.url(scheme.get, call_580269.host, call_580269.base,
                         call_580269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580269, url, valid)

proc call*(call_580270: Call_MirrorTimelineAttachmentsList_580258; itemId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## mirrorTimelineAttachmentsList
  ## Returns a list of attachments for a timeline item.
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
  ##   itemId: string (required)
  ##         : The ID of the timeline item whose attachments should be listed.
  var path_580271 = newJObject()
  var query_580272 = newJObject()
  add(query_580272, "fields", newJString(fields))
  add(query_580272, "quotaUser", newJString(quotaUser))
  add(query_580272, "alt", newJString(alt))
  add(query_580272, "oauth_token", newJString(oauthToken))
  add(query_580272, "userIp", newJString(userIp))
  add(query_580272, "key", newJString(key))
  add(query_580272, "prettyPrint", newJBool(prettyPrint))
  add(path_580271, "itemId", newJString(itemId))
  result = call_580270.call(path_580271, query_580272, nil, nil, nil)

var mirrorTimelineAttachmentsList* = Call_MirrorTimelineAttachmentsList_580258(
    name: "mirrorTimelineAttachmentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/timeline/{itemId}/attachments",
    validator: validate_MirrorTimelineAttachmentsList_580259, base: "/mirror/v1",
    url: url_MirrorTimelineAttachmentsList_580260, schemes: {Scheme.Https})
type
  Call_MirrorTimelineAttachmentsGet_580288 = ref object of OpenApiRestCall_579408
proc url_MirrorTimelineAttachmentsGet_580290(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "itemId" in path, "`itemId` is a required path parameter"
  assert "attachmentId" in path, "`attachmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/timeline/"),
               (kind: VariableSegment, value: "itemId"),
               (kind: ConstantSegment, value: "/attachments/"),
               (kind: VariableSegment, value: "attachmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorTimelineAttachmentsGet_580289(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves an attachment on a timeline item by item ID and attachment ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   attachmentId: JString (required)
  ##               : The ID of the attachment.
  ##   itemId: JString (required)
  ##         : The ID of the timeline item the attachment belongs to.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `attachmentId` field"
  var valid_580291 = path.getOrDefault("attachmentId")
  valid_580291 = validateParameter(valid_580291, JString, required = true,
                                 default = nil)
  if valid_580291 != nil:
    section.add "attachmentId", valid_580291
  var valid_580292 = path.getOrDefault("itemId")
  valid_580292 = validateParameter(valid_580292, JString, required = true,
                                 default = nil)
  if valid_580292 != nil:
    section.add "itemId", valid_580292
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
  var valid_580293 = query.getOrDefault("fields")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "fields", valid_580293
  var valid_580294 = query.getOrDefault("quotaUser")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "quotaUser", valid_580294
  var valid_580295 = query.getOrDefault("alt")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = newJString("json"))
  if valid_580295 != nil:
    section.add "alt", valid_580295
  var valid_580296 = query.getOrDefault("oauth_token")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = nil)
  if valid_580296 != nil:
    section.add "oauth_token", valid_580296
  var valid_580297 = query.getOrDefault("userIp")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "userIp", valid_580297
  var valid_580298 = query.getOrDefault("key")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "key", valid_580298
  var valid_580299 = query.getOrDefault("prettyPrint")
  valid_580299 = validateParameter(valid_580299, JBool, required = false,
                                 default = newJBool(true))
  if valid_580299 != nil:
    section.add "prettyPrint", valid_580299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580300: Call_MirrorTimelineAttachmentsGet_580288; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an attachment on a timeline item by item ID and attachment ID.
  ## 
  let valid = call_580300.validator(path, query, header, formData, body)
  let scheme = call_580300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580300.url(scheme.get, call_580300.host, call_580300.base,
                         call_580300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580300, url, valid)

proc call*(call_580301: Call_MirrorTimelineAttachmentsGet_580288;
          attachmentId: string; itemId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## mirrorTimelineAttachmentsGet
  ## Retrieves an attachment on a timeline item by item ID and attachment ID.
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
  ##   attachmentId: string (required)
  ##               : The ID of the attachment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   itemId: string (required)
  ##         : The ID of the timeline item the attachment belongs to.
  var path_580302 = newJObject()
  var query_580303 = newJObject()
  add(query_580303, "fields", newJString(fields))
  add(query_580303, "quotaUser", newJString(quotaUser))
  add(query_580303, "alt", newJString(alt))
  add(query_580303, "oauth_token", newJString(oauthToken))
  add(query_580303, "userIp", newJString(userIp))
  add(path_580302, "attachmentId", newJString(attachmentId))
  add(query_580303, "key", newJString(key))
  add(query_580303, "prettyPrint", newJBool(prettyPrint))
  add(path_580302, "itemId", newJString(itemId))
  result = call_580301.call(path_580302, query_580303, nil, nil, nil)

var mirrorTimelineAttachmentsGet* = Call_MirrorTimelineAttachmentsGet_580288(
    name: "mirrorTimelineAttachmentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/timeline/{itemId}/attachments/{attachmentId}",
    validator: validate_MirrorTimelineAttachmentsGet_580289, base: "/mirror/v1",
    url: url_MirrorTimelineAttachmentsGet_580290, schemes: {Scheme.Https})
type
  Call_MirrorTimelineAttachmentsDelete_580304 = ref object of OpenApiRestCall_579408
proc url_MirrorTimelineAttachmentsDelete_580306(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "itemId" in path, "`itemId` is a required path parameter"
  assert "attachmentId" in path, "`attachmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/timeline/"),
               (kind: VariableSegment, value: "itemId"),
               (kind: ConstantSegment, value: "/attachments/"),
               (kind: VariableSegment, value: "attachmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorTimelineAttachmentsDelete_580305(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an attachment from a timeline item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   attachmentId: JString (required)
  ##               : The ID of the attachment.
  ##   itemId: JString (required)
  ##         : The ID of the timeline item the attachment belongs to.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `attachmentId` field"
  var valid_580307 = path.getOrDefault("attachmentId")
  valid_580307 = validateParameter(valid_580307, JString, required = true,
                                 default = nil)
  if valid_580307 != nil:
    section.add "attachmentId", valid_580307
  var valid_580308 = path.getOrDefault("itemId")
  valid_580308 = validateParameter(valid_580308, JString, required = true,
                                 default = nil)
  if valid_580308 != nil:
    section.add "itemId", valid_580308
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
  var valid_580309 = query.getOrDefault("fields")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "fields", valid_580309
  var valid_580310 = query.getOrDefault("quotaUser")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = nil)
  if valid_580310 != nil:
    section.add "quotaUser", valid_580310
  var valid_580311 = query.getOrDefault("alt")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = newJString("json"))
  if valid_580311 != nil:
    section.add "alt", valid_580311
  var valid_580312 = query.getOrDefault("oauth_token")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = nil)
  if valid_580312 != nil:
    section.add "oauth_token", valid_580312
  var valid_580313 = query.getOrDefault("userIp")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "userIp", valid_580313
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

proc call*(call_580316: Call_MirrorTimelineAttachmentsDelete_580304;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an attachment from a timeline item.
  ## 
  let valid = call_580316.validator(path, query, header, formData, body)
  let scheme = call_580316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580316.url(scheme.get, call_580316.host, call_580316.base,
                         call_580316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580316, url, valid)

proc call*(call_580317: Call_MirrorTimelineAttachmentsDelete_580304;
          attachmentId: string; itemId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## mirrorTimelineAttachmentsDelete
  ## Deletes an attachment from a timeline item.
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
  ##   attachmentId: string (required)
  ##               : The ID of the attachment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   itemId: string (required)
  ##         : The ID of the timeline item the attachment belongs to.
  var path_580318 = newJObject()
  var query_580319 = newJObject()
  add(query_580319, "fields", newJString(fields))
  add(query_580319, "quotaUser", newJString(quotaUser))
  add(query_580319, "alt", newJString(alt))
  add(query_580319, "oauth_token", newJString(oauthToken))
  add(query_580319, "userIp", newJString(userIp))
  add(path_580318, "attachmentId", newJString(attachmentId))
  add(query_580319, "key", newJString(key))
  add(query_580319, "prettyPrint", newJBool(prettyPrint))
  add(path_580318, "itemId", newJString(itemId))
  result = call_580317.call(path_580318, query_580319, nil, nil, nil)

var mirrorTimelineAttachmentsDelete* = Call_MirrorTimelineAttachmentsDelete_580304(
    name: "mirrorTimelineAttachmentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/timeline/{itemId}/attachments/{attachmentId}",
    validator: validate_MirrorTimelineAttachmentsDelete_580305,
    base: "/mirror/v1", url: url_MirrorTimelineAttachmentsDelete_580306,
    schemes: {Scheme.Https})
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
