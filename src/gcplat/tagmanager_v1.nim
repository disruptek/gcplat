
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Tag Manager
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Accesses Tag Manager accounts and containers.
## 
## https://developers.google.com/tag-manager/api/v1/
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
  gcpServiceName = "tagmanager"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_TagmanagerAccountsList_579676 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsList_579678(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_TagmanagerAccountsList_579677(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all GTM Accounts that a user has access to.
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
  var valid_579790 = query.getOrDefault("fields")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = nil)
  if valid_579790 != nil:
    section.add "fields", valid_579790
  var valid_579791 = query.getOrDefault("quotaUser")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "quotaUser", valid_579791
  var valid_579805 = query.getOrDefault("alt")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = newJString("json"))
  if valid_579805 != nil:
    section.add "alt", valid_579805
  var valid_579806 = query.getOrDefault("oauth_token")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "oauth_token", valid_579806
  var valid_579807 = query.getOrDefault("userIp")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "userIp", valid_579807
  var valid_579808 = query.getOrDefault("key")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "key", valid_579808
  var valid_579809 = query.getOrDefault("prettyPrint")
  valid_579809 = validateParameter(valid_579809, JBool, required = false,
                                 default = newJBool(true))
  if valid_579809 != nil:
    section.add "prettyPrint", valid_579809
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579832: Call_TagmanagerAccountsList_579676; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all GTM Accounts that a user has access to.
  ## 
  let valid = call_579832.validator(path, query, header, formData, body)
  let scheme = call_579832.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579832.url(scheme.get, call_579832.host, call_579832.base,
                         call_579832.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579832, url, valid)

proc call*(call_579903: Call_TagmanagerAccountsList_579676; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsList
  ## Lists all GTM Accounts that a user has access to.
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
  var query_579904 = newJObject()
  add(query_579904, "fields", newJString(fields))
  add(query_579904, "quotaUser", newJString(quotaUser))
  add(query_579904, "alt", newJString(alt))
  add(query_579904, "oauth_token", newJString(oauthToken))
  add(query_579904, "userIp", newJString(userIp))
  add(query_579904, "key", newJString(key))
  add(query_579904, "prettyPrint", newJBool(prettyPrint))
  result = call_579903.call(nil, query_579904, nil, nil, nil)

var tagmanagerAccountsList* = Call_TagmanagerAccountsList_579676(
    name: "tagmanagerAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts",
    validator: validate_TagmanagerAccountsList_579677, base: "/tagmanager/v1",
    url: url_TagmanagerAccountsList_579678, schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsUpdate_579973 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsUpdate_579975(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsUpdate_579974(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a GTM Account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_579976 = path.getOrDefault("accountId")
  valid_579976 = validateParameter(valid_579976, JString, required = true,
                                 default = nil)
  if valid_579976 != nil:
    section.add "accountId", valid_579976
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   fingerprint: JString
  ##              : When provided, this fingerprint must match the fingerprint of the account in storage.
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
  var valid_579977 = query.getOrDefault("fields")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "fields", valid_579977
  var valid_579978 = query.getOrDefault("fingerprint")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "fingerprint", valid_579978
  var valid_579979 = query.getOrDefault("quotaUser")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "quotaUser", valid_579979
  var valid_579980 = query.getOrDefault("alt")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = newJString("json"))
  if valid_579980 != nil:
    section.add "alt", valid_579980
  var valid_579981 = query.getOrDefault("oauth_token")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "oauth_token", valid_579981
  var valid_579982 = query.getOrDefault("userIp")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "userIp", valid_579982
  var valid_579983 = query.getOrDefault("key")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "key", valid_579983
  var valid_579984 = query.getOrDefault("prettyPrint")
  valid_579984 = validateParameter(valid_579984, JBool, required = false,
                                 default = newJBool(true))
  if valid_579984 != nil:
    section.add "prettyPrint", valid_579984
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

proc call*(call_579986: Call_TagmanagerAccountsUpdate_579973; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a GTM Account.
  ## 
  let valid = call_579986.validator(path, query, header, formData, body)
  let scheme = call_579986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579986.url(scheme.get, call_579986.host, call_579986.base,
                         call_579986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579986, url, valid)

proc call*(call_579987: Call_TagmanagerAccountsUpdate_579973; accountId: string;
          fields: string = ""; fingerprint: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsUpdate
  ## Updates a GTM Account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   fingerprint: string
  ##              : When provided, this fingerprint must match the fingerprint of the account in storage.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579988 = newJObject()
  var query_579989 = newJObject()
  var body_579990 = newJObject()
  add(query_579989, "fields", newJString(fields))
  add(query_579989, "fingerprint", newJString(fingerprint))
  add(query_579989, "quotaUser", newJString(quotaUser))
  add(query_579989, "alt", newJString(alt))
  add(query_579989, "oauth_token", newJString(oauthToken))
  add(path_579988, "accountId", newJString(accountId))
  add(query_579989, "userIp", newJString(userIp))
  add(query_579989, "key", newJString(key))
  if body != nil:
    body_579990 = body
  add(query_579989, "prettyPrint", newJBool(prettyPrint))
  result = call_579987.call(path_579988, query_579989, nil, nil, body_579990)

var tagmanagerAccountsUpdate* = Call_TagmanagerAccountsUpdate_579973(
    name: "tagmanagerAccountsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/accounts/{accountId}",
    validator: validate_TagmanagerAccountsUpdate_579974, base: "/tagmanager/v1",
    url: url_TagmanagerAccountsUpdate_579975, schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsGet_579944 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsGet_579946(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsGet_579945(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a GTM Account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_579961 = path.getOrDefault("accountId")
  valid_579961 = validateParameter(valid_579961, JString, required = true,
                                 default = nil)
  if valid_579961 != nil:
    section.add "accountId", valid_579961
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
  var valid_579962 = query.getOrDefault("fields")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "fields", valid_579962
  var valid_579963 = query.getOrDefault("quotaUser")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "quotaUser", valid_579963
  var valid_579964 = query.getOrDefault("alt")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = newJString("json"))
  if valid_579964 != nil:
    section.add "alt", valid_579964
  var valid_579965 = query.getOrDefault("oauth_token")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "oauth_token", valid_579965
  var valid_579966 = query.getOrDefault("userIp")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "userIp", valid_579966
  var valid_579967 = query.getOrDefault("key")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "key", valid_579967
  var valid_579968 = query.getOrDefault("prettyPrint")
  valid_579968 = validateParameter(valid_579968, JBool, required = false,
                                 default = newJBool(true))
  if valid_579968 != nil:
    section.add "prettyPrint", valid_579968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579969: Call_TagmanagerAccountsGet_579944; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a GTM Account.
  ## 
  let valid = call_579969.validator(path, query, header, formData, body)
  let scheme = call_579969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579969.url(scheme.get, call_579969.host, call_579969.base,
                         call_579969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579969, url, valid)

proc call*(call_579970: Call_TagmanagerAccountsGet_579944; accountId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsGet
  ## Gets a GTM Account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579971 = newJObject()
  var query_579972 = newJObject()
  add(query_579972, "fields", newJString(fields))
  add(query_579972, "quotaUser", newJString(quotaUser))
  add(query_579972, "alt", newJString(alt))
  add(query_579972, "oauth_token", newJString(oauthToken))
  add(path_579971, "accountId", newJString(accountId))
  add(query_579972, "userIp", newJString(userIp))
  add(query_579972, "key", newJString(key))
  add(query_579972, "prettyPrint", newJBool(prettyPrint))
  result = call_579970.call(path_579971, query_579972, nil, nil, nil)

var tagmanagerAccountsGet* = Call_TagmanagerAccountsGet_579944(
    name: "tagmanagerAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}",
    validator: validate_TagmanagerAccountsGet_579945, base: "/tagmanager/v1",
    url: url_TagmanagerAccountsGet_579946, schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersCreate_580006 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersCreate_580008(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersCreate_580007(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a Container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580009 = path.getOrDefault("accountId")
  valid_580009 = validateParameter(valid_580009, JString, required = true,
                                 default = nil)
  if valid_580009 != nil:
    section.add "accountId", valid_580009
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
  var valid_580010 = query.getOrDefault("fields")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "fields", valid_580010
  var valid_580011 = query.getOrDefault("quotaUser")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "quotaUser", valid_580011
  var valid_580012 = query.getOrDefault("alt")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = newJString("json"))
  if valid_580012 != nil:
    section.add "alt", valid_580012
  var valid_580013 = query.getOrDefault("oauth_token")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "oauth_token", valid_580013
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580018: Call_TagmanagerAccountsContainersCreate_580006;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Container.
  ## 
  let valid = call_580018.validator(path, query, header, formData, body)
  let scheme = call_580018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580018.url(scheme.get, call_580018.host, call_580018.base,
                         call_580018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580018, url, valid)

proc call*(call_580019: Call_TagmanagerAccountsContainersCreate_580006;
          accountId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersCreate
  ## Creates a Container.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580020 = newJObject()
  var query_580021 = newJObject()
  var body_580022 = newJObject()
  add(query_580021, "fields", newJString(fields))
  add(query_580021, "quotaUser", newJString(quotaUser))
  add(query_580021, "alt", newJString(alt))
  add(query_580021, "oauth_token", newJString(oauthToken))
  add(path_580020, "accountId", newJString(accountId))
  add(query_580021, "userIp", newJString(userIp))
  add(query_580021, "key", newJString(key))
  if body != nil:
    body_580022 = body
  add(query_580021, "prettyPrint", newJBool(prettyPrint))
  result = call_580019.call(path_580020, query_580021, nil, nil, body_580022)

var tagmanagerAccountsContainersCreate* = Call_TagmanagerAccountsContainersCreate_580006(
    name: "tagmanagerAccountsContainersCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers",
    validator: validate_TagmanagerAccountsContainersCreate_580007,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersCreate_580008,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersList_579991 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersList_579993(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersList_579992(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all Containers that belongs to a GTM Account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_579994 = path.getOrDefault("accountId")
  valid_579994 = validateParameter(valid_579994, JString, required = true,
                                 default = nil)
  if valid_579994 != nil:
    section.add "accountId", valid_579994
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
  var valid_579995 = query.getOrDefault("fields")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "fields", valid_579995
  var valid_579996 = query.getOrDefault("quotaUser")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "quotaUser", valid_579996
  var valid_579997 = query.getOrDefault("alt")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = newJString("json"))
  if valid_579997 != nil:
    section.add "alt", valid_579997
  var valid_579998 = query.getOrDefault("oauth_token")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "oauth_token", valid_579998
  var valid_579999 = query.getOrDefault("userIp")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "userIp", valid_579999
  var valid_580000 = query.getOrDefault("key")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "key", valid_580000
  var valid_580001 = query.getOrDefault("prettyPrint")
  valid_580001 = validateParameter(valid_580001, JBool, required = false,
                                 default = newJBool(true))
  if valid_580001 != nil:
    section.add "prettyPrint", valid_580001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580002: Call_TagmanagerAccountsContainersList_579991;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all Containers that belongs to a GTM Account.
  ## 
  let valid = call_580002.validator(path, query, header, formData, body)
  let scheme = call_580002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580002.url(scheme.get, call_580002.host, call_580002.base,
                         call_580002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580002, url, valid)

proc call*(call_580003: Call_TagmanagerAccountsContainersList_579991;
          accountId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersList
  ## Lists all Containers that belongs to a GTM Account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580004 = newJObject()
  var query_580005 = newJObject()
  add(query_580005, "fields", newJString(fields))
  add(query_580005, "quotaUser", newJString(quotaUser))
  add(query_580005, "alt", newJString(alt))
  add(query_580005, "oauth_token", newJString(oauthToken))
  add(path_580004, "accountId", newJString(accountId))
  add(query_580005, "userIp", newJString(userIp))
  add(query_580005, "key", newJString(key))
  add(query_580005, "prettyPrint", newJBool(prettyPrint))
  result = call_580003.call(path_580004, query_580005, nil, nil, nil)

var tagmanagerAccountsContainersList* = Call_TagmanagerAccountsContainersList_579991(
    name: "tagmanagerAccountsContainersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers",
    validator: validate_TagmanagerAccountsContainersList_579992,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersList_579993,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersUpdate_580039 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersUpdate_580041(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersUpdate_580040(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a Container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580042 = path.getOrDefault("containerId")
  valid_580042 = validateParameter(valid_580042, JString, required = true,
                                 default = nil)
  if valid_580042 != nil:
    section.add "containerId", valid_580042
  var valid_580043 = path.getOrDefault("accountId")
  valid_580043 = validateParameter(valid_580043, JString, required = true,
                                 default = nil)
  if valid_580043 != nil:
    section.add "accountId", valid_580043
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   fingerprint: JString
  ##              : When provided, this fingerprint must match the fingerprint of the container in storage.
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
  var valid_580044 = query.getOrDefault("fields")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "fields", valid_580044
  var valid_580045 = query.getOrDefault("fingerprint")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "fingerprint", valid_580045
  var valid_580046 = query.getOrDefault("quotaUser")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "quotaUser", valid_580046
  var valid_580047 = query.getOrDefault("alt")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = newJString("json"))
  if valid_580047 != nil:
    section.add "alt", valid_580047
  var valid_580048 = query.getOrDefault("oauth_token")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "oauth_token", valid_580048
  var valid_580049 = query.getOrDefault("userIp")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "userIp", valid_580049
  var valid_580050 = query.getOrDefault("key")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "key", valid_580050
  var valid_580051 = query.getOrDefault("prettyPrint")
  valid_580051 = validateParameter(valid_580051, JBool, required = false,
                                 default = newJBool(true))
  if valid_580051 != nil:
    section.add "prettyPrint", valid_580051
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

proc call*(call_580053: Call_TagmanagerAccountsContainersUpdate_580039;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a Container.
  ## 
  let valid = call_580053.validator(path, query, header, formData, body)
  let scheme = call_580053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580053.url(scheme.get, call_580053.host, call_580053.base,
                         call_580053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580053, url, valid)

proc call*(call_580054: Call_TagmanagerAccountsContainersUpdate_580039;
          containerId: string; accountId: string; fields: string = "";
          fingerprint: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersUpdate
  ## Updates a Container.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   fingerprint: string
  ##              : When provided, this fingerprint must match the fingerprint of the container in storage.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580055 = newJObject()
  var query_580056 = newJObject()
  var body_580057 = newJObject()
  add(path_580055, "containerId", newJString(containerId))
  add(query_580056, "fields", newJString(fields))
  add(query_580056, "fingerprint", newJString(fingerprint))
  add(query_580056, "quotaUser", newJString(quotaUser))
  add(query_580056, "alt", newJString(alt))
  add(query_580056, "oauth_token", newJString(oauthToken))
  add(path_580055, "accountId", newJString(accountId))
  add(query_580056, "userIp", newJString(userIp))
  add(query_580056, "key", newJString(key))
  if body != nil:
    body_580057 = body
  add(query_580056, "prettyPrint", newJBool(prettyPrint))
  result = call_580054.call(path_580055, query_580056, nil, nil, body_580057)

var tagmanagerAccountsContainersUpdate* = Call_TagmanagerAccountsContainersUpdate_580039(
    name: "tagmanagerAccountsContainersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}",
    validator: validate_TagmanagerAccountsContainersUpdate_580040,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersUpdate_580041,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersGet_580023 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersGet_580025(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersGet_580024(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a Container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580026 = path.getOrDefault("containerId")
  valid_580026 = validateParameter(valid_580026, JString, required = true,
                                 default = nil)
  if valid_580026 != nil:
    section.add "containerId", valid_580026
  var valid_580027 = path.getOrDefault("accountId")
  valid_580027 = validateParameter(valid_580027, JString, required = true,
                                 default = nil)
  if valid_580027 != nil:
    section.add "accountId", valid_580027
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

proc call*(call_580035: Call_TagmanagerAccountsContainersGet_580023;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a Container.
  ## 
  let valid = call_580035.validator(path, query, header, formData, body)
  let scheme = call_580035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580035.url(scheme.get, call_580035.host, call_580035.base,
                         call_580035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580035, url, valid)

proc call*(call_580036: Call_TagmanagerAccountsContainersGet_580023;
          containerId: string; accountId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersGet
  ## Gets a Container.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580037 = newJObject()
  var query_580038 = newJObject()
  add(path_580037, "containerId", newJString(containerId))
  add(query_580038, "fields", newJString(fields))
  add(query_580038, "quotaUser", newJString(quotaUser))
  add(query_580038, "alt", newJString(alt))
  add(query_580038, "oauth_token", newJString(oauthToken))
  add(path_580037, "accountId", newJString(accountId))
  add(query_580038, "userIp", newJString(userIp))
  add(query_580038, "key", newJString(key))
  add(query_580038, "prettyPrint", newJBool(prettyPrint))
  result = call_580036.call(path_580037, query_580038, nil, nil, nil)

var tagmanagerAccountsContainersGet* = Call_TagmanagerAccountsContainersGet_580023(
    name: "tagmanagerAccountsContainersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}",
    validator: validate_TagmanagerAccountsContainersGet_580024,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersGet_580025,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersDelete_580058 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersDelete_580060(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersDelete_580059(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a Container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580061 = path.getOrDefault("containerId")
  valid_580061 = validateParameter(valid_580061, JString, required = true,
                                 default = nil)
  if valid_580061 != nil:
    section.add "containerId", valid_580061
  var valid_580062 = path.getOrDefault("accountId")
  valid_580062 = validateParameter(valid_580062, JString, required = true,
                                 default = nil)
  if valid_580062 != nil:
    section.add "accountId", valid_580062
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
  var valid_580063 = query.getOrDefault("fields")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "fields", valid_580063
  var valid_580064 = query.getOrDefault("quotaUser")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "quotaUser", valid_580064
  var valid_580065 = query.getOrDefault("alt")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = newJString("json"))
  if valid_580065 != nil:
    section.add "alt", valid_580065
  var valid_580066 = query.getOrDefault("oauth_token")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "oauth_token", valid_580066
  var valid_580067 = query.getOrDefault("userIp")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "userIp", valid_580067
  var valid_580068 = query.getOrDefault("key")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "key", valid_580068
  var valid_580069 = query.getOrDefault("prettyPrint")
  valid_580069 = validateParameter(valid_580069, JBool, required = false,
                                 default = newJBool(true))
  if valid_580069 != nil:
    section.add "prettyPrint", valid_580069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580070: Call_TagmanagerAccountsContainersDelete_580058;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a Container.
  ## 
  let valid = call_580070.validator(path, query, header, formData, body)
  let scheme = call_580070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580070.url(scheme.get, call_580070.host, call_580070.base,
                         call_580070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580070, url, valid)

proc call*(call_580071: Call_TagmanagerAccountsContainersDelete_580058;
          containerId: string; accountId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersDelete
  ## Deletes a Container.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580072 = newJObject()
  var query_580073 = newJObject()
  add(path_580072, "containerId", newJString(containerId))
  add(query_580073, "fields", newJString(fields))
  add(query_580073, "quotaUser", newJString(quotaUser))
  add(query_580073, "alt", newJString(alt))
  add(query_580073, "oauth_token", newJString(oauthToken))
  add(path_580072, "accountId", newJString(accountId))
  add(query_580073, "userIp", newJString(userIp))
  add(query_580073, "key", newJString(key))
  add(query_580073, "prettyPrint", newJBool(prettyPrint))
  result = call_580071.call(path_580072, query_580073, nil, nil, nil)

var tagmanagerAccountsContainersDelete* = Call_TagmanagerAccountsContainersDelete_580058(
    name: "tagmanagerAccountsContainersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}",
    validator: validate_TagmanagerAccountsContainersDelete_580059,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersDelete_580060,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersEnvironmentsCreate_580090 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersEnvironmentsCreate_580092(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/environments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersEnvironmentsCreate_580091(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a GTM Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580093 = path.getOrDefault("containerId")
  valid_580093 = validateParameter(valid_580093, JString, required = true,
                                 default = nil)
  if valid_580093 != nil:
    section.add "containerId", valid_580093
  var valid_580094 = path.getOrDefault("accountId")
  valid_580094 = validateParameter(valid_580094, JString, required = true,
                                 default = nil)
  if valid_580094 != nil:
    section.add "accountId", valid_580094
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
  var valid_580095 = query.getOrDefault("fields")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "fields", valid_580095
  var valid_580096 = query.getOrDefault("quotaUser")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "quotaUser", valid_580096
  var valid_580097 = query.getOrDefault("alt")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = newJString("json"))
  if valid_580097 != nil:
    section.add "alt", valid_580097
  var valid_580098 = query.getOrDefault("oauth_token")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "oauth_token", valid_580098
  var valid_580099 = query.getOrDefault("userIp")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "userIp", valid_580099
  var valid_580100 = query.getOrDefault("key")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "key", valid_580100
  var valid_580101 = query.getOrDefault("prettyPrint")
  valid_580101 = validateParameter(valid_580101, JBool, required = false,
                                 default = newJBool(true))
  if valid_580101 != nil:
    section.add "prettyPrint", valid_580101
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

proc call*(call_580103: Call_TagmanagerAccountsContainersEnvironmentsCreate_580090;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a GTM Environment.
  ## 
  let valid = call_580103.validator(path, query, header, formData, body)
  let scheme = call_580103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580103.url(scheme.get, call_580103.host, call_580103.base,
                         call_580103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580103, url, valid)

proc call*(call_580104: Call_TagmanagerAccountsContainersEnvironmentsCreate_580090;
          containerId: string; accountId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersEnvironmentsCreate
  ## Creates a GTM Environment.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580105 = newJObject()
  var query_580106 = newJObject()
  var body_580107 = newJObject()
  add(path_580105, "containerId", newJString(containerId))
  add(query_580106, "fields", newJString(fields))
  add(query_580106, "quotaUser", newJString(quotaUser))
  add(query_580106, "alt", newJString(alt))
  add(query_580106, "oauth_token", newJString(oauthToken))
  add(path_580105, "accountId", newJString(accountId))
  add(query_580106, "userIp", newJString(userIp))
  add(query_580106, "key", newJString(key))
  if body != nil:
    body_580107 = body
  add(query_580106, "prettyPrint", newJBool(prettyPrint))
  result = call_580104.call(path_580105, query_580106, nil, nil, body_580107)

var tagmanagerAccountsContainersEnvironmentsCreate* = Call_TagmanagerAccountsContainersEnvironmentsCreate_580090(
    name: "tagmanagerAccountsContainersEnvironmentsCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/environments",
    validator: validate_TagmanagerAccountsContainersEnvironmentsCreate_580091,
    base: "/tagmanager/v1",
    url: url_TagmanagerAccountsContainersEnvironmentsCreate_580092,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersEnvironmentsList_580074 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersEnvironmentsList_580076(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/environments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersEnvironmentsList_580075(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all GTM Environments of a GTM Container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580077 = path.getOrDefault("containerId")
  valid_580077 = validateParameter(valid_580077, JString, required = true,
                                 default = nil)
  if valid_580077 != nil:
    section.add "containerId", valid_580077
  var valid_580078 = path.getOrDefault("accountId")
  valid_580078 = validateParameter(valid_580078, JString, required = true,
                                 default = nil)
  if valid_580078 != nil:
    section.add "accountId", valid_580078
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
  var valid_580079 = query.getOrDefault("fields")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "fields", valid_580079
  var valid_580080 = query.getOrDefault("quotaUser")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "quotaUser", valid_580080
  var valid_580081 = query.getOrDefault("alt")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = newJString("json"))
  if valid_580081 != nil:
    section.add "alt", valid_580081
  var valid_580082 = query.getOrDefault("oauth_token")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "oauth_token", valid_580082
  var valid_580083 = query.getOrDefault("userIp")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "userIp", valid_580083
  var valid_580084 = query.getOrDefault("key")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "key", valid_580084
  var valid_580085 = query.getOrDefault("prettyPrint")
  valid_580085 = validateParameter(valid_580085, JBool, required = false,
                                 default = newJBool(true))
  if valid_580085 != nil:
    section.add "prettyPrint", valid_580085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580086: Call_TagmanagerAccountsContainersEnvironmentsList_580074;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all GTM Environments of a GTM Container.
  ## 
  let valid = call_580086.validator(path, query, header, formData, body)
  let scheme = call_580086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580086.url(scheme.get, call_580086.host, call_580086.base,
                         call_580086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580086, url, valid)

proc call*(call_580087: Call_TagmanagerAccountsContainersEnvironmentsList_580074;
          containerId: string; accountId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersEnvironmentsList
  ## Lists all GTM Environments of a GTM Container.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580088 = newJObject()
  var query_580089 = newJObject()
  add(path_580088, "containerId", newJString(containerId))
  add(query_580089, "fields", newJString(fields))
  add(query_580089, "quotaUser", newJString(quotaUser))
  add(query_580089, "alt", newJString(alt))
  add(query_580089, "oauth_token", newJString(oauthToken))
  add(path_580088, "accountId", newJString(accountId))
  add(query_580089, "userIp", newJString(userIp))
  add(query_580089, "key", newJString(key))
  add(query_580089, "prettyPrint", newJBool(prettyPrint))
  result = call_580087.call(path_580088, query_580089, nil, nil, nil)

var tagmanagerAccountsContainersEnvironmentsList* = Call_TagmanagerAccountsContainersEnvironmentsList_580074(
    name: "tagmanagerAccountsContainersEnvironmentsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/environments",
    validator: validate_TagmanagerAccountsContainersEnvironmentsList_580075,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersEnvironmentsList_580076,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersEnvironmentsUpdate_580125 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersEnvironmentsUpdate_580127(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  assert "environmentId" in path, "`environmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/environments/"),
               (kind: VariableSegment, value: "environmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersEnvironmentsUpdate_580126(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates a GTM Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  ##   environmentId: JString (required)
  ##                : The GTM Environment ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580128 = path.getOrDefault("containerId")
  valid_580128 = validateParameter(valid_580128, JString, required = true,
                                 default = nil)
  if valid_580128 != nil:
    section.add "containerId", valid_580128
  var valid_580129 = path.getOrDefault("accountId")
  valid_580129 = validateParameter(valid_580129, JString, required = true,
                                 default = nil)
  if valid_580129 != nil:
    section.add "accountId", valid_580129
  var valid_580130 = path.getOrDefault("environmentId")
  valid_580130 = validateParameter(valid_580130, JString, required = true,
                                 default = nil)
  if valid_580130 != nil:
    section.add "environmentId", valid_580130
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   fingerprint: JString
  ##              : When provided, this fingerprint must match the fingerprint of the environment in storage.
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
  var valid_580132 = query.getOrDefault("fingerprint")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "fingerprint", valid_580132
  var valid_580133 = query.getOrDefault("quotaUser")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "quotaUser", valid_580133
  var valid_580134 = query.getOrDefault("alt")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = newJString("json"))
  if valid_580134 != nil:
    section.add "alt", valid_580134
  var valid_580135 = query.getOrDefault("oauth_token")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "oauth_token", valid_580135
  var valid_580136 = query.getOrDefault("userIp")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "userIp", valid_580136
  var valid_580137 = query.getOrDefault("key")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "key", valid_580137
  var valid_580138 = query.getOrDefault("prettyPrint")
  valid_580138 = validateParameter(valid_580138, JBool, required = false,
                                 default = newJBool(true))
  if valid_580138 != nil:
    section.add "prettyPrint", valid_580138
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

proc call*(call_580140: Call_TagmanagerAccountsContainersEnvironmentsUpdate_580125;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a GTM Environment.
  ## 
  let valid = call_580140.validator(path, query, header, formData, body)
  let scheme = call_580140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580140.url(scheme.get, call_580140.host, call_580140.base,
                         call_580140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580140, url, valid)

proc call*(call_580141: Call_TagmanagerAccountsContainersEnvironmentsUpdate_580125;
          containerId: string; accountId: string; environmentId: string;
          fields: string = ""; fingerprint: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersEnvironmentsUpdate
  ## Updates a GTM Environment.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   fingerprint: string
  ##              : When provided, this fingerprint must match the fingerprint of the environment in storage.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   environmentId: string (required)
  ##                : The GTM Environment ID.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580142 = newJObject()
  var query_580143 = newJObject()
  var body_580144 = newJObject()
  add(path_580142, "containerId", newJString(containerId))
  add(query_580143, "fields", newJString(fields))
  add(query_580143, "fingerprint", newJString(fingerprint))
  add(query_580143, "quotaUser", newJString(quotaUser))
  add(query_580143, "alt", newJString(alt))
  add(query_580143, "oauth_token", newJString(oauthToken))
  add(path_580142, "accountId", newJString(accountId))
  add(query_580143, "userIp", newJString(userIp))
  add(query_580143, "key", newJString(key))
  add(path_580142, "environmentId", newJString(environmentId))
  if body != nil:
    body_580144 = body
  add(query_580143, "prettyPrint", newJBool(prettyPrint))
  result = call_580141.call(path_580142, query_580143, nil, nil, body_580144)

var tagmanagerAccountsContainersEnvironmentsUpdate* = Call_TagmanagerAccountsContainersEnvironmentsUpdate_580125(
    name: "tagmanagerAccountsContainersEnvironmentsUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/environments/{environmentId}",
    validator: validate_TagmanagerAccountsContainersEnvironmentsUpdate_580126,
    base: "/tagmanager/v1",
    url: url_TagmanagerAccountsContainersEnvironmentsUpdate_580127,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersEnvironmentsGet_580108 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersEnvironmentsGet_580110(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  assert "environmentId" in path, "`environmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/environments/"),
               (kind: VariableSegment, value: "environmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersEnvironmentsGet_580109(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a GTM Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  ##   environmentId: JString (required)
  ##                : The GTM Environment ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580111 = path.getOrDefault("containerId")
  valid_580111 = validateParameter(valid_580111, JString, required = true,
                                 default = nil)
  if valid_580111 != nil:
    section.add "containerId", valid_580111
  var valid_580112 = path.getOrDefault("accountId")
  valid_580112 = validateParameter(valid_580112, JString, required = true,
                                 default = nil)
  if valid_580112 != nil:
    section.add "accountId", valid_580112
  var valid_580113 = path.getOrDefault("environmentId")
  valid_580113 = validateParameter(valid_580113, JString, required = true,
                                 default = nil)
  if valid_580113 != nil:
    section.add "environmentId", valid_580113
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
  var valid_580114 = query.getOrDefault("fields")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "fields", valid_580114
  var valid_580115 = query.getOrDefault("quotaUser")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "quotaUser", valid_580115
  var valid_580116 = query.getOrDefault("alt")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = newJString("json"))
  if valid_580116 != nil:
    section.add "alt", valid_580116
  var valid_580117 = query.getOrDefault("oauth_token")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "oauth_token", valid_580117
  var valid_580118 = query.getOrDefault("userIp")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "userIp", valid_580118
  var valid_580119 = query.getOrDefault("key")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "key", valid_580119
  var valid_580120 = query.getOrDefault("prettyPrint")
  valid_580120 = validateParameter(valid_580120, JBool, required = false,
                                 default = newJBool(true))
  if valid_580120 != nil:
    section.add "prettyPrint", valid_580120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580121: Call_TagmanagerAccountsContainersEnvironmentsGet_580108;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a GTM Environment.
  ## 
  let valid = call_580121.validator(path, query, header, formData, body)
  let scheme = call_580121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580121.url(scheme.get, call_580121.host, call_580121.base,
                         call_580121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580121, url, valid)

proc call*(call_580122: Call_TagmanagerAccountsContainersEnvironmentsGet_580108;
          containerId: string; accountId: string; environmentId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersEnvironmentsGet
  ## Gets a GTM Environment.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   environmentId: string (required)
  ##                : The GTM Environment ID.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580123 = newJObject()
  var query_580124 = newJObject()
  add(path_580123, "containerId", newJString(containerId))
  add(query_580124, "fields", newJString(fields))
  add(query_580124, "quotaUser", newJString(quotaUser))
  add(query_580124, "alt", newJString(alt))
  add(query_580124, "oauth_token", newJString(oauthToken))
  add(path_580123, "accountId", newJString(accountId))
  add(query_580124, "userIp", newJString(userIp))
  add(query_580124, "key", newJString(key))
  add(path_580123, "environmentId", newJString(environmentId))
  add(query_580124, "prettyPrint", newJBool(prettyPrint))
  result = call_580122.call(path_580123, query_580124, nil, nil, nil)

var tagmanagerAccountsContainersEnvironmentsGet* = Call_TagmanagerAccountsContainersEnvironmentsGet_580108(
    name: "tagmanagerAccountsContainersEnvironmentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/environments/{environmentId}",
    validator: validate_TagmanagerAccountsContainersEnvironmentsGet_580109,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersEnvironmentsGet_580110,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersEnvironmentsDelete_580145 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersEnvironmentsDelete_580147(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  assert "environmentId" in path, "`environmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/environments/"),
               (kind: VariableSegment, value: "environmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersEnvironmentsDelete_580146(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes a GTM Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  ##   environmentId: JString (required)
  ##                : The GTM Environment ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580148 = path.getOrDefault("containerId")
  valid_580148 = validateParameter(valid_580148, JString, required = true,
                                 default = nil)
  if valid_580148 != nil:
    section.add "containerId", valid_580148
  var valid_580149 = path.getOrDefault("accountId")
  valid_580149 = validateParameter(valid_580149, JString, required = true,
                                 default = nil)
  if valid_580149 != nil:
    section.add "accountId", valid_580149
  var valid_580150 = path.getOrDefault("environmentId")
  valid_580150 = validateParameter(valid_580150, JString, required = true,
                                 default = nil)
  if valid_580150 != nil:
    section.add "environmentId", valid_580150
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
  var valid_580151 = query.getOrDefault("fields")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "fields", valid_580151
  var valid_580152 = query.getOrDefault("quotaUser")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "quotaUser", valid_580152
  var valid_580153 = query.getOrDefault("alt")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = newJString("json"))
  if valid_580153 != nil:
    section.add "alt", valid_580153
  var valid_580154 = query.getOrDefault("oauth_token")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "oauth_token", valid_580154
  var valid_580155 = query.getOrDefault("userIp")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "userIp", valid_580155
  var valid_580156 = query.getOrDefault("key")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "key", valid_580156
  var valid_580157 = query.getOrDefault("prettyPrint")
  valid_580157 = validateParameter(valid_580157, JBool, required = false,
                                 default = newJBool(true))
  if valid_580157 != nil:
    section.add "prettyPrint", valid_580157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580158: Call_TagmanagerAccountsContainersEnvironmentsDelete_580145;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a GTM Environment.
  ## 
  let valid = call_580158.validator(path, query, header, formData, body)
  let scheme = call_580158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580158.url(scheme.get, call_580158.host, call_580158.base,
                         call_580158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580158, url, valid)

proc call*(call_580159: Call_TagmanagerAccountsContainersEnvironmentsDelete_580145;
          containerId: string; accountId: string; environmentId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersEnvironmentsDelete
  ## Deletes a GTM Environment.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   environmentId: string (required)
  ##                : The GTM Environment ID.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580160 = newJObject()
  var query_580161 = newJObject()
  add(path_580160, "containerId", newJString(containerId))
  add(query_580161, "fields", newJString(fields))
  add(query_580161, "quotaUser", newJString(quotaUser))
  add(query_580161, "alt", newJString(alt))
  add(query_580161, "oauth_token", newJString(oauthToken))
  add(path_580160, "accountId", newJString(accountId))
  add(query_580161, "userIp", newJString(userIp))
  add(query_580161, "key", newJString(key))
  add(path_580160, "environmentId", newJString(environmentId))
  add(query_580161, "prettyPrint", newJBool(prettyPrint))
  result = call_580159.call(path_580160, query_580161, nil, nil, nil)

var tagmanagerAccountsContainersEnvironmentsDelete* = Call_TagmanagerAccountsContainersEnvironmentsDelete_580145(
    name: "tagmanagerAccountsContainersEnvironmentsDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/environments/{environmentId}",
    validator: validate_TagmanagerAccountsContainersEnvironmentsDelete_580146,
    base: "/tagmanager/v1",
    url: url_TagmanagerAccountsContainersEnvironmentsDelete_580147,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersFoldersCreate_580178 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersFoldersCreate_580180(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/folders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersFoldersCreate_580179(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a GTM Folder.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580181 = path.getOrDefault("containerId")
  valid_580181 = validateParameter(valid_580181, JString, required = true,
                                 default = nil)
  if valid_580181 != nil:
    section.add "containerId", valid_580181
  var valid_580182 = path.getOrDefault("accountId")
  valid_580182 = validateParameter(valid_580182, JString, required = true,
                                 default = nil)
  if valid_580182 != nil:
    section.add "accountId", valid_580182
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
  var valid_580183 = query.getOrDefault("fields")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "fields", valid_580183
  var valid_580184 = query.getOrDefault("quotaUser")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "quotaUser", valid_580184
  var valid_580185 = query.getOrDefault("alt")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = newJString("json"))
  if valid_580185 != nil:
    section.add "alt", valid_580185
  var valid_580186 = query.getOrDefault("oauth_token")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "oauth_token", valid_580186
  var valid_580187 = query.getOrDefault("userIp")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "userIp", valid_580187
  var valid_580188 = query.getOrDefault("key")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "key", valid_580188
  var valid_580189 = query.getOrDefault("prettyPrint")
  valid_580189 = validateParameter(valid_580189, JBool, required = false,
                                 default = newJBool(true))
  if valid_580189 != nil:
    section.add "prettyPrint", valid_580189
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

proc call*(call_580191: Call_TagmanagerAccountsContainersFoldersCreate_580178;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a GTM Folder.
  ## 
  let valid = call_580191.validator(path, query, header, formData, body)
  let scheme = call_580191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580191.url(scheme.get, call_580191.host, call_580191.base,
                         call_580191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580191, url, valid)

proc call*(call_580192: Call_TagmanagerAccountsContainersFoldersCreate_580178;
          containerId: string; accountId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersFoldersCreate
  ## Creates a GTM Folder.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580193 = newJObject()
  var query_580194 = newJObject()
  var body_580195 = newJObject()
  add(path_580193, "containerId", newJString(containerId))
  add(query_580194, "fields", newJString(fields))
  add(query_580194, "quotaUser", newJString(quotaUser))
  add(query_580194, "alt", newJString(alt))
  add(query_580194, "oauth_token", newJString(oauthToken))
  add(path_580193, "accountId", newJString(accountId))
  add(query_580194, "userIp", newJString(userIp))
  add(query_580194, "key", newJString(key))
  if body != nil:
    body_580195 = body
  add(query_580194, "prettyPrint", newJBool(prettyPrint))
  result = call_580192.call(path_580193, query_580194, nil, nil, body_580195)

var tagmanagerAccountsContainersFoldersCreate* = Call_TagmanagerAccountsContainersFoldersCreate_580178(
    name: "tagmanagerAccountsContainersFoldersCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/folders",
    validator: validate_TagmanagerAccountsContainersFoldersCreate_580179,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersFoldersCreate_580180,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersFoldersList_580162 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersFoldersList_580164(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/folders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersFoldersList_580163(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all GTM Folders of a Container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580165 = path.getOrDefault("containerId")
  valid_580165 = validateParameter(valid_580165, JString, required = true,
                                 default = nil)
  if valid_580165 != nil:
    section.add "containerId", valid_580165
  var valid_580166 = path.getOrDefault("accountId")
  valid_580166 = validateParameter(valid_580166, JString, required = true,
                                 default = nil)
  if valid_580166 != nil:
    section.add "accountId", valid_580166
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
  var valid_580167 = query.getOrDefault("fields")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "fields", valid_580167
  var valid_580168 = query.getOrDefault("quotaUser")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "quotaUser", valid_580168
  var valid_580169 = query.getOrDefault("alt")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = newJString("json"))
  if valid_580169 != nil:
    section.add "alt", valid_580169
  var valid_580170 = query.getOrDefault("oauth_token")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "oauth_token", valid_580170
  var valid_580171 = query.getOrDefault("userIp")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "userIp", valid_580171
  var valid_580172 = query.getOrDefault("key")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "key", valid_580172
  var valid_580173 = query.getOrDefault("prettyPrint")
  valid_580173 = validateParameter(valid_580173, JBool, required = false,
                                 default = newJBool(true))
  if valid_580173 != nil:
    section.add "prettyPrint", valid_580173
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580174: Call_TagmanagerAccountsContainersFoldersList_580162;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all GTM Folders of a Container.
  ## 
  let valid = call_580174.validator(path, query, header, formData, body)
  let scheme = call_580174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580174.url(scheme.get, call_580174.host, call_580174.base,
                         call_580174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580174, url, valid)

proc call*(call_580175: Call_TagmanagerAccountsContainersFoldersList_580162;
          containerId: string; accountId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersFoldersList
  ## Lists all GTM Folders of a Container.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580176 = newJObject()
  var query_580177 = newJObject()
  add(path_580176, "containerId", newJString(containerId))
  add(query_580177, "fields", newJString(fields))
  add(query_580177, "quotaUser", newJString(quotaUser))
  add(query_580177, "alt", newJString(alt))
  add(query_580177, "oauth_token", newJString(oauthToken))
  add(path_580176, "accountId", newJString(accountId))
  add(query_580177, "userIp", newJString(userIp))
  add(query_580177, "key", newJString(key))
  add(query_580177, "prettyPrint", newJBool(prettyPrint))
  result = call_580175.call(path_580176, query_580177, nil, nil, nil)

var tagmanagerAccountsContainersFoldersList* = Call_TagmanagerAccountsContainersFoldersList_580162(
    name: "tagmanagerAccountsContainersFoldersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/folders",
    validator: validate_TagmanagerAccountsContainersFoldersList_580163,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersFoldersList_580164,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersFoldersUpdate_580213 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersFoldersUpdate_580215(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  assert "folderId" in path, "`folderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/folders/"),
               (kind: VariableSegment, value: "folderId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersFoldersUpdate_580214(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a GTM Folder.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  ##   folderId: JString (required)
  ##           : The GTM Folder ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580216 = path.getOrDefault("containerId")
  valid_580216 = validateParameter(valid_580216, JString, required = true,
                                 default = nil)
  if valid_580216 != nil:
    section.add "containerId", valid_580216
  var valid_580217 = path.getOrDefault("accountId")
  valid_580217 = validateParameter(valid_580217, JString, required = true,
                                 default = nil)
  if valid_580217 != nil:
    section.add "accountId", valid_580217
  var valid_580218 = path.getOrDefault("folderId")
  valid_580218 = validateParameter(valid_580218, JString, required = true,
                                 default = nil)
  if valid_580218 != nil:
    section.add "folderId", valid_580218
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   fingerprint: JString
  ##              : When provided, this fingerprint must match the fingerprint of the folder in storage.
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
  var valid_580219 = query.getOrDefault("fields")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "fields", valid_580219
  var valid_580220 = query.getOrDefault("fingerprint")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "fingerprint", valid_580220
  var valid_580221 = query.getOrDefault("quotaUser")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "quotaUser", valid_580221
  var valid_580222 = query.getOrDefault("alt")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = newJString("json"))
  if valid_580222 != nil:
    section.add "alt", valid_580222
  var valid_580223 = query.getOrDefault("oauth_token")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "oauth_token", valid_580223
  var valid_580224 = query.getOrDefault("userIp")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "userIp", valid_580224
  var valid_580225 = query.getOrDefault("key")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "key", valid_580225
  var valid_580226 = query.getOrDefault("prettyPrint")
  valid_580226 = validateParameter(valid_580226, JBool, required = false,
                                 default = newJBool(true))
  if valid_580226 != nil:
    section.add "prettyPrint", valid_580226
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

proc call*(call_580228: Call_TagmanagerAccountsContainersFoldersUpdate_580213;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a GTM Folder.
  ## 
  let valid = call_580228.validator(path, query, header, formData, body)
  let scheme = call_580228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580228.url(scheme.get, call_580228.host, call_580228.base,
                         call_580228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580228, url, valid)

proc call*(call_580229: Call_TagmanagerAccountsContainersFoldersUpdate_580213;
          containerId: string; accountId: string; folderId: string;
          fields: string = ""; fingerprint: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersFoldersUpdate
  ## Updates a GTM Folder.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   fingerprint: string
  ##              : When provided, this fingerprint must match the fingerprint of the folder in storage.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   folderId: string (required)
  ##           : The GTM Folder ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580230 = newJObject()
  var query_580231 = newJObject()
  var body_580232 = newJObject()
  add(path_580230, "containerId", newJString(containerId))
  add(query_580231, "fields", newJString(fields))
  add(query_580231, "fingerprint", newJString(fingerprint))
  add(query_580231, "quotaUser", newJString(quotaUser))
  add(query_580231, "alt", newJString(alt))
  add(query_580231, "oauth_token", newJString(oauthToken))
  add(path_580230, "accountId", newJString(accountId))
  add(query_580231, "userIp", newJString(userIp))
  add(path_580230, "folderId", newJString(folderId))
  add(query_580231, "key", newJString(key))
  if body != nil:
    body_580232 = body
  add(query_580231, "prettyPrint", newJBool(prettyPrint))
  result = call_580229.call(path_580230, query_580231, nil, nil, body_580232)

var tagmanagerAccountsContainersFoldersUpdate* = Call_TagmanagerAccountsContainersFoldersUpdate_580213(
    name: "tagmanagerAccountsContainersFoldersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/folders/{folderId}",
    validator: validate_TagmanagerAccountsContainersFoldersUpdate_580214,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersFoldersUpdate_580215,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersFoldersGet_580196 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersFoldersGet_580198(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  assert "folderId" in path, "`folderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/folders/"),
               (kind: VariableSegment, value: "folderId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersFoldersGet_580197(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a GTM Folder.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  ##   folderId: JString (required)
  ##           : The GTM Folder ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580199 = path.getOrDefault("containerId")
  valid_580199 = validateParameter(valid_580199, JString, required = true,
                                 default = nil)
  if valid_580199 != nil:
    section.add "containerId", valid_580199
  var valid_580200 = path.getOrDefault("accountId")
  valid_580200 = validateParameter(valid_580200, JString, required = true,
                                 default = nil)
  if valid_580200 != nil:
    section.add "accountId", valid_580200
  var valid_580201 = path.getOrDefault("folderId")
  valid_580201 = validateParameter(valid_580201, JString, required = true,
                                 default = nil)
  if valid_580201 != nil:
    section.add "folderId", valid_580201
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
  var valid_580202 = query.getOrDefault("fields")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "fields", valid_580202
  var valid_580203 = query.getOrDefault("quotaUser")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "quotaUser", valid_580203
  var valid_580204 = query.getOrDefault("alt")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = newJString("json"))
  if valid_580204 != nil:
    section.add "alt", valid_580204
  var valid_580205 = query.getOrDefault("oauth_token")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "oauth_token", valid_580205
  var valid_580206 = query.getOrDefault("userIp")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "userIp", valid_580206
  var valid_580207 = query.getOrDefault("key")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "key", valid_580207
  var valid_580208 = query.getOrDefault("prettyPrint")
  valid_580208 = validateParameter(valid_580208, JBool, required = false,
                                 default = newJBool(true))
  if valid_580208 != nil:
    section.add "prettyPrint", valid_580208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580209: Call_TagmanagerAccountsContainersFoldersGet_580196;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a GTM Folder.
  ## 
  let valid = call_580209.validator(path, query, header, formData, body)
  let scheme = call_580209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580209.url(scheme.get, call_580209.host, call_580209.base,
                         call_580209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580209, url, valid)

proc call*(call_580210: Call_TagmanagerAccountsContainersFoldersGet_580196;
          containerId: string; accountId: string; folderId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersFoldersGet
  ## Gets a GTM Folder.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   folderId: string (required)
  ##           : The GTM Folder ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580211 = newJObject()
  var query_580212 = newJObject()
  add(path_580211, "containerId", newJString(containerId))
  add(query_580212, "fields", newJString(fields))
  add(query_580212, "quotaUser", newJString(quotaUser))
  add(query_580212, "alt", newJString(alt))
  add(query_580212, "oauth_token", newJString(oauthToken))
  add(path_580211, "accountId", newJString(accountId))
  add(query_580212, "userIp", newJString(userIp))
  add(path_580211, "folderId", newJString(folderId))
  add(query_580212, "key", newJString(key))
  add(query_580212, "prettyPrint", newJBool(prettyPrint))
  result = call_580210.call(path_580211, query_580212, nil, nil, nil)

var tagmanagerAccountsContainersFoldersGet* = Call_TagmanagerAccountsContainersFoldersGet_580196(
    name: "tagmanagerAccountsContainersFoldersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/folders/{folderId}",
    validator: validate_TagmanagerAccountsContainersFoldersGet_580197,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersFoldersGet_580198,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersFoldersDelete_580233 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersFoldersDelete_580235(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  assert "folderId" in path, "`folderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/folders/"),
               (kind: VariableSegment, value: "folderId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersFoldersDelete_580234(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a GTM Folder.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  ##   folderId: JString (required)
  ##           : The GTM Folder ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580236 = path.getOrDefault("containerId")
  valid_580236 = validateParameter(valid_580236, JString, required = true,
                                 default = nil)
  if valid_580236 != nil:
    section.add "containerId", valid_580236
  var valid_580237 = path.getOrDefault("accountId")
  valid_580237 = validateParameter(valid_580237, JString, required = true,
                                 default = nil)
  if valid_580237 != nil:
    section.add "accountId", valid_580237
  var valid_580238 = path.getOrDefault("folderId")
  valid_580238 = validateParameter(valid_580238, JString, required = true,
                                 default = nil)
  if valid_580238 != nil:
    section.add "folderId", valid_580238
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
  var valid_580239 = query.getOrDefault("fields")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "fields", valid_580239
  var valid_580240 = query.getOrDefault("quotaUser")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "quotaUser", valid_580240
  var valid_580241 = query.getOrDefault("alt")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = newJString("json"))
  if valid_580241 != nil:
    section.add "alt", valid_580241
  var valid_580242 = query.getOrDefault("oauth_token")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "oauth_token", valid_580242
  var valid_580243 = query.getOrDefault("userIp")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "userIp", valid_580243
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580246: Call_TagmanagerAccountsContainersFoldersDelete_580233;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a GTM Folder.
  ## 
  let valid = call_580246.validator(path, query, header, formData, body)
  let scheme = call_580246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580246.url(scheme.get, call_580246.host, call_580246.base,
                         call_580246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580246, url, valid)

proc call*(call_580247: Call_TagmanagerAccountsContainersFoldersDelete_580233;
          containerId: string; accountId: string; folderId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersFoldersDelete
  ## Deletes a GTM Folder.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   folderId: string (required)
  ##           : The GTM Folder ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580248 = newJObject()
  var query_580249 = newJObject()
  add(path_580248, "containerId", newJString(containerId))
  add(query_580249, "fields", newJString(fields))
  add(query_580249, "quotaUser", newJString(quotaUser))
  add(query_580249, "alt", newJString(alt))
  add(query_580249, "oauth_token", newJString(oauthToken))
  add(path_580248, "accountId", newJString(accountId))
  add(query_580249, "userIp", newJString(userIp))
  add(path_580248, "folderId", newJString(folderId))
  add(query_580249, "key", newJString(key))
  add(query_580249, "prettyPrint", newJBool(prettyPrint))
  result = call_580247.call(path_580248, query_580249, nil, nil, nil)

var tagmanagerAccountsContainersFoldersDelete* = Call_TagmanagerAccountsContainersFoldersDelete_580233(
    name: "tagmanagerAccountsContainersFoldersDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/folders/{folderId}",
    validator: validate_TagmanagerAccountsContainersFoldersDelete_580234,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersFoldersDelete_580235,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersFoldersEntitiesList_580250 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersFoldersEntitiesList_580252(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  assert "folderId" in path, "`folderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/folders/"),
               (kind: VariableSegment, value: "folderId"),
               (kind: ConstantSegment, value: "/entities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersFoldersEntitiesList_580251(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List all entities in a GTM Folder.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  ##   folderId: JString (required)
  ##           : The GTM Folder ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580253 = path.getOrDefault("containerId")
  valid_580253 = validateParameter(valid_580253, JString, required = true,
                                 default = nil)
  if valid_580253 != nil:
    section.add "containerId", valid_580253
  var valid_580254 = path.getOrDefault("accountId")
  valid_580254 = validateParameter(valid_580254, JString, required = true,
                                 default = nil)
  if valid_580254 != nil:
    section.add "accountId", valid_580254
  var valid_580255 = path.getOrDefault("folderId")
  valid_580255 = validateParameter(valid_580255, JString, required = true,
                                 default = nil)
  if valid_580255 != nil:
    section.add "folderId", valid_580255
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
  var valid_580256 = query.getOrDefault("fields")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "fields", valid_580256
  var valid_580257 = query.getOrDefault("quotaUser")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "quotaUser", valid_580257
  var valid_580258 = query.getOrDefault("alt")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = newJString("json"))
  if valid_580258 != nil:
    section.add "alt", valid_580258
  var valid_580259 = query.getOrDefault("oauth_token")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "oauth_token", valid_580259
  var valid_580260 = query.getOrDefault("userIp")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "userIp", valid_580260
  var valid_580261 = query.getOrDefault("key")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "key", valid_580261
  var valid_580262 = query.getOrDefault("prettyPrint")
  valid_580262 = validateParameter(valid_580262, JBool, required = false,
                                 default = newJBool(true))
  if valid_580262 != nil:
    section.add "prettyPrint", valid_580262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580263: Call_TagmanagerAccountsContainersFoldersEntitiesList_580250;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all entities in a GTM Folder.
  ## 
  let valid = call_580263.validator(path, query, header, formData, body)
  let scheme = call_580263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580263.url(scheme.get, call_580263.host, call_580263.base,
                         call_580263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580263, url, valid)

proc call*(call_580264: Call_TagmanagerAccountsContainersFoldersEntitiesList_580250;
          containerId: string; accountId: string; folderId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersFoldersEntitiesList
  ## List all entities in a GTM Folder.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   folderId: string (required)
  ##           : The GTM Folder ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580265 = newJObject()
  var query_580266 = newJObject()
  add(path_580265, "containerId", newJString(containerId))
  add(query_580266, "fields", newJString(fields))
  add(query_580266, "quotaUser", newJString(quotaUser))
  add(query_580266, "alt", newJString(alt))
  add(query_580266, "oauth_token", newJString(oauthToken))
  add(path_580265, "accountId", newJString(accountId))
  add(query_580266, "userIp", newJString(userIp))
  add(path_580265, "folderId", newJString(folderId))
  add(query_580266, "key", newJString(key))
  add(query_580266, "prettyPrint", newJBool(prettyPrint))
  result = call_580264.call(path_580265, query_580266, nil, nil, nil)

var tagmanagerAccountsContainersFoldersEntitiesList* = Call_TagmanagerAccountsContainersFoldersEntitiesList_580250(
    name: "tagmanagerAccountsContainersFoldersEntitiesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/folders/{folderId}/entities",
    validator: validate_TagmanagerAccountsContainersFoldersEntitiesList_580251,
    base: "/tagmanager/v1",
    url: url_TagmanagerAccountsContainersFoldersEntitiesList_580252,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersMoveFoldersUpdate_580267 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersMoveFoldersUpdate_580269(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  assert "folderId" in path, "`folderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/move_folders/"),
               (kind: VariableSegment, value: "folderId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersMoveFoldersUpdate_580268(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Moves entities to a GTM Folder.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  ##   folderId: JString (required)
  ##           : The GTM Folder ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580270 = path.getOrDefault("containerId")
  valid_580270 = validateParameter(valid_580270, JString, required = true,
                                 default = nil)
  if valid_580270 != nil:
    section.add "containerId", valid_580270
  var valid_580271 = path.getOrDefault("accountId")
  valid_580271 = validateParameter(valid_580271, JString, required = true,
                                 default = nil)
  if valid_580271 != nil:
    section.add "accountId", valid_580271
  var valid_580272 = path.getOrDefault("folderId")
  valid_580272 = validateParameter(valid_580272, JString, required = true,
                                 default = nil)
  if valid_580272 != nil:
    section.add "folderId", valid_580272
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
  ##   triggerId: JArray
  ##            : The triggers to be moved to the folder.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   tagId: JArray
  ##        : The tags to be moved to the folder.
  ##   variableId: JArray
  ##             : The variables to be moved to the folder.
  section = newJObject()
  var valid_580273 = query.getOrDefault("fields")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "fields", valid_580273
  var valid_580274 = query.getOrDefault("quotaUser")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "quotaUser", valid_580274
  var valid_580275 = query.getOrDefault("alt")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = newJString("json"))
  if valid_580275 != nil:
    section.add "alt", valid_580275
  var valid_580276 = query.getOrDefault("oauth_token")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "oauth_token", valid_580276
  var valid_580277 = query.getOrDefault("userIp")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "userIp", valid_580277
  var valid_580278 = query.getOrDefault("key")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "key", valid_580278
  var valid_580279 = query.getOrDefault("triggerId")
  valid_580279 = validateParameter(valid_580279, JArray, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "triggerId", valid_580279
  var valid_580280 = query.getOrDefault("prettyPrint")
  valid_580280 = validateParameter(valid_580280, JBool, required = false,
                                 default = newJBool(true))
  if valid_580280 != nil:
    section.add "prettyPrint", valid_580280
  var valid_580281 = query.getOrDefault("tagId")
  valid_580281 = validateParameter(valid_580281, JArray, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "tagId", valid_580281
  var valid_580282 = query.getOrDefault("variableId")
  valid_580282 = validateParameter(valid_580282, JArray, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "variableId", valid_580282
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

proc call*(call_580284: Call_TagmanagerAccountsContainersMoveFoldersUpdate_580267;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Moves entities to a GTM Folder.
  ## 
  let valid = call_580284.validator(path, query, header, formData, body)
  let scheme = call_580284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580284.url(scheme.get, call_580284.host, call_580284.base,
                         call_580284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580284, url, valid)

proc call*(call_580285: Call_TagmanagerAccountsContainersMoveFoldersUpdate_580267;
          containerId: string; accountId: string; folderId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          triggerId: JsonNode = nil; body: JsonNode = nil; prettyPrint: bool = true;
          tagId: JsonNode = nil; variableId: JsonNode = nil): Recallable =
  ## tagmanagerAccountsContainersMoveFoldersUpdate
  ## Moves entities to a GTM Folder.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   folderId: string (required)
  ##           : The GTM Folder ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   triggerId: JArray
  ##            : The triggers to be moved to the folder.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   tagId: JArray
  ##        : The tags to be moved to the folder.
  ##   variableId: JArray
  ##             : The variables to be moved to the folder.
  var path_580286 = newJObject()
  var query_580287 = newJObject()
  var body_580288 = newJObject()
  add(path_580286, "containerId", newJString(containerId))
  add(query_580287, "fields", newJString(fields))
  add(query_580287, "quotaUser", newJString(quotaUser))
  add(query_580287, "alt", newJString(alt))
  add(query_580287, "oauth_token", newJString(oauthToken))
  add(path_580286, "accountId", newJString(accountId))
  add(query_580287, "userIp", newJString(userIp))
  add(path_580286, "folderId", newJString(folderId))
  add(query_580287, "key", newJString(key))
  if triggerId != nil:
    query_580287.add "triggerId", triggerId
  if body != nil:
    body_580288 = body
  add(query_580287, "prettyPrint", newJBool(prettyPrint))
  if tagId != nil:
    query_580287.add "tagId", tagId
  if variableId != nil:
    query_580287.add "variableId", variableId
  result = call_580285.call(path_580286, query_580287, nil, nil, body_580288)

var tagmanagerAccountsContainersMoveFoldersUpdate* = Call_TagmanagerAccountsContainersMoveFoldersUpdate_580267(
    name: "tagmanagerAccountsContainersMoveFoldersUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/move_folders/{folderId}",
    validator: validate_TagmanagerAccountsContainersMoveFoldersUpdate_580268,
    base: "/tagmanager/v1",
    url: url_TagmanagerAccountsContainersMoveFoldersUpdate_580269,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_580289 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_580291(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  assert "environmentId" in path, "`environmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/reauthorize_environments/"),
               (kind: VariableSegment, value: "environmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_580290(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Re-generates the authorization code for a GTM Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  ##   environmentId: JString (required)
  ##                : The GTM Environment ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580292 = path.getOrDefault("containerId")
  valid_580292 = validateParameter(valid_580292, JString, required = true,
                                 default = nil)
  if valid_580292 != nil:
    section.add "containerId", valid_580292
  var valid_580293 = path.getOrDefault("accountId")
  valid_580293 = validateParameter(valid_580293, JString, required = true,
                                 default = nil)
  if valid_580293 != nil:
    section.add "accountId", valid_580293
  var valid_580294 = path.getOrDefault("environmentId")
  valid_580294 = validateParameter(valid_580294, JString, required = true,
                                 default = nil)
  if valid_580294 != nil:
    section.add "environmentId", valid_580294
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
  var valid_580295 = query.getOrDefault("fields")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "fields", valid_580295
  var valid_580296 = query.getOrDefault("quotaUser")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = nil)
  if valid_580296 != nil:
    section.add "quotaUser", valid_580296
  var valid_580297 = query.getOrDefault("alt")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = newJString("json"))
  if valid_580297 != nil:
    section.add "alt", valid_580297
  var valid_580298 = query.getOrDefault("oauth_token")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "oauth_token", valid_580298
  var valid_580299 = query.getOrDefault("userIp")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = nil)
  if valid_580299 != nil:
    section.add "userIp", valid_580299
  var valid_580300 = query.getOrDefault("key")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "key", valid_580300
  var valid_580301 = query.getOrDefault("prettyPrint")
  valid_580301 = validateParameter(valid_580301, JBool, required = false,
                                 default = newJBool(true))
  if valid_580301 != nil:
    section.add "prettyPrint", valid_580301
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

proc call*(call_580303: Call_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_580289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Re-generates the authorization code for a GTM Environment.
  ## 
  let valid = call_580303.validator(path, query, header, formData, body)
  let scheme = call_580303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580303.url(scheme.get, call_580303.host, call_580303.base,
                         call_580303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580303, url, valid)

proc call*(call_580304: Call_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_580289;
          containerId: string; accountId: string; environmentId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersReauthorizeEnvironmentsUpdate
  ## Re-generates the authorization code for a GTM Environment.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   environmentId: string (required)
  ##                : The GTM Environment ID.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580305 = newJObject()
  var query_580306 = newJObject()
  var body_580307 = newJObject()
  add(path_580305, "containerId", newJString(containerId))
  add(query_580306, "fields", newJString(fields))
  add(query_580306, "quotaUser", newJString(quotaUser))
  add(query_580306, "alt", newJString(alt))
  add(query_580306, "oauth_token", newJString(oauthToken))
  add(path_580305, "accountId", newJString(accountId))
  add(query_580306, "userIp", newJString(userIp))
  add(query_580306, "key", newJString(key))
  add(path_580305, "environmentId", newJString(environmentId))
  if body != nil:
    body_580307 = body
  add(query_580306, "prettyPrint", newJBool(prettyPrint))
  result = call_580304.call(path_580305, query_580306, nil, nil, body_580307)

var tagmanagerAccountsContainersReauthorizeEnvironmentsUpdate* = Call_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_580289(
    name: "tagmanagerAccountsContainersReauthorizeEnvironmentsUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/reauthorize_environments/{environmentId}", validator: validate_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_580290,
    base: "/tagmanager/v1",
    url: url_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_580291,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTagsCreate_580324 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersTagsCreate_580326(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/tags")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersTagsCreate_580325(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a GTM Tag.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580327 = path.getOrDefault("containerId")
  valid_580327 = validateParameter(valid_580327, JString, required = true,
                                 default = nil)
  if valid_580327 != nil:
    section.add "containerId", valid_580327
  var valid_580328 = path.getOrDefault("accountId")
  valid_580328 = validateParameter(valid_580328, JString, required = true,
                                 default = nil)
  if valid_580328 != nil:
    section.add "accountId", valid_580328
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
  var valid_580329 = query.getOrDefault("fields")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "fields", valid_580329
  var valid_580330 = query.getOrDefault("quotaUser")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = nil)
  if valid_580330 != nil:
    section.add "quotaUser", valid_580330
  var valid_580331 = query.getOrDefault("alt")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = newJString("json"))
  if valid_580331 != nil:
    section.add "alt", valid_580331
  var valid_580332 = query.getOrDefault("oauth_token")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = nil)
  if valid_580332 != nil:
    section.add "oauth_token", valid_580332
  var valid_580333 = query.getOrDefault("userIp")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "userIp", valid_580333
  var valid_580334 = query.getOrDefault("key")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = nil)
  if valid_580334 != nil:
    section.add "key", valid_580334
  var valid_580335 = query.getOrDefault("prettyPrint")
  valid_580335 = validateParameter(valid_580335, JBool, required = false,
                                 default = newJBool(true))
  if valid_580335 != nil:
    section.add "prettyPrint", valid_580335
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

proc call*(call_580337: Call_TagmanagerAccountsContainersTagsCreate_580324;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a GTM Tag.
  ## 
  let valid = call_580337.validator(path, query, header, formData, body)
  let scheme = call_580337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580337.url(scheme.get, call_580337.host, call_580337.base,
                         call_580337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580337, url, valid)

proc call*(call_580338: Call_TagmanagerAccountsContainersTagsCreate_580324;
          containerId: string; accountId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersTagsCreate
  ## Creates a GTM Tag.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580339 = newJObject()
  var query_580340 = newJObject()
  var body_580341 = newJObject()
  add(path_580339, "containerId", newJString(containerId))
  add(query_580340, "fields", newJString(fields))
  add(query_580340, "quotaUser", newJString(quotaUser))
  add(query_580340, "alt", newJString(alt))
  add(query_580340, "oauth_token", newJString(oauthToken))
  add(path_580339, "accountId", newJString(accountId))
  add(query_580340, "userIp", newJString(userIp))
  add(query_580340, "key", newJString(key))
  if body != nil:
    body_580341 = body
  add(query_580340, "prettyPrint", newJBool(prettyPrint))
  result = call_580338.call(path_580339, query_580340, nil, nil, body_580341)

var tagmanagerAccountsContainersTagsCreate* = Call_TagmanagerAccountsContainersTagsCreate_580324(
    name: "tagmanagerAccountsContainersTagsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/tags",
    validator: validate_TagmanagerAccountsContainersTagsCreate_580325,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTagsCreate_580326,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTagsList_580308 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersTagsList_580310(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/tags")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersTagsList_580309(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all GTM Tags of a Container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580311 = path.getOrDefault("containerId")
  valid_580311 = validateParameter(valid_580311, JString, required = true,
                                 default = nil)
  if valid_580311 != nil:
    section.add "containerId", valid_580311
  var valid_580312 = path.getOrDefault("accountId")
  valid_580312 = validateParameter(valid_580312, JString, required = true,
                                 default = nil)
  if valid_580312 != nil:
    section.add "accountId", valid_580312
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
  var valid_580313 = query.getOrDefault("fields")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "fields", valid_580313
  var valid_580314 = query.getOrDefault("quotaUser")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = nil)
  if valid_580314 != nil:
    section.add "quotaUser", valid_580314
  var valid_580315 = query.getOrDefault("alt")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = newJString("json"))
  if valid_580315 != nil:
    section.add "alt", valid_580315
  var valid_580316 = query.getOrDefault("oauth_token")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "oauth_token", valid_580316
  var valid_580317 = query.getOrDefault("userIp")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "userIp", valid_580317
  var valid_580318 = query.getOrDefault("key")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "key", valid_580318
  var valid_580319 = query.getOrDefault("prettyPrint")
  valid_580319 = validateParameter(valid_580319, JBool, required = false,
                                 default = newJBool(true))
  if valid_580319 != nil:
    section.add "prettyPrint", valid_580319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580320: Call_TagmanagerAccountsContainersTagsList_580308;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all GTM Tags of a Container.
  ## 
  let valid = call_580320.validator(path, query, header, formData, body)
  let scheme = call_580320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580320.url(scheme.get, call_580320.host, call_580320.base,
                         call_580320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580320, url, valid)

proc call*(call_580321: Call_TagmanagerAccountsContainersTagsList_580308;
          containerId: string; accountId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersTagsList
  ## Lists all GTM Tags of a Container.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580322 = newJObject()
  var query_580323 = newJObject()
  add(path_580322, "containerId", newJString(containerId))
  add(query_580323, "fields", newJString(fields))
  add(query_580323, "quotaUser", newJString(quotaUser))
  add(query_580323, "alt", newJString(alt))
  add(query_580323, "oauth_token", newJString(oauthToken))
  add(path_580322, "accountId", newJString(accountId))
  add(query_580323, "userIp", newJString(userIp))
  add(query_580323, "key", newJString(key))
  add(query_580323, "prettyPrint", newJBool(prettyPrint))
  result = call_580321.call(path_580322, query_580323, nil, nil, nil)

var tagmanagerAccountsContainersTagsList* = Call_TagmanagerAccountsContainersTagsList_580308(
    name: "tagmanagerAccountsContainersTagsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/tags",
    validator: validate_TagmanagerAccountsContainersTagsList_580309,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTagsList_580310,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTagsUpdate_580359 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersTagsUpdate_580361(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersTagsUpdate_580360(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a GTM Tag.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   tagId: JString (required)
  ##        : The GTM Tag ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580362 = path.getOrDefault("containerId")
  valid_580362 = validateParameter(valid_580362, JString, required = true,
                                 default = nil)
  if valid_580362 != nil:
    section.add "containerId", valid_580362
  var valid_580363 = path.getOrDefault("tagId")
  valid_580363 = validateParameter(valid_580363, JString, required = true,
                                 default = nil)
  if valid_580363 != nil:
    section.add "tagId", valid_580363
  var valid_580364 = path.getOrDefault("accountId")
  valid_580364 = validateParameter(valid_580364, JString, required = true,
                                 default = nil)
  if valid_580364 != nil:
    section.add "accountId", valid_580364
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   fingerprint: JString
  ##              : When provided, this fingerprint must match the fingerprint of the tag in storage.
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
  var valid_580365 = query.getOrDefault("fields")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "fields", valid_580365
  var valid_580366 = query.getOrDefault("fingerprint")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = nil)
  if valid_580366 != nil:
    section.add "fingerprint", valid_580366
  var valid_580367 = query.getOrDefault("quotaUser")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "quotaUser", valid_580367
  var valid_580368 = query.getOrDefault("alt")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = newJString("json"))
  if valid_580368 != nil:
    section.add "alt", valid_580368
  var valid_580369 = query.getOrDefault("oauth_token")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = nil)
  if valid_580369 != nil:
    section.add "oauth_token", valid_580369
  var valid_580370 = query.getOrDefault("userIp")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "userIp", valid_580370
  var valid_580371 = query.getOrDefault("key")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "key", valid_580371
  var valid_580372 = query.getOrDefault("prettyPrint")
  valid_580372 = validateParameter(valid_580372, JBool, required = false,
                                 default = newJBool(true))
  if valid_580372 != nil:
    section.add "prettyPrint", valid_580372
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

proc call*(call_580374: Call_TagmanagerAccountsContainersTagsUpdate_580359;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a GTM Tag.
  ## 
  let valid = call_580374.validator(path, query, header, formData, body)
  let scheme = call_580374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580374.url(scheme.get, call_580374.host, call_580374.base,
                         call_580374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580374, url, valid)

proc call*(call_580375: Call_TagmanagerAccountsContainersTagsUpdate_580359;
          containerId: string; tagId: string; accountId: string; fields: string = "";
          fingerprint: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersTagsUpdate
  ## Updates a GTM Tag.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   tagId: string (required)
  ##        : The GTM Tag ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   fingerprint: string
  ##              : When provided, this fingerprint must match the fingerprint of the tag in storage.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580376 = newJObject()
  var query_580377 = newJObject()
  var body_580378 = newJObject()
  add(path_580376, "containerId", newJString(containerId))
  add(path_580376, "tagId", newJString(tagId))
  add(query_580377, "fields", newJString(fields))
  add(query_580377, "fingerprint", newJString(fingerprint))
  add(query_580377, "quotaUser", newJString(quotaUser))
  add(query_580377, "alt", newJString(alt))
  add(query_580377, "oauth_token", newJString(oauthToken))
  add(path_580376, "accountId", newJString(accountId))
  add(query_580377, "userIp", newJString(userIp))
  add(query_580377, "key", newJString(key))
  if body != nil:
    body_580378 = body
  add(query_580377, "prettyPrint", newJBool(prettyPrint))
  result = call_580375.call(path_580376, query_580377, nil, nil, body_580378)

var tagmanagerAccountsContainersTagsUpdate* = Call_TagmanagerAccountsContainersTagsUpdate_580359(
    name: "tagmanagerAccountsContainersTagsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/tags/{tagId}",
    validator: validate_TagmanagerAccountsContainersTagsUpdate_580360,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTagsUpdate_580361,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTagsGet_580342 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersTagsGet_580344(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersTagsGet_580343(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a GTM Tag.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   tagId: JString (required)
  ##        : The GTM Tag ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580345 = path.getOrDefault("containerId")
  valid_580345 = validateParameter(valid_580345, JString, required = true,
                                 default = nil)
  if valid_580345 != nil:
    section.add "containerId", valid_580345
  var valid_580346 = path.getOrDefault("tagId")
  valid_580346 = validateParameter(valid_580346, JString, required = true,
                                 default = nil)
  if valid_580346 != nil:
    section.add "tagId", valid_580346
  var valid_580347 = path.getOrDefault("accountId")
  valid_580347 = validateParameter(valid_580347, JString, required = true,
                                 default = nil)
  if valid_580347 != nil:
    section.add "accountId", valid_580347
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
  var valid_580348 = query.getOrDefault("fields")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = nil)
  if valid_580348 != nil:
    section.add "fields", valid_580348
  var valid_580349 = query.getOrDefault("quotaUser")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "quotaUser", valid_580349
  var valid_580350 = query.getOrDefault("alt")
  valid_580350 = validateParameter(valid_580350, JString, required = false,
                                 default = newJString("json"))
  if valid_580350 != nil:
    section.add "alt", valid_580350
  var valid_580351 = query.getOrDefault("oauth_token")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "oauth_token", valid_580351
  var valid_580352 = query.getOrDefault("userIp")
  valid_580352 = validateParameter(valid_580352, JString, required = false,
                                 default = nil)
  if valid_580352 != nil:
    section.add "userIp", valid_580352
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580355: Call_TagmanagerAccountsContainersTagsGet_580342;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a GTM Tag.
  ## 
  let valid = call_580355.validator(path, query, header, formData, body)
  let scheme = call_580355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580355.url(scheme.get, call_580355.host, call_580355.base,
                         call_580355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580355, url, valid)

proc call*(call_580356: Call_TagmanagerAccountsContainersTagsGet_580342;
          containerId: string; tagId: string; accountId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersTagsGet
  ## Gets a GTM Tag.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   tagId: string (required)
  ##        : The GTM Tag ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580357 = newJObject()
  var query_580358 = newJObject()
  add(path_580357, "containerId", newJString(containerId))
  add(path_580357, "tagId", newJString(tagId))
  add(query_580358, "fields", newJString(fields))
  add(query_580358, "quotaUser", newJString(quotaUser))
  add(query_580358, "alt", newJString(alt))
  add(query_580358, "oauth_token", newJString(oauthToken))
  add(path_580357, "accountId", newJString(accountId))
  add(query_580358, "userIp", newJString(userIp))
  add(query_580358, "key", newJString(key))
  add(query_580358, "prettyPrint", newJBool(prettyPrint))
  result = call_580356.call(path_580357, query_580358, nil, nil, nil)

var tagmanagerAccountsContainersTagsGet* = Call_TagmanagerAccountsContainersTagsGet_580342(
    name: "tagmanagerAccountsContainersTagsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/tags/{tagId}",
    validator: validate_TagmanagerAccountsContainersTagsGet_580343,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTagsGet_580344,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTagsDelete_580379 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersTagsDelete_580381(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersTagsDelete_580380(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a GTM Tag.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   tagId: JString (required)
  ##        : The GTM Tag ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580382 = path.getOrDefault("containerId")
  valid_580382 = validateParameter(valid_580382, JString, required = true,
                                 default = nil)
  if valid_580382 != nil:
    section.add "containerId", valid_580382
  var valid_580383 = path.getOrDefault("tagId")
  valid_580383 = validateParameter(valid_580383, JString, required = true,
                                 default = nil)
  if valid_580383 != nil:
    section.add "tagId", valid_580383
  var valid_580384 = path.getOrDefault("accountId")
  valid_580384 = validateParameter(valid_580384, JString, required = true,
                                 default = nil)
  if valid_580384 != nil:
    section.add "accountId", valid_580384
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
  var valid_580385 = query.getOrDefault("fields")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = nil)
  if valid_580385 != nil:
    section.add "fields", valid_580385
  var valid_580386 = query.getOrDefault("quotaUser")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = nil)
  if valid_580386 != nil:
    section.add "quotaUser", valid_580386
  var valid_580387 = query.getOrDefault("alt")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = newJString("json"))
  if valid_580387 != nil:
    section.add "alt", valid_580387
  var valid_580388 = query.getOrDefault("oauth_token")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "oauth_token", valid_580388
  var valid_580389 = query.getOrDefault("userIp")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "userIp", valid_580389
  var valid_580390 = query.getOrDefault("key")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = nil)
  if valid_580390 != nil:
    section.add "key", valid_580390
  var valid_580391 = query.getOrDefault("prettyPrint")
  valid_580391 = validateParameter(valid_580391, JBool, required = false,
                                 default = newJBool(true))
  if valid_580391 != nil:
    section.add "prettyPrint", valid_580391
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580392: Call_TagmanagerAccountsContainersTagsDelete_580379;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a GTM Tag.
  ## 
  let valid = call_580392.validator(path, query, header, formData, body)
  let scheme = call_580392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580392.url(scheme.get, call_580392.host, call_580392.base,
                         call_580392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580392, url, valid)

proc call*(call_580393: Call_TagmanagerAccountsContainersTagsDelete_580379;
          containerId: string; tagId: string; accountId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersTagsDelete
  ## Deletes a GTM Tag.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   tagId: string (required)
  ##        : The GTM Tag ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580394 = newJObject()
  var query_580395 = newJObject()
  add(path_580394, "containerId", newJString(containerId))
  add(path_580394, "tagId", newJString(tagId))
  add(query_580395, "fields", newJString(fields))
  add(query_580395, "quotaUser", newJString(quotaUser))
  add(query_580395, "alt", newJString(alt))
  add(query_580395, "oauth_token", newJString(oauthToken))
  add(path_580394, "accountId", newJString(accountId))
  add(query_580395, "userIp", newJString(userIp))
  add(query_580395, "key", newJString(key))
  add(query_580395, "prettyPrint", newJBool(prettyPrint))
  result = call_580393.call(path_580394, query_580395, nil, nil, nil)

var tagmanagerAccountsContainersTagsDelete* = Call_TagmanagerAccountsContainersTagsDelete_580379(
    name: "tagmanagerAccountsContainersTagsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/tags/{tagId}",
    validator: validate_TagmanagerAccountsContainersTagsDelete_580380,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTagsDelete_580381,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTriggersCreate_580412 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersTriggersCreate_580414(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/triggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersTriggersCreate_580413(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a GTM Trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580415 = path.getOrDefault("containerId")
  valid_580415 = validateParameter(valid_580415, JString, required = true,
                                 default = nil)
  if valid_580415 != nil:
    section.add "containerId", valid_580415
  var valid_580416 = path.getOrDefault("accountId")
  valid_580416 = validateParameter(valid_580416, JString, required = true,
                                 default = nil)
  if valid_580416 != nil:
    section.add "accountId", valid_580416
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
  var valid_580417 = query.getOrDefault("fields")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = nil)
  if valid_580417 != nil:
    section.add "fields", valid_580417
  var valid_580418 = query.getOrDefault("quotaUser")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = nil)
  if valid_580418 != nil:
    section.add "quotaUser", valid_580418
  var valid_580419 = query.getOrDefault("alt")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = newJString("json"))
  if valid_580419 != nil:
    section.add "alt", valid_580419
  var valid_580420 = query.getOrDefault("oauth_token")
  valid_580420 = validateParameter(valid_580420, JString, required = false,
                                 default = nil)
  if valid_580420 != nil:
    section.add "oauth_token", valid_580420
  var valid_580421 = query.getOrDefault("userIp")
  valid_580421 = validateParameter(valid_580421, JString, required = false,
                                 default = nil)
  if valid_580421 != nil:
    section.add "userIp", valid_580421
  var valid_580422 = query.getOrDefault("key")
  valid_580422 = validateParameter(valid_580422, JString, required = false,
                                 default = nil)
  if valid_580422 != nil:
    section.add "key", valid_580422
  var valid_580423 = query.getOrDefault("prettyPrint")
  valid_580423 = validateParameter(valid_580423, JBool, required = false,
                                 default = newJBool(true))
  if valid_580423 != nil:
    section.add "prettyPrint", valid_580423
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

proc call*(call_580425: Call_TagmanagerAccountsContainersTriggersCreate_580412;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a GTM Trigger.
  ## 
  let valid = call_580425.validator(path, query, header, formData, body)
  let scheme = call_580425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580425.url(scheme.get, call_580425.host, call_580425.base,
                         call_580425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580425, url, valid)

proc call*(call_580426: Call_TagmanagerAccountsContainersTriggersCreate_580412;
          containerId: string; accountId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersTriggersCreate
  ## Creates a GTM Trigger.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580427 = newJObject()
  var query_580428 = newJObject()
  var body_580429 = newJObject()
  add(path_580427, "containerId", newJString(containerId))
  add(query_580428, "fields", newJString(fields))
  add(query_580428, "quotaUser", newJString(quotaUser))
  add(query_580428, "alt", newJString(alt))
  add(query_580428, "oauth_token", newJString(oauthToken))
  add(path_580427, "accountId", newJString(accountId))
  add(query_580428, "userIp", newJString(userIp))
  add(query_580428, "key", newJString(key))
  if body != nil:
    body_580429 = body
  add(query_580428, "prettyPrint", newJBool(prettyPrint))
  result = call_580426.call(path_580427, query_580428, nil, nil, body_580429)

var tagmanagerAccountsContainersTriggersCreate* = Call_TagmanagerAccountsContainersTriggersCreate_580412(
    name: "tagmanagerAccountsContainersTriggersCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/triggers",
    validator: validate_TagmanagerAccountsContainersTriggersCreate_580413,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTriggersCreate_580414,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTriggersList_580396 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersTriggersList_580398(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/triggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersTriggersList_580397(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all GTM Triggers of a Container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580399 = path.getOrDefault("containerId")
  valid_580399 = validateParameter(valid_580399, JString, required = true,
                                 default = nil)
  if valid_580399 != nil:
    section.add "containerId", valid_580399
  var valid_580400 = path.getOrDefault("accountId")
  valid_580400 = validateParameter(valid_580400, JString, required = true,
                                 default = nil)
  if valid_580400 != nil:
    section.add "accountId", valid_580400
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
  var valid_580401 = query.getOrDefault("fields")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "fields", valid_580401
  var valid_580402 = query.getOrDefault("quotaUser")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "quotaUser", valid_580402
  var valid_580403 = query.getOrDefault("alt")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = newJString("json"))
  if valid_580403 != nil:
    section.add "alt", valid_580403
  var valid_580404 = query.getOrDefault("oauth_token")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = nil)
  if valid_580404 != nil:
    section.add "oauth_token", valid_580404
  var valid_580405 = query.getOrDefault("userIp")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = nil)
  if valid_580405 != nil:
    section.add "userIp", valid_580405
  var valid_580406 = query.getOrDefault("key")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = nil)
  if valid_580406 != nil:
    section.add "key", valid_580406
  var valid_580407 = query.getOrDefault("prettyPrint")
  valid_580407 = validateParameter(valid_580407, JBool, required = false,
                                 default = newJBool(true))
  if valid_580407 != nil:
    section.add "prettyPrint", valid_580407
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580408: Call_TagmanagerAccountsContainersTriggersList_580396;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all GTM Triggers of a Container.
  ## 
  let valid = call_580408.validator(path, query, header, formData, body)
  let scheme = call_580408.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580408.url(scheme.get, call_580408.host, call_580408.base,
                         call_580408.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580408, url, valid)

proc call*(call_580409: Call_TagmanagerAccountsContainersTriggersList_580396;
          containerId: string; accountId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersTriggersList
  ## Lists all GTM Triggers of a Container.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580410 = newJObject()
  var query_580411 = newJObject()
  add(path_580410, "containerId", newJString(containerId))
  add(query_580411, "fields", newJString(fields))
  add(query_580411, "quotaUser", newJString(quotaUser))
  add(query_580411, "alt", newJString(alt))
  add(query_580411, "oauth_token", newJString(oauthToken))
  add(path_580410, "accountId", newJString(accountId))
  add(query_580411, "userIp", newJString(userIp))
  add(query_580411, "key", newJString(key))
  add(query_580411, "prettyPrint", newJBool(prettyPrint))
  result = call_580409.call(path_580410, query_580411, nil, nil, nil)

var tagmanagerAccountsContainersTriggersList* = Call_TagmanagerAccountsContainersTriggersList_580396(
    name: "tagmanagerAccountsContainersTriggersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/triggers",
    validator: validate_TagmanagerAccountsContainersTriggersList_580397,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTriggersList_580398,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTriggersUpdate_580447 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersTriggersUpdate_580449(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  assert "triggerId" in path, "`triggerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersTriggersUpdate_580448(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a GTM Trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  ##   triggerId: JString (required)
  ##            : The GTM Trigger ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580450 = path.getOrDefault("containerId")
  valid_580450 = validateParameter(valid_580450, JString, required = true,
                                 default = nil)
  if valid_580450 != nil:
    section.add "containerId", valid_580450
  var valid_580451 = path.getOrDefault("accountId")
  valid_580451 = validateParameter(valid_580451, JString, required = true,
                                 default = nil)
  if valid_580451 != nil:
    section.add "accountId", valid_580451
  var valid_580452 = path.getOrDefault("triggerId")
  valid_580452 = validateParameter(valid_580452, JString, required = true,
                                 default = nil)
  if valid_580452 != nil:
    section.add "triggerId", valid_580452
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   fingerprint: JString
  ##              : When provided, this fingerprint must match the fingerprint of the trigger in storage.
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
  var valid_580453 = query.getOrDefault("fields")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = nil)
  if valid_580453 != nil:
    section.add "fields", valid_580453
  var valid_580454 = query.getOrDefault("fingerprint")
  valid_580454 = validateParameter(valid_580454, JString, required = false,
                                 default = nil)
  if valid_580454 != nil:
    section.add "fingerprint", valid_580454
  var valid_580455 = query.getOrDefault("quotaUser")
  valid_580455 = validateParameter(valid_580455, JString, required = false,
                                 default = nil)
  if valid_580455 != nil:
    section.add "quotaUser", valid_580455
  var valid_580456 = query.getOrDefault("alt")
  valid_580456 = validateParameter(valid_580456, JString, required = false,
                                 default = newJString("json"))
  if valid_580456 != nil:
    section.add "alt", valid_580456
  var valid_580457 = query.getOrDefault("oauth_token")
  valid_580457 = validateParameter(valid_580457, JString, required = false,
                                 default = nil)
  if valid_580457 != nil:
    section.add "oauth_token", valid_580457
  var valid_580458 = query.getOrDefault("userIp")
  valid_580458 = validateParameter(valid_580458, JString, required = false,
                                 default = nil)
  if valid_580458 != nil:
    section.add "userIp", valid_580458
  var valid_580459 = query.getOrDefault("key")
  valid_580459 = validateParameter(valid_580459, JString, required = false,
                                 default = nil)
  if valid_580459 != nil:
    section.add "key", valid_580459
  var valid_580460 = query.getOrDefault("prettyPrint")
  valid_580460 = validateParameter(valid_580460, JBool, required = false,
                                 default = newJBool(true))
  if valid_580460 != nil:
    section.add "prettyPrint", valid_580460
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

proc call*(call_580462: Call_TagmanagerAccountsContainersTriggersUpdate_580447;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a GTM Trigger.
  ## 
  let valid = call_580462.validator(path, query, header, formData, body)
  let scheme = call_580462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580462.url(scheme.get, call_580462.host, call_580462.base,
                         call_580462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580462, url, valid)

proc call*(call_580463: Call_TagmanagerAccountsContainersTriggersUpdate_580447;
          containerId: string; accountId: string; triggerId: string;
          fields: string = ""; fingerprint: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersTriggersUpdate
  ## Updates a GTM Trigger.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   fingerprint: string
  ##              : When provided, this fingerprint must match the fingerprint of the trigger in storage.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   triggerId: string (required)
  ##            : The GTM Trigger ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580464 = newJObject()
  var query_580465 = newJObject()
  var body_580466 = newJObject()
  add(path_580464, "containerId", newJString(containerId))
  add(query_580465, "fields", newJString(fields))
  add(query_580465, "fingerprint", newJString(fingerprint))
  add(query_580465, "quotaUser", newJString(quotaUser))
  add(query_580465, "alt", newJString(alt))
  add(query_580465, "oauth_token", newJString(oauthToken))
  add(path_580464, "accountId", newJString(accountId))
  add(query_580465, "userIp", newJString(userIp))
  add(path_580464, "triggerId", newJString(triggerId))
  add(query_580465, "key", newJString(key))
  if body != nil:
    body_580466 = body
  add(query_580465, "prettyPrint", newJBool(prettyPrint))
  result = call_580463.call(path_580464, query_580465, nil, nil, body_580466)

var tagmanagerAccountsContainersTriggersUpdate* = Call_TagmanagerAccountsContainersTriggersUpdate_580447(
    name: "tagmanagerAccountsContainersTriggersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/triggers/{triggerId}",
    validator: validate_TagmanagerAccountsContainersTriggersUpdate_580448,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTriggersUpdate_580449,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTriggersGet_580430 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersTriggersGet_580432(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  assert "triggerId" in path, "`triggerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersTriggersGet_580431(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a GTM Trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  ##   triggerId: JString (required)
  ##            : The GTM Trigger ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580433 = path.getOrDefault("containerId")
  valid_580433 = validateParameter(valid_580433, JString, required = true,
                                 default = nil)
  if valid_580433 != nil:
    section.add "containerId", valid_580433
  var valid_580434 = path.getOrDefault("accountId")
  valid_580434 = validateParameter(valid_580434, JString, required = true,
                                 default = nil)
  if valid_580434 != nil:
    section.add "accountId", valid_580434
  var valid_580435 = path.getOrDefault("triggerId")
  valid_580435 = validateParameter(valid_580435, JString, required = true,
                                 default = nil)
  if valid_580435 != nil:
    section.add "triggerId", valid_580435
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

proc call*(call_580443: Call_TagmanagerAccountsContainersTriggersGet_580430;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a GTM Trigger.
  ## 
  let valid = call_580443.validator(path, query, header, formData, body)
  let scheme = call_580443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580443.url(scheme.get, call_580443.host, call_580443.base,
                         call_580443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580443, url, valid)

proc call*(call_580444: Call_TagmanagerAccountsContainersTriggersGet_580430;
          containerId: string; accountId: string; triggerId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersTriggersGet
  ## Gets a GTM Trigger.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   triggerId: string (required)
  ##            : The GTM Trigger ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580445 = newJObject()
  var query_580446 = newJObject()
  add(path_580445, "containerId", newJString(containerId))
  add(query_580446, "fields", newJString(fields))
  add(query_580446, "quotaUser", newJString(quotaUser))
  add(query_580446, "alt", newJString(alt))
  add(query_580446, "oauth_token", newJString(oauthToken))
  add(path_580445, "accountId", newJString(accountId))
  add(query_580446, "userIp", newJString(userIp))
  add(path_580445, "triggerId", newJString(triggerId))
  add(query_580446, "key", newJString(key))
  add(query_580446, "prettyPrint", newJBool(prettyPrint))
  result = call_580444.call(path_580445, query_580446, nil, nil, nil)

var tagmanagerAccountsContainersTriggersGet* = Call_TagmanagerAccountsContainersTriggersGet_580430(
    name: "tagmanagerAccountsContainersTriggersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/triggers/{triggerId}",
    validator: validate_TagmanagerAccountsContainersTriggersGet_580431,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTriggersGet_580432,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTriggersDelete_580467 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersTriggersDelete_580469(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  assert "triggerId" in path, "`triggerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersTriggersDelete_580468(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a GTM Trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  ##   triggerId: JString (required)
  ##            : The GTM Trigger ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580470 = path.getOrDefault("containerId")
  valid_580470 = validateParameter(valid_580470, JString, required = true,
                                 default = nil)
  if valid_580470 != nil:
    section.add "containerId", valid_580470
  var valid_580471 = path.getOrDefault("accountId")
  valid_580471 = validateParameter(valid_580471, JString, required = true,
                                 default = nil)
  if valid_580471 != nil:
    section.add "accountId", valid_580471
  var valid_580472 = path.getOrDefault("triggerId")
  valid_580472 = validateParameter(valid_580472, JString, required = true,
                                 default = nil)
  if valid_580472 != nil:
    section.add "triggerId", valid_580472
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
  var valid_580473 = query.getOrDefault("fields")
  valid_580473 = validateParameter(valid_580473, JString, required = false,
                                 default = nil)
  if valid_580473 != nil:
    section.add "fields", valid_580473
  var valid_580474 = query.getOrDefault("quotaUser")
  valid_580474 = validateParameter(valid_580474, JString, required = false,
                                 default = nil)
  if valid_580474 != nil:
    section.add "quotaUser", valid_580474
  var valid_580475 = query.getOrDefault("alt")
  valid_580475 = validateParameter(valid_580475, JString, required = false,
                                 default = newJString("json"))
  if valid_580475 != nil:
    section.add "alt", valid_580475
  var valid_580476 = query.getOrDefault("oauth_token")
  valid_580476 = validateParameter(valid_580476, JString, required = false,
                                 default = nil)
  if valid_580476 != nil:
    section.add "oauth_token", valid_580476
  var valid_580477 = query.getOrDefault("userIp")
  valid_580477 = validateParameter(valid_580477, JString, required = false,
                                 default = nil)
  if valid_580477 != nil:
    section.add "userIp", valid_580477
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580480: Call_TagmanagerAccountsContainersTriggersDelete_580467;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a GTM Trigger.
  ## 
  let valid = call_580480.validator(path, query, header, formData, body)
  let scheme = call_580480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580480.url(scheme.get, call_580480.host, call_580480.base,
                         call_580480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580480, url, valid)

proc call*(call_580481: Call_TagmanagerAccountsContainersTriggersDelete_580467;
          containerId: string; accountId: string; triggerId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersTriggersDelete
  ## Deletes a GTM Trigger.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   triggerId: string (required)
  ##            : The GTM Trigger ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580482 = newJObject()
  var query_580483 = newJObject()
  add(path_580482, "containerId", newJString(containerId))
  add(query_580483, "fields", newJString(fields))
  add(query_580483, "quotaUser", newJString(quotaUser))
  add(query_580483, "alt", newJString(alt))
  add(query_580483, "oauth_token", newJString(oauthToken))
  add(path_580482, "accountId", newJString(accountId))
  add(query_580483, "userIp", newJString(userIp))
  add(path_580482, "triggerId", newJString(triggerId))
  add(query_580483, "key", newJString(key))
  add(query_580483, "prettyPrint", newJBool(prettyPrint))
  result = call_580481.call(path_580482, query_580483, nil, nil, nil)

var tagmanagerAccountsContainersTriggersDelete* = Call_TagmanagerAccountsContainersTriggersDelete_580467(
    name: "tagmanagerAccountsContainersTriggersDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/triggers/{triggerId}",
    validator: validate_TagmanagerAccountsContainersTriggersDelete_580468,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTriggersDelete_580469,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVariablesCreate_580500 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersVariablesCreate_580502(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/variables")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersVariablesCreate_580501(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a GTM Variable.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580503 = path.getOrDefault("containerId")
  valid_580503 = validateParameter(valid_580503, JString, required = true,
                                 default = nil)
  if valid_580503 != nil:
    section.add "containerId", valid_580503
  var valid_580504 = path.getOrDefault("accountId")
  valid_580504 = validateParameter(valid_580504, JString, required = true,
                                 default = nil)
  if valid_580504 != nil:
    section.add "accountId", valid_580504
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
  var valid_580505 = query.getOrDefault("fields")
  valid_580505 = validateParameter(valid_580505, JString, required = false,
                                 default = nil)
  if valid_580505 != nil:
    section.add "fields", valid_580505
  var valid_580506 = query.getOrDefault("quotaUser")
  valid_580506 = validateParameter(valid_580506, JString, required = false,
                                 default = nil)
  if valid_580506 != nil:
    section.add "quotaUser", valid_580506
  var valid_580507 = query.getOrDefault("alt")
  valid_580507 = validateParameter(valid_580507, JString, required = false,
                                 default = newJString("json"))
  if valid_580507 != nil:
    section.add "alt", valid_580507
  var valid_580508 = query.getOrDefault("oauth_token")
  valid_580508 = validateParameter(valid_580508, JString, required = false,
                                 default = nil)
  if valid_580508 != nil:
    section.add "oauth_token", valid_580508
  var valid_580509 = query.getOrDefault("userIp")
  valid_580509 = validateParameter(valid_580509, JString, required = false,
                                 default = nil)
  if valid_580509 != nil:
    section.add "userIp", valid_580509
  var valid_580510 = query.getOrDefault("key")
  valid_580510 = validateParameter(valid_580510, JString, required = false,
                                 default = nil)
  if valid_580510 != nil:
    section.add "key", valid_580510
  var valid_580511 = query.getOrDefault("prettyPrint")
  valid_580511 = validateParameter(valid_580511, JBool, required = false,
                                 default = newJBool(true))
  if valid_580511 != nil:
    section.add "prettyPrint", valid_580511
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

proc call*(call_580513: Call_TagmanagerAccountsContainersVariablesCreate_580500;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a GTM Variable.
  ## 
  let valid = call_580513.validator(path, query, header, formData, body)
  let scheme = call_580513.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580513.url(scheme.get, call_580513.host, call_580513.base,
                         call_580513.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580513, url, valid)

proc call*(call_580514: Call_TagmanagerAccountsContainersVariablesCreate_580500;
          containerId: string; accountId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersVariablesCreate
  ## Creates a GTM Variable.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580515 = newJObject()
  var query_580516 = newJObject()
  var body_580517 = newJObject()
  add(path_580515, "containerId", newJString(containerId))
  add(query_580516, "fields", newJString(fields))
  add(query_580516, "quotaUser", newJString(quotaUser))
  add(query_580516, "alt", newJString(alt))
  add(query_580516, "oauth_token", newJString(oauthToken))
  add(path_580515, "accountId", newJString(accountId))
  add(query_580516, "userIp", newJString(userIp))
  add(query_580516, "key", newJString(key))
  if body != nil:
    body_580517 = body
  add(query_580516, "prettyPrint", newJBool(prettyPrint))
  result = call_580514.call(path_580515, query_580516, nil, nil, body_580517)

var tagmanagerAccountsContainersVariablesCreate* = Call_TagmanagerAccountsContainersVariablesCreate_580500(
    name: "tagmanagerAccountsContainersVariablesCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/variables",
    validator: validate_TagmanagerAccountsContainersVariablesCreate_580501,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVariablesCreate_580502,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVariablesList_580484 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersVariablesList_580486(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/variables")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersVariablesList_580485(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all GTM Variables of a Container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580487 = path.getOrDefault("containerId")
  valid_580487 = validateParameter(valid_580487, JString, required = true,
                                 default = nil)
  if valid_580487 != nil:
    section.add "containerId", valid_580487
  var valid_580488 = path.getOrDefault("accountId")
  valid_580488 = validateParameter(valid_580488, JString, required = true,
                                 default = nil)
  if valid_580488 != nil:
    section.add "accountId", valid_580488
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
  var valid_580489 = query.getOrDefault("fields")
  valid_580489 = validateParameter(valid_580489, JString, required = false,
                                 default = nil)
  if valid_580489 != nil:
    section.add "fields", valid_580489
  var valid_580490 = query.getOrDefault("quotaUser")
  valid_580490 = validateParameter(valid_580490, JString, required = false,
                                 default = nil)
  if valid_580490 != nil:
    section.add "quotaUser", valid_580490
  var valid_580491 = query.getOrDefault("alt")
  valid_580491 = validateParameter(valid_580491, JString, required = false,
                                 default = newJString("json"))
  if valid_580491 != nil:
    section.add "alt", valid_580491
  var valid_580492 = query.getOrDefault("oauth_token")
  valid_580492 = validateParameter(valid_580492, JString, required = false,
                                 default = nil)
  if valid_580492 != nil:
    section.add "oauth_token", valid_580492
  var valid_580493 = query.getOrDefault("userIp")
  valid_580493 = validateParameter(valid_580493, JString, required = false,
                                 default = nil)
  if valid_580493 != nil:
    section.add "userIp", valid_580493
  var valid_580494 = query.getOrDefault("key")
  valid_580494 = validateParameter(valid_580494, JString, required = false,
                                 default = nil)
  if valid_580494 != nil:
    section.add "key", valid_580494
  var valid_580495 = query.getOrDefault("prettyPrint")
  valid_580495 = validateParameter(valid_580495, JBool, required = false,
                                 default = newJBool(true))
  if valid_580495 != nil:
    section.add "prettyPrint", valid_580495
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580496: Call_TagmanagerAccountsContainersVariablesList_580484;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all GTM Variables of a Container.
  ## 
  let valid = call_580496.validator(path, query, header, formData, body)
  let scheme = call_580496.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580496.url(scheme.get, call_580496.host, call_580496.base,
                         call_580496.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580496, url, valid)

proc call*(call_580497: Call_TagmanagerAccountsContainersVariablesList_580484;
          containerId: string; accountId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersVariablesList
  ## Lists all GTM Variables of a Container.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580498 = newJObject()
  var query_580499 = newJObject()
  add(path_580498, "containerId", newJString(containerId))
  add(query_580499, "fields", newJString(fields))
  add(query_580499, "quotaUser", newJString(quotaUser))
  add(query_580499, "alt", newJString(alt))
  add(query_580499, "oauth_token", newJString(oauthToken))
  add(path_580498, "accountId", newJString(accountId))
  add(query_580499, "userIp", newJString(userIp))
  add(query_580499, "key", newJString(key))
  add(query_580499, "prettyPrint", newJBool(prettyPrint))
  result = call_580497.call(path_580498, query_580499, nil, nil, nil)

var tagmanagerAccountsContainersVariablesList* = Call_TagmanagerAccountsContainersVariablesList_580484(
    name: "tagmanagerAccountsContainersVariablesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/variables",
    validator: validate_TagmanagerAccountsContainersVariablesList_580485,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVariablesList_580486,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVariablesUpdate_580535 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersVariablesUpdate_580537(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  assert "variableId" in path, "`variableId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/variables/"),
               (kind: VariableSegment, value: "variableId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersVariablesUpdate_580536(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a GTM Variable.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   variableId: JString (required)
  ##             : The GTM Variable ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580538 = path.getOrDefault("containerId")
  valid_580538 = validateParameter(valid_580538, JString, required = true,
                                 default = nil)
  if valid_580538 != nil:
    section.add "containerId", valid_580538
  var valid_580539 = path.getOrDefault("variableId")
  valid_580539 = validateParameter(valid_580539, JString, required = true,
                                 default = nil)
  if valid_580539 != nil:
    section.add "variableId", valid_580539
  var valid_580540 = path.getOrDefault("accountId")
  valid_580540 = validateParameter(valid_580540, JString, required = true,
                                 default = nil)
  if valid_580540 != nil:
    section.add "accountId", valid_580540
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   fingerprint: JString
  ##              : When provided, this fingerprint must match the fingerprint of the variable in storage.
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
  var valid_580541 = query.getOrDefault("fields")
  valid_580541 = validateParameter(valid_580541, JString, required = false,
                                 default = nil)
  if valid_580541 != nil:
    section.add "fields", valid_580541
  var valid_580542 = query.getOrDefault("fingerprint")
  valid_580542 = validateParameter(valid_580542, JString, required = false,
                                 default = nil)
  if valid_580542 != nil:
    section.add "fingerprint", valid_580542
  var valid_580543 = query.getOrDefault("quotaUser")
  valid_580543 = validateParameter(valid_580543, JString, required = false,
                                 default = nil)
  if valid_580543 != nil:
    section.add "quotaUser", valid_580543
  var valid_580544 = query.getOrDefault("alt")
  valid_580544 = validateParameter(valid_580544, JString, required = false,
                                 default = newJString("json"))
  if valid_580544 != nil:
    section.add "alt", valid_580544
  var valid_580545 = query.getOrDefault("oauth_token")
  valid_580545 = validateParameter(valid_580545, JString, required = false,
                                 default = nil)
  if valid_580545 != nil:
    section.add "oauth_token", valid_580545
  var valid_580546 = query.getOrDefault("userIp")
  valid_580546 = validateParameter(valid_580546, JString, required = false,
                                 default = nil)
  if valid_580546 != nil:
    section.add "userIp", valid_580546
  var valid_580547 = query.getOrDefault("key")
  valid_580547 = validateParameter(valid_580547, JString, required = false,
                                 default = nil)
  if valid_580547 != nil:
    section.add "key", valid_580547
  var valid_580548 = query.getOrDefault("prettyPrint")
  valid_580548 = validateParameter(valid_580548, JBool, required = false,
                                 default = newJBool(true))
  if valid_580548 != nil:
    section.add "prettyPrint", valid_580548
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

proc call*(call_580550: Call_TagmanagerAccountsContainersVariablesUpdate_580535;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a GTM Variable.
  ## 
  let valid = call_580550.validator(path, query, header, formData, body)
  let scheme = call_580550.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580550.url(scheme.get, call_580550.host, call_580550.base,
                         call_580550.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580550, url, valid)

proc call*(call_580551: Call_TagmanagerAccountsContainersVariablesUpdate_580535;
          containerId: string; variableId: string; accountId: string;
          fields: string = ""; fingerprint: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersVariablesUpdate
  ## Updates a GTM Variable.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   fingerprint: string
  ##              : When provided, this fingerprint must match the fingerprint of the variable in storage.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   variableId: string (required)
  ##             : The GTM Variable ID.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580552 = newJObject()
  var query_580553 = newJObject()
  var body_580554 = newJObject()
  add(path_580552, "containerId", newJString(containerId))
  add(query_580553, "fields", newJString(fields))
  add(query_580553, "fingerprint", newJString(fingerprint))
  add(query_580553, "quotaUser", newJString(quotaUser))
  add(query_580553, "alt", newJString(alt))
  add(path_580552, "variableId", newJString(variableId))
  add(query_580553, "oauth_token", newJString(oauthToken))
  add(path_580552, "accountId", newJString(accountId))
  add(query_580553, "userIp", newJString(userIp))
  add(query_580553, "key", newJString(key))
  if body != nil:
    body_580554 = body
  add(query_580553, "prettyPrint", newJBool(prettyPrint))
  result = call_580551.call(path_580552, query_580553, nil, nil, body_580554)

var tagmanagerAccountsContainersVariablesUpdate* = Call_TagmanagerAccountsContainersVariablesUpdate_580535(
    name: "tagmanagerAccountsContainersVariablesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/variables/{variableId}",
    validator: validate_TagmanagerAccountsContainersVariablesUpdate_580536,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVariablesUpdate_580537,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVariablesGet_580518 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersVariablesGet_580520(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  assert "variableId" in path, "`variableId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/variables/"),
               (kind: VariableSegment, value: "variableId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersVariablesGet_580519(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a GTM Variable.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   variableId: JString (required)
  ##             : The GTM Variable ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580521 = path.getOrDefault("containerId")
  valid_580521 = validateParameter(valid_580521, JString, required = true,
                                 default = nil)
  if valid_580521 != nil:
    section.add "containerId", valid_580521
  var valid_580522 = path.getOrDefault("variableId")
  valid_580522 = validateParameter(valid_580522, JString, required = true,
                                 default = nil)
  if valid_580522 != nil:
    section.add "variableId", valid_580522
  var valid_580523 = path.getOrDefault("accountId")
  valid_580523 = validateParameter(valid_580523, JString, required = true,
                                 default = nil)
  if valid_580523 != nil:
    section.add "accountId", valid_580523
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
  var valid_580527 = query.getOrDefault("oauth_token")
  valid_580527 = validateParameter(valid_580527, JString, required = false,
                                 default = nil)
  if valid_580527 != nil:
    section.add "oauth_token", valid_580527
  var valid_580528 = query.getOrDefault("userIp")
  valid_580528 = validateParameter(valid_580528, JString, required = false,
                                 default = nil)
  if valid_580528 != nil:
    section.add "userIp", valid_580528
  var valid_580529 = query.getOrDefault("key")
  valid_580529 = validateParameter(valid_580529, JString, required = false,
                                 default = nil)
  if valid_580529 != nil:
    section.add "key", valid_580529
  var valid_580530 = query.getOrDefault("prettyPrint")
  valid_580530 = validateParameter(valid_580530, JBool, required = false,
                                 default = newJBool(true))
  if valid_580530 != nil:
    section.add "prettyPrint", valid_580530
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580531: Call_TagmanagerAccountsContainersVariablesGet_580518;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a GTM Variable.
  ## 
  let valid = call_580531.validator(path, query, header, formData, body)
  let scheme = call_580531.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580531.url(scheme.get, call_580531.host, call_580531.base,
                         call_580531.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580531, url, valid)

proc call*(call_580532: Call_TagmanagerAccountsContainersVariablesGet_580518;
          containerId: string; variableId: string; accountId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersVariablesGet
  ## Gets a GTM Variable.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   variableId: string (required)
  ##             : The GTM Variable ID.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580533 = newJObject()
  var query_580534 = newJObject()
  add(path_580533, "containerId", newJString(containerId))
  add(query_580534, "fields", newJString(fields))
  add(query_580534, "quotaUser", newJString(quotaUser))
  add(query_580534, "alt", newJString(alt))
  add(path_580533, "variableId", newJString(variableId))
  add(query_580534, "oauth_token", newJString(oauthToken))
  add(path_580533, "accountId", newJString(accountId))
  add(query_580534, "userIp", newJString(userIp))
  add(query_580534, "key", newJString(key))
  add(query_580534, "prettyPrint", newJBool(prettyPrint))
  result = call_580532.call(path_580533, query_580534, nil, nil, nil)

var tagmanagerAccountsContainersVariablesGet* = Call_TagmanagerAccountsContainersVariablesGet_580518(
    name: "tagmanagerAccountsContainersVariablesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/variables/{variableId}",
    validator: validate_TagmanagerAccountsContainersVariablesGet_580519,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVariablesGet_580520,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVariablesDelete_580555 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersVariablesDelete_580557(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  assert "variableId" in path, "`variableId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/variables/"),
               (kind: VariableSegment, value: "variableId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersVariablesDelete_580556(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a GTM Variable.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   variableId: JString (required)
  ##             : The GTM Variable ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580558 = path.getOrDefault("containerId")
  valid_580558 = validateParameter(valid_580558, JString, required = true,
                                 default = nil)
  if valid_580558 != nil:
    section.add "containerId", valid_580558
  var valid_580559 = path.getOrDefault("variableId")
  valid_580559 = validateParameter(valid_580559, JString, required = true,
                                 default = nil)
  if valid_580559 != nil:
    section.add "variableId", valid_580559
  var valid_580560 = path.getOrDefault("accountId")
  valid_580560 = validateParameter(valid_580560, JString, required = true,
                                 default = nil)
  if valid_580560 != nil:
    section.add "accountId", valid_580560
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
  var valid_580561 = query.getOrDefault("fields")
  valid_580561 = validateParameter(valid_580561, JString, required = false,
                                 default = nil)
  if valid_580561 != nil:
    section.add "fields", valid_580561
  var valid_580562 = query.getOrDefault("quotaUser")
  valid_580562 = validateParameter(valid_580562, JString, required = false,
                                 default = nil)
  if valid_580562 != nil:
    section.add "quotaUser", valid_580562
  var valid_580563 = query.getOrDefault("alt")
  valid_580563 = validateParameter(valid_580563, JString, required = false,
                                 default = newJString("json"))
  if valid_580563 != nil:
    section.add "alt", valid_580563
  var valid_580564 = query.getOrDefault("oauth_token")
  valid_580564 = validateParameter(valid_580564, JString, required = false,
                                 default = nil)
  if valid_580564 != nil:
    section.add "oauth_token", valid_580564
  var valid_580565 = query.getOrDefault("userIp")
  valid_580565 = validateParameter(valid_580565, JString, required = false,
                                 default = nil)
  if valid_580565 != nil:
    section.add "userIp", valid_580565
  var valid_580566 = query.getOrDefault("key")
  valid_580566 = validateParameter(valid_580566, JString, required = false,
                                 default = nil)
  if valid_580566 != nil:
    section.add "key", valid_580566
  var valid_580567 = query.getOrDefault("prettyPrint")
  valid_580567 = validateParameter(valid_580567, JBool, required = false,
                                 default = newJBool(true))
  if valid_580567 != nil:
    section.add "prettyPrint", valid_580567
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580568: Call_TagmanagerAccountsContainersVariablesDelete_580555;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a GTM Variable.
  ## 
  let valid = call_580568.validator(path, query, header, formData, body)
  let scheme = call_580568.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580568.url(scheme.get, call_580568.host, call_580568.base,
                         call_580568.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580568, url, valid)

proc call*(call_580569: Call_TagmanagerAccountsContainersVariablesDelete_580555;
          containerId: string; variableId: string; accountId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersVariablesDelete
  ## Deletes a GTM Variable.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   variableId: string (required)
  ##             : The GTM Variable ID.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580570 = newJObject()
  var query_580571 = newJObject()
  add(path_580570, "containerId", newJString(containerId))
  add(query_580571, "fields", newJString(fields))
  add(query_580571, "quotaUser", newJString(quotaUser))
  add(query_580571, "alt", newJString(alt))
  add(path_580570, "variableId", newJString(variableId))
  add(query_580571, "oauth_token", newJString(oauthToken))
  add(path_580570, "accountId", newJString(accountId))
  add(query_580571, "userIp", newJString(userIp))
  add(query_580571, "key", newJString(key))
  add(query_580571, "prettyPrint", newJBool(prettyPrint))
  result = call_580569.call(path_580570, query_580571, nil, nil, nil)

var tagmanagerAccountsContainersVariablesDelete* = Call_TagmanagerAccountsContainersVariablesDelete_580555(
    name: "tagmanagerAccountsContainersVariablesDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/variables/{variableId}",
    validator: validate_TagmanagerAccountsContainersVariablesDelete_580556,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVariablesDelete_580557,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsCreate_580590 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersVersionsCreate_580592(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersVersionsCreate_580591(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a Container Version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580593 = path.getOrDefault("containerId")
  valid_580593 = validateParameter(valid_580593, JString, required = true,
                                 default = nil)
  if valid_580593 != nil:
    section.add "containerId", valid_580593
  var valid_580594 = path.getOrDefault("accountId")
  valid_580594 = validateParameter(valid_580594, JString, required = true,
                                 default = nil)
  if valid_580594 != nil:
    section.add "accountId", valid_580594
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
  var valid_580595 = query.getOrDefault("fields")
  valid_580595 = validateParameter(valid_580595, JString, required = false,
                                 default = nil)
  if valid_580595 != nil:
    section.add "fields", valid_580595
  var valid_580596 = query.getOrDefault("quotaUser")
  valid_580596 = validateParameter(valid_580596, JString, required = false,
                                 default = nil)
  if valid_580596 != nil:
    section.add "quotaUser", valid_580596
  var valid_580597 = query.getOrDefault("alt")
  valid_580597 = validateParameter(valid_580597, JString, required = false,
                                 default = newJString("json"))
  if valid_580597 != nil:
    section.add "alt", valid_580597
  var valid_580598 = query.getOrDefault("oauth_token")
  valid_580598 = validateParameter(valid_580598, JString, required = false,
                                 default = nil)
  if valid_580598 != nil:
    section.add "oauth_token", valid_580598
  var valid_580599 = query.getOrDefault("userIp")
  valid_580599 = validateParameter(valid_580599, JString, required = false,
                                 default = nil)
  if valid_580599 != nil:
    section.add "userIp", valid_580599
  var valid_580600 = query.getOrDefault("key")
  valid_580600 = validateParameter(valid_580600, JString, required = false,
                                 default = nil)
  if valid_580600 != nil:
    section.add "key", valid_580600
  var valid_580601 = query.getOrDefault("prettyPrint")
  valid_580601 = validateParameter(valid_580601, JBool, required = false,
                                 default = newJBool(true))
  if valid_580601 != nil:
    section.add "prettyPrint", valid_580601
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

proc call*(call_580603: Call_TagmanagerAccountsContainersVersionsCreate_580590;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Container Version.
  ## 
  let valid = call_580603.validator(path, query, header, formData, body)
  let scheme = call_580603.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580603.url(scheme.get, call_580603.host, call_580603.base,
                         call_580603.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580603, url, valid)

proc call*(call_580604: Call_TagmanagerAccountsContainersVersionsCreate_580590;
          containerId: string; accountId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersVersionsCreate
  ## Creates a Container Version.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580605 = newJObject()
  var query_580606 = newJObject()
  var body_580607 = newJObject()
  add(path_580605, "containerId", newJString(containerId))
  add(query_580606, "fields", newJString(fields))
  add(query_580606, "quotaUser", newJString(quotaUser))
  add(query_580606, "alt", newJString(alt))
  add(query_580606, "oauth_token", newJString(oauthToken))
  add(path_580605, "accountId", newJString(accountId))
  add(query_580606, "userIp", newJString(userIp))
  add(query_580606, "key", newJString(key))
  if body != nil:
    body_580607 = body
  add(query_580606, "prettyPrint", newJBool(prettyPrint))
  result = call_580604.call(path_580605, query_580606, nil, nil, body_580607)

var tagmanagerAccountsContainersVersionsCreate* = Call_TagmanagerAccountsContainersVersionsCreate_580590(
    name: "tagmanagerAccountsContainersVersionsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/versions",
    validator: validate_TagmanagerAccountsContainersVersionsCreate_580591,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsCreate_580592,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsList_580572 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersVersionsList_580574(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersVersionsList_580573(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all Container Versions of a GTM Container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580575 = path.getOrDefault("containerId")
  valid_580575 = validateParameter(valid_580575, JString, required = true,
                                 default = nil)
  if valid_580575 != nil:
    section.add "containerId", valid_580575
  var valid_580576 = path.getOrDefault("accountId")
  valid_580576 = validateParameter(valid_580576, JString, required = true,
                                 default = nil)
  if valid_580576 != nil:
    section.add "accountId", valid_580576
  result.add "path", section
  ## parameters in `query` object:
  ##   headers: JBool
  ##          : Retrieve headers only when true.
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
  ##   includeDeleted: JBool
  ##                 : Also retrieve deleted (archived) versions when true.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580577 = query.getOrDefault("headers")
  valid_580577 = validateParameter(valid_580577, JBool, required = false,
                                 default = newJBool(false))
  if valid_580577 != nil:
    section.add "headers", valid_580577
  var valid_580578 = query.getOrDefault("fields")
  valid_580578 = validateParameter(valid_580578, JString, required = false,
                                 default = nil)
  if valid_580578 != nil:
    section.add "fields", valid_580578
  var valid_580579 = query.getOrDefault("quotaUser")
  valid_580579 = validateParameter(valid_580579, JString, required = false,
                                 default = nil)
  if valid_580579 != nil:
    section.add "quotaUser", valid_580579
  var valid_580580 = query.getOrDefault("alt")
  valid_580580 = validateParameter(valid_580580, JString, required = false,
                                 default = newJString("json"))
  if valid_580580 != nil:
    section.add "alt", valid_580580
  var valid_580581 = query.getOrDefault("oauth_token")
  valid_580581 = validateParameter(valid_580581, JString, required = false,
                                 default = nil)
  if valid_580581 != nil:
    section.add "oauth_token", valid_580581
  var valid_580582 = query.getOrDefault("userIp")
  valid_580582 = validateParameter(valid_580582, JString, required = false,
                                 default = nil)
  if valid_580582 != nil:
    section.add "userIp", valid_580582
  var valid_580583 = query.getOrDefault("key")
  valid_580583 = validateParameter(valid_580583, JString, required = false,
                                 default = nil)
  if valid_580583 != nil:
    section.add "key", valid_580583
  var valid_580584 = query.getOrDefault("includeDeleted")
  valid_580584 = validateParameter(valid_580584, JBool, required = false,
                                 default = newJBool(false))
  if valid_580584 != nil:
    section.add "includeDeleted", valid_580584
  var valid_580585 = query.getOrDefault("prettyPrint")
  valid_580585 = validateParameter(valid_580585, JBool, required = false,
                                 default = newJBool(true))
  if valid_580585 != nil:
    section.add "prettyPrint", valid_580585
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580586: Call_TagmanagerAccountsContainersVersionsList_580572;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all Container Versions of a GTM Container.
  ## 
  let valid = call_580586.validator(path, query, header, formData, body)
  let scheme = call_580586.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580586.url(scheme.get, call_580586.host, call_580586.base,
                         call_580586.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580586, url, valid)

proc call*(call_580587: Call_TagmanagerAccountsContainersVersionsList_580572;
          containerId: string; accountId: string; headers: bool = false;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          includeDeleted: bool = false; prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersVersionsList
  ## Lists all Container Versions of a GTM Container.
  ##   headers: bool
  ##          : Retrieve headers only when true.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeDeleted: bool
  ##                 : Also retrieve deleted (archived) versions when true.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580588 = newJObject()
  var query_580589 = newJObject()
  add(query_580589, "headers", newJBool(headers))
  add(path_580588, "containerId", newJString(containerId))
  add(query_580589, "fields", newJString(fields))
  add(query_580589, "quotaUser", newJString(quotaUser))
  add(query_580589, "alt", newJString(alt))
  add(query_580589, "oauth_token", newJString(oauthToken))
  add(path_580588, "accountId", newJString(accountId))
  add(query_580589, "userIp", newJString(userIp))
  add(query_580589, "key", newJString(key))
  add(query_580589, "includeDeleted", newJBool(includeDeleted))
  add(query_580589, "prettyPrint", newJBool(prettyPrint))
  result = call_580587.call(path_580588, query_580589, nil, nil, nil)

var tagmanagerAccountsContainersVersionsList* = Call_TagmanagerAccountsContainersVersionsList_580572(
    name: "tagmanagerAccountsContainersVersionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/versions",
    validator: validate_TagmanagerAccountsContainersVersionsList_580573,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsList_580574,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsUpdate_580625 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersVersionsUpdate_580627(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  assert "containerVersionId" in path,
        "`containerVersionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "containerVersionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersVersionsUpdate_580626(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a Container Version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  ##   containerVersionId: JString (required)
  ##                     : The GTM Container Version ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580628 = path.getOrDefault("containerId")
  valid_580628 = validateParameter(valid_580628, JString, required = true,
                                 default = nil)
  if valid_580628 != nil:
    section.add "containerId", valid_580628
  var valid_580629 = path.getOrDefault("accountId")
  valid_580629 = validateParameter(valid_580629, JString, required = true,
                                 default = nil)
  if valid_580629 != nil:
    section.add "accountId", valid_580629
  var valid_580630 = path.getOrDefault("containerVersionId")
  valid_580630 = validateParameter(valid_580630, JString, required = true,
                                 default = nil)
  if valid_580630 != nil:
    section.add "containerVersionId", valid_580630
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   fingerprint: JString
  ##              : When provided, this fingerprint must match the fingerprint of the container version in storage.
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
  var valid_580631 = query.getOrDefault("fields")
  valid_580631 = validateParameter(valid_580631, JString, required = false,
                                 default = nil)
  if valid_580631 != nil:
    section.add "fields", valid_580631
  var valid_580632 = query.getOrDefault("fingerprint")
  valid_580632 = validateParameter(valid_580632, JString, required = false,
                                 default = nil)
  if valid_580632 != nil:
    section.add "fingerprint", valid_580632
  var valid_580633 = query.getOrDefault("quotaUser")
  valid_580633 = validateParameter(valid_580633, JString, required = false,
                                 default = nil)
  if valid_580633 != nil:
    section.add "quotaUser", valid_580633
  var valid_580634 = query.getOrDefault("alt")
  valid_580634 = validateParameter(valid_580634, JString, required = false,
                                 default = newJString("json"))
  if valid_580634 != nil:
    section.add "alt", valid_580634
  var valid_580635 = query.getOrDefault("oauth_token")
  valid_580635 = validateParameter(valid_580635, JString, required = false,
                                 default = nil)
  if valid_580635 != nil:
    section.add "oauth_token", valid_580635
  var valid_580636 = query.getOrDefault("userIp")
  valid_580636 = validateParameter(valid_580636, JString, required = false,
                                 default = nil)
  if valid_580636 != nil:
    section.add "userIp", valid_580636
  var valid_580637 = query.getOrDefault("key")
  valid_580637 = validateParameter(valid_580637, JString, required = false,
                                 default = nil)
  if valid_580637 != nil:
    section.add "key", valid_580637
  var valid_580638 = query.getOrDefault("prettyPrint")
  valid_580638 = validateParameter(valid_580638, JBool, required = false,
                                 default = newJBool(true))
  if valid_580638 != nil:
    section.add "prettyPrint", valid_580638
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

proc call*(call_580640: Call_TagmanagerAccountsContainersVersionsUpdate_580625;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a Container Version.
  ## 
  let valid = call_580640.validator(path, query, header, formData, body)
  let scheme = call_580640.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580640.url(scheme.get, call_580640.host, call_580640.base,
                         call_580640.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580640, url, valid)

proc call*(call_580641: Call_TagmanagerAccountsContainersVersionsUpdate_580625;
          containerId: string; accountId: string; containerVersionId: string;
          fields: string = ""; fingerprint: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersVersionsUpdate
  ## Updates a Container Version.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   fingerprint: string
  ##              : When provided, this fingerprint must match the fingerprint of the container version in storage.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   containerVersionId: string (required)
  ##                     : The GTM Container Version ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580642 = newJObject()
  var query_580643 = newJObject()
  var body_580644 = newJObject()
  add(path_580642, "containerId", newJString(containerId))
  add(query_580643, "fields", newJString(fields))
  add(query_580643, "fingerprint", newJString(fingerprint))
  add(query_580643, "quotaUser", newJString(quotaUser))
  add(query_580643, "alt", newJString(alt))
  add(query_580643, "oauth_token", newJString(oauthToken))
  add(path_580642, "accountId", newJString(accountId))
  add(query_580643, "userIp", newJString(userIp))
  add(path_580642, "containerVersionId", newJString(containerVersionId))
  add(query_580643, "key", newJString(key))
  if body != nil:
    body_580644 = body
  add(query_580643, "prettyPrint", newJBool(prettyPrint))
  result = call_580641.call(path_580642, query_580643, nil, nil, body_580644)

var tagmanagerAccountsContainersVersionsUpdate* = Call_TagmanagerAccountsContainersVersionsUpdate_580625(
    name: "tagmanagerAccountsContainersVersionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/versions/{containerVersionId}",
    validator: validate_TagmanagerAccountsContainersVersionsUpdate_580626,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsUpdate_580627,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsGet_580608 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersVersionsGet_580610(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  assert "containerVersionId" in path,
        "`containerVersionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "containerVersionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersVersionsGet_580609(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a Container Version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  ##   containerVersionId: JString (required)
  ##                     : The GTM Container Version ID. Specify published to retrieve the currently published version.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580611 = path.getOrDefault("containerId")
  valid_580611 = validateParameter(valid_580611, JString, required = true,
                                 default = nil)
  if valid_580611 != nil:
    section.add "containerId", valid_580611
  var valid_580612 = path.getOrDefault("accountId")
  valid_580612 = validateParameter(valid_580612, JString, required = true,
                                 default = nil)
  if valid_580612 != nil:
    section.add "accountId", valid_580612
  var valid_580613 = path.getOrDefault("containerVersionId")
  valid_580613 = validateParameter(valid_580613, JString, required = true,
                                 default = nil)
  if valid_580613 != nil:
    section.add "containerVersionId", valid_580613
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
  var valid_580614 = query.getOrDefault("fields")
  valid_580614 = validateParameter(valid_580614, JString, required = false,
                                 default = nil)
  if valid_580614 != nil:
    section.add "fields", valid_580614
  var valid_580615 = query.getOrDefault("quotaUser")
  valid_580615 = validateParameter(valid_580615, JString, required = false,
                                 default = nil)
  if valid_580615 != nil:
    section.add "quotaUser", valid_580615
  var valid_580616 = query.getOrDefault("alt")
  valid_580616 = validateParameter(valid_580616, JString, required = false,
                                 default = newJString("json"))
  if valid_580616 != nil:
    section.add "alt", valid_580616
  var valid_580617 = query.getOrDefault("oauth_token")
  valid_580617 = validateParameter(valid_580617, JString, required = false,
                                 default = nil)
  if valid_580617 != nil:
    section.add "oauth_token", valid_580617
  var valid_580618 = query.getOrDefault("userIp")
  valid_580618 = validateParameter(valid_580618, JString, required = false,
                                 default = nil)
  if valid_580618 != nil:
    section.add "userIp", valid_580618
  var valid_580619 = query.getOrDefault("key")
  valid_580619 = validateParameter(valid_580619, JString, required = false,
                                 default = nil)
  if valid_580619 != nil:
    section.add "key", valid_580619
  var valid_580620 = query.getOrDefault("prettyPrint")
  valid_580620 = validateParameter(valid_580620, JBool, required = false,
                                 default = newJBool(true))
  if valid_580620 != nil:
    section.add "prettyPrint", valid_580620
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580621: Call_TagmanagerAccountsContainersVersionsGet_580608;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a Container Version.
  ## 
  let valid = call_580621.validator(path, query, header, formData, body)
  let scheme = call_580621.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580621.url(scheme.get, call_580621.host, call_580621.base,
                         call_580621.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580621, url, valid)

proc call*(call_580622: Call_TagmanagerAccountsContainersVersionsGet_580608;
          containerId: string; accountId: string; containerVersionId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersVersionsGet
  ## Gets a Container Version.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   containerVersionId: string (required)
  ##                     : The GTM Container Version ID. Specify published to retrieve the currently published version.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580623 = newJObject()
  var query_580624 = newJObject()
  add(path_580623, "containerId", newJString(containerId))
  add(query_580624, "fields", newJString(fields))
  add(query_580624, "quotaUser", newJString(quotaUser))
  add(query_580624, "alt", newJString(alt))
  add(query_580624, "oauth_token", newJString(oauthToken))
  add(path_580623, "accountId", newJString(accountId))
  add(query_580624, "userIp", newJString(userIp))
  add(path_580623, "containerVersionId", newJString(containerVersionId))
  add(query_580624, "key", newJString(key))
  add(query_580624, "prettyPrint", newJBool(prettyPrint))
  result = call_580622.call(path_580623, query_580624, nil, nil, nil)

var tagmanagerAccountsContainersVersionsGet* = Call_TagmanagerAccountsContainersVersionsGet_580608(
    name: "tagmanagerAccountsContainersVersionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/versions/{containerVersionId}",
    validator: validate_TagmanagerAccountsContainersVersionsGet_580609,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsGet_580610,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsDelete_580645 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersVersionsDelete_580647(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  assert "containerVersionId" in path,
        "`containerVersionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "containerVersionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersVersionsDelete_580646(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a Container Version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  ##   containerVersionId: JString (required)
  ##                     : The GTM Container Version ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580648 = path.getOrDefault("containerId")
  valid_580648 = validateParameter(valid_580648, JString, required = true,
                                 default = nil)
  if valid_580648 != nil:
    section.add "containerId", valid_580648
  var valid_580649 = path.getOrDefault("accountId")
  valid_580649 = validateParameter(valid_580649, JString, required = true,
                                 default = nil)
  if valid_580649 != nil:
    section.add "accountId", valid_580649
  var valid_580650 = path.getOrDefault("containerVersionId")
  valid_580650 = validateParameter(valid_580650, JString, required = true,
                                 default = nil)
  if valid_580650 != nil:
    section.add "containerVersionId", valid_580650
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
  var valid_580651 = query.getOrDefault("fields")
  valid_580651 = validateParameter(valid_580651, JString, required = false,
                                 default = nil)
  if valid_580651 != nil:
    section.add "fields", valid_580651
  var valid_580652 = query.getOrDefault("quotaUser")
  valid_580652 = validateParameter(valid_580652, JString, required = false,
                                 default = nil)
  if valid_580652 != nil:
    section.add "quotaUser", valid_580652
  var valid_580653 = query.getOrDefault("alt")
  valid_580653 = validateParameter(valid_580653, JString, required = false,
                                 default = newJString("json"))
  if valid_580653 != nil:
    section.add "alt", valid_580653
  var valid_580654 = query.getOrDefault("oauth_token")
  valid_580654 = validateParameter(valid_580654, JString, required = false,
                                 default = nil)
  if valid_580654 != nil:
    section.add "oauth_token", valid_580654
  var valid_580655 = query.getOrDefault("userIp")
  valid_580655 = validateParameter(valid_580655, JString, required = false,
                                 default = nil)
  if valid_580655 != nil:
    section.add "userIp", valid_580655
  var valid_580656 = query.getOrDefault("key")
  valid_580656 = validateParameter(valid_580656, JString, required = false,
                                 default = nil)
  if valid_580656 != nil:
    section.add "key", valid_580656
  var valid_580657 = query.getOrDefault("prettyPrint")
  valid_580657 = validateParameter(valid_580657, JBool, required = false,
                                 default = newJBool(true))
  if valid_580657 != nil:
    section.add "prettyPrint", valid_580657
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580658: Call_TagmanagerAccountsContainersVersionsDelete_580645;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a Container Version.
  ## 
  let valid = call_580658.validator(path, query, header, formData, body)
  let scheme = call_580658.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580658.url(scheme.get, call_580658.host, call_580658.base,
                         call_580658.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580658, url, valid)

proc call*(call_580659: Call_TagmanagerAccountsContainersVersionsDelete_580645;
          containerId: string; accountId: string; containerVersionId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersVersionsDelete
  ## Deletes a Container Version.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   containerVersionId: string (required)
  ##                     : The GTM Container Version ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580660 = newJObject()
  var query_580661 = newJObject()
  add(path_580660, "containerId", newJString(containerId))
  add(query_580661, "fields", newJString(fields))
  add(query_580661, "quotaUser", newJString(quotaUser))
  add(query_580661, "alt", newJString(alt))
  add(query_580661, "oauth_token", newJString(oauthToken))
  add(path_580660, "accountId", newJString(accountId))
  add(query_580661, "userIp", newJString(userIp))
  add(path_580660, "containerVersionId", newJString(containerVersionId))
  add(query_580661, "key", newJString(key))
  add(query_580661, "prettyPrint", newJBool(prettyPrint))
  result = call_580659.call(path_580660, query_580661, nil, nil, nil)

var tagmanagerAccountsContainersVersionsDelete* = Call_TagmanagerAccountsContainersVersionsDelete_580645(
    name: "tagmanagerAccountsContainersVersionsDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/versions/{containerVersionId}",
    validator: validate_TagmanagerAccountsContainersVersionsDelete_580646,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsDelete_580647,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsPublish_580662 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersVersionsPublish_580664(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  assert "containerVersionId" in path,
        "`containerVersionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "containerVersionId"),
               (kind: ConstantSegment, value: "/publish")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersVersionsPublish_580663(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Publishes a Container Version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  ##   containerVersionId: JString (required)
  ##                     : The GTM Container Version ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580665 = path.getOrDefault("containerId")
  valid_580665 = validateParameter(valid_580665, JString, required = true,
                                 default = nil)
  if valid_580665 != nil:
    section.add "containerId", valid_580665
  var valid_580666 = path.getOrDefault("accountId")
  valid_580666 = validateParameter(valid_580666, JString, required = true,
                                 default = nil)
  if valid_580666 != nil:
    section.add "accountId", valid_580666
  var valid_580667 = path.getOrDefault("containerVersionId")
  valid_580667 = validateParameter(valid_580667, JString, required = true,
                                 default = nil)
  if valid_580667 != nil:
    section.add "containerVersionId", valid_580667
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   fingerprint: JString
  ##              : When provided, this fingerprint must match the fingerprint of the container version in storage.
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
  var valid_580668 = query.getOrDefault("fields")
  valid_580668 = validateParameter(valid_580668, JString, required = false,
                                 default = nil)
  if valid_580668 != nil:
    section.add "fields", valid_580668
  var valid_580669 = query.getOrDefault("fingerprint")
  valid_580669 = validateParameter(valid_580669, JString, required = false,
                                 default = nil)
  if valid_580669 != nil:
    section.add "fingerprint", valid_580669
  var valid_580670 = query.getOrDefault("quotaUser")
  valid_580670 = validateParameter(valid_580670, JString, required = false,
                                 default = nil)
  if valid_580670 != nil:
    section.add "quotaUser", valid_580670
  var valid_580671 = query.getOrDefault("alt")
  valid_580671 = validateParameter(valid_580671, JString, required = false,
                                 default = newJString("json"))
  if valid_580671 != nil:
    section.add "alt", valid_580671
  var valid_580672 = query.getOrDefault("oauth_token")
  valid_580672 = validateParameter(valid_580672, JString, required = false,
                                 default = nil)
  if valid_580672 != nil:
    section.add "oauth_token", valid_580672
  var valid_580673 = query.getOrDefault("userIp")
  valid_580673 = validateParameter(valid_580673, JString, required = false,
                                 default = nil)
  if valid_580673 != nil:
    section.add "userIp", valid_580673
  var valid_580674 = query.getOrDefault("key")
  valid_580674 = validateParameter(valid_580674, JString, required = false,
                                 default = nil)
  if valid_580674 != nil:
    section.add "key", valid_580674
  var valid_580675 = query.getOrDefault("prettyPrint")
  valid_580675 = validateParameter(valid_580675, JBool, required = false,
                                 default = newJBool(true))
  if valid_580675 != nil:
    section.add "prettyPrint", valid_580675
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580676: Call_TagmanagerAccountsContainersVersionsPublish_580662;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Publishes a Container Version.
  ## 
  let valid = call_580676.validator(path, query, header, formData, body)
  let scheme = call_580676.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580676.url(scheme.get, call_580676.host, call_580676.base,
                         call_580676.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580676, url, valid)

proc call*(call_580677: Call_TagmanagerAccountsContainersVersionsPublish_580662;
          containerId: string; accountId: string; containerVersionId: string;
          fields: string = ""; fingerprint: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersVersionsPublish
  ## Publishes a Container Version.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   fingerprint: string
  ##              : When provided, this fingerprint must match the fingerprint of the container version in storage.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   containerVersionId: string (required)
  ##                     : The GTM Container Version ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580678 = newJObject()
  var query_580679 = newJObject()
  add(path_580678, "containerId", newJString(containerId))
  add(query_580679, "fields", newJString(fields))
  add(query_580679, "fingerprint", newJString(fingerprint))
  add(query_580679, "quotaUser", newJString(quotaUser))
  add(query_580679, "alt", newJString(alt))
  add(query_580679, "oauth_token", newJString(oauthToken))
  add(path_580678, "accountId", newJString(accountId))
  add(query_580679, "userIp", newJString(userIp))
  add(path_580678, "containerVersionId", newJString(containerVersionId))
  add(query_580679, "key", newJString(key))
  add(query_580679, "prettyPrint", newJBool(prettyPrint))
  result = call_580677.call(path_580678, query_580679, nil, nil, nil)

var tagmanagerAccountsContainersVersionsPublish* = Call_TagmanagerAccountsContainersVersionsPublish_580662(
    name: "tagmanagerAccountsContainersVersionsPublish",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/versions/{containerVersionId}/publish",
    validator: validate_TagmanagerAccountsContainersVersionsPublish_580663,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsPublish_580664,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsRestore_580680 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersVersionsRestore_580682(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  assert "containerVersionId" in path,
        "`containerVersionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "containerVersionId"),
               (kind: ConstantSegment, value: "/restore")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersVersionsRestore_580681(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Restores a Container Version. This will overwrite the container's current configuration (including its variables, triggers and tags). The operation will not have any effect on the version that is being served (i.e. the published version).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  ##   containerVersionId: JString (required)
  ##                     : The GTM Container Version ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580683 = path.getOrDefault("containerId")
  valid_580683 = validateParameter(valid_580683, JString, required = true,
                                 default = nil)
  if valid_580683 != nil:
    section.add "containerId", valid_580683
  var valid_580684 = path.getOrDefault("accountId")
  valid_580684 = validateParameter(valid_580684, JString, required = true,
                                 default = nil)
  if valid_580684 != nil:
    section.add "accountId", valid_580684
  var valid_580685 = path.getOrDefault("containerVersionId")
  valid_580685 = validateParameter(valid_580685, JString, required = true,
                                 default = nil)
  if valid_580685 != nil:
    section.add "containerVersionId", valid_580685
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
  var valid_580686 = query.getOrDefault("fields")
  valid_580686 = validateParameter(valid_580686, JString, required = false,
                                 default = nil)
  if valid_580686 != nil:
    section.add "fields", valid_580686
  var valid_580687 = query.getOrDefault("quotaUser")
  valid_580687 = validateParameter(valid_580687, JString, required = false,
                                 default = nil)
  if valid_580687 != nil:
    section.add "quotaUser", valid_580687
  var valid_580688 = query.getOrDefault("alt")
  valid_580688 = validateParameter(valid_580688, JString, required = false,
                                 default = newJString("json"))
  if valid_580688 != nil:
    section.add "alt", valid_580688
  var valid_580689 = query.getOrDefault("oauth_token")
  valid_580689 = validateParameter(valid_580689, JString, required = false,
                                 default = nil)
  if valid_580689 != nil:
    section.add "oauth_token", valid_580689
  var valid_580690 = query.getOrDefault("userIp")
  valid_580690 = validateParameter(valid_580690, JString, required = false,
                                 default = nil)
  if valid_580690 != nil:
    section.add "userIp", valid_580690
  var valid_580691 = query.getOrDefault("key")
  valid_580691 = validateParameter(valid_580691, JString, required = false,
                                 default = nil)
  if valid_580691 != nil:
    section.add "key", valid_580691
  var valid_580692 = query.getOrDefault("prettyPrint")
  valid_580692 = validateParameter(valid_580692, JBool, required = false,
                                 default = newJBool(true))
  if valid_580692 != nil:
    section.add "prettyPrint", valid_580692
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580693: Call_TagmanagerAccountsContainersVersionsRestore_580680;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Restores a Container Version. This will overwrite the container's current configuration (including its variables, triggers and tags). The operation will not have any effect on the version that is being served (i.e. the published version).
  ## 
  let valid = call_580693.validator(path, query, header, formData, body)
  let scheme = call_580693.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580693.url(scheme.get, call_580693.host, call_580693.base,
                         call_580693.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580693, url, valid)

proc call*(call_580694: Call_TagmanagerAccountsContainersVersionsRestore_580680;
          containerId: string; accountId: string; containerVersionId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersVersionsRestore
  ## Restores a Container Version. This will overwrite the container's current configuration (including its variables, triggers and tags). The operation will not have any effect on the version that is being served (i.e. the published version).
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   containerVersionId: string (required)
  ##                     : The GTM Container Version ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580695 = newJObject()
  var query_580696 = newJObject()
  add(path_580695, "containerId", newJString(containerId))
  add(query_580696, "fields", newJString(fields))
  add(query_580696, "quotaUser", newJString(quotaUser))
  add(query_580696, "alt", newJString(alt))
  add(query_580696, "oauth_token", newJString(oauthToken))
  add(path_580695, "accountId", newJString(accountId))
  add(query_580696, "userIp", newJString(userIp))
  add(path_580695, "containerVersionId", newJString(containerVersionId))
  add(query_580696, "key", newJString(key))
  add(query_580696, "prettyPrint", newJBool(prettyPrint))
  result = call_580694.call(path_580695, query_580696, nil, nil, nil)

var tagmanagerAccountsContainersVersionsRestore* = Call_TagmanagerAccountsContainersVersionsRestore_580680(
    name: "tagmanagerAccountsContainersVersionsRestore",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/versions/{containerVersionId}/restore",
    validator: validate_TagmanagerAccountsContainersVersionsRestore_580681,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsRestore_580682,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsUndelete_580697 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsContainersVersionsUndelete_580699(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "containerId" in path, "`containerId` is a required path parameter"
  assert "containerVersionId" in path,
        "`containerVersionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "containerVersionId"),
               (kind: ConstantSegment, value: "/undelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsContainersVersionsUndelete_580698(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Undeletes a Container Version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  ##   containerVersionId: JString (required)
  ##                     : The GTM Container Version ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_580700 = path.getOrDefault("containerId")
  valid_580700 = validateParameter(valid_580700, JString, required = true,
                                 default = nil)
  if valid_580700 != nil:
    section.add "containerId", valid_580700
  var valid_580701 = path.getOrDefault("accountId")
  valid_580701 = validateParameter(valid_580701, JString, required = true,
                                 default = nil)
  if valid_580701 != nil:
    section.add "accountId", valid_580701
  var valid_580702 = path.getOrDefault("containerVersionId")
  valid_580702 = validateParameter(valid_580702, JString, required = true,
                                 default = nil)
  if valid_580702 != nil:
    section.add "containerVersionId", valid_580702
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
  var valid_580703 = query.getOrDefault("fields")
  valid_580703 = validateParameter(valid_580703, JString, required = false,
                                 default = nil)
  if valid_580703 != nil:
    section.add "fields", valid_580703
  var valid_580704 = query.getOrDefault("quotaUser")
  valid_580704 = validateParameter(valid_580704, JString, required = false,
                                 default = nil)
  if valid_580704 != nil:
    section.add "quotaUser", valid_580704
  var valid_580705 = query.getOrDefault("alt")
  valid_580705 = validateParameter(valid_580705, JString, required = false,
                                 default = newJString("json"))
  if valid_580705 != nil:
    section.add "alt", valid_580705
  var valid_580706 = query.getOrDefault("oauth_token")
  valid_580706 = validateParameter(valid_580706, JString, required = false,
                                 default = nil)
  if valid_580706 != nil:
    section.add "oauth_token", valid_580706
  var valid_580707 = query.getOrDefault("userIp")
  valid_580707 = validateParameter(valid_580707, JString, required = false,
                                 default = nil)
  if valid_580707 != nil:
    section.add "userIp", valid_580707
  var valid_580708 = query.getOrDefault("key")
  valid_580708 = validateParameter(valid_580708, JString, required = false,
                                 default = nil)
  if valid_580708 != nil:
    section.add "key", valid_580708
  var valid_580709 = query.getOrDefault("prettyPrint")
  valid_580709 = validateParameter(valid_580709, JBool, required = false,
                                 default = newJBool(true))
  if valid_580709 != nil:
    section.add "prettyPrint", valid_580709
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580710: Call_TagmanagerAccountsContainersVersionsUndelete_580697;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Undeletes a Container Version.
  ## 
  let valid = call_580710.validator(path, query, header, formData, body)
  let scheme = call_580710.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580710.url(scheme.get, call_580710.host, call_580710.base,
                         call_580710.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580710, url, valid)

proc call*(call_580711: Call_TagmanagerAccountsContainersVersionsUndelete_580697;
          containerId: string; accountId: string; containerVersionId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsContainersVersionsUndelete
  ## Undeletes a Container Version.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   containerVersionId: string (required)
  ##                     : The GTM Container Version ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580712 = newJObject()
  var query_580713 = newJObject()
  add(path_580712, "containerId", newJString(containerId))
  add(query_580713, "fields", newJString(fields))
  add(query_580713, "quotaUser", newJString(quotaUser))
  add(query_580713, "alt", newJString(alt))
  add(query_580713, "oauth_token", newJString(oauthToken))
  add(path_580712, "accountId", newJString(accountId))
  add(query_580713, "userIp", newJString(userIp))
  add(path_580712, "containerVersionId", newJString(containerVersionId))
  add(query_580713, "key", newJString(key))
  add(query_580713, "prettyPrint", newJBool(prettyPrint))
  result = call_580711.call(path_580712, query_580713, nil, nil, nil)

var tagmanagerAccountsContainersVersionsUndelete* = Call_TagmanagerAccountsContainersVersionsUndelete_580697(
    name: "tagmanagerAccountsContainersVersionsUndelete",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/versions/{containerVersionId}/undelete",
    validator: validate_TagmanagerAccountsContainersVersionsUndelete_580698,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsUndelete_580699,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsPermissionsCreate_580729 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsPermissionsCreate_580731(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/permissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsPermissionsCreate_580730(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a user's Account & Container Permissions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580732 = path.getOrDefault("accountId")
  valid_580732 = validateParameter(valid_580732, JString, required = true,
                                 default = nil)
  if valid_580732 != nil:
    section.add "accountId", valid_580732
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
  var valid_580733 = query.getOrDefault("fields")
  valid_580733 = validateParameter(valid_580733, JString, required = false,
                                 default = nil)
  if valid_580733 != nil:
    section.add "fields", valid_580733
  var valid_580734 = query.getOrDefault("quotaUser")
  valid_580734 = validateParameter(valid_580734, JString, required = false,
                                 default = nil)
  if valid_580734 != nil:
    section.add "quotaUser", valid_580734
  var valid_580735 = query.getOrDefault("alt")
  valid_580735 = validateParameter(valid_580735, JString, required = false,
                                 default = newJString("json"))
  if valid_580735 != nil:
    section.add "alt", valid_580735
  var valid_580736 = query.getOrDefault("oauth_token")
  valid_580736 = validateParameter(valid_580736, JString, required = false,
                                 default = nil)
  if valid_580736 != nil:
    section.add "oauth_token", valid_580736
  var valid_580737 = query.getOrDefault("userIp")
  valid_580737 = validateParameter(valid_580737, JString, required = false,
                                 default = nil)
  if valid_580737 != nil:
    section.add "userIp", valid_580737
  var valid_580738 = query.getOrDefault("key")
  valid_580738 = validateParameter(valid_580738, JString, required = false,
                                 default = nil)
  if valid_580738 != nil:
    section.add "key", valid_580738
  var valid_580739 = query.getOrDefault("prettyPrint")
  valid_580739 = validateParameter(valid_580739, JBool, required = false,
                                 default = newJBool(true))
  if valid_580739 != nil:
    section.add "prettyPrint", valid_580739
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

proc call*(call_580741: Call_TagmanagerAccountsPermissionsCreate_580729;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a user's Account & Container Permissions.
  ## 
  let valid = call_580741.validator(path, query, header, formData, body)
  let scheme = call_580741.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580741.url(scheme.get, call_580741.host, call_580741.base,
                         call_580741.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580741, url, valid)

proc call*(call_580742: Call_TagmanagerAccountsPermissionsCreate_580729;
          accountId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsPermissionsCreate
  ## Creates a user's Account & Container Permissions.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580743 = newJObject()
  var query_580744 = newJObject()
  var body_580745 = newJObject()
  add(query_580744, "fields", newJString(fields))
  add(query_580744, "quotaUser", newJString(quotaUser))
  add(query_580744, "alt", newJString(alt))
  add(query_580744, "oauth_token", newJString(oauthToken))
  add(path_580743, "accountId", newJString(accountId))
  add(query_580744, "userIp", newJString(userIp))
  add(query_580744, "key", newJString(key))
  if body != nil:
    body_580745 = body
  add(query_580744, "prettyPrint", newJBool(prettyPrint))
  result = call_580742.call(path_580743, query_580744, nil, nil, body_580745)

var tagmanagerAccountsPermissionsCreate* = Call_TagmanagerAccountsPermissionsCreate_580729(
    name: "tagmanagerAccountsPermissionsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accounts/{accountId}/permissions",
    validator: validate_TagmanagerAccountsPermissionsCreate_580730,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsPermissionsCreate_580731,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsPermissionsList_580714 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsPermissionsList_580716(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/permissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsPermissionsList_580715(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all users that have access to the account along with Account and Container Permissions granted to each of them.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The GTM Account ID. @required tagmanager.accounts.permissions.list
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580717 = path.getOrDefault("accountId")
  valid_580717 = validateParameter(valid_580717, JString, required = true,
                                 default = nil)
  if valid_580717 != nil:
    section.add "accountId", valid_580717
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
  var valid_580718 = query.getOrDefault("fields")
  valid_580718 = validateParameter(valid_580718, JString, required = false,
                                 default = nil)
  if valid_580718 != nil:
    section.add "fields", valid_580718
  var valid_580719 = query.getOrDefault("quotaUser")
  valid_580719 = validateParameter(valid_580719, JString, required = false,
                                 default = nil)
  if valid_580719 != nil:
    section.add "quotaUser", valid_580719
  var valid_580720 = query.getOrDefault("alt")
  valid_580720 = validateParameter(valid_580720, JString, required = false,
                                 default = newJString("json"))
  if valid_580720 != nil:
    section.add "alt", valid_580720
  var valid_580721 = query.getOrDefault("oauth_token")
  valid_580721 = validateParameter(valid_580721, JString, required = false,
                                 default = nil)
  if valid_580721 != nil:
    section.add "oauth_token", valid_580721
  var valid_580722 = query.getOrDefault("userIp")
  valid_580722 = validateParameter(valid_580722, JString, required = false,
                                 default = nil)
  if valid_580722 != nil:
    section.add "userIp", valid_580722
  var valid_580723 = query.getOrDefault("key")
  valid_580723 = validateParameter(valid_580723, JString, required = false,
                                 default = nil)
  if valid_580723 != nil:
    section.add "key", valid_580723
  var valid_580724 = query.getOrDefault("prettyPrint")
  valid_580724 = validateParameter(valid_580724, JBool, required = false,
                                 default = newJBool(true))
  if valid_580724 != nil:
    section.add "prettyPrint", valid_580724
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580725: Call_TagmanagerAccountsPermissionsList_580714;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all users that have access to the account along with Account and Container Permissions granted to each of them.
  ## 
  let valid = call_580725.validator(path, query, header, formData, body)
  let scheme = call_580725.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580725.url(scheme.get, call_580725.host, call_580725.base,
                         call_580725.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580725, url, valid)

proc call*(call_580726: Call_TagmanagerAccountsPermissionsList_580714;
          accountId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsPermissionsList
  ## List all users that have access to the account along with Account and Container Permissions granted to each of them.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID. @required tagmanager.accounts.permissions.list
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580727 = newJObject()
  var query_580728 = newJObject()
  add(query_580728, "fields", newJString(fields))
  add(query_580728, "quotaUser", newJString(quotaUser))
  add(query_580728, "alt", newJString(alt))
  add(query_580728, "oauth_token", newJString(oauthToken))
  add(path_580727, "accountId", newJString(accountId))
  add(query_580728, "userIp", newJString(userIp))
  add(query_580728, "key", newJString(key))
  add(query_580728, "prettyPrint", newJBool(prettyPrint))
  result = call_580726.call(path_580727, query_580728, nil, nil, nil)

var tagmanagerAccountsPermissionsList* = Call_TagmanagerAccountsPermissionsList_580714(
    name: "tagmanagerAccountsPermissionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/permissions",
    validator: validate_TagmanagerAccountsPermissionsList_580715,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsPermissionsList_580716,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsPermissionsUpdate_580762 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsPermissionsUpdate_580764(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "permissionId" in path, "`permissionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/permissions/"),
               (kind: VariableSegment, value: "permissionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsPermissionsUpdate_580763(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a user's Account & Container Permissions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  ##   permissionId: JString (required)
  ##               : The GTM User ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580765 = path.getOrDefault("accountId")
  valid_580765 = validateParameter(valid_580765, JString, required = true,
                                 default = nil)
  if valid_580765 != nil:
    section.add "accountId", valid_580765
  var valid_580766 = path.getOrDefault("permissionId")
  valid_580766 = validateParameter(valid_580766, JString, required = true,
                                 default = nil)
  if valid_580766 != nil:
    section.add "permissionId", valid_580766
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
  var valid_580767 = query.getOrDefault("fields")
  valid_580767 = validateParameter(valid_580767, JString, required = false,
                                 default = nil)
  if valid_580767 != nil:
    section.add "fields", valid_580767
  var valid_580768 = query.getOrDefault("quotaUser")
  valid_580768 = validateParameter(valid_580768, JString, required = false,
                                 default = nil)
  if valid_580768 != nil:
    section.add "quotaUser", valid_580768
  var valid_580769 = query.getOrDefault("alt")
  valid_580769 = validateParameter(valid_580769, JString, required = false,
                                 default = newJString("json"))
  if valid_580769 != nil:
    section.add "alt", valid_580769
  var valid_580770 = query.getOrDefault("oauth_token")
  valid_580770 = validateParameter(valid_580770, JString, required = false,
                                 default = nil)
  if valid_580770 != nil:
    section.add "oauth_token", valid_580770
  var valid_580771 = query.getOrDefault("userIp")
  valid_580771 = validateParameter(valid_580771, JString, required = false,
                                 default = nil)
  if valid_580771 != nil:
    section.add "userIp", valid_580771
  var valid_580772 = query.getOrDefault("key")
  valid_580772 = validateParameter(valid_580772, JString, required = false,
                                 default = nil)
  if valid_580772 != nil:
    section.add "key", valid_580772
  var valid_580773 = query.getOrDefault("prettyPrint")
  valid_580773 = validateParameter(valid_580773, JBool, required = false,
                                 default = newJBool(true))
  if valid_580773 != nil:
    section.add "prettyPrint", valid_580773
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

proc call*(call_580775: Call_TagmanagerAccountsPermissionsUpdate_580762;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a user's Account & Container Permissions.
  ## 
  let valid = call_580775.validator(path, query, header, formData, body)
  let scheme = call_580775.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580775.url(scheme.get, call_580775.host, call_580775.base,
                         call_580775.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580775, url, valid)

proc call*(call_580776: Call_TagmanagerAccountsPermissionsUpdate_580762;
          accountId: string; permissionId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsPermissionsUpdate
  ## Updates a user's Account & Container Permissions.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   permissionId: string (required)
  ##               : The GTM User ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580777 = newJObject()
  var query_580778 = newJObject()
  var body_580779 = newJObject()
  add(query_580778, "fields", newJString(fields))
  add(query_580778, "quotaUser", newJString(quotaUser))
  add(query_580778, "alt", newJString(alt))
  add(query_580778, "oauth_token", newJString(oauthToken))
  add(path_580777, "accountId", newJString(accountId))
  add(path_580777, "permissionId", newJString(permissionId))
  add(query_580778, "userIp", newJString(userIp))
  add(query_580778, "key", newJString(key))
  if body != nil:
    body_580779 = body
  add(query_580778, "prettyPrint", newJBool(prettyPrint))
  result = call_580776.call(path_580777, query_580778, nil, nil, body_580779)

var tagmanagerAccountsPermissionsUpdate* = Call_TagmanagerAccountsPermissionsUpdate_580762(
    name: "tagmanagerAccountsPermissionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/permissions/{permissionId}",
    validator: validate_TagmanagerAccountsPermissionsUpdate_580763,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsPermissionsUpdate_580764,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsPermissionsGet_580746 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsPermissionsGet_580748(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "permissionId" in path, "`permissionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/permissions/"),
               (kind: VariableSegment, value: "permissionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsPermissionsGet_580747(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a user's Account & Container Permissions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  ##   permissionId: JString (required)
  ##               : The GTM User ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580749 = path.getOrDefault("accountId")
  valid_580749 = validateParameter(valid_580749, JString, required = true,
                                 default = nil)
  if valid_580749 != nil:
    section.add "accountId", valid_580749
  var valid_580750 = path.getOrDefault("permissionId")
  valid_580750 = validateParameter(valid_580750, JString, required = true,
                                 default = nil)
  if valid_580750 != nil:
    section.add "permissionId", valid_580750
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
  var valid_580751 = query.getOrDefault("fields")
  valid_580751 = validateParameter(valid_580751, JString, required = false,
                                 default = nil)
  if valid_580751 != nil:
    section.add "fields", valid_580751
  var valid_580752 = query.getOrDefault("quotaUser")
  valid_580752 = validateParameter(valid_580752, JString, required = false,
                                 default = nil)
  if valid_580752 != nil:
    section.add "quotaUser", valid_580752
  var valid_580753 = query.getOrDefault("alt")
  valid_580753 = validateParameter(valid_580753, JString, required = false,
                                 default = newJString("json"))
  if valid_580753 != nil:
    section.add "alt", valid_580753
  var valid_580754 = query.getOrDefault("oauth_token")
  valid_580754 = validateParameter(valid_580754, JString, required = false,
                                 default = nil)
  if valid_580754 != nil:
    section.add "oauth_token", valid_580754
  var valid_580755 = query.getOrDefault("userIp")
  valid_580755 = validateParameter(valid_580755, JString, required = false,
                                 default = nil)
  if valid_580755 != nil:
    section.add "userIp", valid_580755
  var valid_580756 = query.getOrDefault("key")
  valid_580756 = validateParameter(valid_580756, JString, required = false,
                                 default = nil)
  if valid_580756 != nil:
    section.add "key", valid_580756
  var valid_580757 = query.getOrDefault("prettyPrint")
  valid_580757 = validateParameter(valid_580757, JBool, required = false,
                                 default = newJBool(true))
  if valid_580757 != nil:
    section.add "prettyPrint", valid_580757
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580758: Call_TagmanagerAccountsPermissionsGet_580746;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a user's Account & Container Permissions.
  ## 
  let valid = call_580758.validator(path, query, header, formData, body)
  let scheme = call_580758.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580758.url(scheme.get, call_580758.host, call_580758.base,
                         call_580758.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580758, url, valid)

proc call*(call_580759: Call_TagmanagerAccountsPermissionsGet_580746;
          accountId: string; permissionId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsPermissionsGet
  ## Gets a user's Account & Container Permissions.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   permissionId: string (required)
  ##               : The GTM User ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580760 = newJObject()
  var query_580761 = newJObject()
  add(query_580761, "fields", newJString(fields))
  add(query_580761, "quotaUser", newJString(quotaUser))
  add(query_580761, "alt", newJString(alt))
  add(query_580761, "oauth_token", newJString(oauthToken))
  add(path_580760, "accountId", newJString(accountId))
  add(path_580760, "permissionId", newJString(permissionId))
  add(query_580761, "userIp", newJString(userIp))
  add(query_580761, "key", newJString(key))
  add(query_580761, "prettyPrint", newJBool(prettyPrint))
  result = call_580759.call(path_580760, query_580761, nil, nil, nil)

var tagmanagerAccountsPermissionsGet* = Call_TagmanagerAccountsPermissionsGet_580746(
    name: "tagmanagerAccountsPermissionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/permissions/{permissionId}",
    validator: validate_TagmanagerAccountsPermissionsGet_580747,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsPermissionsGet_580748,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsPermissionsDelete_580780 = ref object of OpenApiRestCall_579408
proc url_TagmanagerAccountsPermissionsDelete_580782(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "permissionId" in path, "`permissionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/permissions/"),
               (kind: VariableSegment, value: "permissionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsPermissionsDelete_580781(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a user from the account, revoking access to it and all of its containers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  ##   permissionId: JString (required)
  ##               : The GTM User ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580783 = path.getOrDefault("accountId")
  valid_580783 = validateParameter(valid_580783, JString, required = true,
                                 default = nil)
  if valid_580783 != nil:
    section.add "accountId", valid_580783
  var valid_580784 = path.getOrDefault("permissionId")
  valid_580784 = validateParameter(valid_580784, JString, required = true,
                                 default = nil)
  if valid_580784 != nil:
    section.add "permissionId", valid_580784
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
  var valid_580785 = query.getOrDefault("fields")
  valid_580785 = validateParameter(valid_580785, JString, required = false,
                                 default = nil)
  if valid_580785 != nil:
    section.add "fields", valid_580785
  var valid_580786 = query.getOrDefault("quotaUser")
  valid_580786 = validateParameter(valid_580786, JString, required = false,
                                 default = nil)
  if valid_580786 != nil:
    section.add "quotaUser", valid_580786
  var valid_580787 = query.getOrDefault("alt")
  valid_580787 = validateParameter(valid_580787, JString, required = false,
                                 default = newJString("json"))
  if valid_580787 != nil:
    section.add "alt", valid_580787
  var valid_580788 = query.getOrDefault("oauth_token")
  valid_580788 = validateParameter(valid_580788, JString, required = false,
                                 default = nil)
  if valid_580788 != nil:
    section.add "oauth_token", valid_580788
  var valid_580789 = query.getOrDefault("userIp")
  valid_580789 = validateParameter(valid_580789, JString, required = false,
                                 default = nil)
  if valid_580789 != nil:
    section.add "userIp", valid_580789
  var valid_580790 = query.getOrDefault("key")
  valid_580790 = validateParameter(valid_580790, JString, required = false,
                                 default = nil)
  if valid_580790 != nil:
    section.add "key", valid_580790
  var valid_580791 = query.getOrDefault("prettyPrint")
  valid_580791 = validateParameter(valid_580791, JBool, required = false,
                                 default = newJBool(true))
  if valid_580791 != nil:
    section.add "prettyPrint", valid_580791
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580792: Call_TagmanagerAccountsPermissionsDelete_580780;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a user from the account, revoking access to it and all of its containers.
  ## 
  let valid = call_580792.validator(path, query, header, formData, body)
  let scheme = call_580792.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580792.url(scheme.get, call_580792.host, call_580792.base,
                         call_580792.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580792, url, valid)

proc call*(call_580793: Call_TagmanagerAccountsPermissionsDelete_580780;
          accountId: string; permissionId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## tagmanagerAccountsPermissionsDelete
  ## Removes a user from the account, revoking access to it and all of its containers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   permissionId: string (required)
  ##               : The GTM User ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580794 = newJObject()
  var query_580795 = newJObject()
  add(query_580795, "fields", newJString(fields))
  add(query_580795, "quotaUser", newJString(quotaUser))
  add(query_580795, "alt", newJString(alt))
  add(query_580795, "oauth_token", newJString(oauthToken))
  add(path_580794, "accountId", newJString(accountId))
  add(path_580794, "permissionId", newJString(permissionId))
  add(query_580795, "userIp", newJString(userIp))
  add(query_580795, "key", newJString(key))
  add(query_580795, "prettyPrint", newJBool(prettyPrint))
  result = call_580793.call(path_580794, query_580795, nil, nil, nil)

var tagmanagerAccountsPermissionsDelete* = Call_TagmanagerAccountsPermissionsDelete_580780(
    name: "tagmanagerAccountsPermissionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/permissions/{permissionId}",
    validator: validate_TagmanagerAccountsPermissionsDelete_580781,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsPermissionsDelete_580782,
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
