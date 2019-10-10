
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

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
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
  Call_TagmanagerAccountsList_588709 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsList_588711(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_TagmanagerAccountsList_588710(path: JsonNode; query: JsonNode;
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
  var valid_588823 = query.getOrDefault("fields")
  valid_588823 = validateParameter(valid_588823, JString, required = false,
                                 default = nil)
  if valid_588823 != nil:
    section.add "fields", valid_588823
  var valid_588824 = query.getOrDefault("quotaUser")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "quotaUser", valid_588824
  var valid_588838 = query.getOrDefault("alt")
  valid_588838 = validateParameter(valid_588838, JString, required = false,
                                 default = newJString("json"))
  if valid_588838 != nil:
    section.add "alt", valid_588838
  var valid_588839 = query.getOrDefault("oauth_token")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "oauth_token", valid_588839
  var valid_588840 = query.getOrDefault("userIp")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "userIp", valid_588840
  var valid_588841 = query.getOrDefault("key")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "key", valid_588841
  var valid_588842 = query.getOrDefault("prettyPrint")
  valid_588842 = validateParameter(valid_588842, JBool, required = false,
                                 default = newJBool(true))
  if valid_588842 != nil:
    section.add "prettyPrint", valid_588842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588865: Call_TagmanagerAccountsList_588709; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all GTM Accounts that a user has access to.
  ## 
  let valid = call_588865.validator(path, query, header, formData, body)
  let scheme = call_588865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588865.url(scheme.get, call_588865.host, call_588865.base,
                         call_588865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588865, url, valid)

proc call*(call_588936: Call_TagmanagerAccountsList_588709; fields: string = "";
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
  var query_588937 = newJObject()
  add(query_588937, "fields", newJString(fields))
  add(query_588937, "quotaUser", newJString(quotaUser))
  add(query_588937, "alt", newJString(alt))
  add(query_588937, "oauth_token", newJString(oauthToken))
  add(query_588937, "userIp", newJString(userIp))
  add(query_588937, "key", newJString(key))
  add(query_588937, "prettyPrint", newJBool(prettyPrint))
  result = call_588936.call(nil, query_588937, nil, nil, nil)

var tagmanagerAccountsList* = Call_TagmanagerAccountsList_588709(
    name: "tagmanagerAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts",
    validator: validate_TagmanagerAccountsList_588710, base: "/tagmanager/v1",
    url: url_TagmanagerAccountsList_588711, schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsUpdate_589006 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsUpdate_589008(protocol: Scheme; host: string;
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

proc validate_TagmanagerAccountsUpdate_589007(path: JsonNode; query: JsonNode;
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
  var valid_589009 = path.getOrDefault("accountId")
  valid_589009 = validateParameter(valid_589009, JString, required = true,
                                 default = nil)
  if valid_589009 != nil:
    section.add "accountId", valid_589009
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
  var valid_589010 = query.getOrDefault("fields")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "fields", valid_589010
  var valid_589011 = query.getOrDefault("fingerprint")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "fingerprint", valid_589011
  var valid_589012 = query.getOrDefault("quotaUser")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "quotaUser", valid_589012
  var valid_589013 = query.getOrDefault("alt")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = newJString("json"))
  if valid_589013 != nil:
    section.add "alt", valid_589013
  var valid_589014 = query.getOrDefault("oauth_token")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "oauth_token", valid_589014
  var valid_589015 = query.getOrDefault("userIp")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "userIp", valid_589015
  var valid_589016 = query.getOrDefault("key")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "key", valid_589016
  var valid_589017 = query.getOrDefault("prettyPrint")
  valid_589017 = validateParameter(valid_589017, JBool, required = false,
                                 default = newJBool(true))
  if valid_589017 != nil:
    section.add "prettyPrint", valid_589017
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

proc call*(call_589019: Call_TagmanagerAccountsUpdate_589006; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a GTM Account.
  ## 
  let valid = call_589019.validator(path, query, header, formData, body)
  let scheme = call_589019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589019.url(scheme.get, call_589019.host, call_589019.base,
                         call_589019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589019, url, valid)

proc call*(call_589020: Call_TagmanagerAccountsUpdate_589006; accountId: string;
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
  var path_589021 = newJObject()
  var query_589022 = newJObject()
  var body_589023 = newJObject()
  add(query_589022, "fields", newJString(fields))
  add(query_589022, "fingerprint", newJString(fingerprint))
  add(query_589022, "quotaUser", newJString(quotaUser))
  add(query_589022, "alt", newJString(alt))
  add(query_589022, "oauth_token", newJString(oauthToken))
  add(path_589021, "accountId", newJString(accountId))
  add(query_589022, "userIp", newJString(userIp))
  add(query_589022, "key", newJString(key))
  if body != nil:
    body_589023 = body
  add(query_589022, "prettyPrint", newJBool(prettyPrint))
  result = call_589020.call(path_589021, query_589022, nil, nil, body_589023)

var tagmanagerAccountsUpdate* = Call_TagmanagerAccountsUpdate_589006(
    name: "tagmanagerAccountsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/accounts/{accountId}",
    validator: validate_TagmanagerAccountsUpdate_589007, base: "/tagmanager/v1",
    url: url_TagmanagerAccountsUpdate_589008, schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsGet_588977 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsGet_588979(protocol: Scheme; host: string; base: string;
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

proc validate_TagmanagerAccountsGet_588978(path: JsonNode; query: JsonNode;
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
  var valid_588994 = path.getOrDefault("accountId")
  valid_588994 = validateParameter(valid_588994, JString, required = true,
                                 default = nil)
  if valid_588994 != nil:
    section.add "accountId", valid_588994
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
  var valid_588995 = query.getOrDefault("fields")
  valid_588995 = validateParameter(valid_588995, JString, required = false,
                                 default = nil)
  if valid_588995 != nil:
    section.add "fields", valid_588995
  var valid_588996 = query.getOrDefault("quotaUser")
  valid_588996 = validateParameter(valid_588996, JString, required = false,
                                 default = nil)
  if valid_588996 != nil:
    section.add "quotaUser", valid_588996
  var valid_588997 = query.getOrDefault("alt")
  valid_588997 = validateParameter(valid_588997, JString, required = false,
                                 default = newJString("json"))
  if valid_588997 != nil:
    section.add "alt", valid_588997
  var valid_588998 = query.getOrDefault("oauth_token")
  valid_588998 = validateParameter(valid_588998, JString, required = false,
                                 default = nil)
  if valid_588998 != nil:
    section.add "oauth_token", valid_588998
  var valid_588999 = query.getOrDefault("userIp")
  valid_588999 = validateParameter(valid_588999, JString, required = false,
                                 default = nil)
  if valid_588999 != nil:
    section.add "userIp", valid_588999
  var valid_589000 = query.getOrDefault("key")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = nil)
  if valid_589000 != nil:
    section.add "key", valid_589000
  var valid_589001 = query.getOrDefault("prettyPrint")
  valid_589001 = validateParameter(valid_589001, JBool, required = false,
                                 default = newJBool(true))
  if valid_589001 != nil:
    section.add "prettyPrint", valid_589001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589002: Call_TagmanagerAccountsGet_588977; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a GTM Account.
  ## 
  let valid = call_589002.validator(path, query, header, formData, body)
  let scheme = call_589002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589002.url(scheme.get, call_589002.host, call_589002.base,
                         call_589002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589002, url, valid)

proc call*(call_589003: Call_TagmanagerAccountsGet_588977; accountId: string;
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
  var path_589004 = newJObject()
  var query_589005 = newJObject()
  add(query_589005, "fields", newJString(fields))
  add(query_589005, "quotaUser", newJString(quotaUser))
  add(query_589005, "alt", newJString(alt))
  add(query_589005, "oauth_token", newJString(oauthToken))
  add(path_589004, "accountId", newJString(accountId))
  add(query_589005, "userIp", newJString(userIp))
  add(query_589005, "key", newJString(key))
  add(query_589005, "prettyPrint", newJBool(prettyPrint))
  result = call_589003.call(path_589004, query_589005, nil, nil, nil)

var tagmanagerAccountsGet* = Call_TagmanagerAccountsGet_588977(
    name: "tagmanagerAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}",
    validator: validate_TagmanagerAccountsGet_588978, base: "/tagmanager/v1",
    url: url_TagmanagerAccountsGet_588979, schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersCreate_589039 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersCreate_589041(protocol: Scheme; host: string;
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

proc validate_TagmanagerAccountsContainersCreate_589040(path: JsonNode;
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
  var valid_589042 = path.getOrDefault("accountId")
  valid_589042 = validateParameter(valid_589042, JString, required = true,
                                 default = nil)
  if valid_589042 != nil:
    section.add "accountId", valid_589042
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
  var valid_589043 = query.getOrDefault("fields")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "fields", valid_589043
  var valid_589044 = query.getOrDefault("quotaUser")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "quotaUser", valid_589044
  var valid_589045 = query.getOrDefault("alt")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = newJString("json"))
  if valid_589045 != nil:
    section.add "alt", valid_589045
  var valid_589046 = query.getOrDefault("oauth_token")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "oauth_token", valid_589046
  var valid_589047 = query.getOrDefault("userIp")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "userIp", valid_589047
  var valid_589048 = query.getOrDefault("key")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "key", valid_589048
  var valid_589049 = query.getOrDefault("prettyPrint")
  valid_589049 = validateParameter(valid_589049, JBool, required = false,
                                 default = newJBool(true))
  if valid_589049 != nil:
    section.add "prettyPrint", valid_589049
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

proc call*(call_589051: Call_TagmanagerAccountsContainersCreate_589039;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Container.
  ## 
  let valid = call_589051.validator(path, query, header, formData, body)
  let scheme = call_589051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589051.url(scheme.get, call_589051.host, call_589051.base,
                         call_589051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589051, url, valid)

proc call*(call_589052: Call_TagmanagerAccountsContainersCreate_589039;
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
  var path_589053 = newJObject()
  var query_589054 = newJObject()
  var body_589055 = newJObject()
  add(query_589054, "fields", newJString(fields))
  add(query_589054, "quotaUser", newJString(quotaUser))
  add(query_589054, "alt", newJString(alt))
  add(query_589054, "oauth_token", newJString(oauthToken))
  add(path_589053, "accountId", newJString(accountId))
  add(query_589054, "userIp", newJString(userIp))
  add(query_589054, "key", newJString(key))
  if body != nil:
    body_589055 = body
  add(query_589054, "prettyPrint", newJBool(prettyPrint))
  result = call_589052.call(path_589053, query_589054, nil, nil, body_589055)

var tagmanagerAccountsContainersCreate* = Call_TagmanagerAccountsContainersCreate_589039(
    name: "tagmanagerAccountsContainersCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers",
    validator: validate_TagmanagerAccountsContainersCreate_589040,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersCreate_589041,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersList_589024 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersList_589026(protocol: Scheme; host: string;
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

proc validate_TagmanagerAccountsContainersList_589025(path: JsonNode;
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
  var valid_589027 = path.getOrDefault("accountId")
  valid_589027 = validateParameter(valid_589027, JString, required = true,
                                 default = nil)
  if valid_589027 != nil:
    section.add "accountId", valid_589027
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
  var valid_589028 = query.getOrDefault("fields")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "fields", valid_589028
  var valid_589029 = query.getOrDefault("quotaUser")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "quotaUser", valid_589029
  var valid_589030 = query.getOrDefault("alt")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = newJString("json"))
  if valid_589030 != nil:
    section.add "alt", valid_589030
  var valid_589031 = query.getOrDefault("oauth_token")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "oauth_token", valid_589031
  var valid_589032 = query.getOrDefault("userIp")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "userIp", valid_589032
  var valid_589033 = query.getOrDefault("key")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "key", valid_589033
  var valid_589034 = query.getOrDefault("prettyPrint")
  valid_589034 = validateParameter(valid_589034, JBool, required = false,
                                 default = newJBool(true))
  if valid_589034 != nil:
    section.add "prettyPrint", valid_589034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589035: Call_TagmanagerAccountsContainersList_589024;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all Containers that belongs to a GTM Account.
  ## 
  let valid = call_589035.validator(path, query, header, formData, body)
  let scheme = call_589035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589035.url(scheme.get, call_589035.host, call_589035.base,
                         call_589035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589035, url, valid)

proc call*(call_589036: Call_TagmanagerAccountsContainersList_589024;
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
  var path_589037 = newJObject()
  var query_589038 = newJObject()
  add(query_589038, "fields", newJString(fields))
  add(query_589038, "quotaUser", newJString(quotaUser))
  add(query_589038, "alt", newJString(alt))
  add(query_589038, "oauth_token", newJString(oauthToken))
  add(path_589037, "accountId", newJString(accountId))
  add(query_589038, "userIp", newJString(userIp))
  add(query_589038, "key", newJString(key))
  add(query_589038, "prettyPrint", newJBool(prettyPrint))
  result = call_589036.call(path_589037, query_589038, nil, nil, nil)

var tagmanagerAccountsContainersList* = Call_TagmanagerAccountsContainersList_589024(
    name: "tagmanagerAccountsContainersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers",
    validator: validate_TagmanagerAccountsContainersList_589025,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersList_589026,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersUpdate_589072 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersUpdate_589074(protocol: Scheme; host: string;
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

proc validate_TagmanagerAccountsContainersUpdate_589073(path: JsonNode;
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
  var valid_589075 = path.getOrDefault("containerId")
  valid_589075 = validateParameter(valid_589075, JString, required = true,
                                 default = nil)
  if valid_589075 != nil:
    section.add "containerId", valid_589075
  var valid_589076 = path.getOrDefault("accountId")
  valid_589076 = validateParameter(valid_589076, JString, required = true,
                                 default = nil)
  if valid_589076 != nil:
    section.add "accountId", valid_589076
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
  var valid_589077 = query.getOrDefault("fields")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "fields", valid_589077
  var valid_589078 = query.getOrDefault("fingerprint")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "fingerprint", valid_589078
  var valid_589079 = query.getOrDefault("quotaUser")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "quotaUser", valid_589079
  var valid_589080 = query.getOrDefault("alt")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = newJString("json"))
  if valid_589080 != nil:
    section.add "alt", valid_589080
  var valid_589081 = query.getOrDefault("oauth_token")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "oauth_token", valid_589081
  var valid_589082 = query.getOrDefault("userIp")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "userIp", valid_589082
  var valid_589083 = query.getOrDefault("key")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "key", valid_589083
  var valid_589084 = query.getOrDefault("prettyPrint")
  valid_589084 = validateParameter(valid_589084, JBool, required = false,
                                 default = newJBool(true))
  if valid_589084 != nil:
    section.add "prettyPrint", valid_589084
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

proc call*(call_589086: Call_TagmanagerAccountsContainersUpdate_589072;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a Container.
  ## 
  let valid = call_589086.validator(path, query, header, formData, body)
  let scheme = call_589086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589086.url(scheme.get, call_589086.host, call_589086.base,
                         call_589086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589086, url, valid)

proc call*(call_589087: Call_TagmanagerAccountsContainersUpdate_589072;
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
  var path_589088 = newJObject()
  var query_589089 = newJObject()
  var body_589090 = newJObject()
  add(path_589088, "containerId", newJString(containerId))
  add(query_589089, "fields", newJString(fields))
  add(query_589089, "fingerprint", newJString(fingerprint))
  add(query_589089, "quotaUser", newJString(quotaUser))
  add(query_589089, "alt", newJString(alt))
  add(query_589089, "oauth_token", newJString(oauthToken))
  add(path_589088, "accountId", newJString(accountId))
  add(query_589089, "userIp", newJString(userIp))
  add(query_589089, "key", newJString(key))
  if body != nil:
    body_589090 = body
  add(query_589089, "prettyPrint", newJBool(prettyPrint))
  result = call_589087.call(path_589088, query_589089, nil, nil, body_589090)

var tagmanagerAccountsContainersUpdate* = Call_TagmanagerAccountsContainersUpdate_589072(
    name: "tagmanagerAccountsContainersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}",
    validator: validate_TagmanagerAccountsContainersUpdate_589073,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersUpdate_589074,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersGet_589056 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersGet_589058(protocol: Scheme; host: string;
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

proc validate_TagmanagerAccountsContainersGet_589057(path: JsonNode;
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
  var valid_589059 = path.getOrDefault("containerId")
  valid_589059 = validateParameter(valid_589059, JString, required = true,
                                 default = nil)
  if valid_589059 != nil:
    section.add "containerId", valid_589059
  var valid_589060 = path.getOrDefault("accountId")
  valid_589060 = validateParameter(valid_589060, JString, required = true,
                                 default = nil)
  if valid_589060 != nil:
    section.add "accountId", valid_589060
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
  var valid_589061 = query.getOrDefault("fields")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "fields", valid_589061
  var valid_589062 = query.getOrDefault("quotaUser")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "quotaUser", valid_589062
  var valid_589063 = query.getOrDefault("alt")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = newJString("json"))
  if valid_589063 != nil:
    section.add "alt", valid_589063
  var valid_589064 = query.getOrDefault("oauth_token")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "oauth_token", valid_589064
  var valid_589065 = query.getOrDefault("userIp")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "userIp", valid_589065
  var valid_589066 = query.getOrDefault("key")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "key", valid_589066
  var valid_589067 = query.getOrDefault("prettyPrint")
  valid_589067 = validateParameter(valid_589067, JBool, required = false,
                                 default = newJBool(true))
  if valid_589067 != nil:
    section.add "prettyPrint", valid_589067
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589068: Call_TagmanagerAccountsContainersGet_589056;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a Container.
  ## 
  let valid = call_589068.validator(path, query, header, formData, body)
  let scheme = call_589068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589068.url(scheme.get, call_589068.host, call_589068.base,
                         call_589068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589068, url, valid)

proc call*(call_589069: Call_TagmanagerAccountsContainersGet_589056;
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
  var path_589070 = newJObject()
  var query_589071 = newJObject()
  add(path_589070, "containerId", newJString(containerId))
  add(query_589071, "fields", newJString(fields))
  add(query_589071, "quotaUser", newJString(quotaUser))
  add(query_589071, "alt", newJString(alt))
  add(query_589071, "oauth_token", newJString(oauthToken))
  add(path_589070, "accountId", newJString(accountId))
  add(query_589071, "userIp", newJString(userIp))
  add(query_589071, "key", newJString(key))
  add(query_589071, "prettyPrint", newJBool(prettyPrint))
  result = call_589069.call(path_589070, query_589071, nil, nil, nil)

var tagmanagerAccountsContainersGet* = Call_TagmanagerAccountsContainersGet_589056(
    name: "tagmanagerAccountsContainersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}",
    validator: validate_TagmanagerAccountsContainersGet_589057,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersGet_589058,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersDelete_589091 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersDelete_589093(protocol: Scheme; host: string;
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

proc validate_TagmanagerAccountsContainersDelete_589092(path: JsonNode;
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
  var valid_589094 = path.getOrDefault("containerId")
  valid_589094 = validateParameter(valid_589094, JString, required = true,
                                 default = nil)
  if valid_589094 != nil:
    section.add "containerId", valid_589094
  var valid_589095 = path.getOrDefault("accountId")
  valid_589095 = validateParameter(valid_589095, JString, required = true,
                                 default = nil)
  if valid_589095 != nil:
    section.add "accountId", valid_589095
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
  var valid_589096 = query.getOrDefault("fields")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "fields", valid_589096
  var valid_589097 = query.getOrDefault("quotaUser")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "quotaUser", valid_589097
  var valid_589098 = query.getOrDefault("alt")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = newJString("json"))
  if valid_589098 != nil:
    section.add "alt", valid_589098
  var valid_589099 = query.getOrDefault("oauth_token")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "oauth_token", valid_589099
  var valid_589100 = query.getOrDefault("userIp")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "userIp", valid_589100
  var valid_589101 = query.getOrDefault("key")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "key", valid_589101
  var valid_589102 = query.getOrDefault("prettyPrint")
  valid_589102 = validateParameter(valid_589102, JBool, required = false,
                                 default = newJBool(true))
  if valid_589102 != nil:
    section.add "prettyPrint", valid_589102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589103: Call_TagmanagerAccountsContainersDelete_589091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a Container.
  ## 
  let valid = call_589103.validator(path, query, header, formData, body)
  let scheme = call_589103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589103.url(scheme.get, call_589103.host, call_589103.base,
                         call_589103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589103, url, valid)

proc call*(call_589104: Call_TagmanagerAccountsContainersDelete_589091;
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
  var path_589105 = newJObject()
  var query_589106 = newJObject()
  add(path_589105, "containerId", newJString(containerId))
  add(query_589106, "fields", newJString(fields))
  add(query_589106, "quotaUser", newJString(quotaUser))
  add(query_589106, "alt", newJString(alt))
  add(query_589106, "oauth_token", newJString(oauthToken))
  add(path_589105, "accountId", newJString(accountId))
  add(query_589106, "userIp", newJString(userIp))
  add(query_589106, "key", newJString(key))
  add(query_589106, "prettyPrint", newJBool(prettyPrint))
  result = call_589104.call(path_589105, query_589106, nil, nil, nil)

var tagmanagerAccountsContainersDelete* = Call_TagmanagerAccountsContainersDelete_589091(
    name: "tagmanagerAccountsContainersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}",
    validator: validate_TagmanagerAccountsContainersDelete_589092,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersDelete_589093,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersEnvironmentsCreate_589123 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersEnvironmentsCreate_589125(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersEnvironmentsCreate_589124(
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
  var valid_589126 = path.getOrDefault("containerId")
  valid_589126 = validateParameter(valid_589126, JString, required = true,
                                 default = nil)
  if valid_589126 != nil:
    section.add "containerId", valid_589126
  var valid_589127 = path.getOrDefault("accountId")
  valid_589127 = validateParameter(valid_589127, JString, required = true,
                                 default = nil)
  if valid_589127 != nil:
    section.add "accountId", valid_589127
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
  var valid_589128 = query.getOrDefault("fields")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "fields", valid_589128
  var valid_589129 = query.getOrDefault("quotaUser")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "quotaUser", valid_589129
  var valid_589130 = query.getOrDefault("alt")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = newJString("json"))
  if valid_589130 != nil:
    section.add "alt", valid_589130
  var valid_589131 = query.getOrDefault("oauth_token")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "oauth_token", valid_589131
  var valid_589132 = query.getOrDefault("userIp")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "userIp", valid_589132
  var valid_589133 = query.getOrDefault("key")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "key", valid_589133
  var valid_589134 = query.getOrDefault("prettyPrint")
  valid_589134 = validateParameter(valid_589134, JBool, required = false,
                                 default = newJBool(true))
  if valid_589134 != nil:
    section.add "prettyPrint", valid_589134
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

proc call*(call_589136: Call_TagmanagerAccountsContainersEnvironmentsCreate_589123;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a GTM Environment.
  ## 
  let valid = call_589136.validator(path, query, header, formData, body)
  let scheme = call_589136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589136.url(scheme.get, call_589136.host, call_589136.base,
                         call_589136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589136, url, valid)

proc call*(call_589137: Call_TagmanagerAccountsContainersEnvironmentsCreate_589123;
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
  var path_589138 = newJObject()
  var query_589139 = newJObject()
  var body_589140 = newJObject()
  add(path_589138, "containerId", newJString(containerId))
  add(query_589139, "fields", newJString(fields))
  add(query_589139, "quotaUser", newJString(quotaUser))
  add(query_589139, "alt", newJString(alt))
  add(query_589139, "oauth_token", newJString(oauthToken))
  add(path_589138, "accountId", newJString(accountId))
  add(query_589139, "userIp", newJString(userIp))
  add(query_589139, "key", newJString(key))
  if body != nil:
    body_589140 = body
  add(query_589139, "prettyPrint", newJBool(prettyPrint))
  result = call_589137.call(path_589138, query_589139, nil, nil, body_589140)

var tagmanagerAccountsContainersEnvironmentsCreate* = Call_TagmanagerAccountsContainersEnvironmentsCreate_589123(
    name: "tagmanagerAccountsContainersEnvironmentsCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/environments",
    validator: validate_TagmanagerAccountsContainersEnvironmentsCreate_589124,
    base: "/tagmanager/v1",
    url: url_TagmanagerAccountsContainersEnvironmentsCreate_589125,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersEnvironmentsList_589107 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersEnvironmentsList_589109(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersEnvironmentsList_589108(path: JsonNode;
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
  var valid_589110 = path.getOrDefault("containerId")
  valid_589110 = validateParameter(valid_589110, JString, required = true,
                                 default = nil)
  if valid_589110 != nil:
    section.add "containerId", valid_589110
  var valid_589111 = path.getOrDefault("accountId")
  valid_589111 = validateParameter(valid_589111, JString, required = true,
                                 default = nil)
  if valid_589111 != nil:
    section.add "accountId", valid_589111
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
  var valid_589112 = query.getOrDefault("fields")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "fields", valid_589112
  var valid_589113 = query.getOrDefault("quotaUser")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "quotaUser", valid_589113
  var valid_589114 = query.getOrDefault("alt")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = newJString("json"))
  if valid_589114 != nil:
    section.add "alt", valid_589114
  var valid_589115 = query.getOrDefault("oauth_token")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "oauth_token", valid_589115
  var valid_589116 = query.getOrDefault("userIp")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "userIp", valid_589116
  var valid_589117 = query.getOrDefault("key")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "key", valid_589117
  var valid_589118 = query.getOrDefault("prettyPrint")
  valid_589118 = validateParameter(valid_589118, JBool, required = false,
                                 default = newJBool(true))
  if valid_589118 != nil:
    section.add "prettyPrint", valid_589118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589119: Call_TagmanagerAccountsContainersEnvironmentsList_589107;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all GTM Environments of a GTM Container.
  ## 
  let valid = call_589119.validator(path, query, header, formData, body)
  let scheme = call_589119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589119.url(scheme.get, call_589119.host, call_589119.base,
                         call_589119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589119, url, valid)

proc call*(call_589120: Call_TagmanagerAccountsContainersEnvironmentsList_589107;
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
  var path_589121 = newJObject()
  var query_589122 = newJObject()
  add(path_589121, "containerId", newJString(containerId))
  add(query_589122, "fields", newJString(fields))
  add(query_589122, "quotaUser", newJString(quotaUser))
  add(query_589122, "alt", newJString(alt))
  add(query_589122, "oauth_token", newJString(oauthToken))
  add(path_589121, "accountId", newJString(accountId))
  add(query_589122, "userIp", newJString(userIp))
  add(query_589122, "key", newJString(key))
  add(query_589122, "prettyPrint", newJBool(prettyPrint))
  result = call_589120.call(path_589121, query_589122, nil, nil, nil)

var tagmanagerAccountsContainersEnvironmentsList* = Call_TagmanagerAccountsContainersEnvironmentsList_589107(
    name: "tagmanagerAccountsContainersEnvironmentsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/environments",
    validator: validate_TagmanagerAccountsContainersEnvironmentsList_589108,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersEnvironmentsList_589109,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersEnvironmentsUpdate_589158 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersEnvironmentsUpdate_589160(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersEnvironmentsUpdate_589159(
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
  var valid_589161 = path.getOrDefault("containerId")
  valid_589161 = validateParameter(valid_589161, JString, required = true,
                                 default = nil)
  if valid_589161 != nil:
    section.add "containerId", valid_589161
  var valid_589162 = path.getOrDefault("accountId")
  valid_589162 = validateParameter(valid_589162, JString, required = true,
                                 default = nil)
  if valid_589162 != nil:
    section.add "accountId", valid_589162
  var valid_589163 = path.getOrDefault("environmentId")
  valid_589163 = validateParameter(valid_589163, JString, required = true,
                                 default = nil)
  if valid_589163 != nil:
    section.add "environmentId", valid_589163
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
  var valid_589164 = query.getOrDefault("fields")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "fields", valid_589164
  var valid_589165 = query.getOrDefault("fingerprint")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "fingerprint", valid_589165
  var valid_589166 = query.getOrDefault("quotaUser")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "quotaUser", valid_589166
  var valid_589167 = query.getOrDefault("alt")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = newJString("json"))
  if valid_589167 != nil:
    section.add "alt", valid_589167
  var valid_589168 = query.getOrDefault("oauth_token")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "oauth_token", valid_589168
  var valid_589169 = query.getOrDefault("userIp")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "userIp", valid_589169
  var valid_589170 = query.getOrDefault("key")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "key", valid_589170
  var valid_589171 = query.getOrDefault("prettyPrint")
  valid_589171 = validateParameter(valid_589171, JBool, required = false,
                                 default = newJBool(true))
  if valid_589171 != nil:
    section.add "prettyPrint", valid_589171
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

proc call*(call_589173: Call_TagmanagerAccountsContainersEnvironmentsUpdate_589158;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a GTM Environment.
  ## 
  let valid = call_589173.validator(path, query, header, formData, body)
  let scheme = call_589173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589173.url(scheme.get, call_589173.host, call_589173.base,
                         call_589173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589173, url, valid)

proc call*(call_589174: Call_TagmanagerAccountsContainersEnvironmentsUpdate_589158;
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
  var path_589175 = newJObject()
  var query_589176 = newJObject()
  var body_589177 = newJObject()
  add(path_589175, "containerId", newJString(containerId))
  add(query_589176, "fields", newJString(fields))
  add(query_589176, "fingerprint", newJString(fingerprint))
  add(query_589176, "quotaUser", newJString(quotaUser))
  add(query_589176, "alt", newJString(alt))
  add(query_589176, "oauth_token", newJString(oauthToken))
  add(path_589175, "accountId", newJString(accountId))
  add(query_589176, "userIp", newJString(userIp))
  add(query_589176, "key", newJString(key))
  add(path_589175, "environmentId", newJString(environmentId))
  if body != nil:
    body_589177 = body
  add(query_589176, "prettyPrint", newJBool(prettyPrint))
  result = call_589174.call(path_589175, query_589176, nil, nil, body_589177)

var tagmanagerAccountsContainersEnvironmentsUpdate* = Call_TagmanagerAccountsContainersEnvironmentsUpdate_589158(
    name: "tagmanagerAccountsContainersEnvironmentsUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/environments/{environmentId}",
    validator: validate_TagmanagerAccountsContainersEnvironmentsUpdate_589159,
    base: "/tagmanager/v1",
    url: url_TagmanagerAccountsContainersEnvironmentsUpdate_589160,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersEnvironmentsGet_589141 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersEnvironmentsGet_589143(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersEnvironmentsGet_589142(path: JsonNode;
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
  var valid_589144 = path.getOrDefault("containerId")
  valid_589144 = validateParameter(valid_589144, JString, required = true,
                                 default = nil)
  if valid_589144 != nil:
    section.add "containerId", valid_589144
  var valid_589145 = path.getOrDefault("accountId")
  valid_589145 = validateParameter(valid_589145, JString, required = true,
                                 default = nil)
  if valid_589145 != nil:
    section.add "accountId", valid_589145
  var valid_589146 = path.getOrDefault("environmentId")
  valid_589146 = validateParameter(valid_589146, JString, required = true,
                                 default = nil)
  if valid_589146 != nil:
    section.add "environmentId", valid_589146
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
  var valid_589147 = query.getOrDefault("fields")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "fields", valid_589147
  var valid_589148 = query.getOrDefault("quotaUser")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "quotaUser", valid_589148
  var valid_589149 = query.getOrDefault("alt")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = newJString("json"))
  if valid_589149 != nil:
    section.add "alt", valid_589149
  var valid_589150 = query.getOrDefault("oauth_token")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "oauth_token", valid_589150
  var valid_589151 = query.getOrDefault("userIp")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "userIp", valid_589151
  var valid_589152 = query.getOrDefault("key")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "key", valid_589152
  var valid_589153 = query.getOrDefault("prettyPrint")
  valid_589153 = validateParameter(valid_589153, JBool, required = false,
                                 default = newJBool(true))
  if valid_589153 != nil:
    section.add "prettyPrint", valid_589153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589154: Call_TagmanagerAccountsContainersEnvironmentsGet_589141;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a GTM Environment.
  ## 
  let valid = call_589154.validator(path, query, header, formData, body)
  let scheme = call_589154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589154.url(scheme.get, call_589154.host, call_589154.base,
                         call_589154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589154, url, valid)

proc call*(call_589155: Call_TagmanagerAccountsContainersEnvironmentsGet_589141;
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
  var path_589156 = newJObject()
  var query_589157 = newJObject()
  add(path_589156, "containerId", newJString(containerId))
  add(query_589157, "fields", newJString(fields))
  add(query_589157, "quotaUser", newJString(quotaUser))
  add(query_589157, "alt", newJString(alt))
  add(query_589157, "oauth_token", newJString(oauthToken))
  add(path_589156, "accountId", newJString(accountId))
  add(query_589157, "userIp", newJString(userIp))
  add(query_589157, "key", newJString(key))
  add(path_589156, "environmentId", newJString(environmentId))
  add(query_589157, "prettyPrint", newJBool(prettyPrint))
  result = call_589155.call(path_589156, query_589157, nil, nil, nil)

var tagmanagerAccountsContainersEnvironmentsGet* = Call_TagmanagerAccountsContainersEnvironmentsGet_589141(
    name: "tagmanagerAccountsContainersEnvironmentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/environments/{environmentId}",
    validator: validate_TagmanagerAccountsContainersEnvironmentsGet_589142,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersEnvironmentsGet_589143,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersEnvironmentsDelete_589178 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersEnvironmentsDelete_589180(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersEnvironmentsDelete_589179(
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
  var valid_589181 = path.getOrDefault("containerId")
  valid_589181 = validateParameter(valid_589181, JString, required = true,
                                 default = nil)
  if valid_589181 != nil:
    section.add "containerId", valid_589181
  var valid_589182 = path.getOrDefault("accountId")
  valid_589182 = validateParameter(valid_589182, JString, required = true,
                                 default = nil)
  if valid_589182 != nil:
    section.add "accountId", valid_589182
  var valid_589183 = path.getOrDefault("environmentId")
  valid_589183 = validateParameter(valid_589183, JString, required = true,
                                 default = nil)
  if valid_589183 != nil:
    section.add "environmentId", valid_589183
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
  var valid_589184 = query.getOrDefault("fields")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "fields", valid_589184
  var valid_589185 = query.getOrDefault("quotaUser")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "quotaUser", valid_589185
  var valid_589186 = query.getOrDefault("alt")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = newJString("json"))
  if valid_589186 != nil:
    section.add "alt", valid_589186
  var valid_589187 = query.getOrDefault("oauth_token")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = nil)
  if valid_589187 != nil:
    section.add "oauth_token", valid_589187
  var valid_589188 = query.getOrDefault("userIp")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "userIp", valid_589188
  var valid_589189 = query.getOrDefault("key")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "key", valid_589189
  var valid_589190 = query.getOrDefault("prettyPrint")
  valid_589190 = validateParameter(valid_589190, JBool, required = false,
                                 default = newJBool(true))
  if valid_589190 != nil:
    section.add "prettyPrint", valid_589190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589191: Call_TagmanagerAccountsContainersEnvironmentsDelete_589178;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a GTM Environment.
  ## 
  let valid = call_589191.validator(path, query, header, formData, body)
  let scheme = call_589191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589191.url(scheme.get, call_589191.host, call_589191.base,
                         call_589191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589191, url, valid)

proc call*(call_589192: Call_TagmanagerAccountsContainersEnvironmentsDelete_589178;
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
  var path_589193 = newJObject()
  var query_589194 = newJObject()
  add(path_589193, "containerId", newJString(containerId))
  add(query_589194, "fields", newJString(fields))
  add(query_589194, "quotaUser", newJString(quotaUser))
  add(query_589194, "alt", newJString(alt))
  add(query_589194, "oauth_token", newJString(oauthToken))
  add(path_589193, "accountId", newJString(accountId))
  add(query_589194, "userIp", newJString(userIp))
  add(query_589194, "key", newJString(key))
  add(path_589193, "environmentId", newJString(environmentId))
  add(query_589194, "prettyPrint", newJBool(prettyPrint))
  result = call_589192.call(path_589193, query_589194, nil, nil, nil)

var tagmanagerAccountsContainersEnvironmentsDelete* = Call_TagmanagerAccountsContainersEnvironmentsDelete_589178(
    name: "tagmanagerAccountsContainersEnvironmentsDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/environments/{environmentId}",
    validator: validate_TagmanagerAccountsContainersEnvironmentsDelete_589179,
    base: "/tagmanager/v1",
    url: url_TagmanagerAccountsContainersEnvironmentsDelete_589180,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersFoldersCreate_589211 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersFoldersCreate_589213(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersFoldersCreate_589212(path: JsonNode;
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
  var valid_589214 = path.getOrDefault("containerId")
  valid_589214 = validateParameter(valid_589214, JString, required = true,
                                 default = nil)
  if valid_589214 != nil:
    section.add "containerId", valid_589214
  var valid_589215 = path.getOrDefault("accountId")
  valid_589215 = validateParameter(valid_589215, JString, required = true,
                                 default = nil)
  if valid_589215 != nil:
    section.add "accountId", valid_589215
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
  var valid_589216 = query.getOrDefault("fields")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "fields", valid_589216
  var valid_589217 = query.getOrDefault("quotaUser")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "quotaUser", valid_589217
  var valid_589218 = query.getOrDefault("alt")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = newJString("json"))
  if valid_589218 != nil:
    section.add "alt", valid_589218
  var valid_589219 = query.getOrDefault("oauth_token")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "oauth_token", valid_589219
  var valid_589220 = query.getOrDefault("userIp")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "userIp", valid_589220
  var valid_589221 = query.getOrDefault("key")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "key", valid_589221
  var valid_589222 = query.getOrDefault("prettyPrint")
  valid_589222 = validateParameter(valid_589222, JBool, required = false,
                                 default = newJBool(true))
  if valid_589222 != nil:
    section.add "prettyPrint", valid_589222
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

proc call*(call_589224: Call_TagmanagerAccountsContainersFoldersCreate_589211;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a GTM Folder.
  ## 
  let valid = call_589224.validator(path, query, header, formData, body)
  let scheme = call_589224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589224.url(scheme.get, call_589224.host, call_589224.base,
                         call_589224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589224, url, valid)

proc call*(call_589225: Call_TagmanagerAccountsContainersFoldersCreate_589211;
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
  var path_589226 = newJObject()
  var query_589227 = newJObject()
  var body_589228 = newJObject()
  add(path_589226, "containerId", newJString(containerId))
  add(query_589227, "fields", newJString(fields))
  add(query_589227, "quotaUser", newJString(quotaUser))
  add(query_589227, "alt", newJString(alt))
  add(query_589227, "oauth_token", newJString(oauthToken))
  add(path_589226, "accountId", newJString(accountId))
  add(query_589227, "userIp", newJString(userIp))
  add(query_589227, "key", newJString(key))
  if body != nil:
    body_589228 = body
  add(query_589227, "prettyPrint", newJBool(prettyPrint))
  result = call_589225.call(path_589226, query_589227, nil, nil, body_589228)

var tagmanagerAccountsContainersFoldersCreate* = Call_TagmanagerAccountsContainersFoldersCreate_589211(
    name: "tagmanagerAccountsContainersFoldersCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/folders",
    validator: validate_TagmanagerAccountsContainersFoldersCreate_589212,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersFoldersCreate_589213,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersFoldersList_589195 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersFoldersList_589197(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersFoldersList_589196(path: JsonNode;
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
  var valid_589198 = path.getOrDefault("containerId")
  valid_589198 = validateParameter(valid_589198, JString, required = true,
                                 default = nil)
  if valid_589198 != nil:
    section.add "containerId", valid_589198
  var valid_589199 = path.getOrDefault("accountId")
  valid_589199 = validateParameter(valid_589199, JString, required = true,
                                 default = nil)
  if valid_589199 != nil:
    section.add "accountId", valid_589199
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
  var valid_589200 = query.getOrDefault("fields")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "fields", valid_589200
  var valid_589201 = query.getOrDefault("quotaUser")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "quotaUser", valid_589201
  var valid_589202 = query.getOrDefault("alt")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = newJString("json"))
  if valid_589202 != nil:
    section.add "alt", valid_589202
  var valid_589203 = query.getOrDefault("oauth_token")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "oauth_token", valid_589203
  var valid_589204 = query.getOrDefault("userIp")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "userIp", valid_589204
  var valid_589205 = query.getOrDefault("key")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = nil)
  if valid_589205 != nil:
    section.add "key", valid_589205
  var valid_589206 = query.getOrDefault("prettyPrint")
  valid_589206 = validateParameter(valid_589206, JBool, required = false,
                                 default = newJBool(true))
  if valid_589206 != nil:
    section.add "prettyPrint", valid_589206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589207: Call_TagmanagerAccountsContainersFoldersList_589195;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all GTM Folders of a Container.
  ## 
  let valid = call_589207.validator(path, query, header, formData, body)
  let scheme = call_589207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589207.url(scheme.get, call_589207.host, call_589207.base,
                         call_589207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589207, url, valid)

proc call*(call_589208: Call_TagmanagerAccountsContainersFoldersList_589195;
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
  var path_589209 = newJObject()
  var query_589210 = newJObject()
  add(path_589209, "containerId", newJString(containerId))
  add(query_589210, "fields", newJString(fields))
  add(query_589210, "quotaUser", newJString(quotaUser))
  add(query_589210, "alt", newJString(alt))
  add(query_589210, "oauth_token", newJString(oauthToken))
  add(path_589209, "accountId", newJString(accountId))
  add(query_589210, "userIp", newJString(userIp))
  add(query_589210, "key", newJString(key))
  add(query_589210, "prettyPrint", newJBool(prettyPrint))
  result = call_589208.call(path_589209, query_589210, nil, nil, nil)

var tagmanagerAccountsContainersFoldersList* = Call_TagmanagerAccountsContainersFoldersList_589195(
    name: "tagmanagerAccountsContainersFoldersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/folders",
    validator: validate_TagmanagerAccountsContainersFoldersList_589196,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersFoldersList_589197,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersFoldersUpdate_589246 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersFoldersUpdate_589248(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersFoldersUpdate_589247(path: JsonNode;
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
  var valid_589249 = path.getOrDefault("containerId")
  valid_589249 = validateParameter(valid_589249, JString, required = true,
                                 default = nil)
  if valid_589249 != nil:
    section.add "containerId", valid_589249
  var valid_589250 = path.getOrDefault("accountId")
  valid_589250 = validateParameter(valid_589250, JString, required = true,
                                 default = nil)
  if valid_589250 != nil:
    section.add "accountId", valid_589250
  var valid_589251 = path.getOrDefault("folderId")
  valid_589251 = validateParameter(valid_589251, JString, required = true,
                                 default = nil)
  if valid_589251 != nil:
    section.add "folderId", valid_589251
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
  var valid_589252 = query.getOrDefault("fields")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = nil)
  if valid_589252 != nil:
    section.add "fields", valid_589252
  var valid_589253 = query.getOrDefault("fingerprint")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = nil)
  if valid_589253 != nil:
    section.add "fingerprint", valid_589253
  var valid_589254 = query.getOrDefault("quotaUser")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = nil)
  if valid_589254 != nil:
    section.add "quotaUser", valid_589254
  var valid_589255 = query.getOrDefault("alt")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = newJString("json"))
  if valid_589255 != nil:
    section.add "alt", valid_589255
  var valid_589256 = query.getOrDefault("oauth_token")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = nil)
  if valid_589256 != nil:
    section.add "oauth_token", valid_589256
  var valid_589257 = query.getOrDefault("userIp")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = nil)
  if valid_589257 != nil:
    section.add "userIp", valid_589257
  var valid_589258 = query.getOrDefault("key")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "key", valid_589258
  var valid_589259 = query.getOrDefault("prettyPrint")
  valid_589259 = validateParameter(valid_589259, JBool, required = false,
                                 default = newJBool(true))
  if valid_589259 != nil:
    section.add "prettyPrint", valid_589259
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

proc call*(call_589261: Call_TagmanagerAccountsContainersFoldersUpdate_589246;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a GTM Folder.
  ## 
  let valid = call_589261.validator(path, query, header, formData, body)
  let scheme = call_589261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589261.url(scheme.get, call_589261.host, call_589261.base,
                         call_589261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589261, url, valid)

proc call*(call_589262: Call_TagmanagerAccountsContainersFoldersUpdate_589246;
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
  var path_589263 = newJObject()
  var query_589264 = newJObject()
  var body_589265 = newJObject()
  add(path_589263, "containerId", newJString(containerId))
  add(query_589264, "fields", newJString(fields))
  add(query_589264, "fingerprint", newJString(fingerprint))
  add(query_589264, "quotaUser", newJString(quotaUser))
  add(query_589264, "alt", newJString(alt))
  add(query_589264, "oauth_token", newJString(oauthToken))
  add(path_589263, "accountId", newJString(accountId))
  add(query_589264, "userIp", newJString(userIp))
  add(path_589263, "folderId", newJString(folderId))
  add(query_589264, "key", newJString(key))
  if body != nil:
    body_589265 = body
  add(query_589264, "prettyPrint", newJBool(prettyPrint))
  result = call_589262.call(path_589263, query_589264, nil, nil, body_589265)

var tagmanagerAccountsContainersFoldersUpdate* = Call_TagmanagerAccountsContainersFoldersUpdate_589246(
    name: "tagmanagerAccountsContainersFoldersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/folders/{folderId}",
    validator: validate_TagmanagerAccountsContainersFoldersUpdate_589247,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersFoldersUpdate_589248,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersFoldersGet_589229 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersFoldersGet_589231(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersFoldersGet_589230(path: JsonNode;
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
  var valid_589232 = path.getOrDefault("containerId")
  valid_589232 = validateParameter(valid_589232, JString, required = true,
                                 default = nil)
  if valid_589232 != nil:
    section.add "containerId", valid_589232
  var valid_589233 = path.getOrDefault("accountId")
  valid_589233 = validateParameter(valid_589233, JString, required = true,
                                 default = nil)
  if valid_589233 != nil:
    section.add "accountId", valid_589233
  var valid_589234 = path.getOrDefault("folderId")
  valid_589234 = validateParameter(valid_589234, JString, required = true,
                                 default = nil)
  if valid_589234 != nil:
    section.add "folderId", valid_589234
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
  var valid_589235 = query.getOrDefault("fields")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = nil)
  if valid_589235 != nil:
    section.add "fields", valid_589235
  var valid_589236 = query.getOrDefault("quotaUser")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "quotaUser", valid_589236
  var valid_589237 = query.getOrDefault("alt")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = newJString("json"))
  if valid_589237 != nil:
    section.add "alt", valid_589237
  var valid_589238 = query.getOrDefault("oauth_token")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "oauth_token", valid_589238
  var valid_589239 = query.getOrDefault("userIp")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = nil)
  if valid_589239 != nil:
    section.add "userIp", valid_589239
  var valid_589240 = query.getOrDefault("key")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = nil)
  if valid_589240 != nil:
    section.add "key", valid_589240
  var valid_589241 = query.getOrDefault("prettyPrint")
  valid_589241 = validateParameter(valid_589241, JBool, required = false,
                                 default = newJBool(true))
  if valid_589241 != nil:
    section.add "prettyPrint", valid_589241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589242: Call_TagmanagerAccountsContainersFoldersGet_589229;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a GTM Folder.
  ## 
  let valid = call_589242.validator(path, query, header, formData, body)
  let scheme = call_589242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589242.url(scheme.get, call_589242.host, call_589242.base,
                         call_589242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589242, url, valid)

proc call*(call_589243: Call_TagmanagerAccountsContainersFoldersGet_589229;
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
  var path_589244 = newJObject()
  var query_589245 = newJObject()
  add(path_589244, "containerId", newJString(containerId))
  add(query_589245, "fields", newJString(fields))
  add(query_589245, "quotaUser", newJString(quotaUser))
  add(query_589245, "alt", newJString(alt))
  add(query_589245, "oauth_token", newJString(oauthToken))
  add(path_589244, "accountId", newJString(accountId))
  add(query_589245, "userIp", newJString(userIp))
  add(path_589244, "folderId", newJString(folderId))
  add(query_589245, "key", newJString(key))
  add(query_589245, "prettyPrint", newJBool(prettyPrint))
  result = call_589243.call(path_589244, query_589245, nil, nil, nil)

var tagmanagerAccountsContainersFoldersGet* = Call_TagmanagerAccountsContainersFoldersGet_589229(
    name: "tagmanagerAccountsContainersFoldersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/folders/{folderId}",
    validator: validate_TagmanagerAccountsContainersFoldersGet_589230,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersFoldersGet_589231,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersFoldersDelete_589266 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersFoldersDelete_589268(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersFoldersDelete_589267(path: JsonNode;
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
  var valid_589269 = path.getOrDefault("containerId")
  valid_589269 = validateParameter(valid_589269, JString, required = true,
                                 default = nil)
  if valid_589269 != nil:
    section.add "containerId", valid_589269
  var valid_589270 = path.getOrDefault("accountId")
  valid_589270 = validateParameter(valid_589270, JString, required = true,
                                 default = nil)
  if valid_589270 != nil:
    section.add "accountId", valid_589270
  var valid_589271 = path.getOrDefault("folderId")
  valid_589271 = validateParameter(valid_589271, JString, required = true,
                                 default = nil)
  if valid_589271 != nil:
    section.add "folderId", valid_589271
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
  var valid_589272 = query.getOrDefault("fields")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = nil)
  if valid_589272 != nil:
    section.add "fields", valid_589272
  var valid_589273 = query.getOrDefault("quotaUser")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = nil)
  if valid_589273 != nil:
    section.add "quotaUser", valid_589273
  var valid_589274 = query.getOrDefault("alt")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = newJString("json"))
  if valid_589274 != nil:
    section.add "alt", valid_589274
  var valid_589275 = query.getOrDefault("oauth_token")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "oauth_token", valid_589275
  var valid_589276 = query.getOrDefault("userIp")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = nil)
  if valid_589276 != nil:
    section.add "userIp", valid_589276
  var valid_589277 = query.getOrDefault("key")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = nil)
  if valid_589277 != nil:
    section.add "key", valid_589277
  var valid_589278 = query.getOrDefault("prettyPrint")
  valid_589278 = validateParameter(valid_589278, JBool, required = false,
                                 default = newJBool(true))
  if valid_589278 != nil:
    section.add "prettyPrint", valid_589278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589279: Call_TagmanagerAccountsContainersFoldersDelete_589266;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a GTM Folder.
  ## 
  let valid = call_589279.validator(path, query, header, formData, body)
  let scheme = call_589279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589279.url(scheme.get, call_589279.host, call_589279.base,
                         call_589279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589279, url, valid)

proc call*(call_589280: Call_TagmanagerAccountsContainersFoldersDelete_589266;
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
  var path_589281 = newJObject()
  var query_589282 = newJObject()
  add(path_589281, "containerId", newJString(containerId))
  add(query_589282, "fields", newJString(fields))
  add(query_589282, "quotaUser", newJString(quotaUser))
  add(query_589282, "alt", newJString(alt))
  add(query_589282, "oauth_token", newJString(oauthToken))
  add(path_589281, "accountId", newJString(accountId))
  add(query_589282, "userIp", newJString(userIp))
  add(path_589281, "folderId", newJString(folderId))
  add(query_589282, "key", newJString(key))
  add(query_589282, "prettyPrint", newJBool(prettyPrint))
  result = call_589280.call(path_589281, query_589282, nil, nil, nil)

var tagmanagerAccountsContainersFoldersDelete* = Call_TagmanagerAccountsContainersFoldersDelete_589266(
    name: "tagmanagerAccountsContainersFoldersDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/folders/{folderId}",
    validator: validate_TagmanagerAccountsContainersFoldersDelete_589267,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersFoldersDelete_589268,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersFoldersEntitiesList_589283 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersFoldersEntitiesList_589285(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersFoldersEntitiesList_589284(
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
  var valid_589286 = path.getOrDefault("containerId")
  valid_589286 = validateParameter(valid_589286, JString, required = true,
                                 default = nil)
  if valid_589286 != nil:
    section.add "containerId", valid_589286
  var valid_589287 = path.getOrDefault("accountId")
  valid_589287 = validateParameter(valid_589287, JString, required = true,
                                 default = nil)
  if valid_589287 != nil:
    section.add "accountId", valid_589287
  var valid_589288 = path.getOrDefault("folderId")
  valid_589288 = validateParameter(valid_589288, JString, required = true,
                                 default = nil)
  if valid_589288 != nil:
    section.add "folderId", valid_589288
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
  var valid_589289 = query.getOrDefault("fields")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "fields", valid_589289
  var valid_589290 = query.getOrDefault("quotaUser")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = nil)
  if valid_589290 != nil:
    section.add "quotaUser", valid_589290
  var valid_589291 = query.getOrDefault("alt")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = newJString("json"))
  if valid_589291 != nil:
    section.add "alt", valid_589291
  var valid_589292 = query.getOrDefault("oauth_token")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = nil)
  if valid_589292 != nil:
    section.add "oauth_token", valid_589292
  var valid_589293 = query.getOrDefault("userIp")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "userIp", valid_589293
  var valid_589294 = query.getOrDefault("key")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "key", valid_589294
  var valid_589295 = query.getOrDefault("prettyPrint")
  valid_589295 = validateParameter(valid_589295, JBool, required = false,
                                 default = newJBool(true))
  if valid_589295 != nil:
    section.add "prettyPrint", valid_589295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589296: Call_TagmanagerAccountsContainersFoldersEntitiesList_589283;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all entities in a GTM Folder.
  ## 
  let valid = call_589296.validator(path, query, header, formData, body)
  let scheme = call_589296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589296.url(scheme.get, call_589296.host, call_589296.base,
                         call_589296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589296, url, valid)

proc call*(call_589297: Call_TagmanagerAccountsContainersFoldersEntitiesList_589283;
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
  var path_589298 = newJObject()
  var query_589299 = newJObject()
  add(path_589298, "containerId", newJString(containerId))
  add(query_589299, "fields", newJString(fields))
  add(query_589299, "quotaUser", newJString(quotaUser))
  add(query_589299, "alt", newJString(alt))
  add(query_589299, "oauth_token", newJString(oauthToken))
  add(path_589298, "accountId", newJString(accountId))
  add(query_589299, "userIp", newJString(userIp))
  add(path_589298, "folderId", newJString(folderId))
  add(query_589299, "key", newJString(key))
  add(query_589299, "prettyPrint", newJBool(prettyPrint))
  result = call_589297.call(path_589298, query_589299, nil, nil, nil)

var tagmanagerAccountsContainersFoldersEntitiesList* = Call_TagmanagerAccountsContainersFoldersEntitiesList_589283(
    name: "tagmanagerAccountsContainersFoldersEntitiesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/folders/{folderId}/entities",
    validator: validate_TagmanagerAccountsContainersFoldersEntitiesList_589284,
    base: "/tagmanager/v1",
    url: url_TagmanagerAccountsContainersFoldersEntitiesList_589285,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersMoveFoldersUpdate_589300 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersMoveFoldersUpdate_589302(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersMoveFoldersUpdate_589301(
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
  var valid_589303 = path.getOrDefault("containerId")
  valid_589303 = validateParameter(valid_589303, JString, required = true,
                                 default = nil)
  if valid_589303 != nil:
    section.add "containerId", valid_589303
  var valid_589304 = path.getOrDefault("accountId")
  valid_589304 = validateParameter(valid_589304, JString, required = true,
                                 default = nil)
  if valid_589304 != nil:
    section.add "accountId", valid_589304
  var valid_589305 = path.getOrDefault("folderId")
  valid_589305 = validateParameter(valid_589305, JString, required = true,
                                 default = nil)
  if valid_589305 != nil:
    section.add "folderId", valid_589305
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
  var valid_589306 = query.getOrDefault("fields")
  valid_589306 = validateParameter(valid_589306, JString, required = false,
                                 default = nil)
  if valid_589306 != nil:
    section.add "fields", valid_589306
  var valid_589307 = query.getOrDefault("quotaUser")
  valid_589307 = validateParameter(valid_589307, JString, required = false,
                                 default = nil)
  if valid_589307 != nil:
    section.add "quotaUser", valid_589307
  var valid_589308 = query.getOrDefault("alt")
  valid_589308 = validateParameter(valid_589308, JString, required = false,
                                 default = newJString("json"))
  if valid_589308 != nil:
    section.add "alt", valid_589308
  var valid_589309 = query.getOrDefault("oauth_token")
  valid_589309 = validateParameter(valid_589309, JString, required = false,
                                 default = nil)
  if valid_589309 != nil:
    section.add "oauth_token", valid_589309
  var valid_589310 = query.getOrDefault("userIp")
  valid_589310 = validateParameter(valid_589310, JString, required = false,
                                 default = nil)
  if valid_589310 != nil:
    section.add "userIp", valid_589310
  var valid_589311 = query.getOrDefault("key")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = nil)
  if valid_589311 != nil:
    section.add "key", valid_589311
  var valid_589312 = query.getOrDefault("triggerId")
  valid_589312 = validateParameter(valid_589312, JArray, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "triggerId", valid_589312
  var valid_589313 = query.getOrDefault("prettyPrint")
  valid_589313 = validateParameter(valid_589313, JBool, required = false,
                                 default = newJBool(true))
  if valid_589313 != nil:
    section.add "prettyPrint", valid_589313
  var valid_589314 = query.getOrDefault("tagId")
  valid_589314 = validateParameter(valid_589314, JArray, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "tagId", valid_589314
  var valid_589315 = query.getOrDefault("variableId")
  valid_589315 = validateParameter(valid_589315, JArray, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "variableId", valid_589315
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

proc call*(call_589317: Call_TagmanagerAccountsContainersMoveFoldersUpdate_589300;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Moves entities to a GTM Folder.
  ## 
  let valid = call_589317.validator(path, query, header, formData, body)
  let scheme = call_589317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589317.url(scheme.get, call_589317.host, call_589317.base,
                         call_589317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589317, url, valid)

proc call*(call_589318: Call_TagmanagerAccountsContainersMoveFoldersUpdate_589300;
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
  var path_589319 = newJObject()
  var query_589320 = newJObject()
  var body_589321 = newJObject()
  add(path_589319, "containerId", newJString(containerId))
  add(query_589320, "fields", newJString(fields))
  add(query_589320, "quotaUser", newJString(quotaUser))
  add(query_589320, "alt", newJString(alt))
  add(query_589320, "oauth_token", newJString(oauthToken))
  add(path_589319, "accountId", newJString(accountId))
  add(query_589320, "userIp", newJString(userIp))
  add(path_589319, "folderId", newJString(folderId))
  add(query_589320, "key", newJString(key))
  if triggerId != nil:
    query_589320.add "triggerId", triggerId
  if body != nil:
    body_589321 = body
  add(query_589320, "prettyPrint", newJBool(prettyPrint))
  if tagId != nil:
    query_589320.add "tagId", tagId
  if variableId != nil:
    query_589320.add "variableId", variableId
  result = call_589318.call(path_589319, query_589320, nil, nil, body_589321)

var tagmanagerAccountsContainersMoveFoldersUpdate* = Call_TagmanagerAccountsContainersMoveFoldersUpdate_589300(
    name: "tagmanagerAccountsContainersMoveFoldersUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/move_folders/{folderId}",
    validator: validate_TagmanagerAccountsContainersMoveFoldersUpdate_589301,
    base: "/tagmanager/v1",
    url: url_TagmanagerAccountsContainersMoveFoldersUpdate_589302,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_589322 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_589324(
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

proc validate_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_589323(
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
  var valid_589325 = path.getOrDefault("containerId")
  valid_589325 = validateParameter(valid_589325, JString, required = true,
                                 default = nil)
  if valid_589325 != nil:
    section.add "containerId", valid_589325
  var valid_589326 = path.getOrDefault("accountId")
  valid_589326 = validateParameter(valid_589326, JString, required = true,
                                 default = nil)
  if valid_589326 != nil:
    section.add "accountId", valid_589326
  var valid_589327 = path.getOrDefault("environmentId")
  valid_589327 = validateParameter(valid_589327, JString, required = true,
                                 default = nil)
  if valid_589327 != nil:
    section.add "environmentId", valid_589327
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
  var valid_589328 = query.getOrDefault("fields")
  valid_589328 = validateParameter(valid_589328, JString, required = false,
                                 default = nil)
  if valid_589328 != nil:
    section.add "fields", valid_589328
  var valid_589329 = query.getOrDefault("quotaUser")
  valid_589329 = validateParameter(valid_589329, JString, required = false,
                                 default = nil)
  if valid_589329 != nil:
    section.add "quotaUser", valid_589329
  var valid_589330 = query.getOrDefault("alt")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = newJString("json"))
  if valid_589330 != nil:
    section.add "alt", valid_589330
  var valid_589331 = query.getOrDefault("oauth_token")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = nil)
  if valid_589331 != nil:
    section.add "oauth_token", valid_589331
  var valid_589332 = query.getOrDefault("userIp")
  valid_589332 = validateParameter(valid_589332, JString, required = false,
                                 default = nil)
  if valid_589332 != nil:
    section.add "userIp", valid_589332
  var valid_589333 = query.getOrDefault("key")
  valid_589333 = validateParameter(valid_589333, JString, required = false,
                                 default = nil)
  if valid_589333 != nil:
    section.add "key", valid_589333
  var valid_589334 = query.getOrDefault("prettyPrint")
  valid_589334 = validateParameter(valid_589334, JBool, required = false,
                                 default = newJBool(true))
  if valid_589334 != nil:
    section.add "prettyPrint", valid_589334
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

proc call*(call_589336: Call_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_589322;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Re-generates the authorization code for a GTM Environment.
  ## 
  let valid = call_589336.validator(path, query, header, formData, body)
  let scheme = call_589336.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589336.url(scheme.get, call_589336.host, call_589336.base,
                         call_589336.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589336, url, valid)

proc call*(call_589337: Call_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_589322;
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
  var path_589338 = newJObject()
  var query_589339 = newJObject()
  var body_589340 = newJObject()
  add(path_589338, "containerId", newJString(containerId))
  add(query_589339, "fields", newJString(fields))
  add(query_589339, "quotaUser", newJString(quotaUser))
  add(query_589339, "alt", newJString(alt))
  add(query_589339, "oauth_token", newJString(oauthToken))
  add(path_589338, "accountId", newJString(accountId))
  add(query_589339, "userIp", newJString(userIp))
  add(query_589339, "key", newJString(key))
  add(path_589338, "environmentId", newJString(environmentId))
  if body != nil:
    body_589340 = body
  add(query_589339, "prettyPrint", newJBool(prettyPrint))
  result = call_589337.call(path_589338, query_589339, nil, nil, body_589340)

var tagmanagerAccountsContainersReauthorizeEnvironmentsUpdate* = Call_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_589322(
    name: "tagmanagerAccountsContainersReauthorizeEnvironmentsUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/reauthorize_environments/{environmentId}", validator: validate_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_589323,
    base: "/tagmanager/v1",
    url: url_TagmanagerAccountsContainersReauthorizeEnvironmentsUpdate_589324,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTagsCreate_589357 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersTagsCreate_589359(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersTagsCreate_589358(path: JsonNode;
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
  var valid_589360 = path.getOrDefault("containerId")
  valid_589360 = validateParameter(valid_589360, JString, required = true,
                                 default = nil)
  if valid_589360 != nil:
    section.add "containerId", valid_589360
  var valid_589361 = path.getOrDefault("accountId")
  valid_589361 = validateParameter(valid_589361, JString, required = true,
                                 default = nil)
  if valid_589361 != nil:
    section.add "accountId", valid_589361
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
  var valid_589362 = query.getOrDefault("fields")
  valid_589362 = validateParameter(valid_589362, JString, required = false,
                                 default = nil)
  if valid_589362 != nil:
    section.add "fields", valid_589362
  var valid_589363 = query.getOrDefault("quotaUser")
  valid_589363 = validateParameter(valid_589363, JString, required = false,
                                 default = nil)
  if valid_589363 != nil:
    section.add "quotaUser", valid_589363
  var valid_589364 = query.getOrDefault("alt")
  valid_589364 = validateParameter(valid_589364, JString, required = false,
                                 default = newJString("json"))
  if valid_589364 != nil:
    section.add "alt", valid_589364
  var valid_589365 = query.getOrDefault("oauth_token")
  valid_589365 = validateParameter(valid_589365, JString, required = false,
                                 default = nil)
  if valid_589365 != nil:
    section.add "oauth_token", valid_589365
  var valid_589366 = query.getOrDefault("userIp")
  valid_589366 = validateParameter(valid_589366, JString, required = false,
                                 default = nil)
  if valid_589366 != nil:
    section.add "userIp", valid_589366
  var valid_589367 = query.getOrDefault("key")
  valid_589367 = validateParameter(valid_589367, JString, required = false,
                                 default = nil)
  if valid_589367 != nil:
    section.add "key", valid_589367
  var valid_589368 = query.getOrDefault("prettyPrint")
  valid_589368 = validateParameter(valid_589368, JBool, required = false,
                                 default = newJBool(true))
  if valid_589368 != nil:
    section.add "prettyPrint", valid_589368
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

proc call*(call_589370: Call_TagmanagerAccountsContainersTagsCreate_589357;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a GTM Tag.
  ## 
  let valid = call_589370.validator(path, query, header, formData, body)
  let scheme = call_589370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589370.url(scheme.get, call_589370.host, call_589370.base,
                         call_589370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589370, url, valid)

proc call*(call_589371: Call_TagmanagerAccountsContainersTagsCreate_589357;
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
  var path_589372 = newJObject()
  var query_589373 = newJObject()
  var body_589374 = newJObject()
  add(path_589372, "containerId", newJString(containerId))
  add(query_589373, "fields", newJString(fields))
  add(query_589373, "quotaUser", newJString(quotaUser))
  add(query_589373, "alt", newJString(alt))
  add(query_589373, "oauth_token", newJString(oauthToken))
  add(path_589372, "accountId", newJString(accountId))
  add(query_589373, "userIp", newJString(userIp))
  add(query_589373, "key", newJString(key))
  if body != nil:
    body_589374 = body
  add(query_589373, "prettyPrint", newJBool(prettyPrint))
  result = call_589371.call(path_589372, query_589373, nil, nil, body_589374)

var tagmanagerAccountsContainersTagsCreate* = Call_TagmanagerAccountsContainersTagsCreate_589357(
    name: "tagmanagerAccountsContainersTagsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/tags",
    validator: validate_TagmanagerAccountsContainersTagsCreate_589358,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTagsCreate_589359,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTagsList_589341 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersTagsList_589343(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersTagsList_589342(path: JsonNode;
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
  var valid_589344 = path.getOrDefault("containerId")
  valid_589344 = validateParameter(valid_589344, JString, required = true,
                                 default = nil)
  if valid_589344 != nil:
    section.add "containerId", valid_589344
  var valid_589345 = path.getOrDefault("accountId")
  valid_589345 = validateParameter(valid_589345, JString, required = true,
                                 default = nil)
  if valid_589345 != nil:
    section.add "accountId", valid_589345
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
  var valid_589346 = query.getOrDefault("fields")
  valid_589346 = validateParameter(valid_589346, JString, required = false,
                                 default = nil)
  if valid_589346 != nil:
    section.add "fields", valid_589346
  var valid_589347 = query.getOrDefault("quotaUser")
  valid_589347 = validateParameter(valid_589347, JString, required = false,
                                 default = nil)
  if valid_589347 != nil:
    section.add "quotaUser", valid_589347
  var valid_589348 = query.getOrDefault("alt")
  valid_589348 = validateParameter(valid_589348, JString, required = false,
                                 default = newJString("json"))
  if valid_589348 != nil:
    section.add "alt", valid_589348
  var valid_589349 = query.getOrDefault("oauth_token")
  valid_589349 = validateParameter(valid_589349, JString, required = false,
                                 default = nil)
  if valid_589349 != nil:
    section.add "oauth_token", valid_589349
  var valid_589350 = query.getOrDefault("userIp")
  valid_589350 = validateParameter(valid_589350, JString, required = false,
                                 default = nil)
  if valid_589350 != nil:
    section.add "userIp", valid_589350
  var valid_589351 = query.getOrDefault("key")
  valid_589351 = validateParameter(valid_589351, JString, required = false,
                                 default = nil)
  if valid_589351 != nil:
    section.add "key", valid_589351
  var valid_589352 = query.getOrDefault("prettyPrint")
  valid_589352 = validateParameter(valid_589352, JBool, required = false,
                                 default = newJBool(true))
  if valid_589352 != nil:
    section.add "prettyPrint", valid_589352
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589353: Call_TagmanagerAccountsContainersTagsList_589341;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all GTM Tags of a Container.
  ## 
  let valid = call_589353.validator(path, query, header, formData, body)
  let scheme = call_589353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589353.url(scheme.get, call_589353.host, call_589353.base,
                         call_589353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589353, url, valid)

proc call*(call_589354: Call_TagmanagerAccountsContainersTagsList_589341;
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
  var path_589355 = newJObject()
  var query_589356 = newJObject()
  add(path_589355, "containerId", newJString(containerId))
  add(query_589356, "fields", newJString(fields))
  add(query_589356, "quotaUser", newJString(quotaUser))
  add(query_589356, "alt", newJString(alt))
  add(query_589356, "oauth_token", newJString(oauthToken))
  add(path_589355, "accountId", newJString(accountId))
  add(query_589356, "userIp", newJString(userIp))
  add(query_589356, "key", newJString(key))
  add(query_589356, "prettyPrint", newJBool(prettyPrint))
  result = call_589354.call(path_589355, query_589356, nil, nil, nil)

var tagmanagerAccountsContainersTagsList* = Call_TagmanagerAccountsContainersTagsList_589341(
    name: "tagmanagerAccountsContainersTagsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/tags",
    validator: validate_TagmanagerAccountsContainersTagsList_589342,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTagsList_589343,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTagsUpdate_589392 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersTagsUpdate_589394(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersTagsUpdate_589393(path: JsonNode;
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
  var valid_589395 = path.getOrDefault("containerId")
  valid_589395 = validateParameter(valid_589395, JString, required = true,
                                 default = nil)
  if valid_589395 != nil:
    section.add "containerId", valid_589395
  var valid_589396 = path.getOrDefault("tagId")
  valid_589396 = validateParameter(valid_589396, JString, required = true,
                                 default = nil)
  if valid_589396 != nil:
    section.add "tagId", valid_589396
  var valid_589397 = path.getOrDefault("accountId")
  valid_589397 = validateParameter(valid_589397, JString, required = true,
                                 default = nil)
  if valid_589397 != nil:
    section.add "accountId", valid_589397
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
  var valid_589398 = query.getOrDefault("fields")
  valid_589398 = validateParameter(valid_589398, JString, required = false,
                                 default = nil)
  if valid_589398 != nil:
    section.add "fields", valid_589398
  var valid_589399 = query.getOrDefault("fingerprint")
  valid_589399 = validateParameter(valid_589399, JString, required = false,
                                 default = nil)
  if valid_589399 != nil:
    section.add "fingerprint", valid_589399
  var valid_589400 = query.getOrDefault("quotaUser")
  valid_589400 = validateParameter(valid_589400, JString, required = false,
                                 default = nil)
  if valid_589400 != nil:
    section.add "quotaUser", valid_589400
  var valid_589401 = query.getOrDefault("alt")
  valid_589401 = validateParameter(valid_589401, JString, required = false,
                                 default = newJString("json"))
  if valid_589401 != nil:
    section.add "alt", valid_589401
  var valid_589402 = query.getOrDefault("oauth_token")
  valid_589402 = validateParameter(valid_589402, JString, required = false,
                                 default = nil)
  if valid_589402 != nil:
    section.add "oauth_token", valid_589402
  var valid_589403 = query.getOrDefault("userIp")
  valid_589403 = validateParameter(valid_589403, JString, required = false,
                                 default = nil)
  if valid_589403 != nil:
    section.add "userIp", valid_589403
  var valid_589404 = query.getOrDefault("key")
  valid_589404 = validateParameter(valid_589404, JString, required = false,
                                 default = nil)
  if valid_589404 != nil:
    section.add "key", valid_589404
  var valid_589405 = query.getOrDefault("prettyPrint")
  valid_589405 = validateParameter(valid_589405, JBool, required = false,
                                 default = newJBool(true))
  if valid_589405 != nil:
    section.add "prettyPrint", valid_589405
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

proc call*(call_589407: Call_TagmanagerAccountsContainersTagsUpdate_589392;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a GTM Tag.
  ## 
  let valid = call_589407.validator(path, query, header, formData, body)
  let scheme = call_589407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589407.url(scheme.get, call_589407.host, call_589407.base,
                         call_589407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589407, url, valid)

proc call*(call_589408: Call_TagmanagerAccountsContainersTagsUpdate_589392;
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
  var path_589409 = newJObject()
  var query_589410 = newJObject()
  var body_589411 = newJObject()
  add(path_589409, "containerId", newJString(containerId))
  add(path_589409, "tagId", newJString(tagId))
  add(query_589410, "fields", newJString(fields))
  add(query_589410, "fingerprint", newJString(fingerprint))
  add(query_589410, "quotaUser", newJString(quotaUser))
  add(query_589410, "alt", newJString(alt))
  add(query_589410, "oauth_token", newJString(oauthToken))
  add(path_589409, "accountId", newJString(accountId))
  add(query_589410, "userIp", newJString(userIp))
  add(query_589410, "key", newJString(key))
  if body != nil:
    body_589411 = body
  add(query_589410, "prettyPrint", newJBool(prettyPrint))
  result = call_589408.call(path_589409, query_589410, nil, nil, body_589411)

var tagmanagerAccountsContainersTagsUpdate* = Call_TagmanagerAccountsContainersTagsUpdate_589392(
    name: "tagmanagerAccountsContainersTagsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/tags/{tagId}",
    validator: validate_TagmanagerAccountsContainersTagsUpdate_589393,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTagsUpdate_589394,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTagsGet_589375 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersTagsGet_589377(protocol: Scheme; host: string;
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

proc validate_TagmanagerAccountsContainersTagsGet_589376(path: JsonNode;
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
  var valid_589378 = path.getOrDefault("containerId")
  valid_589378 = validateParameter(valid_589378, JString, required = true,
                                 default = nil)
  if valid_589378 != nil:
    section.add "containerId", valid_589378
  var valid_589379 = path.getOrDefault("tagId")
  valid_589379 = validateParameter(valid_589379, JString, required = true,
                                 default = nil)
  if valid_589379 != nil:
    section.add "tagId", valid_589379
  var valid_589380 = path.getOrDefault("accountId")
  valid_589380 = validateParameter(valid_589380, JString, required = true,
                                 default = nil)
  if valid_589380 != nil:
    section.add "accountId", valid_589380
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
  var valid_589381 = query.getOrDefault("fields")
  valid_589381 = validateParameter(valid_589381, JString, required = false,
                                 default = nil)
  if valid_589381 != nil:
    section.add "fields", valid_589381
  var valid_589382 = query.getOrDefault("quotaUser")
  valid_589382 = validateParameter(valid_589382, JString, required = false,
                                 default = nil)
  if valid_589382 != nil:
    section.add "quotaUser", valid_589382
  var valid_589383 = query.getOrDefault("alt")
  valid_589383 = validateParameter(valid_589383, JString, required = false,
                                 default = newJString("json"))
  if valid_589383 != nil:
    section.add "alt", valid_589383
  var valid_589384 = query.getOrDefault("oauth_token")
  valid_589384 = validateParameter(valid_589384, JString, required = false,
                                 default = nil)
  if valid_589384 != nil:
    section.add "oauth_token", valid_589384
  var valid_589385 = query.getOrDefault("userIp")
  valid_589385 = validateParameter(valid_589385, JString, required = false,
                                 default = nil)
  if valid_589385 != nil:
    section.add "userIp", valid_589385
  var valid_589386 = query.getOrDefault("key")
  valid_589386 = validateParameter(valid_589386, JString, required = false,
                                 default = nil)
  if valid_589386 != nil:
    section.add "key", valid_589386
  var valid_589387 = query.getOrDefault("prettyPrint")
  valid_589387 = validateParameter(valid_589387, JBool, required = false,
                                 default = newJBool(true))
  if valid_589387 != nil:
    section.add "prettyPrint", valid_589387
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589388: Call_TagmanagerAccountsContainersTagsGet_589375;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a GTM Tag.
  ## 
  let valid = call_589388.validator(path, query, header, formData, body)
  let scheme = call_589388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589388.url(scheme.get, call_589388.host, call_589388.base,
                         call_589388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589388, url, valid)

proc call*(call_589389: Call_TagmanagerAccountsContainersTagsGet_589375;
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
  var path_589390 = newJObject()
  var query_589391 = newJObject()
  add(path_589390, "containerId", newJString(containerId))
  add(path_589390, "tagId", newJString(tagId))
  add(query_589391, "fields", newJString(fields))
  add(query_589391, "quotaUser", newJString(quotaUser))
  add(query_589391, "alt", newJString(alt))
  add(query_589391, "oauth_token", newJString(oauthToken))
  add(path_589390, "accountId", newJString(accountId))
  add(query_589391, "userIp", newJString(userIp))
  add(query_589391, "key", newJString(key))
  add(query_589391, "prettyPrint", newJBool(prettyPrint))
  result = call_589389.call(path_589390, query_589391, nil, nil, nil)

var tagmanagerAccountsContainersTagsGet* = Call_TagmanagerAccountsContainersTagsGet_589375(
    name: "tagmanagerAccountsContainersTagsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/tags/{tagId}",
    validator: validate_TagmanagerAccountsContainersTagsGet_589376,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTagsGet_589377,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTagsDelete_589412 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersTagsDelete_589414(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersTagsDelete_589413(path: JsonNode;
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
  var valid_589415 = path.getOrDefault("containerId")
  valid_589415 = validateParameter(valid_589415, JString, required = true,
                                 default = nil)
  if valid_589415 != nil:
    section.add "containerId", valid_589415
  var valid_589416 = path.getOrDefault("tagId")
  valid_589416 = validateParameter(valid_589416, JString, required = true,
                                 default = nil)
  if valid_589416 != nil:
    section.add "tagId", valid_589416
  var valid_589417 = path.getOrDefault("accountId")
  valid_589417 = validateParameter(valid_589417, JString, required = true,
                                 default = nil)
  if valid_589417 != nil:
    section.add "accountId", valid_589417
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
  var valid_589418 = query.getOrDefault("fields")
  valid_589418 = validateParameter(valid_589418, JString, required = false,
                                 default = nil)
  if valid_589418 != nil:
    section.add "fields", valid_589418
  var valid_589419 = query.getOrDefault("quotaUser")
  valid_589419 = validateParameter(valid_589419, JString, required = false,
                                 default = nil)
  if valid_589419 != nil:
    section.add "quotaUser", valid_589419
  var valid_589420 = query.getOrDefault("alt")
  valid_589420 = validateParameter(valid_589420, JString, required = false,
                                 default = newJString("json"))
  if valid_589420 != nil:
    section.add "alt", valid_589420
  var valid_589421 = query.getOrDefault("oauth_token")
  valid_589421 = validateParameter(valid_589421, JString, required = false,
                                 default = nil)
  if valid_589421 != nil:
    section.add "oauth_token", valid_589421
  var valid_589422 = query.getOrDefault("userIp")
  valid_589422 = validateParameter(valid_589422, JString, required = false,
                                 default = nil)
  if valid_589422 != nil:
    section.add "userIp", valid_589422
  var valid_589423 = query.getOrDefault("key")
  valid_589423 = validateParameter(valid_589423, JString, required = false,
                                 default = nil)
  if valid_589423 != nil:
    section.add "key", valid_589423
  var valid_589424 = query.getOrDefault("prettyPrint")
  valid_589424 = validateParameter(valid_589424, JBool, required = false,
                                 default = newJBool(true))
  if valid_589424 != nil:
    section.add "prettyPrint", valid_589424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589425: Call_TagmanagerAccountsContainersTagsDelete_589412;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a GTM Tag.
  ## 
  let valid = call_589425.validator(path, query, header, formData, body)
  let scheme = call_589425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589425.url(scheme.get, call_589425.host, call_589425.base,
                         call_589425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589425, url, valid)

proc call*(call_589426: Call_TagmanagerAccountsContainersTagsDelete_589412;
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
  var path_589427 = newJObject()
  var query_589428 = newJObject()
  add(path_589427, "containerId", newJString(containerId))
  add(path_589427, "tagId", newJString(tagId))
  add(query_589428, "fields", newJString(fields))
  add(query_589428, "quotaUser", newJString(quotaUser))
  add(query_589428, "alt", newJString(alt))
  add(query_589428, "oauth_token", newJString(oauthToken))
  add(path_589427, "accountId", newJString(accountId))
  add(query_589428, "userIp", newJString(userIp))
  add(query_589428, "key", newJString(key))
  add(query_589428, "prettyPrint", newJBool(prettyPrint))
  result = call_589426.call(path_589427, query_589428, nil, nil, nil)

var tagmanagerAccountsContainersTagsDelete* = Call_TagmanagerAccountsContainersTagsDelete_589412(
    name: "tagmanagerAccountsContainersTagsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/tags/{tagId}",
    validator: validate_TagmanagerAccountsContainersTagsDelete_589413,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTagsDelete_589414,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTriggersCreate_589445 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersTriggersCreate_589447(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersTriggersCreate_589446(path: JsonNode;
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
  var valid_589448 = path.getOrDefault("containerId")
  valid_589448 = validateParameter(valid_589448, JString, required = true,
                                 default = nil)
  if valid_589448 != nil:
    section.add "containerId", valid_589448
  var valid_589449 = path.getOrDefault("accountId")
  valid_589449 = validateParameter(valid_589449, JString, required = true,
                                 default = nil)
  if valid_589449 != nil:
    section.add "accountId", valid_589449
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
  var valid_589450 = query.getOrDefault("fields")
  valid_589450 = validateParameter(valid_589450, JString, required = false,
                                 default = nil)
  if valid_589450 != nil:
    section.add "fields", valid_589450
  var valid_589451 = query.getOrDefault("quotaUser")
  valid_589451 = validateParameter(valid_589451, JString, required = false,
                                 default = nil)
  if valid_589451 != nil:
    section.add "quotaUser", valid_589451
  var valid_589452 = query.getOrDefault("alt")
  valid_589452 = validateParameter(valid_589452, JString, required = false,
                                 default = newJString("json"))
  if valid_589452 != nil:
    section.add "alt", valid_589452
  var valid_589453 = query.getOrDefault("oauth_token")
  valid_589453 = validateParameter(valid_589453, JString, required = false,
                                 default = nil)
  if valid_589453 != nil:
    section.add "oauth_token", valid_589453
  var valid_589454 = query.getOrDefault("userIp")
  valid_589454 = validateParameter(valid_589454, JString, required = false,
                                 default = nil)
  if valid_589454 != nil:
    section.add "userIp", valid_589454
  var valid_589455 = query.getOrDefault("key")
  valid_589455 = validateParameter(valid_589455, JString, required = false,
                                 default = nil)
  if valid_589455 != nil:
    section.add "key", valid_589455
  var valid_589456 = query.getOrDefault("prettyPrint")
  valid_589456 = validateParameter(valid_589456, JBool, required = false,
                                 default = newJBool(true))
  if valid_589456 != nil:
    section.add "prettyPrint", valid_589456
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

proc call*(call_589458: Call_TagmanagerAccountsContainersTriggersCreate_589445;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a GTM Trigger.
  ## 
  let valid = call_589458.validator(path, query, header, formData, body)
  let scheme = call_589458.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589458.url(scheme.get, call_589458.host, call_589458.base,
                         call_589458.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589458, url, valid)

proc call*(call_589459: Call_TagmanagerAccountsContainersTriggersCreate_589445;
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
  var path_589460 = newJObject()
  var query_589461 = newJObject()
  var body_589462 = newJObject()
  add(path_589460, "containerId", newJString(containerId))
  add(query_589461, "fields", newJString(fields))
  add(query_589461, "quotaUser", newJString(quotaUser))
  add(query_589461, "alt", newJString(alt))
  add(query_589461, "oauth_token", newJString(oauthToken))
  add(path_589460, "accountId", newJString(accountId))
  add(query_589461, "userIp", newJString(userIp))
  add(query_589461, "key", newJString(key))
  if body != nil:
    body_589462 = body
  add(query_589461, "prettyPrint", newJBool(prettyPrint))
  result = call_589459.call(path_589460, query_589461, nil, nil, body_589462)

var tagmanagerAccountsContainersTriggersCreate* = Call_TagmanagerAccountsContainersTriggersCreate_589445(
    name: "tagmanagerAccountsContainersTriggersCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/triggers",
    validator: validate_TagmanagerAccountsContainersTriggersCreate_589446,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTriggersCreate_589447,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTriggersList_589429 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersTriggersList_589431(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersTriggersList_589430(path: JsonNode;
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
  var valid_589432 = path.getOrDefault("containerId")
  valid_589432 = validateParameter(valid_589432, JString, required = true,
                                 default = nil)
  if valid_589432 != nil:
    section.add "containerId", valid_589432
  var valid_589433 = path.getOrDefault("accountId")
  valid_589433 = validateParameter(valid_589433, JString, required = true,
                                 default = nil)
  if valid_589433 != nil:
    section.add "accountId", valid_589433
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
  var valid_589434 = query.getOrDefault("fields")
  valid_589434 = validateParameter(valid_589434, JString, required = false,
                                 default = nil)
  if valid_589434 != nil:
    section.add "fields", valid_589434
  var valid_589435 = query.getOrDefault("quotaUser")
  valid_589435 = validateParameter(valid_589435, JString, required = false,
                                 default = nil)
  if valid_589435 != nil:
    section.add "quotaUser", valid_589435
  var valid_589436 = query.getOrDefault("alt")
  valid_589436 = validateParameter(valid_589436, JString, required = false,
                                 default = newJString("json"))
  if valid_589436 != nil:
    section.add "alt", valid_589436
  var valid_589437 = query.getOrDefault("oauth_token")
  valid_589437 = validateParameter(valid_589437, JString, required = false,
                                 default = nil)
  if valid_589437 != nil:
    section.add "oauth_token", valid_589437
  var valid_589438 = query.getOrDefault("userIp")
  valid_589438 = validateParameter(valid_589438, JString, required = false,
                                 default = nil)
  if valid_589438 != nil:
    section.add "userIp", valid_589438
  var valid_589439 = query.getOrDefault("key")
  valid_589439 = validateParameter(valid_589439, JString, required = false,
                                 default = nil)
  if valid_589439 != nil:
    section.add "key", valid_589439
  var valid_589440 = query.getOrDefault("prettyPrint")
  valid_589440 = validateParameter(valid_589440, JBool, required = false,
                                 default = newJBool(true))
  if valid_589440 != nil:
    section.add "prettyPrint", valid_589440
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589441: Call_TagmanagerAccountsContainersTriggersList_589429;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all GTM Triggers of a Container.
  ## 
  let valid = call_589441.validator(path, query, header, formData, body)
  let scheme = call_589441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589441.url(scheme.get, call_589441.host, call_589441.base,
                         call_589441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589441, url, valid)

proc call*(call_589442: Call_TagmanagerAccountsContainersTriggersList_589429;
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
  var path_589443 = newJObject()
  var query_589444 = newJObject()
  add(path_589443, "containerId", newJString(containerId))
  add(query_589444, "fields", newJString(fields))
  add(query_589444, "quotaUser", newJString(quotaUser))
  add(query_589444, "alt", newJString(alt))
  add(query_589444, "oauth_token", newJString(oauthToken))
  add(path_589443, "accountId", newJString(accountId))
  add(query_589444, "userIp", newJString(userIp))
  add(query_589444, "key", newJString(key))
  add(query_589444, "prettyPrint", newJBool(prettyPrint))
  result = call_589442.call(path_589443, query_589444, nil, nil, nil)

var tagmanagerAccountsContainersTriggersList* = Call_TagmanagerAccountsContainersTriggersList_589429(
    name: "tagmanagerAccountsContainersTriggersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/triggers",
    validator: validate_TagmanagerAccountsContainersTriggersList_589430,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTriggersList_589431,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTriggersUpdate_589480 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersTriggersUpdate_589482(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersTriggersUpdate_589481(path: JsonNode;
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
  var valid_589483 = path.getOrDefault("containerId")
  valid_589483 = validateParameter(valid_589483, JString, required = true,
                                 default = nil)
  if valid_589483 != nil:
    section.add "containerId", valid_589483
  var valid_589484 = path.getOrDefault("accountId")
  valid_589484 = validateParameter(valid_589484, JString, required = true,
                                 default = nil)
  if valid_589484 != nil:
    section.add "accountId", valid_589484
  var valid_589485 = path.getOrDefault("triggerId")
  valid_589485 = validateParameter(valid_589485, JString, required = true,
                                 default = nil)
  if valid_589485 != nil:
    section.add "triggerId", valid_589485
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
  var valid_589486 = query.getOrDefault("fields")
  valid_589486 = validateParameter(valid_589486, JString, required = false,
                                 default = nil)
  if valid_589486 != nil:
    section.add "fields", valid_589486
  var valid_589487 = query.getOrDefault("fingerprint")
  valid_589487 = validateParameter(valid_589487, JString, required = false,
                                 default = nil)
  if valid_589487 != nil:
    section.add "fingerprint", valid_589487
  var valid_589488 = query.getOrDefault("quotaUser")
  valid_589488 = validateParameter(valid_589488, JString, required = false,
                                 default = nil)
  if valid_589488 != nil:
    section.add "quotaUser", valid_589488
  var valid_589489 = query.getOrDefault("alt")
  valid_589489 = validateParameter(valid_589489, JString, required = false,
                                 default = newJString("json"))
  if valid_589489 != nil:
    section.add "alt", valid_589489
  var valid_589490 = query.getOrDefault("oauth_token")
  valid_589490 = validateParameter(valid_589490, JString, required = false,
                                 default = nil)
  if valid_589490 != nil:
    section.add "oauth_token", valid_589490
  var valid_589491 = query.getOrDefault("userIp")
  valid_589491 = validateParameter(valid_589491, JString, required = false,
                                 default = nil)
  if valid_589491 != nil:
    section.add "userIp", valid_589491
  var valid_589492 = query.getOrDefault("key")
  valid_589492 = validateParameter(valid_589492, JString, required = false,
                                 default = nil)
  if valid_589492 != nil:
    section.add "key", valid_589492
  var valid_589493 = query.getOrDefault("prettyPrint")
  valid_589493 = validateParameter(valid_589493, JBool, required = false,
                                 default = newJBool(true))
  if valid_589493 != nil:
    section.add "prettyPrint", valid_589493
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

proc call*(call_589495: Call_TagmanagerAccountsContainersTriggersUpdate_589480;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a GTM Trigger.
  ## 
  let valid = call_589495.validator(path, query, header, formData, body)
  let scheme = call_589495.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589495.url(scheme.get, call_589495.host, call_589495.base,
                         call_589495.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589495, url, valid)

proc call*(call_589496: Call_TagmanagerAccountsContainersTriggersUpdate_589480;
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
  var path_589497 = newJObject()
  var query_589498 = newJObject()
  var body_589499 = newJObject()
  add(path_589497, "containerId", newJString(containerId))
  add(query_589498, "fields", newJString(fields))
  add(query_589498, "fingerprint", newJString(fingerprint))
  add(query_589498, "quotaUser", newJString(quotaUser))
  add(query_589498, "alt", newJString(alt))
  add(query_589498, "oauth_token", newJString(oauthToken))
  add(path_589497, "accountId", newJString(accountId))
  add(query_589498, "userIp", newJString(userIp))
  add(path_589497, "triggerId", newJString(triggerId))
  add(query_589498, "key", newJString(key))
  if body != nil:
    body_589499 = body
  add(query_589498, "prettyPrint", newJBool(prettyPrint))
  result = call_589496.call(path_589497, query_589498, nil, nil, body_589499)

var tagmanagerAccountsContainersTriggersUpdate* = Call_TagmanagerAccountsContainersTriggersUpdate_589480(
    name: "tagmanagerAccountsContainersTriggersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/triggers/{triggerId}",
    validator: validate_TagmanagerAccountsContainersTriggersUpdate_589481,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTriggersUpdate_589482,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTriggersGet_589463 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersTriggersGet_589465(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersTriggersGet_589464(path: JsonNode;
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
  var valid_589466 = path.getOrDefault("containerId")
  valid_589466 = validateParameter(valid_589466, JString, required = true,
                                 default = nil)
  if valid_589466 != nil:
    section.add "containerId", valid_589466
  var valid_589467 = path.getOrDefault("accountId")
  valid_589467 = validateParameter(valid_589467, JString, required = true,
                                 default = nil)
  if valid_589467 != nil:
    section.add "accountId", valid_589467
  var valid_589468 = path.getOrDefault("triggerId")
  valid_589468 = validateParameter(valid_589468, JString, required = true,
                                 default = nil)
  if valid_589468 != nil:
    section.add "triggerId", valid_589468
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
  var valid_589469 = query.getOrDefault("fields")
  valid_589469 = validateParameter(valid_589469, JString, required = false,
                                 default = nil)
  if valid_589469 != nil:
    section.add "fields", valid_589469
  var valid_589470 = query.getOrDefault("quotaUser")
  valid_589470 = validateParameter(valid_589470, JString, required = false,
                                 default = nil)
  if valid_589470 != nil:
    section.add "quotaUser", valid_589470
  var valid_589471 = query.getOrDefault("alt")
  valid_589471 = validateParameter(valid_589471, JString, required = false,
                                 default = newJString("json"))
  if valid_589471 != nil:
    section.add "alt", valid_589471
  var valid_589472 = query.getOrDefault("oauth_token")
  valid_589472 = validateParameter(valid_589472, JString, required = false,
                                 default = nil)
  if valid_589472 != nil:
    section.add "oauth_token", valid_589472
  var valid_589473 = query.getOrDefault("userIp")
  valid_589473 = validateParameter(valid_589473, JString, required = false,
                                 default = nil)
  if valid_589473 != nil:
    section.add "userIp", valid_589473
  var valid_589474 = query.getOrDefault("key")
  valid_589474 = validateParameter(valid_589474, JString, required = false,
                                 default = nil)
  if valid_589474 != nil:
    section.add "key", valid_589474
  var valid_589475 = query.getOrDefault("prettyPrint")
  valid_589475 = validateParameter(valid_589475, JBool, required = false,
                                 default = newJBool(true))
  if valid_589475 != nil:
    section.add "prettyPrint", valid_589475
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589476: Call_TagmanagerAccountsContainersTriggersGet_589463;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a GTM Trigger.
  ## 
  let valid = call_589476.validator(path, query, header, formData, body)
  let scheme = call_589476.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589476.url(scheme.get, call_589476.host, call_589476.base,
                         call_589476.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589476, url, valid)

proc call*(call_589477: Call_TagmanagerAccountsContainersTriggersGet_589463;
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
  var path_589478 = newJObject()
  var query_589479 = newJObject()
  add(path_589478, "containerId", newJString(containerId))
  add(query_589479, "fields", newJString(fields))
  add(query_589479, "quotaUser", newJString(quotaUser))
  add(query_589479, "alt", newJString(alt))
  add(query_589479, "oauth_token", newJString(oauthToken))
  add(path_589478, "accountId", newJString(accountId))
  add(query_589479, "userIp", newJString(userIp))
  add(path_589478, "triggerId", newJString(triggerId))
  add(query_589479, "key", newJString(key))
  add(query_589479, "prettyPrint", newJBool(prettyPrint))
  result = call_589477.call(path_589478, query_589479, nil, nil, nil)

var tagmanagerAccountsContainersTriggersGet* = Call_TagmanagerAccountsContainersTriggersGet_589463(
    name: "tagmanagerAccountsContainersTriggersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/triggers/{triggerId}",
    validator: validate_TagmanagerAccountsContainersTriggersGet_589464,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTriggersGet_589465,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersTriggersDelete_589500 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersTriggersDelete_589502(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersTriggersDelete_589501(path: JsonNode;
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
  var valid_589503 = path.getOrDefault("containerId")
  valid_589503 = validateParameter(valid_589503, JString, required = true,
                                 default = nil)
  if valid_589503 != nil:
    section.add "containerId", valid_589503
  var valid_589504 = path.getOrDefault("accountId")
  valid_589504 = validateParameter(valid_589504, JString, required = true,
                                 default = nil)
  if valid_589504 != nil:
    section.add "accountId", valid_589504
  var valid_589505 = path.getOrDefault("triggerId")
  valid_589505 = validateParameter(valid_589505, JString, required = true,
                                 default = nil)
  if valid_589505 != nil:
    section.add "triggerId", valid_589505
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
  var valid_589506 = query.getOrDefault("fields")
  valid_589506 = validateParameter(valid_589506, JString, required = false,
                                 default = nil)
  if valid_589506 != nil:
    section.add "fields", valid_589506
  var valid_589507 = query.getOrDefault("quotaUser")
  valid_589507 = validateParameter(valid_589507, JString, required = false,
                                 default = nil)
  if valid_589507 != nil:
    section.add "quotaUser", valid_589507
  var valid_589508 = query.getOrDefault("alt")
  valid_589508 = validateParameter(valid_589508, JString, required = false,
                                 default = newJString("json"))
  if valid_589508 != nil:
    section.add "alt", valid_589508
  var valid_589509 = query.getOrDefault("oauth_token")
  valid_589509 = validateParameter(valid_589509, JString, required = false,
                                 default = nil)
  if valid_589509 != nil:
    section.add "oauth_token", valid_589509
  var valid_589510 = query.getOrDefault("userIp")
  valid_589510 = validateParameter(valid_589510, JString, required = false,
                                 default = nil)
  if valid_589510 != nil:
    section.add "userIp", valid_589510
  var valid_589511 = query.getOrDefault("key")
  valid_589511 = validateParameter(valid_589511, JString, required = false,
                                 default = nil)
  if valid_589511 != nil:
    section.add "key", valid_589511
  var valid_589512 = query.getOrDefault("prettyPrint")
  valid_589512 = validateParameter(valid_589512, JBool, required = false,
                                 default = newJBool(true))
  if valid_589512 != nil:
    section.add "prettyPrint", valid_589512
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589513: Call_TagmanagerAccountsContainersTriggersDelete_589500;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a GTM Trigger.
  ## 
  let valid = call_589513.validator(path, query, header, formData, body)
  let scheme = call_589513.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589513.url(scheme.get, call_589513.host, call_589513.base,
                         call_589513.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589513, url, valid)

proc call*(call_589514: Call_TagmanagerAccountsContainersTriggersDelete_589500;
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
  var path_589515 = newJObject()
  var query_589516 = newJObject()
  add(path_589515, "containerId", newJString(containerId))
  add(query_589516, "fields", newJString(fields))
  add(query_589516, "quotaUser", newJString(quotaUser))
  add(query_589516, "alt", newJString(alt))
  add(query_589516, "oauth_token", newJString(oauthToken))
  add(path_589515, "accountId", newJString(accountId))
  add(query_589516, "userIp", newJString(userIp))
  add(path_589515, "triggerId", newJString(triggerId))
  add(query_589516, "key", newJString(key))
  add(query_589516, "prettyPrint", newJBool(prettyPrint))
  result = call_589514.call(path_589515, query_589516, nil, nil, nil)

var tagmanagerAccountsContainersTriggersDelete* = Call_TagmanagerAccountsContainersTriggersDelete_589500(
    name: "tagmanagerAccountsContainersTriggersDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/triggers/{triggerId}",
    validator: validate_TagmanagerAccountsContainersTriggersDelete_589501,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersTriggersDelete_589502,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVariablesCreate_589533 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersVariablesCreate_589535(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersVariablesCreate_589534(path: JsonNode;
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
  var valid_589536 = path.getOrDefault("containerId")
  valid_589536 = validateParameter(valid_589536, JString, required = true,
                                 default = nil)
  if valid_589536 != nil:
    section.add "containerId", valid_589536
  var valid_589537 = path.getOrDefault("accountId")
  valid_589537 = validateParameter(valid_589537, JString, required = true,
                                 default = nil)
  if valid_589537 != nil:
    section.add "accountId", valid_589537
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
  var valid_589538 = query.getOrDefault("fields")
  valid_589538 = validateParameter(valid_589538, JString, required = false,
                                 default = nil)
  if valid_589538 != nil:
    section.add "fields", valid_589538
  var valid_589539 = query.getOrDefault("quotaUser")
  valid_589539 = validateParameter(valid_589539, JString, required = false,
                                 default = nil)
  if valid_589539 != nil:
    section.add "quotaUser", valid_589539
  var valid_589540 = query.getOrDefault("alt")
  valid_589540 = validateParameter(valid_589540, JString, required = false,
                                 default = newJString("json"))
  if valid_589540 != nil:
    section.add "alt", valid_589540
  var valid_589541 = query.getOrDefault("oauth_token")
  valid_589541 = validateParameter(valid_589541, JString, required = false,
                                 default = nil)
  if valid_589541 != nil:
    section.add "oauth_token", valid_589541
  var valid_589542 = query.getOrDefault("userIp")
  valid_589542 = validateParameter(valid_589542, JString, required = false,
                                 default = nil)
  if valid_589542 != nil:
    section.add "userIp", valid_589542
  var valid_589543 = query.getOrDefault("key")
  valid_589543 = validateParameter(valid_589543, JString, required = false,
                                 default = nil)
  if valid_589543 != nil:
    section.add "key", valid_589543
  var valid_589544 = query.getOrDefault("prettyPrint")
  valid_589544 = validateParameter(valid_589544, JBool, required = false,
                                 default = newJBool(true))
  if valid_589544 != nil:
    section.add "prettyPrint", valid_589544
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

proc call*(call_589546: Call_TagmanagerAccountsContainersVariablesCreate_589533;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a GTM Variable.
  ## 
  let valid = call_589546.validator(path, query, header, formData, body)
  let scheme = call_589546.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589546.url(scheme.get, call_589546.host, call_589546.base,
                         call_589546.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589546, url, valid)

proc call*(call_589547: Call_TagmanagerAccountsContainersVariablesCreate_589533;
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
  var path_589548 = newJObject()
  var query_589549 = newJObject()
  var body_589550 = newJObject()
  add(path_589548, "containerId", newJString(containerId))
  add(query_589549, "fields", newJString(fields))
  add(query_589549, "quotaUser", newJString(quotaUser))
  add(query_589549, "alt", newJString(alt))
  add(query_589549, "oauth_token", newJString(oauthToken))
  add(path_589548, "accountId", newJString(accountId))
  add(query_589549, "userIp", newJString(userIp))
  add(query_589549, "key", newJString(key))
  if body != nil:
    body_589550 = body
  add(query_589549, "prettyPrint", newJBool(prettyPrint))
  result = call_589547.call(path_589548, query_589549, nil, nil, body_589550)

var tagmanagerAccountsContainersVariablesCreate* = Call_TagmanagerAccountsContainersVariablesCreate_589533(
    name: "tagmanagerAccountsContainersVariablesCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/variables",
    validator: validate_TagmanagerAccountsContainersVariablesCreate_589534,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVariablesCreate_589535,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVariablesList_589517 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersVariablesList_589519(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersVariablesList_589518(path: JsonNode;
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
  var valid_589520 = path.getOrDefault("containerId")
  valid_589520 = validateParameter(valid_589520, JString, required = true,
                                 default = nil)
  if valid_589520 != nil:
    section.add "containerId", valid_589520
  var valid_589521 = path.getOrDefault("accountId")
  valid_589521 = validateParameter(valid_589521, JString, required = true,
                                 default = nil)
  if valid_589521 != nil:
    section.add "accountId", valid_589521
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
  var valid_589522 = query.getOrDefault("fields")
  valid_589522 = validateParameter(valid_589522, JString, required = false,
                                 default = nil)
  if valid_589522 != nil:
    section.add "fields", valid_589522
  var valid_589523 = query.getOrDefault("quotaUser")
  valid_589523 = validateParameter(valid_589523, JString, required = false,
                                 default = nil)
  if valid_589523 != nil:
    section.add "quotaUser", valid_589523
  var valid_589524 = query.getOrDefault("alt")
  valid_589524 = validateParameter(valid_589524, JString, required = false,
                                 default = newJString("json"))
  if valid_589524 != nil:
    section.add "alt", valid_589524
  var valid_589525 = query.getOrDefault("oauth_token")
  valid_589525 = validateParameter(valid_589525, JString, required = false,
                                 default = nil)
  if valid_589525 != nil:
    section.add "oauth_token", valid_589525
  var valid_589526 = query.getOrDefault("userIp")
  valid_589526 = validateParameter(valid_589526, JString, required = false,
                                 default = nil)
  if valid_589526 != nil:
    section.add "userIp", valid_589526
  var valid_589527 = query.getOrDefault("key")
  valid_589527 = validateParameter(valid_589527, JString, required = false,
                                 default = nil)
  if valid_589527 != nil:
    section.add "key", valid_589527
  var valid_589528 = query.getOrDefault("prettyPrint")
  valid_589528 = validateParameter(valid_589528, JBool, required = false,
                                 default = newJBool(true))
  if valid_589528 != nil:
    section.add "prettyPrint", valid_589528
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589529: Call_TagmanagerAccountsContainersVariablesList_589517;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all GTM Variables of a Container.
  ## 
  let valid = call_589529.validator(path, query, header, formData, body)
  let scheme = call_589529.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589529.url(scheme.get, call_589529.host, call_589529.base,
                         call_589529.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589529, url, valid)

proc call*(call_589530: Call_TagmanagerAccountsContainersVariablesList_589517;
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
  var path_589531 = newJObject()
  var query_589532 = newJObject()
  add(path_589531, "containerId", newJString(containerId))
  add(query_589532, "fields", newJString(fields))
  add(query_589532, "quotaUser", newJString(quotaUser))
  add(query_589532, "alt", newJString(alt))
  add(query_589532, "oauth_token", newJString(oauthToken))
  add(path_589531, "accountId", newJString(accountId))
  add(query_589532, "userIp", newJString(userIp))
  add(query_589532, "key", newJString(key))
  add(query_589532, "prettyPrint", newJBool(prettyPrint))
  result = call_589530.call(path_589531, query_589532, nil, nil, nil)

var tagmanagerAccountsContainersVariablesList* = Call_TagmanagerAccountsContainersVariablesList_589517(
    name: "tagmanagerAccountsContainersVariablesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/variables",
    validator: validate_TagmanagerAccountsContainersVariablesList_589518,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVariablesList_589519,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVariablesUpdate_589568 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersVariablesUpdate_589570(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersVariablesUpdate_589569(path: JsonNode;
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
  var valid_589571 = path.getOrDefault("containerId")
  valid_589571 = validateParameter(valid_589571, JString, required = true,
                                 default = nil)
  if valid_589571 != nil:
    section.add "containerId", valid_589571
  var valid_589572 = path.getOrDefault("variableId")
  valid_589572 = validateParameter(valid_589572, JString, required = true,
                                 default = nil)
  if valid_589572 != nil:
    section.add "variableId", valid_589572
  var valid_589573 = path.getOrDefault("accountId")
  valid_589573 = validateParameter(valid_589573, JString, required = true,
                                 default = nil)
  if valid_589573 != nil:
    section.add "accountId", valid_589573
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
  var valid_589574 = query.getOrDefault("fields")
  valid_589574 = validateParameter(valid_589574, JString, required = false,
                                 default = nil)
  if valid_589574 != nil:
    section.add "fields", valid_589574
  var valid_589575 = query.getOrDefault("fingerprint")
  valid_589575 = validateParameter(valid_589575, JString, required = false,
                                 default = nil)
  if valid_589575 != nil:
    section.add "fingerprint", valid_589575
  var valid_589576 = query.getOrDefault("quotaUser")
  valid_589576 = validateParameter(valid_589576, JString, required = false,
                                 default = nil)
  if valid_589576 != nil:
    section.add "quotaUser", valid_589576
  var valid_589577 = query.getOrDefault("alt")
  valid_589577 = validateParameter(valid_589577, JString, required = false,
                                 default = newJString("json"))
  if valid_589577 != nil:
    section.add "alt", valid_589577
  var valid_589578 = query.getOrDefault("oauth_token")
  valid_589578 = validateParameter(valid_589578, JString, required = false,
                                 default = nil)
  if valid_589578 != nil:
    section.add "oauth_token", valid_589578
  var valid_589579 = query.getOrDefault("userIp")
  valid_589579 = validateParameter(valid_589579, JString, required = false,
                                 default = nil)
  if valid_589579 != nil:
    section.add "userIp", valid_589579
  var valid_589580 = query.getOrDefault("key")
  valid_589580 = validateParameter(valid_589580, JString, required = false,
                                 default = nil)
  if valid_589580 != nil:
    section.add "key", valid_589580
  var valid_589581 = query.getOrDefault("prettyPrint")
  valid_589581 = validateParameter(valid_589581, JBool, required = false,
                                 default = newJBool(true))
  if valid_589581 != nil:
    section.add "prettyPrint", valid_589581
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

proc call*(call_589583: Call_TagmanagerAccountsContainersVariablesUpdate_589568;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a GTM Variable.
  ## 
  let valid = call_589583.validator(path, query, header, formData, body)
  let scheme = call_589583.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589583.url(scheme.get, call_589583.host, call_589583.base,
                         call_589583.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589583, url, valid)

proc call*(call_589584: Call_TagmanagerAccountsContainersVariablesUpdate_589568;
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
  var path_589585 = newJObject()
  var query_589586 = newJObject()
  var body_589587 = newJObject()
  add(path_589585, "containerId", newJString(containerId))
  add(query_589586, "fields", newJString(fields))
  add(query_589586, "fingerprint", newJString(fingerprint))
  add(query_589586, "quotaUser", newJString(quotaUser))
  add(query_589586, "alt", newJString(alt))
  add(path_589585, "variableId", newJString(variableId))
  add(query_589586, "oauth_token", newJString(oauthToken))
  add(path_589585, "accountId", newJString(accountId))
  add(query_589586, "userIp", newJString(userIp))
  add(query_589586, "key", newJString(key))
  if body != nil:
    body_589587 = body
  add(query_589586, "prettyPrint", newJBool(prettyPrint))
  result = call_589584.call(path_589585, query_589586, nil, nil, body_589587)

var tagmanagerAccountsContainersVariablesUpdate* = Call_TagmanagerAccountsContainersVariablesUpdate_589568(
    name: "tagmanagerAccountsContainersVariablesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/variables/{variableId}",
    validator: validate_TagmanagerAccountsContainersVariablesUpdate_589569,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVariablesUpdate_589570,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVariablesGet_589551 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersVariablesGet_589553(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersVariablesGet_589552(path: JsonNode;
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
  var valid_589554 = path.getOrDefault("containerId")
  valid_589554 = validateParameter(valid_589554, JString, required = true,
                                 default = nil)
  if valid_589554 != nil:
    section.add "containerId", valid_589554
  var valid_589555 = path.getOrDefault("variableId")
  valid_589555 = validateParameter(valid_589555, JString, required = true,
                                 default = nil)
  if valid_589555 != nil:
    section.add "variableId", valid_589555
  var valid_589556 = path.getOrDefault("accountId")
  valid_589556 = validateParameter(valid_589556, JString, required = true,
                                 default = nil)
  if valid_589556 != nil:
    section.add "accountId", valid_589556
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
  var valid_589557 = query.getOrDefault("fields")
  valid_589557 = validateParameter(valid_589557, JString, required = false,
                                 default = nil)
  if valid_589557 != nil:
    section.add "fields", valid_589557
  var valid_589558 = query.getOrDefault("quotaUser")
  valid_589558 = validateParameter(valid_589558, JString, required = false,
                                 default = nil)
  if valid_589558 != nil:
    section.add "quotaUser", valid_589558
  var valid_589559 = query.getOrDefault("alt")
  valid_589559 = validateParameter(valid_589559, JString, required = false,
                                 default = newJString("json"))
  if valid_589559 != nil:
    section.add "alt", valid_589559
  var valid_589560 = query.getOrDefault("oauth_token")
  valid_589560 = validateParameter(valid_589560, JString, required = false,
                                 default = nil)
  if valid_589560 != nil:
    section.add "oauth_token", valid_589560
  var valid_589561 = query.getOrDefault("userIp")
  valid_589561 = validateParameter(valid_589561, JString, required = false,
                                 default = nil)
  if valid_589561 != nil:
    section.add "userIp", valid_589561
  var valid_589562 = query.getOrDefault("key")
  valid_589562 = validateParameter(valid_589562, JString, required = false,
                                 default = nil)
  if valid_589562 != nil:
    section.add "key", valid_589562
  var valid_589563 = query.getOrDefault("prettyPrint")
  valid_589563 = validateParameter(valid_589563, JBool, required = false,
                                 default = newJBool(true))
  if valid_589563 != nil:
    section.add "prettyPrint", valid_589563
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589564: Call_TagmanagerAccountsContainersVariablesGet_589551;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a GTM Variable.
  ## 
  let valid = call_589564.validator(path, query, header, formData, body)
  let scheme = call_589564.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589564.url(scheme.get, call_589564.host, call_589564.base,
                         call_589564.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589564, url, valid)

proc call*(call_589565: Call_TagmanagerAccountsContainersVariablesGet_589551;
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
  var path_589566 = newJObject()
  var query_589567 = newJObject()
  add(path_589566, "containerId", newJString(containerId))
  add(query_589567, "fields", newJString(fields))
  add(query_589567, "quotaUser", newJString(quotaUser))
  add(query_589567, "alt", newJString(alt))
  add(path_589566, "variableId", newJString(variableId))
  add(query_589567, "oauth_token", newJString(oauthToken))
  add(path_589566, "accountId", newJString(accountId))
  add(query_589567, "userIp", newJString(userIp))
  add(query_589567, "key", newJString(key))
  add(query_589567, "prettyPrint", newJBool(prettyPrint))
  result = call_589565.call(path_589566, query_589567, nil, nil, nil)

var tagmanagerAccountsContainersVariablesGet* = Call_TagmanagerAccountsContainersVariablesGet_589551(
    name: "tagmanagerAccountsContainersVariablesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/variables/{variableId}",
    validator: validate_TagmanagerAccountsContainersVariablesGet_589552,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVariablesGet_589553,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVariablesDelete_589588 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersVariablesDelete_589590(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersVariablesDelete_589589(path: JsonNode;
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
  var valid_589591 = path.getOrDefault("containerId")
  valid_589591 = validateParameter(valid_589591, JString, required = true,
                                 default = nil)
  if valid_589591 != nil:
    section.add "containerId", valid_589591
  var valid_589592 = path.getOrDefault("variableId")
  valid_589592 = validateParameter(valid_589592, JString, required = true,
                                 default = nil)
  if valid_589592 != nil:
    section.add "variableId", valid_589592
  var valid_589593 = path.getOrDefault("accountId")
  valid_589593 = validateParameter(valid_589593, JString, required = true,
                                 default = nil)
  if valid_589593 != nil:
    section.add "accountId", valid_589593
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
  var valid_589594 = query.getOrDefault("fields")
  valid_589594 = validateParameter(valid_589594, JString, required = false,
                                 default = nil)
  if valid_589594 != nil:
    section.add "fields", valid_589594
  var valid_589595 = query.getOrDefault("quotaUser")
  valid_589595 = validateParameter(valid_589595, JString, required = false,
                                 default = nil)
  if valid_589595 != nil:
    section.add "quotaUser", valid_589595
  var valid_589596 = query.getOrDefault("alt")
  valid_589596 = validateParameter(valid_589596, JString, required = false,
                                 default = newJString("json"))
  if valid_589596 != nil:
    section.add "alt", valid_589596
  var valid_589597 = query.getOrDefault("oauth_token")
  valid_589597 = validateParameter(valid_589597, JString, required = false,
                                 default = nil)
  if valid_589597 != nil:
    section.add "oauth_token", valid_589597
  var valid_589598 = query.getOrDefault("userIp")
  valid_589598 = validateParameter(valid_589598, JString, required = false,
                                 default = nil)
  if valid_589598 != nil:
    section.add "userIp", valid_589598
  var valid_589599 = query.getOrDefault("key")
  valid_589599 = validateParameter(valid_589599, JString, required = false,
                                 default = nil)
  if valid_589599 != nil:
    section.add "key", valid_589599
  var valid_589600 = query.getOrDefault("prettyPrint")
  valid_589600 = validateParameter(valid_589600, JBool, required = false,
                                 default = newJBool(true))
  if valid_589600 != nil:
    section.add "prettyPrint", valid_589600
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589601: Call_TagmanagerAccountsContainersVariablesDelete_589588;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a GTM Variable.
  ## 
  let valid = call_589601.validator(path, query, header, formData, body)
  let scheme = call_589601.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589601.url(scheme.get, call_589601.host, call_589601.base,
                         call_589601.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589601, url, valid)

proc call*(call_589602: Call_TagmanagerAccountsContainersVariablesDelete_589588;
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
  var path_589603 = newJObject()
  var query_589604 = newJObject()
  add(path_589603, "containerId", newJString(containerId))
  add(query_589604, "fields", newJString(fields))
  add(query_589604, "quotaUser", newJString(quotaUser))
  add(query_589604, "alt", newJString(alt))
  add(path_589603, "variableId", newJString(variableId))
  add(query_589604, "oauth_token", newJString(oauthToken))
  add(path_589603, "accountId", newJString(accountId))
  add(query_589604, "userIp", newJString(userIp))
  add(query_589604, "key", newJString(key))
  add(query_589604, "prettyPrint", newJBool(prettyPrint))
  result = call_589602.call(path_589603, query_589604, nil, nil, nil)

var tagmanagerAccountsContainersVariablesDelete* = Call_TagmanagerAccountsContainersVariablesDelete_589588(
    name: "tagmanagerAccountsContainersVariablesDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/variables/{variableId}",
    validator: validate_TagmanagerAccountsContainersVariablesDelete_589589,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVariablesDelete_589590,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsCreate_589623 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersVersionsCreate_589625(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersVersionsCreate_589624(path: JsonNode;
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
  var valid_589626 = path.getOrDefault("containerId")
  valid_589626 = validateParameter(valid_589626, JString, required = true,
                                 default = nil)
  if valid_589626 != nil:
    section.add "containerId", valid_589626
  var valid_589627 = path.getOrDefault("accountId")
  valid_589627 = validateParameter(valid_589627, JString, required = true,
                                 default = nil)
  if valid_589627 != nil:
    section.add "accountId", valid_589627
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
  var valid_589628 = query.getOrDefault("fields")
  valid_589628 = validateParameter(valid_589628, JString, required = false,
                                 default = nil)
  if valid_589628 != nil:
    section.add "fields", valid_589628
  var valid_589629 = query.getOrDefault("quotaUser")
  valid_589629 = validateParameter(valid_589629, JString, required = false,
                                 default = nil)
  if valid_589629 != nil:
    section.add "quotaUser", valid_589629
  var valid_589630 = query.getOrDefault("alt")
  valid_589630 = validateParameter(valid_589630, JString, required = false,
                                 default = newJString("json"))
  if valid_589630 != nil:
    section.add "alt", valid_589630
  var valid_589631 = query.getOrDefault("oauth_token")
  valid_589631 = validateParameter(valid_589631, JString, required = false,
                                 default = nil)
  if valid_589631 != nil:
    section.add "oauth_token", valid_589631
  var valid_589632 = query.getOrDefault("userIp")
  valid_589632 = validateParameter(valid_589632, JString, required = false,
                                 default = nil)
  if valid_589632 != nil:
    section.add "userIp", valid_589632
  var valid_589633 = query.getOrDefault("key")
  valid_589633 = validateParameter(valid_589633, JString, required = false,
                                 default = nil)
  if valid_589633 != nil:
    section.add "key", valid_589633
  var valid_589634 = query.getOrDefault("prettyPrint")
  valid_589634 = validateParameter(valid_589634, JBool, required = false,
                                 default = newJBool(true))
  if valid_589634 != nil:
    section.add "prettyPrint", valid_589634
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

proc call*(call_589636: Call_TagmanagerAccountsContainersVersionsCreate_589623;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Container Version.
  ## 
  let valid = call_589636.validator(path, query, header, formData, body)
  let scheme = call_589636.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589636.url(scheme.get, call_589636.host, call_589636.base,
                         call_589636.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589636, url, valid)

proc call*(call_589637: Call_TagmanagerAccountsContainersVersionsCreate_589623;
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
  var path_589638 = newJObject()
  var query_589639 = newJObject()
  var body_589640 = newJObject()
  add(path_589638, "containerId", newJString(containerId))
  add(query_589639, "fields", newJString(fields))
  add(query_589639, "quotaUser", newJString(quotaUser))
  add(query_589639, "alt", newJString(alt))
  add(query_589639, "oauth_token", newJString(oauthToken))
  add(path_589638, "accountId", newJString(accountId))
  add(query_589639, "userIp", newJString(userIp))
  add(query_589639, "key", newJString(key))
  if body != nil:
    body_589640 = body
  add(query_589639, "prettyPrint", newJBool(prettyPrint))
  result = call_589637.call(path_589638, query_589639, nil, nil, body_589640)

var tagmanagerAccountsContainersVersionsCreate* = Call_TagmanagerAccountsContainersVersionsCreate_589623(
    name: "tagmanagerAccountsContainersVersionsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/versions",
    validator: validate_TagmanagerAccountsContainersVersionsCreate_589624,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsCreate_589625,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsList_589605 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersVersionsList_589607(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersVersionsList_589606(path: JsonNode;
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
  var valid_589608 = path.getOrDefault("containerId")
  valid_589608 = validateParameter(valid_589608, JString, required = true,
                                 default = nil)
  if valid_589608 != nil:
    section.add "containerId", valid_589608
  var valid_589609 = path.getOrDefault("accountId")
  valid_589609 = validateParameter(valid_589609, JString, required = true,
                                 default = nil)
  if valid_589609 != nil:
    section.add "accountId", valid_589609
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
  var valid_589610 = query.getOrDefault("headers")
  valid_589610 = validateParameter(valid_589610, JBool, required = false,
                                 default = newJBool(false))
  if valid_589610 != nil:
    section.add "headers", valid_589610
  var valid_589611 = query.getOrDefault("fields")
  valid_589611 = validateParameter(valid_589611, JString, required = false,
                                 default = nil)
  if valid_589611 != nil:
    section.add "fields", valid_589611
  var valid_589612 = query.getOrDefault("quotaUser")
  valid_589612 = validateParameter(valid_589612, JString, required = false,
                                 default = nil)
  if valid_589612 != nil:
    section.add "quotaUser", valid_589612
  var valid_589613 = query.getOrDefault("alt")
  valid_589613 = validateParameter(valid_589613, JString, required = false,
                                 default = newJString("json"))
  if valid_589613 != nil:
    section.add "alt", valid_589613
  var valid_589614 = query.getOrDefault("oauth_token")
  valid_589614 = validateParameter(valid_589614, JString, required = false,
                                 default = nil)
  if valid_589614 != nil:
    section.add "oauth_token", valid_589614
  var valid_589615 = query.getOrDefault("userIp")
  valid_589615 = validateParameter(valid_589615, JString, required = false,
                                 default = nil)
  if valid_589615 != nil:
    section.add "userIp", valid_589615
  var valid_589616 = query.getOrDefault("key")
  valid_589616 = validateParameter(valid_589616, JString, required = false,
                                 default = nil)
  if valid_589616 != nil:
    section.add "key", valid_589616
  var valid_589617 = query.getOrDefault("includeDeleted")
  valid_589617 = validateParameter(valid_589617, JBool, required = false,
                                 default = newJBool(false))
  if valid_589617 != nil:
    section.add "includeDeleted", valid_589617
  var valid_589618 = query.getOrDefault("prettyPrint")
  valid_589618 = validateParameter(valid_589618, JBool, required = false,
                                 default = newJBool(true))
  if valid_589618 != nil:
    section.add "prettyPrint", valid_589618
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589619: Call_TagmanagerAccountsContainersVersionsList_589605;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all Container Versions of a GTM Container.
  ## 
  let valid = call_589619.validator(path, query, header, formData, body)
  let scheme = call_589619.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589619.url(scheme.get, call_589619.host, call_589619.base,
                         call_589619.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589619, url, valid)

proc call*(call_589620: Call_TagmanagerAccountsContainersVersionsList_589605;
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
  var path_589621 = newJObject()
  var query_589622 = newJObject()
  add(query_589622, "headers", newJBool(headers))
  add(path_589621, "containerId", newJString(containerId))
  add(query_589622, "fields", newJString(fields))
  add(query_589622, "quotaUser", newJString(quotaUser))
  add(query_589622, "alt", newJString(alt))
  add(query_589622, "oauth_token", newJString(oauthToken))
  add(path_589621, "accountId", newJString(accountId))
  add(query_589622, "userIp", newJString(userIp))
  add(query_589622, "key", newJString(key))
  add(query_589622, "includeDeleted", newJBool(includeDeleted))
  add(query_589622, "prettyPrint", newJBool(prettyPrint))
  result = call_589620.call(path_589621, query_589622, nil, nil, nil)

var tagmanagerAccountsContainersVersionsList* = Call_TagmanagerAccountsContainersVersionsList_589605(
    name: "tagmanagerAccountsContainersVersionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/containers/{containerId}/versions",
    validator: validate_TagmanagerAccountsContainersVersionsList_589606,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsList_589607,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsUpdate_589658 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersVersionsUpdate_589660(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersVersionsUpdate_589659(path: JsonNode;
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
  var valid_589661 = path.getOrDefault("containerId")
  valid_589661 = validateParameter(valid_589661, JString, required = true,
                                 default = nil)
  if valid_589661 != nil:
    section.add "containerId", valid_589661
  var valid_589662 = path.getOrDefault("accountId")
  valid_589662 = validateParameter(valid_589662, JString, required = true,
                                 default = nil)
  if valid_589662 != nil:
    section.add "accountId", valid_589662
  var valid_589663 = path.getOrDefault("containerVersionId")
  valid_589663 = validateParameter(valid_589663, JString, required = true,
                                 default = nil)
  if valid_589663 != nil:
    section.add "containerVersionId", valid_589663
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
  var valid_589664 = query.getOrDefault("fields")
  valid_589664 = validateParameter(valid_589664, JString, required = false,
                                 default = nil)
  if valid_589664 != nil:
    section.add "fields", valid_589664
  var valid_589665 = query.getOrDefault("fingerprint")
  valid_589665 = validateParameter(valid_589665, JString, required = false,
                                 default = nil)
  if valid_589665 != nil:
    section.add "fingerprint", valid_589665
  var valid_589666 = query.getOrDefault("quotaUser")
  valid_589666 = validateParameter(valid_589666, JString, required = false,
                                 default = nil)
  if valid_589666 != nil:
    section.add "quotaUser", valid_589666
  var valid_589667 = query.getOrDefault("alt")
  valid_589667 = validateParameter(valid_589667, JString, required = false,
                                 default = newJString("json"))
  if valid_589667 != nil:
    section.add "alt", valid_589667
  var valid_589668 = query.getOrDefault("oauth_token")
  valid_589668 = validateParameter(valid_589668, JString, required = false,
                                 default = nil)
  if valid_589668 != nil:
    section.add "oauth_token", valid_589668
  var valid_589669 = query.getOrDefault("userIp")
  valid_589669 = validateParameter(valid_589669, JString, required = false,
                                 default = nil)
  if valid_589669 != nil:
    section.add "userIp", valid_589669
  var valid_589670 = query.getOrDefault("key")
  valid_589670 = validateParameter(valid_589670, JString, required = false,
                                 default = nil)
  if valid_589670 != nil:
    section.add "key", valid_589670
  var valid_589671 = query.getOrDefault("prettyPrint")
  valid_589671 = validateParameter(valid_589671, JBool, required = false,
                                 default = newJBool(true))
  if valid_589671 != nil:
    section.add "prettyPrint", valid_589671
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

proc call*(call_589673: Call_TagmanagerAccountsContainersVersionsUpdate_589658;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a Container Version.
  ## 
  let valid = call_589673.validator(path, query, header, formData, body)
  let scheme = call_589673.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589673.url(scheme.get, call_589673.host, call_589673.base,
                         call_589673.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589673, url, valid)

proc call*(call_589674: Call_TagmanagerAccountsContainersVersionsUpdate_589658;
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
  var path_589675 = newJObject()
  var query_589676 = newJObject()
  var body_589677 = newJObject()
  add(path_589675, "containerId", newJString(containerId))
  add(query_589676, "fields", newJString(fields))
  add(query_589676, "fingerprint", newJString(fingerprint))
  add(query_589676, "quotaUser", newJString(quotaUser))
  add(query_589676, "alt", newJString(alt))
  add(query_589676, "oauth_token", newJString(oauthToken))
  add(path_589675, "accountId", newJString(accountId))
  add(query_589676, "userIp", newJString(userIp))
  add(path_589675, "containerVersionId", newJString(containerVersionId))
  add(query_589676, "key", newJString(key))
  if body != nil:
    body_589677 = body
  add(query_589676, "prettyPrint", newJBool(prettyPrint))
  result = call_589674.call(path_589675, query_589676, nil, nil, body_589677)

var tagmanagerAccountsContainersVersionsUpdate* = Call_TagmanagerAccountsContainersVersionsUpdate_589658(
    name: "tagmanagerAccountsContainersVersionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/versions/{containerVersionId}",
    validator: validate_TagmanagerAccountsContainersVersionsUpdate_589659,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsUpdate_589660,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsGet_589641 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersVersionsGet_589643(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersVersionsGet_589642(path: JsonNode;
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
  var valid_589644 = path.getOrDefault("containerId")
  valid_589644 = validateParameter(valid_589644, JString, required = true,
                                 default = nil)
  if valid_589644 != nil:
    section.add "containerId", valid_589644
  var valid_589645 = path.getOrDefault("accountId")
  valid_589645 = validateParameter(valid_589645, JString, required = true,
                                 default = nil)
  if valid_589645 != nil:
    section.add "accountId", valid_589645
  var valid_589646 = path.getOrDefault("containerVersionId")
  valid_589646 = validateParameter(valid_589646, JString, required = true,
                                 default = nil)
  if valid_589646 != nil:
    section.add "containerVersionId", valid_589646
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
  var valid_589647 = query.getOrDefault("fields")
  valid_589647 = validateParameter(valid_589647, JString, required = false,
                                 default = nil)
  if valid_589647 != nil:
    section.add "fields", valid_589647
  var valid_589648 = query.getOrDefault("quotaUser")
  valid_589648 = validateParameter(valid_589648, JString, required = false,
                                 default = nil)
  if valid_589648 != nil:
    section.add "quotaUser", valid_589648
  var valid_589649 = query.getOrDefault("alt")
  valid_589649 = validateParameter(valid_589649, JString, required = false,
                                 default = newJString("json"))
  if valid_589649 != nil:
    section.add "alt", valid_589649
  var valid_589650 = query.getOrDefault("oauth_token")
  valid_589650 = validateParameter(valid_589650, JString, required = false,
                                 default = nil)
  if valid_589650 != nil:
    section.add "oauth_token", valid_589650
  var valid_589651 = query.getOrDefault("userIp")
  valid_589651 = validateParameter(valid_589651, JString, required = false,
                                 default = nil)
  if valid_589651 != nil:
    section.add "userIp", valid_589651
  var valid_589652 = query.getOrDefault("key")
  valid_589652 = validateParameter(valid_589652, JString, required = false,
                                 default = nil)
  if valid_589652 != nil:
    section.add "key", valid_589652
  var valid_589653 = query.getOrDefault("prettyPrint")
  valid_589653 = validateParameter(valid_589653, JBool, required = false,
                                 default = newJBool(true))
  if valid_589653 != nil:
    section.add "prettyPrint", valid_589653
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589654: Call_TagmanagerAccountsContainersVersionsGet_589641;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a Container Version.
  ## 
  let valid = call_589654.validator(path, query, header, formData, body)
  let scheme = call_589654.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589654.url(scheme.get, call_589654.host, call_589654.base,
                         call_589654.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589654, url, valid)

proc call*(call_589655: Call_TagmanagerAccountsContainersVersionsGet_589641;
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
  var path_589656 = newJObject()
  var query_589657 = newJObject()
  add(path_589656, "containerId", newJString(containerId))
  add(query_589657, "fields", newJString(fields))
  add(query_589657, "quotaUser", newJString(quotaUser))
  add(query_589657, "alt", newJString(alt))
  add(query_589657, "oauth_token", newJString(oauthToken))
  add(path_589656, "accountId", newJString(accountId))
  add(query_589657, "userIp", newJString(userIp))
  add(path_589656, "containerVersionId", newJString(containerVersionId))
  add(query_589657, "key", newJString(key))
  add(query_589657, "prettyPrint", newJBool(prettyPrint))
  result = call_589655.call(path_589656, query_589657, nil, nil, nil)

var tagmanagerAccountsContainersVersionsGet* = Call_TagmanagerAccountsContainersVersionsGet_589641(
    name: "tagmanagerAccountsContainersVersionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/versions/{containerVersionId}",
    validator: validate_TagmanagerAccountsContainersVersionsGet_589642,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsGet_589643,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsDelete_589678 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersVersionsDelete_589680(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersVersionsDelete_589679(path: JsonNode;
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
  var valid_589681 = path.getOrDefault("containerId")
  valid_589681 = validateParameter(valid_589681, JString, required = true,
                                 default = nil)
  if valid_589681 != nil:
    section.add "containerId", valid_589681
  var valid_589682 = path.getOrDefault("accountId")
  valid_589682 = validateParameter(valid_589682, JString, required = true,
                                 default = nil)
  if valid_589682 != nil:
    section.add "accountId", valid_589682
  var valid_589683 = path.getOrDefault("containerVersionId")
  valid_589683 = validateParameter(valid_589683, JString, required = true,
                                 default = nil)
  if valid_589683 != nil:
    section.add "containerVersionId", valid_589683
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
  var valid_589684 = query.getOrDefault("fields")
  valid_589684 = validateParameter(valid_589684, JString, required = false,
                                 default = nil)
  if valid_589684 != nil:
    section.add "fields", valid_589684
  var valid_589685 = query.getOrDefault("quotaUser")
  valid_589685 = validateParameter(valid_589685, JString, required = false,
                                 default = nil)
  if valid_589685 != nil:
    section.add "quotaUser", valid_589685
  var valid_589686 = query.getOrDefault("alt")
  valid_589686 = validateParameter(valid_589686, JString, required = false,
                                 default = newJString("json"))
  if valid_589686 != nil:
    section.add "alt", valid_589686
  var valid_589687 = query.getOrDefault("oauth_token")
  valid_589687 = validateParameter(valid_589687, JString, required = false,
                                 default = nil)
  if valid_589687 != nil:
    section.add "oauth_token", valid_589687
  var valid_589688 = query.getOrDefault("userIp")
  valid_589688 = validateParameter(valid_589688, JString, required = false,
                                 default = nil)
  if valid_589688 != nil:
    section.add "userIp", valid_589688
  var valid_589689 = query.getOrDefault("key")
  valid_589689 = validateParameter(valid_589689, JString, required = false,
                                 default = nil)
  if valid_589689 != nil:
    section.add "key", valid_589689
  var valid_589690 = query.getOrDefault("prettyPrint")
  valid_589690 = validateParameter(valid_589690, JBool, required = false,
                                 default = newJBool(true))
  if valid_589690 != nil:
    section.add "prettyPrint", valid_589690
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589691: Call_TagmanagerAccountsContainersVersionsDelete_589678;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a Container Version.
  ## 
  let valid = call_589691.validator(path, query, header, formData, body)
  let scheme = call_589691.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589691.url(scheme.get, call_589691.host, call_589691.base,
                         call_589691.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589691, url, valid)

proc call*(call_589692: Call_TagmanagerAccountsContainersVersionsDelete_589678;
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
  var path_589693 = newJObject()
  var query_589694 = newJObject()
  add(path_589693, "containerId", newJString(containerId))
  add(query_589694, "fields", newJString(fields))
  add(query_589694, "quotaUser", newJString(quotaUser))
  add(query_589694, "alt", newJString(alt))
  add(query_589694, "oauth_token", newJString(oauthToken))
  add(path_589693, "accountId", newJString(accountId))
  add(query_589694, "userIp", newJString(userIp))
  add(path_589693, "containerVersionId", newJString(containerVersionId))
  add(query_589694, "key", newJString(key))
  add(query_589694, "prettyPrint", newJBool(prettyPrint))
  result = call_589692.call(path_589693, query_589694, nil, nil, nil)

var tagmanagerAccountsContainersVersionsDelete* = Call_TagmanagerAccountsContainersVersionsDelete_589678(
    name: "tagmanagerAccountsContainersVersionsDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/versions/{containerVersionId}",
    validator: validate_TagmanagerAccountsContainersVersionsDelete_589679,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsDelete_589680,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsPublish_589695 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersVersionsPublish_589697(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersVersionsPublish_589696(path: JsonNode;
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
  var valid_589698 = path.getOrDefault("containerId")
  valid_589698 = validateParameter(valid_589698, JString, required = true,
                                 default = nil)
  if valid_589698 != nil:
    section.add "containerId", valid_589698
  var valid_589699 = path.getOrDefault("accountId")
  valid_589699 = validateParameter(valid_589699, JString, required = true,
                                 default = nil)
  if valid_589699 != nil:
    section.add "accountId", valid_589699
  var valid_589700 = path.getOrDefault("containerVersionId")
  valid_589700 = validateParameter(valid_589700, JString, required = true,
                                 default = nil)
  if valid_589700 != nil:
    section.add "containerVersionId", valid_589700
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
  var valid_589701 = query.getOrDefault("fields")
  valid_589701 = validateParameter(valid_589701, JString, required = false,
                                 default = nil)
  if valid_589701 != nil:
    section.add "fields", valid_589701
  var valid_589702 = query.getOrDefault("fingerprint")
  valid_589702 = validateParameter(valid_589702, JString, required = false,
                                 default = nil)
  if valid_589702 != nil:
    section.add "fingerprint", valid_589702
  var valid_589703 = query.getOrDefault("quotaUser")
  valid_589703 = validateParameter(valid_589703, JString, required = false,
                                 default = nil)
  if valid_589703 != nil:
    section.add "quotaUser", valid_589703
  var valid_589704 = query.getOrDefault("alt")
  valid_589704 = validateParameter(valid_589704, JString, required = false,
                                 default = newJString("json"))
  if valid_589704 != nil:
    section.add "alt", valid_589704
  var valid_589705 = query.getOrDefault("oauth_token")
  valid_589705 = validateParameter(valid_589705, JString, required = false,
                                 default = nil)
  if valid_589705 != nil:
    section.add "oauth_token", valid_589705
  var valid_589706 = query.getOrDefault("userIp")
  valid_589706 = validateParameter(valid_589706, JString, required = false,
                                 default = nil)
  if valid_589706 != nil:
    section.add "userIp", valid_589706
  var valid_589707 = query.getOrDefault("key")
  valid_589707 = validateParameter(valid_589707, JString, required = false,
                                 default = nil)
  if valid_589707 != nil:
    section.add "key", valid_589707
  var valid_589708 = query.getOrDefault("prettyPrint")
  valid_589708 = validateParameter(valid_589708, JBool, required = false,
                                 default = newJBool(true))
  if valid_589708 != nil:
    section.add "prettyPrint", valid_589708
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589709: Call_TagmanagerAccountsContainersVersionsPublish_589695;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Publishes a Container Version.
  ## 
  let valid = call_589709.validator(path, query, header, formData, body)
  let scheme = call_589709.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589709.url(scheme.get, call_589709.host, call_589709.base,
                         call_589709.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589709, url, valid)

proc call*(call_589710: Call_TagmanagerAccountsContainersVersionsPublish_589695;
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
  var path_589711 = newJObject()
  var query_589712 = newJObject()
  add(path_589711, "containerId", newJString(containerId))
  add(query_589712, "fields", newJString(fields))
  add(query_589712, "fingerprint", newJString(fingerprint))
  add(query_589712, "quotaUser", newJString(quotaUser))
  add(query_589712, "alt", newJString(alt))
  add(query_589712, "oauth_token", newJString(oauthToken))
  add(path_589711, "accountId", newJString(accountId))
  add(query_589712, "userIp", newJString(userIp))
  add(path_589711, "containerVersionId", newJString(containerVersionId))
  add(query_589712, "key", newJString(key))
  add(query_589712, "prettyPrint", newJBool(prettyPrint))
  result = call_589710.call(path_589711, query_589712, nil, nil, nil)

var tagmanagerAccountsContainersVersionsPublish* = Call_TagmanagerAccountsContainersVersionsPublish_589695(
    name: "tagmanagerAccountsContainersVersionsPublish",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/versions/{containerVersionId}/publish",
    validator: validate_TagmanagerAccountsContainersVersionsPublish_589696,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsPublish_589697,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsRestore_589713 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersVersionsRestore_589715(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersVersionsRestore_589714(path: JsonNode;
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
  var valid_589716 = path.getOrDefault("containerId")
  valid_589716 = validateParameter(valid_589716, JString, required = true,
                                 default = nil)
  if valid_589716 != nil:
    section.add "containerId", valid_589716
  var valid_589717 = path.getOrDefault("accountId")
  valid_589717 = validateParameter(valid_589717, JString, required = true,
                                 default = nil)
  if valid_589717 != nil:
    section.add "accountId", valid_589717
  var valid_589718 = path.getOrDefault("containerVersionId")
  valid_589718 = validateParameter(valid_589718, JString, required = true,
                                 default = nil)
  if valid_589718 != nil:
    section.add "containerVersionId", valid_589718
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
  var valid_589719 = query.getOrDefault("fields")
  valid_589719 = validateParameter(valid_589719, JString, required = false,
                                 default = nil)
  if valid_589719 != nil:
    section.add "fields", valid_589719
  var valid_589720 = query.getOrDefault("quotaUser")
  valid_589720 = validateParameter(valid_589720, JString, required = false,
                                 default = nil)
  if valid_589720 != nil:
    section.add "quotaUser", valid_589720
  var valid_589721 = query.getOrDefault("alt")
  valid_589721 = validateParameter(valid_589721, JString, required = false,
                                 default = newJString("json"))
  if valid_589721 != nil:
    section.add "alt", valid_589721
  var valid_589722 = query.getOrDefault("oauth_token")
  valid_589722 = validateParameter(valid_589722, JString, required = false,
                                 default = nil)
  if valid_589722 != nil:
    section.add "oauth_token", valid_589722
  var valid_589723 = query.getOrDefault("userIp")
  valid_589723 = validateParameter(valid_589723, JString, required = false,
                                 default = nil)
  if valid_589723 != nil:
    section.add "userIp", valid_589723
  var valid_589724 = query.getOrDefault("key")
  valid_589724 = validateParameter(valid_589724, JString, required = false,
                                 default = nil)
  if valid_589724 != nil:
    section.add "key", valid_589724
  var valid_589725 = query.getOrDefault("prettyPrint")
  valid_589725 = validateParameter(valid_589725, JBool, required = false,
                                 default = newJBool(true))
  if valid_589725 != nil:
    section.add "prettyPrint", valid_589725
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589726: Call_TagmanagerAccountsContainersVersionsRestore_589713;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Restores a Container Version. This will overwrite the container's current configuration (including its variables, triggers and tags). The operation will not have any effect on the version that is being served (i.e. the published version).
  ## 
  let valid = call_589726.validator(path, query, header, formData, body)
  let scheme = call_589726.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589726.url(scheme.get, call_589726.host, call_589726.base,
                         call_589726.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589726, url, valid)

proc call*(call_589727: Call_TagmanagerAccountsContainersVersionsRestore_589713;
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
  var path_589728 = newJObject()
  var query_589729 = newJObject()
  add(path_589728, "containerId", newJString(containerId))
  add(query_589729, "fields", newJString(fields))
  add(query_589729, "quotaUser", newJString(quotaUser))
  add(query_589729, "alt", newJString(alt))
  add(query_589729, "oauth_token", newJString(oauthToken))
  add(path_589728, "accountId", newJString(accountId))
  add(query_589729, "userIp", newJString(userIp))
  add(path_589728, "containerVersionId", newJString(containerVersionId))
  add(query_589729, "key", newJString(key))
  add(query_589729, "prettyPrint", newJBool(prettyPrint))
  result = call_589727.call(path_589728, query_589729, nil, nil, nil)

var tagmanagerAccountsContainersVersionsRestore* = Call_TagmanagerAccountsContainersVersionsRestore_589713(
    name: "tagmanagerAccountsContainersVersionsRestore",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/versions/{containerVersionId}/restore",
    validator: validate_TagmanagerAccountsContainersVersionsRestore_589714,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsRestore_589715,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsContainersVersionsUndelete_589730 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsContainersVersionsUndelete_589732(protocol: Scheme;
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

proc validate_TagmanagerAccountsContainersVersionsUndelete_589731(path: JsonNode;
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
  var valid_589733 = path.getOrDefault("containerId")
  valid_589733 = validateParameter(valid_589733, JString, required = true,
                                 default = nil)
  if valid_589733 != nil:
    section.add "containerId", valid_589733
  var valid_589734 = path.getOrDefault("accountId")
  valid_589734 = validateParameter(valid_589734, JString, required = true,
                                 default = nil)
  if valid_589734 != nil:
    section.add "accountId", valid_589734
  var valid_589735 = path.getOrDefault("containerVersionId")
  valid_589735 = validateParameter(valid_589735, JString, required = true,
                                 default = nil)
  if valid_589735 != nil:
    section.add "containerVersionId", valid_589735
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
  var valid_589736 = query.getOrDefault("fields")
  valid_589736 = validateParameter(valid_589736, JString, required = false,
                                 default = nil)
  if valid_589736 != nil:
    section.add "fields", valid_589736
  var valid_589737 = query.getOrDefault("quotaUser")
  valid_589737 = validateParameter(valid_589737, JString, required = false,
                                 default = nil)
  if valid_589737 != nil:
    section.add "quotaUser", valid_589737
  var valid_589738 = query.getOrDefault("alt")
  valid_589738 = validateParameter(valid_589738, JString, required = false,
                                 default = newJString("json"))
  if valid_589738 != nil:
    section.add "alt", valid_589738
  var valid_589739 = query.getOrDefault("oauth_token")
  valid_589739 = validateParameter(valid_589739, JString, required = false,
                                 default = nil)
  if valid_589739 != nil:
    section.add "oauth_token", valid_589739
  var valid_589740 = query.getOrDefault("userIp")
  valid_589740 = validateParameter(valid_589740, JString, required = false,
                                 default = nil)
  if valid_589740 != nil:
    section.add "userIp", valid_589740
  var valid_589741 = query.getOrDefault("key")
  valid_589741 = validateParameter(valid_589741, JString, required = false,
                                 default = nil)
  if valid_589741 != nil:
    section.add "key", valid_589741
  var valid_589742 = query.getOrDefault("prettyPrint")
  valid_589742 = validateParameter(valid_589742, JBool, required = false,
                                 default = newJBool(true))
  if valid_589742 != nil:
    section.add "prettyPrint", valid_589742
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589743: Call_TagmanagerAccountsContainersVersionsUndelete_589730;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Undeletes a Container Version.
  ## 
  let valid = call_589743.validator(path, query, header, formData, body)
  let scheme = call_589743.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589743.url(scheme.get, call_589743.host, call_589743.base,
                         call_589743.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589743, url, valid)

proc call*(call_589744: Call_TagmanagerAccountsContainersVersionsUndelete_589730;
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
  var path_589745 = newJObject()
  var query_589746 = newJObject()
  add(path_589745, "containerId", newJString(containerId))
  add(query_589746, "fields", newJString(fields))
  add(query_589746, "quotaUser", newJString(quotaUser))
  add(query_589746, "alt", newJString(alt))
  add(query_589746, "oauth_token", newJString(oauthToken))
  add(path_589745, "accountId", newJString(accountId))
  add(query_589746, "userIp", newJString(userIp))
  add(path_589745, "containerVersionId", newJString(containerVersionId))
  add(query_589746, "key", newJString(key))
  add(query_589746, "prettyPrint", newJBool(prettyPrint))
  result = call_589744.call(path_589745, query_589746, nil, nil, nil)

var tagmanagerAccountsContainersVersionsUndelete* = Call_TagmanagerAccountsContainersVersionsUndelete_589730(
    name: "tagmanagerAccountsContainersVersionsUndelete",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/accounts/{accountId}/containers/{containerId}/versions/{containerVersionId}/undelete",
    validator: validate_TagmanagerAccountsContainersVersionsUndelete_589731,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsContainersVersionsUndelete_589732,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsPermissionsCreate_589762 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsPermissionsCreate_589764(protocol: Scheme; host: string;
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

proc validate_TagmanagerAccountsPermissionsCreate_589763(path: JsonNode;
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
  var valid_589765 = path.getOrDefault("accountId")
  valid_589765 = validateParameter(valid_589765, JString, required = true,
                                 default = nil)
  if valid_589765 != nil:
    section.add "accountId", valid_589765
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
  var valid_589766 = query.getOrDefault("fields")
  valid_589766 = validateParameter(valid_589766, JString, required = false,
                                 default = nil)
  if valid_589766 != nil:
    section.add "fields", valid_589766
  var valid_589767 = query.getOrDefault("quotaUser")
  valid_589767 = validateParameter(valid_589767, JString, required = false,
                                 default = nil)
  if valid_589767 != nil:
    section.add "quotaUser", valid_589767
  var valid_589768 = query.getOrDefault("alt")
  valid_589768 = validateParameter(valid_589768, JString, required = false,
                                 default = newJString("json"))
  if valid_589768 != nil:
    section.add "alt", valid_589768
  var valid_589769 = query.getOrDefault("oauth_token")
  valid_589769 = validateParameter(valid_589769, JString, required = false,
                                 default = nil)
  if valid_589769 != nil:
    section.add "oauth_token", valid_589769
  var valid_589770 = query.getOrDefault("userIp")
  valid_589770 = validateParameter(valid_589770, JString, required = false,
                                 default = nil)
  if valid_589770 != nil:
    section.add "userIp", valid_589770
  var valid_589771 = query.getOrDefault("key")
  valid_589771 = validateParameter(valid_589771, JString, required = false,
                                 default = nil)
  if valid_589771 != nil:
    section.add "key", valid_589771
  var valid_589772 = query.getOrDefault("prettyPrint")
  valid_589772 = validateParameter(valid_589772, JBool, required = false,
                                 default = newJBool(true))
  if valid_589772 != nil:
    section.add "prettyPrint", valid_589772
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

proc call*(call_589774: Call_TagmanagerAccountsPermissionsCreate_589762;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a user's Account & Container Permissions.
  ## 
  let valid = call_589774.validator(path, query, header, formData, body)
  let scheme = call_589774.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589774.url(scheme.get, call_589774.host, call_589774.base,
                         call_589774.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589774, url, valid)

proc call*(call_589775: Call_TagmanagerAccountsPermissionsCreate_589762;
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
  var path_589776 = newJObject()
  var query_589777 = newJObject()
  var body_589778 = newJObject()
  add(query_589777, "fields", newJString(fields))
  add(query_589777, "quotaUser", newJString(quotaUser))
  add(query_589777, "alt", newJString(alt))
  add(query_589777, "oauth_token", newJString(oauthToken))
  add(path_589776, "accountId", newJString(accountId))
  add(query_589777, "userIp", newJString(userIp))
  add(query_589777, "key", newJString(key))
  if body != nil:
    body_589778 = body
  add(query_589777, "prettyPrint", newJBool(prettyPrint))
  result = call_589775.call(path_589776, query_589777, nil, nil, body_589778)

var tagmanagerAccountsPermissionsCreate* = Call_TagmanagerAccountsPermissionsCreate_589762(
    name: "tagmanagerAccountsPermissionsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accounts/{accountId}/permissions",
    validator: validate_TagmanagerAccountsPermissionsCreate_589763,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsPermissionsCreate_589764,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsPermissionsList_589747 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsPermissionsList_589749(protocol: Scheme; host: string;
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

proc validate_TagmanagerAccountsPermissionsList_589748(path: JsonNode;
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
  var valid_589750 = path.getOrDefault("accountId")
  valid_589750 = validateParameter(valid_589750, JString, required = true,
                                 default = nil)
  if valid_589750 != nil:
    section.add "accountId", valid_589750
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
  var valid_589751 = query.getOrDefault("fields")
  valid_589751 = validateParameter(valid_589751, JString, required = false,
                                 default = nil)
  if valid_589751 != nil:
    section.add "fields", valid_589751
  var valid_589752 = query.getOrDefault("quotaUser")
  valid_589752 = validateParameter(valid_589752, JString, required = false,
                                 default = nil)
  if valid_589752 != nil:
    section.add "quotaUser", valid_589752
  var valid_589753 = query.getOrDefault("alt")
  valid_589753 = validateParameter(valid_589753, JString, required = false,
                                 default = newJString("json"))
  if valid_589753 != nil:
    section.add "alt", valid_589753
  var valid_589754 = query.getOrDefault("oauth_token")
  valid_589754 = validateParameter(valid_589754, JString, required = false,
                                 default = nil)
  if valid_589754 != nil:
    section.add "oauth_token", valid_589754
  var valid_589755 = query.getOrDefault("userIp")
  valid_589755 = validateParameter(valid_589755, JString, required = false,
                                 default = nil)
  if valid_589755 != nil:
    section.add "userIp", valid_589755
  var valid_589756 = query.getOrDefault("key")
  valid_589756 = validateParameter(valid_589756, JString, required = false,
                                 default = nil)
  if valid_589756 != nil:
    section.add "key", valid_589756
  var valid_589757 = query.getOrDefault("prettyPrint")
  valid_589757 = validateParameter(valid_589757, JBool, required = false,
                                 default = newJBool(true))
  if valid_589757 != nil:
    section.add "prettyPrint", valid_589757
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589758: Call_TagmanagerAccountsPermissionsList_589747;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all users that have access to the account along with Account and Container Permissions granted to each of them.
  ## 
  let valid = call_589758.validator(path, query, header, formData, body)
  let scheme = call_589758.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589758.url(scheme.get, call_589758.host, call_589758.base,
                         call_589758.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589758, url, valid)

proc call*(call_589759: Call_TagmanagerAccountsPermissionsList_589747;
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
  var path_589760 = newJObject()
  var query_589761 = newJObject()
  add(query_589761, "fields", newJString(fields))
  add(query_589761, "quotaUser", newJString(quotaUser))
  add(query_589761, "alt", newJString(alt))
  add(query_589761, "oauth_token", newJString(oauthToken))
  add(path_589760, "accountId", newJString(accountId))
  add(query_589761, "userIp", newJString(userIp))
  add(query_589761, "key", newJString(key))
  add(query_589761, "prettyPrint", newJBool(prettyPrint))
  result = call_589759.call(path_589760, query_589761, nil, nil, nil)

var tagmanagerAccountsPermissionsList* = Call_TagmanagerAccountsPermissionsList_589747(
    name: "tagmanagerAccountsPermissionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/permissions",
    validator: validate_TagmanagerAccountsPermissionsList_589748,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsPermissionsList_589749,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsPermissionsUpdate_589795 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsPermissionsUpdate_589797(protocol: Scheme; host: string;
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

proc validate_TagmanagerAccountsPermissionsUpdate_589796(path: JsonNode;
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
  var valid_589798 = path.getOrDefault("accountId")
  valid_589798 = validateParameter(valid_589798, JString, required = true,
                                 default = nil)
  if valid_589798 != nil:
    section.add "accountId", valid_589798
  var valid_589799 = path.getOrDefault("permissionId")
  valid_589799 = validateParameter(valid_589799, JString, required = true,
                                 default = nil)
  if valid_589799 != nil:
    section.add "permissionId", valid_589799
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
  var valid_589800 = query.getOrDefault("fields")
  valid_589800 = validateParameter(valid_589800, JString, required = false,
                                 default = nil)
  if valid_589800 != nil:
    section.add "fields", valid_589800
  var valid_589801 = query.getOrDefault("quotaUser")
  valid_589801 = validateParameter(valid_589801, JString, required = false,
                                 default = nil)
  if valid_589801 != nil:
    section.add "quotaUser", valid_589801
  var valid_589802 = query.getOrDefault("alt")
  valid_589802 = validateParameter(valid_589802, JString, required = false,
                                 default = newJString("json"))
  if valid_589802 != nil:
    section.add "alt", valid_589802
  var valid_589803 = query.getOrDefault("oauth_token")
  valid_589803 = validateParameter(valid_589803, JString, required = false,
                                 default = nil)
  if valid_589803 != nil:
    section.add "oauth_token", valid_589803
  var valid_589804 = query.getOrDefault("userIp")
  valid_589804 = validateParameter(valid_589804, JString, required = false,
                                 default = nil)
  if valid_589804 != nil:
    section.add "userIp", valid_589804
  var valid_589805 = query.getOrDefault("key")
  valid_589805 = validateParameter(valid_589805, JString, required = false,
                                 default = nil)
  if valid_589805 != nil:
    section.add "key", valid_589805
  var valid_589806 = query.getOrDefault("prettyPrint")
  valid_589806 = validateParameter(valid_589806, JBool, required = false,
                                 default = newJBool(true))
  if valid_589806 != nil:
    section.add "prettyPrint", valid_589806
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

proc call*(call_589808: Call_TagmanagerAccountsPermissionsUpdate_589795;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a user's Account & Container Permissions.
  ## 
  let valid = call_589808.validator(path, query, header, formData, body)
  let scheme = call_589808.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589808.url(scheme.get, call_589808.host, call_589808.base,
                         call_589808.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589808, url, valid)

proc call*(call_589809: Call_TagmanagerAccountsPermissionsUpdate_589795;
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
  var path_589810 = newJObject()
  var query_589811 = newJObject()
  var body_589812 = newJObject()
  add(query_589811, "fields", newJString(fields))
  add(query_589811, "quotaUser", newJString(quotaUser))
  add(query_589811, "alt", newJString(alt))
  add(query_589811, "oauth_token", newJString(oauthToken))
  add(path_589810, "accountId", newJString(accountId))
  add(path_589810, "permissionId", newJString(permissionId))
  add(query_589811, "userIp", newJString(userIp))
  add(query_589811, "key", newJString(key))
  if body != nil:
    body_589812 = body
  add(query_589811, "prettyPrint", newJBool(prettyPrint))
  result = call_589809.call(path_589810, query_589811, nil, nil, body_589812)

var tagmanagerAccountsPermissionsUpdate* = Call_TagmanagerAccountsPermissionsUpdate_589795(
    name: "tagmanagerAccountsPermissionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/permissions/{permissionId}",
    validator: validate_TagmanagerAccountsPermissionsUpdate_589796,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsPermissionsUpdate_589797,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsPermissionsGet_589779 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsPermissionsGet_589781(protocol: Scheme; host: string;
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

proc validate_TagmanagerAccountsPermissionsGet_589780(path: JsonNode;
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
  var valid_589782 = path.getOrDefault("accountId")
  valid_589782 = validateParameter(valid_589782, JString, required = true,
                                 default = nil)
  if valid_589782 != nil:
    section.add "accountId", valid_589782
  var valid_589783 = path.getOrDefault("permissionId")
  valid_589783 = validateParameter(valid_589783, JString, required = true,
                                 default = nil)
  if valid_589783 != nil:
    section.add "permissionId", valid_589783
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
  var valid_589784 = query.getOrDefault("fields")
  valid_589784 = validateParameter(valid_589784, JString, required = false,
                                 default = nil)
  if valid_589784 != nil:
    section.add "fields", valid_589784
  var valid_589785 = query.getOrDefault("quotaUser")
  valid_589785 = validateParameter(valid_589785, JString, required = false,
                                 default = nil)
  if valid_589785 != nil:
    section.add "quotaUser", valid_589785
  var valid_589786 = query.getOrDefault("alt")
  valid_589786 = validateParameter(valid_589786, JString, required = false,
                                 default = newJString("json"))
  if valid_589786 != nil:
    section.add "alt", valid_589786
  var valid_589787 = query.getOrDefault("oauth_token")
  valid_589787 = validateParameter(valid_589787, JString, required = false,
                                 default = nil)
  if valid_589787 != nil:
    section.add "oauth_token", valid_589787
  var valid_589788 = query.getOrDefault("userIp")
  valid_589788 = validateParameter(valid_589788, JString, required = false,
                                 default = nil)
  if valid_589788 != nil:
    section.add "userIp", valid_589788
  var valid_589789 = query.getOrDefault("key")
  valid_589789 = validateParameter(valid_589789, JString, required = false,
                                 default = nil)
  if valid_589789 != nil:
    section.add "key", valid_589789
  var valid_589790 = query.getOrDefault("prettyPrint")
  valid_589790 = validateParameter(valid_589790, JBool, required = false,
                                 default = newJBool(true))
  if valid_589790 != nil:
    section.add "prettyPrint", valid_589790
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589791: Call_TagmanagerAccountsPermissionsGet_589779;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a user's Account & Container Permissions.
  ## 
  let valid = call_589791.validator(path, query, header, formData, body)
  let scheme = call_589791.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589791.url(scheme.get, call_589791.host, call_589791.base,
                         call_589791.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589791, url, valid)

proc call*(call_589792: Call_TagmanagerAccountsPermissionsGet_589779;
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
  var path_589793 = newJObject()
  var query_589794 = newJObject()
  add(query_589794, "fields", newJString(fields))
  add(query_589794, "quotaUser", newJString(quotaUser))
  add(query_589794, "alt", newJString(alt))
  add(query_589794, "oauth_token", newJString(oauthToken))
  add(path_589793, "accountId", newJString(accountId))
  add(path_589793, "permissionId", newJString(permissionId))
  add(query_589794, "userIp", newJString(userIp))
  add(query_589794, "key", newJString(key))
  add(query_589794, "prettyPrint", newJBool(prettyPrint))
  result = call_589792.call(path_589793, query_589794, nil, nil, nil)

var tagmanagerAccountsPermissionsGet* = Call_TagmanagerAccountsPermissionsGet_589779(
    name: "tagmanagerAccountsPermissionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/permissions/{permissionId}",
    validator: validate_TagmanagerAccountsPermissionsGet_589780,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsPermissionsGet_589781,
    schemes: {Scheme.Https})
type
  Call_TagmanagerAccountsPermissionsDelete_589813 = ref object of OpenApiRestCall_588441
proc url_TagmanagerAccountsPermissionsDelete_589815(protocol: Scheme; host: string;
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

proc validate_TagmanagerAccountsPermissionsDelete_589814(path: JsonNode;
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
  var valid_589816 = path.getOrDefault("accountId")
  valid_589816 = validateParameter(valid_589816, JString, required = true,
                                 default = nil)
  if valid_589816 != nil:
    section.add "accountId", valid_589816
  var valid_589817 = path.getOrDefault("permissionId")
  valid_589817 = validateParameter(valid_589817, JString, required = true,
                                 default = nil)
  if valid_589817 != nil:
    section.add "permissionId", valid_589817
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
  var valid_589818 = query.getOrDefault("fields")
  valid_589818 = validateParameter(valid_589818, JString, required = false,
                                 default = nil)
  if valid_589818 != nil:
    section.add "fields", valid_589818
  var valid_589819 = query.getOrDefault("quotaUser")
  valid_589819 = validateParameter(valid_589819, JString, required = false,
                                 default = nil)
  if valid_589819 != nil:
    section.add "quotaUser", valid_589819
  var valid_589820 = query.getOrDefault("alt")
  valid_589820 = validateParameter(valid_589820, JString, required = false,
                                 default = newJString("json"))
  if valid_589820 != nil:
    section.add "alt", valid_589820
  var valid_589821 = query.getOrDefault("oauth_token")
  valid_589821 = validateParameter(valid_589821, JString, required = false,
                                 default = nil)
  if valid_589821 != nil:
    section.add "oauth_token", valid_589821
  var valid_589822 = query.getOrDefault("userIp")
  valid_589822 = validateParameter(valid_589822, JString, required = false,
                                 default = nil)
  if valid_589822 != nil:
    section.add "userIp", valid_589822
  var valid_589823 = query.getOrDefault("key")
  valid_589823 = validateParameter(valid_589823, JString, required = false,
                                 default = nil)
  if valid_589823 != nil:
    section.add "key", valid_589823
  var valid_589824 = query.getOrDefault("prettyPrint")
  valid_589824 = validateParameter(valid_589824, JBool, required = false,
                                 default = newJBool(true))
  if valid_589824 != nil:
    section.add "prettyPrint", valid_589824
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589825: Call_TagmanagerAccountsPermissionsDelete_589813;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a user from the account, revoking access to it and all of its containers.
  ## 
  let valid = call_589825.validator(path, query, header, formData, body)
  let scheme = call_589825.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589825.url(scheme.get, call_589825.host, call_589825.base,
                         call_589825.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589825, url, valid)

proc call*(call_589826: Call_TagmanagerAccountsPermissionsDelete_589813;
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
  var path_589827 = newJObject()
  var query_589828 = newJObject()
  add(query_589828, "fields", newJString(fields))
  add(query_589828, "quotaUser", newJString(quotaUser))
  add(query_589828, "alt", newJString(alt))
  add(query_589828, "oauth_token", newJString(oauthToken))
  add(path_589827, "accountId", newJString(accountId))
  add(path_589827, "permissionId", newJString(permissionId))
  add(query_589828, "userIp", newJString(userIp))
  add(query_589828, "key", newJString(key))
  add(query_589828, "prettyPrint", newJBool(prettyPrint))
  result = call_589826.call(path_589827, query_589828, nil, nil, nil)

var tagmanagerAccountsPermissionsDelete* = Call_TagmanagerAccountsPermissionsDelete_589813(
    name: "tagmanagerAccountsPermissionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/permissions/{permissionId}",
    validator: validate_TagmanagerAccountsPermissionsDelete_589814,
    base: "/tagmanager/v1", url: url_TagmanagerAccountsPermissionsDelete_589815,
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
