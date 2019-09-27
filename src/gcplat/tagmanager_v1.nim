
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_TagmanagerAccountsList_593676 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsList_593678(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TagmanagerAccountsList_593677(path: JsonNode; query: JsonNode;
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
  var valid_593790 = query.getOrDefault("fields")
  valid_593790 = validateParameter(valid_593790, JString, required = false,
                                 default = nil)
  if valid_593790 != nil:
    section.add "fields", valid_593790
  var valid_593791 = query.getOrDefault("quotaUser")
  valid_593791 = validateParameter(valid_593791, JString, required = false,
                                 default = nil)
  if valid_593791 != nil:
    section.add "quotaUser", valid_593791
  var valid_593805 = query.getOrDefault("alt")
  valid_593805 = validateParameter(valid_593805, JString, required = false,
                                 default = newJString("json"))
  if valid_593805 != nil:
    section.add "alt", valid_593805
  var valid_593806 = query.getOrDefault("oauth_token")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "oauth_token", valid_593806
  var valid_593807 = query.getOrDefault("userIp")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "userIp", valid_593807
  var valid_593808 = query.getOrDefault("key")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = nil)
  if valid_593808 != nil:
    section.add "key", valid_593808
  var valid_593809 = query.getOrDefault("prettyPrint")
  valid_593809 = validateParameter(valid_593809, JBool, required = false,
                                 default = newJBool(true))
  if valid_593809 != nil:
    section.add "prettyPrint", valid_593809
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593832: Call_TagmanagerAccountsList_593676; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all GTM Accounts that a user has access to.
  ## 
  let valid = call_593832.validator(path, query, header, formData, body)
  let scheme = call_593832.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593832.url(scheme.get, call_593832.host, call_593832.base,
                         call_593832.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593832, url, valid)

proc call*(call_593903: Call_TagmanagerAccountsList_593676; fields: string = "";
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
  var query_593904 = newJObject()
  add(query_593904, "fields", newJString(fields))
  add(query_593904, "quotaUser", newJString(quotaUser))
  add(query_593904, "alt", newJString(alt))
  add(query_593904, "oauth_token", newJString(oauthToken))
  add(query_593904, "userIp", newJString(userIp))
  add(query_593904, "key", newJString(key))
  add(query_593904, "prettyPrint", newJBool(prettyPrint))
  result = call_593903.call(nil, query_593904, nil, nil, nil)

var tagmanagerAccountsList* = Call_TagmanagerAccountsList_593676(
    name: "tagmanagerAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts",
    validator: validate_TagmanagerAccountsList_593677, base: "/tagmanager/v1",
    url: url_TagmanagerAccountsList_593678, schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsUpdate_593973 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsUpdate_593975(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsUpdate_593974(path: JsonNode; query: JsonNode;
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
  var valid_593976 = path.getOrDefault("accountId")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "accountId", valid_593976
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
  var valid_593977 = query.getOrDefault("fields")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "fields", valid_593977
  var valid_593978 = query.getOrDefault("fingerprint")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = nil)
  if valid_593978 != nil:
    section.add "fingerprint", valid_593978
  var valid_593979 = query.getOrDefault("quotaUser")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = nil)
  if valid_593979 != nil:
    section.add "quotaUser", valid_593979
  var valid_593980 = query.getOrDefault("alt")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = newJString("json"))
  if valid_593980 != nil:
    section.add "alt", valid_593980
  var valid_593981 = query.getOrDefault("oauth_token")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = nil)
  if valid_593981 != nil:
    section.add "oauth_token", valid_593981
  var valid_593982 = query.getOrDefault("userIp")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "userIp", valid_593982
  var valid_593983 = query.getOrDefault("key")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "key", valid_593983
  var valid_593984 = query.getOrDefault("prettyPrint")
  valid_593984 = validateParameter(valid_593984, JBool, required = false,
                                 default = newJBool(true))
  if valid_593984 != nil:
    section.add "prettyPrint", valid_593984
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

proc call*(call_593986: Call_TagmanagerAccountsUpdate_593973; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a GTM Account.
  ## 
  let valid = call_593986.validator(path, query, header, formData, body)
  let scheme = call_593986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593986.url(scheme.get, call_593986.host, call_593986.base,
                         call_593986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593986, url, valid)

proc call*(call_593987: Call_TagmanagerAccountsUpdate_593973; accountId: string;
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
  var path_593988 = newJObject()
  var query_593989 = newJObject()
  var body_593990 = newJObject()
  add(query_593989, "fields", newJString(fields))
  add(query_593989, "fingerprint", newJString(fingerprint))
  add(query_593989, "quotaUser", newJString(quotaUser))
  add(query_593989, "alt", newJString(alt))
  add(query_593989, "oauth_token", newJString(oauthToken))
  add(path_593988, "accountId", newJString(accountId))
  add(query_593989, "userIp", newJString(userIp))
  add(query_593989, "key", newJString(key))
  if body != nil:
    body_593990 = body
  add(query_593989, "prettyPrint", newJBool(prettyPrint))
  result = call_593987.call(path_593988, query_593989, nil, nil, body_593990)

var tagmanagerAccountsUpdate* = Call_TagmanagerAccountsUpdate_593973(
    name: "tagmanagerAccountsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/accounts/{accountId}",
    validator: validate_TagmanagerAccountsUpdate_593974, base: "/tagmanager/v1",
    url: url_TagmanagerAccountsUpdate_593975, schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsGet_593944 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsGet_593946(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagmanagerAccountsGet_593945(path: JsonNode; query: JsonNode;
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
  var valid_593961 = path.getOrDefault("accountId")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "accountId", valid_593961
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
  var valid_593962 = query.getOrDefault("fields")
  valid_593962 = validateParameter(valid_593962, JString, required = false,
                                 default = nil)
  if valid_593962 != nil:
    section.add "fields", valid_593962
  var valid_593963 = query.getOrDefault("quotaUser")
  valid_593963 = validateParameter(valid_593963, JString, required = false,
                                 default = nil)
  if valid_593963 != nil:
    section.add "quotaUser", valid_593963
  var valid_593964 = query.getOrDefault("alt")
  valid_593964 = validateParameter(valid_593964, JString, required = false,
                                 default = newJString("json"))
  if valid_593964 != nil:
    section.add "alt", valid_593964
  var valid_593965 = query.getOrDefault("oauth_token")
  valid_593965 = validateParameter(valid_593965, JString, required = false,
                                 default = nil)
  if valid_593965 != nil:
    section.add "oauth_token", valid_593965
  var valid_593966 = query.getOrDefault("userIp")
  valid_593966 = validateParameter(valid_593966, JString, required = false,
                                 default = nil)
  if valid_593966 != nil:
    section.add "userIp", valid_593966
  var valid_593967 = query.getOrDefault("key")
  valid_593967 = validateParameter(valid_593967, JString, required = false,
                                 default = nil)
  if valid_593967 != nil:
    section.add "key", valid_593967
  var valid_593968 = query.getOrDefault("prettyPrint")
  valid_593968 = validateParameter(valid_593968, JBool, required = false,
                                 default = newJBool(true))
  if valid_593968 != nil:
    section.add "prettyPrint", valid_593968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593969: Call_TagmanagerAccountsGet_593944; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a GTM Account.
  ## 
  let valid = call_593969.validator(path, query, header, formData, body)
  let scheme = call_593969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593969.url(scheme.get, call_593969.host, call_593969.base,
                         call_593969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593969, url, valid)

proc call*(call_593970: Call_TagmanagerAccountsGet_593944; accountId: string;
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
  var path_593971 = newJObject()
  var query_593972 = newJObject()
  add(query_593972, "fields", newJString(fields))
  add(query_593972, "quotaUser", newJString(quotaUser))
  add(query_593972, "alt", newJString(alt))
  add(query_593972, "oauth_token", newJString(oauthToken))
  add(path_593971, "accountId", newJString(accountId))
  add(query_593972, "userIp", newJString(userIp))
  add(query_593972, "key", newJString(key))
  add(query_593972, "prettyPrint", newJBool(prettyPrint))
  result = call_593970.call(path_593971, query_593972, nil, nil, nil)

var tagmanagerAccountsGet* = Call_TagmanagerAccountsGet_593944(
    name: "tagmanagerAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}",
    validator: validate_TagmanagerAccountsGet_593945, base: "/tagmanager/v1",
    url: url_TagmanagerAccountsGet_593946, schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersCreate_594006 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersCreate_594008(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersCreate_594007(path: JsonNode;
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
  var valid_594009 = path.getOrDefault("accountId")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "accountId", valid_594009
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
  var valid_594010 = query.getOrDefault("fields")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "fields", valid_594010
  var valid_594011 = query.getOrDefault("quotaUser")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "quotaUser", valid_594011
  var valid_594012 = query.getOrDefault("alt")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = newJString("json"))
  if valid_594012 != nil:
    section.add "alt", valid_594012
  var valid_594013 = query.getOrDefault("oauth_token")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "oauth_token", valid_594013
  var valid_594014 = query.getOrDefault("userIp")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "userIp", valid_594014
  var valid_594015 = query.getOrDefault("key")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "key", valid_594015
  var valid_594016 = query.getOrDefault("prettyPrint")
  valid_594016 = validateParameter(valid_594016, JBool, required = false,
                                 default = newJBool(true))
  if valid_594016 != nil:
    section.add "prettyPrint", valid_594016
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

proc call*(call_594018: Call_TagmanagerAccountsContainersCreate_594006;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Container.
  ## 
  let valid = call_594018.validator(path, query, header, formData, body)
  let scheme = call_594018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594018.url(scheme.get, call_594018.host, call_594018.base,
                         call_594018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594018, url, valid)

proc call*(call_594019: Call_TagmanagerAccountsContainersCreate_594006;
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
  var path_594020 = newJObject()
  var query_594021 = newJObject()
  var body_594022 = newJObject()
  add(query_594021, "fields", newJString(fields))
  add(query_594021, "quotaUser", newJString(quotaUser))
  add(query_594021, "alt", newJString(alt))
  add(query_594021, "oauth_token", newJString(oauthToken))
  add(path_594020, "accountId", newJString(accountId))
  add(query_594021, "userIp", newJString(userIp))
  add(query_594021, "key", newJString(key))
  if body != nil:
    body_594022 = body
  add(query_594021, "prettyPrint", newJBool(prettyPrint))
  result = call_594019.call(path_594020, query_594021, nil, nil, body_594022)

var tagmanagerAccountsContainersCreate* = Call_TagmanagerAccountsContainersCreate_594006(
    name: "tagmanagerAccountsContainersCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers",
    validator: validate_TagmanagerAccountsContainersCreate_594007,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersCreate_594008,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersList_593991 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersList_593993(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersList_593992(path: JsonNode;
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
  var valid_593994 = path.getOrDefault("accountId")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "accountId", valid_593994
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
  var valid_593995 = query.getOrDefault("fields")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "fields", valid_593995
  var valid_593996 = query.getOrDefault("quotaUser")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "quotaUser", valid_593996
  var valid_593997 = query.getOrDefault("alt")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = newJString("json"))
  if valid_593997 != nil:
    section.add "alt", valid_593997
  var valid_593998 = query.getOrDefault("oauth_token")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = nil)
  if valid_593998 != nil:
    section.add "oauth_token", valid_593998
  var valid_593999 = query.getOrDefault("userIp")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "userIp", valid_593999
  var valid_594000 = query.getOrDefault("key")
  valid_594000 = validateParameter(valid_594000, JString, required = false,
                                 default = nil)
  if valid_594000 != nil:
    section.add "key", valid_594000
  var valid_594001 = query.getOrDefault("prettyPrint")
  valid_594001 = validateParameter(valid_594001, JBool, required = false,
                                 default = newJBool(true))
  if valid_594001 != nil:
    section.add "prettyPrint", valid_594001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594002: Call_TagmanagerAccountsContainersList_593991;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all Containers that belongs to a GTM Account.
  ## 
  let valid = call_594002.validator(path, query, header, formData, body)
  let scheme = call_594002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594002.url(scheme.get, call_594002.host, call_594002.base,
                         call_594002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594002, url, valid)

proc call*(call_594003: Call_TagmanagerAccountsContainersList_593991;
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
  var path_594004 = newJObject()
  var query_594005 = newJObject()
  add(query_594005, "fields", newJString(fields))
  add(query_594005, "quotaUser", newJString(quotaUser))
  add(query_594005, "alt", newJString(alt))
  add(query_594005, "oauth_token", newJString(oauthToken))
  add(path_594004, "accountId", newJString(accountId))
  add(query_594005, "userIp", newJString(userIp))
  add(query_594005, "key", newJString(key))
  add(query_594005, "prettyPrint", newJBool(prettyPrint))
  result = call_594003.call(path_594004, query_594005, nil, nil, nil)

var tagmanagerAccountsContainersList* = Call_TagmanagerAccountsContainersList_593991(
    name: "tagmanagerAccountsContainersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers",
    validator: validate_TagmanagerAccountsContainersList_593992,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersList_593993,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersUpdate_594039 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersUpdate_594041(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersUpdate_594040(path: JsonNode;
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
  var valid_594042 = path.getOrDefault("containerId")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "containerId", valid_594042
  var valid_594043 = path.getOrDefault("accountId")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "accountId", valid_594043
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
  var valid_594044 = query.getOrDefault("fields")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "fields", valid_594044
  var valid_594045 = query.getOrDefault("fingerprint")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = nil)
  if valid_594045 != nil:
    section.add "fingerprint", valid_594045
  var valid_594046 = query.getOrDefault("quotaUser")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "quotaUser", valid_594046
  var valid_594047 = query.getOrDefault("alt")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = newJString("json"))
  if valid_594047 != nil:
    section.add "alt", valid_594047
  var valid_594048 = query.getOrDefault("oauth_token")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "oauth_token", valid_594048
  var valid_594049 = query.getOrDefault("userIp")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = nil)
  if valid_594049 != nil:
    section.add "userIp", valid_594049
  var valid_594050 = query.getOrDefault("key")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "key", valid_594050
  var valid_594051 = query.getOrDefault("prettyPrint")
  valid_594051 = validateParameter(valid_594051, JBool, required = false,
                                 default = newJBool(true))
  if valid_594051 != nil:
    section.add "prettyPrint", valid_594051
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

proc call*(call_594053: Call_TagmanagerAccountsContainersUpdate_594039;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a Container.
  ## 
  let valid = call_594053.validator(path, query, header, formData, body)
  let scheme = call_594053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594053.url(scheme.get, call_594053.host, call_594053.base,
                         call_594053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594053, url, valid)

proc call*(call_594054: Call_TagmanagerAccountsContainersUpdate_594039;
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
  var path_594055 = newJObject()
  var query_594056 = newJObject()
  var body_594057 = newJObject()
  add(path_594055, "containerId", newJString(containerId))
  add(query_594056, "fields", newJString(fields))
  add(query_594056, "fingerprint", newJString(fingerprint))
  add(query_594056, "quotaUser", newJString(quotaUser))
  add(query_594056, "alt", newJString(alt))
  add(query_594056, "oauth_token", newJString(oauthToken))
  add(path_594055, "accountId", newJString(accountId))
  add(query_594056, "userIp", newJString(userIp))
  add(query_594056, "key", newJString(key))
  if body != nil:
    body_594057 = body
  add(query_594056, "prettyPrint", newJBool(prettyPrint))
  result = call_594054.call(path_594055, query_594056, nil, nil, body_594057)

var tagmanagerAccountsContainersUpdate* = Call_TagmanagerAccountsContainersUpdate_594039(
    name: "tagmanagerAccountsContainersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}",
    validator: validate_TagmanagerAccountsContainersUpdate_594040,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersUpdate_594041,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersGet_594023 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersGet_594025(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersGet_594024(path: JsonNode;
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
  var valid_594026 = path.getOrDefault("containerId")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "containerId", valid_594026
  var valid_594027 = path.getOrDefault("accountId")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "accountId", valid_594027
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
  var valid_594028 = query.getOrDefault("fields")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "fields", valid_594028
  var valid_594029 = query.getOrDefault("quotaUser")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "quotaUser", valid_594029
  var valid_594030 = query.getOrDefault("alt")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = newJString("json"))
  if valid_594030 != nil:
    section.add "alt", valid_594030
  var valid_594031 = query.getOrDefault("oauth_token")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "oauth_token", valid_594031
  var valid_594032 = query.getOrDefault("userIp")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "userIp", valid_594032
  var valid_594033 = query.getOrDefault("key")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "key", valid_594033
  var valid_594034 = query.getOrDefault("prettyPrint")
  valid_594034 = validateParameter(valid_594034, JBool, required = false,
                                 default = newJBool(true))
  if valid_594034 != nil:
    section.add "prettyPrint", valid_594034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594035: Call_TagmanagerAccountsContainersGet_594023;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a Container.
  ## 
  let valid = call_594035.validator(path, query, header, formData, body)
  let scheme = call_594035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594035.url(scheme.get, call_594035.host, call_594035.base,
                         call_594035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594035, url, valid)

proc call*(call_594036: Call_TagmanagerAccountsContainersGet_594023;
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
  var path_594037 = newJObject()
  var query_594038 = newJObject()
  add(path_594037, "containerId", newJString(containerId))
  add(query_594038, "fields", newJString(fields))
  add(query_594038, "quotaUser", newJString(quotaUser))
  add(query_594038, "alt", newJString(alt))
  add(query_594038, "oauth_token", newJString(oauthToken))
  add(path_594037, "accountId", newJString(accountId))
  add(query_594038, "userIp", newJString(userIp))
  add(query_594038, "key", newJString(key))
  add(query_594038, "prettyPrint", newJBool(prettyPrint))
  result = call_594036.call(path_594037, query_594038, nil, nil, nil)

var tagmanagerAccountsContainersGet* = Call_TagmanagerAccountsContainersGet_594023(
    name: "tagmanagerAccountsContainersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}",
    validator: validate_TagmanagerAccountsContainersGet_594024,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersGet_594025,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersDelete_594058 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersDelete_594060(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersDelete_594059(path: JsonNode;
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
  var valid_594061 = path.getOrDefault("containerId")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "containerId", valid_594061
  var valid_594062 = path.getOrDefault("accountId")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "accountId", valid_594062
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
  var valid_594063 = query.getOrDefault("fields")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "fields", valid_594063
  var valid_594064 = query.getOrDefault("quotaUser")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "quotaUser", valid_594064
  var valid_594065 = query.getOrDefault("alt")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = newJString("json"))
  if valid_594065 != nil:
    section.add "alt", valid_594065
  var valid_594066 = query.getOrDefault("oauth_token")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = nil)
  if valid_594066 != nil:
    section.add "oauth_token", valid_594066
  var valid_594067 = query.getOrDefault("userIp")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = nil)
  if valid_594067 != nil:
    section.add "userIp", valid_594067
  var valid_594068 = query.getOrDefault("key")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = nil)
  if valid_594068 != nil:
    section.add "key", valid_594068
  var valid_594069 = query.getOrDefault("prettyPrint")
  valid_594069 = validateParameter(valid_594069, JBool, required = false,
                                 default = newJBool(true))
  if valid_594069 != nil:
    section.add "prettyPrint", valid_594069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594070: Call_TagmanagerAccountsContainersDelete_594058;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a Container.
  ## 
  let valid = call_594070.validator(path, query, header, formData, body)
  let scheme = call_594070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594070.url(scheme.get, call_594070.host, call_594070.base,
                         call_594070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594070, url, valid)

proc call*(call_594071: Call_TagmanagerAccountsContainersDelete_594058;
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
  var path_594072 = newJObject()
  var query_594073 = newJObject()
  add(path_594072, "containerId", newJString(containerId))
  add(query_594073, "fields", newJString(fields))
  add(query_594073, "quotaUser", newJString(quotaUser))
  add(query_594073, "alt", newJString(alt))
  add(query_594073, "oauth_token", newJString(oauthToken))
  add(path_594072, "accountId", newJString(accountId))
  add(query_594073, "userIp", newJString(userIp))
  add(query_594073, "key", newJString(key))
  add(query_594073, "prettyPrint", newJBool(prettyPrint))
  result = call_594071.call(path_594072, query_594073, nil, nil, nil)

var tagmanagerAccountsContainersDelete* = Call_TagmanagerAccountsContainersDelete_594058(
    name: "tagmanagerAccountsContainersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}",
    validator: validate_TagmanagerAccountsContainersDelete_594059,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersDelete_594060,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersEnvironmentsCreate_594090 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersEnvironmentsCreate_594092(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersEnvironmentsCreate_594091(
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
  var valid_594093 = path.getOrDefault("containerId")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "containerId", valid_594093
  var valid_594094 = path.getOrDefault("accountId")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "accountId", valid_594094
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
  var valid_594095 = query.getOrDefault("fields")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "fields", valid_594095
  var valid_594096 = query.getOrDefault("quotaUser")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = nil)
  if valid_594096 != nil:
    section.add "quotaUser", valid_594096
  var valid_594097 = query.getOrDefault("alt")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = newJString("json"))
  if valid_594097 != nil:
    section.add "alt", valid_594097
  var valid_594098 = query.getOrDefault("oauth_token")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "oauth_token", valid_594098
  var valid_594099 = query.getOrDefault("userIp")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "userIp", valid_594099
  var valid_594100 = query.getOrDefault("key")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "key", valid_594100
  var valid_594101 = query.getOrDefault("prettyPrint")
  valid_594101 = validateParameter(valid_594101, JBool, required = false,
                                 default = newJBool(true))
  if valid_594101 != nil:
    section.add "prettyPrint", valid_594101
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

proc call*(call_594103: Call_TagmanagerAccountsContainersEnvironmentsCreate_594090;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a GTM Environment.
  ## 
  let valid = call_594103.validator(path, query, header, formData, body)
  let scheme = call_594103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594103.url(scheme.get, call_594103.host, call_594103.base,
                         call_594103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594103, url, valid)

proc call*(call_594104: Call_TagmanagerAccountsContainersEnvironmentsCreate_594090;
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
  var path_594105 = newJObject()
  var query_594106 = newJObject()
  var body_594107 = newJObject()
  add(path_594105, "containerId", newJString(containerId))
  add(query_594106, "fields", newJString(fields))
  add(query_594106, "quotaUser", newJString(quotaUser))
  add(query_594106, "alt", newJString(alt))
  add(query_594106, "oauth_token", newJString(oauthToken))
  add(path_594105, "accountId", newJString(accountId))
  add(query_594106, "userIp", newJString(userIp))
  add(query_594106, "key", newJString(key))
  if body != nil:
    body_594107 = body
  add(query_594106, "prettyPrint", newJBool(prettyPrint))
  result = call_594104.call(path_594105, query_594106, nil, nil, body_594107)

var tagmanagerAccountsContainersEnvironmentsCreate* = Call_TagmanagerAccountsContainersEnvironmentsCreate_594090(
    name: "tagmanagerAccountsContainersEnvironmentsCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/environments",
    validator: validate_TagmanagerAccountsContainersEnvironmentsCreate_594091,
    base: "/tagmanager/v1",
    url: url_TagmanagerAccountsContainersEnvironmentsCreate_594092,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersEnvironmentsList_594074 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersEnvironmentsList_594076(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersEnvironmentsList_594075(path: JsonNode;
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
  var valid_594077 = path.getOrDefault("containerId")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "containerId", valid_594077
  var valid_594078 = path.getOrDefault("accountId")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "accountId", valid_594078
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
  var valid_594079 = query.getOrDefault("fields")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "fields", valid_594079
  var valid_594080 = query.getOrDefault("quotaUser")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = nil)
  if valid_594080 != nil:
    section.add "quotaUser", valid_594080
  var valid_594081 = query.getOrDefault("alt")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = newJString("json"))
  if valid_594081 != nil:
    section.add "alt", valid_594081
  var valid_594082 = query.getOrDefault("oauth_token")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "oauth_token", valid_594082
  var valid_594083 = query.getOrDefault("userIp")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "userIp", valid_594083
  var valid_594084 = query.getOrDefault("key")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "key", valid_594084
  var valid_594085 = query.getOrDefault("prettyPrint")
  valid_594085 = validateParameter(valid_594085, JBool, required = false,
                                 default = newJBool(true))
  if valid_594085 != nil:
    section.add "prettyPrint", valid_594085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594086: Call_TagmanagerAccountsContainersEnvironmentsList_594074;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all GTM Environments of a GTM Container.
  ## 
  let valid = call_594086.validator(path, query, header, formData, body)
  let scheme = call_594086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594086.url(scheme.get, call_594086.host, call_594086.base,
                         call_594086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594086, url, valid)

proc call*(call_594087: Call_TagmanagerAccountsContainersEnvironmentsList_594074;
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
  var path_594088 = newJObject()
  var query_594089 = newJObject()
  add(path_594088, "containerId", newJString(containerId))
  add(query_594089, "fields", newJString(fields))
  add(query_594089, "quotaUser", newJString(quotaUser))
  add(query_594089, "alt", newJString(alt))
  add(query_594089, "oauth_token", newJString(oauthToken))
  add(path_594088, "accountId", newJString(accountId))
  add(query_594089, "userIp", newJString(userIp))
  add(query_594089, "key", newJString(key))
  add(query_594089, "prettyPrint", newJBool(prettyPrint))
  result = call_594087.call(path_594088, query_594089, nil, nil, nil)

var tagmanagerAccountsContainersEnvironmentsList* = Call_TagmanagerAccountsContainersEnvironmentsList_594074(
    name: "tagmanagerAccountsContainersEnvironmentsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/environments",
    validator: validate_TagmanagerAccountsContainersEnvironmentsList_594075,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersEnvironmentsList_594076,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersEnvironmentsUpdate_594125 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersEnvironmentsUpdate_594127(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersEnvironmentsUpdate_594126(
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
  var valid_594128 = path.getOrDefault("containerId")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "containerId", valid_594128
  var valid_594129 = path.getOrDefault("accountId")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "accountId", valid_594129
  var valid_594130 = path.getOrDefault("environmentId")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "environmentId", valid_594130
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
  var valid_594131 = query.getOrDefault("fields")
  valid_594131 = validateParameter(valid_594131, JString, required = false,
                                 default = nil)
  if valid_594131 != nil:
    section.add "fields", valid_594131
  var valid_594132 = query.getOrDefault("fingerprint")
  valid_594132 = validateParameter(valid_594132, JString, required = false,
                                 default = nil)
  if valid_594132 != nil:
    section.add "fingerprint", valid_594132
  var valid_594133 = query.getOrDefault("quotaUser")
  valid_594133 = validateParameter(valid_594133, JString, required = false,
                                 default = nil)
  if valid_594133 != nil:
    section.add "quotaUser", valid_594133
  var valid_594134 = query.getOrDefault("alt")
  valid_594134 = validateParameter(valid_594134, JString, required = false,
                                 default = newJString("json"))
  if valid_594134 != nil:
    section.add "alt", valid_594134
  var valid_594135 = query.getOrDefault("oauth_token")
  valid_594135 = validateParameter(valid_594135, JString, required = false,
                                 default = nil)
  if valid_594135 != nil:
    section.add "oauth_token", valid_594135
  var valid_594136 = query.getOrDefault("userIp")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = nil)
  if valid_594136 != nil:
    section.add "userIp", valid_594136
  var valid_594137 = query.getOrDefault("key")
  valid_594137 = validateParameter(valid_594137, JString, required = false,
                                 default = nil)
  if valid_594137 != nil:
    section.add "key", valid_594137
  var valid_594138 = query.getOrDefault("prettyPrint")
  valid_594138 = validateParameter(valid_594138, JBool, required = false,
                                 default = newJBool(true))
  if valid_594138 != nil:
    section.add "prettyPrint", valid_594138
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

proc call*(call_594140: Call_TagmanagerAccountsContainersEnvironmentsUpdate_594125;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a GTM Environment.
  ## 
  let valid = call_594140.validator(path, query, header, formData, body)
  let scheme = call_594140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594140.url(scheme.get, call_594140.host, call_594140.base,
                         call_594140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594140, url, valid)

proc call*(call_594141: Call_TagmanagerAccountsContainersEnvironmentsUpdate_594125;
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
  var path_594142 = newJObject()
  var query_594143 = newJObject()
  var body_594144 = newJObject()
  add(path_594142, "containerId", newJString(containerId))
  add(query_594143, "fields", newJString(fields))
  add(query_594143, "fingerprint", newJString(fingerprint))
  add(query_594143, "quotaUser", newJString(quotaUser))
  add(query_594143, "alt", newJString(alt))
  add(query_594143, "oauth_token", newJString(oauthToken))
  add(path_594142, "accountId", newJString(accountId))
  add(query_594143, "userIp", newJString(userIp))
  add(query_594143, "key", newJString(key))
  add(path_594142, "environmentId", newJString(environmentId))
  if body != nil:
    body_594144 = body
  add(query_594143, "prettyPrint", newJBool(prettyPrint))
  result = call_594141.call(path_594142, query_594143, nil, nil, body_594144)

var tagmanagerAccountsContainersEnvironmentsUpdate* = Call_TagmanagerAccountsContainersEnvironmentsUpdate_594125(
    name: "tagmanagerAccountsContainersEnvironmentsUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/environments/{environmentId}",
    validator: validate_TagmanagerAccountsContainersEnvironmentsUpdate_594126,
    base: "/tagmanager/v1",
    url: url_TagmanagerAccountsContainersEnvironmentsUpdate_594127,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersEnvironmentsGet_594108 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersEnvironmentsGet_594110(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersEnvironmentsGet_594109(path: JsonNode;
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
  var valid_594111 = path.getOrDefault("containerId")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "containerId", valid_594111
  var valid_594112 = path.getOrDefault("accountId")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "accountId", valid_594112
  var valid_594113 = path.getOrDefault("environmentId")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "environmentId", valid_594113
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
  var valid_594114 = query.getOrDefault("fields")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = nil)
  if valid_594114 != nil:
    section.add "fields", valid_594114
  var valid_594115 = query.getOrDefault("quotaUser")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = nil)
  if valid_594115 != nil:
    section.add "quotaUser", valid_594115
  var valid_594116 = query.getOrDefault("alt")
  valid_594116 = validateParameter(valid_594116, JString, required = false,
                                 default = newJString("json"))
  if valid_594116 != nil:
    section.add "alt", valid_594116
  var valid_594117 = query.getOrDefault("oauth_token")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = nil)
  if valid_594117 != nil:
    section.add "oauth_token", valid_594117
  var valid_594118 = query.getOrDefault("userIp")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = nil)
  if valid_594118 != nil:
    section.add "userIp", valid_594118
  var valid_594119 = query.getOrDefault("key")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "key", valid_594119
  var valid_594120 = query.getOrDefault("prettyPrint")
  valid_594120 = validateParameter(valid_594120, JBool, required = false,
                                 default = newJBool(true))
  if valid_594120 != nil:
    section.add "prettyPrint", valid_594120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594121: Call_TagmanagerAccountsContainersEnvironmentsGet_594108;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a GTM Environment.
  ## 
  let valid = call_594121.validator(path, query, header, formData, body)
  let scheme = call_594121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594121.url(scheme.get, call_594121.host, call_594121.base,
                         call_594121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594121, url, valid)

proc call*(call_594122: Call_TagmanagerAccountsContainersEnvironmentsGet_594108;
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
  var path_594123 = newJObject()
  var query_594124 = newJObject()
  add(path_594123, "containerId", newJString(containerId))
  add(query_594124, "fields", newJString(fields))
  add(query_594124, "quotaUser", newJString(quotaUser))
  add(query_594124, "alt", newJString(alt))
  add(query_594124, "oauth_token", newJString(oauthToken))
  add(path_594123, "accountId", newJString(accountId))
  add(query_594124, "userIp", newJString(userIp))
  add(query_594124, "key", newJString(key))
  add(path_594123, "environmentId", newJString(environmentId))
  add(query_594124, "prettyPrint", newJBool(prettyPrint))
  result = call_594122.call(path_594123, query_594124, nil, nil, nil)

var tagmanagerAccountsContainersEnvironmentsGet* = Call_TagmanagerAccountsContainersEnvironmentsGet_594108(
    name: "tagmanagerAccountsContainersEnvironmentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/environments/{environmentId}",
    validator: validate_TagmanagerAccountsContainersEnvironmentsGet_594109,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersEnvironmentsGet_594110,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersEnvironmentsDelete_594145 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersEnvironmentsDelete_594147(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersEnvironmentsDelete_594146(
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
  var valid_594148 = path.getOrDefault("containerId")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "containerId", valid_594148
  var valid_594149 = path.getOrDefault("accountId")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "accountId", valid_594149
  var valid_594150 = path.getOrDefault("environmentId")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "environmentId", valid_594150
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
  var valid_594151 = query.getOrDefault("fields")
  valid_594151 = validateParameter(valid_594151, JString, required = false,
                                 default = nil)
  if valid_594151 != nil:
    section.add "fields", valid_594151
  var valid_594152 = query.getOrDefault("quotaUser")
  valid_594152 = validateParameter(valid_594152, JString, required = false,
                                 default = nil)
  if valid_594152 != nil:
    section.add "quotaUser", valid_594152
  var valid_594153 = query.getOrDefault("alt")
  valid_594153 = validateParameter(valid_594153, JString, required = false,
                                 default = newJString("json"))
  if valid_594153 != nil:
    section.add "alt", valid_594153
  var valid_594154 = query.getOrDefault("oauth_token")
  valid_594154 = validateParameter(valid_594154, JString, required = false,
                                 default = nil)
  if valid_594154 != nil:
    section.add "oauth_token", valid_594154
  var valid_594155 = query.getOrDefault("userIp")
  valid_594155 = validateParameter(valid_594155, JString, required = false,
                                 default = nil)
  if valid_594155 != nil:
    section.add "userIp", valid_594155
  var valid_594156 = query.getOrDefault("key")
  valid_594156 = validateParameter(valid_594156, JString, required = false,
                                 default = nil)
  if valid_594156 != nil:
    section.add "key", valid_594156
  var valid_594157 = query.getOrDefault("prettyPrint")
  valid_594157 = validateParameter(valid_594157, JBool, required = false,
                                 default = newJBool(true))
  if valid_594157 != nil:
    section.add "prettyPrint", valid_594157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594158: Call_TagmanagerAccountsContainersEnvironmentsDelete_594145;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a GTM Environment.
  ## 
  let valid = call_594158.validator(path, query, header, formData, body)
  let scheme = call_594158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594158.url(scheme.get, call_594158.host, call_594158.base,
                         call_594158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594158, url, valid)

proc call*(call_594159: Call_TagmanagerAccountsContainersEnvironmentsDelete_594145;
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
  var path_594160 = newJObject()
  var query_594161 = newJObject()
  add(path_594160, "containerId", newJString(containerId))
  add(query_594161, "fields", newJString(fields))
  add(query_594161, "quotaUser", newJString(quotaUser))
  add(query_594161, "alt", newJString(alt))
  add(query_594161, "oauth_token", newJString(oauthToken))
  add(path_594160, "accountId", newJString(accountId))
  add(query_594161, "userIp", newJString(userIp))
  add(query_594161, "key", newJString(key))
  add(path_594160, "environmentId", newJString(environmentId))
  add(query_594161, "prettyPrint", newJBool(prettyPrint))
  result = call_594159.call(path_594160, query_594161, nil, nil, nil)

var tagmanagerAccountsContainersEnvironmentsDelete* = Call_TagmanagerAccountsContainersEnvironmentsDelete_594145(
    name: "tagmanagerAccountsContainersEnvironmentsDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/environments/{environmentId}",
    validator: validate_TagmanagerAccountsContainersEnvironmentsDelete_594146,
    base: "/tagmanager/v1",
    url: url_TagmanagerAccountsContainersEnvironmentsDelete_594147,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersFoldersCreate_594178 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersFoldersCreate_594180(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersFoldersCreate_594179(path: JsonNode;
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
  var valid_594181 = path.getOrDefault("containerId")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "containerId", valid_594181
  var valid_594182 = path.getOrDefault("accountId")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "accountId", valid_594182
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
  var valid_594183 = query.getOrDefault("fields")
  valid_594183 = validateParameter(valid_594183, JString, required = false,
                                 default = nil)
  if valid_594183 != nil:
    section.add "fields", valid_594183
  var valid_594184 = query.getOrDefault("quotaUser")
  valid_594184 = validateParameter(valid_594184, JString, required = false,
                                 default = nil)
  if valid_594184 != nil:
    section.add "quotaUser", valid_594184
  var valid_594185 = query.getOrDefault("alt")
  valid_594185 = validateParameter(valid_594185, JString, required = false,
                                 default = newJString("json"))
  if valid_594185 != nil:
    section.add "alt", valid_594185
  var valid_594186 = query.getOrDefault("oauth_token")
  valid_594186 = validateParameter(valid_594186, JString, required = false,
                                 default = nil)
  if valid_594186 != nil:
    section.add "oauth_token", valid_594186
  var valid_594187 = query.getOrDefault("userIp")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = nil)
  if valid_594187 != nil:
    section.add "userIp", valid_594187
  var valid_594188 = query.getOrDefault("key")
  valid_594188 = validateParameter(valid_594188, JString, required = false,
                                 default = nil)
  if valid_594188 != nil:
    section.add "key", valid_594188
  var valid_594189 = query.getOrDefault("prettyPrint")
  valid_594189 = validateParameter(valid_594189, JBool, required = false,
                                 default = newJBool(true))
  if valid_594189 != nil:
    section.add "prettyPrint", valid_594189
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

proc call*(call_594191: Call_TagmanagerAccountsContainersFoldersCreate_594178;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a GTM Folder.
  ## 
  let valid = call_594191.validator(path, query, header, formData, body)
  let scheme = call_594191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594191.url(scheme.get, call_594191.host, call_594191.base,
                         call_594191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594191, url, valid)

proc call*(call_594192: Call_TagmanagerAccountsContainersFoldersCreate_594178;
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
  var path_594193 = newJObject()
  var query_594194 = newJObject()
  var body_594195 = newJObject()
  add(path_594193, "containerId", newJString(containerId))
  add(query_594194, "fields", newJString(fields))
  add(query_594194, "quotaUser", newJString(quotaUser))
  add(query_594194, "alt", newJString(alt))
  add(query_594194, "oauth_token", newJString(oauthToken))
  add(path_594193, "accountId", newJString(accountId))
  add(query_594194, "userIp", newJString(userIp))
  add(query_594194, "key", newJString(key))
  if body != nil:
    body_594195 = body
  add(query_594194, "prettyPrint", newJBool(prettyPrint))
  result = call_594192.call(path_594193, query_594194, nil, nil, body_594195)

var tagmanagerAccountsContainersFoldersCreate* = Call_TagmanagerAccountsContainersFoldersCreate_594178(
    name: "tagmanagerAccountsContainersFoldersCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/folders",
    validator: validate_TagmanagerAccountsContainersFoldersCreate_594179,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersFoldersCreate_594180,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersFoldersList_594162 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersFoldersList_594164(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersFoldersList_594163(path: JsonNode;
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
  var valid_594165 = path.getOrDefault("containerId")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = nil)
  if valid_594165 != nil:
    section.add "containerId", valid_594165
  var valid_594166 = path.getOrDefault("accountId")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "accountId", valid_594166
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
  var valid_594167 = query.getOrDefault("fields")
  valid_594167 = validateParameter(valid_594167, JString, required = false,
                                 default = nil)
  if valid_594167 != nil:
    section.add "fields", valid_594167
  var valid_594168 = query.getOrDefault("quotaUser")
  valid_594168 = validateParameter(valid_594168, JString, required = false,
                                 default = nil)
  if valid_594168 != nil:
    section.add "quotaUser", valid_594168
  var valid_594169 = query.getOrDefault("alt")
  valid_594169 = validateParameter(valid_594169, JString, required = false,
                                 default = newJString("json"))
  if valid_594169 != nil:
    section.add "alt", valid_594169
  var valid_594170 = query.getOrDefault("oauth_token")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = nil)
  if valid_594170 != nil:
    section.add "oauth_token", valid_594170
  var valid_594171 = query.getOrDefault("userIp")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = nil)
  if valid_594171 != nil:
    section.add "userIp", valid_594171
  var valid_594172 = query.getOrDefault("key")
  valid_594172 = validateParameter(valid_594172, JString, required = false,
                                 default = nil)
  if valid_594172 != nil:
    section.add "key", valid_594172
  var valid_594173 = query.getOrDefault("prettyPrint")
  valid_594173 = validateParameter(valid_594173, JBool, required = false,
                                 default = newJBool(true))
  if valid_594173 != nil:
    section.add "prettyPrint", valid_594173
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594174: Call_TagmanagerAccountsContainersFoldersList_594162;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all GTM Folders of a Container.
  ## 
  let valid = call_594174.validator(path, query, header, formData, body)
  let scheme = call_594174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594174.url(scheme.get, call_594174.host, call_594174.base,
                         call_594174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594174, url, valid)

proc call*(call_594175: Call_TagmanagerAccountsContainersFoldersList_594162;
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
  var path_594176 = newJObject()
  var query_594177 = newJObject()
  add(path_594176, "containerId", newJString(containerId))
  add(query_594177, "fields", newJString(fields))
  add(query_594177, "quotaUser", newJString(quotaUser))
  add(query_594177, "alt", newJString(alt))
  add(query_594177, "oauth_token", newJString(oauthToken))
  add(path_594176, "accountId", newJString(accountId))
  add(query_594177, "userIp", newJString(userIp))
  add(query_594177, "key", newJString(key))
  add(query_594177, "prettyPrint", newJBool(prettyPrint))
  result = call_594175.call(path_594176, query_594177, nil, nil, nil)

var tagmanagerAccountsContainersFoldersList* = Call_TagmanagerAccountsContainersFoldersList_594162(
    name: "tagmanagerAccountsContainersFoldersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/folders",
    validator: validate_TagmanagerAccountsContainersFoldersList_594163,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersFoldersList_594164,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersFoldersUpdate_594213 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersFoldersUpdate_594215(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersFoldersUpdate_594214(path: JsonNode;
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
  var valid_594216 = path.getOrDefault("containerId")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "containerId", valid_594216
  var valid_594217 = path.getOrDefault("accountId")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "accountId", valid_594217
  var valid_594218 = path.getOrDefault("folderId")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = nil)
  if valid_594218 != nil:
    section.add "folderId", valid_594218
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
  var valid_594219 = query.getOrDefault("fields")
  valid_594219 = validateParameter(valid_594219, JString, required = false,
                                 default = nil)
  if valid_594219 != nil:
    section.add "fields", valid_594219
  var valid_594220 = query.getOrDefault("fingerprint")
  valid_594220 = validateParameter(valid_594220, JString, required = false,
                                 default = nil)
  if valid_594220 != nil:
    section.add "fingerprint", valid_594220
  var valid_594221 = query.getOrDefault("quotaUser")
  valid_594221 = validateParameter(valid_594221, JString, required = false,
                                 default = nil)
  if valid_594221 != nil:
    section.add "quotaUser", valid_594221
  var valid_594222 = query.getOrDefault("alt")
  valid_594222 = validateParameter(valid_594222, JString, required = false,
                                 default = newJString("json"))
  if valid_594222 != nil:
    section.add "alt", valid_594222
  var valid_594223 = query.getOrDefault("oauth_token")
  valid_594223 = validateParameter(valid_594223, JString, required = false,
                                 default = nil)
  if valid_594223 != nil:
    section.add "oauth_token", valid_594223
  var valid_594224 = query.getOrDefault("userIp")
  valid_594224 = validateParameter(valid_594224, JString, required = false,
                                 default = nil)
  if valid_594224 != nil:
    section.add "userIp", valid_594224
  var valid_594225 = query.getOrDefault("key")
  valid_594225 = validateParameter(valid_594225, JString, required = false,
                                 default = nil)
  if valid_594225 != nil:
    section.add "key", valid_594225
  var valid_594226 = query.getOrDefault("prettyPrint")
  valid_594226 = validateParameter(valid_594226, JBool, required = false,
                                 default = newJBool(true))
  if valid_594226 != nil:
    section.add "prettyPrint", valid_594226
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

proc call*(call_594228: Call_TagmanagerAccountsContainersFoldersUpdate_594213;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a GTM Folder.
  ## 
  let valid = call_594228.validator(path, query, header, formData, body)
  let scheme = call_594228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594228.url(scheme.get, call_594228.host, call_594228.base,
                         call_594228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594228, url, valid)

proc call*(call_594229: Call_TagmanagerAccountsContainersFoldersUpdate_594213;
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
  var path_594230 = newJObject()
  var query_594231 = newJObject()
  var body_594232 = newJObject()
  add(path_594230, "containerId", newJString(containerId))
  add(query_594231, "fields", newJString(fields))
  add(query_594231, "fingerprint", newJString(fingerprint))
  add(query_594231, "quotaUser", newJString(quotaUser))
  add(query_594231, "alt", newJString(alt))
  add(query_594231, "oauth_token", newJString(oauthToken))
  add(path_594230, "accountId", newJString(accountId))
  add(query_594231, "userIp", newJString(userIp))
  add(path_594230, "folderId", newJString(folderId))
  add(query_594231, "key", newJString(key))
  if body != nil:
    body_594232 = body
  add(query_594231, "prettyPrint", newJBool(prettyPrint))
  result = call_594229.call(path_594230, query_594231, nil, nil, body_594232)

var tagmanagerAccountsContainersFoldersUpdate* = Call_TagmanagerAccountsContainersFoldersUpdate_594213(
    name: "tagmanagerAccountsContainersFoldersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/folders/{folderId}",
    validator: validate_TagmanagerAccountsContainersFoldersUpdate_594214,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersFoldersUpdate_594215,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersFoldersGet_594196 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersFoldersGet_594198(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersFoldersGet_594197(path: JsonNode;
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
  var valid_594199 = path.getOrDefault("containerId")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "containerId", valid_594199
  var valid_594200 = path.getOrDefault("accountId")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "accountId", valid_594200
  var valid_594201 = path.getOrDefault("folderId")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "folderId", valid_594201
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
  var valid_594202 = query.getOrDefault("fields")
  valid_594202 = validateParameter(valid_594202, JString, required = false,
                                 default = nil)
  if valid_594202 != nil:
    section.add "fields", valid_594202
  var valid_594203 = query.getOrDefault("quotaUser")
  valid_594203 = validateParameter(valid_594203, JString, required = false,
                                 default = nil)
  if valid_594203 != nil:
    section.add "quotaUser", valid_594203
  var valid_594204 = query.getOrDefault("alt")
  valid_594204 = validateParameter(valid_594204, JString, required = false,
                                 default = newJString("json"))
  if valid_594204 != nil:
    section.add "alt", valid_594204
  var valid_594205 = query.getOrDefault("oauth_token")
  valid_594205 = validateParameter(valid_594205, JString, required = false,
                                 default = nil)
  if valid_594205 != nil:
    section.add "oauth_token", valid_594205
  var valid_594206 = query.getOrDefault("userIp")
  valid_594206 = validateParameter(valid_594206, JString, required = false,
                                 default = nil)
  if valid_594206 != nil:
    section.add "userIp", valid_594206
  var valid_594207 = query.getOrDefault("key")
  valid_594207 = validateParameter(valid_594207, JString, required = false,
                                 default = nil)
  if valid_594207 != nil:
    section.add "key", valid_594207
  var valid_594208 = query.getOrDefault("prettyPrint")
  valid_594208 = validateParameter(valid_594208, JBool, required = false,
                                 default = newJBool(true))
  if valid_594208 != nil:
    section.add "prettyPrint", valid_594208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594209: Call_TagmanagerAccountsContainersFoldersGet_594196;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a GTM Folder.
  ## 
  let valid = call_594209.validator(path, query, header, formData, body)
  let scheme = call_594209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594209.url(scheme.get, call_594209.host, call_594209.base,
                         call_594209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594209, url, valid)

proc call*(call_594210: Call_TagmanagerAccountsContainersFoldersGet_594196;
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
  var path_594211 = newJObject()
  var query_594212 = newJObject()
  add(path_594211, "containerId", newJString(containerId))
  add(query_594212, "fields", newJString(fields))
  add(query_594212, "quotaUser", newJString(quotaUser))
  add(query_594212, "alt", newJString(alt))
  add(query_594212, "oauth_token", newJString(oauthToken))
  add(path_594211, "accountId", newJString(accountId))
  add(query_594212, "userIp", newJString(userIp))
  add(path_594211, "folderId", newJString(folderId))
  add(query_594212, "key", newJString(key))
  add(query_594212, "prettyPrint", newJBool(prettyPrint))
  result = call_594210.call(path_594211, query_594212, nil, nil, nil)

var tagmanagerAccountsContainersFoldersGet* = Call_TagmanagerAccountsContainersFoldersGet_594196(
    name: "tagmanagerAccountsContainersFoldersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/folders/{folderId}",
    validator: validate_TagmanagerAccountsContainersFoldersGet_594197,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersFoldersGet_594198,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersFoldersDelete_594233 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersFoldersDelete_594235(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersFoldersDelete_594234(path: JsonNode;
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
  var valid_594236 = path.getOrDefault("containerId")
  valid_594236 = validateParameter(valid_594236, JString, required = true,
                                 default = nil)
  if valid_594236 != nil:
    section.add "containerId", valid_594236
  var valid_594237 = path.getOrDefault("accountId")
  valid_594237 = validateParameter(valid_594237, JString, required = true,
                                 default = nil)
  if valid_594237 != nil:
    section.add "accountId", valid_594237
  var valid_594238 = path.getOrDefault("folderId")
  valid_594238 = validateParameter(valid_594238, JString, required = true,
                                 default = nil)
  if valid_594238 != nil:
    section.add "folderId", valid_594238
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
  var valid_594239 = query.getOrDefault("fields")
  valid_594239 = validateParameter(valid_594239, JString, required = false,
                                 default = nil)
  if valid_594239 != nil:
    section.add "fields", valid_594239
  var valid_594240 = query.getOrDefault("quotaUser")
  valid_594240 = validateParameter(valid_594240, JString, required = false,
                                 default = nil)
  if valid_594240 != nil:
    section.add "quotaUser", valid_594240
  var valid_594241 = query.getOrDefault("alt")
  valid_594241 = validateParameter(valid_594241, JString, required = false,
                                 default = newJString("json"))
  if valid_594241 != nil:
    section.add "alt", valid_594241
  var valid_594242 = query.getOrDefault("oauth_token")
  valid_594242 = validateParameter(valid_594242, JString, required = false,
                                 default = nil)
  if valid_594242 != nil:
    section.add "oauth_token", valid_594242
  var valid_594243 = query.getOrDefault("userIp")
  valid_594243 = validateParameter(valid_594243, JString, required = false,
                                 default = nil)
  if valid_594243 != nil:
    section.add "userIp", valid_594243
  var valid_594244 = query.getOrDefault("key")
  valid_594244 = validateParameter(valid_594244, JString, required = false,
                                 default = nil)
  if valid_594244 != nil:
    section.add "key", valid_594244
  var valid_594245 = query.getOrDefault("prettyPrint")
  valid_594245 = validateParameter(valid_594245, JBool, required = false,
                                 default = newJBool(true))
  if valid_594245 != nil:
    section.add "prettyPrint", valid_594245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594246: Call_TagmanagerAccountsContainersFoldersDelete_594233;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a GTM Folder.
  ## 
  let valid = call_594246.validator(path, query, header, formData, body)
  let scheme = call_594246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594246.url(scheme.get, call_594246.host, call_594246.base,
                         call_594246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594246, url, valid)

proc call*(call_594247: Call_TagmanagerAccountsContainersFoldersDelete_594233;
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
  var path_594248 = newJObject()
  var query_594249 = newJObject()
  add(path_594248, "containerId", newJString(containerId))
  add(query_594249, "fields", newJString(fields))
  add(query_594249, "quotaUser", newJString(quotaUser))
  add(query_594249, "alt", newJString(alt))
  add(query_594249, "oauth_token", newJString(oauthToken))
  add(path_594248, "accountId", newJString(accountId))
  add(query_594249, "userIp", newJString(userIp))
  add(path_594248, "folderId", newJString(folderId))
  add(query_594249, "key", newJString(key))
  add(query_594249, "prettyPrint", newJBool(prettyPrint))
  result = call_594247.call(path_594248, query_594249, nil, nil, nil)

var tagmanagerAccountsContainersFoldersDelete* = Call_TagmanagerAccountsContainersFoldersDelete_594233(
    name: "tagmanagerAccountsContainersFoldersDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/folders/{folderId}",
    validator: validate_TagmanagerAccountsContainersFoldersDelete_594234,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersFoldersDelete_594235,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersFoldersEntitiesList_594250 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersFoldersEntitiesList_594252(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersFoldersEntitiesList_594251(
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
  var valid_594253 = path.getOrDefault("containerId")
  valid_594253 = validateParameter(valid_594253, JString, required = true,
                                 default = nil)
  if valid_594253 != nil:
    section.add "containerId", valid_594253
  var valid_594254 = path.getOrDefault("accountId")
  valid_594254 = validateParameter(valid_594254, JString, required = true,
                                 default = nil)
  if valid_594254 != nil:
    section.add "accountId", valid_594254
  var valid_594255 = path.getOrDefault("folderId")
  valid_594255 = validateParameter(valid_594255, JString, required = true,
                                 default = nil)
  if valid_594255 != nil:
    section.add "folderId", valid_594255
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
  var valid_594256 = query.getOrDefault("fields")
  valid_594256 = validateParameter(valid_594256, JString, required = false,
                                 default = nil)
  if valid_594256 != nil:
    section.add "fields", valid_594256
  var valid_594257 = query.getOrDefault("quotaUser")
  valid_594257 = validateParameter(valid_594257, JString, required = false,
                                 default = nil)
  if valid_594257 != nil:
    section.add "quotaUser", valid_594257
  var valid_594258 = query.getOrDefault("alt")
  valid_594258 = validateParameter(valid_594258, JString, required = false,
                                 default = newJString("json"))
  if valid_594258 != nil:
    section.add "alt", valid_594258
  var valid_594259 = query.getOrDefault("oauth_token")
  valid_594259 = validateParameter(valid_594259, JString, required = false,
                                 default = nil)
  if valid_594259 != nil:
    section.add "oauth_token", valid_594259
  var valid_594260 = query.getOrDefault("userIp")
  valid_594260 = validateParameter(valid_594260, JString, required = false,
                                 default = nil)
  if valid_594260 != nil:
    section.add "userIp", valid_594260
  var valid_594261 = query.getOrDefault("key")
  valid_594261 = validateParameter(valid_594261, JString, required = false,
                                 default = nil)
  if valid_594261 != nil:
    section.add "key", valid_594261
  var valid_594262 = query.getOrDefault("prettyPrint")
  valid_594262 = validateParameter(valid_594262, JBool, required = false,
                                 default = newJBool(true))
  if valid_594262 != nil:
    section.add "prettyPrint", valid_594262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594263: Call_TagmanagerAccountsContainersFoldersEntitiesList_594250;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all entities in a GTM Folder.
  ## 
  let valid = call_594263.validator(path, query, header, formData, body)
  let scheme = call_594263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594263.url(scheme.get, call_594263.host, call_594263.base,
                         call_594263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594263, url, valid)

proc call*(call_594264: Call_TagmanagerAccountsContainersFoldersEntitiesList_594250;
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
  var path_594265 = newJObject()
  var query_594266 = newJObject()
  add(path_594265, "containerId", newJString(containerId))
  add(query_594266, "fields", newJString(fields))
  add(query_594266, "quotaUser", newJString(quotaUser))
  add(query_594266, "alt", newJString(alt))
  add(query_594266, "oauth_token", newJString(oauthToken))
  add(path_594265, "accountId", newJString(accountId))
  add(query_594266, "userIp", newJString(userIp))
  add(path_594265, "folderId", newJString(folderId))
  add(query_594266, "key", newJString(key))
  add(query_594266, "prettyPrint", newJBool(prettyPrint))
  result = call_594264.call(path_594265, query_594266, nil, nil, nil)

var tagmanagerAccountsContainersFoldersEntitiesList* = Call_TagmanagerAccountsContainersFoldersEntitiesList_594250(
    name: "tagmanagerAccountsContainersFoldersEntitiesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/folders/{folderId}/entities",
    validator: validate_TagmanagerAccountsContainersFoldersEntitiesList_594251,
    base: "/tagmanager/v1",
    url: url_TagmanagerAccountsContainersFoldersEntitiesList_594252,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersMoveFoldersUpdate_594267 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersMoveFoldersUpdate_594269(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersMoveFoldersUpdate_594268(
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
  var valid_594270 = path.getOrDefault("containerId")
  valid_594270 = validateParameter(valid_594270, JString, required = true,
                                 default = nil)
  if valid_594270 != nil:
    section.add "containerId", valid_594270
  var valid_594271 = path.getOrDefault("accountId")
  valid_594271 = validateParameter(valid_594271, JString, required = true,
                                 default = nil)
  if valid_594271 != nil:
    section.add "accountId", valid_594271
  var valid_594272 = path.getOrDefault("folderId")
  valid_594272 = validateParameter(valid_594272, JString, required = true,
                                 default = nil)
  if valid_594272 != nil:
    section.add "folderId", valid_594272
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
  var valid_594273 = query.getOrDefault("fields")
  valid_594273 = validateParameter(valid_594273, JString, required = false,
                                 default = nil)
  if valid_594273 != nil:
    section.add "fields", valid_594273
  var valid_594274 = query.getOrDefault("quotaUser")
  valid_594274 = validateParameter(valid_594274, JString, required = false,
                                 default = nil)
  if valid_594274 != nil:
    section.add "quotaUser", valid_594274
  var valid_594275 = query.getOrDefault("alt")
  valid_594275 = validateParameter(valid_594275, JString, required = false,
                                 default = newJString("json"))
  if valid_594275 != nil:
    section.add "alt", valid_594275
  var valid_594276 = query.getOrDefault("oauth_token")
  valid_594276 = validateParameter(valid_594276, JString, required = false,
                                 default = nil)
  if valid_594276 != nil:
    section.add "oauth_token", valid_594276
  var valid_594277 = query.getOrDefault("userIp")
  valid_594277 = validateParameter(valid_594277, JString, required = false,
                                 default = nil)
  if valid_594277 != nil:
    section.add "userIp", valid_594277
  var valid_594278 = query.getOrDefault("key")
  valid_594278 = validateParameter(valid_594278, JString, required = false,
                                 default = nil)
  if valid_594278 != nil:
    section.add "key", valid_594278
  var valid_594279 = query.getOrDefault("triggerId")
  valid_594279 = validateParameter(valid_594279, JArray, required = false,
                                 default = nil)
  if valid_594279 != nil:
    section.add "triggerId", valid_594279
  var valid_594280 = query.getOrDefault("prettyPrint")
  valid_594280 = validateParameter(valid_594280, JBool, required = false,
                                 default = newJBool(true))
  if valid_594280 != nil:
    section.add "prettyPrint", valid_594280
  var valid_594281 = query.getOrDefault("tagId")
  valid_594281 = validateParameter(valid_594281, JArray, required = false,
                                 default = nil)
  if valid_594281 != nil:
    section.add "tagId", valid_594281
  var valid_594282 = query.getOrDefault("variableId")
  valid_594282 = validateParameter(valid_594282, JArray, required = false,
                                 default = nil)
  if valid_594282 != nil:
    section.add "variableId", valid_594282
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

proc call*(call_594284: Call_TagmanagerAccountsContainersMoveFoldersUpdate_594267;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Moves entities to a GTM Folder.
  ## 
  let valid = call_594284.validator(path, query, header, formData, body)
  let scheme = call_594284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594284.url(scheme.get, call_594284.host, call_594284.base,
                         call_594284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594284, url, valid)

proc call*(call_594285: Call_TagmanagerAccountsContainersMoveFoldersUpdate_594267;
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
  var path_594286 = newJObject()
  var query_594287 = newJObject()
  var body_594288 = newJObject()
  add(path_594286, "containerId", newJString(containerId))
  add(query_594287, "fields", newJString(fields))
  add(query_594287, "quotaUser", newJString(quotaUser))
  add(query_594287, "alt", newJString(alt))
  add(query_594287, "oauth_token", newJString(oauthToken))
  add(path_594286, "accountId", newJString(accountId))
  add(query_594287, "userIp", newJString(userIp))
  add(path_594286, "folderId", newJString(folderId))
  add(query_594287, "key", newJString(key))
  if triggerId != nil:
    query_594287.add "triggerId", triggerId
  if body != nil:
    body_594288 = body
  add(query_594287, "prettyPrint", newJBool(prettyPrint))
  if tagId != nil:
    query_594287.add "tagId", tagId
  if variableId != nil:
    query_594287.add "variableId", variableId
  result = call_594285.call(path_594286, query_594287, nil, nil, body_594288)

var tagmanagerAccountsContainersMoveFoldersUpdate* = Call_TagmanagerAccountsContainersMoveFoldersUpdate_594267(
    name: "tagmanagerAccountsContainersMoveFoldersUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/move_folders/{folderId}",
    validator: validate_TagmanagerAccountsContainersMoveFoldersUpdate_594268,
    base: "/tagmanager/v1",
    url: url_TagmanagerAccountsContainersMoveFoldersUpdate_594269,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_594289 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_594291(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_594290(
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
  var valid_594292 = path.getOrDefault("containerId")
  valid_594292 = validateParameter(valid_594292, JString, required = true,
                                 default = nil)
  if valid_594292 != nil:
    section.add "containerId", valid_594292
  var valid_594293 = path.getOrDefault("accountId")
  valid_594293 = validateParameter(valid_594293, JString, required = true,
                                 default = nil)
  if valid_594293 != nil:
    section.add "accountId", valid_594293
  var valid_594294 = path.getOrDefault("environmentId")
  valid_594294 = validateParameter(valid_594294, JString, required = true,
                                 default = nil)
  if valid_594294 != nil:
    section.add "environmentId", valid_594294
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
  var valid_594295 = query.getOrDefault("fields")
  valid_594295 = validateParameter(valid_594295, JString, required = false,
                                 default = nil)
  if valid_594295 != nil:
    section.add "fields", valid_594295
  var valid_594296 = query.getOrDefault("quotaUser")
  valid_594296 = validateParameter(valid_594296, JString, required = false,
                                 default = nil)
  if valid_594296 != nil:
    section.add "quotaUser", valid_594296
  var valid_594297 = query.getOrDefault("alt")
  valid_594297 = validateParameter(valid_594297, JString, required = false,
                                 default = newJString("json"))
  if valid_594297 != nil:
    section.add "alt", valid_594297
  var valid_594298 = query.getOrDefault("oauth_token")
  valid_594298 = validateParameter(valid_594298, JString, required = false,
                                 default = nil)
  if valid_594298 != nil:
    section.add "oauth_token", valid_594298
  var valid_594299 = query.getOrDefault("userIp")
  valid_594299 = validateParameter(valid_594299, JString, required = false,
                                 default = nil)
  if valid_594299 != nil:
    section.add "userIp", valid_594299
  var valid_594300 = query.getOrDefault("key")
  valid_594300 = validateParameter(valid_594300, JString, required = false,
                                 default = nil)
  if valid_594300 != nil:
    section.add "key", valid_594300
  var valid_594301 = query.getOrDefault("prettyPrint")
  valid_594301 = validateParameter(valid_594301, JBool, required = false,
                                 default = newJBool(true))
  if valid_594301 != nil:
    section.add "prettyPrint", valid_594301
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

proc call*(call_594303: Call_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_594289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Re-generates the authorization code for a GTM Environment.
  ## 
  let valid = call_594303.validator(path, query, header, formData, body)
  let scheme = call_594303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594303.url(scheme.get, call_594303.host, call_594303.base,
                         call_594303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594303, url, valid)

proc call*(call_594304: Call_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_594289;
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
  var path_594305 = newJObject()
  var query_594306 = newJObject()
  var body_594307 = newJObject()
  add(path_594305, "containerId", newJString(containerId))
  add(query_594306, "fields", newJString(fields))
  add(query_594306, "quotaUser", newJString(quotaUser))
  add(query_594306, "alt", newJString(alt))
  add(query_594306, "oauth_token", newJString(oauthToken))
  add(path_594305, "accountId", newJString(accountId))
  add(query_594306, "userIp", newJString(userIp))
  add(query_594306, "key", newJString(key))
  add(path_594305, "environmentId", newJString(environmentId))
  if body != nil:
    body_594307 = body
  add(query_594306, "prettyPrint", newJBool(prettyPrint))
  result = call_594304.call(path_594305, query_594306, nil, nil, body_594307)

var tagmanagerAccountsContainersReauthorizeEnvironmentsUpdate* = Call_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_594289(
    name: "tagmanagerAccountsContainersReauthorizeEnvironmentsUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/reauthorize_environments/{environmentId}", validator: validate_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_594290,
    base: "/tagmanager/v1",
    url: url_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_594291,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTagsCreate_594324 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersTagsCreate_594326(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersTagsCreate_594325(path: JsonNode;
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
  var valid_594327 = path.getOrDefault("containerId")
  valid_594327 = validateParameter(valid_594327, JString, required = true,
                                 default = nil)
  if valid_594327 != nil:
    section.add "containerId", valid_594327
  var valid_594328 = path.getOrDefault("accountId")
  valid_594328 = validateParameter(valid_594328, JString, required = true,
                                 default = nil)
  if valid_594328 != nil:
    section.add "accountId", valid_594328
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
  var valid_594329 = query.getOrDefault("fields")
  valid_594329 = validateParameter(valid_594329, JString, required = false,
                                 default = nil)
  if valid_594329 != nil:
    section.add "fields", valid_594329
  var valid_594330 = query.getOrDefault("quotaUser")
  valid_594330 = validateParameter(valid_594330, JString, required = false,
                                 default = nil)
  if valid_594330 != nil:
    section.add "quotaUser", valid_594330
  var valid_594331 = query.getOrDefault("alt")
  valid_594331 = validateParameter(valid_594331, JString, required = false,
                                 default = newJString("json"))
  if valid_594331 != nil:
    section.add "alt", valid_594331
  var valid_594332 = query.getOrDefault("oauth_token")
  valid_594332 = validateParameter(valid_594332, JString, required = false,
                                 default = nil)
  if valid_594332 != nil:
    section.add "oauth_token", valid_594332
  var valid_594333 = query.getOrDefault("userIp")
  valid_594333 = validateParameter(valid_594333, JString, required = false,
                                 default = nil)
  if valid_594333 != nil:
    section.add "userIp", valid_594333
  var valid_594334 = query.getOrDefault("key")
  valid_594334 = validateParameter(valid_594334, JString, required = false,
                                 default = nil)
  if valid_594334 != nil:
    section.add "key", valid_594334
  var valid_594335 = query.getOrDefault("prettyPrint")
  valid_594335 = validateParameter(valid_594335, JBool, required = false,
                                 default = newJBool(true))
  if valid_594335 != nil:
    section.add "prettyPrint", valid_594335
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

proc call*(call_594337: Call_TagmanagerAccountsContainersTagsCreate_594324;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a GTM Tag.
  ## 
  let valid = call_594337.validator(path, query, header, formData, body)
  let scheme = call_594337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594337.url(scheme.get, call_594337.host, call_594337.base,
                         call_594337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594337, url, valid)

proc call*(call_594338: Call_TagmanagerAccountsContainersTagsCreate_594324;
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
  var path_594339 = newJObject()
  var query_594340 = newJObject()
  var body_594341 = newJObject()
  add(path_594339, "containerId", newJString(containerId))
  add(query_594340, "fields", newJString(fields))
  add(query_594340, "quotaUser", newJString(quotaUser))
  add(query_594340, "alt", newJString(alt))
  add(query_594340, "oauth_token", newJString(oauthToken))
  add(path_594339, "accountId", newJString(accountId))
  add(query_594340, "userIp", newJString(userIp))
  add(query_594340, "key", newJString(key))
  if body != nil:
    body_594341 = body
  add(query_594340, "prettyPrint", newJBool(prettyPrint))
  result = call_594338.call(path_594339, query_594340, nil, nil, body_594341)

var tagmanagerAccountsContainersTagsCreate* = Call_TagmanagerAccountsContainersTagsCreate_594324(
    name: "tagmanagerAccountsContainersTagsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/tags",
    validator: validate_TagmanagerAccountsContainersTagsCreate_594325,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTagsCreate_594326,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTagsList_594308 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersTagsList_594310(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersTagsList_594309(path: JsonNode;
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
  var valid_594311 = path.getOrDefault("containerId")
  valid_594311 = validateParameter(valid_594311, JString, required = true,
                                 default = nil)
  if valid_594311 != nil:
    section.add "containerId", valid_594311
  var valid_594312 = path.getOrDefault("accountId")
  valid_594312 = validateParameter(valid_594312, JString, required = true,
                                 default = nil)
  if valid_594312 != nil:
    section.add "accountId", valid_594312
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
  var valid_594313 = query.getOrDefault("fields")
  valid_594313 = validateParameter(valid_594313, JString, required = false,
                                 default = nil)
  if valid_594313 != nil:
    section.add "fields", valid_594313
  var valid_594314 = query.getOrDefault("quotaUser")
  valid_594314 = validateParameter(valid_594314, JString, required = false,
                                 default = nil)
  if valid_594314 != nil:
    section.add "quotaUser", valid_594314
  var valid_594315 = query.getOrDefault("alt")
  valid_594315 = validateParameter(valid_594315, JString, required = false,
                                 default = newJString("json"))
  if valid_594315 != nil:
    section.add "alt", valid_594315
  var valid_594316 = query.getOrDefault("oauth_token")
  valid_594316 = validateParameter(valid_594316, JString, required = false,
                                 default = nil)
  if valid_594316 != nil:
    section.add "oauth_token", valid_594316
  var valid_594317 = query.getOrDefault("userIp")
  valid_594317 = validateParameter(valid_594317, JString, required = false,
                                 default = nil)
  if valid_594317 != nil:
    section.add "userIp", valid_594317
  var valid_594318 = query.getOrDefault("key")
  valid_594318 = validateParameter(valid_594318, JString, required = false,
                                 default = nil)
  if valid_594318 != nil:
    section.add "key", valid_594318
  var valid_594319 = query.getOrDefault("prettyPrint")
  valid_594319 = validateParameter(valid_594319, JBool, required = false,
                                 default = newJBool(true))
  if valid_594319 != nil:
    section.add "prettyPrint", valid_594319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594320: Call_TagmanagerAccountsContainersTagsList_594308;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all GTM Tags of a Container.
  ## 
  let valid = call_594320.validator(path, query, header, formData, body)
  let scheme = call_594320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594320.url(scheme.get, call_594320.host, call_594320.base,
                         call_594320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594320, url, valid)

proc call*(call_594321: Call_TagmanagerAccountsContainersTagsList_594308;
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
  var path_594322 = newJObject()
  var query_594323 = newJObject()
  add(path_594322, "containerId", newJString(containerId))
  add(query_594323, "fields", newJString(fields))
  add(query_594323, "quotaUser", newJString(quotaUser))
  add(query_594323, "alt", newJString(alt))
  add(query_594323, "oauth_token", newJString(oauthToken))
  add(path_594322, "accountId", newJString(accountId))
  add(query_594323, "userIp", newJString(userIp))
  add(query_594323, "key", newJString(key))
  add(query_594323, "prettyPrint", newJBool(prettyPrint))
  result = call_594321.call(path_594322, query_594323, nil, nil, nil)

var tagmanagerAccountsContainersTagsList* = Call_TagmanagerAccountsContainersTagsList_594308(
    name: "tagmanagerAccountsContainersTagsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/tags",
    validator: validate_TagmanagerAccountsContainersTagsList_594309,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTagsList_594310,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTagsUpdate_594359 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersTagsUpdate_594361(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersTagsUpdate_594360(path: JsonNode;
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
  var valid_594362 = path.getOrDefault("containerId")
  valid_594362 = validateParameter(valid_594362, JString, required = true,
                                 default = nil)
  if valid_594362 != nil:
    section.add "containerId", valid_594362
  var valid_594363 = path.getOrDefault("tagId")
  valid_594363 = validateParameter(valid_594363, JString, required = true,
                                 default = nil)
  if valid_594363 != nil:
    section.add "tagId", valid_594363
  var valid_594364 = path.getOrDefault("accountId")
  valid_594364 = validateParameter(valid_594364, JString, required = true,
                                 default = nil)
  if valid_594364 != nil:
    section.add "accountId", valid_594364
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
  var valid_594365 = query.getOrDefault("fields")
  valid_594365 = validateParameter(valid_594365, JString, required = false,
                                 default = nil)
  if valid_594365 != nil:
    section.add "fields", valid_594365
  var valid_594366 = query.getOrDefault("fingerprint")
  valid_594366 = validateParameter(valid_594366, JString, required = false,
                                 default = nil)
  if valid_594366 != nil:
    section.add "fingerprint", valid_594366
  var valid_594367 = query.getOrDefault("quotaUser")
  valid_594367 = validateParameter(valid_594367, JString, required = false,
                                 default = nil)
  if valid_594367 != nil:
    section.add "quotaUser", valid_594367
  var valid_594368 = query.getOrDefault("alt")
  valid_594368 = validateParameter(valid_594368, JString, required = false,
                                 default = newJString("json"))
  if valid_594368 != nil:
    section.add "alt", valid_594368
  var valid_594369 = query.getOrDefault("oauth_token")
  valid_594369 = validateParameter(valid_594369, JString, required = false,
                                 default = nil)
  if valid_594369 != nil:
    section.add "oauth_token", valid_594369
  var valid_594370 = query.getOrDefault("userIp")
  valid_594370 = validateParameter(valid_594370, JString, required = false,
                                 default = nil)
  if valid_594370 != nil:
    section.add "userIp", valid_594370
  var valid_594371 = query.getOrDefault("key")
  valid_594371 = validateParameter(valid_594371, JString, required = false,
                                 default = nil)
  if valid_594371 != nil:
    section.add "key", valid_594371
  var valid_594372 = query.getOrDefault("prettyPrint")
  valid_594372 = validateParameter(valid_594372, JBool, required = false,
                                 default = newJBool(true))
  if valid_594372 != nil:
    section.add "prettyPrint", valid_594372
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

proc call*(call_594374: Call_TagmanagerAccountsContainersTagsUpdate_594359;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a GTM Tag.
  ## 
  let valid = call_594374.validator(path, query, header, formData, body)
  let scheme = call_594374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594374.url(scheme.get, call_594374.host, call_594374.base,
                         call_594374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594374, url, valid)

proc call*(call_594375: Call_TagmanagerAccountsContainersTagsUpdate_594359;
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
  var path_594376 = newJObject()
  var query_594377 = newJObject()
  var body_594378 = newJObject()
  add(path_594376, "containerId", newJString(containerId))
  add(path_594376, "tagId", newJString(tagId))
  add(query_594377, "fields", newJString(fields))
  add(query_594377, "fingerprint", newJString(fingerprint))
  add(query_594377, "quotaUser", newJString(quotaUser))
  add(query_594377, "alt", newJString(alt))
  add(query_594377, "oauth_token", newJString(oauthToken))
  add(path_594376, "accountId", newJString(accountId))
  add(query_594377, "userIp", newJString(userIp))
  add(query_594377, "key", newJString(key))
  if body != nil:
    body_594378 = body
  add(query_594377, "prettyPrint", newJBool(prettyPrint))
  result = call_594375.call(path_594376, query_594377, nil, nil, body_594378)

var tagmanagerAccountsContainersTagsUpdate* = Call_TagmanagerAccountsContainersTagsUpdate_594359(
    name: "tagmanagerAccountsContainersTagsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/tags/{tagId}",
    validator: validate_TagmanagerAccountsContainersTagsUpdate_594360,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTagsUpdate_594361,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTagsGet_594342 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersTagsGet_594344(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersTagsGet_594343(path: JsonNode;
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
  var valid_594345 = path.getOrDefault("containerId")
  valid_594345 = validateParameter(valid_594345, JString, required = true,
                                 default = nil)
  if valid_594345 != nil:
    section.add "containerId", valid_594345
  var valid_594346 = path.getOrDefault("tagId")
  valid_594346 = validateParameter(valid_594346, JString, required = true,
                                 default = nil)
  if valid_594346 != nil:
    section.add "tagId", valid_594346
  var valid_594347 = path.getOrDefault("accountId")
  valid_594347 = validateParameter(valid_594347, JString, required = true,
                                 default = nil)
  if valid_594347 != nil:
    section.add "accountId", valid_594347
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
  var valid_594348 = query.getOrDefault("fields")
  valid_594348 = validateParameter(valid_594348, JString, required = false,
                                 default = nil)
  if valid_594348 != nil:
    section.add "fields", valid_594348
  var valid_594349 = query.getOrDefault("quotaUser")
  valid_594349 = validateParameter(valid_594349, JString, required = false,
                                 default = nil)
  if valid_594349 != nil:
    section.add "quotaUser", valid_594349
  var valid_594350 = query.getOrDefault("alt")
  valid_594350 = validateParameter(valid_594350, JString, required = false,
                                 default = newJString("json"))
  if valid_594350 != nil:
    section.add "alt", valid_594350
  var valid_594351 = query.getOrDefault("oauth_token")
  valid_594351 = validateParameter(valid_594351, JString, required = false,
                                 default = nil)
  if valid_594351 != nil:
    section.add "oauth_token", valid_594351
  var valid_594352 = query.getOrDefault("userIp")
  valid_594352 = validateParameter(valid_594352, JString, required = false,
                                 default = nil)
  if valid_594352 != nil:
    section.add "userIp", valid_594352
  var valid_594353 = query.getOrDefault("key")
  valid_594353 = validateParameter(valid_594353, JString, required = false,
                                 default = nil)
  if valid_594353 != nil:
    section.add "key", valid_594353
  var valid_594354 = query.getOrDefault("prettyPrint")
  valid_594354 = validateParameter(valid_594354, JBool, required = false,
                                 default = newJBool(true))
  if valid_594354 != nil:
    section.add "prettyPrint", valid_594354
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594355: Call_TagmanagerAccountsContainersTagsGet_594342;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a GTM Tag.
  ## 
  let valid = call_594355.validator(path, query, header, formData, body)
  let scheme = call_594355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594355.url(scheme.get, call_594355.host, call_594355.base,
                         call_594355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594355, url, valid)

proc call*(call_594356: Call_TagmanagerAccountsContainersTagsGet_594342;
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
  var path_594357 = newJObject()
  var query_594358 = newJObject()
  add(path_594357, "containerId", newJString(containerId))
  add(path_594357, "tagId", newJString(tagId))
  add(query_594358, "fields", newJString(fields))
  add(query_594358, "quotaUser", newJString(quotaUser))
  add(query_594358, "alt", newJString(alt))
  add(query_594358, "oauth_token", newJString(oauthToken))
  add(path_594357, "accountId", newJString(accountId))
  add(query_594358, "userIp", newJString(userIp))
  add(query_594358, "key", newJString(key))
  add(query_594358, "prettyPrint", newJBool(prettyPrint))
  result = call_594356.call(path_594357, query_594358, nil, nil, nil)

var tagmanagerAccountsContainersTagsGet* = Call_TagmanagerAccountsContainersTagsGet_594342(
    name: "tagmanagerAccountsContainersTagsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/tags/{tagId}",
    validator: validate_TagmanagerAccountsContainersTagsGet_594343,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTagsGet_594344,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTagsDelete_594379 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersTagsDelete_594381(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersTagsDelete_594380(path: JsonNode;
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
  var valid_594382 = path.getOrDefault("containerId")
  valid_594382 = validateParameter(valid_594382, JString, required = true,
                                 default = nil)
  if valid_594382 != nil:
    section.add "containerId", valid_594382
  var valid_594383 = path.getOrDefault("tagId")
  valid_594383 = validateParameter(valid_594383, JString, required = true,
                                 default = nil)
  if valid_594383 != nil:
    section.add "tagId", valid_594383
  var valid_594384 = path.getOrDefault("accountId")
  valid_594384 = validateParameter(valid_594384, JString, required = true,
                                 default = nil)
  if valid_594384 != nil:
    section.add "accountId", valid_594384
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
  var valid_594385 = query.getOrDefault("fields")
  valid_594385 = validateParameter(valid_594385, JString, required = false,
                                 default = nil)
  if valid_594385 != nil:
    section.add "fields", valid_594385
  var valid_594386 = query.getOrDefault("quotaUser")
  valid_594386 = validateParameter(valid_594386, JString, required = false,
                                 default = nil)
  if valid_594386 != nil:
    section.add "quotaUser", valid_594386
  var valid_594387 = query.getOrDefault("alt")
  valid_594387 = validateParameter(valid_594387, JString, required = false,
                                 default = newJString("json"))
  if valid_594387 != nil:
    section.add "alt", valid_594387
  var valid_594388 = query.getOrDefault("oauth_token")
  valid_594388 = validateParameter(valid_594388, JString, required = false,
                                 default = nil)
  if valid_594388 != nil:
    section.add "oauth_token", valid_594388
  var valid_594389 = query.getOrDefault("userIp")
  valid_594389 = validateParameter(valid_594389, JString, required = false,
                                 default = nil)
  if valid_594389 != nil:
    section.add "userIp", valid_594389
  var valid_594390 = query.getOrDefault("key")
  valid_594390 = validateParameter(valid_594390, JString, required = false,
                                 default = nil)
  if valid_594390 != nil:
    section.add "key", valid_594390
  var valid_594391 = query.getOrDefault("prettyPrint")
  valid_594391 = validateParameter(valid_594391, JBool, required = false,
                                 default = newJBool(true))
  if valid_594391 != nil:
    section.add "prettyPrint", valid_594391
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594392: Call_TagmanagerAccountsContainersTagsDelete_594379;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a GTM Tag.
  ## 
  let valid = call_594392.validator(path, query, header, formData, body)
  let scheme = call_594392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594392.url(scheme.get, call_594392.host, call_594392.base,
                         call_594392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594392, url, valid)

proc call*(call_594393: Call_TagmanagerAccountsContainersTagsDelete_594379;
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
  var path_594394 = newJObject()
  var query_594395 = newJObject()
  add(path_594394, "containerId", newJString(containerId))
  add(path_594394, "tagId", newJString(tagId))
  add(query_594395, "fields", newJString(fields))
  add(query_594395, "quotaUser", newJString(quotaUser))
  add(query_594395, "alt", newJString(alt))
  add(query_594395, "oauth_token", newJString(oauthToken))
  add(path_594394, "accountId", newJString(accountId))
  add(query_594395, "userIp", newJString(userIp))
  add(query_594395, "key", newJString(key))
  add(query_594395, "prettyPrint", newJBool(prettyPrint))
  result = call_594393.call(path_594394, query_594395, nil, nil, nil)

var tagmanagerAccountsContainersTagsDelete* = Call_TagmanagerAccountsContainersTagsDelete_594379(
    name: "tagmanagerAccountsContainersTagsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/tags/{tagId}",
    validator: validate_TagmanagerAccountsContainersTagsDelete_594380,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTagsDelete_594381,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTriggersCreate_594412 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersTriggersCreate_594414(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersTriggersCreate_594413(path: JsonNode;
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
  var valid_594415 = path.getOrDefault("containerId")
  valid_594415 = validateParameter(valid_594415, JString, required = true,
                                 default = nil)
  if valid_594415 != nil:
    section.add "containerId", valid_594415
  var valid_594416 = path.getOrDefault("accountId")
  valid_594416 = validateParameter(valid_594416, JString, required = true,
                                 default = nil)
  if valid_594416 != nil:
    section.add "accountId", valid_594416
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
  var valid_594417 = query.getOrDefault("fields")
  valid_594417 = validateParameter(valid_594417, JString, required = false,
                                 default = nil)
  if valid_594417 != nil:
    section.add "fields", valid_594417
  var valid_594418 = query.getOrDefault("quotaUser")
  valid_594418 = validateParameter(valid_594418, JString, required = false,
                                 default = nil)
  if valid_594418 != nil:
    section.add "quotaUser", valid_594418
  var valid_594419 = query.getOrDefault("alt")
  valid_594419 = validateParameter(valid_594419, JString, required = false,
                                 default = newJString("json"))
  if valid_594419 != nil:
    section.add "alt", valid_594419
  var valid_594420 = query.getOrDefault("oauth_token")
  valid_594420 = validateParameter(valid_594420, JString, required = false,
                                 default = nil)
  if valid_594420 != nil:
    section.add "oauth_token", valid_594420
  var valid_594421 = query.getOrDefault("userIp")
  valid_594421 = validateParameter(valid_594421, JString, required = false,
                                 default = nil)
  if valid_594421 != nil:
    section.add "userIp", valid_594421
  var valid_594422 = query.getOrDefault("key")
  valid_594422 = validateParameter(valid_594422, JString, required = false,
                                 default = nil)
  if valid_594422 != nil:
    section.add "key", valid_594422
  var valid_594423 = query.getOrDefault("prettyPrint")
  valid_594423 = validateParameter(valid_594423, JBool, required = false,
                                 default = newJBool(true))
  if valid_594423 != nil:
    section.add "prettyPrint", valid_594423
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

proc call*(call_594425: Call_TagmanagerAccountsContainersTriggersCreate_594412;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a GTM Trigger.
  ## 
  let valid = call_594425.validator(path, query, header, formData, body)
  let scheme = call_594425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594425.url(scheme.get, call_594425.host, call_594425.base,
                         call_594425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594425, url, valid)

proc call*(call_594426: Call_TagmanagerAccountsContainersTriggersCreate_594412;
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
  var path_594427 = newJObject()
  var query_594428 = newJObject()
  var body_594429 = newJObject()
  add(path_594427, "containerId", newJString(containerId))
  add(query_594428, "fields", newJString(fields))
  add(query_594428, "quotaUser", newJString(quotaUser))
  add(query_594428, "alt", newJString(alt))
  add(query_594428, "oauth_token", newJString(oauthToken))
  add(path_594427, "accountId", newJString(accountId))
  add(query_594428, "userIp", newJString(userIp))
  add(query_594428, "key", newJString(key))
  if body != nil:
    body_594429 = body
  add(query_594428, "prettyPrint", newJBool(prettyPrint))
  result = call_594426.call(path_594427, query_594428, nil, nil, body_594429)

var tagmanagerAccountsContainersTriggersCreate* = Call_TagmanagerAccountsContainersTriggersCreate_594412(
    name: "tagmanagerAccountsContainersTriggersCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/triggers",
    validator: validate_TagmanagerAccountsContainersTriggersCreate_594413,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTriggersCreate_594414,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTriggersList_594396 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersTriggersList_594398(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersTriggersList_594397(path: JsonNode;
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
  var valid_594399 = path.getOrDefault("containerId")
  valid_594399 = validateParameter(valid_594399, JString, required = true,
                                 default = nil)
  if valid_594399 != nil:
    section.add "containerId", valid_594399
  var valid_594400 = path.getOrDefault("accountId")
  valid_594400 = validateParameter(valid_594400, JString, required = true,
                                 default = nil)
  if valid_594400 != nil:
    section.add "accountId", valid_594400
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
  var valid_594401 = query.getOrDefault("fields")
  valid_594401 = validateParameter(valid_594401, JString, required = false,
                                 default = nil)
  if valid_594401 != nil:
    section.add "fields", valid_594401
  var valid_594402 = query.getOrDefault("quotaUser")
  valid_594402 = validateParameter(valid_594402, JString, required = false,
                                 default = nil)
  if valid_594402 != nil:
    section.add "quotaUser", valid_594402
  var valid_594403 = query.getOrDefault("alt")
  valid_594403 = validateParameter(valid_594403, JString, required = false,
                                 default = newJString("json"))
  if valid_594403 != nil:
    section.add "alt", valid_594403
  var valid_594404 = query.getOrDefault("oauth_token")
  valid_594404 = validateParameter(valid_594404, JString, required = false,
                                 default = nil)
  if valid_594404 != nil:
    section.add "oauth_token", valid_594404
  var valid_594405 = query.getOrDefault("userIp")
  valid_594405 = validateParameter(valid_594405, JString, required = false,
                                 default = nil)
  if valid_594405 != nil:
    section.add "userIp", valid_594405
  var valid_594406 = query.getOrDefault("key")
  valid_594406 = validateParameter(valid_594406, JString, required = false,
                                 default = nil)
  if valid_594406 != nil:
    section.add "key", valid_594406
  var valid_594407 = query.getOrDefault("prettyPrint")
  valid_594407 = validateParameter(valid_594407, JBool, required = false,
                                 default = newJBool(true))
  if valid_594407 != nil:
    section.add "prettyPrint", valid_594407
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594408: Call_TagmanagerAccountsContainersTriggersList_594396;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all GTM Triggers of a Container.
  ## 
  let valid = call_594408.validator(path, query, header, formData, body)
  let scheme = call_594408.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594408.url(scheme.get, call_594408.host, call_594408.base,
                         call_594408.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594408, url, valid)

proc call*(call_594409: Call_TagmanagerAccountsContainersTriggersList_594396;
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
  var path_594410 = newJObject()
  var query_594411 = newJObject()
  add(path_594410, "containerId", newJString(containerId))
  add(query_594411, "fields", newJString(fields))
  add(query_594411, "quotaUser", newJString(quotaUser))
  add(query_594411, "alt", newJString(alt))
  add(query_594411, "oauth_token", newJString(oauthToken))
  add(path_594410, "accountId", newJString(accountId))
  add(query_594411, "userIp", newJString(userIp))
  add(query_594411, "key", newJString(key))
  add(query_594411, "prettyPrint", newJBool(prettyPrint))
  result = call_594409.call(path_594410, query_594411, nil, nil, nil)

var tagmanagerAccountsContainersTriggersList* = Call_TagmanagerAccountsContainersTriggersList_594396(
    name: "tagmanagerAccountsContainersTriggersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/triggers",
    validator: validate_TagmanagerAccountsContainersTriggersList_594397,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTriggersList_594398,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTriggersUpdate_594447 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersTriggersUpdate_594449(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersTriggersUpdate_594448(path: JsonNode;
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
  var valid_594450 = path.getOrDefault("containerId")
  valid_594450 = validateParameter(valid_594450, JString, required = true,
                                 default = nil)
  if valid_594450 != nil:
    section.add "containerId", valid_594450
  var valid_594451 = path.getOrDefault("accountId")
  valid_594451 = validateParameter(valid_594451, JString, required = true,
                                 default = nil)
  if valid_594451 != nil:
    section.add "accountId", valid_594451
  var valid_594452 = path.getOrDefault("triggerId")
  valid_594452 = validateParameter(valid_594452, JString, required = true,
                                 default = nil)
  if valid_594452 != nil:
    section.add "triggerId", valid_594452
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
  var valid_594453 = query.getOrDefault("fields")
  valid_594453 = validateParameter(valid_594453, JString, required = false,
                                 default = nil)
  if valid_594453 != nil:
    section.add "fields", valid_594453
  var valid_594454 = query.getOrDefault("fingerprint")
  valid_594454 = validateParameter(valid_594454, JString, required = false,
                                 default = nil)
  if valid_594454 != nil:
    section.add "fingerprint", valid_594454
  var valid_594455 = query.getOrDefault("quotaUser")
  valid_594455 = validateParameter(valid_594455, JString, required = false,
                                 default = nil)
  if valid_594455 != nil:
    section.add "quotaUser", valid_594455
  var valid_594456 = query.getOrDefault("alt")
  valid_594456 = validateParameter(valid_594456, JString, required = false,
                                 default = newJString("json"))
  if valid_594456 != nil:
    section.add "alt", valid_594456
  var valid_594457 = query.getOrDefault("oauth_token")
  valid_594457 = validateParameter(valid_594457, JString, required = false,
                                 default = nil)
  if valid_594457 != nil:
    section.add "oauth_token", valid_594457
  var valid_594458 = query.getOrDefault("userIp")
  valid_594458 = validateParameter(valid_594458, JString, required = false,
                                 default = nil)
  if valid_594458 != nil:
    section.add "userIp", valid_594458
  var valid_594459 = query.getOrDefault("key")
  valid_594459 = validateParameter(valid_594459, JString, required = false,
                                 default = nil)
  if valid_594459 != nil:
    section.add "key", valid_594459
  var valid_594460 = query.getOrDefault("prettyPrint")
  valid_594460 = validateParameter(valid_594460, JBool, required = false,
                                 default = newJBool(true))
  if valid_594460 != nil:
    section.add "prettyPrint", valid_594460
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

proc call*(call_594462: Call_TagmanagerAccountsContainersTriggersUpdate_594447;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a GTM Trigger.
  ## 
  let valid = call_594462.validator(path, query, header, formData, body)
  let scheme = call_594462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594462.url(scheme.get, call_594462.host, call_594462.base,
                         call_594462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594462, url, valid)

proc call*(call_594463: Call_TagmanagerAccountsContainersTriggersUpdate_594447;
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
  var path_594464 = newJObject()
  var query_594465 = newJObject()
  var body_594466 = newJObject()
  add(path_594464, "containerId", newJString(containerId))
  add(query_594465, "fields", newJString(fields))
  add(query_594465, "fingerprint", newJString(fingerprint))
  add(query_594465, "quotaUser", newJString(quotaUser))
  add(query_594465, "alt", newJString(alt))
  add(query_594465, "oauth_token", newJString(oauthToken))
  add(path_594464, "accountId", newJString(accountId))
  add(query_594465, "userIp", newJString(userIp))
  add(path_594464, "triggerId", newJString(triggerId))
  add(query_594465, "key", newJString(key))
  if body != nil:
    body_594466 = body
  add(query_594465, "prettyPrint", newJBool(prettyPrint))
  result = call_594463.call(path_594464, query_594465, nil, nil, body_594466)

var tagmanagerAccountsContainersTriggersUpdate* = Call_TagmanagerAccountsContainersTriggersUpdate_594447(
    name: "tagmanagerAccountsContainersTriggersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/triggers/{triggerId}",
    validator: validate_TagmanagerAccountsContainersTriggersUpdate_594448,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTriggersUpdate_594449,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTriggersGet_594430 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersTriggersGet_594432(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersTriggersGet_594431(path: JsonNode;
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
  var valid_594433 = path.getOrDefault("containerId")
  valid_594433 = validateParameter(valid_594433, JString, required = true,
                                 default = nil)
  if valid_594433 != nil:
    section.add "containerId", valid_594433
  var valid_594434 = path.getOrDefault("accountId")
  valid_594434 = validateParameter(valid_594434, JString, required = true,
                                 default = nil)
  if valid_594434 != nil:
    section.add "accountId", valid_594434
  var valid_594435 = path.getOrDefault("triggerId")
  valid_594435 = validateParameter(valid_594435, JString, required = true,
                                 default = nil)
  if valid_594435 != nil:
    section.add "triggerId", valid_594435
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
  var valid_594436 = query.getOrDefault("fields")
  valid_594436 = validateParameter(valid_594436, JString, required = false,
                                 default = nil)
  if valid_594436 != nil:
    section.add "fields", valid_594436
  var valid_594437 = query.getOrDefault("quotaUser")
  valid_594437 = validateParameter(valid_594437, JString, required = false,
                                 default = nil)
  if valid_594437 != nil:
    section.add "quotaUser", valid_594437
  var valid_594438 = query.getOrDefault("alt")
  valid_594438 = validateParameter(valid_594438, JString, required = false,
                                 default = newJString("json"))
  if valid_594438 != nil:
    section.add "alt", valid_594438
  var valid_594439 = query.getOrDefault("oauth_token")
  valid_594439 = validateParameter(valid_594439, JString, required = false,
                                 default = nil)
  if valid_594439 != nil:
    section.add "oauth_token", valid_594439
  var valid_594440 = query.getOrDefault("userIp")
  valid_594440 = validateParameter(valid_594440, JString, required = false,
                                 default = nil)
  if valid_594440 != nil:
    section.add "userIp", valid_594440
  var valid_594441 = query.getOrDefault("key")
  valid_594441 = validateParameter(valid_594441, JString, required = false,
                                 default = nil)
  if valid_594441 != nil:
    section.add "key", valid_594441
  var valid_594442 = query.getOrDefault("prettyPrint")
  valid_594442 = validateParameter(valid_594442, JBool, required = false,
                                 default = newJBool(true))
  if valid_594442 != nil:
    section.add "prettyPrint", valid_594442
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594443: Call_TagmanagerAccountsContainersTriggersGet_594430;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a GTM Trigger.
  ## 
  let valid = call_594443.validator(path, query, header, formData, body)
  let scheme = call_594443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594443.url(scheme.get, call_594443.host, call_594443.base,
                         call_594443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594443, url, valid)

proc call*(call_594444: Call_TagmanagerAccountsContainersTriggersGet_594430;
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
  var path_594445 = newJObject()
  var query_594446 = newJObject()
  add(path_594445, "containerId", newJString(containerId))
  add(query_594446, "fields", newJString(fields))
  add(query_594446, "quotaUser", newJString(quotaUser))
  add(query_594446, "alt", newJString(alt))
  add(query_594446, "oauth_token", newJString(oauthToken))
  add(path_594445, "accountId", newJString(accountId))
  add(query_594446, "userIp", newJString(userIp))
  add(path_594445, "triggerId", newJString(triggerId))
  add(query_594446, "key", newJString(key))
  add(query_594446, "prettyPrint", newJBool(prettyPrint))
  result = call_594444.call(path_594445, query_594446, nil, nil, nil)

var tagmanagerAccountsContainersTriggersGet* = Call_TagmanagerAccountsContainersTriggersGet_594430(
    name: "tagmanagerAccountsContainersTriggersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/triggers/{triggerId}",
    validator: validate_TagmanagerAccountsContainersTriggersGet_594431,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTriggersGet_594432,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTriggersDelete_594467 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersTriggersDelete_594469(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersTriggersDelete_594468(path: JsonNode;
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
  var valid_594470 = path.getOrDefault("containerId")
  valid_594470 = validateParameter(valid_594470, JString, required = true,
                                 default = nil)
  if valid_594470 != nil:
    section.add "containerId", valid_594470
  var valid_594471 = path.getOrDefault("accountId")
  valid_594471 = validateParameter(valid_594471, JString, required = true,
                                 default = nil)
  if valid_594471 != nil:
    section.add "accountId", valid_594471
  var valid_594472 = path.getOrDefault("triggerId")
  valid_594472 = validateParameter(valid_594472, JString, required = true,
                                 default = nil)
  if valid_594472 != nil:
    section.add "triggerId", valid_594472
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
  var valid_594473 = query.getOrDefault("fields")
  valid_594473 = validateParameter(valid_594473, JString, required = false,
                                 default = nil)
  if valid_594473 != nil:
    section.add "fields", valid_594473
  var valid_594474 = query.getOrDefault("quotaUser")
  valid_594474 = validateParameter(valid_594474, JString, required = false,
                                 default = nil)
  if valid_594474 != nil:
    section.add "quotaUser", valid_594474
  var valid_594475 = query.getOrDefault("alt")
  valid_594475 = validateParameter(valid_594475, JString, required = false,
                                 default = newJString("json"))
  if valid_594475 != nil:
    section.add "alt", valid_594475
  var valid_594476 = query.getOrDefault("oauth_token")
  valid_594476 = validateParameter(valid_594476, JString, required = false,
                                 default = nil)
  if valid_594476 != nil:
    section.add "oauth_token", valid_594476
  var valid_594477 = query.getOrDefault("userIp")
  valid_594477 = validateParameter(valid_594477, JString, required = false,
                                 default = nil)
  if valid_594477 != nil:
    section.add "userIp", valid_594477
  var valid_594478 = query.getOrDefault("key")
  valid_594478 = validateParameter(valid_594478, JString, required = false,
                                 default = nil)
  if valid_594478 != nil:
    section.add "key", valid_594478
  var valid_594479 = query.getOrDefault("prettyPrint")
  valid_594479 = validateParameter(valid_594479, JBool, required = false,
                                 default = newJBool(true))
  if valid_594479 != nil:
    section.add "prettyPrint", valid_594479
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594480: Call_TagmanagerAccountsContainersTriggersDelete_594467;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a GTM Trigger.
  ## 
  let valid = call_594480.validator(path, query, header, formData, body)
  let scheme = call_594480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594480.url(scheme.get, call_594480.host, call_594480.base,
                         call_594480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594480, url, valid)

proc call*(call_594481: Call_TagmanagerAccountsContainersTriggersDelete_594467;
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
  var path_594482 = newJObject()
  var query_594483 = newJObject()
  add(path_594482, "containerId", newJString(containerId))
  add(query_594483, "fields", newJString(fields))
  add(query_594483, "quotaUser", newJString(quotaUser))
  add(query_594483, "alt", newJString(alt))
  add(query_594483, "oauth_token", newJString(oauthToken))
  add(path_594482, "accountId", newJString(accountId))
  add(query_594483, "userIp", newJString(userIp))
  add(path_594482, "triggerId", newJString(triggerId))
  add(query_594483, "key", newJString(key))
  add(query_594483, "prettyPrint", newJBool(prettyPrint))
  result = call_594481.call(path_594482, query_594483, nil, nil, nil)

var tagmanagerAccountsContainersTriggersDelete* = Call_TagmanagerAccountsContainersTriggersDelete_594467(
    name: "tagmanagerAccountsContainersTriggersDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/triggers/{triggerId}",
    validator: validate_TagmanagerAccountsContainersTriggersDelete_594468,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTriggersDelete_594469,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVariablesCreate_594500 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersVariablesCreate_594502(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersVariablesCreate_594501(path: JsonNode;
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
  var valid_594503 = path.getOrDefault("containerId")
  valid_594503 = validateParameter(valid_594503, JString, required = true,
                                 default = nil)
  if valid_594503 != nil:
    section.add "containerId", valid_594503
  var valid_594504 = path.getOrDefault("accountId")
  valid_594504 = validateParameter(valid_594504, JString, required = true,
                                 default = nil)
  if valid_594504 != nil:
    section.add "accountId", valid_594504
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
  var valid_594505 = query.getOrDefault("fields")
  valid_594505 = validateParameter(valid_594505, JString, required = false,
                                 default = nil)
  if valid_594505 != nil:
    section.add "fields", valid_594505
  var valid_594506 = query.getOrDefault("quotaUser")
  valid_594506 = validateParameter(valid_594506, JString, required = false,
                                 default = nil)
  if valid_594506 != nil:
    section.add "quotaUser", valid_594506
  var valid_594507 = query.getOrDefault("alt")
  valid_594507 = validateParameter(valid_594507, JString, required = false,
                                 default = newJString("json"))
  if valid_594507 != nil:
    section.add "alt", valid_594507
  var valid_594508 = query.getOrDefault("oauth_token")
  valid_594508 = validateParameter(valid_594508, JString, required = false,
                                 default = nil)
  if valid_594508 != nil:
    section.add "oauth_token", valid_594508
  var valid_594509 = query.getOrDefault("userIp")
  valid_594509 = validateParameter(valid_594509, JString, required = false,
                                 default = nil)
  if valid_594509 != nil:
    section.add "userIp", valid_594509
  var valid_594510 = query.getOrDefault("key")
  valid_594510 = validateParameter(valid_594510, JString, required = false,
                                 default = nil)
  if valid_594510 != nil:
    section.add "key", valid_594510
  var valid_594511 = query.getOrDefault("prettyPrint")
  valid_594511 = validateParameter(valid_594511, JBool, required = false,
                                 default = newJBool(true))
  if valid_594511 != nil:
    section.add "prettyPrint", valid_594511
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

proc call*(call_594513: Call_TagmanagerAccountsContainersVariablesCreate_594500;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a GTM Variable.
  ## 
  let valid = call_594513.validator(path, query, header, formData, body)
  let scheme = call_594513.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594513.url(scheme.get, call_594513.host, call_594513.base,
                         call_594513.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594513, url, valid)

proc call*(call_594514: Call_TagmanagerAccountsContainersVariablesCreate_594500;
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
  var path_594515 = newJObject()
  var query_594516 = newJObject()
  var body_594517 = newJObject()
  add(path_594515, "containerId", newJString(containerId))
  add(query_594516, "fields", newJString(fields))
  add(query_594516, "quotaUser", newJString(quotaUser))
  add(query_594516, "alt", newJString(alt))
  add(query_594516, "oauth_token", newJString(oauthToken))
  add(path_594515, "accountId", newJString(accountId))
  add(query_594516, "userIp", newJString(userIp))
  add(query_594516, "key", newJString(key))
  if body != nil:
    body_594517 = body
  add(query_594516, "prettyPrint", newJBool(prettyPrint))
  result = call_594514.call(path_594515, query_594516, nil, nil, body_594517)

var tagmanagerAccountsContainersVariablesCreate* = Call_TagmanagerAccountsContainersVariablesCreate_594500(
    name: "tagmanagerAccountsContainersVariablesCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/variables",
    validator: validate_TagmanagerAccountsContainersVariablesCreate_594501,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVariablesCreate_594502,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVariablesList_594484 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersVariablesList_594486(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersVariablesList_594485(path: JsonNode;
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
  var valid_594487 = path.getOrDefault("containerId")
  valid_594487 = validateParameter(valid_594487, JString, required = true,
                                 default = nil)
  if valid_594487 != nil:
    section.add "containerId", valid_594487
  var valid_594488 = path.getOrDefault("accountId")
  valid_594488 = validateParameter(valid_594488, JString, required = true,
                                 default = nil)
  if valid_594488 != nil:
    section.add "accountId", valid_594488
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
  var valid_594489 = query.getOrDefault("fields")
  valid_594489 = validateParameter(valid_594489, JString, required = false,
                                 default = nil)
  if valid_594489 != nil:
    section.add "fields", valid_594489
  var valid_594490 = query.getOrDefault("quotaUser")
  valid_594490 = validateParameter(valid_594490, JString, required = false,
                                 default = nil)
  if valid_594490 != nil:
    section.add "quotaUser", valid_594490
  var valid_594491 = query.getOrDefault("alt")
  valid_594491 = validateParameter(valid_594491, JString, required = false,
                                 default = newJString("json"))
  if valid_594491 != nil:
    section.add "alt", valid_594491
  var valid_594492 = query.getOrDefault("oauth_token")
  valid_594492 = validateParameter(valid_594492, JString, required = false,
                                 default = nil)
  if valid_594492 != nil:
    section.add "oauth_token", valid_594492
  var valid_594493 = query.getOrDefault("userIp")
  valid_594493 = validateParameter(valid_594493, JString, required = false,
                                 default = nil)
  if valid_594493 != nil:
    section.add "userIp", valid_594493
  var valid_594494 = query.getOrDefault("key")
  valid_594494 = validateParameter(valid_594494, JString, required = false,
                                 default = nil)
  if valid_594494 != nil:
    section.add "key", valid_594494
  var valid_594495 = query.getOrDefault("prettyPrint")
  valid_594495 = validateParameter(valid_594495, JBool, required = false,
                                 default = newJBool(true))
  if valid_594495 != nil:
    section.add "prettyPrint", valid_594495
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594496: Call_TagmanagerAccountsContainersVariablesList_594484;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all GTM Variables of a Container.
  ## 
  let valid = call_594496.validator(path, query, header, formData, body)
  let scheme = call_594496.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594496.url(scheme.get, call_594496.host, call_594496.base,
                         call_594496.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594496, url, valid)

proc call*(call_594497: Call_TagmanagerAccountsContainersVariablesList_594484;
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
  var path_594498 = newJObject()
  var query_594499 = newJObject()
  add(path_594498, "containerId", newJString(containerId))
  add(query_594499, "fields", newJString(fields))
  add(query_594499, "quotaUser", newJString(quotaUser))
  add(query_594499, "alt", newJString(alt))
  add(query_594499, "oauth_token", newJString(oauthToken))
  add(path_594498, "accountId", newJString(accountId))
  add(query_594499, "userIp", newJString(userIp))
  add(query_594499, "key", newJString(key))
  add(query_594499, "prettyPrint", newJBool(prettyPrint))
  result = call_594497.call(path_594498, query_594499, nil, nil, nil)

var tagmanagerAccountsContainersVariablesList* = Call_TagmanagerAccountsContainersVariablesList_594484(
    name: "tagmanagerAccountsContainersVariablesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/variables",
    validator: validate_TagmanagerAccountsContainersVariablesList_594485,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVariablesList_594486,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVariablesUpdate_594535 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersVariablesUpdate_594537(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersVariablesUpdate_594536(path: JsonNode;
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
  var valid_594538 = path.getOrDefault("containerId")
  valid_594538 = validateParameter(valid_594538, JString, required = true,
                                 default = nil)
  if valid_594538 != nil:
    section.add "containerId", valid_594538
  var valid_594539 = path.getOrDefault("variableId")
  valid_594539 = validateParameter(valid_594539, JString, required = true,
                                 default = nil)
  if valid_594539 != nil:
    section.add "variableId", valid_594539
  var valid_594540 = path.getOrDefault("accountId")
  valid_594540 = validateParameter(valid_594540, JString, required = true,
                                 default = nil)
  if valid_594540 != nil:
    section.add "accountId", valid_594540
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
  var valid_594541 = query.getOrDefault("fields")
  valid_594541 = validateParameter(valid_594541, JString, required = false,
                                 default = nil)
  if valid_594541 != nil:
    section.add "fields", valid_594541
  var valid_594542 = query.getOrDefault("fingerprint")
  valid_594542 = validateParameter(valid_594542, JString, required = false,
                                 default = nil)
  if valid_594542 != nil:
    section.add "fingerprint", valid_594542
  var valid_594543 = query.getOrDefault("quotaUser")
  valid_594543 = validateParameter(valid_594543, JString, required = false,
                                 default = nil)
  if valid_594543 != nil:
    section.add "quotaUser", valid_594543
  var valid_594544 = query.getOrDefault("alt")
  valid_594544 = validateParameter(valid_594544, JString, required = false,
                                 default = newJString("json"))
  if valid_594544 != nil:
    section.add "alt", valid_594544
  var valid_594545 = query.getOrDefault("oauth_token")
  valid_594545 = validateParameter(valid_594545, JString, required = false,
                                 default = nil)
  if valid_594545 != nil:
    section.add "oauth_token", valid_594545
  var valid_594546 = query.getOrDefault("userIp")
  valid_594546 = validateParameter(valid_594546, JString, required = false,
                                 default = nil)
  if valid_594546 != nil:
    section.add "userIp", valid_594546
  var valid_594547 = query.getOrDefault("key")
  valid_594547 = validateParameter(valid_594547, JString, required = false,
                                 default = nil)
  if valid_594547 != nil:
    section.add "key", valid_594547
  var valid_594548 = query.getOrDefault("prettyPrint")
  valid_594548 = validateParameter(valid_594548, JBool, required = false,
                                 default = newJBool(true))
  if valid_594548 != nil:
    section.add "prettyPrint", valid_594548
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

proc call*(call_594550: Call_TagmanagerAccountsContainersVariablesUpdate_594535;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a GTM Variable.
  ## 
  let valid = call_594550.validator(path, query, header, formData, body)
  let scheme = call_594550.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594550.url(scheme.get, call_594550.host, call_594550.base,
                         call_594550.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594550, url, valid)

proc call*(call_594551: Call_TagmanagerAccountsContainersVariablesUpdate_594535;
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
  var path_594552 = newJObject()
  var query_594553 = newJObject()
  var body_594554 = newJObject()
  add(path_594552, "containerId", newJString(containerId))
  add(query_594553, "fields", newJString(fields))
  add(query_594553, "fingerprint", newJString(fingerprint))
  add(query_594553, "quotaUser", newJString(quotaUser))
  add(query_594553, "alt", newJString(alt))
  add(path_594552, "variableId", newJString(variableId))
  add(query_594553, "oauth_token", newJString(oauthToken))
  add(path_594552, "accountId", newJString(accountId))
  add(query_594553, "userIp", newJString(userIp))
  add(query_594553, "key", newJString(key))
  if body != nil:
    body_594554 = body
  add(query_594553, "prettyPrint", newJBool(prettyPrint))
  result = call_594551.call(path_594552, query_594553, nil, nil, body_594554)

var tagmanagerAccountsContainersVariablesUpdate* = Call_TagmanagerAccountsContainersVariablesUpdate_594535(
    name: "tagmanagerAccountsContainersVariablesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/variables/{variableId}",
    validator: validate_TagmanagerAccountsContainersVariablesUpdate_594536,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVariablesUpdate_594537,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVariablesGet_594518 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersVariablesGet_594520(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersVariablesGet_594519(path: JsonNode;
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
  var valid_594521 = path.getOrDefault("containerId")
  valid_594521 = validateParameter(valid_594521, JString, required = true,
                                 default = nil)
  if valid_594521 != nil:
    section.add "containerId", valid_594521
  var valid_594522 = path.getOrDefault("variableId")
  valid_594522 = validateParameter(valid_594522, JString, required = true,
                                 default = nil)
  if valid_594522 != nil:
    section.add "variableId", valid_594522
  var valid_594523 = path.getOrDefault("accountId")
  valid_594523 = validateParameter(valid_594523, JString, required = true,
                                 default = nil)
  if valid_594523 != nil:
    section.add "accountId", valid_594523
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
  var valid_594524 = query.getOrDefault("fields")
  valid_594524 = validateParameter(valid_594524, JString, required = false,
                                 default = nil)
  if valid_594524 != nil:
    section.add "fields", valid_594524
  var valid_594525 = query.getOrDefault("quotaUser")
  valid_594525 = validateParameter(valid_594525, JString, required = false,
                                 default = nil)
  if valid_594525 != nil:
    section.add "quotaUser", valid_594525
  var valid_594526 = query.getOrDefault("alt")
  valid_594526 = validateParameter(valid_594526, JString, required = false,
                                 default = newJString("json"))
  if valid_594526 != nil:
    section.add "alt", valid_594526
  var valid_594527 = query.getOrDefault("oauth_token")
  valid_594527 = validateParameter(valid_594527, JString, required = false,
                                 default = nil)
  if valid_594527 != nil:
    section.add "oauth_token", valid_594527
  var valid_594528 = query.getOrDefault("userIp")
  valid_594528 = validateParameter(valid_594528, JString, required = false,
                                 default = nil)
  if valid_594528 != nil:
    section.add "userIp", valid_594528
  var valid_594529 = query.getOrDefault("key")
  valid_594529 = validateParameter(valid_594529, JString, required = false,
                                 default = nil)
  if valid_594529 != nil:
    section.add "key", valid_594529
  var valid_594530 = query.getOrDefault("prettyPrint")
  valid_594530 = validateParameter(valid_594530, JBool, required = false,
                                 default = newJBool(true))
  if valid_594530 != nil:
    section.add "prettyPrint", valid_594530
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594531: Call_TagmanagerAccountsContainersVariablesGet_594518;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a GTM Variable.
  ## 
  let valid = call_594531.validator(path, query, header, formData, body)
  let scheme = call_594531.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594531.url(scheme.get, call_594531.host, call_594531.base,
                         call_594531.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594531, url, valid)

proc call*(call_594532: Call_TagmanagerAccountsContainersVariablesGet_594518;
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
  var path_594533 = newJObject()
  var query_594534 = newJObject()
  add(path_594533, "containerId", newJString(containerId))
  add(query_594534, "fields", newJString(fields))
  add(query_594534, "quotaUser", newJString(quotaUser))
  add(query_594534, "alt", newJString(alt))
  add(path_594533, "variableId", newJString(variableId))
  add(query_594534, "oauth_token", newJString(oauthToken))
  add(path_594533, "accountId", newJString(accountId))
  add(query_594534, "userIp", newJString(userIp))
  add(query_594534, "key", newJString(key))
  add(query_594534, "prettyPrint", newJBool(prettyPrint))
  result = call_594532.call(path_594533, query_594534, nil, nil, nil)

var tagmanagerAccountsContainersVariablesGet* = Call_TagmanagerAccountsContainersVariablesGet_594518(
    name: "tagmanagerAccountsContainersVariablesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/variables/{variableId}",
    validator: validate_TagmanagerAccountsContainersVariablesGet_594519,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVariablesGet_594520,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVariablesDelete_594555 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersVariablesDelete_594557(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersVariablesDelete_594556(path: JsonNode;
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
  var valid_594558 = path.getOrDefault("containerId")
  valid_594558 = validateParameter(valid_594558, JString, required = true,
                                 default = nil)
  if valid_594558 != nil:
    section.add "containerId", valid_594558
  var valid_594559 = path.getOrDefault("variableId")
  valid_594559 = validateParameter(valid_594559, JString, required = true,
                                 default = nil)
  if valid_594559 != nil:
    section.add "variableId", valid_594559
  var valid_594560 = path.getOrDefault("accountId")
  valid_594560 = validateParameter(valid_594560, JString, required = true,
                                 default = nil)
  if valid_594560 != nil:
    section.add "accountId", valid_594560
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
  var valid_594561 = query.getOrDefault("fields")
  valid_594561 = validateParameter(valid_594561, JString, required = false,
                                 default = nil)
  if valid_594561 != nil:
    section.add "fields", valid_594561
  var valid_594562 = query.getOrDefault("quotaUser")
  valid_594562 = validateParameter(valid_594562, JString, required = false,
                                 default = nil)
  if valid_594562 != nil:
    section.add "quotaUser", valid_594562
  var valid_594563 = query.getOrDefault("alt")
  valid_594563 = validateParameter(valid_594563, JString, required = false,
                                 default = newJString("json"))
  if valid_594563 != nil:
    section.add "alt", valid_594563
  var valid_594564 = query.getOrDefault("oauth_token")
  valid_594564 = validateParameter(valid_594564, JString, required = false,
                                 default = nil)
  if valid_594564 != nil:
    section.add "oauth_token", valid_594564
  var valid_594565 = query.getOrDefault("userIp")
  valid_594565 = validateParameter(valid_594565, JString, required = false,
                                 default = nil)
  if valid_594565 != nil:
    section.add "userIp", valid_594565
  var valid_594566 = query.getOrDefault("key")
  valid_594566 = validateParameter(valid_594566, JString, required = false,
                                 default = nil)
  if valid_594566 != nil:
    section.add "key", valid_594566
  var valid_594567 = query.getOrDefault("prettyPrint")
  valid_594567 = validateParameter(valid_594567, JBool, required = false,
                                 default = newJBool(true))
  if valid_594567 != nil:
    section.add "prettyPrint", valid_594567
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594568: Call_TagmanagerAccountsContainersVariablesDelete_594555;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a GTM Variable.
  ## 
  let valid = call_594568.validator(path, query, header, formData, body)
  let scheme = call_594568.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594568.url(scheme.get, call_594568.host, call_594568.base,
                         call_594568.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594568, url, valid)

proc call*(call_594569: Call_TagmanagerAccountsContainersVariablesDelete_594555;
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
  var path_594570 = newJObject()
  var query_594571 = newJObject()
  add(path_594570, "containerId", newJString(containerId))
  add(query_594571, "fields", newJString(fields))
  add(query_594571, "quotaUser", newJString(quotaUser))
  add(query_594571, "alt", newJString(alt))
  add(path_594570, "variableId", newJString(variableId))
  add(query_594571, "oauth_token", newJString(oauthToken))
  add(path_594570, "accountId", newJString(accountId))
  add(query_594571, "userIp", newJString(userIp))
  add(query_594571, "key", newJString(key))
  add(query_594571, "prettyPrint", newJBool(prettyPrint))
  result = call_594569.call(path_594570, query_594571, nil, nil, nil)

var tagmanagerAccountsContainersVariablesDelete* = Call_TagmanagerAccountsContainersVariablesDelete_594555(
    name: "tagmanagerAccountsContainersVariablesDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/variables/{variableId}",
    validator: validate_TagmanagerAccountsContainersVariablesDelete_594556,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVariablesDelete_594557,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsCreate_594590 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersVersionsCreate_594592(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersVersionsCreate_594591(path: JsonNode;
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
  var valid_594593 = path.getOrDefault("containerId")
  valid_594593 = validateParameter(valid_594593, JString, required = true,
                                 default = nil)
  if valid_594593 != nil:
    section.add "containerId", valid_594593
  var valid_594594 = path.getOrDefault("accountId")
  valid_594594 = validateParameter(valid_594594, JString, required = true,
                                 default = nil)
  if valid_594594 != nil:
    section.add "accountId", valid_594594
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
  var valid_594595 = query.getOrDefault("fields")
  valid_594595 = validateParameter(valid_594595, JString, required = false,
                                 default = nil)
  if valid_594595 != nil:
    section.add "fields", valid_594595
  var valid_594596 = query.getOrDefault("quotaUser")
  valid_594596 = validateParameter(valid_594596, JString, required = false,
                                 default = nil)
  if valid_594596 != nil:
    section.add "quotaUser", valid_594596
  var valid_594597 = query.getOrDefault("alt")
  valid_594597 = validateParameter(valid_594597, JString, required = false,
                                 default = newJString("json"))
  if valid_594597 != nil:
    section.add "alt", valid_594597
  var valid_594598 = query.getOrDefault("oauth_token")
  valid_594598 = validateParameter(valid_594598, JString, required = false,
                                 default = nil)
  if valid_594598 != nil:
    section.add "oauth_token", valid_594598
  var valid_594599 = query.getOrDefault("userIp")
  valid_594599 = validateParameter(valid_594599, JString, required = false,
                                 default = nil)
  if valid_594599 != nil:
    section.add "userIp", valid_594599
  var valid_594600 = query.getOrDefault("key")
  valid_594600 = validateParameter(valid_594600, JString, required = false,
                                 default = nil)
  if valid_594600 != nil:
    section.add "key", valid_594600
  var valid_594601 = query.getOrDefault("prettyPrint")
  valid_594601 = validateParameter(valid_594601, JBool, required = false,
                                 default = newJBool(true))
  if valid_594601 != nil:
    section.add "prettyPrint", valid_594601
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

proc call*(call_594603: Call_TagmanagerAccountsContainersVersionsCreate_594590;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Container Version.
  ## 
  let valid = call_594603.validator(path, query, header, formData, body)
  let scheme = call_594603.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594603.url(scheme.get, call_594603.host, call_594603.base,
                         call_594603.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594603, url, valid)

proc call*(call_594604: Call_TagmanagerAccountsContainersVersionsCreate_594590;
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
  var path_594605 = newJObject()
  var query_594606 = newJObject()
  var body_594607 = newJObject()
  add(path_594605, "containerId", newJString(containerId))
  add(query_594606, "fields", newJString(fields))
  add(query_594606, "quotaUser", newJString(quotaUser))
  add(query_594606, "alt", newJString(alt))
  add(query_594606, "oauth_token", newJString(oauthToken))
  add(path_594605, "accountId", newJString(accountId))
  add(query_594606, "userIp", newJString(userIp))
  add(query_594606, "key", newJString(key))
  if body != nil:
    body_594607 = body
  add(query_594606, "prettyPrint", newJBool(prettyPrint))
  result = call_594604.call(path_594605, query_594606, nil, nil, body_594607)

var tagmanagerAccountsContainersVersionsCreate* = Call_TagmanagerAccountsContainersVersionsCreate_594590(
    name: "tagmanagerAccountsContainersVersionsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/versions",
    validator: validate_TagmanagerAccountsContainersVersionsCreate_594591,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsCreate_594592,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsList_594572 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersVersionsList_594574(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersVersionsList_594573(path: JsonNode;
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
  var valid_594575 = path.getOrDefault("containerId")
  valid_594575 = validateParameter(valid_594575, JString, required = true,
                                 default = nil)
  if valid_594575 != nil:
    section.add "containerId", valid_594575
  var valid_594576 = path.getOrDefault("accountId")
  valid_594576 = validateParameter(valid_594576, JString, required = true,
                                 default = nil)
  if valid_594576 != nil:
    section.add "accountId", valid_594576
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
  var valid_594577 = query.getOrDefault("headers")
  valid_594577 = validateParameter(valid_594577, JBool, required = false,
                                 default = newJBool(false))
  if valid_594577 != nil:
    section.add "headers", valid_594577
  var valid_594578 = query.getOrDefault("fields")
  valid_594578 = validateParameter(valid_594578, JString, required = false,
                                 default = nil)
  if valid_594578 != nil:
    section.add "fields", valid_594578
  var valid_594579 = query.getOrDefault("quotaUser")
  valid_594579 = validateParameter(valid_594579, JString, required = false,
                                 default = nil)
  if valid_594579 != nil:
    section.add "quotaUser", valid_594579
  var valid_594580 = query.getOrDefault("alt")
  valid_594580 = validateParameter(valid_594580, JString, required = false,
                                 default = newJString("json"))
  if valid_594580 != nil:
    section.add "alt", valid_594580
  var valid_594581 = query.getOrDefault("oauth_token")
  valid_594581 = validateParameter(valid_594581, JString, required = false,
                                 default = nil)
  if valid_594581 != nil:
    section.add "oauth_token", valid_594581
  var valid_594582 = query.getOrDefault("userIp")
  valid_594582 = validateParameter(valid_594582, JString, required = false,
                                 default = nil)
  if valid_594582 != nil:
    section.add "userIp", valid_594582
  var valid_594583 = query.getOrDefault("key")
  valid_594583 = validateParameter(valid_594583, JString, required = false,
                                 default = nil)
  if valid_594583 != nil:
    section.add "key", valid_594583
  var valid_594584 = query.getOrDefault("includeDeleted")
  valid_594584 = validateParameter(valid_594584, JBool, required = false,
                                 default = newJBool(false))
  if valid_594584 != nil:
    section.add "includeDeleted", valid_594584
  var valid_594585 = query.getOrDefault("prettyPrint")
  valid_594585 = validateParameter(valid_594585, JBool, required = false,
                                 default = newJBool(true))
  if valid_594585 != nil:
    section.add "prettyPrint", valid_594585
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594586: Call_TagmanagerAccountsContainersVersionsList_594572;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all Container Versions of a GTM Container.
  ## 
  let valid = call_594586.validator(path, query, header, formData, body)
  let scheme = call_594586.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594586.url(scheme.get, call_594586.host, call_594586.base,
                         call_594586.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594586, url, valid)

proc call*(call_594587: Call_TagmanagerAccountsContainersVersionsList_594572;
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
  var path_594588 = newJObject()
  var query_594589 = newJObject()
  add(query_594589, "headers", newJBool(headers))
  add(path_594588, "containerId", newJString(containerId))
  add(query_594589, "fields", newJString(fields))
  add(query_594589, "quotaUser", newJString(quotaUser))
  add(query_594589, "alt", newJString(alt))
  add(query_594589, "oauth_token", newJString(oauthToken))
  add(path_594588, "accountId", newJString(accountId))
  add(query_594589, "userIp", newJString(userIp))
  add(query_594589, "key", newJString(key))
  add(query_594589, "includeDeleted", newJBool(includeDeleted))
  add(query_594589, "prettyPrint", newJBool(prettyPrint))
  result = call_594587.call(path_594588, query_594589, nil, nil, nil)

var tagmanagerAccountsContainersVersionsList* = Call_TagmanagerAccountsContainersVersionsList_594572(
    name: "tagmanagerAccountsContainersVersionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/versions",
    validator: validate_TagmanagerAccountsContainersVersionsList_594573,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsList_594574,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsUpdate_594625 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersVersionsUpdate_594627(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersVersionsUpdate_594626(path: JsonNode;
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
  var valid_594628 = path.getOrDefault("containerId")
  valid_594628 = validateParameter(valid_594628, JString, required = true,
                                 default = nil)
  if valid_594628 != nil:
    section.add "containerId", valid_594628
  var valid_594629 = path.getOrDefault("accountId")
  valid_594629 = validateParameter(valid_594629, JString, required = true,
                                 default = nil)
  if valid_594629 != nil:
    section.add "accountId", valid_594629
  var valid_594630 = path.getOrDefault("containerVersionId")
  valid_594630 = validateParameter(valid_594630, JString, required = true,
                                 default = nil)
  if valid_594630 != nil:
    section.add "containerVersionId", valid_594630
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
  var valid_594631 = query.getOrDefault("fields")
  valid_594631 = validateParameter(valid_594631, JString, required = false,
                                 default = nil)
  if valid_594631 != nil:
    section.add "fields", valid_594631
  var valid_594632 = query.getOrDefault("fingerprint")
  valid_594632 = validateParameter(valid_594632, JString, required = false,
                                 default = nil)
  if valid_594632 != nil:
    section.add "fingerprint", valid_594632
  var valid_594633 = query.getOrDefault("quotaUser")
  valid_594633 = validateParameter(valid_594633, JString, required = false,
                                 default = nil)
  if valid_594633 != nil:
    section.add "quotaUser", valid_594633
  var valid_594634 = query.getOrDefault("alt")
  valid_594634 = validateParameter(valid_594634, JString, required = false,
                                 default = newJString("json"))
  if valid_594634 != nil:
    section.add "alt", valid_594634
  var valid_594635 = query.getOrDefault("oauth_token")
  valid_594635 = validateParameter(valid_594635, JString, required = false,
                                 default = nil)
  if valid_594635 != nil:
    section.add "oauth_token", valid_594635
  var valid_594636 = query.getOrDefault("userIp")
  valid_594636 = validateParameter(valid_594636, JString, required = false,
                                 default = nil)
  if valid_594636 != nil:
    section.add "userIp", valid_594636
  var valid_594637 = query.getOrDefault("key")
  valid_594637 = validateParameter(valid_594637, JString, required = false,
                                 default = nil)
  if valid_594637 != nil:
    section.add "key", valid_594637
  var valid_594638 = query.getOrDefault("prettyPrint")
  valid_594638 = validateParameter(valid_594638, JBool, required = false,
                                 default = newJBool(true))
  if valid_594638 != nil:
    section.add "prettyPrint", valid_594638
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

proc call*(call_594640: Call_TagmanagerAccountsContainersVersionsUpdate_594625;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a Container Version.
  ## 
  let valid = call_594640.validator(path, query, header, formData, body)
  let scheme = call_594640.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594640.url(scheme.get, call_594640.host, call_594640.base,
                         call_594640.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594640, url, valid)

proc call*(call_594641: Call_TagmanagerAccountsContainersVersionsUpdate_594625;
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
  var path_594642 = newJObject()
  var query_594643 = newJObject()
  var body_594644 = newJObject()
  add(path_594642, "containerId", newJString(containerId))
  add(query_594643, "fields", newJString(fields))
  add(query_594643, "fingerprint", newJString(fingerprint))
  add(query_594643, "quotaUser", newJString(quotaUser))
  add(query_594643, "alt", newJString(alt))
  add(query_594643, "oauth_token", newJString(oauthToken))
  add(path_594642, "accountId", newJString(accountId))
  add(query_594643, "userIp", newJString(userIp))
  add(path_594642, "containerVersionId", newJString(containerVersionId))
  add(query_594643, "key", newJString(key))
  if body != nil:
    body_594644 = body
  add(query_594643, "prettyPrint", newJBool(prettyPrint))
  result = call_594641.call(path_594642, query_594643, nil, nil, body_594644)

var tagmanagerAccountsContainersVersionsUpdate* = Call_TagmanagerAccountsContainersVersionsUpdate_594625(
    name: "tagmanagerAccountsContainersVersionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/versions/{containerVersionId}",
    validator: validate_TagmanagerAccountsContainersVersionsUpdate_594626,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsUpdate_594627,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsGet_594608 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersVersionsGet_594610(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersVersionsGet_594609(path: JsonNode;
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
  var valid_594611 = path.getOrDefault("containerId")
  valid_594611 = validateParameter(valid_594611, JString, required = true,
                                 default = nil)
  if valid_594611 != nil:
    section.add "containerId", valid_594611
  var valid_594612 = path.getOrDefault("accountId")
  valid_594612 = validateParameter(valid_594612, JString, required = true,
                                 default = nil)
  if valid_594612 != nil:
    section.add "accountId", valid_594612
  var valid_594613 = path.getOrDefault("containerVersionId")
  valid_594613 = validateParameter(valid_594613, JString, required = true,
                                 default = nil)
  if valid_594613 != nil:
    section.add "containerVersionId", valid_594613
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
  var valid_594614 = query.getOrDefault("fields")
  valid_594614 = validateParameter(valid_594614, JString, required = false,
                                 default = nil)
  if valid_594614 != nil:
    section.add "fields", valid_594614
  var valid_594615 = query.getOrDefault("quotaUser")
  valid_594615 = validateParameter(valid_594615, JString, required = false,
                                 default = nil)
  if valid_594615 != nil:
    section.add "quotaUser", valid_594615
  var valid_594616 = query.getOrDefault("alt")
  valid_594616 = validateParameter(valid_594616, JString, required = false,
                                 default = newJString("json"))
  if valid_594616 != nil:
    section.add "alt", valid_594616
  var valid_594617 = query.getOrDefault("oauth_token")
  valid_594617 = validateParameter(valid_594617, JString, required = false,
                                 default = nil)
  if valid_594617 != nil:
    section.add "oauth_token", valid_594617
  var valid_594618 = query.getOrDefault("userIp")
  valid_594618 = validateParameter(valid_594618, JString, required = false,
                                 default = nil)
  if valid_594618 != nil:
    section.add "userIp", valid_594618
  var valid_594619 = query.getOrDefault("key")
  valid_594619 = validateParameter(valid_594619, JString, required = false,
                                 default = nil)
  if valid_594619 != nil:
    section.add "key", valid_594619
  var valid_594620 = query.getOrDefault("prettyPrint")
  valid_594620 = validateParameter(valid_594620, JBool, required = false,
                                 default = newJBool(true))
  if valid_594620 != nil:
    section.add "prettyPrint", valid_594620
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594621: Call_TagmanagerAccountsContainersVersionsGet_594608;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a Container Version.
  ## 
  let valid = call_594621.validator(path, query, header, formData, body)
  let scheme = call_594621.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594621.url(scheme.get, call_594621.host, call_594621.base,
                         call_594621.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594621, url, valid)

proc call*(call_594622: Call_TagmanagerAccountsContainersVersionsGet_594608;
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
  var path_594623 = newJObject()
  var query_594624 = newJObject()
  add(path_594623, "containerId", newJString(containerId))
  add(query_594624, "fields", newJString(fields))
  add(query_594624, "quotaUser", newJString(quotaUser))
  add(query_594624, "alt", newJString(alt))
  add(query_594624, "oauth_token", newJString(oauthToken))
  add(path_594623, "accountId", newJString(accountId))
  add(query_594624, "userIp", newJString(userIp))
  add(path_594623, "containerVersionId", newJString(containerVersionId))
  add(query_594624, "key", newJString(key))
  add(query_594624, "prettyPrint", newJBool(prettyPrint))
  result = call_594622.call(path_594623, query_594624, nil, nil, nil)

var tagmanagerAccountsContainersVersionsGet* = Call_TagmanagerAccountsContainersVersionsGet_594608(
    name: "tagmanagerAccountsContainersVersionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/versions/{containerVersionId}",
    validator: validate_TagmanagerAccountsContainersVersionsGet_594609,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsGet_594610,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsDelete_594645 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersVersionsDelete_594647(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersVersionsDelete_594646(path: JsonNode;
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
  var valid_594648 = path.getOrDefault("containerId")
  valid_594648 = validateParameter(valid_594648, JString, required = true,
                                 default = nil)
  if valid_594648 != nil:
    section.add "containerId", valid_594648
  var valid_594649 = path.getOrDefault("accountId")
  valid_594649 = validateParameter(valid_594649, JString, required = true,
                                 default = nil)
  if valid_594649 != nil:
    section.add "accountId", valid_594649
  var valid_594650 = path.getOrDefault("containerVersionId")
  valid_594650 = validateParameter(valid_594650, JString, required = true,
                                 default = nil)
  if valid_594650 != nil:
    section.add "containerVersionId", valid_594650
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
  var valid_594651 = query.getOrDefault("fields")
  valid_594651 = validateParameter(valid_594651, JString, required = false,
                                 default = nil)
  if valid_594651 != nil:
    section.add "fields", valid_594651
  var valid_594652 = query.getOrDefault("quotaUser")
  valid_594652 = validateParameter(valid_594652, JString, required = false,
                                 default = nil)
  if valid_594652 != nil:
    section.add "quotaUser", valid_594652
  var valid_594653 = query.getOrDefault("alt")
  valid_594653 = validateParameter(valid_594653, JString, required = false,
                                 default = newJString("json"))
  if valid_594653 != nil:
    section.add "alt", valid_594653
  var valid_594654 = query.getOrDefault("oauth_token")
  valid_594654 = validateParameter(valid_594654, JString, required = false,
                                 default = nil)
  if valid_594654 != nil:
    section.add "oauth_token", valid_594654
  var valid_594655 = query.getOrDefault("userIp")
  valid_594655 = validateParameter(valid_594655, JString, required = false,
                                 default = nil)
  if valid_594655 != nil:
    section.add "userIp", valid_594655
  var valid_594656 = query.getOrDefault("key")
  valid_594656 = validateParameter(valid_594656, JString, required = false,
                                 default = nil)
  if valid_594656 != nil:
    section.add "key", valid_594656
  var valid_594657 = query.getOrDefault("prettyPrint")
  valid_594657 = validateParameter(valid_594657, JBool, required = false,
                                 default = newJBool(true))
  if valid_594657 != nil:
    section.add "prettyPrint", valid_594657
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594658: Call_TagmanagerAccountsContainersVersionsDelete_594645;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a Container Version.
  ## 
  let valid = call_594658.validator(path, query, header, formData, body)
  let scheme = call_594658.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594658.url(scheme.get, call_594658.host, call_594658.base,
                         call_594658.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594658, url, valid)

proc call*(call_594659: Call_TagmanagerAccountsContainersVersionsDelete_594645;
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
  var path_594660 = newJObject()
  var query_594661 = newJObject()
  add(path_594660, "containerId", newJString(containerId))
  add(query_594661, "fields", newJString(fields))
  add(query_594661, "quotaUser", newJString(quotaUser))
  add(query_594661, "alt", newJString(alt))
  add(query_594661, "oauth_token", newJString(oauthToken))
  add(path_594660, "accountId", newJString(accountId))
  add(query_594661, "userIp", newJString(userIp))
  add(path_594660, "containerVersionId", newJString(containerVersionId))
  add(query_594661, "key", newJString(key))
  add(query_594661, "prettyPrint", newJBool(prettyPrint))
  result = call_594659.call(path_594660, query_594661, nil, nil, nil)

var tagmanagerAccountsContainersVersionsDelete* = Call_TagmanagerAccountsContainersVersionsDelete_594645(
    name: "tagmanagerAccountsContainersVersionsDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/versions/{containerVersionId}",
    validator: validate_TagmanagerAccountsContainersVersionsDelete_594646,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsDelete_594647,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsPublish_594662 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersVersionsPublish_594664(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersVersionsPublish_594663(path: JsonNode;
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
  var valid_594665 = path.getOrDefault("containerId")
  valid_594665 = validateParameter(valid_594665, JString, required = true,
                                 default = nil)
  if valid_594665 != nil:
    section.add "containerId", valid_594665
  var valid_594666 = path.getOrDefault("accountId")
  valid_594666 = validateParameter(valid_594666, JString, required = true,
                                 default = nil)
  if valid_594666 != nil:
    section.add "accountId", valid_594666
  var valid_594667 = path.getOrDefault("containerVersionId")
  valid_594667 = validateParameter(valid_594667, JString, required = true,
                                 default = nil)
  if valid_594667 != nil:
    section.add "containerVersionId", valid_594667
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
  var valid_594668 = query.getOrDefault("fields")
  valid_594668 = validateParameter(valid_594668, JString, required = false,
                                 default = nil)
  if valid_594668 != nil:
    section.add "fields", valid_594668
  var valid_594669 = query.getOrDefault("fingerprint")
  valid_594669 = validateParameter(valid_594669, JString, required = false,
                                 default = nil)
  if valid_594669 != nil:
    section.add "fingerprint", valid_594669
  var valid_594670 = query.getOrDefault("quotaUser")
  valid_594670 = validateParameter(valid_594670, JString, required = false,
                                 default = nil)
  if valid_594670 != nil:
    section.add "quotaUser", valid_594670
  var valid_594671 = query.getOrDefault("alt")
  valid_594671 = validateParameter(valid_594671, JString, required = false,
                                 default = newJString("json"))
  if valid_594671 != nil:
    section.add "alt", valid_594671
  var valid_594672 = query.getOrDefault("oauth_token")
  valid_594672 = validateParameter(valid_594672, JString, required = false,
                                 default = nil)
  if valid_594672 != nil:
    section.add "oauth_token", valid_594672
  var valid_594673 = query.getOrDefault("userIp")
  valid_594673 = validateParameter(valid_594673, JString, required = false,
                                 default = nil)
  if valid_594673 != nil:
    section.add "userIp", valid_594673
  var valid_594674 = query.getOrDefault("key")
  valid_594674 = validateParameter(valid_594674, JString, required = false,
                                 default = nil)
  if valid_594674 != nil:
    section.add "key", valid_594674
  var valid_594675 = query.getOrDefault("prettyPrint")
  valid_594675 = validateParameter(valid_594675, JBool, required = false,
                                 default = newJBool(true))
  if valid_594675 != nil:
    section.add "prettyPrint", valid_594675
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594676: Call_TagmanagerAccountsContainersVersionsPublish_594662;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Publishes a Container Version.
  ## 
  let valid = call_594676.validator(path, query, header, formData, body)
  let scheme = call_594676.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594676.url(scheme.get, call_594676.host, call_594676.base,
                         call_594676.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594676, url, valid)

proc call*(call_594677: Call_TagmanagerAccountsContainersVersionsPublish_594662;
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
  var path_594678 = newJObject()
  var query_594679 = newJObject()
  add(path_594678, "containerId", newJString(containerId))
  add(query_594679, "fields", newJString(fields))
  add(query_594679, "fingerprint", newJString(fingerprint))
  add(query_594679, "quotaUser", newJString(quotaUser))
  add(query_594679, "alt", newJString(alt))
  add(query_594679, "oauth_token", newJString(oauthToken))
  add(path_594678, "accountId", newJString(accountId))
  add(query_594679, "userIp", newJString(userIp))
  add(path_594678, "containerVersionId", newJString(containerVersionId))
  add(query_594679, "key", newJString(key))
  add(query_594679, "prettyPrint", newJBool(prettyPrint))
  result = call_594677.call(path_594678, query_594679, nil, nil, nil)

var tagmanagerAccountsContainersVersionsPublish* = Call_TagmanagerAccountsContainersVersionsPublish_594662(
    name: "tagmanagerAccountsContainersVersionsPublish",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/versions/{containerVersionId}/publish",
    validator: validate_TagmanagerAccountsContainersVersionsPublish_594663,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsPublish_594664,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsRestore_594680 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersVersionsRestore_594682(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersVersionsRestore_594681(path: JsonNode;
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
  var valid_594683 = path.getOrDefault("containerId")
  valid_594683 = validateParameter(valid_594683, JString, required = true,
                                 default = nil)
  if valid_594683 != nil:
    section.add "containerId", valid_594683
  var valid_594684 = path.getOrDefault("accountId")
  valid_594684 = validateParameter(valid_594684, JString, required = true,
                                 default = nil)
  if valid_594684 != nil:
    section.add "accountId", valid_594684
  var valid_594685 = path.getOrDefault("containerVersionId")
  valid_594685 = validateParameter(valid_594685, JString, required = true,
                                 default = nil)
  if valid_594685 != nil:
    section.add "containerVersionId", valid_594685
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
  var valid_594686 = query.getOrDefault("fields")
  valid_594686 = validateParameter(valid_594686, JString, required = false,
                                 default = nil)
  if valid_594686 != nil:
    section.add "fields", valid_594686
  var valid_594687 = query.getOrDefault("quotaUser")
  valid_594687 = validateParameter(valid_594687, JString, required = false,
                                 default = nil)
  if valid_594687 != nil:
    section.add "quotaUser", valid_594687
  var valid_594688 = query.getOrDefault("alt")
  valid_594688 = validateParameter(valid_594688, JString, required = false,
                                 default = newJString("json"))
  if valid_594688 != nil:
    section.add "alt", valid_594688
  var valid_594689 = query.getOrDefault("oauth_token")
  valid_594689 = validateParameter(valid_594689, JString, required = false,
                                 default = nil)
  if valid_594689 != nil:
    section.add "oauth_token", valid_594689
  var valid_594690 = query.getOrDefault("userIp")
  valid_594690 = validateParameter(valid_594690, JString, required = false,
                                 default = nil)
  if valid_594690 != nil:
    section.add "userIp", valid_594690
  var valid_594691 = query.getOrDefault("key")
  valid_594691 = validateParameter(valid_594691, JString, required = false,
                                 default = nil)
  if valid_594691 != nil:
    section.add "key", valid_594691
  var valid_594692 = query.getOrDefault("prettyPrint")
  valid_594692 = validateParameter(valid_594692, JBool, required = false,
                                 default = newJBool(true))
  if valid_594692 != nil:
    section.add "prettyPrint", valid_594692
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594693: Call_TagmanagerAccountsContainersVersionsRestore_594680;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Restores a Container Version. This will overwrite the container's current configuration (including its variables, triggers and tags). The operation will not have any effect on the version that is being served (i.e. the published version).
  ## 
  let valid = call_594693.validator(path, query, header, formData, body)
  let scheme = call_594693.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594693.url(scheme.get, call_594693.host, call_594693.base,
                         call_594693.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594693, url, valid)

proc call*(call_594694: Call_TagmanagerAccountsContainersVersionsRestore_594680;
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
  var path_594695 = newJObject()
  var query_594696 = newJObject()
  add(path_594695, "containerId", newJString(containerId))
  add(query_594696, "fields", newJString(fields))
  add(query_594696, "quotaUser", newJString(quotaUser))
  add(query_594696, "alt", newJString(alt))
  add(query_594696, "oauth_token", newJString(oauthToken))
  add(path_594695, "accountId", newJString(accountId))
  add(query_594696, "userIp", newJString(userIp))
  add(path_594695, "containerVersionId", newJString(containerVersionId))
  add(query_594696, "key", newJString(key))
  add(query_594696, "prettyPrint", newJBool(prettyPrint))
  result = call_594694.call(path_594695, query_594696, nil, nil, nil)

var tagmanagerAccountsContainersVersionsRestore* = Call_TagmanagerAccountsContainersVersionsRestore_594680(
    name: "tagmanagerAccountsContainersVersionsRestore",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/versions/{containerVersionId}/restore",
    validator: validate_TagmanagerAccountsContainersVersionsRestore_594681,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsRestore_594682,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsUndelete_594697 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsContainersVersionsUndelete_594699(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsContainersVersionsUndelete_594698(path: JsonNode;
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
  var valid_594700 = path.getOrDefault("containerId")
  valid_594700 = validateParameter(valid_594700, JString, required = true,
                                 default = nil)
  if valid_594700 != nil:
    section.add "containerId", valid_594700
  var valid_594701 = path.getOrDefault("accountId")
  valid_594701 = validateParameter(valid_594701, JString, required = true,
                                 default = nil)
  if valid_594701 != nil:
    section.add "accountId", valid_594701
  var valid_594702 = path.getOrDefault("containerVersionId")
  valid_594702 = validateParameter(valid_594702, JString, required = true,
                                 default = nil)
  if valid_594702 != nil:
    section.add "containerVersionId", valid_594702
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
  var valid_594703 = query.getOrDefault("fields")
  valid_594703 = validateParameter(valid_594703, JString, required = false,
                                 default = nil)
  if valid_594703 != nil:
    section.add "fields", valid_594703
  var valid_594704 = query.getOrDefault("quotaUser")
  valid_594704 = validateParameter(valid_594704, JString, required = false,
                                 default = nil)
  if valid_594704 != nil:
    section.add "quotaUser", valid_594704
  var valid_594705 = query.getOrDefault("alt")
  valid_594705 = validateParameter(valid_594705, JString, required = false,
                                 default = newJString("json"))
  if valid_594705 != nil:
    section.add "alt", valid_594705
  var valid_594706 = query.getOrDefault("oauth_token")
  valid_594706 = validateParameter(valid_594706, JString, required = false,
                                 default = nil)
  if valid_594706 != nil:
    section.add "oauth_token", valid_594706
  var valid_594707 = query.getOrDefault("userIp")
  valid_594707 = validateParameter(valid_594707, JString, required = false,
                                 default = nil)
  if valid_594707 != nil:
    section.add "userIp", valid_594707
  var valid_594708 = query.getOrDefault("key")
  valid_594708 = validateParameter(valid_594708, JString, required = false,
                                 default = nil)
  if valid_594708 != nil:
    section.add "key", valid_594708
  var valid_594709 = query.getOrDefault("prettyPrint")
  valid_594709 = validateParameter(valid_594709, JBool, required = false,
                                 default = newJBool(true))
  if valid_594709 != nil:
    section.add "prettyPrint", valid_594709
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594710: Call_TagmanagerAccountsContainersVersionsUndelete_594697;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Undeletes a Container Version.
  ## 
  let valid = call_594710.validator(path, query, header, formData, body)
  let scheme = call_594710.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594710.url(scheme.get, call_594710.host, call_594710.base,
                         call_594710.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594710, url, valid)

proc call*(call_594711: Call_TagmanagerAccountsContainersVersionsUndelete_594697;
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
  var path_594712 = newJObject()
  var query_594713 = newJObject()
  add(path_594712, "containerId", newJString(containerId))
  add(query_594713, "fields", newJString(fields))
  add(query_594713, "quotaUser", newJString(quotaUser))
  add(query_594713, "alt", newJString(alt))
  add(query_594713, "oauth_token", newJString(oauthToken))
  add(path_594712, "accountId", newJString(accountId))
  add(query_594713, "userIp", newJString(userIp))
  add(path_594712, "containerVersionId", newJString(containerVersionId))
  add(query_594713, "key", newJString(key))
  add(query_594713, "prettyPrint", newJBool(prettyPrint))
  result = call_594711.call(path_594712, query_594713, nil, nil, nil)

var tagmanagerAccountsContainersVersionsUndelete* = Call_TagmanagerAccountsContainersVersionsUndelete_594697(
    name: "tagmanagerAccountsContainersVersionsUndelete",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/versions/{containerVersionId}/undelete",
    validator: validate_TagmanagerAccountsContainersVersionsUndelete_594698,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsUndelete_594699,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsPermissionsCreate_594729 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsPermissionsCreate_594731(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsPermissionsCreate_594730(path: JsonNode;
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
  var valid_594732 = path.getOrDefault("accountId")
  valid_594732 = validateParameter(valid_594732, JString, required = true,
                                 default = nil)
  if valid_594732 != nil:
    section.add "accountId", valid_594732
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
  var valid_594733 = query.getOrDefault("fields")
  valid_594733 = validateParameter(valid_594733, JString, required = false,
                                 default = nil)
  if valid_594733 != nil:
    section.add "fields", valid_594733
  var valid_594734 = query.getOrDefault("quotaUser")
  valid_594734 = validateParameter(valid_594734, JString, required = false,
                                 default = nil)
  if valid_594734 != nil:
    section.add "quotaUser", valid_594734
  var valid_594735 = query.getOrDefault("alt")
  valid_594735 = validateParameter(valid_594735, JString, required = false,
                                 default = newJString("json"))
  if valid_594735 != nil:
    section.add "alt", valid_594735
  var valid_594736 = query.getOrDefault("oauth_token")
  valid_594736 = validateParameter(valid_594736, JString, required = false,
                                 default = nil)
  if valid_594736 != nil:
    section.add "oauth_token", valid_594736
  var valid_594737 = query.getOrDefault("userIp")
  valid_594737 = validateParameter(valid_594737, JString, required = false,
                                 default = nil)
  if valid_594737 != nil:
    section.add "userIp", valid_594737
  var valid_594738 = query.getOrDefault("key")
  valid_594738 = validateParameter(valid_594738, JString, required = false,
                                 default = nil)
  if valid_594738 != nil:
    section.add "key", valid_594738
  var valid_594739 = query.getOrDefault("prettyPrint")
  valid_594739 = validateParameter(valid_594739, JBool, required = false,
                                 default = newJBool(true))
  if valid_594739 != nil:
    section.add "prettyPrint", valid_594739
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

proc call*(call_594741: Call_TagmanagerAccountsPermissionsCreate_594729;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a user's Account & Container Permissions.
  ## 
  let valid = call_594741.validator(path, query, header, formData, body)
  let scheme = call_594741.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594741.url(scheme.get, call_594741.host, call_594741.base,
                         call_594741.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594741, url, valid)

proc call*(call_594742: Call_TagmanagerAccountsPermissionsCreate_594729;
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
  var path_594743 = newJObject()
  var query_594744 = newJObject()
  var body_594745 = newJObject()
  add(query_594744, "fields", newJString(fields))
  add(query_594744, "quotaUser", newJString(quotaUser))
  add(query_594744, "alt", newJString(alt))
  add(query_594744, "oauth_token", newJString(oauthToken))
  add(path_594743, "accountId", newJString(accountId))
  add(query_594744, "userIp", newJString(userIp))
  add(query_594744, "key", newJString(key))
  if body != nil:
    body_594745 = body
  add(query_594744, "prettyPrint", newJBool(prettyPrint))
  result = call_594742.call(path_594743, query_594744, nil, nil, body_594745)

var tagmanagerAccountsPermissionsCreate* = Call_TagmanagerAccountsPermissionsCreate_594729(
    name: "tagmanagerAccountsPermissionsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accounts/{accountId}/permissions",
    validator: validate_TagmanagerAccountsPermissionsCreate_594730,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsPermissionsCreate_594731,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsPermissionsList_594714 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsPermissionsList_594716(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsPermissionsList_594715(path: JsonNode;
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
  var valid_594717 = path.getOrDefault("accountId")
  valid_594717 = validateParameter(valid_594717, JString, required = true,
                                 default = nil)
  if valid_594717 != nil:
    section.add "accountId", valid_594717
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
  var valid_594718 = query.getOrDefault("fields")
  valid_594718 = validateParameter(valid_594718, JString, required = false,
                                 default = nil)
  if valid_594718 != nil:
    section.add "fields", valid_594718
  var valid_594719 = query.getOrDefault("quotaUser")
  valid_594719 = validateParameter(valid_594719, JString, required = false,
                                 default = nil)
  if valid_594719 != nil:
    section.add "quotaUser", valid_594719
  var valid_594720 = query.getOrDefault("alt")
  valid_594720 = validateParameter(valid_594720, JString, required = false,
                                 default = newJString("json"))
  if valid_594720 != nil:
    section.add "alt", valid_594720
  var valid_594721 = query.getOrDefault("oauth_token")
  valid_594721 = validateParameter(valid_594721, JString, required = false,
                                 default = nil)
  if valid_594721 != nil:
    section.add "oauth_token", valid_594721
  var valid_594722 = query.getOrDefault("userIp")
  valid_594722 = validateParameter(valid_594722, JString, required = false,
                                 default = nil)
  if valid_594722 != nil:
    section.add "userIp", valid_594722
  var valid_594723 = query.getOrDefault("key")
  valid_594723 = validateParameter(valid_594723, JString, required = false,
                                 default = nil)
  if valid_594723 != nil:
    section.add "key", valid_594723
  var valid_594724 = query.getOrDefault("prettyPrint")
  valid_594724 = validateParameter(valid_594724, JBool, required = false,
                                 default = newJBool(true))
  if valid_594724 != nil:
    section.add "prettyPrint", valid_594724
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594725: Call_TagmanagerAccountsPermissionsList_594714;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all users that have access to the account along with Account and Container Permissions granted to each of them.
  ## 
  let valid = call_594725.validator(path, query, header, formData, body)
  let scheme = call_594725.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594725.url(scheme.get, call_594725.host, call_594725.base,
                         call_594725.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594725, url, valid)

proc call*(call_594726: Call_TagmanagerAccountsPermissionsList_594714;
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
  var path_594727 = newJObject()
  var query_594728 = newJObject()
  add(query_594728, "fields", newJString(fields))
  add(query_594728, "quotaUser", newJString(quotaUser))
  add(query_594728, "alt", newJString(alt))
  add(query_594728, "oauth_token", newJString(oauthToken))
  add(path_594727, "accountId", newJString(accountId))
  add(query_594728, "userIp", newJString(userIp))
  add(query_594728, "key", newJString(key))
  add(query_594728, "prettyPrint", newJBool(prettyPrint))
  result = call_594726.call(path_594727, query_594728, nil, nil, nil)

var tagmanagerAccountsPermissionsList* = Call_TagmanagerAccountsPermissionsList_594714(
    name: "tagmanagerAccountsPermissionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/permissions",
    validator: validate_TagmanagerAccountsPermissionsList_594715,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsPermissionsList_594716,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsPermissionsUpdate_594762 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsPermissionsUpdate_594764(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsPermissionsUpdate_594763(path: JsonNode;
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
  var valid_594765 = path.getOrDefault("accountId")
  valid_594765 = validateParameter(valid_594765, JString, required = true,
                                 default = nil)
  if valid_594765 != nil:
    section.add "accountId", valid_594765
  var valid_594766 = path.getOrDefault("permissionId")
  valid_594766 = validateParameter(valid_594766, JString, required = true,
                                 default = nil)
  if valid_594766 != nil:
    section.add "permissionId", valid_594766
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
  var valid_594767 = query.getOrDefault("fields")
  valid_594767 = validateParameter(valid_594767, JString, required = false,
                                 default = nil)
  if valid_594767 != nil:
    section.add "fields", valid_594767
  var valid_594768 = query.getOrDefault("quotaUser")
  valid_594768 = validateParameter(valid_594768, JString, required = false,
                                 default = nil)
  if valid_594768 != nil:
    section.add "quotaUser", valid_594768
  var valid_594769 = query.getOrDefault("alt")
  valid_594769 = validateParameter(valid_594769, JString, required = false,
                                 default = newJString("json"))
  if valid_594769 != nil:
    section.add "alt", valid_594769
  var valid_594770 = query.getOrDefault("oauth_token")
  valid_594770 = validateParameter(valid_594770, JString, required = false,
                                 default = nil)
  if valid_594770 != nil:
    section.add "oauth_token", valid_594770
  var valid_594771 = query.getOrDefault("userIp")
  valid_594771 = validateParameter(valid_594771, JString, required = false,
                                 default = nil)
  if valid_594771 != nil:
    section.add "userIp", valid_594771
  var valid_594772 = query.getOrDefault("key")
  valid_594772 = validateParameter(valid_594772, JString, required = false,
                                 default = nil)
  if valid_594772 != nil:
    section.add "key", valid_594772
  var valid_594773 = query.getOrDefault("prettyPrint")
  valid_594773 = validateParameter(valid_594773, JBool, required = false,
                                 default = newJBool(true))
  if valid_594773 != nil:
    section.add "prettyPrint", valid_594773
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

proc call*(call_594775: Call_TagmanagerAccountsPermissionsUpdate_594762;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a user's Account & Container Permissions.
  ## 
  let valid = call_594775.validator(path, query, header, formData, body)
  let scheme = call_594775.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594775.url(scheme.get, call_594775.host, call_594775.base,
                         call_594775.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594775, url, valid)

proc call*(call_594776: Call_TagmanagerAccountsPermissionsUpdate_594762;
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
  var path_594777 = newJObject()
  var query_594778 = newJObject()
  var body_594779 = newJObject()
  add(query_594778, "fields", newJString(fields))
  add(query_594778, "quotaUser", newJString(quotaUser))
  add(query_594778, "alt", newJString(alt))
  add(query_594778, "oauth_token", newJString(oauthToken))
  add(path_594777, "accountId", newJString(accountId))
  add(path_594777, "permissionId", newJString(permissionId))
  add(query_594778, "userIp", newJString(userIp))
  add(query_594778, "key", newJString(key))
  if body != nil:
    body_594779 = body
  add(query_594778, "prettyPrint", newJBool(prettyPrint))
  result = call_594776.call(path_594777, query_594778, nil, nil, body_594779)

var tagmanagerAccountsPermissionsUpdate* = Call_TagmanagerAccountsPermissionsUpdate_594762(
    name: "tagmanagerAccountsPermissionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/permissions/{permissionId}",
    validator: validate_TagmanagerAccountsPermissionsUpdate_594763,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsPermissionsUpdate_594764,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsPermissionsGet_594746 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsPermissionsGet_594748(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsPermissionsGet_594747(path: JsonNode;
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
  var valid_594749 = path.getOrDefault("accountId")
  valid_594749 = validateParameter(valid_594749, JString, required = true,
                                 default = nil)
  if valid_594749 != nil:
    section.add "accountId", valid_594749
  var valid_594750 = path.getOrDefault("permissionId")
  valid_594750 = validateParameter(valid_594750, JString, required = true,
                                 default = nil)
  if valid_594750 != nil:
    section.add "permissionId", valid_594750
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
  var valid_594751 = query.getOrDefault("fields")
  valid_594751 = validateParameter(valid_594751, JString, required = false,
                                 default = nil)
  if valid_594751 != nil:
    section.add "fields", valid_594751
  var valid_594752 = query.getOrDefault("quotaUser")
  valid_594752 = validateParameter(valid_594752, JString, required = false,
                                 default = nil)
  if valid_594752 != nil:
    section.add "quotaUser", valid_594752
  var valid_594753 = query.getOrDefault("alt")
  valid_594753 = validateParameter(valid_594753, JString, required = false,
                                 default = newJString("json"))
  if valid_594753 != nil:
    section.add "alt", valid_594753
  var valid_594754 = query.getOrDefault("oauth_token")
  valid_594754 = validateParameter(valid_594754, JString, required = false,
                                 default = nil)
  if valid_594754 != nil:
    section.add "oauth_token", valid_594754
  var valid_594755 = query.getOrDefault("userIp")
  valid_594755 = validateParameter(valid_594755, JString, required = false,
                                 default = nil)
  if valid_594755 != nil:
    section.add "userIp", valid_594755
  var valid_594756 = query.getOrDefault("key")
  valid_594756 = validateParameter(valid_594756, JString, required = false,
                                 default = nil)
  if valid_594756 != nil:
    section.add "key", valid_594756
  var valid_594757 = query.getOrDefault("prettyPrint")
  valid_594757 = validateParameter(valid_594757, JBool, required = false,
                                 default = newJBool(true))
  if valid_594757 != nil:
    section.add "prettyPrint", valid_594757
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594758: Call_TagmanagerAccountsPermissionsGet_594746;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a user's Account & Container Permissions.
  ## 
  let valid = call_594758.validator(path, query, header, formData, body)
  let scheme = call_594758.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594758.url(scheme.get, call_594758.host, call_594758.base,
                         call_594758.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594758, url, valid)

proc call*(call_594759: Call_TagmanagerAccountsPermissionsGet_594746;
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
  var path_594760 = newJObject()
  var query_594761 = newJObject()
  add(query_594761, "fields", newJString(fields))
  add(query_594761, "quotaUser", newJString(quotaUser))
  add(query_594761, "alt", newJString(alt))
  add(query_594761, "oauth_token", newJString(oauthToken))
  add(path_594760, "accountId", newJString(accountId))
  add(path_594760, "permissionId", newJString(permissionId))
  add(query_594761, "userIp", newJString(userIp))
  add(query_594761, "key", newJString(key))
  add(query_594761, "prettyPrint", newJBool(prettyPrint))
  result = call_594759.call(path_594760, query_594761, nil, nil, nil)

var tagmanagerAccountsPermissionsGet* = Call_TagmanagerAccountsPermissionsGet_594746(
    name: "tagmanagerAccountsPermissionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/permissions/{permissionId}",
    validator: validate_TagmanagerAccountsPermissionsGet_594747,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsPermissionsGet_594748,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsPermissionsDelete_594780 = ref object of OpenApiRestCall_593408
proc url_TagmanagerAccountsPermissionsDelete_594782(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TagmanagerAccountsPermissionsDelete_594781(path: JsonNode;
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
  var valid_594783 = path.getOrDefault("accountId")
  valid_594783 = validateParameter(valid_594783, JString, required = true,
                                 default = nil)
  if valid_594783 != nil:
    section.add "accountId", valid_594783
  var valid_594784 = path.getOrDefault("permissionId")
  valid_594784 = validateParameter(valid_594784, JString, required = true,
                                 default = nil)
  if valid_594784 != nil:
    section.add "permissionId", valid_594784
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
  var valid_594785 = query.getOrDefault("fields")
  valid_594785 = validateParameter(valid_594785, JString, required = false,
                                 default = nil)
  if valid_594785 != nil:
    section.add "fields", valid_594785
  var valid_594786 = query.getOrDefault("quotaUser")
  valid_594786 = validateParameter(valid_594786, JString, required = false,
                                 default = nil)
  if valid_594786 != nil:
    section.add "quotaUser", valid_594786
  var valid_594787 = query.getOrDefault("alt")
  valid_594787 = validateParameter(valid_594787, JString, required = false,
                                 default = newJString("json"))
  if valid_594787 != nil:
    section.add "alt", valid_594787
  var valid_594788 = query.getOrDefault("oauth_token")
  valid_594788 = validateParameter(valid_594788, JString, required = false,
                                 default = nil)
  if valid_594788 != nil:
    section.add "oauth_token", valid_594788
  var valid_594789 = query.getOrDefault("userIp")
  valid_594789 = validateParameter(valid_594789, JString, required = false,
                                 default = nil)
  if valid_594789 != nil:
    section.add "userIp", valid_594789
  var valid_594790 = query.getOrDefault("key")
  valid_594790 = validateParameter(valid_594790, JString, required = false,
                                 default = nil)
  if valid_594790 != nil:
    section.add "key", valid_594790
  var valid_594791 = query.getOrDefault("prettyPrint")
  valid_594791 = validateParameter(valid_594791, JBool, required = false,
                                 default = newJBool(true))
  if valid_594791 != nil:
    section.add "prettyPrint", valid_594791
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594792: Call_TagmanagerAccountsPermissionsDelete_594780;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a user from the account, revoking access to it and all of its containers.
  ## 
  let valid = call_594792.validator(path, query, header, formData, body)
  let scheme = call_594792.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594792.url(scheme.get, call_594792.host, call_594792.base,
                         call_594792.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594792, url, valid)

proc call*(call_594793: Call_TagmanagerAccountsPermissionsDelete_594780;
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
  var path_594794 = newJObject()
  var query_594795 = newJObject()
  add(query_594795, "fields", newJString(fields))
  add(query_594795, "quotaUser", newJString(quotaUser))
  add(query_594795, "alt", newJString(alt))
  add(query_594795, "oauth_token", newJString(oauthToken))
  add(path_594794, "accountId", newJString(accountId))
  add(path_594794, "permissionId", newJString(permissionId))
  add(query_594795, "userIp", newJString(userIp))
  add(query_594795, "key", newJString(key))
  add(query_594795, "prettyPrint", newJBool(prettyPrint))
  result = call_594793.call(path_594794, query_594795, nil, nil, nil)

var tagmanagerAccountsPermissionsDelete* = Call_TagmanagerAccountsPermissionsDelete_594780(
    name: "tagmanagerAccountsPermissionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/permissions/{permissionId}",
    validator: validate_TagmanagerAccountsPermissionsDelete_594781,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsPermissionsDelete_594782,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
