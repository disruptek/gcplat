
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Enterprise Apps Reseller
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Creates and manages your customers and their subscriptions.
## 
## https://developers.google.com/google-apps/reseller/
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

  OpenApiRestCall_579424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579424): Option[Scheme] {.used.} =
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
  gcpServiceName = "reseller"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ResellerCustomersInsert_579692 = ref object of OpenApiRestCall_579424
proc url_ResellerCustomersInsert_579694(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ResellerCustomersInsert_579693(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Order a new customer's account.
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
  ##   customerAuthToken: JString
  ##                    : The customerAuthToken query string is required when creating a resold account that transfers a direct customer's subscription or transfers another reseller customer's subscription to your reseller management. This is a hexadecimal authentication token needed to complete the subscription transfer. For more information, see the administrator help center.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579806 = query.getOrDefault("fields")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "fields", valid_579806
  var valid_579807 = query.getOrDefault("quotaUser")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "quotaUser", valid_579807
  var valid_579821 = query.getOrDefault("alt")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = newJString("json"))
  if valid_579821 != nil:
    section.add "alt", valid_579821
  var valid_579822 = query.getOrDefault("oauth_token")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "oauth_token", valid_579822
  var valid_579823 = query.getOrDefault("userIp")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "userIp", valid_579823
  var valid_579824 = query.getOrDefault("key")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "key", valid_579824
  var valid_579825 = query.getOrDefault("customerAuthToken")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "customerAuthToken", valid_579825
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

proc call*(call_579850: Call_ResellerCustomersInsert_579692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Order a new customer's account.
  ## 
  let valid = call_579850.validator(path, query, header, formData, body)
  let scheme = call_579850.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579850.url(scheme.get, call_579850.host, call_579850.base,
                         call_579850.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579850, url, valid)

proc call*(call_579921: Call_ResellerCustomersInsert_579692; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; customerAuthToken: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## resellerCustomersInsert
  ## Order a new customer's account.
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
  ##   customerAuthToken: string
  ##                    : The customerAuthToken query string is required when creating a resold account that transfers a direct customer's subscription or transfers another reseller customer's subscription to your reseller management. This is a hexadecimal authentication token needed to complete the subscription transfer. For more information, see the administrator help center.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579922 = newJObject()
  var body_579924 = newJObject()
  add(query_579922, "fields", newJString(fields))
  add(query_579922, "quotaUser", newJString(quotaUser))
  add(query_579922, "alt", newJString(alt))
  add(query_579922, "oauth_token", newJString(oauthToken))
  add(query_579922, "userIp", newJString(userIp))
  add(query_579922, "key", newJString(key))
  add(query_579922, "customerAuthToken", newJString(customerAuthToken))
  if body != nil:
    body_579924 = body
  add(query_579922, "prettyPrint", newJBool(prettyPrint))
  result = call_579921.call(nil, query_579922, nil, nil, body_579924)

var resellerCustomersInsert* = Call_ResellerCustomersInsert_579692(
    name: "resellerCustomersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customers",
    validator: validate_ResellerCustomersInsert_579693, base: "/apps/reseller/v1",
    url: url_ResellerCustomersInsert_579694, schemes: {Scheme.Https})
type
  Call_ResellerCustomersUpdate_579992 = ref object of OpenApiRestCall_579424
proc url_ResellerCustomersUpdate_579994(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResellerCustomersUpdate_579993(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a customer account's settings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customerId: JString (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customerId` field"
  var valid_579995 = path.getOrDefault("customerId")
  valid_579995 = validateParameter(valid_579995, JString, required = true,
                                 default = nil)
  if valid_579995 != nil:
    section.add "customerId", valid_579995
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580004: Call_ResellerCustomersUpdate_579992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a customer account's settings.
  ## 
  let valid = call_580004.validator(path, query, header, formData, body)
  let scheme = call_580004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580004.url(scheme.get, call_580004.host, call_580004.base,
                         call_580004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580004, url, valid)

proc call*(call_580005: Call_ResellerCustomersUpdate_579992; customerId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## resellerCustomersUpdate
  ## Update a customer account's settings.
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
  ##   customerId: string (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580006 = newJObject()
  var query_580007 = newJObject()
  var body_580008 = newJObject()
  add(query_580007, "fields", newJString(fields))
  add(query_580007, "quotaUser", newJString(quotaUser))
  add(query_580007, "alt", newJString(alt))
  add(query_580007, "oauth_token", newJString(oauthToken))
  add(query_580007, "userIp", newJString(userIp))
  add(path_580006, "customerId", newJString(customerId))
  add(query_580007, "key", newJString(key))
  if body != nil:
    body_580008 = body
  add(query_580007, "prettyPrint", newJBool(prettyPrint))
  result = call_580005.call(path_580006, query_580007, nil, nil, body_580008)

var resellerCustomersUpdate* = Call_ResellerCustomersUpdate_579992(
    name: "resellerCustomersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/customers/{customerId}",
    validator: validate_ResellerCustomersUpdate_579993, base: "/apps/reseller/v1",
    url: url_ResellerCustomersUpdate_579994, schemes: {Scheme.Https})
type
  Call_ResellerCustomersGet_579963 = ref object of OpenApiRestCall_579424
proc url_ResellerCustomersGet_579965(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResellerCustomersGet_579964(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a customer account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customerId: JString (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customerId` field"
  var valid_579980 = path.getOrDefault("customerId")
  valid_579980 = validateParameter(valid_579980, JString, required = true,
                                 default = nil)
  if valid_579980 != nil:
    section.add "customerId", valid_579980
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
  var valid_579981 = query.getOrDefault("fields")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "fields", valid_579981
  var valid_579982 = query.getOrDefault("quotaUser")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "quotaUser", valid_579982
  var valid_579983 = query.getOrDefault("alt")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = newJString("json"))
  if valid_579983 != nil:
    section.add "alt", valid_579983
  var valid_579984 = query.getOrDefault("oauth_token")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "oauth_token", valid_579984
  var valid_579985 = query.getOrDefault("userIp")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "userIp", valid_579985
  var valid_579986 = query.getOrDefault("key")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "key", valid_579986
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

proc call*(call_579988: Call_ResellerCustomersGet_579963; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a customer account.
  ## 
  let valid = call_579988.validator(path, query, header, formData, body)
  let scheme = call_579988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579988.url(scheme.get, call_579988.host, call_579988.base,
                         call_579988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579988, url, valid)

proc call*(call_579989: Call_ResellerCustomersGet_579963; customerId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## resellerCustomersGet
  ## Get a customer account.
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
  ##   customerId: string (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579990 = newJObject()
  var query_579991 = newJObject()
  add(query_579991, "fields", newJString(fields))
  add(query_579991, "quotaUser", newJString(quotaUser))
  add(query_579991, "alt", newJString(alt))
  add(query_579991, "oauth_token", newJString(oauthToken))
  add(query_579991, "userIp", newJString(userIp))
  add(path_579990, "customerId", newJString(customerId))
  add(query_579991, "key", newJString(key))
  add(query_579991, "prettyPrint", newJBool(prettyPrint))
  result = call_579989.call(path_579990, query_579991, nil, nil, nil)

var resellerCustomersGet* = Call_ResellerCustomersGet_579963(
    name: "resellerCustomersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customers/{customerId}",
    validator: validate_ResellerCustomersGet_579964, base: "/apps/reseller/v1",
    url: url_ResellerCustomersGet_579965, schemes: {Scheme.Https})
type
  Call_ResellerCustomersPatch_580009 = ref object of OpenApiRestCall_579424
proc url_ResellerCustomersPatch_580011(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResellerCustomersPatch_580010(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a customer account's settings. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customerId: JString (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customerId` field"
  var valid_580012 = path.getOrDefault("customerId")
  valid_580012 = validateParameter(valid_580012, JString, required = true,
                                 default = nil)
  if valid_580012 != nil:
    section.add "customerId", valid_580012
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
  var valid_580013 = query.getOrDefault("fields")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "fields", valid_580013
  var valid_580014 = query.getOrDefault("quotaUser")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "quotaUser", valid_580014
  var valid_580015 = query.getOrDefault("alt")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = newJString("json"))
  if valid_580015 != nil:
    section.add "alt", valid_580015
  var valid_580016 = query.getOrDefault("oauth_token")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "oauth_token", valid_580016
  var valid_580017 = query.getOrDefault("userIp")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "userIp", valid_580017
  var valid_580018 = query.getOrDefault("key")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "key", valid_580018
  var valid_580019 = query.getOrDefault("prettyPrint")
  valid_580019 = validateParameter(valid_580019, JBool, required = false,
                                 default = newJBool(true))
  if valid_580019 != nil:
    section.add "prettyPrint", valid_580019
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

proc call*(call_580021: Call_ResellerCustomersPatch_580009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a customer account's settings. This method supports patch semantics.
  ## 
  let valid = call_580021.validator(path, query, header, formData, body)
  let scheme = call_580021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580021.url(scheme.get, call_580021.host, call_580021.base,
                         call_580021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580021, url, valid)

proc call*(call_580022: Call_ResellerCustomersPatch_580009; customerId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## resellerCustomersPatch
  ## Update a customer account's settings. This method supports patch semantics.
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
  ##   customerId: string (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580023 = newJObject()
  var query_580024 = newJObject()
  var body_580025 = newJObject()
  add(query_580024, "fields", newJString(fields))
  add(query_580024, "quotaUser", newJString(quotaUser))
  add(query_580024, "alt", newJString(alt))
  add(query_580024, "oauth_token", newJString(oauthToken))
  add(query_580024, "userIp", newJString(userIp))
  add(path_580023, "customerId", newJString(customerId))
  add(query_580024, "key", newJString(key))
  if body != nil:
    body_580025 = body
  add(query_580024, "prettyPrint", newJBool(prettyPrint))
  result = call_580022.call(path_580023, query_580024, nil, nil, body_580025)

var resellerCustomersPatch* = Call_ResellerCustomersPatch_580009(
    name: "resellerCustomersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/customers/{customerId}",
    validator: validate_ResellerCustomersPatch_580010, base: "/apps/reseller/v1",
    url: url_ResellerCustomersPatch_580011, schemes: {Scheme.Https})
type
  Call_ResellerSubscriptionsInsert_580026 = ref object of OpenApiRestCall_579424
proc url_ResellerSubscriptionsInsert_580028(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerId"),
               (kind: ConstantSegment, value: "/subscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResellerSubscriptionsInsert_580027(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or transfer a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customerId: JString (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customerId` field"
  var valid_580029 = path.getOrDefault("customerId")
  valid_580029 = validateParameter(valid_580029, JString, required = true,
                                 default = nil)
  if valid_580029 != nil:
    section.add "customerId", valid_580029
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
  ##   customerAuthToken: JString
  ##                    : The customerAuthToken query string is required when creating a resold account that transfers a direct customer's subscription or transfers another reseller customer's subscription to your reseller management. This is a hexadecimal authentication token needed to complete the subscription transfer. For more information, see the administrator help center.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580030 = query.getOrDefault("fields")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "fields", valid_580030
  var valid_580031 = query.getOrDefault("quotaUser")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "quotaUser", valid_580031
  var valid_580032 = query.getOrDefault("alt")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = newJString("json"))
  if valid_580032 != nil:
    section.add "alt", valid_580032
  var valid_580033 = query.getOrDefault("oauth_token")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "oauth_token", valid_580033
  var valid_580034 = query.getOrDefault("userIp")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "userIp", valid_580034
  var valid_580035 = query.getOrDefault("key")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "key", valid_580035
  var valid_580036 = query.getOrDefault("customerAuthToken")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "customerAuthToken", valid_580036
  var valid_580037 = query.getOrDefault("prettyPrint")
  valid_580037 = validateParameter(valid_580037, JBool, required = false,
                                 default = newJBool(true))
  if valid_580037 != nil:
    section.add "prettyPrint", valid_580037
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

proc call*(call_580039: Call_ResellerSubscriptionsInsert_580026; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or transfer a subscription.
  ## 
  let valid = call_580039.validator(path, query, header, formData, body)
  let scheme = call_580039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580039.url(scheme.get, call_580039.host, call_580039.base,
                         call_580039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580039, url, valid)

proc call*(call_580040: Call_ResellerSubscriptionsInsert_580026;
          customerId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; customerAuthToken: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## resellerSubscriptionsInsert
  ## Create or transfer a subscription.
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
  ##   customerId: string (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customerAuthToken: string
  ##                    : The customerAuthToken query string is required when creating a resold account that transfers a direct customer's subscription or transfers another reseller customer's subscription to your reseller management. This is a hexadecimal authentication token needed to complete the subscription transfer. For more information, see the administrator help center.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580041 = newJObject()
  var query_580042 = newJObject()
  var body_580043 = newJObject()
  add(query_580042, "fields", newJString(fields))
  add(query_580042, "quotaUser", newJString(quotaUser))
  add(query_580042, "alt", newJString(alt))
  add(query_580042, "oauth_token", newJString(oauthToken))
  add(query_580042, "userIp", newJString(userIp))
  add(path_580041, "customerId", newJString(customerId))
  add(query_580042, "key", newJString(key))
  add(query_580042, "customerAuthToken", newJString(customerAuthToken))
  if body != nil:
    body_580043 = body
  add(query_580042, "prettyPrint", newJBool(prettyPrint))
  result = call_580040.call(path_580041, query_580042, nil, nil, body_580043)

var resellerSubscriptionsInsert* = Call_ResellerSubscriptionsInsert_580026(
    name: "resellerSubscriptionsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customers/{customerId}/subscriptions",
    validator: validate_ResellerSubscriptionsInsert_580027,
    base: "/apps/reseller/v1", url: url_ResellerSubscriptionsInsert_580028,
    schemes: {Scheme.Https})
type
  Call_ResellerSubscriptionsGet_580044 = ref object of OpenApiRestCall_579424
proc url_ResellerSubscriptionsGet_580046(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerId"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResellerSubscriptionsGet_580045(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a specific subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : This is a required property. The subscriptionId is the subscription identifier and is unique for each customer. Since a subscriptionId changes when a subscription is updated, we recommend to not use this ID as a key for persistent data. And the subscriptionId can be found using the retrieve all reseller subscriptions method.
  ##   customerId: JString (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_580047 = path.getOrDefault("subscriptionId")
  valid_580047 = validateParameter(valid_580047, JString, required = true,
                                 default = nil)
  if valid_580047 != nil:
    section.add "subscriptionId", valid_580047
  var valid_580048 = path.getOrDefault("customerId")
  valid_580048 = validateParameter(valid_580048, JString, required = true,
                                 default = nil)
  if valid_580048 != nil:
    section.add "customerId", valid_580048
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
  var valid_580049 = query.getOrDefault("fields")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "fields", valid_580049
  var valid_580050 = query.getOrDefault("quotaUser")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "quotaUser", valid_580050
  var valid_580051 = query.getOrDefault("alt")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = newJString("json"))
  if valid_580051 != nil:
    section.add "alt", valid_580051
  var valid_580052 = query.getOrDefault("oauth_token")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "oauth_token", valid_580052
  var valid_580053 = query.getOrDefault("userIp")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "userIp", valid_580053
  var valid_580054 = query.getOrDefault("key")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "key", valid_580054
  var valid_580055 = query.getOrDefault("prettyPrint")
  valid_580055 = validateParameter(valid_580055, JBool, required = false,
                                 default = newJBool(true))
  if valid_580055 != nil:
    section.add "prettyPrint", valid_580055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580056: Call_ResellerSubscriptionsGet_580044; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific subscription.
  ## 
  let valid = call_580056.validator(path, query, header, formData, body)
  let scheme = call_580056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580056.url(scheme.get, call_580056.host, call_580056.base,
                         call_580056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580056, url, valid)

proc call*(call_580057: Call_ResellerSubscriptionsGet_580044;
          subscriptionId: string; customerId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## resellerSubscriptionsGet
  ## Get a specific subscription.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   subscriptionId: string (required)
  ##                 : This is a required property. The subscriptionId is the subscription identifier and is unique for each customer. Since a subscriptionId changes when a subscription is updated, we recommend to not use this ID as a key for persistent data. And the subscriptionId can be found using the retrieve all reseller subscriptions method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   customerId: string (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580058 = newJObject()
  var query_580059 = newJObject()
  add(query_580059, "fields", newJString(fields))
  add(query_580059, "quotaUser", newJString(quotaUser))
  add(query_580059, "alt", newJString(alt))
  add(path_580058, "subscriptionId", newJString(subscriptionId))
  add(query_580059, "oauth_token", newJString(oauthToken))
  add(query_580059, "userIp", newJString(userIp))
  add(path_580058, "customerId", newJString(customerId))
  add(query_580059, "key", newJString(key))
  add(query_580059, "prettyPrint", newJBool(prettyPrint))
  result = call_580057.call(path_580058, query_580059, nil, nil, nil)

var resellerSubscriptionsGet* = Call_ResellerSubscriptionsGet_580044(
    name: "resellerSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customers/{customerId}/subscriptions/{subscriptionId}",
    validator: validate_ResellerSubscriptionsGet_580045,
    base: "/apps/reseller/v1", url: url_ResellerSubscriptionsGet_580046,
    schemes: {Scheme.Https})
type
  Call_ResellerSubscriptionsDelete_580060 = ref object of OpenApiRestCall_579424
proc url_ResellerSubscriptionsDelete_580062(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerId"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResellerSubscriptionsDelete_580061(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancel or transfer a subscription to direct.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : This is a required property. The subscriptionId is the subscription identifier and is unique for each customer. Since a subscriptionId changes when a subscription is updated, we recommend to not use this ID as a key for persistent data. And the subscriptionId can be found using the retrieve all reseller subscriptions method.
  ##   customerId: JString (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_580063 = path.getOrDefault("subscriptionId")
  valid_580063 = validateParameter(valid_580063, JString, required = true,
                                 default = nil)
  if valid_580063 != nil:
    section.add "subscriptionId", valid_580063
  var valid_580064 = path.getOrDefault("customerId")
  valid_580064 = validateParameter(valid_580064, JString, required = true,
                                 default = nil)
  if valid_580064 != nil:
    section.add "customerId", valid_580064
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   deletionType: JString (required)
  ##               : The deletionType query string enables the cancellation, downgrade, or suspension of a subscription.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580065 = query.getOrDefault("fields")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "fields", valid_580065
  var valid_580066 = query.getOrDefault("quotaUser")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "quotaUser", valid_580066
  var valid_580067 = query.getOrDefault("alt")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = newJString("json"))
  if valid_580067 != nil:
    section.add "alt", valid_580067
  assert query != nil,
        "query argument is necessary due to required `deletionType` field"
  var valid_580068 = query.getOrDefault("deletionType")
  valid_580068 = validateParameter(valid_580068, JString, required = true,
                                 default = newJString("cancel"))
  if valid_580068 != nil:
    section.add "deletionType", valid_580068
  var valid_580069 = query.getOrDefault("oauth_token")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "oauth_token", valid_580069
  var valid_580070 = query.getOrDefault("userIp")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "userIp", valid_580070
  var valid_580071 = query.getOrDefault("key")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "key", valid_580071
  var valid_580072 = query.getOrDefault("prettyPrint")
  valid_580072 = validateParameter(valid_580072, JBool, required = false,
                                 default = newJBool(true))
  if valid_580072 != nil:
    section.add "prettyPrint", valid_580072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580073: Call_ResellerSubscriptionsDelete_580060; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancel or transfer a subscription to direct.
  ## 
  let valid = call_580073.validator(path, query, header, formData, body)
  let scheme = call_580073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580073.url(scheme.get, call_580073.host, call_580073.base,
                         call_580073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580073, url, valid)

proc call*(call_580074: Call_ResellerSubscriptionsDelete_580060;
          subscriptionId: string; customerId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; deletionType: string = "cancel";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## resellerSubscriptionsDelete
  ## Cancel or transfer a subscription to direct.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   deletionType: string (required)
  ##               : The deletionType query string enables the cancellation, downgrade, or suspension of a subscription.
  ##   subscriptionId: string (required)
  ##                 : This is a required property. The subscriptionId is the subscription identifier and is unique for each customer. Since a subscriptionId changes when a subscription is updated, we recommend to not use this ID as a key for persistent data. And the subscriptionId can be found using the retrieve all reseller subscriptions method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   customerId: string (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580075 = newJObject()
  var query_580076 = newJObject()
  add(query_580076, "fields", newJString(fields))
  add(query_580076, "quotaUser", newJString(quotaUser))
  add(query_580076, "alt", newJString(alt))
  add(query_580076, "deletionType", newJString(deletionType))
  add(path_580075, "subscriptionId", newJString(subscriptionId))
  add(query_580076, "oauth_token", newJString(oauthToken))
  add(query_580076, "userIp", newJString(userIp))
  add(path_580075, "customerId", newJString(customerId))
  add(query_580076, "key", newJString(key))
  add(query_580076, "prettyPrint", newJBool(prettyPrint))
  result = call_580074.call(path_580075, query_580076, nil, nil, nil)

var resellerSubscriptionsDelete* = Call_ResellerSubscriptionsDelete_580060(
    name: "resellerSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customers/{customerId}/subscriptions/{subscriptionId}",
    validator: validate_ResellerSubscriptionsDelete_580061,
    base: "/apps/reseller/v1", url: url_ResellerSubscriptionsDelete_580062,
    schemes: {Scheme.Https})
type
  Call_ResellerSubscriptionsActivate_580077 = ref object of OpenApiRestCall_579424
proc url_ResellerSubscriptionsActivate_580079(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerId"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/activate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResellerSubscriptionsActivate_580078(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Activates a subscription previously suspended by the reseller
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : This is a required property. The subscriptionId is the subscription identifier and is unique for each customer. Since a subscriptionId changes when a subscription is updated, we recommend to not use this ID as a key for persistent data. And the subscriptionId can be found using the retrieve all reseller subscriptions method.
  ##   customerId: JString (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_580080 = path.getOrDefault("subscriptionId")
  valid_580080 = validateParameter(valid_580080, JString, required = true,
                                 default = nil)
  if valid_580080 != nil:
    section.add "subscriptionId", valid_580080
  var valid_580081 = path.getOrDefault("customerId")
  valid_580081 = validateParameter(valid_580081, JString, required = true,
                                 default = nil)
  if valid_580081 != nil:
    section.add "customerId", valid_580081
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
  var valid_580082 = query.getOrDefault("fields")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "fields", valid_580082
  var valid_580083 = query.getOrDefault("quotaUser")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "quotaUser", valid_580083
  var valid_580084 = query.getOrDefault("alt")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = newJString("json"))
  if valid_580084 != nil:
    section.add "alt", valid_580084
  var valid_580085 = query.getOrDefault("oauth_token")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "oauth_token", valid_580085
  var valid_580086 = query.getOrDefault("userIp")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "userIp", valid_580086
  var valid_580087 = query.getOrDefault("key")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "key", valid_580087
  var valid_580088 = query.getOrDefault("prettyPrint")
  valid_580088 = validateParameter(valid_580088, JBool, required = false,
                                 default = newJBool(true))
  if valid_580088 != nil:
    section.add "prettyPrint", valid_580088
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580089: Call_ResellerSubscriptionsActivate_580077; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Activates a subscription previously suspended by the reseller
  ## 
  let valid = call_580089.validator(path, query, header, formData, body)
  let scheme = call_580089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580089.url(scheme.get, call_580089.host, call_580089.base,
                         call_580089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580089, url, valid)

proc call*(call_580090: Call_ResellerSubscriptionsActivate_580077;
          subscriptionId: string; customerId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## resellerSubscriptionsActivate
  ## Activates a subscription previously suspended by the reseller
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   subscriptionId: string (required)
  ##                 : This is a required property. The subscriptionId is the subscription identifier and is unique for each customer. Since a subscriptionId changes when a subscription is updated, we recommend to not use this ID as a key for persistent data. And the subscriptionId can be found using the retrieve all reseller subscriptions method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   customerId: string (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580091 = newJObject()
  var query_580092 = newJObject()
  add(query_580092, "fields", newJString(fields))
  add(query_580092, "quotaUser", newJString(quotaUser))
  add(query_580092, "alt", newJString(alt))
  add(path_580091, "subscriptionId", newJString(subscriptionId))
  add(query_580092, "oauth_token", newJString(oauthToken))
  add(query_580092, "userIp", newJString(userIp))
  add(path_580091, "customerId", newJString(customerId))
  add(query_580092, "key", newJString(key))
  add(query_580092, "prettyPrint", newJBool(prettyPrint))
  result = call_580090.call(path_580091, query_580092, nil, nil, nil)

var resellerSubscriptionsActivate* = Call_ResellerSubscriptionsActivate_580077(
    name: "resellerSubscriptionsActivate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/customers/{customerId}/subscriptions/{subscriptionId}/activate",
    validator: validate_ResellerSubscriptionsActivate_580078,
    base: "/apps/reseller/v1", url: url_ResellerSubscriptionsActivate_580079,
    schemes: {Scheme.Https})
type
  Call_ResellerSubscriptionsChangePlan_580093 = ref object of OpenApiRestCall_579424
proc url_ResellerSubscriptionsChangePlan_580095(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerId"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/changePlan")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResellerSubscriptionsChangePlan_580094(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a subscription plan. Use this method to update a plan for a 30-day trial or a flexible plan subscription to an annual commitment plan with monthly or yearly payments.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : This is a required property. The subscriptionId is the subscription identifier and is unique for each customer. Since a subscriptionId changes when a subscription is updated, we recommend to not use this ID as a key for persistent data. And the subscriptionId can be found using the retrieve all reseller subscriptions method.
  ##   customerId: JString (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_580096 = path.getOrDefault("subscriptionId")
  valid_580096 = validateParameter(valid_580096, JString, required = true,
                                 default = nil)
  if valid_580096 != nil:
    section.add "subscriptionId", valid_580096
  var valid_580097 = path.getOrDefault("customerId")
  valid_580097 = validateParameter(valid_580097, JString, required = true,
                                 default = nil)
  if valid_580097 != nil:
    section.add "customerId", valid_580097
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
  var valid_580098 = query.getOrDefault("fields")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "fields", valid_580098
  var valid_580099 = query.getOrDefault("quotaUser")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "quotaUser", valid_580099
  var valid_580100 = query.getOrDefault("alt")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = newJString("json"))
  if valid_580100 != nil:
    section.add "alt", valid_580100
  var valid_580101 = query.getOrDefault("oauth_token")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "oauth_token", valid_580101
  var valid_580102 = query.getOrDefault("userIp")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "userIp", valid_580102
  var valid_580103 = query.getOrDefault("key")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "key", valid_580103
  var valid_580104 = query.getOrDefault("prettyPrint")
  valid_580104 = validateParameter(valid_580104, JBool, required = false,
                                 default = newJBool(true))
  if valid_580104 != nil:
    section.add "prettyPrint", valid_580104
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

proc call*(call_580106: Call_ResellerSubscriptionsChangePlan_580093;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update a subscription plan. Use this method to update a plan for a 30-day trial or a flexible plan subscription to an annual commitment plan with monthly or yearly payments.
  ## 
  let valid = call_580106.validator(path, query, header, formData, body)
  let scheme = call_580106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580106.url(scheme.get, call_580106.host, call_580106.base,
                         call_580106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580106, url, valid)

proc call*(call_580107: Call_ResellerSubscriptionsChangePlan_580093;
          subscriptionId: string; customerId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## resellerSubscriptionsChangePlan
  ## Update a subscription plan. Use this method to update a plan for a 30-day trial or a flexible plan subscription to an annual commitment plan with monthly or yearly payments.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   subscriptionId: string (required)
  ##                 : This is a required property. The subscriptionId is the subscription identifier and is unique for each customer. Since a subscriptionId changes when a subscription is updated, we recommend to not use this ID as a key for persistent data. And the subscriptionId can be found using the retrieve all reseller subscriptions method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   customerId: string (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580108 = newJObject()
  var query_580109 = newJObject()
  var body_580110 = newJObject()
  add(query_580109, "fields", newJString(fields))
  add(query_580109, "quotaUser", newJString(quotaUser))
  add(query_580109, "alt", newJString(alt))
  add(path_580108, "subscriptionId", newJString(subscriptionId))
  add(query_580109, "oauth_token", newJString(oauthToken))
  add(query_580109, "userIp", newJString(userIp))
  add(path_580108, "customerId", newJString(customerId))
  add(query_580109, "key", newJString(key))
  if body != nil:
    body_580110 = body
  add(query_580109, "prettyPrint", newJBool(prettyPrint))
  result = call_580107.call(path_580108, query_580109, nil, nil, body_580110)

var resellerSubscriptionsChangePlan* = Call_ResellerSubscriptionsChangePlan_580093(
    name: "resellerSubscriptionsChangePlan", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/customers/{customerId}/subscriptions/{subscriptionId}/changePlan",
    validator: validate_ResellerSubscriptionsChangePlan_580094,
    base: "/apps/reseller/v1", url: url_ResellerSubscriptionsChangePlan_580095,
    schemes: {Scheme.Https})
type
  Call_ResellerSubscriptionsChangeRenewalSettings_580111 = ref object of OpenApiRestCall_579424
proc url_ResellerSubscriptionsChangeRenewalSettings_580113(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerId"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/changeRenewalSettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResellerSubscriptionsChangeRenewalSettings_580112(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a user license's renewal settings. This is applicable for accounts with annual commitment plans only.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : This is a required property. The subscriptionId is the subscription identifier and is unique for each customer. Since a subscriptionId changes when a subscription is updated, we recommend to not use this ID as a key for persistent data. And the subscriptionId can be found using the retrieve all reseller subscriptions method.
  ##   customerId: JString (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_580114 = path.getOrDefault("subscriptionId")
  valid_580114 = validateParameter(valid_580114, JString, required = true,
                                 default = nil)
  if valid_580114 != nil:
    section.add "subscriptionId", valid_580114
  var valid_580115 = path.getOrDefault("customerId")
  valid_580115 = validateParameter(valid_580115, JString, required = true,
                                 default = nil)
  if valid_580115 != nil:
    section.add "customerId", valid_580115
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
  var valid_580116 = query.getOrDefault("fields")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "fields", valid_580116
  var valid_580117 = query.getOrDefault("quotaUser")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "quotaUser", valid_580117
  var valid_580118 = query.getOrDefault("alt")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = newJString("json"))
  if valid_580118 != nil:
    section.add "alt", valid_580118
  var valid_580119 = query.getOrDefault("oauth_token")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "oauth_token", valid_580119
  var valid_580120 = query.getOrDefault("userIp")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "userIp", valid_580120
  var valid_580121 = query.getOrDefault("key")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "key", valid_580121
  var valid_580122 = query.getOrDefault("prettyPrint")
  valid_580122 = validateParameter(valid_580122, JBool, required = false,
                                 default = newJBool(true))
  if valid_580122 != nil:
    section.add "prettyPrint", valid_580122
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

proc call*(call_580124: Call_ResellerSubscriptionsChangeRenewalSettings_580111;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update a user license's renewal settings. This is applicable for accounts with annual commitment plans only.
  ## 
  let valid = call_580124.validator(path, query, header, formData, body)
  let scheme = call_580124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580124.url(scheme.get, call_580124.host, call_580124.base,
                         call_580124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580124, url, valid)

proc call*(call_580125: Call_ResellerSubscriptionsChangeRenewalSettings_580111;
          subscriptionId: string; customerId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## resellerSubscriptionsChangeRenewalSettings
  ## Update a user license's renewal settings. This is applicable for accounts with annual commitment plans only.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   subscriptionId: string (required)
  ##                 : This is a required property. The subscriptionId is the subscription identifier and is unique for each customer. Since a subscriptionId changes when a subscription is updated, we recommend to not use this ID as a key for persistent data. And the subscriptionId can be found using the retrieve all reseller subscriptions method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   customerId: string (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580126 = newJObject()
  var query_580127 = newJObject()
  var body_580128 = newJObject()
  add(query_580127, "fields", newJString(fields))
  add(query_580127, "quotaUser", newJString(quotaUser))
  add(query_580127, "alt", newJString(alt))
  add(path_580126, "subscriptionId", newJString(subscriptionId))
  add(query_580127, "oauth_token", newJString(oauthToken))
  add(query_580127, "userIp", newJString(userIp))
  add(path_580126, "customerId", newJString(customerId))
  add(query_580127, "key", newJString(key))
  if body != nil:
    body_580128 = body
  add(query_580127, "prettyPrint", newJBool(prettyPrint))
  result = call_580125.call(path_580126, query_580127, nil, nil, body_580128)

var resellerSubscriptionsChangeRenewalSettings* = Call_ResellerSubscriptionsChangeRenewalSettings_580111(
    name: "resellerSubscriptionsChangeRenewalSettings", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customers/{customerId}/subscriptions/{subscriptionId}/changeRenewalSettings",
    validator: validate_ResellerSubscriptionsChangeRenewalSettings_580112,
    base: "/apps/reseller/v1",
    url: url_ResellerSubscriptionsChangeRenewalSettings_580113,
    schemes: {Scheme.Https})
type
  Call_ResellerSubscriptionsChangeSeats_580129 = ref object of OpenApiRestCall_579424
proc url_ResellerSubscriptionsChangeSeats_580131(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerId"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/changeSeats")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResellerSubscriptionsChangeSeats_580130(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a subscription's user license settings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : This is a required property. The subscriptionId is the subscription identifier and is unique for each customer. Since a subscriptionId changes when a subscription is updated, we recommend to not use this ID as a key for persistent data. And the subscriptionId can be found using the retrieve all reseller subscriptions method.
  ##   customerId: JString (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_580132 = path.getOrDefault("subscriptionId")
  valid_580132 = validateParameter(valid_580132, JString, required = true,
                                 default = nil)
  if valid_580132 != nil:
    section.add "subscriptionId", valid_580132
  var valid_580133 = path.getOrDefault("customerId")
  valid_580133 = validateParameter(valid_580133, JString, required = true,
                                 default = nil)
  if valid_580133 != nil:
    section.add "customerId", valid_580133
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
  var valid_580134 = query.getOrDefault("fields")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "fields", valid_580134
  var valid_580135 = query.getOrDefault("quotaUser")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "quotaUser", valid_580135
  var valid_580136 = query.getOrDefault("alt")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = newJString("json"))
  if valid_580136 != nil:
    section.add "alt", valid_580136
  var valid_580137 = query.getOrDefault("oauth_token")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "oauth_token", valid_580137
  var valid_580138 = query.getOrDefault("userIp")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "userIp", valid_580138
  var valid_580139 = query.getOrDefault("key")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "key", valid_580139
  var valid_580140 = query.getOrDefault("prettyPrint")
  valid_580140 = validateParameter(valid_580140, JBool, required = false,
                                 default = newJBool(true))
  if valid_580140 != nil:
    section.add "prettyPrint", valid_580140
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

proc call*(call_580142: Call_ResellerSubscriptionsChangeSeats_580129;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update a subscription's user license settings.
  ## 
  let valid = call_580142.validator(path, query, header, formData, body)
  let scheme = call_580142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580142.url(scheme.get, call_580142.host, call_580142.base,
                         call_580142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580142, url, valid)

proc call*(call_580143: Call_ResellerSubscriptionsChangeSeats_580129;
          subscriptionId: string; customerId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## resellerSubscriptionsChangeSeats
  ## Update a subscription's user license settings.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   subscriptionId: string (required)
  ##                 : This is a required property. The subscriptionId is the subscription identifier and is unique for each customer. Since a subscriptionId changes when a subscription is updated, we recommend to not use this ID as a key for persistent data. And the subscriptionId can be found using the retrieve all reseller subscriptions method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   customerId: string (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580144 = newJObject()
  var query_580145 = newJObject()
  var body_580146 = newJObject()
  add(query_580145, "fields", newJString(fields))
  add(query_580145, "quotaUser", newJString(quotaUser))
  add(query_580145, "alt", newJString(alt))
  add(path_580144, "subscriptionId", newJString(subscriptionId))
  add(query_580145, "oauth_token", newJString(oauthToken))
  add(query_580145, "userIp", newJString(userIp))
  add(path_580144, "customerId", newJString(customerId))
  add(query_580145, "key", newJString(key))
  if body != nil:
    body_580146 = body
  add(query_580145, "prettyPrint", newJBool(prettyPrint))
  result = call_580143.call(path_580144, query_580145, nil, nil, body_580146)

var resellerSubscriptionsChangeSeats* = Call_ResellerSubscriptionsChangeSeats_580129(
    name: "resellerSubscriptionsChangeSeats", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customers/{customerId}/subscriptions/{subscriptionId}/changeSeats",
    validator: validate_ResellerSubscriptionsChangeSeats_580130,
    base: "/apps/reseller/v1", url: url_ResellerSubscriptionsChangeSeats_580131,
    schemes: {Scheme.Https})
type
  Call_ResellerSubscriptionsStartPaidService_580147 = ref object of OpenApiRestCall_579424
proc url_ResellerSubscriptionsStartPaidService_580149(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerId"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/startPaidService")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResellerSubscriptionsStartPaidService_580148(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Immediately move a 30-day free trial subscription to a paid service subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : This is a required property. The subscriptionId is the subscription identifier and is unique for each customer. Since a subscriptionId changes when a subscription is updated, we recommend to not use this ID as a key for persistent data. And the subscriptionId can be found using the retrieve all reseller subscriptions method.
  ##   customerId: JString (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_580150 = path.getOrDefault("subscriptionId")
  valid_580150 = validateParameter(valid_580150, JString, required = true,
                                 default = nil)
  if valid_580150 != nil:
    section.add "subscriptionId", valid_580150
  var valid_580151 = path.getOrDefault("customerId")
  valid_580151 = validateParameter(valid_580151, JString, required = true,
                                 default = nil)
  if valid_580151 != nil:
    section.add "customerId", valid_580151
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
  var valid_580152 = query.getOrDefault("fields")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "fields", valid_580152
  var valid_580153 = query.getOrDefault("quotaUser")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "quotaUser", valid_580153
  var valid_580154 = query.getOrDefault("alt")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = newJString("json"))
  if valid_580154 != nil:
    section.add "alt", valid_580154
  var valid_580155 = query.getOrDefault("oauth_token")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "oauth_token", valid_580155
  var valid_580156 = query.getOrDefault("userIp")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "userIp", valid_580156
  var valid_580157 = query.getOrDefault("key")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "key", valid_580157
  var valid_580158 = query.getOrDefault("prettyPrint")
  valid_580158 = validateParameter(valid_580158, JBool, required = false,
                                 default = newJBool(true))
  if valid_580158 != nil:
    section.add "prettyPrint", valid_580158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580159: Call_ResellerSubscriptionsStartPaidService_580147;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Immediately move a 30-day free trial subscription to a paid service subscription.
  ## 
  let valid = call_580159.validator(path, query, header, formData, body)
  let scheme = call_580159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580159.url(scheme.get, call_580159.host, call_580159.base,
                         call_580159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580159, url, valid)

proc call*(call_580160: Call_ResellerSubscriptionsStartPaidService_580147;
          subscriptionId: string; customerId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## resellerSubscriptionsStartPaidService
  ## Immediately move a 30-day free trial subscription to a paid service subscription.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   subscriptionId: string (required)
  ##                 : This is a required property. The subscriptionId is the subscription identifier and is unique for each customer. Since a subscriptionId changes when a subscription is updated, we recommend to not use this ID as a key for persistent data. And the subscriptionId can be found using the retrieve all reseller subscriptions method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   customerId: string (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580161 = newJObject()
  var query_580162 = newJObject()
  add(query_580162, "fields", newJString(fields))
  add(query_580162, "quotaUser", newJString(quotaUser))
  add(query_580162, "alt", newJString(alt))
  add(path_580161, "subscriptionId", newJString(subscriptionId))
  add(query_580162, "oauth_token", newJString(oauthToken))
  add(query_580162, "userIp", newJString(userIp))
  add(path_580161, "customerId", newJString(customerId))
  add(query_580162, "key", newJString(key))
  add(query_580162, "prettyPrint", newJBool(prettyPrint))
  result = call_580160.call(path_580161, query_580162, nil, nil, nil)

var resellerSubscriptionsStartPaidService* = Call_ResellerSubscriptionsStartPaidService_580147(
    name: "resellerSubscriptionsStartPaidService", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customers/{customerId}/subscriptions/{subscriptionId}/startPaidService",
    validator: validate_ResellerSubscriptionsStartPaidService_580148,
    base: "/apps/reseller/v1", url: url_ResellerSubscriptionsStartPaidService_580149,
    schemes: {Scheme.Https})
type
  Call_ResellerSubscriptionsSuspend_580163 = ref object of OpenApiRestCall_579424
proc url_ResellerSubscriptionsSuspend_580165(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerId"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/suspend")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResellerSubscriptionsSuspend_580164(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Suspends an active subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : This is a required property. The subscriptionId is the subscription identifier and is unique for each customer. Since a subscriptionId changes when a subscription is updated, we recommend to not use this ID as a key for persistent data. And the subscriptionId can be found using the retrieve all reseller subscriptions method.
  ##   customerId: JString (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_580166 = path.getOrDefault("subscriptionId")
  valid_580166 = validateParameter(valid_580166, JString, required = true,
                                 default = nil)
  if valid_580166 != nil:
    section.add "subscriptionId", valid_580166
  var valid_580167 = path.getOrDefault("customerId")
  valid_580167 = validateParameter(valid_580167, JString, required = true,
                                 default = nil)
  if valid_580167 != nil:
    section.add "customerId", valid_580167
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
  var valid_580168 = query.getOrDefault("fields")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "fields", valid_580168
  var valid_580169 = query.getOrDefault("quotaUser")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "quotaUser", valid_580169
  var valid_580170 = query.getOrDefault("alt")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = newJString("json"))
  if valid_580170 != nil:
    section.add "alt", valid_580170
  var valid_580171 = query.getOrDefault("oauth_token")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "oauth_token", valid_580171
  var valid_580172 = query.getOrDefault("userIp")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "userIp", valid_580172
  var valid_580173 = query.getOrDefault("key")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "key", valid_580173
  var valid_580174 = query.getOrDefault("prettyPrint")
  valid_580174 = validateParameter(valid_580174, JBool, required = false,
                                 default = newJBool(true))
  if valid_580174 != nil:
    section.add "prettyPrint", valid_580174
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580175: Call_ResellerSubscriptionsSuspend_580163; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suspends an active subscription.
  ## 
  let valid = call_580175.validator(path, query, header, formData, body)
  let scheme = call_580175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580175.url(scheme.get, call_580175.host, call_580175.base,
                         call_580175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580175, url, valid)

proc call*(call_580176: Call_ResellerSubscriptionsSuspend_580163;
          subscriptionId: string; customerId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## resellerSubscriptionsSuspend
  ## Suspends an active subscription.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   subscriptionId: string (required)
  ##                 : This is a required property. The subscriptionId is the subscription identifier and is unique for each customer. Since a subscriptionId changes when a subscription is updated, we recommend to not use this ID as a key for persistent data. And the subscriptionId can be found using the retrieve all reseller subscriptions method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   customerId: string (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580177 = newJObject()
  var query_580178 = newJObject()
  add(query_580178, "fields", newJString(fields))
  add(query_580178, "quotaUser", newJString(quotaUser))
  add(query_580178, "alt", newJString(alt))
  add(path_580177, "subscriptionId", newJString(subscriptionId))
  add(query_580178, "oauth_token", newJString(oauthToken))
  add(query_580178, "userIp", newJString(userIp))
  add(path_580177, "customerId", newJString(customerId))
  add(query_580178, "key", newJString(key))
  add(query_580178, "prettyPrint", newJBool(prettyPrint))
  result = call_580176.call(path_580177, query_580178, nil, nil, nil)

var resellerSubscriptionsSuspend* = Call_ResellerSubscriptionsSuspend_580163(
    name: "resellerSubscriptionsSuspend", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/customers/{customerId}/subscriptions/{subscriptionId}/suspend",
    validator: validate_ResellerSubscriptionsSuspend_580164,
    base: "/apps/reseller/v1", url: url_ResellerSubscriptionsSuspend_580165,
    schemes: {Scheme.Https})
type
  Call_ResellerResellernotifyGetwatchdetails_580179 = ref object of OpenApiRestCall_579424
proc url_ResellerResellernotifyGetwatchdetails_580181(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ResellerResellernotifyGetwatchdetails_580180(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns all the details of the watch corresponding to the reseller.
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
  if body != nil:
    result.add "body", body

proc call*(call_580189: Call_ResellerResellernotifyGetwatchdetails_580179;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns all the details of the watch corresponding to the reseller.
  ## 
  let valid = call_580189.validator(path, query, header, formData, body)
  let scheme = call_580189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580189.url(scheme.get, call_580189.host, call_580189.base,
                         call_580189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580189, url, valid)

proc call*(call_580190: Call_ResellerResellernotifyGetwatchdetails_580179;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## resellerResellernotifyGetwatchdetails
  ## Returns all the details of the watch corresponding to the reseller.
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
  var query_580191 = newJObject()
  add(query_580191, "fields", newJString(fields))
  add(query_580191, "quotaUser", newJString(quotaUser))
  add(query_580191, "alt", newJString(alt))
  add(query_580191, "oauth_token", newJString(oauthToken))
  add(query_580191, "userIp", newJString(userIp))
  add(query_580191, "key", newJString(key))
  add(query_580191, "prettyPrint", newJBool(prettyPrint))
  result = call_580190.call(nil, query_580191, nil, nil, nil)

var resellerResellernotifyGetwatchdetails* = Call_ResellerResellernotifyGetwatchdetails_580179(
    name: "resellerResellernotifyGetwatchdetails", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/resellernotify/getwatchdetails",
    validator: validate_ResellerResellernotifyGetwatchdetails_580180,
    base: "/apps/reseller/v1", url: url_ResellerResellernotifyGetwatchdetails_580181,
    schemes: {Scheme.Https})
type
  Call_ResellerResellernotifyRegister_580192 = ref object of OpenApiRestCall_579424
proc url_ResellerResellernotifyRegister_580194(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ResellerResellernotifyRegister_580193(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Registers a Reseller for receiving notifications.
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
  ##   serviceAccountEmailAddress: JString
  ##                             : The service account which will own the created Cloud-PubSub topic.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580195 = query.getOrDefault("fields")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "fields", valid_580195
  var valid_580196 = query.getOrDefault("quotaUser")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "quotaUser", valid_580196
  var valid_580197 = query.getOrDefault("alt")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = newJString("json"))
  if valid_580197 != nil:
    section.add "alt", valid_580197
  var valid_580198 = query.getOrDefault("oauth_token")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "oauth_token", valid_580198
  var valid_580199 = query.getOrDefault("userIp")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "userIp", valid_580199
  var valid_580200 = query.getOrDefault("serviceAccountEmailAddress")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "serviceAccountEmailAddress", valid_580200
  var valid_580201 = query.getOrDefault("key")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "key", valid_580201
  var valid_580202 = query.getOrDefault("prettyPrint")
  valid_580202 = validateParameter(valid_580202, JBool, required = false,
                                 default = newJBool(true))
  if valid_580202 != nil:
    section.add "prettyPrint", valid_580202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580203: Call_ResellerResellernotifyRegister_580192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers a Reseller for receiving notifications.
  ## 
  let valid = call_580203.validator(path, query, header, formData, body)
  let scheme = call_580203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580203.url(scheme.get, call_580203.host, call_580203.base,
                         call_580203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580203, url, valid)

proc call*(call_580204: Call_ResellerResellernotifyRegister_580192;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = "";
          serviceAccountEmailAddress: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## resellerResellernotifyRegister
  ## Registers a Reseller for receiving notifications.
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
  ##   serviceAccountEmailAddress: string
  ##                             : The service account which will own the created Cloud-PubSub topic.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580205 = newJObject()
  add(query_580205, "fields", newJString(fields))
  add(query_580205, "quotaUser", newJString(quotaUser))
  add(query_580205, "alt", newJString(alt))
  add(query_580205, "oauth_token", newJString(oauthToken))
  add(query_580205, "userIp", newJString(userIp))
  add(query_580205, "serviceAccountEmailAddress",
      newJString(serviceAccountEmailAddress))
  add(query_580205, "key", newJString(key))
  add(query_580205, "prettyPrint", newJBool(prettyPrint))
  result = call_580204.call(nil, query_580205, nil, nil, nil)

var resellerResellernotifyRegister* = Call_ResellerResellernotifyRegister_580192(
    name: "resellerResellernotifyRegister", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/resellernotify/register",
    validator: validate_ResellerResellernotifyRegister_580193,
    base: "/apps/reseller/v1", url: url_ResellerResellernotifyRegister_580194,
    schemes: {Scheme.Https})
type
  Call_ResellerResellernotifyUnregister_580206 = ref object of OpenApiRestCall_579424
proc url_ResellerResellernotifyUnregister_580208(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ResellerResellernotifyUnregister_580207(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Unregisters a Reseller for receiving notifications.
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
  ##   serviceAccountEmailAddress: JString
  ##                             : The service account which owns the Cloud-PubSub topic.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580209 = query.getOrDefault("fields")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "fields", valid_580209
  var valid_580210 = query.getOrDefault("quotaUser")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "quotaUser", valid_580210
  var valid_580211 = query.getOrDefault("alt")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = newJString("json"))
  if valid_580211 != nil:
    section.add "alt", valid_580211
  var valid_580212 = query.getOrDefault("oauth_token")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "oauth_token", valid_580212
  var valid_580213 = query.getOrDefault("userIp")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "userIp", valid_580213
  var valid_580214 = query.getOrDefault("serviceAccountEmailAddress")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "serviceAccountEmailAddress", valid_580214
  var valid_580215 = query.getOrDefault("key")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "key", valid_580215
  var valid_580216 = query.getOrDefault("prettyPrint")
  valid_580216 = validateParameter(valid_580216, JBool, required = false,
                                 default = newJBool(true))
  if valid_580216 != nil:
    section.add "prettyPrint", valid_580216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580217: Call_ResellerResellernotifyUnregister_580206;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unregisters a Reseller for receiving notifications.
  ## 
  let valid = call_580217.validator(path, query, header, formData, body)
  let scheme = call_580217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580217.url(scheme.get, call_580217.host, call_580217.base,
                         call_580217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580217, url, valid)

proc call*(call_580218: Call_ResellerResellernotifyUnregister_580206;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = "";
          serviceAccountEmailAddress: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## resellerResellernotifyUnregister
  ## Unregisters a Reseller for receiving notifications.
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
  ##   serviceAccountEmailAddress: string
  ##                             : The service account which owns the Cloud-PubSub topic.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580219 = newJObject()
  add(query_580219, "fields", newJString(fields))
  add(query_580219, "quotaUser", newJString(quotaUser))
  add(query_580219, "alt", newJString(alt))
  add(query_580219, "oauth_token", newJString(oauthToken))
  add(query_580219, "userIp", newJString(userIp))
  add(query_580219, "serviceAccountEmailAddress",
      newJString(serviceAccountEmailAddress))
  add(query_580219, "key", newJString(key))
  add(query_580219, "prettyPrint", newJBool(prettyPrint))
  result = call_580218.call(nil, query_580219, nil, nil, nil)

var resellerResellernotifyUnregister* = Call_ResellerResellernotifyUnregister_580206(
    name: "resellerResellernotifyUnregister", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/resellernotify/unregister",
    validator: validate_ResellerResellernotifyUnregister_580207,
    base: "/apps/reseller/v1", url: url_ResellerResellernotifyUnregister_580208,
    schemes: {Scheme.Https})
type
  Call_ResellerSubscriptionsList_580220 = ref object of OpenApiRestCall_579424
proc url_ResellerSubscriptionsList_580222(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ResellerSubscriptionsList_580221(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List of subscriptions managed by the reseller. The list can be all subscriptions, all of a customer's subscriptions, or all of a customer's transferable subscriptions.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to specify next page in the list
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   customerId: JString
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : When retrieving a large list, the maxResults is the maximum number of results per page. The nextPageToken value takes you to the next page. The default is 20.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customerAuthToken: JString
  ##                    : The customerAuthToken query string is required when creating a resold account that transfers a direct customer's subscription or transfers another reseller customer's subscription to your reseller management. This is a hexadecimal authentication token needed to complete the subscription transfer. For more information, see the administrator help center.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   customerNamePrefix: JString
  ##                     : When retrieving all of your subscriptions and filtering for specific customers, you can enter a prefix for a customer name. Using an example customer group that includes exam.com, example20.com and example.com:  
  ## - exa -- Returns all customer names that start with 'exa' which could include exam.com, example20.com, and example.com. A name prefix is similar to using a regular expression's asterisk, exa*. 
  ## - example -- Returns example20.com and example.com.
  section = newJObject()
  var valid_580223 = query.getOrDefault("fields")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "fields", valid_580223
  var valid_580224 = query.getOrDefault("pageToken")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "pageToken", valid_580224
  var valid_580225 = query.getOrDefault("quotaUser")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "quotaUser", valid_580225
  var valid_580226 = query.getOrDefault("alt")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = newJString("json"))
  if valid_580226 != nil:
    section.add "alt", valid_580226
  var valid_580227 = query.getOrDefault("customerId")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "customerId", valid_580227
  var valid_580228 = query.getOrDefault("oauth_token")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "oauth_token", valid_580228
  var valid_580229 = query.getOrDefault("userIp")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "userIp", valid_580229
  var valid_580230 = query.getOrDefault("maxResults")
  valid_580230 = validateParameter(valid_580230, JInt, required = false, default = nil)
  if valid_580230 != nil:
    section.add "maxResults", valid_580230
  var valid_580231 = query.getOrDefault("key")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "key", valid_580231
  var valid_580232 = query.getOrDefault("customerAuthToken")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "customerAuthToken", valid_580232
  var valid_580233 = query.getOrDefault("prettyPrint")
  valid_580233 = validateParameter(valid_580233, JBool, required = false,
                                 default = newJBool(true))
  if valid_580233 != nil:
    section.add "prettyPrint", valid_580233
  var valid_580234 = query.getOrDefault("customerNamePrefix")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "customerNamePrefix", valid_580234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580235: Call_ResellerSubscriptionsList_580220; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List of subscriptions managed by the reseller. The list can be all subscriptions, all of a customer's subscriptions, or all of a customer's transferable subscriptions.
  ## 
  let valid = call_580235.validator(path, query, header, formData, body)
  let scheme = call_580235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580235.url(scheme.get, call_580235.host, call_580235.base,
                         call_580235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580235, url, valid)

proc call*(call_580236: Call_ResellerSubscriptionsList_580220; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          customerId: string = ""; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; customerAuthToken: string = "";
          prettyPrint: bool = true; customerNamePrefix: string = ""): Recallable =
  ## resellerSubscriptionsList
  ## List of subscriptions managed by the reseller. The list can be all subscriptions, all of a customer's subscriptions, or all of a customer's transferable subscriptions.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to specify next page in the list
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   customerId: string
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : When retrieving a large list, the maxResults is the maximum number of results per page. The nextPageToken value takes you to the next page. The default is 20.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customerAuthToken: string
  ##                    : The customerAuthToken query string is required when creating a resold account that transfers a direct customer's subscription or transfers another reseller customer's subscription to your reseller management. This is a hexadecimal authentication token needed to complete the subscription transfer. For more information, see the administrator help center.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   customerNamePrefix: string
  ##                     : When retrieving all of your subscriptions and filtering for specific customers, you can enter a prefix for a customer name. Using an example customer group that includes exam.com, example20.com and example.com:  
  ## - exa -- Returns all customer names that start with 'exa' which could include exam.com, example20.com, and example.com. A name prefix is similar to using a regular expression's asterisk, exa*. 
  ## - example -- Returns example20.com and example.com.
  var query_580237 = newJObject()
  add(query_580237, "fields", newJString(fields))
  add(query_580237, "pageToken", newJString(pageToken))
  add(query_580237, "quotaUser", newJString(quotaUser))
  add(query_580237, "alt", newJString(alt))
  add(query_580237, "customerId", newJString(customerId))
  add(query_580237, "oauth_token", newJString(oauthToken))
  add(query_580237, "userIp", newJString(userIp))
  add(query_580237, "maxResults", newJInt(maxResults))
  add(query_580237, "key", newJString(key))
  add(query_580237, "customerAuthToken", newJString(customerAuthToken))
  add(query_580237, "prettyPrint", newJBool(prettyPrint))
  add(query_580237, "customerNamePrefix", newJString(customerNamePrefix))
  result = call_580236.call(nil, query_580237, nil, nil, nil)

var resellerSubscriptionsList* = Call_ResellerSubscriptionsList_580220(
    name: "resellerSubscriptionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/subscriptions",
    validator: validate_ResellerSubscriptionsList_580221,
    base: "/apps/reseller/v1", url: url_ResellerSubscriptionsList_580222,
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
