
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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
  gcpServiceName = "tagmanager"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_TagmanagerAccountsList_578609 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsList_578611(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_TagmanagerAccountsList_578610(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all GTM Accounts that a user has access to.
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
  var valid_578723 = query.getOrDefault("key")
  valid_578723 = validateParameter(valid_578723, JString, required = false,
                                 default = nil)
  if valid_578723 != nil:
    section.add "key", valid_578723
  var valid_578737 = query.getOrDefault("prettyPrint")
  valid_578737 = validateParameter(valid_578737, JBool, required = false,
                                 default = newJBool(true))
  if valid_578737 != nil:
    section.add "prettyPrint", valid_578737
  var valid_578738 = query.getOrDefault("oauth_token")
  valid_578738 = validateParameter(valid_578738, JString, required = false,
                                 default = nil)
  if valid_578738 != nil:
    section.add "oauth_token", valid_578738
  var valid_578739 = query.getOrDefault("alt")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = newJString("json"))
  if valid_578739 != nil:
    section.add "alt", valid_578739
  var valid_578740 = query.getOrDefault("userIp")
  valid_578740 = validateParameter(valid_578740, JString, required = false,
                                 default = nil)
  if valid_578740 != nil:
    section.add "userIp", valid_578740
  var valid_578741 = query.getOrDefault("quotaUser")
  valid_578741 = validateParameter(valid_578741, JString, required = false,
                                 default = nil)
  if valid_578741 != nil:
    section.add "quotaUser", valid_578741
  var valid_578742 = query.getOrDefault("fields")
  valid_578742 = validateParameter(valid_578742, JString, required = false,
                                 default = nil)
  if valid_578742 != nil:
    section.add "fields", valid_578742
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578765: Call_TagmanagerAccountsList_578609; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all GTM Accounts that a user has access to.
  ## 
  let valid = call_578765.validator(path, query, header, formData, body)
  let scheme = call_578765.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578765.url(scheme.get, call_578765.host, call_578765.base,
                         call_578765.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578765, url, valid)

proc call*(call_578836: Call_TagmanagerAccountsList_578609; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## tagmanagerAccountsList
  ## Lists all GTM Accounts that a user has access to.
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
  var query_578837 = newJObject()
  add(query_578837, "key", newJString(key))
  add(query_578837, "prettyPrint", newJBool(prettyPrint))
  add(query_578837, "oauth_token", newJString(oauthToken))
  add(query_578837, "alt", newJString(alt))
  add(query_578837, "userIp", newJString(userIp))
  add(query_578837, "quotaUser", newJString(quotaUser))
  add(query_578837, "fields", newJString(fields))
  result = call_578836.call(nil, query_578837, nil, nil, nil)

var tagmanagerAccountsList* = Call_TagmanagerAccountsList_578609(
    name: "tagmanagerAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts",
    validator: validate_TagmanagerAccountsList_578610, base: "/tagmanager/v1",
    url: url_TagmanagerAccountsList_578611, schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsUpdate_578906 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsUpdate_578908(protocol: Scheme; host: string;
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

proc validate_TagmanagerAccountsUpdate_578907(path: JsonNode; query: JsonNode;
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
  var valid_578909 = path.getOrDefault("accountId")
  valid_578909 = validateParameter(valid_578909, JString, required = true,
                                 default = nil)
  if valid_578909 != nil:
    section.add "accountId", valid_578909
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fingerprint: JString
  ##              : When provided, this fingerprint must match the fingerprint of the account in storage.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578910 = query.getOrDefault("key")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "key", valid_578910
  var valid_578911 = query.getOrDefault("prettyPrint")
  valid_578911 = validateParameter(valid_578911, JBool, required = false,
                                 default = newJBool(true))
  if valid_578911 != nil:
    section.add "prettyPrint", valid_578911
  var valid_578912 = query.getOrDefault("oauth_token")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "oauth_token", valid_578912
  var valid_578913 = query.getOrDefault("fingerprint")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "fingerprint", valid_578913
  var valid_578914 = query.getOrDefault("alt")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = newJString("json"))
  if valid_578914 != nil:
    section.add "alt", valid_578914
  var valid_578915 = query.getOrDefault("userIp")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "userIp", valid_578915
  var valid_578916 = query.getOrDefault("quotaUser")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "quotaUser", valid_578916
  var valid_578917 = query.getOrDefault("fields")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "fields", valid_578917
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

proc call*(call_578919: Call_TagmanagerAccountsUpdate_578906; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a GTM Account.
  ## 
  let valid = call_578919.validator(path, query, header, formData, body)
  let scheme = call_578919.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578919.url(scheme.get, call_578919.host, call_578919.base,
                         call_578919.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578919, url, valid)

proc call*(call_578920: Call_TagmanagerAccountsUpdate_578906; accountId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          fingerprint: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## tagmanagerAccountsUpdate
  ## Updates a GTM Account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fingerprint: string
  ##              : When provided, this fingerprint must match the fingerprint of the account in storage.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578921 = newJObject()
  var query_578922 = newJObject()
  var body_578923 = newJObject()
  add(query_578922, "key", newJString(key))
  add(query_578922, "prettyPrint", newJBool(prettyPrint))
  add(query_578922, "oauth_token", newJString(oauthToken))
  add(query_578922, "fingerprint", newJString(fingerprint))
  add(query_578922, "alt", newJString(alt))
  add(query_578922, "userIp", newJString(userIp))
  add(query_578922, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578923 = body
  add(path_578921, "accountId", newJString(accountId))
  add(query_578922, "fields", newJString(fields))
  result = call_578920.call(path_578921, query_578922, nil, nil, body_578923)

var tagmanagerAccountsUpdate* = Call_TagmanagerAccountsUpdate_578906(
    name: "tagmanagerAccountsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/accounts/{accountId}",
    validator: validate_TagmanagerAccountsUpdate_578907, base: "/tagmanager/v1",
    url: url_TagmanagerAccountsUpdate_578908, schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsGet_578877 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsGet_578879(protocol: Scheme; host: string; base: string;
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

proc validate_TagmanagerAccountsGet_578878(path: JsonNode; query: JsonNode;
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
  var valid_578894 = path.getOrDefault("accountId")
  valid_578894 = validateParameter(valid_578894, JString, required = true,
                                 default = nil)
  if valid_578894 != nil:
    section.add "accountId", valid_578894
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
  var valid_578895 = query.getOrDefault("key")
  valid_578895 = validateParameter(valid_578895, JString, required = false,
                                 default = nil)
  if valid_578895 != nil:
    section.add "key", valid_578895
  var valid_578896 = query.getOrDefault("prettyPrint")
  valid_578896 = validateParameter(valid_578896, JBool, required = false,
                                 default = newJBool(true))
  if valid_578896 != nil:
    section.add "prettyPrint", valid_578896
  var valid_578897 = query.getOrDefault("oauth_token")
  valid_578897 = validateParameter(valid_578897, JString, required = false,
                                 default = nil)
  if valid_578897 != nil:
    section.add "oauth_token", valid_578897
  var valid_578898 = query.getOrDefault("alt")
  valid_578898 = validateParameter(valid_578898, JString, required = false,
                                 default = newJString("json"))
  if valid_578898 != nil:
    section.add "alt", valid_578898
  var valid_578899 = query.getOrDefault("userIp")
  valid_578899 = validateParameter(valid_578899, JString, required = false,
                                 default = nil)
  if valid_578899 != nil:
    section.add "userIp", valid_578899
  var valid_578900 = query.getOrDefault("quotaUser")
  valid_578900 = validateParameter(valid_578900, JString, required = false,
                                 default = nil)
  if valid_578900 != nil:
    section.add "quotaUser", valid_578900
  var valid_578901 = query.getOrDefault("fields")
  valid_578901 = validateParameter(valid_578901, JString, required = false,
                                 default = nil)
  if valid_578901 != nil:
    section.add "fields", valid_578901
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578902: Call_TagmanagerAccountsGet_578877; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a GTM Account.
  ## 
  let valid = call_578902.validator(path, query, header, formData, body)
  let scheme = call_578902.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578902.url(scheme.get, call_578902.host, call_578902.base,
                         call_578902.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578902, url, valid)

proc call*(call_578903: Call_TagmanagerAccountsGet_578877; accountId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## tagmanagerAccountsGet
  ## Gets a GTM Account.
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
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578904 = newJObject()
  var query_578905 = newJObject()
  add(query_578905, "key", newJString(key))
  add(query_578905, "prettyPrint", newJBool(prettyPrint))
  add(query_578905, "oauth_token", newJString(oauthToken))
  add(query_578905, "alt", newJString(alt))
  add(query_578905, "userIp", newJString(userIp))
  add(query_578905, "quotaUser", newJString(quotaUser))
  add(path_578904, "accountId", newJString(accountId))
  add(query_578905, "fields", newJString(fields))
  result = call_578903.call(path_578904, query_578905, nil, nil, nil)

var tagmanagerAccountsGet* = Call_TagmanagerAccountsGet_578877(
    name: "tagmanagerAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}",
    validator: validate_TagmanagerAccountsGet_578878, base: "/tagmanager/v1",
    url: url_TagmanagerAccountsGet_578879, schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersCreate_578939 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersCreate_578941(protocol: Scheme; host: string;
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

proc validate_TagmanagerAccountsContainersCreate_578940(path: JsonNode;
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
  var valid_578942 = path.getOrDefault("accountId")
  valid_578942 = validateParameter(valid_578942, JString, required = true,
                                 default = nil)
  if valid_578942 != nil:
    section.add "accountId", valid_578942
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
  var valid_578943 = query.getOrDefault("key")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "key", valid_578943
  var valid_578944 = query.getOrDefault("prettyPrint")
  valid_578944 = validateParameter(valid_578944, JBool, required = false,
                                 default = newJBool(true))
  if valid_578944 != nil:
    section.add "prettyPrint", valid_578944
  var valid_578945 = query.getOrDefault("oauth_token")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "oauth_token", valid_578945
  var valid_578946 = query.getOrDefault("alt")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = newJString("json"))
  if valid_578946 != nil:
    section.add "alt", valid_578946
  var valid_578947 = query.getOrDefault("userIp")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "userIp", valid_578947
  var valid_578948 = query.getOrDefault("quotaUser")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "quotaUser", valid_578948
  var valid_578949 = query.getOrDefault("fields")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "fields", valid_578949
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

proc call*(call_578951: Call_TagmanagerAccountsContainersCreate_578939;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Container.
  ## 
  let valid = call_578951.validator(path, query, header, formData, body)
  let scheme = call_578951.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578951.url(scheme.get, call_578951.host, call_578951.base,
                         call_578951.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578951, url, valid)

proc call*(call_578952: Call_TagmanagerAccountsContainersCreate_578939;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersCreate
  ## Creates a Container.
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
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578953 = newJObject()
  var query_578954 = newJObject()
  var body_578955 = newJObject()
  add(query_578954, "key", newJString(key))
  add(query_578954, "prettyPrint", newJBool(prettyPrint))
  add(query_578954, "oauth_token", newJString(oauthToken))
  add(query_578954, "alt", newJString(alt))
  add(query_578954, "userIp", newJString(userIp))
  add(query_578954, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578955 = body
  add(path_578953, "accountId", newJString(accountId))
  add(query_578954, "fields", newJString(fields))
  result = call_578952.call(path_578953, query_578954, nil, nil, body_578955)

var tagmanagerAccountsContainersCreate* = Call_TagmanagerAccountsContainersCreate_578939(
    name: "tagmanagerAccountsContainersCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers",
    validator: validate_TagmanagerAccountsContainersCreate_578940,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersCreate_578941,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersList_578924 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersList_578926(protocol: Scheme; host: string;
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

proc validate_TagmanagerAccountsContainersList_578925(path: JsonNode;
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
  var valid_578927 = path.getOrDefault("accountId")
  valid_578927 = validateParameter(valid_578927, JString, required = true,
                                 default = nil)
  if valid_578927 != nil:
    section.add "accountId", valid_578927
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
  var valid_578928 = query.getOrDefault("key")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "key", valid_578928
  var valid_578929 = query.getOrDefault("prettyPrint")
  valid_578929 = validateParameter(valid_578929, JBool, required = false,
                                 default = newJBool(true))
  if valid_578929 != nil:
    section.add "prettyPrint", valid_578929
  var valid_578930 = query.getOrDefault("oauth_token")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "oauth_token", valid_578930
  var valid_578931 = query.getOrDefault("alt")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = newJString("json"))
  if valid_578931 != nil:
    section.add "alt", valid_578931
  var valid_578932 = query.getOrDefault("userIp")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "userIp", valid_578932
  var valid_578933 = query.getOrDefault("quotaUser")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "quotaUser", valid_578933
  var valid_578934 = query.getOrDefault("fields")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "fields", valid_578934
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578935: Call_TagmanagerAccountsContainersList_578924;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all Containers that belongs to a GTM Account.
  ## 
  let valid = call_578935.validator(path, query, header, formData, body)
  let scheme = call_578935.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578935.url(scheme.get, call_578935.host, call_578935.base,
                         call_578935.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578935, url, valid)

proc call*(call_578936: Call_TagmanagerAccountsContainersList_578924;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersList
  ## Lists all Containers that belongs to a GTM Account.
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
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578937 = newJObject()
  var query_578938 = newJObject()
  add(query_578938, "key", newJString(key))
  add(query_578938, "prettyPrint", newJBool(prettyPrint))
  add(query_578938, "oauth_token", newJString(oauthToken))
  add(query_578938, "alt", newJString(alt))
  add(query_578938, "userIp", newJString(userIp))
  add(query_578938, "quotaUser", newJString(quotaUser))
  add(path_578937, "accountId", newJString(accountId))
  add(query_578938, "fields", newJString(fields))
  result = call_578936.call(path_578937, query_578938, nil, nil, nil)

var tagmanagerAccountsContainersList* = Call_TagmanagerAccountsContainersList_578924(
    name: "tagmanagerAccountsContainersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers",
    validator: validate_TagmanagerAccountsContainersList_578925,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersList_578926,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersUpdate_578972 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersUpdate_578974(protocol: Scheme; host: string;
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

proc validate_TagmanagerAccountsContainersUpdate_578973(path: JsonNode;
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
  var valid_578975 = path.getOrDefault("containerId")
  valid_578975 = validateParameter(valid_578975, JString, required = true,
                                 default = nil)
  if valid_578975 != nil:
    section.add "containerId", valid_578975
  var valid_578976 = path.getOrDefault("accountId")
  valid_578976 = validateParameter(valid_578976, JString, required = true,
                                 default = nil)
  if valid_578976 != nil:
    section.add "accountId", valid_578976
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fingerprint: JString
  ##              : When provided, this fingerprint must match the fingerprint of the container in storage.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578977 = query.getOrDefault("key")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "key", valid_578977
  var valid_578978 = query.getOrDefault("prettyPrint")
  valid_578978 = validateParameter(valid_578978, JBool, required = false,
                                 default = newJBool(true))
  if valid_578978 != nil:
    section.add "prettyPrint", valid_578978
  var valid_578979 = query.getOrDefault("oauth_token")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "oauth_token", valid_578979
  var valid_578980 = query.getOrDefault("fingerprint")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "fingerprint", valid_578980
  var valid_578981 = query.getOrDefault("alt")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = newJString("json"))
  if valid_578981 != nil:
    section.add "alt", valid_578981
  var valid_578982 = query.getOrDefault("userIp")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "userIp", valid_578982
  var valid_578983 = query.getOrDefault("quotaUser")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "quotaUser", valid_578983
  var valid_578984 = query.getOrDefault("fields")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "fields", valid_578984
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

proc call*(call_578986: Call_TagmanagerAccountsContainersUpdate_578972;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a Container.
  ## 
  let valid = call_578986.validator(path, query, header, formData, body)
  let scheme = call_578986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578986.url(scheme.get, call_578986.host, call_578986.base,
                         call_578986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578986, url, valid)

proc call*(call_578987: Call_TagmanagerAccountsContainersUpdate_578972;
          containerId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; fingerprint: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersUpdate
  ## Updates a Container.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fingerprint: string
  ##              : When provided, this fingerprint must match the fingerprint of the container in storage.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578988 = newJObject()
  var query_578989 = newJObject()
  var body_578990 = newJObject()
  add(query_578989, "key", newJString(key))
  add(query_578989, "prettyPrint", newJBool(prettyPrint))
  add(query_578989, "oauth_token", newJString(oauthToken))
  add(path_578988, "containerId", newJString(containerId))
  add(query_578989, "fingerprint", newJString(fingerprint))
  add(query_578989, "alt", newJString(alt))
  add(query_578989, "userIp", newJString(userIp))
  add(query_578989, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578990 = body
  add(path_578988, "accountId", newJString(accountId))
  add(query_578989, "fields", newJString(fields))
  result = call_578987.call(path_578988, query_578989, nil, nil, body_578990)

var tagmanagerAccountsContainersUpdate* = Call_TagmanagerAccountsContainersUpdate_578972(
    name: "tagmanagerAccountsContainersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}",
    validator: validate_TagmanagerAccountsContainersUpdate_578973,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersUpdate_578974,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersGet_578956 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersGet_578958(protocol: Scheme; host: string;
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

proc validate_TagmanagerAccountsContainersGet_578957(path: JsonNode;
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
  var valid_578959 = path.getOrDefault("containerId")
  valid_578959 = validateParameter(valid_578959, JString, required = true,
                                 default = nil)
  if valid_578959 != nil:
    section.add "containerId", valid_578959
  var valid_578960 = path.getOrDefault("accountId")
  valid_578960 = validateParameter(valid_578960, JString, required = true,
                                 default = nil)
  if valid_578960 != nil:
    section.add "accountId", valid_578960
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
  var valid_578961 = query.getOrDefault("key")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "key", valid_578961
  var valid_578962 = query.getOrDefault("prettyPrint")
  valid_578962 = validateParameter(valid_578962, JBool, required = false,
                                 default = newJBool(true))
  if valid_578962 != nil:
    section.add "prettyPrint", valid_578962
  var valid_578963 = query.getOrDefault("oauth_token")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "oauth_token", valid_578963
  var valid_578964 = query.getOrDefault("alt")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = newJString("json"))
  if valid_578964 != nil:
    section.add "alt", valid_578964
  var valid_578965 = query.getOrDefault("userIp")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "userIp", valid_578965
  var valid_578966 = query.getOrDefault("quotaUser")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "quotaUser", valid_578966
  var valid_578967 = query.getOrDefault("fields")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "fields", valid_578967
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578968: Call_TagmanagerAccountsContainersGet_578956;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a Container.
  ## 
  let valid = call_578968.validator(path, query, header, formData, body)
  let scheme = call_578968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578968.url(scheme.get, call_578968.host, call_578968.base,
                         call_578968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578968, url, valid)

proc call*(call_578969: Call_TagmanagerAccountsContainersGet_578956;
          containerId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersGet
  ## Gets a Container.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578970 = newJObject()
  var query_578971 = newJObject()
  add(query_578971, "key", newJString(key))
  add(query_578971, "prettyPrint", newJBool(prettyPrint))
  add(query_578971, "oauth_token", newJString(oauthToken))
  add(path_578970, "containerId", newJString(containerId))
  add(query_578971, "alt", newJString(alt))
  add(query_578971, "userIp", newJString(userIp))
  add(query_578971, "quotaUser", newJString(quotaUser))
  add(path_578970, "accountId", newJString(accountId))
  add(query_578971, "fields", newJString(fields))
  result = call_578969.call(path_578970, query_578971, nil, nil, nil)

var tagmanagerAccountsContainersGet* = Call_TagmanagerAccountsContainersGet_578956(
    name: "tagmanagerAccountsContainersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}",
    validator: validate_TagmanagerAccountsContainersGet_578957,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersGet_578958,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersDelete_578991 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersDelete_578993(protocol: Scheme; host: string;
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

proc validate_TagmanagerAccountsContainersDelete_578992(path: JsonNode;
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
  var valid_578994 = path.getOrDefault("containerId")
  valid_578994 = validateParameter(valid_578994, JString, required = true,
                                 default = nil)
  if valid_578994 != nil:
    section.add "containerId", valid_578994
  var valid_578995 = path.getOrDefault("accountId")
  valid_578995 = validateParameter(valid_578995, JString, required = true,
                                 default = nil)
  if valid_578995 != nil:
    section.add "accountId", valid_578995
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
  var valid_578996 = query.getOrDefault("key")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "key", valid_578996
  var valid_578997 = query.getOrDefault("prettyPrint")
  valid_578997 = validateParameter(valid_578997, JBool, required = false,
                                 default = newJBool(true))
  if valid_578997 != nil:
    section.add "prettyPrint", valid_578997
  var valid_578998 = query.getOrDefault("oauth_token")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "oauth_token", valid_578998
  var valid_578999 = query.getOrDefault("alt")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = newJString("json"))
  if valid_578999 != nil:
    section.add "alt", valid_578999
  var valid_579000 = query.getOrDefault("userIp")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "userIp", valid_579000
  var valid_579001 = query.getOrDefault("quotaUser")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "quotaUser", valid_579001
  var valid_579002 = query.getOrDefault("fields")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "fields", valid_579002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579003: Call_TagmanagerAccountsContainersDelete_578991;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a Container.
  ## 
  let valid = call_579003.validator(path, query, header, formData, body)
  let scheme = call_579003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579003.url(scheme.get, call_579003.host, call_579003.base,
                         call_579003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579003, url, valid)

proc call*(call_579004: Call_TagmanagerAccountsContainersDelete_578991;
          containerId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersDelete
  ## Deletes a Container.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579005 = newJObject()
  var query_579006 = newJObject()
  add(query_579006, "key", newJString(key))
  add(query_579006, "prettyPrint", newJBool(prettyPrint))
  add(query_579006, "oauth_token", newJString(oauthToken))
  add(path_579005, "containerId", newJString(containerId))
  add(query_579006, "alt", newJString(alt))
  add(query_579006, "userIp", newJString(userIp))
  add(query_579006, "quotaUser", newJString(quotaUser))
  add(path_579005, "accountId", newJString(accountId))
  add(query_579006, "fields", newJString(fields))
  result = call_579004.call(path_579005, query_579006, nil, nil, nil)

var tagmanagerAccountsContainersDelete* = Call_TagmanagerAccountsContainersDelete_578991(
    name: "tagmanagerAccountsContainersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}",
    validator: validate_TagmanagerAccountsContainersDelete_578992,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersDelete_578993,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersEnvironmentsCreate_579023 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersEnvironmentsCreate_579025(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersEnvironmentsCreate_579024(
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
  var valid_579026 = path.getOrDefault("containerId")
  valid_579026 = validateParameter(valid_579026, JString, required = true,
                                 default = nil)
  if valid_579026 != nil:
    section.add "containerId", valid_579026
  var valid_579027 = path.getOrDefault("accountId")
  valid_579027 = validateParameter(valid_579027, JString, required = true,
                                 default = nil)
  if valid_579027 != nil:
    section.add "accountId", valid_579027
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
  var valid_579031 = query.getOrDefault("alt")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = newJString("json"))
  if valid_579031 != nil:
    section.add "alt", valid_579031
  var valid_579032 = query.getOrDefault("userIp")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "userIp", valid_579032
  var valid_579033 = query.getOrDefault("quotaUser")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "quotaUser", valid_579033
  var valid_579034 = query.getOrDefault("fields")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "fields", valid_579034
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

proc call*(call_579036: Call_TagmanagerAccountsContainersEnvironmentsCreate_579023;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a GTM Environment.
  ## 
  let valid = call_579036.validator(path, query, header, formData, body)
  let scheme = call_579036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579036.url(scheme.get, call_579036.host, call_579036.base,
                         call_579036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579036, url, valid)

proc call*(call_579037: Call_TagmanagerAccountsContainersEnvironmentsCreate_579023;
          containerId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersEnvironmentsCreate
  ## Creates a GTM Environment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579038 = newJObject()
  var query_579039 = newJObject()
  var body_579040 = newJObject()
  add(query_579039, "key", newJString(key))
  add(query_579039, "prettyPrint", newJBool(prettyPrint))
  add(query_579039, "oauth_token", newJString(oauthToken))
  add(path_579038, "containerId", newJString(containerId))
  add(query_579039, "alt", newJString(alt))
  add(query_579039, "userIp", newJString(userIp))
  add(query_579039, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579040 = body
  add(path_579038, "accountId", newJString(accountId))
  add(query_579039, "fields", newJString(fields))
  result = call_579037.call(path_579038, query_579039, nil, nil, body_579040)

var tagmanagerAccountsContainersEnvironmentsCreate* = Call_TagmanagerAccountsContainersEnvironmentsCreate_579023(
    name: "tagmanagerAccountsContainersEnvironmentsCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/environments",
    validator: validate_TagmanagerAccountsContainersEnvironmentsCreate_579024,
    base: "/tagmanager/v1",
    url: url_TagmanagerAccountsContainersEnvironmentsCreate_579025,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersEnvironmentsList_579007 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersEnvironmentsList_579009(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersEnvironmentsList_579008(path: JsonNode;
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
  var valid_579010 = path.getOrDefault("containerId")
  valid_579010 = validateParameter(valid_579010, JString, required = true,
                                 default = nil)
  if valid_579010 != nil:
    section.add "containerId", valid_579010
  var valid_579011 = path.getOrDefault("accountId")
  valid_579011 = validateParameter(valid_579011, JString, required = true,
                                 default = nil)
  if valid_579011 != nil:
    section.add "accountId", valid_579011
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
  var valid_579012 = query.getOrDefault("key")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "key", valid_579012
  var valid_579013 = query.getOrDefault("prettyPrint")
  valid_579013 = validateParameter(valid_579013, JBool, required = false,
                                 default = newJBool(true))
  if valid_579013 != nil:
    section.add "prettyPrint", valid_579013
  var valid_579014 = query.getOrDefault("oauth_token")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "oauth_token", valid_579014
  var valid_579015 = query.getOrDefault("alt")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = newJString("json"))
  if valid_579015 != nil:
    section.add "alt", valid_579015
  var valid_579016 = query.getOrDefault("userIp")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "userIp", valid_579016
  var valid_579017 = query.getOrDefault("quotaUser")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "quotaUser", valid_579017
  var valid_579018 = query.getOrDefault("fields")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "fields", valid_579018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579019: Call_TagmanagerAccountsContainersEnvironmentsList_579007;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all GTM Environments of a GTM Container.
  ## 
  let valid = call_579019.validator(path, query, header, formData, body)
  let scheme = call_579019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579019.url(scheme.get, call_579019.host, call_579019.base,
                         call_579019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579019, url, valid)

proc call*(call_579020: Call_TagmanagerAccountsContainersEnvironmentsList_579007;
          containerId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersEnvironmentsList
  ## Lists all GTM Environments of a GTM Container.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579021 = newJObject()
  var query_579022 = newJObject()
  add(query_579022, "key", newJString(key))
  add(query_579022, "prettyPrint", newJBool(prettyPrint))
  add(query_579022, "oauth_token", newJString(oauthToken))
  add(path_579021, "containerId", newJString(containerId))
  add(query_579022, "alt", newJString(alt))
  add(query_579022, "userIp", newJString(userIp))
  add(query_579022, "quotaUser", newJString(quotaUser))
  add(path_579021, "accountId", newJString(accountId))
  add(query_579022, "fields", newJString(fields))
  result = call_579020.call(path_579021, query_579022, nil, nil, nil)

var tagmanagerAccountsContainersEnvironmentsList* = Call_TagmanagerAccountsContainersEnvironmentsList_579007(
    name: "tagmanagerAccountsContainersEnvironmentsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/environments",
    validator: validate_TagmanagerAccountsContainersEnvironmentsList_579008,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersEnvironmentsList_579009,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersEnvironmentsUpdate_579058 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersEnvironmentsUpdate_579060(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersEnvironmentsUpdate_579059(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates a GTM Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   environmentId: JString (required)
  ##                : The GTM Environment ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_579061 = path.getOrDefault("containerId")
  valid_579061 = validateParameter(valid_579061, JString, required = true,
                                 default = nil)
  if valid_579061 != nil:
    section.add "containerId", valid_579061
  var valid_579062 = path.getOrDefault("environmentId")
  valid_579062 = validateParameter(valid_579062, JString, required = true,
                                 default = nil)
  if valid_579062 != nil:
    section.add "environmentId", valid_579062
  var valid_579063 = path.getOrDefault("accountId")
  valid_579063 = validateParameter(valid_579063, JString, required = true,
                                 default = nil)
  if valid_579063 != nil:
    section.add "accountId", valid_579063
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fingerprint: JString
  ##              : When provided, this fingerprint must match the fingerprint of the environment in storage.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579064 = query.getOrDefault("key")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "key", valid_579064
  var valid_579065 = query.getOrDefault("prettyPrint")
  valid_579065 = validateParameter(valid_579065, JBool, required = false,
                                 default = newJBool(true))
  if valid_579065 != nil:
    section.add "prettyPrint", valid_579065
  var valid_579066 = query.getOrDefault("oauth_token")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "oauth_token", valid_579066
  var valid_579067 = query.getOrDefault("fingerprint")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "fingerprint", valid_579067
  var valid_579068 = query.getOrDefault("alt")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = newJString("json"))
  if valid_579068 != nil:
    section.add "alt", valid_579068
  var valid_579069 = query.getOrDefault("userIp")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "userIp", valid_579069
  var valid_579070 = query.getOrDefault("quotaUser")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = nil)
  if valid_579070 != nil:
    section.add "quotaUser", valid_579070
  var valid_579071 = query.getOrDefault("fields")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "fields", valid_579071
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

proc call*(call_579073: Call_TagmanagerAccountsContainersEnvironmentsUpdate_579058;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a GTM Environment.
  ## 
  let valid = call_579073.validator(path, query, header, formData, body)
  let scheme = call_579073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579073.url(scheme.get, call_579073.host, call_579073.base,
                         call_579073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579073, url, valid)

proc call*(call_579074: Call_TagmanagerAccountsContainersEnvironmentsUpdate_579058;
          containerId: string; environmentId: string; accountId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          fingerprint: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersEnvironmentsUpdate
  ## Updates a GTM Environment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fingerprint: string
  ##              : When provided, this fingerprint must match the fingerprint of the environment in storage.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   environmentId: string (required)
  ##                : The GTM Environment ID.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579075 = newJObject()
  var query_579076 = newJObject()
  var body_579077 = newJObject()
  add(query_579076, "key", newJString(key))
  add(query_579076, "prettyPrint", newJBool(prettyPrint))
  add(query_579076, "oauth_token", newJString(oauthToken))
  add(path_579075, "containerId", newJString(containerId))
  add(query_579076, "fingerprint", newJString(fingerprint))
  add(query_579076, "alt", newJString(alt))
  add(query_579076, "userIp", newJString(userIp))
  add(query_579076, "quotaUser", newJString(quotaUser))
  add(path_579075, "environmentId", newJString(environmentId))
  if body != nil:
    body_579077 = body
  add(path_579075, "accountId", newJString(accountId))
  add(query_579076, "fields", newJString(fields))
  result = call_579074.call(path_579075, query_579076, nil, nil, body_579077)

var tagmanagerAccountsContainersEnvironmentsUpdate* = Call_TagmanagerAccountsContainersEnvironmentsUpdate_579058(
    name: "tagmanagerAccountsContainersEnvironmentsUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/environments/{environmentId}",
    validator: validate_TagmanagerAccountsContainersEnvironmentsUpdate_579059,
    base: "/tagmanager/v1",
    url: url_TagmanagerAccountsContainersEnvironmentsUpdate_579060,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersEnvironmentsGet_579041 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersEnvironmentsGet_579043(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersEnvironmentsGet_579042(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a GTM Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   environmentId: JString (required)
  ##                : The GTM Environment ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_579044 = path.getOrDefault("containerId")
  valid_579044 = validateParameter(valid_579044, JString, required = true,
                                 default = nil)
  if valid_579044 != nil:
    section.add "containerId", valid_579044
  var valid_579045 = path.getOrDefault("environmentId")
  valid_579045 = validateParameter(valid_579045, JString, required = true,
                                 default = nil)
  if valid_579045 != nil:
    section.add "environmentId", valid_579045
  var valid_579046 = path.getOrDefault("accountId")
  valid_579046 = validateParameter(valid_579046, JString, required = true,
                                 default = nil)
  if valid_579046 != nil:
    section.add "accountId", valid_579046
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
  var valid_579050 = query.getOrDefault("alt")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = newJString("json"))
  if valid_579050 != nil:
    section.add "alt", valid_579050
  var valid_579051 = query.getOrDefault("userIp")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "userIp", valid_579051
  var valid_579052 = query.getOrDefault("quotaUser")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "quotaUser", valid_579052
  var valid_579053 = query.getOrDefault("fields")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "fields", valid_579053
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579054: Call_TagmanagerAccountsContainersEnvironmentsGet_579041;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a GTM Environment.
  ## 
  let valid = call_579054.validator(path, query, header, formData, body)
  let scheme = call_579054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579054.url(scheme.get, call_579054.host, call_579054.base,
                         call_579054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579054, url, valid)

proc call*(call_579055: Call_TagmanagerAccountsContainersEnvironmentsGet_579041;
          containerId: string; environmentId: string; accountId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersEnvironmentsGet
  ## Gets a GTM Environment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   environmentId: string (required)
  ##                : The GTM Environment ID.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579056 = newJObject()
  var query_579057 = newJObject()
  add(query_579057, "key", newJString(key))
  add(query_579057, "prettyPrint", newJBool(prettyPrint))
  add(query_579057, "oauth_token", newJString(oauthToken))
  add(path_579056, "containerId", newJString(containerId))
  add(query_579057, "alt", newJString(alt))
  add(query_579057, "userIp", newJString(userIp))
  add(query_579057, "quotaUser", newJString(quotaUser))
  add(path_579056, "environmentId", newJString(environmentId))
  add(path_579056, "accountId", newJString(accountId))
  add(query_579057, "fields", newJString(fields))
  result = call_579055.call(path_579056, query_579057, nil, nil, nil)

var tagmanagerAccountsContainersEnvironmentsGet* = Call_TagmanagerAccountsContainersEnvironmentsGet_579041(
    name: "tagmanagerAccountsContainersEnvironmentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/environments/{environmentId}",
    validator: validate_TagmanagerAccountsContainersEnvironmentsGet_579042,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersEnvironmentsGet_579043,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersEnvironmentsDelete_579078 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersEnvironmentsDelete_579080(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersEnvironmentsDelete_579079(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes a GTM Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   environmentId: JString (required)
  ##                : The GTM Environment ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_579081 = path.getOrDefault("containerId")
  valid_579081 = validateParameter(valid_579081, JString, required = true,
                                 default = nil)
  if valid_579081 != nil:
    section.add "containerId", valid_579081
  var valid_579082 = path.getOrDefault("environmentId")
  valid_579082 = validateParameter(valid_579082, JString, required = true,
                                 default = nil)
  if valid_579082 != nil:
    section.add "environmentId", valid_579082
  var valid_579083 = path.getOrDefault("accountId")
  valid_579083 = validateParameter(valid_579083, JString, required = true,
                                 default = nil)
  if valid_579083 != nil:
    section.add "accountId", valid_579083
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
  var valid_579084 = query.getOrDefault("key")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "key", valid_579084
  var valid_579085 = query.getOrDefault("prettyPrint")
  valid_579085 = validateParameter(valid_579085, JBool, required = false,
                                 default = newJBool(true))
  if valid_579085 != nil:
    section.add "prettyPrint", valid_579085
  var valid_579086 = query.getOrDefault("oauth_token")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "oauth_token", valid_579086
  var valid_579087 = query.getOrDefault("alt")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = newJString("json"))
  if valid_579087 != nil:
    section.add "alt", valid_579087
  var valid_579088 = query.getOrDefault("userIp")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "userIp", valid_579088
  var valid_579089 = query.getOrDefault("quotaUser")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "quotaUser", valid_579089
  var valid_579090 = query.getOrDefault("fields")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "fields", valid_579090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579091: Call_TagmanagerAccountsContainersEnvironmentsDelete_579078;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a GTM Environment.
  ## 
  let valid = call_579091.validator(path, query, header, formData, body)
  let scheme = call_579091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579091.url(scheme.get, call_579091.host, call_579091.base,
                         call_579091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579091, url, valid)

proc call*(call_579092: Call_TagmanagerAccountsContainersEnvironmentsDelete_579078;
          containerId: string; environmentId: string; accountId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersEnvironmentsDelete
  ## Deletes a GTM Environment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   environmentId: string (required)
  ##                : The GTM Environment ID.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579093 = newJObject()
  var query_579094 = newJObject()
  add(query_579094, "key", newJString(key))
  add(query_579094, "prettyPrint", newJBool(prettyPrint))
  add(query_579094, "oauth_token", newJString(oauthToken))
  add(path_579093, "containerId", newJString(containerId))
  add(query_579094, "alt", newJString(alt))
  add(query_579094, "userIp", newJString(userIp))
  add(query_579094, "quotaUser", newJString(quotaUser))
  add(path_579093, "environmentId", newJString(environmentId))
  add(path_579093, "accountId", newJString(accountId))
  add(query_579094, "fields", newJString(fields))
  result = call_579092.call(path_579093, query_579094, nil, nil, nil)

var tagmanagerAccountsContainersEnvironmentsDelete* = Call_TagmanagerAccountsContainersEnvironmentsDelete_579078(
    name: "tagmanagerAccountsContainersEnvironmentsDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/environments/{environmentId}",
    validator: validate_TagmanagerAccountsContainersEnvironmentsDelete_579079,
    base: "/tagmanager/v1",
    url: url_TagmanagerAccountsContainersEnvironmentsDelete_579080,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersFoldersCreate_579111 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersFoldersCreate_579113(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersFoldersCreate_579112(path: JsonNode;
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
  var valid_579114 = path.getOrDefault("containerId")
  valid_579114 = validateParameter(valid_579114, JString, required = true,
                                 default = nil)
  if valid_579114 != nil:
    section.add "containerId", valid_579114
  var valid_579115 = path.getOrDefault("accountId")
  valid_579115 = validateParameter(valid_579115, JString, required = true,
                                 default = nil)
  if valid_579115 != nil:
    section.add "accountId", valid_579115
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
  var valid_579116 = query.getOrDefault("key")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "key", valid_579116
  var valid_579117 = query.getOrDefault("prettyPrint")
  valid_579117 = validateParameter(valid_579117, JBool, required = false,
                                 default = newJBool(true))
  if valid_579117 != nil:
    section.add "prettyPrint", valid_579117
  var valid_579118 = query.getOrDefault("oauth_token")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "oauth_token", valid_579118
  var valid_579119 = query.getOrDefault("alt")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = newJString("json"))
  if valid_579119 != nil:
    section.add "alt", valid_579119
  var valid_579120 = query.getOrDefault("userIp")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "userIp", valid_579120
  var valid_579121 = query.getOrDefault("quotaUser")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "quotaUser", valid_579121
  var valid_579122 = query.getOrDefault("fields")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "fields", valid_579122
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

proc call*(call_579124: Call_TagmanagerAccountsContainersFoldersCreate_579111;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a GTM Folder.
  ## 
  let valid = call_579124.validator(path, query, header, formData, body)
  let scheme = call_579124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579124.url(scheme.get, call_579124.host, call_579124.base,
                         call_579124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579124, url, valid)

proc call*(call_579125: Call_TagmanagerAccountsContainersFoldersCreate_579111;
          containerId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersFoldersCreate
  ## Creates a GTM Folder.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579126 = newJObject()
  var query_579127 = newJObject()
  var body_579128 = newJObject()
  add(query_579127, "key", newJString(key))
  add(query_579127, "prettyPrint", newJBool(prettyPrint))
  add(query_579127, "oauth_token", newJString(oauthToken))
  add(path_579126, "containerId", newJString(containerId))
  add(query_579127, "alt", newJString(alt))
  add(query_579127, "userIp", newJString(userIp))
  add(query_579127, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579128 = body
  add(path_579126, "accountId", newJString(accountId))
  add(query_579127, "fields", newJString(fields))
  result = call_579125.call(path_579126, query_579127, nil, nil, body_579128)

var tagmanagerAccountsContainersFoldersCreate* = Call_TagmanagerAccountsContainersFoldersCreate_579111(
    name: "tagmanagerAccountsContainersFoldersCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/folders",
    validator: validate_TagmanagerAccountsContainersFoldersCreate_579112,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersFoldersCreate_579113,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersFoldersList_579095 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersFoldersList_579097(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersFoldersList_579096(path: JsonNode;
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
  var valid_579098 = path.getOrDefault("containerId")
  valid_579098 = validateParameter(valid_579098, JString, required = true,
                                 default = nil)
  if valid_579098 != nil:
    section.add "containerId", valid_579098
  var valid_579099 = path.getOrDefault("accountId")
  valid_579099 = validateParameter(valid_579099, JString, required = true,
                                 default = nil)
  if valid_579099 != nil:
    section.add "accountId", valid_579099
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
  var valid_579100 = query.getOrDefault("key")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "key", valid_579100
  var valid_579101 = query.getOrDefault("prettyPrint")
  valid_579101 = validateParameter(valid_579101, JBool, required = false,
                                 default = newJBool(true))
  if valid_579101 != nil:
    section.add "prettyPrint", valid_579101
  var valid_579102 = query.getOrDefault("oauth_token")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "oauth_token", valid_579102
  var valid_579103 = query.getOrDefault("alt")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = newJString("json"))
  if valid_579103 != nil:
    section.add "alt", valid_579103
  var valid_579104 = query.getOrDefault("userIp")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "userIp", valid_579104
  var valid_579105 = query.getOrDefault("quotaUser")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "quotaUser", valid_579105
  var valid_579106 = query.getOrDefault("fields")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "fields", valid_579106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579107: Call_TagmanagerAccountsContainersFoldersList_579095;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all GTM Folders of a Container.
  ## 
  let valid = call_579107.validator(path, query, header, formData, body)
  let scheme = call_579107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579107.url(scheme.get, call_579107.host, call_579107.base,
                         call_579107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579107, url, valid)

proc call*(call_579108: Call_TagmanagerAccountsContainersFoldersList_579095;
          containerId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersFoldersList
  ## Lists all GTM Folders of a Container.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579109 = newJObject()
  var query_579110 = newJObject()
  add(query_579110, "key", newJString(key))
  add(query_579110, "prettyPrint", newJBool(prettyPrint))
  add(query_579110, "oauth_token", newJString(oauthToken))
  add(path_579109, "containerId", newJString(containerId))
  add(query_579110, "alt", newJString(alt))
  add(query_579110, "userIp", newJString(userIp))
  add(query_579110, "quotaUser", newJString(quotaUser))
  add(path_579109, "accountId", newJString(accountId))
  add(query_579110, "fields", newJString(fields))
  result = call_579108.call(path_579109, query_579110, nil, nil, nil)

var tagmanagerAccountsContainersFoldersList* = Call_TagmanagerAccountsContainersFoldersList_579095(
    name: "tagmanagerAccountsContainersFoldersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/folders",
    validator: validate_TagmanagerAccountsContainersFoldersList_579096,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersFoldersList_579097,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersFoldersUpdate_579146 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersFoldersUpdate_579148(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersFoldersUpdate_579147(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a GTM Folder.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   folderId: JString (required)
  ##           : The GTM Folder ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_579149 = path.getOrDefault("containerId")
  valid_579149 = validateParameter(valid_579149, JString, required = true,
                                 default = nil)
  if valid_579149 != nil:
    section.add "containerId", valid_579149
  var valid_579150 = path.getOrDefault("folderId")
  valid_579150 = validateParameter(valid_579150, JString, required = true,
                                 default = nil)
  if valid_579150 != nil:
    section.add "folderId", valid_579150
  var valid_579151 = path.getOrDefault("accountId")
  valid_579151 = validateParameter(valid_579151, JString, required = true,
                                 default = nil)
  if valid_579151 != nil:
    section.add "accountId", valid_579151
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fingerprint: JString
  ##              : When provided, this fingerprint must match the fingerprint of the folder in storage.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579152 = query.getOrDefault("key")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "key", valid_579152
  var valid_579153 = query.getOrDefault("prettyPrint")
  valid_579153 = validateParameter(valid_579153, JBool, required = false,
                                 default = newJBool(true))
  if valid_579153 != nil:
    section.add "prettyPrint", valid_579153
  var valid_579154 = query.getOrDefault("oauth_token")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = nil)
  if valid_579154 != nil:
    section.add "oauth_token", valid_579154
  var valid_579155 = query.getOrDefault("fingerprint")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = nil)
  if valid_579155 != nil:
    section.add "fingerprint", valid_579155
  var valid_579156 = query.getOrDefault("alt")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = newJString("json"))
  if valid_579156 != nil:
    section.add "alt", valid_579156
  var valid_579157 = query.getOrDefault("userIp")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = nil)
  if valid_579157 != nil:
    section.add "userIp", valid_579157
  var valid_579158 = query.getOrDefault("quotaUser")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "quotaUser", valid_579158
  var valid_579159 = query.getOrDefault("fields")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = nil)
  if valid_579159 != nil:
    section.add "fields", valid_579159
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

proc call*(call_579161: Call_TagmanagerAccountsContainersFoldersUpdate_579146;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a GTM Folder.
  ## 
  let valid = call_579161.validator(path, query, header, formData, body)
  let scheme = call_579161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579161.url(scheme.get, call_579161.host, call_579161.base,
                         call_579161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579161, url, valid)

proc call*(call_579162: Call_TagmanagerAccountsContainersFoldersUpdate_579146;
          containerId: string; folderId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; fingerprint: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersFoldersUpdate
  ## Updates a GTM Folder.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fingerprint: string
  ##              : When provided, this fingerprint must match the fingerprint of the folder in storage.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   folderId: string (required)
  ##           : The GTM Folder ID.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579163 = newJObject()
  var query_579164 = newJObject()
  var body_579165 = newJObject()
  add(query_579164, "key", newJString(key))
  add(query_579164, "prettyPrint", newJBool(prettyPrint))
  add(query_579164, "oauth_token", newJString(oauthToken))
  add(path_579163, "containerId", newJString(containerId))
  add(query_579164, "fingerprint", newJString(fingerprint))
  add(query_579164, "alt", newJString(alt))
  add(query_579164, "userIp", newJString(userIp))
  add(query_579164, "quotaUser", newJString(quotaUser))
  add(path_579163, "folderId", newJString(folderId))
  if body != nil:
    body_579165 = body
  add(path_579163, "accountId", newJString(accountId))
  add(query_579164, "fields", newJString(fields))
  result = call_579162.call(path_579163, query_579164, nil, nil, body_579165)

var tagmanagerAccountsContainersFoldersUpdate* = Call_TagmanagerAccountsContainersFoldersUpdate_579146(
    name: "tagmanagerAccountsContainersFoldersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/folders/{folderId}",
    validator: validate_TagmanagerAccountsContainersFoldersUpdate_579147,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersFoldersUpdate_579148,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersFoldersGet_579129 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersFoldersGet_579131(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersFoldersGet_579130(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a GTM Folder.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   folderId: JString (required)
  ##           : The GTM Folder ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_579132 = path.getOrDefault("containerId")
  valid_579132 = validateParameter(valid_579132, JString, required = true,
                                 default = nil)
  if valid_579132 != nil:
    section.add "containerId", valid_579132
  var valid_579133 = path.getOrDefault("folderId")
  valid_579133 = validateParameter(valid_579133, JString, required = true,
                                 default = nil)
  if valid_579133 != nil:
    section.add "folderId", valid_579133
  var valid_579134 = path.getOrDefault("accountId")
  valid_579134 = validateParameter(valid_579134, JString, required = true,
                                 default = nil)
  if valid_579134 != nil:
    section.add "accountId", valid_579134
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
  var valid_579135 = query.getOrDefault("key")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "key", valid_579135
  var valid_579136 = query.getOrDefault("prettyPrint")
  valid_579136 = validateParameter(valid_579136, JBool, required = false,
                                 default = newJBool(true))
  if valid_579136 != nil:
    section.add "prettyPrint", valid_579136
  var valid_579137 = query.getOrDefault("oauth_token")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "oauth_token", valid_579137
  var valid_579138 = query.getOrDefault("alt")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = newJString("json"))
  if valid_579138 != nil:
    section.add "alt", valid_579138
  var valid_579139 = query.getOrDefault("userIp")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "userIp", valid_579139
  var valid_579140 = query.getOrDefault("quotaUser")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = nil)
  if valid_579140 != nil:
    section.add "quotaUser", valid_579140
  var valid_579141 = query.getOrDefault("fields")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "fields", valid_579141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579142: Call_TagmanagerAccountsContainersFoldersGet_579129;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a GTM Folder.
  ## 
  let valid = call_579142.validator(path, query, header, formData, body)
  let scheme = call_579142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579142.url(scheme.get, call_579142.host, call_579142.base,
                         call_579142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579142, url, valid)

proc call*(call_579143: Call_TagmanagerAccountsContainersFoldersGet_579129;
          containerId: string; folderId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersFoldersGet
  ## Gets a GTM Folder.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   folderId: string (required)
  ##           : The GTM Folder ID.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579144 = newJObject()
  var query_579145 = newJObject()
  add(query_579145, "key", newJString(key))
  add(query_579145, "prettyPrint", newJBool(prettyPrint))
  add(query_579145, "oauth_token", newJString(oauthToken))
  add(path_579144, "containerId", newJString(containerId))
  add(query_579145, "alt", newJString(alt))
  add(query_579145, "userIp", newJString(userIp))
  add(query_579145, "quotaUser", newJString(quotaUser))
  add(path_579144, "folderId", newJString(folderId))
  add(path_579144, "accountId", newJString(accountId))
  add(query_579145, "fields", newJString(fields))
  result = call_579143.call(path_579144, query_579145, nil, nil, nil)

var tagmanagerAccountsContainersFoldersGet* = Call_TagmanagerAccountsContainersFoldersGet_579129(
    name: "tagmanagerAccountsContainersFoldersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/folders/{folderId}",
    validator: validate_TagmanagerAccountsContainersFoldersGet_579130,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersFoldersGet_579131,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersFoldersDelete_579166 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersFoldersDelete_579168(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersFoldersDelete_579167(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a GTM Folder.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   folderId: JString (required)
  ##           : The GTM Folder ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_579169 = path.getOrDefault("containerId")
  valid_579169 = validateParameter(valid_579169, JString, required = true,
                                 default = nil)
  if valid_579169 != nil:
    section.add "containerId", valid_579169
  var valid_579170 = path.getOrDefault("folderId")
  valid_579170 = validateParameter(valid_579170, JString, required = true,
                                 default = nil)
  if valid_579170 != nil:
    section.add "folderId", valid_579170
  var valid_579171 = path.getOrDefault("accountId")
  valid_579171 = validateParameter(valid_579171, JString, required = true,
                                 default = nil)
  if valid_579171 != nil:
    section.add "accountId", valid_579171
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
  var valid_579172 = query.getOrDefault("key")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = nil)
  if valid_579172 != nil:
    section.add "key", valid_579172
  var valid_579173 = query.getOrDefault("prettyPrint")
  valid_579173 = validateParameter(valid_579173, JBool, required = false,
                                 default = newJBool(true))
  if valid_579173 != nil:
    section.add "prettyPrint", valid_579173
  var valid_579174 = query.getOrDefault("oauth_token")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "oauth_token", valid_579174
  var valid_579175 = query.getOrDefault("alt")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = newJString("json"))
  if valid_579175 != nil:
    section.add "alt", valid_579175
  var valid_579176 = query.getOrDefault("userIp")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "userIp", valid_579176
  var valid_579177 = query.getOrDefault("quotaUser")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "quotaUser", valid_579177
  var valid_579178 = query.getOrDefault("fields")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "fields", valid_579178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579179: Call_TagmanagerAccountsContainersFoldersDelete_579166;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a GTM Folder.
  ## 
  let valid = call_579179.validator(path, query, header, formData, body)
  let scheme = call_579179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579179.url(scheme.get, call_579179.host, call_579179.base,
                         call_579179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579179, url, valid)

proc call*(call_579180: Call_TagmanagerAccountsContainersFoldersDelete_579166;
          containerId: string; folderId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersFoldersDelete
  ## Deletes a GTM Folder.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   folderId: string (required)
  ##           : The GTM Folder ID.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579181 = newJObject()
  var query_579182 = newJObject()
  add(query_579182, "key", newJString(key))
  add(query_579182, "prettyPrint", newJBool(prettyPrint))
  add(query_579182, "oauth_token", newJString(oauthToken))
  add(path_579181, "containerId", newJString(containerId))
  add(query_579182, "alt", newJString(alt))
  add(query_579182, "userIp", newJString(userIp))
  add(query_579182, "quotaUser", newJString(quotaUser))
  add(path_579181, "folderId", newJString(folderId))
  add(path_579181, "accountId", newJString(accountId))
  add(query_579182, "fields", newJString(fields))
  result = call_579180.call(path_579181, query_579182, nil, nil, nil)

var tagmanagerAccountsContainersFoldersDelete* = Call_TagmanagerAccountsContainersFoldersDelete_579166(
    name: "tagmanagerAccountsContainersFoldersDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/folders/{folderId}",
    validator: validate_TagmanagerAccountsContainersFoldersDelete_579167,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersFoldersDelete_579168,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersFoldersEntitiesList_579183 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersFoldersEntitiesList_579185(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersFoldersEntitiesList_579184(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List all entities in a GTM Folder.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   folderId: JString (required)
  ##           : The GTM Folder ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_579186 = path.getOrDefault("containerId")
  valid_579186 = validateParameter(valid_579186, JString, required = true,
                                 default = nil)
  if valid_579186 != nil:
    section.add "containerId", valid_579186
  var valid_579187 = path.getOrDefault("folderId")
  valid_579187 = validateParameter(valid_579187, JString, required = true,
                                 default = nil)
  if valid_579187 != nil:
    section.add "folderId", valid_579187
  var valid_579188 = path.getOrDefault("accountId")
  valid_579188 = validateParameter(valid_579188, JString, required = true,
                                 default = nil)
  if valid_579188 != nil:
    section.add "accountId", valid_579188
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
  var valid_579189 = query.getOrDefault("key")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "key", valid_579189
  var valid_579190 = query.getOrDefault("prettyPrint")
  valid_579190 = validateParameter(valid_579190, JBool, required = false,
                                 default = newJBool(true))
  if valid_579190 != nil:
    section.add "prettyPrint", valid_579190
  var valid_579191 = query.getOrDefault("oauth_token")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "oauth_token", valid_579191
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

proc call*(call_579196: Call_TagmanagerAccountsContainersFoldersEntitiesList_579183;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all entities in a GTM Folder.
  ## 
  let valid = call_579196.validator(path, query, header, formData, body)
  let scheme = call_579196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579196.url(scheme.get, call_579196.host, call_579196.base,
                         call_579196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579196, url, valid)

proc call*(call_579197: Call_TagmanagerAccountsContainersFoldersEntitiesList_579183;
          containerId: string; folderId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersFoldersEntitiesList
  ## List all entities in a GTM Folder.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   folderId: string (required)
  ##           : The GTM Folder ID.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579198 = newJObject()
  var query_579199 = newJObject()
  add(query_579199, "key", newJString(key))
  add(query_579199, "prettyPrint", newJBool(prettyPrint))
  add(query_579199, "oauth_token", newJString(oauthToken))
  add(path_579198, "containerId", newJString(containerId))
  add(query_579199, "alt", newJString(alt))
  add(query_579199, "userIp", newJString(userIp))
  add(query_579199, "quotaUser", newJString(quotaUser))
  add(path_579198, "folderId", newJString(folderId))
  add(path_579198, "accountId", newJString(accountId))
  add(query_579199, "fields", newJString(fields))
  result = call_579197.call(path_579198, query_579199, nil, nil, nil)

var tagmanagerAccountsContainersFoldersEntitiesList* = Call_TagmanagerAccountsContainersFoldersEntitiesList_579183(
    name: "tagmanagerAccountsContainersFoldersEntitiesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/folders/{folderId}/entities",
    validator: validate_TagmanagerAccountsContainersFoldersEntitiesList_579184,
    base: "/tagmanager/v1",
    url: url_TagmanagerAccountsContainersFoldersEntitiesList_579185,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersMoveFoldersUpdate_579200 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersMoveFoldersUpdate_579202(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersMoveFoldersUpdate_579201(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Moves entities to a GTM Folder.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   folderId: JString (required)
  ##           : The GTM Folder ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_579203 = path.getOrDefault("containerId")
  valid_579203 = validateParameter(valid_579203, JString, required = true,
                                 default = nil)
  if valid_579203 != nil:
    section.add "containerId", valid_579203
  var valid_579204 = path.getOrDefault("folderId")
  valid_579204 = validateParameter(valid_579204, JString, required = true,
                                 default = nil)
  if valid_579204 != nil:
    section.add "folderId", valid_579204
  var valid_579205 = path.getOrDefault("accountId")
  valid_579205 = validateParameter(valid_579205, JString, required = true,
                                 default = nil)
  if valid_579205 != nil:
    section.add "accountId", valid_579205
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
  ##   triggerId: JArray
  ##            : The triggers to be moved to the folder.
  ##   variableId: JArray
  ##             : The variables to be moved to the folder.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   tagId: JArray
  ##        : The tags to be moved to the folder.
  section = newJObject()
  var valid_579206 = query.getOrDefault("key")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = nil)
  if valid_579206 != nil:
    section.add "key", valid_579206
  var valid_579207 = query.getOrDefault("prettyPrint")
  valid_579207 = validateParameter(valid_579207, JBool, required = false,
                                 default = newJBool(true))
  if valid_579207 != nil:
    section.add "prettyPrint", valid_579207
  var valid_579208 = query.getOrDefault("oauth_token")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = nil)
  if valid_579208 != nil:
    section.add "oauth_token", valid_579208
  var valid_579209 = query.getOrDefault("alt")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = newJString("json"))
  if valid_579209 != nil:
    section.add "alt", valid_579209
  var valid_579210 = query.getOrDefault("userIp")
  valid_579210 = validateParameter(valid_579210, JString, required = false,
                                 default = nil)
  if valid_579210 != nil:
    section.add "userIp", valid_579210
  var valid_579211 = query.getOrDefault("quotaUser")
  valid_579211 = validateParameter(valid_579211, JString, required = false,
                                 default = nil)
  if valid_579211 != nil:
    section.add "quotaUser", valid_579211
  var valid_579212 = query.getOrDefault("triggerId")
  valid_579212 = validateParameter(valid_579212, JArray, required = false,
                                 default = nil)
  if valid_579212 != nil:
    section.add "triggerId", valid_579212
  var valid_579213 = query.getOrDefault("variableId")
  valid_579213 = validateParameter(valid_579213, JArray, required = false,
                                 default = nil)
  if valid_579213 != nil:
    section.add "variableId", valid_579213
  var valid_579214 = query.getOrDefault("fields")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = nil)
  if valid_579214 != nil:
    section.add "fields", valid_579214
  var valid_579215 = query.getOrDefault("tagId")
  valid_579215 = validateParameter(valid_579215, JArray, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "tagId", valid_579215
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

proc call*(call_579217: Call_TagmanagerAccountsContainersMoveFoldersUpdate_579200;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Moves entities to a GTM Folder.
  ## 
  let valid = call_579217.validator(path, query, header, formData, body)
  let scheme = call_579217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579217.url(scheme.get, call_579217.host, call_579217.base,
                         call_579217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579217, url, valid)

proc call*(call_579218: Call_TagmanagerAccountsContainersMoveFoldersUpdate_579200;
          containerId: string; folderId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; triggerId: JsonNode = nil;
          body: JsonNode = nil; variableId: JsonNode = nil; fields: string = "";
          tagId: JsonNode = nil): Recallable =
  ## tagmanagerAccountsContainersMoveFoldersUpdate
  ## Moves entities to a GTM Folder.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   triggerId: JArray
  ##            : The triggers to be moved to the folder.
  ##   folderId: string (required)
  ##           : The GTM Folder ID.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   variableId: JArray
  ##             : The variables to be moved to the folder.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   tagId: JArray
  ##        : The tags to be moved to the folder.
  var path_579219 = newJObject()
  var query_579220 = newJObject()
  var body_579221 = newJObject()
  add(query_579220, "key", newJString(key))
  add(query_579220, "prettyPrint", newJBool(prettyPrint))
  add(query_579220, "oauth_token", newJString(oauthToken))
  add(path_579219, "containerId", newJString(containerId))
  add(query_579220, "alt", newJString(alt))
  add(query_579220, "userIp", newJString(userIp))
  add(query_579220, "quotaUser", newJString(quotaUser))
  if triggerId != nil:
    query_579220.add "triggerId", triggerId
  add(path_579219, "folderId", newJString(folderId))
  if body != nil:
    body_579221 = body
  add(path_579219, "accountId", newJString(accountId))
  if variableId != nil:
    query_579220.add "variableId", variableId
  add(query_579220, "fields", newJString(fields))
  if tagId != nil:
    query_579220.add "tagId", tagId
  result = call_579218.call(path_579219, query_579220, nil, nil, body_579221)

var tagmanagerAccountsContainersMoveFoldersUpdate* = Call_TagmanagerAccountsContainersMoveFoldersUpdate_579200(
    name: "tagmanagerAccountsContainersMoveFoldersUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/move_folders/{folderId}",
    validator: validate_TagmanagerAccountsContainersMoveFoldersUpdate_579201,
    base: "/tagmanager/v1",
    url: url_TagmanagerAccountsContainersMoveFoldersUpdate_579202,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_579222 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_579224(
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

proc validate_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_579223(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Re-generates the authorization code for a GTM Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   environmentId: JString (required)
  ##                : The GTM Environment ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_579225 = path.getOrDefault("containerId")
  valid_579225 = validateParameter(valid_579225, JString, required = true,
                                 default = nil)
  if valid_579225 != nil:
    section.add "containerId", valid_579225
  var valid_579226 = path.getOrDefault("environmentId")
  valid_579226 = validateParameter(valid_579226, JString, required = true,
                                 default = nil)
  if valid_579226 != nil:
    section.add "environmentId", valid_579226
  var valid_579227 = path.getOrDefault("accountId")
  valid_579227 = validateParameter(valid_579227, JString, required = true,
                                 default = nil)
  if valid_579227 != nil:
    section.add "accountId", valid_579227
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
  var valid_579228 = query.getOrDefault("key")
  valid_579228 = validateParameter(valid_579228, JString, required = false,
                                 default = nil)
  if valid_579228 != nil:
    section.add "key", valid_579228
  var valid_579229 = query.getOrDefault("prettyPrint")
  valid_579229 = validateParameter(valid_579229, JBool, required = false,
                                 default = newJBool(true))
  if valid_579229 != nil:
    section.add "prettyPrint", valid_579229
  var valid_579230 = query.getOrDefault("oauth_token")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = nil)
  if valid_579230 != nil:
    section.add "oauth_token", valid_579230
  var valid_579231 = query.getOrDefault("alt")
  valid_579231 = validateParameter(valid_579231, JString, required = false,
                                 default = newJString("json"))
  if valid_579231 != nil:
    section.add "alt", valid_579231
  var valid_579232 = query.getOrDefault("userIp")
  valid_579232 = validateParameter(valid_579232, JString, required = false,
                                 default = nil)
  if valid_579232 != nil:
    section.add "userIp", valid_579232
  var valid_579233 = query.getOrDefault("quotaUser")
  valid_579233 = validateParameter(valid_579233, JString, required = false,
                                 default = nil)
  if valid_579233 != nil:
    section.add "quotaUser", valid_579233
  var valid_579234 = query.getOrDefault("fields")
  valid_579234 = validateParameter(valid_579234, JString, required = false,
                                 default = nil)
  if valid_579234 != nil:
    section.add "fields", valid_579234
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

proc call*(call_579236: Call_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_579222;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Re-generates the authorization code for a GTM Environment.
  ## 
  let valid = call_579236.validator(path, query, header, formData, body)
  let scheme = call_579236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579236.url(scheme.get, call_579236.host, call_579236.base,
                         call_579236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579236, url, valid)

proc call*(call_579237: Call_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_579222;
          containerId: string; environmentId: string; accountId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersReauthorizeEnvironmentsUpdate
  ## Re-generates the authorization code for a GTM Environment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   environmentId: string (required)
  ##                : The GTM Environment ID.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579238 = newJObject()
  var query_579239 = newJObject()
  var body_579240 = newJObject()
  add(query_579239, "key", newJString(key))
  add(query_579239, "prettyPrint", newJBool(prettyPrint))
  add(query_579239, "oauth_token", newJString(oauthToken))
  add(path_579238, "containerId", newJString(containerId))
  add(query_579239, "alt", newJString(alt))
  add(query_579239, "userIp", newJString(userIp))
  add(query_579239, "quotaUser", newJString(quotaUser))
  add(path_579238, "environmentId", newJString(environmentId))
  if body != nil:
    body_579240 = body
  add(path_579238, "accountId", newJString(accountId))
  add(query_579239, "fields", newJString(fields))
  result = call_579237.call(path_579238, query_579239, nil, nil, body_579240)

var tagmanagerAccountsContainersReauthorizeEnvironmentsUpdate* = Call_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_579222(
    name: "tagmanagerAccountsContainersReauthorizeEnvironmentsUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/reauthorize_environments/{environmentId}", validator: validate_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_579223,
    base: "/tagmanager/v1",
    url: url_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_579224,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTagsCreate_579257 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersTagsCreate_579259(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersTagsCreate_579258(path: JsonNode;
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
  var valid_579260 = path.getOrDefault("containerId")
  valid_579260 = validateParameter(valid_579260, JString, required = true,
                                 default = nil)
  if valid_579260 != nil:
    section.add "containerId", valid_579260
  var valid_579261 = path.getOrDefault("accountId")
  valid_579261 = validateParameter(valid_579261, JString, required = true,
                                 default = nil)
  if valid_579261 != nil:
    section.add "accountId", valid_579261
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
  var valid_579262 = query.getOrDefault("key")
  valid_579262 = validateParameter(valid_579262, JString, required = false,
                                 default = nil)
  if valid_579262 != nil:
    section.add "key", valid_579262
  var valid_579263 = query.getOrDefault("prettyPrint")
  valid_579263 = validateParameter(valid_579263, JBool, required = false,
                                 default = newJBool(true))
  if valid_579263 != nil:
    section.add "prettyPrint", valid_579263
  var valid_579264 = query.getOrDefault("oauth_token")
  valid_579264 = validateParameter(valid_579264, JString, required = false,
                                 default = nil)
  if valid_579264 != nil:
    section.add "oauth_token", valid_579264
  var valid_579265 = query.getOrDefault("alt")
  valid_579265 = validateParameter(valid_579265, JString, required = false,
                                 default = newJString("json"))
  if valid_579265 != nil:
    section.add "alt", valid_579265
  var valid_579266 = query.getOrDefault("userIp")
  valid_579266 = validateParameter(valid_579266, JString, required = false,
                                 default = nil)
  if valid_579266 != nil:
    section.add "userIp", valid_579266
  var valid_579267 = query.getOrDefault("quotaUser")
  valid_579267 = validateParameter(valid_579267, JString, required = false,
                                 default = nil)
  if valid_579267 != nil:
    section.add "quotaUser", valid_579267
  var valid_579268 = query.getOrDefault("fields")
  valid_579268 = validateParameter(valid_579268, JString, required = false,
                                 default = nil)
  if valid_579268 != nil:
    section.add "fields", valid_579268
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

proc call*(call_579270: Call_TagmanagerAccountsContainersTagsCreate_579257;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a GTM Tag.
  ## 
  let valid = call_579270.validator(path, query, header, formData, body)
  let scheme = call_579270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579270.url(scheme.get, call_579270.host, call_579270.base,
                         call_579270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579270, url, valid)

proc call*(call_579271: Call_TagmanagerAccountsContainersTagsCreate_579257;
          containerId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersTagsCreate
  ## Creates a GTM Tag.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579272 = newJObject()
  var query_579273 = newJObject()
  var body_579274 = newJObject()
  add(query_579273, "key", newJString(key))
  add(query_579273, "prettyPrint", newJBool(prettyPrint))
  add(query_579273, "oauth_token", newJString(oauthToken))
  add(path_579272, "containerId", newJString(containerId))
  add(query_579273, "alt", newJString(alt))
  add(query_579273, "userIp", newJString(userIp))
  add(query_579273, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579274 = body
  add(path_579272, "accountId", newJString(accountId))
  add(query_579273, "fields", newJString(fields))
  result = call_579271.call(path_579272, query_579273, nil, nil, body_579274)

var tagmanagerAccountsContainersTagsCreate* = Call_TagmanagerAccountsContainersTagsCreate_579257(
    name: "tagmanagerAccountsContainersTagsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/tags",
    validator: validate_TagmanagerAccountsContainersTagsCreate_579258,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTagsCreate_579259,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTagsList_579241 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersTagsList_579243(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersTagsList_579242(path: JsonNode;
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
  var valid_579244 = path.getOrDefault("containerId")
  valid_579244 = validateParameter(valid_579244, JString, required = true,
                                 default = nil)
  if valid_579244 != nil:
    section.add "containerId", valid_579244
  var valid_579245 = path.getOrDefault("accountId")
  valid_579245 = validateParameter(valid_579245, JString, required = true,
                                 default = nil)
  if valid_579245 != nil:
    section.add "accountId", valid_579245
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
  var valid_579246 = query.getOrDefault("key")
  valid_579246 = validateParameter(valid_579246, JString, required = false,
                                 default = nil)
  if valid_579246 != nil:
    section.add "key", valid_579246
  var valid_579247 = query.getOrDefault("prettyPrint")
  valid_579247 = validateParameter(valid_579247, JBool, required = false,
                                 default = newJBool(true))
  if valid_579247 != nil:
    section.add "prettyPrint", valid_579247
  var valid_579248 = query.getOrDefault("oauth_token")
  valid_579248 = validateParameter(valid_579248, JString, required = false,
                                 default = nil)
  if valid_579248 != nil:
    section.add "oauth_token", valid_579248
  var valid_579249 = query.getOrDefault("alt")
  valid_579249 = validateParameter(valid_579249, JString, required = false,
                                 default = newJString("json"))
  if valid_579249 != nil:
    section.add "alt", valid_579249
  var valid_579250 = query.getOrDefault("userIp")
  valid_579250 = validateParameter(valid_579250, JString, required = false,
                                 default = nil)
  if valid_579250 != nil:
    section.add "userIp", valid_579250
  var valid_579251 = query.getOrDefault("quotaUser")
  valid_579251 = validateParameter(valid_579251, JString, required = false,
                                 default = nil)
  if valid_579251 != nil:
    section.add "quotaUser", valid_579251
  var valid_579252 = query.getOrDefault("fields")
  valid_579252 = validateParameter(valid_579252, JString, required = false,
                                 default = nil)
  if valid_579252 != nil:
    section.add "fields", valid_579252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579253: Call_TagmanagerAccountsContainersTagsList_579241;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all GTM Tags of a Container.
  ## 
  let valid = call_579253.validator(path, query, header, formData, body)
  let scheme = call_579253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579253.url(scheme.get, call_579253.host, call_579253.base,
                         call_579253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579253, url, valid)

proc call*(call_579254: Call_TagmanagerAccountsContainersTagsList_579241;
          containerId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersTagsList
  ## Lists all GTM Tags of a Container.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579255 = newJObject()
  var query_579256 = newJObject()
  add(query_579256, "key", newJString(key))
  add(query_579256, "prettyPrint", newJBool(prettyPrint))
  add(query_579256, "oauth_token", newJString(oauthToken))
  add(path_579255, "containerId", newJString(containerId))
  add(query_579256, "alt", newJString(alt))
  add(query_579256, "userIp", newJString(userIp))
  add(query_579256, "quotaUser", newJString(quotaUser))
  add(path_579255, "accountId", newJString(accountId))
  add(query_579256, "fields", newJString(fields))
  result = call_579254.call(path_579255, query_579256, nil, nil, nil)

var tagmanagerAccountsContainersTagsList* = Call_TagmanagerAccountsContainersTagsList_579241(
    name: "tagmanagerAccountsContainersTagsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/tags",
    validator: validate_TagmanagerAccountsContainersTagsList_579242,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTagsList_579243,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTagsUpdate_579292 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersTagsUpdate_579294(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersTagsUpdate_579293(path: JsonNode;
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
  var valid_579295 = path.getOrDefault("containerId")
  valid_579295 = validateParameter(valid_579295, JString, required = true,
                                 default = nil)
  if valid_579295 != nil:
    section.add "containerId", valid_579295
  var valid_579296 = path.getOrDefault("tagId")
  valid_579296 = validateParameter(valid_579296, JString, required = true,
                                 default = nil)
  if valid_579296 != nil:
    section.add "tagId", valid_579296
  var valid_579297 = path.getOrDefault("accountId")
  valid_579297 = validateParameter(valid_579297, JString, required = true,
                                 default = nil)
  if valid_579297 != nil:
    section.add "accountId", valid_579297
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fingerprint: JString
  ##              : When provided, this fingerprint must match the fingerprint of the tag in storage.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579298 = query.getOrDefault("key")
  valid_579298 = validateParameter(valid_579298, JString, required = false,
                                 default = nil)
  if valid_579298 != nil:
    section.add "key", valid_579298
  var valid_579299 = query.getOrDefault("prettyPrint")
  valid_579299 = validateParameter(valid_579299, JBool, required = false,
                                 default = newJBool(true))
  if valid_579299 != nil:
    section.add "prettyPrint", valid_579299
  var valid_579300 = query.getOrDefault("oauth_token")
  valid_579300 = validateParameter(valid_579300, JString, required = false,
                                 default = nil)
  if valid_579300 != nil:
    section.add "oauth_token", valid_579300
  var valid_579301 = query.getOrDefault("fingerprint")
  valid_579301 = validateParameter(valid_579301, JString, required = false,
                                 default = nil)
  if valid_579301 != nil:
    section.add "fingerprint", valid_579301
  var valid_579302 = query.getOrDefault("alt")
  valid_579302 = validateParameter(valid_579302, JString, required = false,
                                 default = newJString("json"))
  if valid_579302 != nil:
    section.add "alt", valid_579302
  var valid_579303 = query.getOrDefault("userIp")
  valid_579303 = validateParameter(valid_579303, JString, required = false,
                                 default = nil)
  if valid_579303 != nil:
    section.add "userIp", valid_579303
  var valid_579304 = query.getOrDefault("quotaUser")
  valid_579304 = validateParameter(valid_579304, JString, required = false,
                                 default = nil)
  if valid_579304 != nil:
    section.add "quotaUser", valid_579304
  var valid_579305 = query.getOrDefault("fields")
  valid_579305 = validateParameter(valid_579305, JString, required = false,
                                 default = nil)
  if valid_579305 != nil:
    section.add "fields", valid_579305
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

proc call*(call_579307: Call_TagmanagerAccountsContainersTagsUpdate_579292;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a GTM Tag.
  ## 
  let valid = call_579307.validator(path, query, header, formData, body)
  let scheme = call_579307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579307.url(scheme.get, call_579307.host, call_579307.base,
                         call_579307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579307, url, valid)

proc call*(call_579308: Call_TagmanagerAccountsContainersTagsUpdate_579292;
          containerId: string; tagId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; fingerprint: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersTagsUpdate
  ## Updates a GTM Tag.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fingerprint: string
  ##              : When provided, this fingerprint must match the fingerprint of the tag in storage.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   tagId: string (required)
  ##        : The GTM Tag ID.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579309 = newJObject()
  var query_579310 = newJObject()
  var body_579311 = newJObject()
  add(query_579310, "key", newJString(key))
  add(query_579310, "prettyPrint", newJBool(prettyPrint))
  add(query_579310, "oauth_token", newJString(oauthToken))
  add(path_579309, "containerId", newJString(containerId))
  add(query_579310, "fingerprint", newJString(fingerprint))
  add(query_579310, "alt", newJString(alt))
  add(query_579310, "userIp", newJString(userIp))
  add(path_579309, "tagId", newJString(tagId))
  add(query_579310, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579311 = body
  add(path_579309, "accountId", newJString(accountId))
  add(query_579310, "fields", newJString(fields))
  result = call_579308.call(path_579309, query_579310, nil, nil, body_579311)

var tagmanagerAccountsContainersTagsUpdate* = Call_TagmanagerAccountsContainersTagsUpdate_579292(
    name: "tagmanagerAccountsContainersTagsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/tags/{tagId}",
    validator: validate_TagmanagerAccountsContainersTagsUpdate_579293,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTagsUpdate_579294,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTagsGet_579275 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersTagsGet_579277(protocol: Scheme; host: string;
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

proc validate_TagmanagerAccountsContainersTagsGet_579276(path: JsonNode;
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
  var valid_579278 = path.getOrDefault("containerId")
  valid_579278 = validateParameter(valid_579278, JString, required = true,
                                 default = nil)
  if valid_579278 != nil:
    section.add "containerId", valid_579278
  var valid_579279 = path.getOrDefault("tagId")
  valid_579279 = validateParameter(valid_579279, JString, required = true,
                                 default = nil)
  if valid_579279 != nil:
    section.add "tagId", valid_579279
  var valid_579280 = path.getOrDefault("accountId")
  valid_579280 = validateParameter(valid_579280, JString, required = true,
                                 default = nil)
  if valid_579280 != nil:
    section.add "accountId", valid_579280
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
  var valid_579281 = query.getOrDefault("key")
  valid_579281 = validateParameter(valid_579281, JString, required = false,
                                 default = nil)
  if valid_579281 != nil:
    section.add "key", valid_579281
  var valid_579282 = query.getOrDefault("prettyPrint")
  valid_579282 = validateParameter(valid_579282, JBool, required = false,
                                 default = newJBool(true))
  if valid_579282 != nil:
    section.add "prettyPrint", valid_579282
  var valid_579283 = query.getOrDefault("oauth_token")
  valid_579283 = validateParameter(valid_579283, JString, required = false,
                                 default = nil)
  if valid_579283 != nil:
    section.add "oauth_token", valid_579283
  var valid_579284 = query.getOrDefault("alt")
  valid_579284 = validateParameter(valid_579284, JString, required = false,
                                 default = newJString("json"))
  if valid_579284 != nil:
    section.add "alt", valid_579284
  var valid_579285 = query.getOrDefault("userIp")
  valid_579285 = validateParameter(valid_579285, JString, required = false,
                                 default = nil)
  if valid_579285 != nil:
    section.add "userIp", valid_579285
  var valid_579286 = query.getOrDefault("quotaUser")
  valid_579286 = validateParameter(valid_579286, JString, required = false,
                                 default = nil)
  if valid_579286 != nil:
    section.add "quotaUser", valid_579286
  var valid_579287 = query.getOrDefault("fields")
  valid_579287 = validateParameter(valid_579287, JString, required = false,
                                 default = nil)
  if valid_579287 != nil:
    section.add "fields", valid_579287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579288: Call_TagmanagerAccountsContainersTagsGet_579275;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a GTM Tag.
  ## 
  let valid = call_579288.validator(path, query, header, formData, body)
  let scheme = call_579288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579288.url(scheme.get, call_579288.host, call_579288.base,
                         call_579288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579288, url, valid)

proc call*(call_579289: Call_TagmanagerAccountsContainersTagsGet_579275;
          containerId: string; tagId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersTagsGet
  ## Gets a GTM Tag.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   tagId: string (required)
  ##        : The GTM Tag ID.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579290 = newJObject()
  var query_579291 = newJObject()
  add(query_579291, "key", newJString(key))
  add(query_579291, "prettyPrint", newJBool(prettyPrint))
  add(query_579291, "oauth_token", newJString(oauthToken))
  add(path_579290, "containerId", newJString(containerId))
  add(query_579291, "alt", newJString(alt))
  add(query_579291, "userIp", newJString(userIp))
  add(path_579290, "tagId", newJString(tagId))
  add(query_579291, "quotaUser", newJString(quotaUser))
  add(path_579290, "accountId", newJString(accountId))
  add(query_579291, "fields", newJString(fields))
  result = call_579289.call(path_579290, query_579291, nil, nil, nil)

var tagmanagerAccountsContainersTagsGet* = Call_TagmanagerAccountsContainersTagsGet_579275(
    name: "tagmanagerAccountsContainersTagsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/tags/{tagId}",
    validator: validate_TagmanagerAccountsContainersTagsGet_579276,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTagsGet_579277,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTagsDelete_579312 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersTagsDelete_579314(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersTagsDelete_579313(path: JsonNode;
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
  var valid_579315 = path.getOrDefault("containerId")
  valid_579315 = validateParameter(valid_579315, JString, required = true,
                                 default = nil)
  if valid_579315 != nil:
    section.add "containerId", valid_579315
  var valid_579316 = path.getOrDefault("tagId")
  valid_579316 = validateParameter(valid_579316, JString, required = true,
                                 default = nil)
  if valid_579316 != nil:
    section.add "tagId", valid_579316
  var valid_579317 = path.getOrDefault("accountId")
  valid_579317 = validateParameter(valid_579317, JString, required = true,
                                 default = nil)
  if valid_579317 != nil:
    section.add "accountId", valid_579317
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
  var valid_579318 = query.getOrDefault("key")
  valid_579318 = validateParameter(valid_579318, JString, required = false,
                                 default = nil)
  if valid_579318 != nil:
    section.add "key", valid_579318
  var valid_579319 = query.getOrDefault("prettyPrint")
  valid_579319 = validateParameter(valid_579319, JBool, required = false,
                                 default = newJBool(true))
  if valid_579319 != nil:
    section.add "prettyPrint", valid_579319
  var valid_579320 = query.getOrDefault("oauth_token")
  valid_579320 = validateParameter(valid_579320, JString, required = false,
                                 default = nil)
  if valid_579320 != nil:
    section.add "oauth_token", valid_579320
  var valid_579321 = query.getOrDefault("alt")
  valid_579321 = validateParameter(valid_579321, JString, required = false,
                                 default = newJString("json"))
  if valid_579321 != nil:
    section.add "alt", valid_579321
  var valid_579322 = query.getOrDefault("userIp")
  valid_579322 = validateParameter(valid_579322, JString, required = false,
                                 default = nil)
  if valid_579322 != nil:
    section.add "userIp", valid_579322
  var valid_579323 = query.getOrDefault("quotaUser")
  valid_579323 = validateParameter(valid_579323, JString, required = false,
                                 default = nil)
  if valid_579323 != nil:
    section.add "quotaUser", valid_579323
  var valid_579324 = query.getOrDefault("fields")
  valid_579324 = validateParameter(valid_579324, JString, required = false,
                                 default = nil)
  if valid_579324 != nil:
    section.add "fields", valid_579324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579325: Call_TagmanagerAccountsContainersTagsDelete_579312;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a GTM Tag.
  ## 
  let valid = call_579325.validator(path, query, header, formData, body)
  let scheme = call_579325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579325.url(scheme.get, call_579325.host, call_579325.base,
                         call_579325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579325, url, valid)

proc call*(call_579326: Call_TagmanagerAccountsContainersTagsDelete_579312;
          containerId: string; tagId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersTagsDelete
  ## Deletes a GTM Tag.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   tagId: string (required)
  ##        : The GTM Tag ID.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579327 = newJObject()
  var query_579328 = newJObject()
  add(query_579328, "key", newJString(key))
  add(query_579328, "prettyPrint", newJBool(prettyPrint))
  add(query_579328, "oauth_token", newJString(oauthToken))
  add(path_579327, "containerId", newJString(containerId))
  add(query_579328, "alt", newJString(alt))
  add(query_579328, "userIp", newJString(userIp))
  add(path_579327, "tagId", newJString(tagId))
  add(query_579328, "quotaUser", newJString(quotaUser))
  add(path_579327, "accountId", newJString(accountId))
  add(query_579328, "fields", newJString(fields))
  result = call_579326.call(path_579327, query_579328, nil, nil, nil)

var tagmanagerAccountsContainersTagsDelete* = Call_TagmanagerAccountsContainersTagsDelete_579312(
    name: "tagmanagerAccountsContainersTagsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/tags/{tagId}",
    validator: validate_TagmanagerAccountsContainersTagsDelete_579313,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTagsDelete_579314,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTriggersCreate_579345 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersTriggersCreate_579347(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersTriggersCreate_579346(path: JsonNode;
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
  var valid_579348 = path.getOrDefault("containerId")
  valid_579348 = validateParameter(valid_579348, JString, required = true,
                                 default = nil)
  if valid_579348 != nil:
    section.add "containerId", valid_579348
  var valid_579349 = path.getOrDefault("accountId")
  valid_579349 = validateParameter(valid_579349, JString, required = true,
                                 default = nil)
  if valid_579349 != nil:
    section.add "accountId", valid_579349
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
  var valid_579350 = query.getOrDefault("key")
  valid_579350 = validateParameter(valid_579350, JString, required = false,
                                 default = nil)
  if valid_579350 != nil:
    section.add "key", valid_579350
  var valid_579351 = query.getOrDefault("prettyPrint")
  valid_579351 = validateParameter(valid_579351, JBool, required = false,
                                 default = newJBool(true))
  if valid_579351 != nil:
    section.add "prettyPrint", valid_579351
  var valid_579352 = query.getOrDefault("oauth_token")
  valid_579352 = validateParameter(valid_579352, JString, required = false,
                                 default = nil)
  if valid_579352 != nil:
    section.add "oauth_token", valid_579352
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

proc call*(call_579358: Call_TagmanagerAccountsContainersTriggersCreate_579345;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a GTM Trigger.
  ## 
  let valid = call_579358.validator(path, query, header, formData, body)
  let scheme = call_579358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579358.url(scheme.get, call_579358.host, call_579358.base,
                         call_579358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579358, url, valid)

proc call*(call_579359: Call_TagmanagerAccountsContainersTriggersCreate_579345;
          containerId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersTriggersCreate
  ## Creates a GTM Trigger.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579360 = newJObject()
  var query_579361 = newJObject()
  var body_579362 = newJObject()
  add(query_579361, "key", newJString(key))
  add(query_579361, "prettyPrint", newJBool(prettyPrint))
  add(query_579361, "oauth_token", newJString(oauthToken))
  add(path_579360, "containerId", newJString(containerId))
  add(query_579361, "alt", newJString(alt))
  add(query_579361, "userIp", newJString(userIp))
  add(query_579361, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579362 = body
  add(path_579360, "accountId", newJString(accountId))
  add(query_579361, "fields", newJString(fields))
  result = call_579359.call(path_579360, query_579361, nil, nil, body_579362)

var tagmanagerAccountsContainersTriggersCreate* = Call_TagmanagerAccountsContainersTriggersCreate_579345(
    name: "tagmanagerAccountsContainersTriggersCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/triggers",
    validator: validate_TagmanagerAccountsContainersTriggersCreate_579346,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTriggersCreate_579347,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTriggersList_579329 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersTriggersList_579331(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersTriggersList_579330(path: JsonNode;
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
  var valid_579332 = path.getOrDefault("containerId")
  valid_579332 = validateParameter(valid_579332, JString, required = true,
                                 default = nil)
  if valid_579332 != nil:
    section.add "containerId", valid_579332
  var valid_579333 = path.getOrDefault("accountId")
  valid_579333 = validateParameter(valid_579333, JString, required = true,
                                 default = nil)
  if valid_579333 != nil:
    section.add "accountId", valid_579333
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
  var valid_579334 = query.getOrDefault("key")
  valid_579334 = validateParameter(valid_579334, JString, required = false,
                                 default = nil)
  if valid_579334 != nil:
    section.add "key", valid_579334
  var valid_579335 = query.getOrDefault("prettyPrint")
  valid_579335 = validateParameter(valid_579335, JBool, required = false,
                                 default = newJBool(true))
  if valid_579335 != nil:
    section.add "prettyPrint", valid_579335
  var valid_579336 = query.getOrDefault("oauth_token")
  valid_579336 = validateParameter(valid_579336, JString, required = false,
                                 default = nil)
  if valid_579336 != nil:
    section.add "oauth_token", valid_579336
  var valid_579337 = query.getOrDefault("alt")
  valid_579337 = validateParameter(valid_579337, JString, required = false,
                                 default = newJString("json"))
  if valid_579337 != nil:
    section.add "alt", valid_579337
  var valid_579338 = query.getOrDefault("userIp")
  valid_579338 = validateParameter(valid_579338, JString, required = false,
                                 default = nil)
  if valid_579338 != nil:
    section.add "userIp", valid_579338
  var valid_579339 = query.getOrDefault("quotaUser")
  valid_579339 = validateParameter(valid_579339, JString, required = false,
                                 default = nil)
  if valid_579339 != nil:
    section.add "quotaUser", valid_579339
  var valid_579340 = query.getOrDefault("fields")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = nil)
  if valid_579340 != nil:
    section.add "fields", valid_579340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579341: Call_TagmanagerAccountsContainersTriggersList_579329;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all GTM Triggers of a Container.
  ## 
  let valid = call_579341.validator(path, query, header, formData, body)
  let scheme = call_579341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579341.url(scheme.get, call_579341.host, call_579341.base,
                         call_579341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579341, url, valid)

proc call*(call_579342: Call_TagmanagerAccountsContainersTriggersList_579329;
          containerId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersTriggersList
  ## Lists all GTM Triggers of a Container.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579343 = newJObject()
  var query_579344 = newJObject()
  add(query_579344, "key", newJString(key))
  add(query_579344, "prettyPrint", newJBool(prettyPrint))
  add(query_579344, "oauth_token", newJString(oauthToken))
  add(path_579343, "containerId", newJString(containerId))
  add(query_579344, "alt", newJString(alt))
  add(query_579344, "userIp", newJString(userIp))
  add(query_579344, "quotaUser", newJString(quotaUser))
  add(path_579343, "accountId", newJString(accountId))
  add(query_579344, "fields", newJString(fields))
  result = call_579342.call(path_579343, query_579344, nil, nil, nil)

var tagmanagerAccountsContainersTriggersList* = Call_TagmanagerAccountsContainersTriggersList_579329(
    name: "tagmanagerAccountsContainersTriggersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/triggers",
    validator: validate_TagmanagerAccountsContainersTriggersList_579330,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTriggersList_579331,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTriggersUpdate_579380 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersTriggersUpdate_579382(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersTriggersUpdate_579381(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a GTM Trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   triggerId: JString (required)
  ##            : The GTM Trigger ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_579383 = path.getOrDefault("containerId")
  valid_579383 = validateParameter(valid_579383, JString, required = true,
                                 default = nil)
  if valid_579383 != nil:
    section.add "containerId", valid_579383
  var valid_579384 = path.getOrDefault("triggerId")
  valid_579384 = validateParameter(valid_579384, JString, required = true,
                                 default = nil)
  if valid_579384 != nil:
    section.add "triggerId", valid_579384
  var valid_579385 = path.getOrDefault("accountId")
  valid_579385 = validateParameter(valid_579385, JString, required = true,
                                 default = nil)
  if valid_579385 != nil:
    section.add "accountId", valid_579385
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fingerprint: JString
  ##              : When provided, this fingerprint must match the fingerprint of the trigger in storage.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579386 = query.getOrDefault("key")
  valid_579386 = validateParameter(valid_579386, JString, required = false,
                                 default = nil)
  if valid_579386 != nil:
    section.add "key", valid_579386
  var valid_579387 = query.getOrDefault("prettyPrint")
  valid_579387 = validateParameter(valid_579387, JBool, required = false,
                                 default = newJBool(true))
  if valid_579387 != nil:
    section.add "prettyPrint", valid_579387
  var valid_579388 = query.getOrDefault("oauth_token")
  valid_579388 = validateParameter(valid_579388, JString, required = false,
                                 default = nil)
  if valid_579388 != nil:
    section.add "oauth_token", valid_579388
  var valid_579389 = query.getOrDefault("fingerprint")
  valid_579389 = validateParameter(valid_579389, JString, required = false,
                                 default = nil)
  if valid_579389 != nil:
    section.add "fingerprint", valid_579389
  var valid_579390 = query.getOrDefault("alt")
  valid_579390 = validateParameter(valid_579390, JString, required = false,
                                 default = newJString("json"))
  if valid_579390 != nil:
    section.add "alt", valid_579390
  var valid_579391 = query.getOrDefault("userIp")
  valid_579391 = validateParameter(valid_579391, JString, required = false,
                                 default = nil)
  if valid_579391 != nil:
    section.add "userIp", valid_579391
  var valid_579392 = query.getOrDefault("quotaUser")
  valid_579392 = validateParameter(valid_579392, JString, required = false,
                                 default = nil)
  if valid_579392 != nil:
    section.add "quotaUser", valid_579392
  var valid_579393 = query.getOrDefault("fields")
  valid_579393 = validateParameter(valid_579393, JString, required = false,
                                 default = nil)
  if valid_579393 != nil:
    section.add "fields", valid_579393
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

proc call*(call_579395: Call_TagmanagerAccountsContainersTriggersUpdate_579380;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a GTM Trigger.
  ## 
  let valid = call_579395.validator(path, query, header, formData, body)
  let scheme = call_579395.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579395.url(scheme.get, call_579395.host, call_579395.base,
                         call_579395.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579395, url, valid)

proc call*(call_579396: Call_TagmanagerAccountsContainersTriggersUpdate_579380;
          containerId: string; triggerId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; fingerprint: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersTriggersUpdate
  ## Updates a GTM Trigger.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fingerprint: string
  ##              : When provided, this fingerprint must match the fingerprint of the trigger in storage.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   triggerId: string (required)
  ##            : The GTM Trigger ID.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579397 = newJObject()
  var query_579398 = newJObject()
  var body_579399 = newJObject()
  add(query_579398, "key", newJString(key))
  add(query_579398, "prettyPrint", newJBool(prettyPrint))
  add(query_579398, "oauth_token", newJString(oauthToken))
  add(path_579397, "containerId", newJString(containerId))
  add(query_579398, "fingerprint", newJString(fingerprint))
  add(query_579398, "alt", newJString(alt))
  add(query_579398, "userIp", newJString(userIp))
  add(query_579398, "quotaUser", newJString(quotaUser))
  add(path_579397, "triggerId", newJString(triggerId))
  if body != nil:
    body_579399 = body
  add(path_579397, "accountId", newJString(accountId))
  add(query_579398, "fields", newJString(fields))
  result = call_579396.call(path_579397, query_579398, nil, nil, body_579399)

var tagmanagerAccountsContainersTriggersUpdate* = Call_TagmanagerAccountsContainersTriggersUpdate_579380(
    name: "tagmanagerAccountsContainersTriggersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/triggers/{triggerId}",
    validator: validate_TagmanagerAccountsContainersTriggersUpdate_579381,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTriggersUpdate_579382,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTriggersGet_579363 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersTriggersGet_579365(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersTriggersGet_579364(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a GTM Trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   triggerId: JString (required)
  ##            : The GTM Trigger ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_579366 = path.getOrDefault("containerId")
  valid_579366 = validateParameter(valid_579366, JString, required = true,
                                 default = nil)
  if valid_579366 != nil:
    section.add "containerId", valid_579366
  var valid_579367 = path.getOrDefault("triggerId")
  valid_579367 = validateParameter(valid_579367, JString, required = true,
                                 default = nil)
  if valid_579367 != nil:
    section.add "triggerId", valid_579367
  var valid_579368 = path.getOrDefault("accountId")
  valid_579368 = validateParameter(valid_579368, JString, required = true,
                                 default = nil)
  if valid_579368 != nil:
    section.add "accountId", valid_579368
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
  var valid_579369 = query.getOrDefault("key")
  valid_579369 = validateParameter(valid_579369, JString, required = false,
                                 default = nil)
  if valid_579369 != nil:
    section.add "key", valid_579369
  var valid_579370 = query.getOrDefault("prettyPrint")
  valid_579370 = validateParameter(valid_579370, JBool, required = false,
                                 default = newJBool(true))
  if valid_579370 != nil:
    section.add "prettyPrint", valid_579370
  var valid_579371 = query.getOrDefault("oauth_token")
  valid_579371 = validateParameter(valid_579371, JString, required = false,
                                 default = nil)
  if valid_579371 != nil:
    section.add "oauth_token", valid_579371
  var valid_579372 = query.getOrDefault("alt")
  valid_579372 = validateParameter(valid_579372, JString, required = false,
                                 default = newJString("json"))
  if valid_579372 != nil:
    section.add "alt", valid_579372
  var valid_579373 = query.getOrDefault("userIp")
  valid_579373 = validateParameter(valid_579373, JString, required = false,
                                 default = nil)
  if valid_579373 != nil:
    section.add "userIp", valid_579373
  var valid_579374 = query.getOrDefault("quotaUser")
  valid_579374 = validateParameter(valid_579374, JString, required = false,
                                 default = nil)
  if valid_579374 != nil:
    section.add "quotaUser", valid_579374
  var valid_579375 = query.getOrDefault("fields")
  valid_579375 = validateParameter(valid_579375, JString, required = false,
                                 default = nil)
  if valid_579375 != nil:
    section.add "fields", valid_579375
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579376: Call_TagmanagerAccountsContainersTriggersGet_579363;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a GTM Trigger.
  ## 
  let valid = call_579376.validator(path, query, header, formData, body)
  let scheme = call_579376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579376.url(scheme.get, call_579376.host, call_579376.base,
                         call_579376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579376, url, valid)

proc call*(call_579377: Call_TagmanagerAccountsContainersTriggersGet_579363;
          containerId: string; triggerId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersTriggersGet
  ## Gets a GTM Trigger.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   triggerId: string (required)
  ##            : The GTM Trigger ID.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579378 = newJObject()
  var query_579379 = newJObject()
  add(query_579379, "key", newJString(key))
  add(query_579379, "prettyPrint", newJBool(prettyPrint))
  add(query_579379, "oauth_token", newJString(oauthToken))
  add(path_579378, "containerId", newJString(containerId))
  add(query_579379, "alt", newJString(alt))
  add(query_579379, "userIp", newJString(userIp))
  add(query_579379, "quotaUser", newJString(quotaUser))
  add(path_579378, "triggerId", newJString(triggerId))
  add(path_579378, "accountId", newJString(accountId))
  add(query_579379, "fields", newJString(fields))
  result = call_579377.call(path_579378, query_579379, nil, nil, nil)

var tagmanagerAccountsContainersTriggersGet* = Call_TagmanagerAccountsContainersTriggersGet_579363(
    name: "tagmanagerAccountsContainersTriggersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/triggers/{triggerId}",
    validator: validate_TagmanagerAccountsContainersTriggersGet_579364,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTriggersGet_579365,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTriggersDelete_579400 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersTriggersDelete_579402(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersTriggersDelete_579401(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a GTM Trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   triggerId: JString (required)
  ##            : The GTM Trigger ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_579403 = path.getOrDefault("containerId")
  valid_579403 = validateParameter(valid_579403, JString, required = true,
                                 default = nil)
  if valid_579403 != nil:
    section.add "containerId", valid_579403
  var valid_579404 = path.getOrDefault("triggerId")
  valid_579404 = validateParameter(valid_579404, JString, required = true,
                                 default = nil)
  if valid_579404 != nil:
    section.add "triggerId", valid_579404
  var valid_579405 = path.getOrDefault("accountId")
  valid_579405 = validateParameter(valid_579405, JString, required = true,
                                 default = nil)
  if valid_579405 != nil:
    section.add "accountId", valid_579405
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
  var valid_579406 = query.getOrDefault("key")
  valid_579406 = validateParameter(valid_579406, JString, required = false,
                                 default = nil)
  if valid_579406 != nil:
    section.add "key", valid_579406
  var valid_579407 = query.getOrDefault("prettyPrint")
  valid_579407 = validateParameter(valid_579407, JBool, required = false,
                                 default = newJBool(true))
  if valid_579407 != nil:
    section.add "prettyPrint", valid_579407
  var valid_579408 = query.getOrDefault("oauth_token")
  valid_579408 = validateParameter(valid_579408, JString, required = false,
                                 default = nil)
  if valid_579408 != nil:
    section.add "oauth_token", valid_579408
  var valid_579409 = query.getOrDefault("alt")
  valid_579409 = validateParameter(valid_579409, JString, required = false,
                                 default = newJString("json"))
  if valid_579409 != nil:
    section.add "alt", valid_579409
  var valid_579410 = query.getOrDefault("userIp")
  valid_579410 = validateParameter(valid_579410, JString, required = false,
                                 default = nil)
  if valid_579410 != nil:
    section.add "userIp", valid_579410
  var valid_579411 = query.getOrDefault("quotaUser")
  valid_579411 = validateParameter(valid_579411, JString, required = false,
                                 default = nil)
  if valid_579411 != nil:
    section.add "quotaUser", valid_579411
  var valid_579412 = query.getOrDefault("fields")
  valid_579412 = validateParameter(valid_579412, JString, required = false,
                                 default = nil)
  if valid_579412 != nil:
    section.add "fields", valid_579412
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579413: Call_TagmanagerAccountsContainersTriggersDelete_579400;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a GTM Trigger.
  ## 
  let valid = call_579413.validator(path, query, header, formData, body)
  let scheme = call_579413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579413.url(scheme.get, call_579413.host, call_579413.base,
                         call_579413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579413, url, valid)

proc call*(call_579414: Call_TagmanagerAccountsContainersTriggersDelete_579400;
          containerId: string; triggerId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersTriggersDelete
  ## Deletes a GTM Trigger.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   triggerId: string (required)
  ##            : The GTM Trigger ID.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579415 = newJObject()
  var query_579416 = newJObject()
  add(query_579416, "key", newJString(key))
  add(query_579416, "prettyPrint", newJBool(prettyPrint))
  add(query_579416, "oauth_token", newJString(oauthToken))
  add(path_579415, "containerId", newJString(containerId))
  add(query_579416, "alt", newJString(alt))
  add(query_579416, "userIp", newJString(userIp))
  add(query_579416, "quotaUser", newJString(quotaUser))
  add(path_579415, "triggerId", newJString(triggerId))
  add(path_579415, "accountId", newJString(accountId))
  add(query_579416, "fields", newJString(fields))
  result = call_579414.call(path_579415, query_579416, nil, nil, nil)

var tagmanagerAccountsContainersTriggersDelete* = Call_TagmanagerAccountsContainersTriggersDelete_579400(
    name: "tagmanagerAccountsContainersTriggersDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/triggers/{triggerId}",
    validator: validate_TagmanagerAccountsContainersTriggersDelete_579401,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTriggersDelete_579402,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVariablesCreate_579433 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersVariablesCreate_579435(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersVariablesCreate_579434(path: JsonNode;
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
  var valid_579436 = path.getOrDefault("containerId")
  valid_579436 = validateParameter(valid_579436, JString, required = true,
                                 default = nil)
  if valid_579436 != nil:
    section.add "containerId", valid_579436
  var valid_579437 = path.getOrDefault("accountId")
  valid_579437 = validateParameter(valid_579437, JString, required = true,
                                 default = nil)
  if valid_579437 != nil:
    section.add "accountId", valid_579437
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
  var valid_579438 = query.getOrDefault("key")
  valid_579438 = validateParameter(valid_579438, JString, required = false,
                                 default = nil)
  if valid_579438 != nil:
    section.add "key", valid_579438
  var valid_579439 = query.getOrDefault("prettyPrint")
  valid_579439 = validateParameter(valid_579439, JBool, required = false,
                                 default = newJBool(true))
  if valid_579439 != nil:
    section.add "prettyPrint", valid_579439
  var valid_579440 = query.getOrDefault("oauth_token")
  valid_579440 = validateParameter(valid_579440, JString, required = false,
                                 default = nil)
  if valid_579440 != nil:
    section.add "oauth_token", valid_579440
  var valid_579441 = query.getOrDefault("alt")
  valid_579441 = validateParameter(valid_579441, JString, required = false,
                                 default = newJString("json"))
  if valid_579441 != nil:
    section.add "alt", valid_579441
  var valid_579442 = query.getOrDefault("userIp")
  valid_579442 = validateParameter(valid_579442, JString, required = false,
                                 default = nil)
  if valid_579442 != nil:
    section.add "userIp", valid_579442
  var valid_579443 = query.getOrDefault("quotaUser")
  valid_579443 = validateParameter(valid_579443, JString, required = false,
                                 default = nil)
  if valid_579443 != nil:
    section.add "quotaUser", valid_579443
  var valid_579444 = query.getOrDefault("fields")
  valid_579444 = validateParameter(valid_579444, JString, required = false,
                                 default = nil)
  if valid_579444 != nil:
    section.add "fields", valid_579444
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

proc call*(call_579446: Call_TagmanagerAccountsContainersVariablesCreate_579433;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a GTM Variable.
  ## 
  let valid = call_579446.validator(path, query, header, formData, body)
  let scheme = call_579446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579446.url(scheme.get, call_579446.host, call_579446.base,
                         call_579446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579446, url, valid)

proc call*(call_579447: Call_TagmanagerAccountsContainersVariablesCreate_579433;
          containerId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersVariablesCreate
  ## Creates a GTM Variable.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579448 = newJObject()
  var query_579449 = newJObject()
  var body_579450 = newJObject()
  add(query_579449, "key", newJString(key))
  add(query_579449, "prettyPrint", newJBool(prettyPrint))
  add(query_579449, "oauth_token", newJString(oauthToken))
  add(path_579448, "containerId", newJString(containerId))
  add(query_579449, "alt", newJString(alt))
  add(query_579449, "userIp", newJString(userIp))
  add(query_579449, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579450 = body
  add(path_579448, "accountId", newJString(accountId))
  add(query_579449, "fields", newJString(fields))
  result = call_579447.call(path_579448, query_579449, nil, nil, body_579450)

var tagmanagerAccountsContainersVariablesCreate* = Call_TagmanagerAccountsContainersVariablesCreate_579433(
    name: "tagmanagerAccountsContainersVariablesCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/variables",
    validator: validate_TagmanagerAccountsContainersVariablesCreate_579434,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVariablesCreate_579435,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVariablesList_579417 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersVariablesList_579419(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersVariablesList_579418(path: JsonNode;
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
  var valid_579420 = path.getOrDefault("containerId")
  valid_579420 = validateParameter(valid_579420, JString, required = true,
                                 default = nil)
  if valid_579420 != nil:
    section.add "containerId", valid_579420
  var valid_579421 = path.getOrDefault("accountId")
  valid_579421 = validateParameter(valid_579421, JString, required = true,
                                 default = nil)
  if valid_579421 != nil:
    section.add "accountId", valid_579421
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
  var valid_579422 = query.getOrDefault("key")
  valid_579422 = validateParameter(valid_579422, JString, required = false,
                                 default = nil)
  if valid_579422 != nil:
    section.add "key", valid_579422
  var valid_579423 = query.getOrDefault("prettyPrint")
  valid_579423 = validateParameter(valid_579423, JBool, required = false,
                                 default = newJBool(true))
  if valid_579423 != nil:
    section.add "prettyPrint", valid_579423
  var valid_579424 = query.getOrDefault("oauth_token")
  valid_579424 = validateParameter(valid_579424, JString, required = false,
                                 default = nil)
  if valid_579424 != nil:
    section.add "oauth_token", valid_579424
  var valid_579425 = query.getOrDefault("alt")
  valid_579425 = validateParameter(valid_579425, JString, required = false,
                                 default = newJString("json"))
  if valid_579425 != nil:
    section.add "alt", valid_579425
  var valid_579426 = query.getOrDefault("userIp")
  valid_579426 = validateParameter(valid_579426, JString, required = false,
                                 default = nil)
  if valid_579426 != nil:
    section.add "userIp", valid_579426
  var valid_579427 = query.getOrDefault("quotaUser")
  valid_579427 = validateParameter(valid_579427, JString, required = false,
                                 default = nil)
  if valid_579427 != nil:
    section.add "quotaUser", valid_579427
  var valid_579428 = query.getOrDefault("fields")
  valid_579428 = validateParameter(valid_579428, JString, required = false,
                                 default = nil)
  if valid_579428 != nil:
    section.add "fields", valid_579428
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579429: Call_TagmanagerAccountsContainersVariablesList_579417;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all GTM Variables of a Container.
  ## 
  let valid = call_579429.validator(path, query, header, formData, body)
  let scheme = call_579429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579429.url(scheme.get, call_579429.host, call_579429.base,
                         call_579429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579429, url, valid)

proc call*(call_579430: Call_TagmanagerAccountsContainersVariablesList_579417;
          containerId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersVariablesList
  ## Lists all GTM Variables of a Container.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579431 = newJObject()
  var query_579432 = newJObject()
  add(query_579432, "key", newJString(key))
  add(query_579432, "prettyPrint", newJBool(prettyPrint))
  add(query_579432, "oauth_token", newJString(oauthToken))
  add(path_579431, "containerId", newJString(containerId))
  add(query_579432, "alt", newJString(alt))
  add(query_579432, "userIp", newJString(userIp))
  add(query_579432, "quotaUser", newJString(quotaUser))
  add(path_579431, "accountId", newJString(accountId))
  add(query_579432, "fields", newJString(fields))
  result = call_579430.call(path_579431, query_579432, nil, nil, nil)

var tagmanagerAccountsContainersVariablesList* = Call_TagmanagerAccountsContainersVariablesList_579417(
    name: "tagmanagerAccountsContainersVariablesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/variables",
    validator: validate_TagmanagerAccountsContainersVariablesList_579418,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVariablesList_579419,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVariablesUpdate_579468 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersVariablesUpdate_579470(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersVariablesUpdate_579469(path: JsonNode;
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
  var valid_579471 = path.getOrDefault("containerId")
  valid_579471 = validateParameter(valid_579471, JString, required = true,
                                 default = nil)
  if valid_579471 != nil:
    section.add "containerId", valid_579471
  var valid_579472 = path.getOrDefault("variableId")
  valid_579472 = validateParameter(valid_579472, JString, required = true,
                                 default = nil)
  if valid_579472 != nil:
    section.add "variableId", valid_579472
  var valid_579473 = path.getOrDefault("accountId")
  valid_579473 = validateParameter(valid_579473, JString, required = true,
                                 default = nil)
  if valid_579473 != nil:
    section.add "accountId", valid_579473
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fingerprint: JString
  ##              : When provided, this fingerprint must match the fingerprint of the variable in storage.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579474 = query.getOrDefault("key")
  valid_579474 = validateParameter(valid_579474, JString, required = false,
                                 default = nil)
  if valid_579474 != nil:
    section.add "key", valid_579474
  var valid_579475 = query.getOrDefault("prettyPrint")
  valid_579475 = validateParameter(valid_579475, JBool, required = false,
                                 default = newJBool(true))
  if valid_579475 != nil:
    section.add "prettyPrint", valid_579475
  var valid_579476 = query.getOrDefault("oauth_token")
  valid_579476 = validateParameter(valid_579476, JString, required = false,
                                 default = nil)
  if valid_579476 != nil:
    section.add "oauth_token", valid_579476
  var valid_579477 = query.getOrDefault("fingerprint")
  valid_579477 = validateParameter(valid_579477, JString, required = false,
                                 default = nil)
  if valid_579477 != nil:
    section.add "fingerprint", valid_579477
  var valid_579478 = query.getOrDefault("alt")
  valid_579478 = validateParameter(valid_579478, JString, required = false,
                                 default = newJString("json"))
  if valid_579478 != nil:
    section.add "alt", valid_579478
  var valid_579479 = query.getOrDefault("userIp")
  valid_579479 = validateParameter(valid_579479, JString, required = false,
                                 default = nil)
  if valid_579479 != nil:
    section.add "userIp", valid_579479
  var valid_579480 = query.getOrDefault("quotaUser")
  valid_579480 = validateParameter(valid_579480, JString, required = false,
                                 default = nil)
  if valid_579480 != nil:
    section.add "quotaUser", valid_579480
  var valid_579481 = query.getOrDefault("fields")
  valid_579481 = validateParameter(valid_579481, JString, required = false,
                                 default = nil)
  if valid_579481 != nil:
    section.add "fields", valid_579481
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

proc call*(call_579483: Call_TagmanagerAccountsContainersVariablesUpdate_579468;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a GTM Variable.
  ## 
  let valid = call_579483.validator(path, query, header, formData, body)
  let scheme = call_579483.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579483.url(scheme.get, call_579483.host, call_579483.base,
                         call_579483.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579483, url, valid)

proc call*(call_579484: Call_TagmanagerAccountsContainersVariablesUpdate_579468;
          containerId: string; variableId: string; accountId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          fingerprint: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersVariablesUpdate
  ## Updates a GTM Variable.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   variableId: string (required)
  ##             : The GTM Variable ID.
  ##   fingerprint: string
  ##              : When provided, this fingerprint must match the fingerprint of the variable in storage.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579485 = newJObject()
  var query_579486 = newJObject()
  var body_579487 = newJObject()
  add(query_579486, "key", newJString(key))
  add(query_579486, "prettyPrint", newJBool(prettyPrint))
  add(query_579486, "oauth_token", newJString(oauthToken))
  add(path_579485, "containerId", newJString(containerId))
  add(path_579485, "variableId", newJString(variableId))
  add(query_579486, "fingerprint", newJString(fingerprint))
  add(query_579486, "alt", newJString(alt))
  add(query_579486, "userIp", newJString(userIp))
  add(query_579486, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579487 = body
  add(path_579485, "accountId", newJString(accountId))
  add(query_579486, "fields", newJString(fields))
  result = call_579484.call(path_579485, query_579486, nil, nil, body_579487)

var tagmanagerAccountsContainersVariablesUpdate* = Call_TagmanagerAccountsContainersVariablesUpdate_579468(
    name: "tagmanagerAccountsContainersVariablesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/variables/{variableId}",
    validator: validate_TagmanagerAccountsContainersVariablesUpdate_579469,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVariablesUpdate_579470,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVariablesGet_579451 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersVariablesGet_579453(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersVariablesGet_579452(path: JsonNode;
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
  var valid_579454 = path.getOrDefault("containerId")
  valid_579454 = validateParameter(valid_579454, JString, required = true,
                                 default = nil)
  if valid_579454 != nil:
    section.add "containerId", valid_579454
  var valid_579455 = path.getOrDefault("variableId")
  valid_579455 = validateParameter(valid_579455, JString, required = true,
                                 default = nil)
  if valid_579455 != nil:
    section.add "variableId", valid_579455
  var valid_579456 = path.getOrDefault("accountId")
  valid_579456 = validateParameter(valid_579456, JString, required = true,
                                 default = nil)
  if valid_579456 != nil:
    section.add "accountId", valid_579456
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
  var valid_579457 = query.getOrDefault("key")
  valid_579457 = validateParameter(valid_579457, JString, required = false,
                                 default = nil)
  if valid_579457 != nil:
    section.add "key", valid_579457
  var valid_579458 = query.getOrDefault("prettyPrint")
  valid_579458 = validateParameter(valid_579458, JBool, required = false,
                                 default = newJBool(true))
  if valid_579458 != nil:
    section.add "prettyPrint", valid_579458
  var valid_579459 = query.getOrDefault("oauth_token")
  valid_579459 = validateParameter(valid_579459, JString, required = false,
                                 default = nil)
  if valid_579459 != nil:
    section.add "oauth_token", valid_579459
  var valid_579460 = query.getOrDefault("alt")
  valid_579460 = validateParameter(valid_579460, JString, required = false,
                                 default = newJString("json"))
  if valid_579460 != nil:
    section.add "alt", valid_579460
  var valid_579461 = query.getOrDefault("userIp")
  valid_579461 = validateParameter(valid_579461, JString, required = false,
                                 default = nil)
  if valid_579461 != nil:
    section.add "userIp", valid_579461
  var valid_579462 = query.getOrDefault("quotaUser")
  valid_579462 = validateParameter(valid_579462, JString, required = false,
                                 default = nil)
  if valid_579462 != nil:
    section.add "quotaUser", valid_579462
  var valid_579463 = query.getOrDefault("fields")
  valid_579463 = validateParameter(valid_579463, JString, required = false,
                                 default = nil)
  if valid_579463 != nil:
    section.add "fields", valid_579463
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579464: Call_TagmanagerAccountsContainersVariablesGet_579451;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a GTM Variable.
  ## 
  let valid = call_579464.validator(path, query, header, formData, body)
  let scheme = call_579464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579464.url(scheme.get, call_579464.host, call_579464.base,
                         call_579464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579464, url, valid)

proc call*(call_579465: Call_TagmanagerAccountsContainersVariablesGet_579451;
          containerId: string; variableId: string; accountId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersVariablesGet
  ## Gets a GTM Variable.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   variableId: string (required)
  ##             : The GTM Variable ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579466 = newJObject()
  var query_579467 = newJObject()
  add(query_579467, "key", newJString(key))
  add(query_579467, "prettyPrint", newJBool(prettyPrint))
  add(query_579467, "oauth_token", newJString(oauthToken))
  add(path_579466, "containerId", newJString(containerId))
  add(path_579466, "variableId", newJString(variableId))
  add(query_579467, "alt", newJString(alt))
  add(query_579467, "userIp", newJString(userIp))
  add(query_579467, "quotaUser", newJString(quotaUser))
  add(path_579466, "accountId", newJString(accountId))
  add(query_579467, "fields", newJString(fields))
  result = call_579465.call(path_579466, query_579467, nil, nil, nil)

var tagmanagerAccountsContainersVariablesGet* = Call_TagmanagerAccountsContainersVariablesGet_579451(
    name: "tagmanagerAccountsContainersVariablesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/variables/{variableId}",
    validator: validate_TagmanagerAccountsContainersVariablesGet_579452,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVariablesGet_579453,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVariablesDelete_579488 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersVariablesDelete_579490(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersVariablesDelete_579489(path: JsonNode;
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
  var valid_579491 = path.getOrDefault("containerId")
  valid_579491 = validateParameter(valid_579491, JString, required = true,
                                 default = nil)
  if valid_579491 != nil:
    section.add "containerId", valid_579491
  var valid_579492 = path.getOrDefault("variableId")
  valid_579492 = validateParameter(valid_579492, JString, required = true,
                                 default = nil)
  if valid_579492 != nil:
    section.add "variableId", valid_579492
  var valid_579493 = path.getOrDefault("accountId")
  valid_579493 = validateParameter(valid_579493, JString, required = true,
                                 default = nil)
  if valid_579493 != nil:
    section.add "accountId", valid_579493
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
  var valid_579494 = query.getOrDefault("key")
  valid_579494 = validateParameter(valid_579494, JString, required = false,
                                 default = nil)
  if valid_579494 != nil:
    section.add "key", valid_579494
  var valid_579495 = query.getOrDefault("prettyPrint")
  valid_579495 = validateParameter(valid_579495, JBool, required = false,
                                 default = newJBool(true))
  if valid_579495 != nil:
    section.add "prettyPrint", valid_579495
  var valid_579496 = query.getOrDefault("oauth_token")
  valid_579496 = validateParameter(valid_579496, JString, required = false,
                                 default = nil)
  if valid_579496 != nil:
    section.add "oauth_token", valid_579496
  var valid_579497 = query.getOrDefault("alt")
  valid_579497 = validateParameter(valid_579497, JString, required = false,
                                 default = newJString("json"))
  if valid_579497 != nil:
    section.add "alt", valid_579497
  var valid_579498 = query.getOrDefault("userIp")
  valid_579498 = validateParameter(valid_579498, JString, required = false,
                                 default = nil)
  if valid_579498 != nil:
    section.add "userIp", valid_579498
  var valid_579499 = query.getOrDefault("quotaUser")
  valid_579499 = validateParameter(valid_579499, JString, required = false,
                                 default = nil)
  if valid_579499 != nil:
    section.add "quotaUser", valid_579499
  var valid_579500 = query.getOrDefault("fields")
  valid_579500 = validateParameter(valid_579500, JString, required = false,
                                 default = nil)
  if valid_579500 != nil:
    section.add "fields", valid_579500
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579501: Call_TagmanagerAccountsContainersVariablesDelete_579488;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a GTM Variable.
  ## 
  let valid = call_579501.validator(path, query, header, formData, body)
  let scheme = call_579501.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579501.url(scheme.get, call_579501.host, call_579501.base,
                         call_579501.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579501, url, valid)

proc call*(call_579502: Call_TagmanagerAccountsContainersVariablesDelete_579488;
          containerId: string; variableId: string; accountId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersVariablesDelete
  ## Deletes a GTM Variable.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   variableId: string (required)
  ##             : The GTM Variable ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579503 = newJObject()
  var query_579504 = newJObject()
  add(query_579504, "key", newJString(key))
  add(query_579504, "prettyPrint", newJBool(prettyPrint))
  add(query_579504, "oauth_token", newJString(oauthToken))
  add(path_579503, "containerId", newJString(containerId))
  add(path_579503, "variableId", newJString(variableId))
  add(query_579504, "alt", newJString(alt))
  add(query_579504, "userIp", newJString(userIp))
  add(query_579504, "quotaUser", newJString(quotaUser))
  add(path_579503, "accountId", newJString(accountId))
  add(query_579504, "fields", newJString(fields))
  result = call_579502.call(path_579503, query_579504, nil, nil, nil)

var tagmanagerAccountsContainersVariablesDelete* = Call_TagmanagerAccountsContainersVariablesDelete_579488(
    name: "tagmanagerAccountsContainersVariablesDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/variables/{variableId}",
    validator: validate_TagmanagerAccountsContainersVariablesDelete_579489,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVariablesDelete_579490,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsCreate_579523 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersVersionsCreate_579525(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersVersionsCreate_579524(path: JsonNode;
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
  var valid_579526 = path.getOrDefault("containerId")
  valid_579526 = validateParameter(valid_579526, JString, required = true,
                                 default = nil)
  if valid_579526 != nil:
    section.add "containerId", valid_579526
  var valid_579527 = path.getOrDefault("accountId")
  valid_579527 = validateParameter(valid_579527, JString, required = true,
                                 default = nil)
  if valid_579527 != nil:
    section.add "accountId", valid_579527
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
  var valid_579528 = query.getOrDefault("key")
  valid_579528 = validateParameter(valid_579528, JString, required = false,
                                 default = nil)
  if valid_579528 != nil:
    section.add "key", valid_579528
  var valid_579529 = query.getOrDefault("prettyPrint")
  valid_579529 = validateParameter(valid_579529, JBool, required = false,
                                 default = newJBool(true))
  if valid_579529 != nil:
    section.add "prettyPrint", valid_579529
  var valid_579530 = query.getOrDefault("oauth_token")
  valid_579530 = validateParameter(valid_579530, JString, required = false,
                                 default = nil)
  if valid_579530 != nil:
    section.add "oauth_token", valid_579530
  var valid_579531 = query.getOrDefault("alt")
  valid_579531 = validateParameter(valid_579531, JString, required = false,
                                 default = newJString("json"))
  if valid_579531 != nil:
    section.add "alt", valid_579531
  var valid_579532 = query.getOrDefault("userIp")
  valid_579532 = validateParameter(valid_579532, JString, required = false,
                                 default = nil)
  if valid_579532 != nil:
    section.add "userIp", valid_579532
  var valid_579533 = query.getOrDefault("quotaUser")
  valid_579533 = validateParameter(valid_579533, JString, required = false,
                                 default = nil)
  if valid_579533 != nil:
    section.add "quotaUser", valid_579533
  var valid_579534 = query.getOrDefault("fields")
  valid_579534 = validateParameter(valid_579534, JString, required = false,
                                 default = nil)
  if valid_579534 != nil:
    section.add "fields", valid_579534
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

proc call*(call_579536: Call_TagmanagerAccountsContainersVersionsCreate_579523;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Container Version.
  ## 
  let valid = call_579536.validator(path, query, header, formData, body)
  let scheme = call_579536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579536.url(scheme.get, call_579536.host, call_579536.base,
                         call_579536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579536, url, valid)

proc call*(call_579537: Call_TagmanagerAccountsContainersVersionsCreate_579523;
          containerId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersVersionsCreate
  ## Creates a Container Version.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579538 = newJObject()
  var query_579539 = newJObject()
  var body_579540 = newJObject()
  add(query_579539, "key", newJString(key))
  add(query_579539, "prettyPrint", newJBool(prettyPrint))
  add(query_579539, "oauth_token", newJString(oauthToken))
  add(path_579538, "containerId", newJString(containerId))
  add(query_579539, "alt", newJString(alt))
  add(query_579539, "userIp", newJString(userIp))
  add(query_579539, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579540 = body
  add(path_579538, "accountId", newJString(accountId))
  add(query_579539, "fields", newJString(fields))
  result = call_579537.call(path_579538, query_579539, nil, nil, body_579540)

var tagmanagerAccountsContainersVersionsCreate* = Call_TagmanagerAccountsContainersVersionsCreate_579523(
    name: "tagmanagerAccountsContainersVersionsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/versions",
    validator: validate_TagmanagerAccountsContainersVersionsCreate_579524,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsCreate_579525,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsList_579505 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersVersionsList_579507(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersVersionsList_579506(path: JsonNode;
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
  var valid_579508 = path.getOrDefault("containerId")
  valid_579508 = validateParameter(valid_579508, JString, required = true,
                                 default = nil)
  if valid_579508 != nil:
    section.add "containerId", valid_579508
  var valid_579509 = path.getOrDefault("accountId")
  valid_579509 = validateParameter(valid_579509, JString, required = true,
                                 default = nil)
  if valid_579509 != nil:
    section.add "accountId", valid_579509
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
  ##   includeDeleted: JBool
  ##                 : Also retrieve deleted (archived) versions when true.
  ##   headers: JBool
  ##          : Retrieve headers only when true.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579510 = query.getOrDefault("key")
  valid_579510 = validateParameter(valid_579510, JString, required = false,
                                 default = nil)
  if valid_579510 != nil:
    section.add "key", valid_579510
  var valid_579511 = query.getOrDefault("prettyPrint")
  valid_579511 = validateParameter(valid_579511, JBool, required = false,
                                 default = newJBool(true))
  if valid_579511 != nil:
    section.add "prettyPrint", valid_579511
  var valid_579512 = query.getOrDefault("oauth_token")
  valid_579512 = validateParameter(valid_579512, JString, required = false,
                                 default = nil)
  if valid_579512 != nil:
    section.add "oauth_token", valid_579512
  var valid_579513 = query.getOrDefault("alt")
  valid_579513 = validateParameter(valid_579513, JString, required = false,
                                 default = newJString("json"))
  if valid_579513 != nil:
    section.add "alt", valid_579513
  var valid_579514 = query.getOrDefault("userIp")
  valid_579514 = validateParameter(valid_579514, JString, required = false,
                                 default = nil)
  if valid_579514 != nil:
    section.add "userIp", valid_579514
  var valid_579515 = query.getOrDefault("quotaUser")
  valid_579515 = validateParameter(valid_579515, JString, required = false,
                                 default = nil)
  if valid_579515 != nil:
    section.add "quotaUser", valid_579515
  var valid_579516 = query.getOrDefault("includeDeleted")
  valid_579516 = validateParameter(valid_579516, JBool, required = false,
                                 default = newJBool(false))
  if valid_579516 != nil:
    section.add "includeDeleted", valid_579516
  var valid_579517 = query.getOrDefault("headers")
  valid_579517 = validateParameter(valid_579517, JBool, required = false,
                                 default = newJBool(false))
  if valid_579517 != nil:
    section.add "headers", valid_579517
  var valid_579518 = query.getOrDefault("fields")
  valid_579518 = validateParameter(valid_579518, JString, required = false,
                                 default = nil)
  if valid_579518 != nil:
    section.add "fields", valid_579518
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579519: Call_TagmanagerAccountsContainersVersionsList_579505;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all Container Versions of a GTM Container.
  ## 
  let valid = call_579519.validator(path, query, header, formData, body)
  let scheme = call_579519.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579519.url(scheme.get, call_579519.host, call_579519.base,
                         call_579519.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579519, url, valid)

proc call*(call_579520: Call_TagmanagerAccountsContainersVersionsList_579505;
          containerId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; includeDeleted: bool = false;
          headers: bool = false; fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersVersionsList
  ## Lists all Container Versions of a GTM Container.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   includeDeleted: bool
  ##                 : Also retrieve deleted (archived) versions when true.
  ##   headers: bool
  ##          : Retrieve headers only when true.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579521 = newJObject()
  var query_579522 = newJObject()
  add(query_579522, "key", newJString(key))
  add(query_579522, "prettyPrint", newJBool(prettyPrint))
  add(query_579522, "oauth_token", newJString(oauthToken))
  add(path_579521, "containerId", newJString(containerId))
  add(query_579522, "alt", newJString(alt))
  add(query_579522, "userIp", newJString(userIp))
  add(query_579522, "quotaUser", newJString(quotaUser))
  add(query_579522, "includeDeleted", newJBool(includeDeleted))
  add(query_579522, "headers", newJBool(headers))
  add(path_579521, "accountId", newJString(accountId))
  add(query_579522, "fields", newJString(fields))
  result = call_579520.call(path_579521, query_579522, nil, nil, nil)

var tagmanagerAccountsContainersVersionsList* = Call_TagmanagerAccountsContainersVersionsList_579505(
    name: "tagmanagerAccountsContainersVersionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/versions",
    validator: validate_TagmanagerAccountsContainersVersionsList_579506,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsList_579507,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsUpdate_579558 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersVersionsUpdate_579560(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersVersionsUpdate_579559(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a Container Version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   containerVersionId: JString (required)
  ##                     : The GTM Container Version ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_579561 = path.getOrDefault("containerId")
  valid_579561 = validateParameter(valid_579561, JString, required = true,
                                 default = nil)
  if valid_579561 != nil:
    section.add "containerId", valid_579561
  var valid_579562 = path.getOrDefault("containerVersionId")
  valid_579562 = validateParameter(valid_579562, JString, required = true,
                                 default = nil)
  if valid_579562 != nil:
    section.add "containerVersionId", valid_579562
  var valid_579563 = path.getOrDefault("accountId")
  valid_579563 = validateParameter(valid_579563, JString, required = true,
                                 default = nil)
  if valid_579563 != nil:
    section.add "accountId", valid_579563
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fingerprint: JString
  ##              : When provided, this fingerprint must match the fingerprint of the container version in storage.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579564 = query.getOrDefault("key")
  valid_579564 = validateParameter(valid_579564, JString, required = false,
                                 default = nil)
  if valid_579564 != nil:
    section.add "key", valid_579564
  var valid_579565 = query.getOrDefault("prettyPrint")
  valid_579565 = validateParameter(valid_579565, JBool, required = false,
                                 default = newJBool(true))
  if valid_579565 != nil:
    section.add "prettyPrint", valid_579565
  var valid_579566 = query.getOrDefault("oauth_token")
  valid_579566 = validateParameter(valid_579566, JString, required = false,
                                 default = nil)
  if valid_579566 != nil:
    section.add "oauth_token", valid_579566
  var valid_579567 = query.getOrDefault("fingerprint")
  valid_579567 = validateParameter(valid_579567, JString, required = false,
                                 default = nil)
  if valid_579567 != nil:
    section.add "fingerprint", valid_579567
  var valid_579568 = query.getOrDefault("alt")
  valid_579568 = validateParameter(valid_579568, JString, required = false,
                                 default = newJString("json"))
  if valid_579568 != nil:
    section.add "alt", valid_579568
  var valid_579569 = query.getOrDefault("userIp")
  valid_579569 = validateParameter(valid_579569, JString, required = false,
                                 default = nil)
  if valid_579569 != nil:
    section.add "userIp", valid_579569
  var valid_579570 = query.getOrDefault("quotaUser")
  valid_579570 = validateParameter(valid_579570, JString, required = false,
                                 default = nil)
  if valid_579570 != nil:
    section.add "quotaUser", valid_579570
  var valid_579571 = query.getOrDefault("fields")
  valid_579571 = validateParameter(valid_579571, JString, required = false,
                                 default = nil)
  if valid_579571 != nil:
    section.add "fields", valid_579571
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

proc call*(call_579573: Call_TagmanagerAccountsContainersVersionsUpdate_579558;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a Container Version.
  ## 
  let valid = call_579573.validator(path, query, header, formData, body)
  let scheme = call_579573.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579573.url(scheme.get, call_579573.host, call_579573.base,
                         call_579573.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579573, url, valid)

proc call*(call_579574: Call_TagmanagerAccountsContainersVersionsUpdate_579558;
          containerId: string; containerVersionId: string; accountId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          fingerprint: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersVersionsUpdate
  ## Updates a Container Version.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fingerprint: string
  ##              : When provided, this fingerprint must match the fingerprint of the container version in storage.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   containerVersionId: string (required)
  ##                     : The GTM Container Version ID.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579575 = newJObject()
  var query_579576 = newJObject()
  var body_579577 = newJObject()
  add(query_579576, "key", newJString(key))
  add(query_579576, "prettyPrint", newJBool(prettyPrint))
  add(query_579576, "oauth_token", newJString(oauthToken))
  add(path_579575, "containerId", newJString(containerId))
  add(query_579576, "fingerprint", newJString(fingerprint))
  add(query_579576, "alt", newJString(alt))
  add(query_579576, "userIp", newJString(userIp))
  add(query_579576, "quotaUser", newJString(quotaUser))
  add(path_579575, "containerVersionId", newJString(containerVersionId))
  if body != nil:
    body_579577 = body
  add(path_579575, "accountId", newJString(accountId))
  add(query_579576, "fields", newJString(fields))
  result = call_579574.call(path_579575, query_579576, nil, nil, body_579577)

var tagmanagerAccountsContainersVersionsUpdate* = Call_TagmanagerAccountsContainersVersionsUpdate_579558(
    name: "tagmanagerAccountsContainersVersionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/versions/{containerVersionId}",
    validator: validate_TagmanagerAccountsContainersVersionsUpdate_579559,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsUpdate_579560,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsGet_579541 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersVersionsGet_579543(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersVersionsGet_579542(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a Container Version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   containerVersionId: JString (required)
  ##                     : The GTM Container Version ID. Specify published to retrieve the currently published version.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_579544 = path.getOrDefault("containerId")
  valid_579544 = validateParameter(valid_579544, JString, required = true,
                                 default = nil)
  if valid_579544 != nil:
    section.add "containerId", valid_579544
  var valid_579545 = path.getOrDefault("containerVersionId")
  valid_579545 = validateParameter(valid_579545, JString, required = true,
                                 default = nil)
  if valid_579545 != nil:
    section.add "containerVersionId", valid_579545
  var valid_579546 = path.getOrDefault("accountId")
  valid_579546 = validateParameter(valid_579546, JString, required = true,
                                 default = nil)
  if valid_579546 != nil:
    section.add "accountId", valid_579546
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
  var valid_579547 = query.getOrDefault("key")
  valid_579547 = validateParameter(valid_579547, JString, required = false,
                                 default = nil)
  if valid_579547 != nil:
    section.add "key", valid_579547
  var valid_579548 = query.getOrDefault("prettyPrint")
  valid_579548 = validateParameter(valid_579548, JBool, required = false,
                                 default = newJBool(true))
  if valid_579548 != nil:
    section.add "prettyPrint", valid_579548
  var valid_579549 = query.getOrDefault("oauth_token")
  valid_579549 = validateParameter(valid_579549, JString, required = false,
                                 default = nil)
  if valid_579549 != nil:
    section.add "oauth_token", valid_579549
  var valid_579550 = query.getOrDefault("alt")
  valid_579550 = validateParameter(valid_579550, JString, required = false,
                                 default = newJString("json"))
  if valid_579550 != nil:
    section.add "alt", valid_579550
  var valid_579551 = query.getOrDefault("userIp")
  valid_579551 = validateParameter(valid_579551, JString, required = false,
                                 default = nil)
  if valid_579551 != nil:
    section.add "userIp", valid_579551
  var valid_579552 = query.getOrDefault("quotaUser")
  valid_579552 = validateParameter(valid_579552, JString, required = false,
                                 default = nil)
  if valid_579552 != nil:
    section.add "quotaUser", valid_579552
  var valid_579553 = query.getOrDefault("fields")
  valid_579553 = validateParameter(valid_579553, JString, required = false,
                                 default = nil)
  if valid_579553 != nil:
    section.add "fields", valid_579553
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579554: Call_TagmanagerAccountsContainersVersionsGet_579541;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a Container Version.
  ## 
  let valid = call_579554.validator(path, query, header, formData, body)
  let scheme = call_579554.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579554.url(scheme.get, call_579554.host, call_579554.base,
                         call_579554.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579554, url, valid)

proc call*(call_579555: Call_TagmanagerAccountsContainersVersionsGet_579541;
          containerId: string; containerVersionId: string; accountId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersVersionsGet
  ## Gets a Container Version.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   containerVersionId: string (required)
  ##                     : The GTM Container Version ID. Specify published to retrieve the currently published version.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579556 = newJObject()
  var query_579557 = newJObject()
  add(query_579557, "key", newJString(key))
  add(query_579557, "prettyPrint", newJBool(prettyPrint))
  add(query_579557, "oauth_token", newJString(oauthToken))
  add(path_579556, "containerId", newJString(containerId))
  add(query_579557, "alt", newJString(alt))
  add(query_579557, "userIp", newJString(userIp))
  add(query_579557, "quotaUser", newJString(quotaUser))
  add(path_579556, "containerVersionId", newJString(containerVersionId))
  add(path_579556, "accountId", newJString(accountId))
  add(query_579557, "fields", newJString(fields))
  result = call_579555.call(path_579556, query_579557, nil, nil, nil)

var tagmanagerAccountsContainersVersionsGet* = Call_TagmanagerAccountsContainersVersionsGet_579541(
    name: "tagmanagerAccountsContainersVersionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/versions/{containerVersionId}",
    validator: validate_TagmanagerAccountsContainersVersionsGet_579542,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsGet_579543,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsDelete_579578 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersVersionsDelete_579580(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersVersionsDelete_579579(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a Container Version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   containerVersionId: JString (required)
  ##                     : The GTM Container Version ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_579581 = path.getOrDefault("containerId")
  valid_579581 = validateParameter(valid_579581, JString, required = true,
                                 default = nil)
  if valid_579581 != nil:
    section.add "containerId", valid_579581
  var valid_579582 = path.getOrDefault("containerVersionId")
  valid_579582 = validateParameter(valid_579582, JString, required = true,
                                 default = nil)
  if valid_579582 != nil:
    section.add "containerVersionId", valid_579582
  var valid_579583 = path.getOrDefault("accountId")
  valid_579583 = validateParameter(valid_579583, JString, required = true,
                                 default = nil)
  if valid_579583 != nil:
    section.add "accountId", valid_579583
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
  var valid_579584 = query.getOrDefault("key")
  valid_579584 = validateParameter(valid_579584, JString, required = false,
                                 default = nil)
  if valid_579584 != nil:
    section.add "key", valid_579584
  var valid_579585 = query.getOrDefault("prettyPrint")
  valid_579585 = validateParameter(valid_579585, JBool, required = false,
                                 default = newJBool(true))
  if valid_579585 != nil:
    section.add "prettyPrint", valid_579585
  var valid_579586 = query.getOrDefault("oauth_token")
  valid_579586 = validateParameter(valid_579586, JString, required = false,
                                 default = nil)
  if valid_579586 != nil:
    section.add "oauth_token", valid_579586
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
  var valid_579589 = query.getOrDefault("quotaUser")
  valid_579589 = validateParameter(valid_579589, JString, required = false,
                                 default = nil)
  if valid_579589 != nil:
    section.add "quotaUser", valid_579589
  var valid_579590 = query.getOrDefault("fields")
  valid_579590 = validateParameter(valid_579590, JString, required = false,
                                 default = nil)
  if valid_579590 != nil:
    section.add "fields", valid_579590
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579591: Call_TagmanagerAccountsContainersVersionsDelete_579578;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a Container Version.
  ## 
  let valid = call_579591.validator(path, query, header, formData, body)
  let scheme = call_579591.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579591.url(scheme.get, call_579591.host, call_579591.base,
                         call_579591.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579591, url, valid)

proc call*(call_579592: Call_TagmanagerAccountsContainersVersionsDelete_579578;
          containerId: string; containerVersionId: string; accountId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersVersionsDelete
  ## Deletes a Container Version.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   containerVersionId: string (required)
  ##                     : The GTM Container Version ID.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579593 = newJObject()
  var query_579594 = newJObject()
  add(query_579594, "key", newJString(key))
  add(query_579594, "prettyPrint", newJBool(prettyPrint))
  add(query_579594, "oauth_token", newJString(oauthToken))
  add(path_579593, "containerId", newJString(containerId))
  add(query_579594, "alt", newJString(alt))
  add(query_579594, "userIp", newJString(userIp))
  add(query_579594, "quotaUser", newJString(quotaUser))
  add(path_579593, "containerVersionId", newJString(containerVersionId))
  add(path_579593, "accountId", newJString(accountId))
  add(query_579594, "fields", newJString(fields))
  result = call_579592.call(path_579593, query_579594, nil, nil, nil)

var tagmanagerAccountsContainersVersionsDelete* = Call_TagmanagerAccountsContainersVersionsDelete_579578(
    name: "tagmanagerAccountsContainersVersionsDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/versions/{containerVersionId}",
    validator: validate_TagmanagerAccountsContainersVersionsDelete_579579,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsDelete_579580,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsPublish_579595 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersVersionsPublish_579597(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersVersionsPublish_579596(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Publishes a Container Version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   containerVersionId: JString (required)
  ##                     : The GTM Container Version ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_579598 = path.getOrDefault("containerId")
  valid_579598 = validateParameter(valid_579598, JString, required = true,
                                 default = nil)
  if valid_579598 != nil:
    section.add "containerId", valid_579598
  var valid_579599 = path.getOrDefault("containerVersionId")
  valid_579599 = validateParameter(valid_579599, JString, required = true,
                                 default = nil)
  if valid_579599 != nil:
    section.add "containerVersionId", valid_579599
  var valid_579600 = path.getOrDefault("accountId")
  valid_579600 = validateParameter(valid_579600, JString, required = true,
                                 default = nil)
  if valid_579600 != nil:
    section.add "accountId", valid_579600
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fingerprint: JString
  ##              : When provided, this fingerprint must match the fingerprint of the container version in storage.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579601 = query.getOrDefault("key")
  valid_579601 = validateParameter(valid_579601, JString, required = false,
                                 default = nil)
  if valid_579601 != nil:
    section.add "key", valid_579601
  var valid_579602 = query.getOrDefault("prettyPrint")
  valid_579602 = validateParameter(valid_579602, JBool, required = false,
                                 default = newJBool(true))
  if valid_579602 != nil:
    section.add "prettyPrint", valid_579602
  var valid_579603 = query.getOrDefault("oauth_token")
  valid_579603 = validateParameter(valid_579603, JString, required = false,
                                 default = nil)
  if valid_579603 != nil:
    section.add "oauth_token", valid_579603
  var valid_579604 = query.getOrDefault("fingerprint")
  valid_579604 = validateParameter(valid_579604, JString, required = false,
                                 default = nil)
  if valid_579604 != nil:
    section.add "fingerprint", valid_579604
  var valid_579605 = query.getOrDefault("alt")
  valid_579605 = validateParameter(valid_579605, JString, required = false,
                                 default = newJString("json"))
  if valid_579605 != nil:
    section.add "alt", valid_579605
  var valid_579606 = query.getOrDefault("userIp")
  valid_579606 = validateParameter(valid_579606, JString, required = false,
                                 default = nil)
  if valid_579606 != nil:
    section.add "userIp", valid_579606
  var valid_579607 = query.getOrDefault("quotaUser")
  valid_579607 = validateParameter(valid_579607, JString, required = false,
                                 default = nil)
  if valid_579607 != nil:
    section.add "quotaUser", valid_579607
  var valid_579608 = query.getOrDefault("fields")
  valid_579608 = validateParameter(valid_579608, JString, required = false,
                                 default = nil)
  if valid_579608 != nil:
    section.add "fields", valid_579608
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579609: Call_TagmanagerAccountsContainersVersionsPublish_579595;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Publishes a Container Version.
  ## 
  let valid = call_579609.validator(path, query, header, formData, body)
  let scheme = call_579609.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579609.url(scheme.get, call_579609.host, call_579609.base,
                         call_579609.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579609, url, valid)

proc call*(call_579610: Call_TagmanagerAccountsContainersVersionsPublish_579595;
          containerId: string; containerVersionId: string; accountId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          fingerprint: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersVersionsPublish
  ## Publishes a Container Version.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   fingerprint: string
  ##              : When provided, this fingerprint must match the fingerprint of the container version in storage.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   containerVersionId: string (required)
  ##                     : The GTM Container Version ID.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579611 = newJObject()
  var query_579612 = newJObject()
  add(query_579612, "key", newJString(key))
  add(query_579612, "prettyPrint", newJBool(prettyPrint))
  add(query_579612, "oauth_token", newJString(oauthToken))
  add(path_579611, "containerId", newJString(containerId))
  add(query_579612, "fingerprint", newJString(fingerprint))
  add(query_579612, "alt", newJString(alt))
  add(query_579612, "userIp", newJString(userIp))
  add(query_579612, "quotaUser", newJString(quotaUser))
  add(path_579611, "containerVersionId", newJString(containerVersionId))
  add(path_579611, "accountId", newJString(accountId))
  add(query_579612, "fields", newJString(fields))
  result = call_579610.call(path_579611, query_579612, nil, nil, nil)

var tagmanagerAccountsContainersVersionsPublish* = Call_TagmanagerAccountsContainersVersionsPublish_579595(
    name: "tagmanagerAccountsContainersVersionsPublish",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/versions/{containerVersionId}/publish",
    validator: validate_TagmanagerAccountsContainersVersionsPublish_579596,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsPublish_579597,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsRestore_579613 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersVersionsRestore_579615(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersVersionsRestore_579614(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Restores a Container Version. This will overwrite the container's current configuration (including its variables, triggers and tags). The operation will not have any effect on the version that is being served (i.e. the published version).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   containerVersionId: JString (required)
  ##                     : The GTM Container Version ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_579616 = path.getOrDefault("containerId")
  valid_579616 = validateParameter(valid_579616, JString, required = true,
                                 default = nil)
  if valid_579616 != nil:
    section.add "containerId", valid_579616
  var valid_579617 = path.getOrDefault("containerVersionId")
  valid_579617 = validateParameter(valid_579617, JString, required = true,
                                 default = nil)
  if valid_579617 != nil:
    section.add "containerVersionId", valid_579617
  var valid_579618 = path.getOrDefault("accountId")
  valid_579618 = validateParameter(valid_579618, JString, required = true,
                                 default = nil)
  if valid_579618 != nil:
    section.add "accountId", valid_579618
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
  var valid_579619 = query.getOrDefault("key")
  valid_579619 = validateParameter(valid_579619, JString, required = false,
                                 default = nil)
  if valid_579619 != nil:
    section.add "key", valid_579619
  var valid_579620 = query.getOrDefault("prettyPrint")
  valid_579620 = validateParameter(valid_579620, JBool, required = false,
                                 default = newJBool(true))
  if valid_579620 != nil:
    section.add "prettyPrint", valid_579620
  var valid_579621 = query.getOrDefault("oauth_token")
  valid_579621 = validateParameter(valid_579621, JString, required = false,
                                 default = nil)
  if valid_579621 != nil:
    section.add "oauth_token", valid_579621
  var valid_579622 = query.getOrDefault("alt")
  valid_579622 = validateParameter(valid_579622, JString, required = false,
                                 default = newJString("json"))
  if valid_579622 != nil:
    section.add "alt", valid_579622
  var valid_579623 = query.getOrDefault("userIp")
  valid_579623 = validateParameter(valid_579623, JString, required = false,
                                 default = nil)
  if valid_579623 != nil:
    section.add "userIp", valid_579623
  var valid_579624 = query.getOrDefault("quotaUser")
  valid_579624 = validateParameter(valid_579624, JString, required = false,
                                 default = nil)
  if valid_579624 != nil:
    section.add "quotaUser", valid_579624
  var valid_579625 = query.getOrDefault("fields")
  valid_579625 = validateParameter(valid_579625, JString, required = false,
                                 default = nil)
  if valid_579625 != nil:
    section.add "fields", valid_579625
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579626: Call_TagmanagerAccountsContainersVersionsRestore_579613;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Restores a Container Version. This will overwrite the container's current configuration (including its variables, triggers and tags). The operation will not have any effect on the version that is being served (i.e. the published version).
  ## 
  let valid = call_579626.validator(path, query, header, formData, body)
  let scheme = call_579626.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579626.url(scheme.get, call_579626.host, call_579626.base,
                         call_579626.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579626, url, valid)

proc call*(call_579627: Call_TagmanagerAccountsContainersVersionsRestore_579613;
          containerId: string; containerVersionId: string; accountId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersVersionsRestore
  ## Restores a Container Version. This will overwrite the container's current configuration (including its variables, triggers and tags). The operation will not have any effect on the version that is being served (i.e. the published version).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   containerVersionId: string (required)
  ##                     : The GTM Container Version ID.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579628 = newJObject()
  var query_579629 = newJObject()
  add(query_579629, "key", newJString(key))
  add(query_579629, "prettyPrint", newJBool(prettyPrint))
  add(query_579629, "oauth_token", newJString(oauthToken))
  add(path_579628, "containerId", newJString(containerId))
  add(query_579629, "alt", newJString(alt))
  add(query_579629, "userIp", newJString(userIp))
  add(query_579629, "quotaUser", newJString(quotaUser))
  add(path_579628, "containerVersionId", newJString(containerVersionId))
  add(path_579628, "accountId", newJString(accountId))
  add(query_579629, "fields", newJString(fields))
  result = call_579627.call(path_579628, query_579629, nil, nil, nil)

var tagmanagerAccountsContainersVersionsRestore* = Call_TagmanagerAccountsContainersVersionsRestore_579613(
    name: "tagmanagerAccountsContainersVersionsRestore",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/versions/{containerVersionId}/restore",
    validator: validate_TagmanagerAccountsContainersVersionsRestore_579614,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsRestore_579615,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsUndelete_579630 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsContainersVersionsUndelete_579632(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersVersionsUndelete_579631(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Undeletes a Container Version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerId: JString (required)
  ##              : The GTM Container ID.
  ##   containerVersionId: JString (required)
  ##                     : The GTM Container Version ID.
  ##   accountId: JString (required)
  ##            : The GTM Account ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `containerId` field"
  var valid_579633 = path.getOrDefault("containerId")
  valid_579633 = validateParameter(valid_579633, JString, required = true,
                                 default = nil)
  if valid_579633 != nil:
    section.add "containerId", valid_579633
  var valid_579634 = path.getOrDefault("containerVersionId")
  valid_579634 = validateParameter(valid_579634, JString, required = true,
                                 default = nil)
  if valid_579634 != nil:
    section.add "containerVersionId", valid_579634
  var valid_579635 = path.getOrDefault("accountId")
  valid_579635 = validateParameter(valid_579635, JString, required = true,
                                 default = nil)
  if valid_579635 != nil:
    section.add "accountId", valid_579635
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
  var valid_579636 = query.getOrDefault("key")
  valid_579636 = validateParameter(valid_579636, JString, required = false,
                                 default = nil)
  if valid_579636 != nil:
    section.add "key", valid_579636
  var valid_579637 = query.getOrDefault("prettyPrint")
  valid_579637 = validateParameter(valid_579637, JBool, required = false,
                                 default = newJBool(true))
  if valid_579637 != nil:
    section.add "prettyPrint", valid_579637
  var valid_579638 = query.getOrDefault("oauth_token")
  valid_579638 = validateParameter(valid_579638, JString, required = false,
                                 default = nil)
  if valid_579638 != nil:
    section.add "oauth_token", valid_579638
  var valid_579639 = query.getOrDefault("alt")
  valid_579639 = validateParameter(valid_579639, JString, required = false,
                                 default = newJString("json"))
  if valid_579639 != nil:
    section.add "alt", valid_579639
  var valid_579640 = query.getOrDefault("userIp")
  valid_579640 = validateParameter(valid_579640, JString, required = false,
                                 default = nil)
  if valid_579640 != nil:
    section.add "userIp", valid_579640
  var valid_579641 = query.getOrDefault("quotaUser")
  valid_579641 = validateParameter(valid_579641, JString, required = false,
                                 default = nil)
  if valid_579641 != nil:
    section.add "quotaUser", valid_579641
  var valid_579642 = query.getOrDefault("fields")
  valid_579642 = validateParameter(valid_579642, JString, required = false,
                                 default = nil)
  if valid_579642 != nil:
    section.add "fields", valid_579642
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579643: Call_TagmanagerAccountsContainersVersionsUndelete_579630;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Undeletes a Container Version.
  ## 
  let valid = call_579643.validator(path, query, header, formData, body)
  let scheme = call_579643.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579643.url(scheme.get, call_579643.host, call_579643.base,
                         call_579643.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579643, url, valid)

proc call*(call_579644: Call_TagmanagerAccountsContainersVersionsUndelete_579630;
          containerId: string; containerVersionId: string; accountId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## tagmanagerAccountsContainersVersionsUndelete
  ## Undeletes a Container Version.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   containerId: string (required)
  ##              : The GTM Container ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   containerVersionId: string (required)
  ##                     : The GTM Container Version ID.
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579645 = newJObject()
  var query_579646 = newJObject()
  add(query_579646, "key", newJString(key))
  add(query_579646, "prettyPrint", newJBool(prettyPrint))
  add(query_579646, "oauth_token", newJString(oauthToken))
  add(path_579645, "containerId", newJString(containerId))
  add(query_579646, "alt", newJString(alt))
  add(query_579646, "userIp", newJString(userIp))
  add(query_579646, "quotaUser", newJString(quotaUser))
  add(path_579645, "containerVersionId", newJString(containerVersionId))
  add(path_579645, "accountId", newJString(accountId))
  add(query_579646, "fields", newJString(fields))
  result = call_579644.call(path_579645, query_579646, nil, nil, nil)

var tagmanagerAccountsContainersVersionsUndelete* = Call_TagmanagerAccountsContainersVersionsUndelete_579630(
    name: "tagmanagerAccountsContainersVersionsUndelete",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/versions/{containerVersionId}/undelete",
    validator: validate_TagmanagerAccountsContainersVersionsUndelete_579631,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsUndelete_579632,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsPermissionsCreate_579662 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsPermissionsCreate_579664(protocol: Scheme; host: string;
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

proc validate_TagmanagerAccountsPermissionsCreate_579663(path: JsonNode;
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
  var valid_579665 = path.getOrDefault("accountId")
  valid_579665 = validateParameter(valid_579665, JString, required = true,
                                 default = nil)
  if valid_579665 != nil:
    section.add "accountId", valid_579665
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
  var valid_579666 = query.getOrDefault("key")
  valid_579666 = validateParameter(valid_579666, JString, required = false,
                                 default = nil)
  if valid_579666 != nil:
    section.add "key", valid_579666
  var valid_579667 = query.getOrDefault("prettyPrint")
  valid_579667 = validateParameter(valid_579667, JBool, required = false,
                                 default = newJBool(true))
  if valid_579667 != nil:
    section.add "prettyPrint", valid_579667
  var valid_579668 = query.getOrDefault("oauth_token")
  valid_579668 = validateParameter(valid_579668, JString, required = false,
                                 default = nil)
  if valid_579668 != nil:
    section.add "oauth_token", valid_579668
  var valid_579669 = query.getOrDefault("alt")
  valid_579669 = validateParameter(valid_579669, JString, required = false,
                                 default = newJString("json"))
  if valid_579669 != nil:
    section.add "alt", valid_579669
  var valid_579670 = query.getOrDefault("userIp")
  valid_579670 = validateParameter(valid_579670, JString, required = false,
                                 default = nil)
  if valid_579670 != nil:
    section.add "userIp", valid_579670
  var valid_579671 = query.getOrDefault("quotaUser")
  valid_579671 = validateParameter(valid_579671, JString, required = false,
                                 default = nil)
  if valid_579671 != nil:
    section.add "quotaUser", valid_579671
  var valid_579672 = query.getOrDefault("fields")
  valid_579672 = validateParameter(valid_579672, JString, required = false,
                                 default = nil)
  if valid_579672 != nil:
    section.add "fields", valid_579672
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

proc call*(call_579674: Call_TagmanagerAccountsPermissionsCreate_579662;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a user's Account & Container Permissions.
  ## 
  let valid = call_579674.validator(path, query, header, formData, body)
  let scheme = call_579674.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579674.url(scheme.get, call_579674.host, call_579674.base,
                         call_579674.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579674, url, valid)

proc call*(call_579675: Call_TagmanagerAccountsPermissionsCreate_579662;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## tagmanagerAccountsPermissionsCreate
  ## Creates a user's Account & Container Permissions.
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
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579676 = newJObject()
  var query_579677 = newJObject()
  var body_579678 = newJObject()
  add(query_579677, "key", newJString(key))
  add(query_579677, "prettyPrint", newJBool(prettyPrint))
  add(query_579677, "oauth_token", newJString(oauthToken))
  add(query_579677, "alt", newJString(alt))
  add(query_579677, "userIp", newJString(userIp))
  add(query_579677, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579678 = body
  add(path_579676, "accountId", newJString(accountId))
  add(query_579677, "fields", newJString(fields))
  result = call_579675.call(path_579676, query_579677, nil, nil, body_579678)

var tagmanagerAccountsPermissionsCreate* = Call_TagmanagerAccountsPermissionsCreate_579662(
    name: "tagmanagerAccountsPermissionsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accounts/{accountId}/permissions",
    validator: validate_TagmanagerAccountsPermissionsCreate_579663,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsPermissionsCreate_579664,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsPermissionsList_579647 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsPermissionsList_579649(protocol: Scheme; host: string;
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

proc validate_TagmanagerAccountsPermissionsList_579648(path: JsonNode;
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
  var valid_579650 = path.getOrDefault("accountId")
  valid_579650 = validateParameter(valid_579650, JString, required = true,
                                 default = nil)
  if valid_579650 != nil:
    section.add "accountId", valid_579650
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
  var valid_579651 = query.getOrDefault("key")
  valid_579651 = validateParameter(valid_579651, JString, required = false,
                                 default = nil)
  if valid_579651 != nil:
    section.add "key", valid_579651
  var valid_579652 = query.getOrDefault("prettyPrint")
  valid_579652 = validateParameter(valid_579652, JBool, required = false,
                                 default = newJBool(true))
  if valid_579652 != nil:
    section.add "prettyPrint", valid_579652
  var valid_579653 = query.getOrDefault("oauth_token")
  valid_579653 = validateParameter(valid_579653, JString, required = false,
                                 default = nil)
  if valid_579653 != nil:
    section.add "oauth_token", valid_579653
  var valid_579654 = query.getOrDefault("alt")
  valid_579654 = validateParameter(valid_579654, JString, required = false,
                                 default = newJString("json"))
  if valid_579654 != nil:
    section.add "alt", valid_579654
  var valid_579655 = query.getOrDefault("userIp")
  valid_579655 = validateParameter(valid_579655, JString, required = false,
                                 default = nil)
  if valid_579655 != nil:
    section.add "userIp", valid_579655
  var valid_579656 = query.getOrDefault("quotaUser")
  valid_579656 = validateParameter(valid_579656, JString, required = false,
                                 default = nil)
  if valid_579656 != nil:
    section.add "quotaUser", valid_579656
  var valid_579657 = query.getOrDefault("fields")
  valid_579657 = validateParameter(valid_579657, JString, required = false,
                                 default = nil)
  if valid_579657 != nil:
    section.add "fields", valid_579657
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579658: Call_TagmanagerAccountsPermissionsList_579647;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all users that have access to the account along with Account and Container Permissions granted to each of them.
  ## 
  let valid = call_579658.validator(path, query, header, formData, body)
  let scheme = call_579658.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579658.url(scheme.get, call_579658.host, call_579658.base,
                         call_579658.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579658, url, valid)

proc call*(call_579659: Call_TagmanagerAccountsPermissionsList_579647;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## tagmanagerAccountsPermissionsList
  ## List all users that have access to the account along with Account and Container Permissions granted to each of them.
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
  ##   accountId: string (required)
  ##            : The GTM Account ID. @required tagmanager.accounts.permissions.list
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579660 = newJObject()
  var query_579661 = newJObject()
  add(query_579661, "key", newJString(key))
  add(query_579661, "prettyPrint", newJBool(prettyPrint))
  add(query_579661, "oauth_token", newJString(oauthToken))
  add(query_579661, "alt", newJString(alt))
  add(query_579661, "userIp", newJString(userIp))
  add(query_579661, "quotaUser", newJString(quotaUser))
  add(path_579660, "accountId", newJString(accountId))
  add(query_579661, "fields", newJString(fields))
  result = call_579659.call(path_579660, query_579661, nil, nil, nil)

var tagmanagerAccountsPermissionsList* = Call_TagmanagerAccountsPermissionsList_579647(
    name: "tagmanagerAccountsPermissionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/permissions",
    validator: validate_TagmanagerAccountsPermissionsList_579648,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsPermissionsList_579649,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsPermissionsUpdate_579695 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsPermissionsUpdate_579697(protocol: Scheme; host: string;
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

proc validate_TagmanagerAccountsPermissionsUpdate_579696(path: JsonNode;
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
  var valid_579698 = path.getOrDefault("accountId")
  valid_579698 = validateParameter(valid_579698, JString, required = true,
                                 default = nil)
  if valid_579698 != nil:
    section.add "accountId", valid_579698
  var valid_579699 = path.getOrDefault("permissionId")
  valid_579699 = validateParameter(valid_579699, JString, required = true,
                                 default = nil)
  if valid_579699 != nil:
    section.add "permissionId", valid_579699
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
  var valid_579700 = query.getOrDefault("key")
  valid_579700 = validateParameter(valid_579700, JString, required = false,
                                 default = nil)
  if valid_579700 != nil:
    section.add "key", valid_579700
  var valid_579701 = query.getOrDefault("prettyPrint")
  valid_579701 = validateParameter(valid_579701, JBool, required = false,
                                 default = newJBool(true))
  if valid_579701 != nil:
    section.add "prettyPrint", valid_579701
  var valid_579702 = query.getOrDefault("oauth_token")
  valid_579702 = validateParameter(valid_579702, JString, required = false,
                                 default = nil)
  if valid_579702 != nil:
    section.add "oauth_token", valid_579702
  var valid_579703 = query.getOrDefault("alt")
  valid_579703 = validateParameter(valid_579703, JString, required = false,
                                 default = newJString("json"))
  if valid_579703 != nil:
    section.add "alt", valid_579703
  var valid_579704 = query.getOrDefault("userIp")
  valid_579704 = validateParameter(valid_579704, JString, required = false,
                                 default = nil)
  if valid_579704 != nil:
    section.add "userIp", valid_579704
  var valid_579705 = query.getOrDefault("quotaUser")
  valid_579705 = validateParameter(valid_579705, JString, required = false,
                                 default = nil)
  if valid_579705 != nil:
    section.add "quotaUser", valid_579705
  var valid_579706 = query.getOrDefault("fields")
  valid_579706 = validateParameter(valid_579706, JString, required = false,
                                 default = nil)
  if valid_579706 != nil:
    section.add "fields", valid_579706
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

proc call*(call_579708: Call_TagmanagerAccountsPermissionsUpdate_579695;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a user's Account & Container Permissions.
  ## 
  let valid = call_579708.validator(path, query, header, formData, body)
  let scheme = call_579708.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579708.url(scheme.get, call_579708.host, call_579708.base,
                         call_579708.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579708, url, valid)

proc call*(call_579709: Call_TagmanagerAccountsPermissionsUpdate_579695;
          accountId: string; permissionId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## tagmanagerAccountsPermissionsUpdate
  ## Updates a user's Account & Container Permissions.
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
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   permissionId: string (required)
  ##               : The GTM User ID.
  var path_579710 = newJObject()
  var query_579711 = newJObject()
  var body_579712 = newJObject()
  add(query_579711, "key", newJString(key))
  add(query_579711, "prettyPrint", newJBool(prettyPrint))
  add(query_579711, "oauth_token", newJString(oauthToken))
  add(query_579711, "alt", newJString(alt))
  add(query_579711, "userIp", newJString(userIp))
  add(query_579711, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579712 = body
  add(path_579710, "accountId", newJString(accountId))
  add(query_579711, "fields", newJString(fields))
  add(path_579710, "permissionId", newJString(permissionId))
  result = call_579709.call(path_579710, query_579711, nil, nil, body_579712)

var tagmanagerAccountsPermissionsUpdate* = Call_TagmanagerAccountsPermissionsUpdate_579695(
    name: "tagmanagerAccountsPermissionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/permissions/{permissionId}",
    validator: validate_TagmanagerAccountsPermissionsUpdate_579696,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsPermissionsUpdate_579697,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsPermissionsGet_579679 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsPermissionsGet_579681(protocol: Scheme; host: string;
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

proc validate_TagmanagerAccountsPermissionsGet_579680(path: JsonNode;
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
  var valid_579682 = path.getOrDefault("accountId")
  valid_579682 = validateParameter(valid_579682, JString, required = true,
                                 default = nil)
  if valid_579682 != nil:
    section.add "accountId", valid_579682
  var valid_579683 = path.getOrDefault("permissionId")
  valid_579683 = validateParameter(valid_579683, JString, required = true,
                                 default = nil)
  if valid_579683 != nil:
    section.add "permissionId", valid_579683
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
  var valid_579684 = query.getOrDefault("key")
  valid_579684 = validateParameter(valid_579684, JString, required = false,
                                 default = nil)
  if valid_579684 != nil:
    section.add "key", valid_579684
  var valid_579685 = query.getOrDefault("prettyPrint")
  valid_579685 = validateParameter(valid_579685, JBool, required = false,
                                 default = newJBool(true))
  if valid_579685 != nil:
    section.add "prettyPrint", valid_579685
  var valid_579686 = query.getOrDefault("oauth_token")
  valid_579686 = validateParameter(valid_579686, JString, required = false,
                                 default = nil)
  if valid_579686 != nil:
    section.add "oauth_token", valid_579686
  var valid_579687 = query.getOrDefault("alt")
  valid_579687 = validateParameter(valid_579687, JString, required = false,
                                 default = newJString("json"))
  if valid_579687 != nil:
    section.add "alt", valid_579687
  var valid_579688 = query.getOrDefault("userIp")
  valid_579688 = validateParameter(valid_579688, JString, required = false,
                                 default = nil)
  if valid_579688 != nil:
    section.add "userIp", valid_579688
  var valid_579689 = query.getOrDefault("quotaUser")
  valid_579689 = validateParameter(valid_579689, JString, required = false,
                                 default = nil)
  if valid_579689 != nil:
    section.add "quotaUser", valid_579689
  var valid_579690 = query.getOrDefault("fields")
  valid_579690 = validateParameter(valid_579690, JString, required = false,
                                 default = nil)
  if valid_579690 != nil:
    section.add "fields", valid_579690
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579691: Call_TagmanagerAccountsPermissionsGet_579679;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a user's Account & Container Permissions.
  ## 
  let valid = call_579691.validator(path, query, header, formData, body)
  let scheme = call_579691.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579691.url(scheme.get, call_579691.host, call_579691.base,
                         call_579691.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579691, url, valid)

proc call*(call_579692: Call_TagmanagerAccountsPermissionsGet_579679;
          accountId: string; permissionId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## tagmanagerAccountsPermissionsGet
  ## Gets a user's Account & Container Permissions.
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
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   permissionId: string (required)
  ##               : The GTM User ID.
  var path_579693 = newJObject()
  var query_579694 = newJObject()
  add(query_579694, "key", newJString(key))
  add(query_579694, "prettyPrint", newJBool(prettyPrint))
  add(query_579694, "oauth_token", newJString(oauthToken))
  add(query_579694, "alt", newJString(alt))
  add(query_579694, "userIp", newJString(userIp))
  add(query_579694, "quotaUser", newJString(quotaUser))
  add(path_579693, "accountId", newJString(accountId))
  add(query_579694, "fields", newJString(fields))
  add(path_579693, "permissionId", newJString(permissionId))
  result = call_579692.call(path_579693, query_579694, nil, nil, nil)

var tagmanagerAccountsPermissionsGet* = Call_TagmanagerAccountsPermissionsGet_579679(
    name: "tagmanagerAccountsPermissionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/permissions/{permissionId}",
    validator: validate_TagmanagerAccountsPermissionsGet_579680,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsPermissionsGet_579681,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsPermissionsDelete_579713 = ref object of OpenApiRestCall_578339
proc url_TagmanagerAccountsPermissionsDelete_579715(protocol: Scheme; host: string;
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

proc validate_TagmanagerAccountsPermissionsDelete_579714(path: JsonNode;
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
  var valid_579716 = path.getOrDefault("accountId")
  valid_579716 = validateParameter(valid_579716, JString, required = true,
                                 default = nil)
  if valid_579716 != nil:
    section.add "accountId", valid_579716
  var valid_579717 = path.getOrDefault("permissionId")
  valid_579717 = validateParameter(valid_579717, JString, required = true,
                                 default = nil)
  if valid_579717 != nil:
    section.add "permissionId", valid_579717
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
  var valid_579718 = query.getOrDefault("key")
  valid_579718 = validateParameter(valid_579718, JString, required = false,
                                 default = nil)
  if valid_579718 != nil:
    section.add "key", valid_579718
  var valid_579719 = query.getOrDefault("prettyPrint")
  valid_579719 = validateParameter(valid_579719, JBool, required = false,
                                 default = newJBool(true))
  if valid_579719 != nil:
    section.add "prettyPrint", valid_579719
  var valid_579720 = query.getOrDefault("oauth_token")
  valid_579720 = validateParameter(valid_579720, JString, required = false,
                                 default = nil)
  if valid_579720 != nil:
    section.add "oauth_token", valid_579720
  var valid_579721 = query.getOrDefault("alt")
  valid_579721 = validateParameter(valid_579721, JString, required = false,
                                 default = newJString("json"))
  if valid_579721 != nil:
    section.add "alt", valid_579721
  var valid_579722 = query.getOrDefault("userIp")
  valid_579722 = validateParameter(valid_579722, JString, required = false,
                                 default = nil)
  if valid_579722 != nil:
    section.add "userIp", valid_579722
  var valid_579723 = query.getOrDefault("quotaUser")
  valid_579723 = validateParameter(valid_579723, JString, required = false,
                                 default = nil)
  if valid_579723 != nil:
    section.add "quotaUser", valid_579723
  var valid_579724 = query.getOrDefault("fields")
  valid_579724 = validateParameter(valid_579724, JString, required = false,
                                 default = nil)
  if valid_579724 != nil:
    section.add "fields", valid_579724
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579725: Call_TagmanagerAccountsPermissionsDelete_579713;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a user from the account, revoking access to it and all of its containers.
  ## 
  let valid = call_579725.validator(path, query, header, formData, body)
  let scheme = call_579725.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579725.url(scheme.get, call_579725.host, call_579725.base,
                         call_579725.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579725, url, valid)

proc call*(call_579726: Call_TagmanagerAccountsPermissionsDelete_579713;
          accountId: string; permissionId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## tagmanagerAccountsPermissionsDelete
  ## Removes a user from the account, revoking access to it and all of its containers.
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
  ##   accountId: string (required)
  ##            : The GTM Account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   permissionId: string (required)
  ##               : The GTM User ID.
  var path_579727 = newJObject()
  var query_579728 = newJObject()
  add(query_579728, "key", newJString(key))
  add(query_579728, "prettyPrint", newJBool(prettyPrint))
  add(query_579728, "oauth_token", newJString(oauthToken))
  add(query_579728, "alt", newJString(alt))
  add(query_579728, "userIp", newJString(userIp))
  add(query_579728, "quotaUser", newJString(quotaUser))
  add(path_579727, "accountId", newJString(accountId))
  add(query_579728, "fields", newJString(fields))
  add(path_579727, "permissionId", newJString(permissionId))
  result = call_579726.call(path_579727, query_579728, nil, nil, nil)

var tagmanagerAccountsPermissionsDelete* = Call_TagmanagerAccountsPermissionsDelete_579713(
    name: "tagmanagerAccountsPermissionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/permissions/{permissionId}",
    validator: validate_TagmanagerAccountsPermissionsDelete_579714,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsPermissionsDelete_579715,
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
