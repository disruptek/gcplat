
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

  OpenApiRestCall_578355 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578355](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578355): Option[Scheme] {.used.} =
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
  gcpServiceName = "reseller"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ResellerCustomersInsert_578625 = ref object of OpenApiRestCall_578355
proc url_ResellerCustomersInsert_578627(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ResellerCustomersInsert_578626(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Order a new customer's account.
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
  ##   customerAuthToken: JString
  ##                    : The customerAuthToken query string is required when creating a resold account that transfers a direct customer's subscription or transfers another reseller customer's subscription to your reseller management. This is a hexadecimal authentication token needed to complete the subscription transfer. For more information, see the administrator help center.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578753 = query.getOrDefault("prettyPrint")
  valid_578753 = validateParameter(valid_578753, JBool, required = false,
                                 default = newJBool(true))
  if valid_578753 != nil:
    section.add "prettyPrint", valid_578753
  var valid_578754 = query.getOrDefault("oauth_token")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "oauth_token", valid_578754
  var valid_578755 = query.getOrDefault("customerAuthToken")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "customerAuthToken", valid_578755
  var valid_578756 = query.getOrDefault("alt")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = newJString("json"))
  if valid_578756 != nil:
    section.add "alt", valid_578756
  var valid_578757 = query.getOrDefault("userIp")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "userIp", valid_578757
  var valid_578758 = query.getOrDefault("quotaUser")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "quotaUser", valid_578758
  var valid_578759 = query.getOrDefault("fields")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "fields", valid_578759
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

proc call*(call_578783: Call_ResellerCustomersInsert_578625; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Order a new customer's account.
  ## 
  let valid = call_578783.validator(path, query, header, formData, body)
  let scheme = call_578783.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578783.url(scheme.get, call_578783.host, call_578783.base,
                         call_578783.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578783, url, valid)

proc call*(call_578854: Call_ResellerCustomersInsert_578625; key: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          customerAuthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## resellerCustomersInsert
  ## Order a new customer's account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customerAuthToken: string
  ##                    : The customerAuthToken query string is required when creating a resold account that transfers a direct customer's subscription or transfers another reseller customer's subscription to your reseller management. This is a hexadecimal authentication token needed to complete the subscription transfer. For more information, see the administrator help center.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578855 = newJObject()
  var body_578857 = newJObject()
  add(query_578855, "key", newJString(key))
  add(query_578855, "prettyPrint", newJBool(prettyPrint))
  add(query_578855, "oauth_token", newJString(oauthToken))
  add(query_578855, "customerAuthToken", newJString(customerAuthToken))
  add(query_578855, "alt", newJString(alt))
  add(query_578855, "userIp", newJString(userIp))
  add(query_578855, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578857 = body
  add(query_578855, "fields", newJString(fields))
  result = call_578854.call(nil, query_578855, nil, nil, body_578857)

var resellerCustomersInsert* = Call_ResellerCustomersInsert_578625(
    name: "resellerCustomersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customers",
    validator: validate_ResellerCustomersInsert_578626, base: "/apps/reseller/v1",
    url: url_ResellerCustomersInsert_578627, schemes: {Scheme.Https})
type
  Call_ResellerCustomersUpdate_578925 = ref object of OpenApiRestCall_578355
proc url_ResellerCustomersUpdate_578927(protocol: Scheme; host: string; base: string;
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

proc validate_ResellerCustomersUpdate_578926(path: JsonNode; query: JsonNode;
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
  var valid_578928 = path.getOrDefault("customerId")
  valid_578928 = validateParameter(valid_578928, JString, required = true,
                                 default = nil)
  if valid_578928 != nil:
    section.add "customerId", valid_578928
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
  var valid_578929 = query.getOrDefault("key")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "key", valid_578929
  var valid_578930 = query.getOrDefault("prettyPrint")
  valid_578930 = validateParameter(valid_578930, JBool, required = false,
                                 default = newJBool(true))
  if valid_578930 != nil:
    section.add "prettyPrint", valid_578930
  var valid_578931 = query.getOrDefault("oauth_token")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "oauth_token", valid_578931
  var valid_578932 = query.getOrDefault("alt")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = newJString("json"))
  if valid_578932 != nil:
    section.add "alt", valid_578932
  var valid_578933 = query.getOrDefault("userIp")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "userIp", valid_578933
  var valid_578934 = query.getOrDefault("quotaUser")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "quotaUser", valid_578934
  var valid_578935 = query.getOrDefault("fields")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "fields", valid_578935
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

proc call*(call_578937: Call_ResellerCustomersUpdate_578925; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a customer account's settings.
  ## 
  let valid = call_578937.validator(path, query, header, formData, body)
  let scheme = call_578937.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578937.url(scheme.get, call_578937.host, call_578937.base,
                         call_578937.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578937, url, valid)

proc call*(call_578938: Call_ResellerCustomersUpdate_578925; customerId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## resellerCustomersUpdate
  ## Update a customer account's settings.
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
  ##   customerId: string (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578939 = newJObject()
  var query_578940 = newJObject()
  var body_578941 = newJObject()
  add(query_578940, "key", newJString(key))
  add(query_578940, "prettyPrint", newJBool(prettyPrint))
  add(query_578940, "oauth_token", newJString(oauthToken))
  add(query_578940, "alt", newJString(alt))
  add(query_578940, "userIp", newJString(userIp))
  add(query_578940, "quotaUser", newJString(quotaUser))
  add(path_578939, "customerId", newJString(customerId))
  if body != nil:
    body_578941 = body
  add(query_578940, "fields", newJString(fields))
  result = call_578938.call(path_578939, query_578940, nil, nil, body_578941)

var resellerCustomersUpdate* = Call_ResellerCustomersUpdate_578925(
    name: "resellerCustomersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/customers/{customerId}",
    validator: validate_ResellerCustomersUpdate_578926, base: "/apps/reseller/v1",
    url: url_ResellerCustomersUpdate_578927, schemes: {Scheme.Https})
type
  Call_ResellerCustomersGet_578896 = ref object of OpenApiRestCall_578355
proc url_ResellerCustomersGet_578898(protocol: Scheme; host: string; base: string;
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

proc validate_ResellerCustomersGet_578897(path: JsonNode; query: JsonNode;
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
  var valid_578913 = path.getOrDefault("customerId")
  valid_578913 = validateParameter(valid_578913, JString, required = true,
                                 default = nil)
  if valid_578913 != nil:
    section.add "customerId", valid_578913
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
  var valid_578914 = query.getOrDefault("key")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "key", valid_578914
  var valid_578915 = query.getOrDefault("prettyPrint")
  valid_578915 = validateParameter(valid_578915, JBool, required = false,
                                 default = newJBool(true))
  if valid_578915 != nil:
    section.add "prettyPrint", valid_578915
  var valid_578916 = query.getOrDefault("oauth_token")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "oauth_token", valid_578916
  var valid_578917 = query.getOrDefault("alt")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = newJString("json"))
  if valid_578917 != nil:
    section.add "alt", valid_578917
  var valid_578918 = query.getOrDefault("userIp")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "userIp", valid_578918
  var valid_578919 = query.getOrDefault("quotaUser")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "quotaUser", valid_578919
  var valid_578920 = query.getOrDefault("fields")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "fields", valid_578920
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578921: Call_ResellerCustomersGet_578896; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a customer account.
  ## 
  let valid = call_578921.validator(path, query, header, formData, body)
  let scheme = call_578921.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578921.url(scheme.get, call_578921.host, call_578921.base,
                         call_578921.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578921, url, valid)

proc call*(call_578922: Call_ResellerCustomersGet_578896; customerId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## resellerCustomersGet
  ## Get a customer account.
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
  ##   customerId: string (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578923 = newJObject()
  var query_578924 = newJObject()
  add(query_578924, "key", newJString(key))
  add(query_578924, "prettyPrint", newJBool(prettyPrint))
  add(query_578924, "oauth_token", newJString(oauthToken))
  add(query_578924, "alt", newJString(alt))
  add(query_578924, "userIp", newJString(userIp))
  add(query_578924, "quotaUser", newJString(quotaUser))
  add(path_578923, "customerId", newJString(customerId))
  add(query_578924, "fields", newJString(fields))
  result = call_578922.call(path_578923, query_578924, nil, nil, nil)

var resellerCustomersGet* = Call_ResellerCustomersGet_578896(
    name: "resellerCustomersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customers/{customerId}",
    validator: validate_ResellerCustomersGet_578897, base: "/apps/reseller/v1",
    url: url_ResellerCustomersGet_578898, schemes: {Scheme.Https})
type
  Call_ResellerCustomersPatch_578942 = ref object of OpenApiRestCall_578355
proc url_ResellerCustomersPatch_578944(protocol: Scheme; host: string; base: string;
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

proc validate_ResellerCustomersPatch_578943(path: JsonNode; query: JsonNode;
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
  var valid_578945 = path.getOrDefault("customerId")
  valid_578945 = validateParameter(valid_578945, JString, required = true,
                                 default = nil)
  if valid_578945 != nil:
    section.add "customerId", valid_578945
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
  var valid_578946 = query.getOrDefault("key")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "key", valid_578946
  var valid_578947 = query.getOrDefault("prettyPrint")
  valid_578947 = validateParameter(valid_578947, JBool, required = false,
                                 default = newJBool(true))
  if valid_578947 != nil:
    section.add "prettyPrint", valid_578947
  var valid_578948 = query.getOrDefault("oauth_token")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "oauth_token", valid_578948
  var valid_578949 = query.getOrDefault("alt")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = newJString("json"))
  if valid_578949 != nil:
    section.add "alt", valid_578949
  var valid_578950 = query.getOrDefault("userIp")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "userIp", valid_578950
  var valid_578951 = query.getOrDefault("quotaUser")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "quotaUser", valid_578951
  var valid_578952 = query.getOrDefault("fields")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "fields", valid_578952
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

proc call*(call_578954: Call_ResellerCustomersPatch_578942; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a customer account's settings. This method supports patch semantics.
  ## 
  let valid = call_578954.validator(path, query, header, formData, body)
  let scheme = call_578954.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578954.url(scheme.get, call_578954.host, call_578954.base,
                         call_578954.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578954, url, valid)

proc call*(call_578955: Call_ResellerCustomersPatch_578942; customerId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## resellerCustomersPatch
  ## Update a customer account's settings. This method supports patch semantics.
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
  ##   customerId: string (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578956 = newJObject()
  var query_578957 = newJObject()
  var body_578958 = newJObject()
  add(query_578957, "key", newJString(key))
  add(query_578957, "prettyPrint", newJBool(prettyPrint))
  add(query_578957, "oauth_token", newJString(oauthToken))
  add(query_578957, "alt", newJString(alt))
  add(query_578957, "userIp", newJString(userIp))
  add(query_578957, "quotaUser", newJString(quotaUser))
  add(path_578956, "customerId", newJString(customerId))
  if body != nil:
    body_578958 = body
  add(query_578957, "fields", newJString(fields))
  result = call_578955.call(path_578956, query_578957, nil, nil, body_578958)

var resellerCustomersPatch* = Call_ResellerCustomersPatch_578942(
    name: "resellerCustomersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/customers/{customerId}",
    validator: validate_ResellerCustomersPatch_578943, base: "/apps/reseller/v1",
    url: url_ResellerCustomersPatch_578944, schemes: {Scheme.Https})
type
  Call_ResellerSubscriptionsInsert_578959 = ref object of OpenApiRestCall_578355
proc url_ResellerSubscriptionsInsert_578961(protocol: Scheme; host: string;
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

proc validate_ResellerSubscriptionsInsert_578960(path: JsonNode; query: JsonNode;
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
  var valid_578962 = path.getOrDefault("customerId")
  valid_578962 = validateParameter(valid_578962, JString, required = true,
                                 default = nil)
  if valid_578962 != nil:
    section.add "customerId", valid_578962
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   customerAuthToken: JString
  ##                    : The customerAuthToken query string is required when creating a resold account that transfers a direct customer's subscription or transfers another reseller customer's subscription to your reseller management. This is a hexadecimal authentication token needed to complete the subscription transfer. For more information, see the administrator help center.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578963 = query.getOrDefault("key")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "key", valid_578963
  var valid_578964 = query.getOrDefault("prettyPrint")
  valid_578964 = validateParameter(valid_578964, JBool, required = false,
                                 default = newJBool(true))
  if valid_578964 != nil:
    section.add "prettyPrint", valid_578964
  var valid_578965 = query.getOrDefault("oauth_token")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "oauth_token", valid_578965
  var valid_578966 = query.getOrDefault("customerAuthToken")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "customerAuthToken", valid_578966
  var valid_578967 = query.getOrDefault("alt")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = newJString("json"))
  if valid_578967 != nil:
    section.add "alt", valid_578967
  var valid_578968 = query.getOrDefault("userIp")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "userIp", valid_578968
  var valid_578969 = query.getOrDefault("quotaUser")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "quotaUser", valid_578969
  var valid_578970 = query.getOrDefault("fields")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "fields", valid_578970
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

proc call*(call_578972: Call_ResellerSubscriptionsInsert_578959; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or transfer a subscription.
  ## 
  let valid = call_578972.validator(path, query, header, formData, body)
  let scheme = call_578972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578972.url(scheme.get, call_578972.host, call_578972.base,
                         call_578972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578972, url, valid)

proc call*(call_578973: Call_ResellerSubscriptionsInsert_578959;
          customerId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; customerAuthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## resellerSubscriptionsInsert
  ## Create or transfer a subscription.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customerAuthToken: string
  ##                    : The customerAuthToken query string is required when creating a resold account that transfers a direct customer's subscription or transfers another reseller customer's subscription to your reseller management. This is a hexadecimal authentication token needed to complete the subscription transfer. For more information, see the administrator help center.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   customerId: string (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578974 = newJObject()
  var query_578975 = newJObject()
  var body_578976 = newJObject()
  add(query_578975, "key", newJString(key))
  add(query_578975, "prettyPrint", newJBool(prettyPrint))
  add(query_578975, "oauth_token", newJString(oauthToken))
  add(query_578975, "customerAuthToken", newJString(customerAuthToken))
  add(query_578975, "alt", newJString(alt))
  add(query_578975, "userIp", newJString(userIp))
  add(query_578975, "quotaUser", newJString(quotaUser))
  add(path_578974, "customerId", newJString(customerId))
  if body != nil:
    body_578976 = body
  add(query_578975, "fields", newJString(fields))
  result = call_578973.call(path_578974, query_578975, nil, nil, body_578976)

var resellerSubscriptionsInsert* = Call_ResellerSubscriptionsInsert_578959(
    name: "resellerSubscriptionsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customers/{customerId}/subscriptions",
    validator: validate_ResellerSubscriptionsInsert_578960,
    base: "/apps/reseller/v1", url: url_ResellerSubscriptionsInsert_578961,
    schemes: {Scheme.Https})
type
  Call_ResellerSubscriptionsGet_578977 = ref object of OpenApiRestCall_578355
proc url_ResellerSubscriptionsGet_578979(protocol: Scheme; host: string;
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

proc validate_ResellerSubscriptionsGet_578978(path: JsonNode; query: JsonNode;
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
  var valid_578980 = path.getOrDefault("subscriptionId")
  valid_578980 = validateParameter(valid_578980, JString, required = true,
                                 default = nil)
  if valid_578980 != nil:
    section.add "subscriptionId", valid_578980
  var valid_578981 = path.getOrDefault("customerId")
  valid_578981 = validateParameter(valid_578981, JString, required = true,
                                 default = nil)
  if valid_578981 != nil:
    section.add "customerId", valid_578981
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
  var valid_578982 = query.getOrDefault("key")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "key", valid_578982
  var valid_578983 = query.getOrDefault("prettyPrint")
  valid_578983 = validateParameter(valid_578983, JBool, required = false,
                                 default = newJBool(true))
  if valid_578983 != nil:
    section.add "prettyPrint", valid_578983
  var valid_578984 = query.getOrDefault("oauth_token")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "oauth_token", valid_578984
  var valid_578985 = query.getOrDefault("alt")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = newJString("json"))
  if valid_578985 != nil:
    section.add "alt", valid_578985
  var valid_578986 = query.getOrDefault("userIp")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "userIp", valid_578986
  var valid_578987 = query.getOrDefault("quotaUser")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "quotaUser", valid_578987
  var valid_578988 = query.getOrDefault("fields")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "fields", valid_578988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578989: Call_ResellerSubscriptionsGet_578977; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific subscription.
  ## 
  let valid = call_578989.validator(path, query, header, formData, body)
  let scheme = call_578989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578989.url(scheme.get, call_578989.host, call_578989.base,
                         call_578989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578989, url, valid)

proc call*(call_578990: Call_ResellerSubscriptionsGet_578977;
          subscriptionId: string; customerId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## resellerSubscriptionsGet
  ## Get a specific subscription.
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
  ##   subscriptionId: string (required)
  ##                 : This is a required property. The subscriptionId is the subscription identifier and is unique for each customer. Since a subscriptionId changes when a subscription is updated, we recommend to not use this ID as a key for persistent data. And the subscriptionId can be found using the retrieve all reseller subscriptions method.
  ##   customerId: string (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578991 = newJObject()
  var query_578992 = newJObject()
  add(query_578992, "key", newJString(key))
  add(query_578992, "prettyPrint", newJBool(prettyPrint))
  add(query_578992, "oauth_token", newJString(oauthToken))
  add(query_578992, "alt", newJString(alt))
  add(query_578992, "userIp", newJString(userIp))
  add(query_578992, "quotaUser", newJString(quotaUser))
  add(path_578991, "subscriptionId", newJString(subscriptionId))
  add(path_578991, "customerId", newJString(customerId))
  add(query_578992, "fields", newJString(fields))
  result = call_578990.call(path_578991, query_578992, nil, nil, nil)

var resellerSubscriptionsGet* = Call_ResellerSubscriptionsGet_578977(
    name: "resellerSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customers/{customerId}/subscriptions/{subscriptionId}",
    validator: validate_ResellerSubscriptionsGet_578978,
    base: "/apps/reseller/v1", url: url_ResellerSubscriptionsGet_578979,
    schemes: {Scheme.Https})
type
  Call_ResellerSubscriptionsDelete_578993 = ref object of OpenApiRestCall_578355
proc url_ResellerSubscriptionsDelete_578995(protocol: Scheme; host: string;
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

proc validate_ResellerSubscriptionsDelete_578994(path: JsonNode; query: JsonNode;
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
  var valid_578996 = path.getOrDefault("subscriptionId")
  valid_578996 = validateParameter(valid_578996, JString, required = true,
                                 default = nil)
  if valid_578996 != nil:
    section.add "subscriptionId", valid_578996
  var valid_578997 = path.getOrDefault("customerId")
  valid_578997 = validateParameter(valid_578997, JString, required = true,
                                 default = nil)
  if valid_578997 != nil:
    section.add "customerId", valid_578997
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
  ##   deletionType: JString (required)
  ##               : The deletionType query string enables the cancellation, downgrade, or suspension of a subscription.
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
  assert query != nil,
        "query argument is necessary due to required `deletionType` field"
  var valid_579005 = query.getOrDefault("deletionType")
  valid_579005 = validateParameter(valid_579005, JString, required = true,
                                 default = newJString("cancel"))
  if valid_579005 != nil:
    section.add "deletionType", valid_579005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579006: Call_ResellerSubscriptionsDelete_578993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancel or transfer a subscription to direct.
  ## 
  let valid = call_579006.validator(path, query, header, formData, body)
  let scheme = call_579006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579006.url(scheme.get, call_579006.host, call_579006.base,
                         call_579006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579006, url, valid)

proc call*(call_579007: Call_ResellerSubscriptionsDelete_578993;
          subscriptionId: string; customerId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = "";
          deletionType: string = "cancel"): Recallable =
  ## resellerSubscriptionsDelete
  ## Cancel or transfer a subscription to direct.
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
  ##   subscriptionId: string (required)
  ##                 : This is a required property. The subscriptionId is the subscription identifier and is unique for each customer. Since a subscriptionId changes when a subscription is updated, we recommend to not use this ID as a key for persistent data. And the subscriptionId can be found using the retrieve all reseller subscriptions method.
  ##   customerId: string (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   deletionType: string (required)
  ##               : The deletionType query string enables the cancellation, downgrade, or suspension of a subscription.
  var path_579008 = newJObject()
  var query_579009 = newJObject()
  add(query_579009, "key", newJString(key))
  add(query_579009, "prettyPrint", newJBool(prettyPrint))
  add(query_579009, "oauth_token", newJString(oauthToken))
  add(query_579009, "alt", newJString(alt))
  add(query_579009, "userIp", newJString(userIp))
  add(query_579009, "quotaUser", newJString(quotaUser))
  add(path_579008, "subscriptionId", newJString(subscriptionId))
  add(path_579008, "customerId", newJString(customerId))
  add(query_579009, "fields", newJString(fields))
  add(query_579009, "deletionType", newJString(deletionType))
  result = call_579007.call(path_579008, query_579009, nil, nil, nil)

var resellerSubscriptionsDelete* = Call_ResellerSubscriptionsDelete_578993(
    name: "resellerSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customers/{customerId}/subscriptions/{subscriptionId}",
    validator: validate_ResellerSubscriptionsDelete_578994,
    base: "/apps/reseller/v1", url: url_ResellerSubscriptionsDelete_578995,
    schemes: {Scheme.Https})
type
  Call_ResellerSubscriptionsActivate_579010 = ref object of OpenApiRestCall_578355
proc url_ResellerSubscriptionsActivate_579012(protocol: Scheme; host: string;
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

proc validate_ResellerSubscriptionsActivate_579011(path: JsonNode; query: JsonNode;
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
  var valid_579013 = path.getOrDefault("subscriptionId")
  valid_579013 = validateParameter(valid_579013, JString, required = true,
                                 default = nil)
  if valid_579013 != nil:
    section.add "subscriptionId", valid_579013
  var valid_579014 = path.getOrDefault("customerId")
  valid_579014 = validateParameter(valid_579014, JString, required = true,
                                 default = nil)
  if valid_579014 != nil:
    section.add "customerId", valid_579014
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
  var valid_579015 = query.getOrDefault("key")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "key", valid_579015
  var valid_579016 = query.getOrDefault("prettyPrint")
  valid_579016 = validateParameter(valid_579016, JBool, required = false,
                                 default = newJBool(true))
  if valid_579016 != nil:
    section.add "prettyPrint", valid_579016
  var valid_579017 = query.getOrDefault("oauth_token")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "oauth_token", valid_579017
  var valid_579018 = query.getOrDefault("alt")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = newJString("json"))
  if valid_579018 != nil:
    section.add "alt", valid_579018
  var valid_579019 = query.getOrDefault("userIp")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "userIp", valid_579019
  var valid_579020 = query.getOrDefault("quotaUser")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "quotaUser", valid_579020
  var valid_579021 = query.getOrDefault("fields")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "fields", valid_579021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579022: Call_ResellerSubscriptionsActivate_579010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Activates a subscription previously suspended by the reseller
  ## 
  let valid = call_579022.validator(path, query, header, formData, body)
  let scheme = call_579022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579022.url(scheme.get, call_579022.host, call_579022.base,
                         call_579022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579022, url, valid)

proc call*(call_579023: Call_ResellerSubscriptionsActivate_579010;
          subscriptionId: string; customerId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## resellerSubscriptionsActivate
  ## Activates a subscription previously suspended by the reseller
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
  ##   subscriptionId: string (required)
  ##                 : This is a required property. The subscriptionId is the subscription identifier and is unique for each customer. Since a subscriptionId changes when a subscription is updated, we recommend to not use this ID as a key for persistent data. And the subscriptionId can be found using the retrieve all reseller subscriptions method.
  ##   customerId: string (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579024 = newJObject()
  var query_579025 = newJObject()
  add(query_579025, "key", newJString(key))
  add(query_579025, "prettyPrint", newJBool(prettyPrint))
  add(query_579025, "oauth_token", newJString(oauthToken))
  add(query_579025, "alt", newJString(alt))
  add(query_579025, "userIp", newJString(userIp))
  add(query_579025, "quotaUser", newJString(quotaUser))
  add(path_579024, "subscriptionId", newJString(subscriptionId))
  add(path_579024, "customerId", newJString(customerId))
  add(query_579025, "fields", newJString(fields))
  result = call_579023.call(path_579024, query_579025, nil, nil, nil)

var resellerSubscriptionsActivate* = Call_ResellerSubscriptionsActivate_579010(
    name: "resellerSubscriptionsActivate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/customers/{customerId}/subscriptions/{subscriptionId}/activate",
    validator: validate_ResellerSubscriptionsActivate_579011,
    base: "/apps/reseller/v1", url: url_ResellerSubscriptionsActivate_579012,
    schemes: {Scheme.Https})
type
  Call_ResellerSubscriptionsChangePlan_579026 = ref object of OpenApiRestCall_578355
proc url_ResellerSubscriptionsChangePlan_579028(protocol: Scheme; host: string;
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

proc validate_ResellerSubscriptionsChangePlan_579027(path: JsonNode;
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
  var valid_579029 = path.getOrDefault("subscriptionId")
  valid_579029 = validateParameter(valid_579029, JString, required = true,
                                 default = nil)
  if valid_579029 != nil:
    section.add "subscriptionId", valid_579029
  var valid_579030 = path.getOrDefault("customerId")
  valid_579030 = validateParameter(valid_579030, JString, required = true,
                                 default = nil)
  if valid_579030 != nil:
    section.add "customerId", valid_579030
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
  var valid_579031 = query.getOrDefault("key")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "key", valid_579031
  var valid_579032 = query.getOrDefault("prettyPrint")
  valid_579032 = validateParameter(valid_579032, JBool, required = false,
                                 default = newJBool(true))
  if valid_579032 != nil:
    section.add "prettyPrint", valid_579032
  var valid_579033 = query.getOrDefault("oauth_token")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "oauth_token", valid_579033
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
  var valid_579037 = query.getOrDefault("fields")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "fields", valid_579037
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

proc call*(call_579039: Call_ResellerSubscriptionsChangePlan_579026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update a subscription plan. Use this method to update a plan for a 30-day trial or a flexible plan subscription to an annual commitment plan with monthly or yearly payments.
  ## 
  let valid = call_579039.validator(path, query, header, formData, body)
  let scheme = call_579039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579039.url(scheme.get, call_579039.host, call_579039.base,
                         call_579039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579039, url, valid)

proc call*(call_579040: Call_ResellerSubscriptionsChangePlan_579026;
          subscriptionId: string; customerId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## resellerSubscriptionsChangePlan
  ## Update a subscription plan. Use this method to update a plan for a 30-day trial or a flexible plan subscription to an annual commitment plan with monthly or yearly payments.
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
  ##   subscriptionId: string (required)
  ##                 : This is a required property. The subscriptionId is the subscription identifier and is unique for each customer. Since a subscriptionId changes when a subscription is updated, we recommend to not use this ID as a key for persistent data. And the subscriptionId can be found using the retrieve all reseller subscriptions method.
  ##   customerId: string (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579041 = newJObject()
  var query_579042 = newJObject()
  var body_579043 = newJObject()
  add(query_579042, "key", newJString(key))
  add(query_579042, "prettyPrint", newJBool(prettyPrint))
  add(query_579042, "oauth_token", newJString(oauthToken))
  add(query_579042, "alt", newJString(alt))
  add(query_579042, "userIp", newJString(userIp))
  add(query_579042, "quotaUser", newJString(quotaUser))
  add(path_579041, "subscriptionId", newJString(subscriptionId))
  add(path_579041, "customerId", newJString(customerId))
  if body != nil:
    body_579043 = body
  add(query_579042, "fields", newJString(fields))
  result = call_579040.call(path_579041, query_579042, nil, nil, body_579043)

var resellerSubscriptionsChangePlan* = Call_ResellerSubscriptionsChangePlan_579026(
    name: "resellerSubscriptionsChangePlan", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/customers/{customerId}/subscriptions/{subscriptionId}/changePlan",
    validator: validate_ResellerSubscriptionsChangePlan_579027,
    base: "/apps/reseller/v1", url: url_ResellerSubscriptionsChangePlan_579028,
    schemes: {Scheme.Https})
type
  Call_ResellerSubscriptionsChangeRenewalSettings_579044 = ref object of OpenApiRestCall_578355
proc url_ResellerSubscriptionsChangeRenewalSettings_579046(protocol: Scheme;
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

proc validate_ResellerSubscriptionsChangeRenewalSettings_579045(path: JsonNode;
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
  var valid_579047 = path.getOrDefault("subscriptionId")
  valid_579047 = validateParameter(valid_579047, JString, required = true,
                                 default = nil)
  if valid_579047 != nil:
    section.add "subscriptionId", valid_579047
  var valid_579048 = path.getOrDefault("customerId")
  valid_579048 = validateParameter(valid_579048, JString, required = true,
                                 default = nil)
  if valid_579048 != nil:
    section.add "customerId", valid_579048
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
  var valid_579049 = query.getOrDefault("key")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "key", valid_579049
  var valid_579050 = query.getOrDefault("prettyPrint")
  valid_579050 = validateParameter(valid_579050, JBool, required = false,
                                 default = newJBool(true))
  if valid_579050 != nil:
    section.add "prettyPrint", valid_579050
  var valid_579051 = query.getOrDefault("oauth_token")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "oauth_token", valid_579051
  var valid_579052 = query.getOrDefault("alt")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = newJString("json"))
  if valid_579052 != nil:
    section.add "alt", valid_579052
  var valid_579053 = query.getOrDefault("userIp")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "userIp", valid_579053
  var valid_579054 = query.getOrDefault("quotaUser")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "quotaUser", valid_579054
  var valid_579055 = query.getOrDefault("fields")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "fields", valid_579055
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

proc call*(call_579057: Call_ResellerSubscriptionsChangeRenewalSettings_579044;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update a user license's renewal settings. This is applicable for accounts with annual commitment plans only.
  ## 
  let valid = call_579057.validator(path, query, header, formData, body)
  let scheme = call_579057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579057.url(scheme.get, call_579057.host, call_579057.base,
                         call_579057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579057, url, valid)

proc call*(call_579058: Call_ResellerSubscriptionsChangeRenewalSettings_579044;
          subscriptionId: string; customerId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## resellerSubscriptionsChangeRenewalSettings
  ## Update a user license's renewal settings. This is applicable for accounts with annual commitment plans only.
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
  ##   subscriptionId: string (required)
  ##                 : This is a required property. The subscriptionId is the subscription identifier and is unique for each customer. Since a subscriptionId changes when a subscription is updated, we recommend to not use this ID as a key for persistent data. And the subscriptionId can be found using the retrieve all reseller subscriptions method.
  ##   customerId: string (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579059 = newJObject()
  var query_579060 = newJObject()
  var body_579061 = newJObject()
  add(query_579060, "key", newJString(key))
  add(query_579060, "prettyPrint", newJBool(prettyPrint))
  add(query_579060, "oauth_token", newJString(oauthToken))
  add(query_579060, "alt", newJString(alt))
  add(query_579060, "userIp", newJString(userIp))
  add(query_579060, "quotaUser", newJString(quotaUser))
  add(path_579059, "subscriptionId", newJString(subscriptionId))
  add(path_579059, "customerId", newJString(customerId))
  if body != nil:
    body_579061 = body
  add(query_579060, "fields", newJString(fields))
  result = call_579058.call(path_579059, query_579060, nil, nil, body_579061)

var resellerSubscriptionsChangeRenewalSettings* = Call_ResellerSubscriptionsChangeRenewalSettings_579044(
    name: "resellerSubscriptionsChangeRenewalSettings", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customers/{customerId}/subscriptions/{subscriptionId}/changeRenewalSettings",
    validator: validate_ResellerSubscriptionsChangeRenewalSettings_579045,
    base: "/apps/reseller/v1",
    url: url_ResellerSubscriptionsChangeRenewalSettings_579046,
    schemes: {Scheme.Https})
type
  Call_ResellerSubscriptionsChangeSeats_579062 = ref object of OpenApiRestCall_578355
proc url_ResellerSubscriptionsChangeSeats_579064(protocol: Scheme; host: string;
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

proc validate_ResellerSubscriptionsChangeSeats_579063(path: JsonNode;
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
  var valid_579065 = path.getOrDefault("subscriptionId")
  valid_579065 = validateParameter(valid_579065, JString, required = true,
                                 default = nil)
  if valid_579065 != nil:
    section.add "subscriptionId", valid_579065
  var valid_579066 = path.getOrDefault("customerId")
  valid_579066 = validateParameter(valid_579066, JString, required = true,
                                 default = nil)
  if valid_579066 != nil:
    section.add "customerId", valid_579066
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
  var valid_579067 = query.getOrDefault("key")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "key", valid_579067
  var valid_579068 = query.getOrDefault("prettyPrint")
  valid_579068 = validateParameter(valid_579068, JBool, required = false,
                                 default = newJBool(true))
  if valid_579068 != nil:
    section.add "prettyPrint", valid_579068
  var valid_579069 = query.getOrDefault("oauth_token")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "oauth_token", valid_579069
  var valid_579070 = query.getOrDefault("alt")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = newJString("json"))
  if valid_579070 != nil:
    section.add "alt", valid_579070
  var valid_579071 = query.getOrDefault("userIp")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "userIp", valid_579071
  var valid_579072 = query.getOrDefault("quotaUser")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "quotaUser", valid_579072
  var valid_579073 = query.getOrDefault("fields")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "fields", valid_579073
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

proc call*(call_579075: Call_ResellerSubscriptionsChangeSeats_579062;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update a subscription's user license settings.
  ## 
  let valid = call_579075.validator(path, query, header, formData, body)
  let scheme = call_579075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579075.url(scheme.get, call_579075.host, call_579075.base,
                         call_579075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579075, url, valid)

proc call*(call_579076: Call_ResellerSubscriptionsChangeSeats_579062;
          subscriptionId: string; customerId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## resellerSubscriptionsChangeSeats
  ## Update a subscription's user license settings.
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
  ##   subscriptionId: string (required)
  ##                 : This is a required property. The subscriptionId is the subscription identifier and is unique for each customer. Since a subscriptionId changes when a subscription is updated, we recommend to not use this ID as a key for persistent data. And the subscriptionId can be found using the retrieve all reseller subscriptions method.
  ##   customerId: string (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579077 = newJObject()
  var query_579078 = newJObject()
  var body_579079 = newJObject()
  add(query_579078, "key", newJString(key))
  add(query_579078, "prettyPrint", newJBool(prettyPrint))
  add(query_579078, "oauth_token", newJString(oauthToken))
  add(query_579078, "alt", newJString(alt))
  add(query_579078, "userIp", newJString(userIp))
  add(query_579078, "quotaUser", newJString(quotaUser))
  add(path_579077, "subscriptionId", newJString(subscriptionId))
  add(path_579077, "customerId", newJString(customerId))
  if body != nil:
    body_579079 = body
  add(query_579078, "fields", newJString(fields))
  result = call_579076.call(path_579077, query_579078, nil, nil, body_579079)

var resellerSubscriptionsChangeSeats* = Call_ResellerSubscriptionsChangeSeats_579062(
    name: "resellerSubscriptionsChangeSeats", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customers/{customerId}/subscriptions/{subscriptionId}/changeSeats",
    validator: validate_ResellerSubscriptionsChangeSeats_579063,
    base: "/apps/reseller/v1", url: url_ResellerSubscriptionsChangeSeats_579064,
    schemes: {Scheme.Https})
type
  Call_ResellerSubscriptionsStartPaidService_579080 = ref object of OpenApiRestCall_578355
proc url_ResellerSubscriptionsStartPaidService_579082(protocol: Scheme;
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

proc validate_ResellerSubscriptionsStartPaidService_579081(path: JsonNode;
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
  var valid_579083 = path.getOrDefault("subscriptionId")
  valid_579083 = validateParameter(valid_579083, JString, required = true,
                                 default = nil)
  if valid_579083 != nil:
    section.add "subscriptionId", valid_579083
  var valid_579084 = path.getOrDefault("customerId")
  valid_579084 = validateParameter(valid_579084, JString, required = true,
                                 default = nil)
  if valid_579084 != nil:
    section.add "customerId", valid_579084
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
  var valid_579085 = query.getOrDefault("key")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "key", valid_579085
  var valid_579086 = query.getOrDefault("prettyPrint")
  valid_579086 = validateParameter(valid_579086, JBool, required = false,
                                 default = newJBool(true))
  if valid_579086 != nil:
    section.add "prettyPrint", valid_579086
  var valid_579087 = query.getOrDefault("oauth_token")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "oauth_token", valid_579087
  var valid_579088 = query.getOrDefault("alt")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = newJString("json"))
  if valid_579088 != nil:
    section.add "alt", valid_579088
  var valid_579089 = query.getOrDefault("userIp")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "userIp", valid_579089
  var valid_579090 = query.getOrDefault("quotaUser")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "quotaUser", valid_579090
  var valid_579091 = query.getOrDefault("fields")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "fields", valid_579091
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579092: Call_ResellerSubscriptionsStartPaidService_579080;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Immediately move a 30-day free trial subscription to a paid service subscription.
  ## 
  let valid = call_579092.validator(path, query, header, formData, body)
  let scheme = call_579092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579092.url(scheme.get, call_579092.host, call_579092.base,
                         call_579092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579092, url, valid)

proc call*(call_579093: Call_ResellerSubscriptionsStartPaidService_579080;
          subscriptionId: string; customerId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## resellerSubscriptionsStartPaidService
  ## Immediately move a 30-day free trial subscription to a paid service subscription.
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
  ##   subscriptionId: string (required)
  ##                 : This is a required property. The subscriptionId is the subscription identifier and is unique for each customer. Since a subscriptionId changes when a subscription is updated, we recommend to not use this ID as a key for persistent data. And the subscriptionId can be found using the retrieve all reseller subscriptions method.
  ##   customerId: string (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579094 = newJObject()
  var query_579095 = newJObject()
  add(query_579095, "key", newJString(key))
  add(query_579095, "prettyPrint", newJBool(prettyPrint))
  add(query_579095, "oauth_token", newJString(oauthToken))
  add(query_579095, "alt", newJString(alt))
  add(query_579095, "userIp", newJString(userIp))
  add(query_579095, "quotaUser", newJString(quotaUser))
  add(path_579094, "subscriptionId", newJString(subscriptionId))
  add(path_579094, "customerId", newJString(customerId))
  add(query_579095, "fields", newJString(fields))
  result = call_579093.call(path_579094, query_579095, nil, nil, nil)

var resellerSubscriptionsStartPaidService* = Call_ResellerSubscriptionsStartPaidService_579080(
    name: "resellerSubscriptionsStartPaidService", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customers/{customerId}/subscriptions/{subscriptionId}/startPaidService",
    validator: validate_ResellerSubscriptionsStartPaidService_579081,
    base: "/apps/reseller/v1", url: url_ResellerSubscriptionsStartPaidService_579082,
    schemes: {Scheme.Https})
type
  Call_ResellerSubscriptionsSuspend_579096 = ref object of OpenApiRestCall_578355
proc url_ResellerSubscriptionsSuspend_579098(protocol: Scheme; host: string;
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

proc validate_ResellerSubscriptionsSuspend_579097(path: JsonNode; query: JsonNode;
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
  var valid_579099 = path.getOrDefault("subscriptionId")
  valid_579099 = validateParameter(valid_579099, JString, required = true,
                                 default = nil)
  if valid_579099 != nil:
    section.add "subscriptionId", valid_579099
  var valid_579100 = path.getOrDefault("customerId")
  valid_579100 = validateParameter(valid_579100, JString, required = true,
                                 default = nil)
  if valid_579100 != nil:
    section.add "customerId", valid_579100
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
  var valid_579101 = query.getOrDefault("key")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "key", valid_579101
  var valid_579102 = query.getOrDefault("prettyPrint")
  valid_579102 = validateParameter(valid_579102, JBool, required = false,
                                 default = newJBool(true))
  if valid_579102 != nil:
    section.add "prettyPrint", valid_579102
  var valid_579103 = query.getOrDefault("oauth_token")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "oauth_token", valid_579103
  var valid_579104 = query.getOrDefault("alt")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = newJString("json"))
  if valid_579104 != nil:
    section.add "alt", valid_579104
  var valid_579105 = query.getOrDefault("userIp")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "userIp", valid_579105
  var valid_579106 = query.getOrDefault("quotaUser")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "quotaUser", valid_579106
  var valid_579107 = query.getOrDefault("fields")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "fields", valid_579107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579108: Call_ResellerSubscriptionsSuspend_579096; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suspends an active subscription.
  ## 
  let valid = call_579108.validator(path, query, header, formData, body)
  let scheme = call_579108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579108.url(scheme.get, call_579108.host, call_579108.base,
                         call_579108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579108, url, valid)

proc call*(call_579109: Call_ResellerSubscriptionsSuspend_579096;
          subscriptionId: string; customerId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## resellerSubscriptionsSuspend
  ## Suspends an active subscription.
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
  ##   subscriptionId: string (required)
  ##                 : This is a required property. The subscriptionId is the subscription identifier and is unique for each customer. Since a subscriptionId changes when a subscription is updated, we recommend to not use this ID as a key for persistent data. And the subscriptionId can be found using the retrieve all reseller subscriptions method.
  ##   customerId: string (required)
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579110 = newJObject()
  var query_579111 = newJObject()
  add(query_579111, "key", newJString(key))
  add(query_579111, "prettyPrint", newJBool(prettyPrint))
  add(query_579111, "oauth_token", newJString(oauthToken))
  add(query_579111, "alt", newJString(alt))
  add(query_579111, "userIp", newJString(userIp))
  add(query_579111, "quotaUser", newJString(quotaUser))
  add(path_579110, "subscriptionId", newJString(subscriptionId))
  add(path_579110, "customerId", newJString(customerId))
  add(query_579111, "fields", newJString(fields))
  result = call_579109.call(path_579110, query_579111, nil, nil, nil)

var resellerSubscriptionsSuspend* = Call_ResellerSubscriptionsSuspend_579096(
    name: "resellerSubscriptionsSuspend", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/customers/{customerId}/subscriptions/{subscriptionId}/suspend",
    validator: validate_ResellerSubscriptionsSuspend_579097,
    base: "/apps/reseller/v1", url: url_ResellerSubscriptionsSuspend_579098,
    schemes: {Scheme.Https})
type
  Call_ResellerResellernotifyGetwatchdetails_579112 = ref object of OpenApiRestCall_578355
proc url_ResellerResellernotifyGetwatchdetails_579114(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ResellerResellernotifyGetwatchdetails_579113(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns all the details of the watch corresponding to the reseller.
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
  var valid_579115 = query.getOrDefault("key")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = nil)
  if valid_579115 != nil:
    section.add "key", valid_579115
  var valid_579116 = query.getOrDefault("prettyPrint")
  valid_579116 = validateParameter(valid_579116, JBool, required = false,
                                 default = newJBool(true))
  if valid_579116 != nil:
    section.add "prettyPrint", valid_579116
  var valid_579117 = query.getOrDefault("oauth_token")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "oauth_token", valid_579117
  var valid_579118 = query.getOrDefault("alt")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = newJString("json"))
  if valid_579118 != nil:
    section.add "alt", valid_579118
  var valid_579119 = query.getOrDefault("userIp")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "userIp", valid_579119
  var valid_579120 = query.getOrDefault("quotaUser")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "quotaUser", valid_579120
  var valid_579121 = query.getOrDefault("fields")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "fields", valid_579121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579122: Call_ResellerResellernotifyGetwatchdetails_579112;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns all the details of the watch corresponding to the reseller.
  ## 
  let valid = call_579122.validator(path, query, header, formData, body)
  let scheme = call_579122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579122.url(scheme.get, call_579122.host, call_579122.base,
                         call_579122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579122, url, valid)

proc call*(call_579123: Call_ResellerResellernotifyGetwatchdetails_579112;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## resellerResellernotifyGetwatchdetails
  ## Returns all the details of the watch corresponding to the reseller.
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
  var query_579124 = newJObject()
  add(query_579124, "key", newJString(key))
  add(query_579124, "prettyPrint", newJBool(prettyPrint))
  add(query_579124, "oauth_token", newJString(oauthToken))
  add(query_579124, "alt", newJString(alt))
  add(query_579124, "userIp", newJString(userIp))
  add(query_579124, "quotaUser", newJString(quotaUser))
  add(query_579124, "fields", newJString(fields))
  result = call_579123.call(nil, query_579124, nil, nil, nil)

var resellerResellernotifyGetwatchdetails* = Call_ResellerResellernotifyGetwatchdetails_579112(
    name: "resellerResellernotifyGetwatchdetails", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/resellernotify/getwatchdetails",
    validator: validate_ResellerResellernotifyGetwatchdetails_579113,
    base: "/apps/reseller/v1", url: url_ResellerResellernotifyGetwatchdetails_579114,
    schemes: {Scheme.Https})
type
  Call_ResellerResellernotifyRegister_579125 = ref object of OpenApiRestCall_578355
proc url_ResellerResellernotifyRegister_579127(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ResellerResellernotifyRegister_579126(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Registers a Reseller for receiving notifications.
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
  ##   serviceAccountEmailAddress: JString
  ##                             : The service account which will own the created Cloud-PubSub topic.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579128 = query.getOrDefault("key")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "key", valid_579128
  var valid_579129 = query.getOrDefault("prettyPrint")
  valid_579129 = validateParameter(valid_579129, JBool, required = false,
                                 default = newJBool(true))
  if valid_579129 != nil:
    section.add "prettyPrint", valid_579129
  var valid_579130 = query.getOrDefault("oauth_token")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "oauth_token", valid_579130
  var valid_579131 = query.getOrDefault("alt")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = newJString("json"))
  if valid_579131 != nil:
    section.add "alt", valid_579131
  var valid_579132 = query.getOrDefault("userIp")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "userIp", valid_579132
  var valid_579133 = query.getOrDefault("quotaUser")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "quotaUser", valid_579133
  var valid_579134 = query.getOrDefault("serviceAccountEmailAddress")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = nil)
  if valid_579134 != nil:
    section.add "serviceAccountEmailAddress", valid_579134
  var valid_579135 = query.getOrDefault("fields")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "fields", valid_579135
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579136: Call_ResellerResellernotifyRegister_579125; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers a Reseller for receiving notifications.
  ## 
  let valid = call_579136.validator(path, query, header, formData, body)
  let scheme = call_579136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579136.url(scheme.get, call_579136.host, call_579136.base,
                         call_579136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579136, url, valid)

proc call*(call_579137: Call_ResellerResellernotifyRegister_579125;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          serviceAccountEmailAddress: string = ""; fields: string = ""): Recallable =
  ## resellerResellernotifyRegister
  ## Registers a Reseller for receiving notifications.
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
  ##   serviceAccountEmailAddress: string
  ##                             : The service account which will own the created Cloud-PubSub topic.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579138 = newJObject()
  add(query_579138, "key", newJString(key))
  add(query_579138, "prettyPrint", newJBool(prettyPrint))
  add(query_579138, "oauth_token", newJString(oauthToken))
  add(query_579138, "alt", newJString(alt))
  add(query_579138, "userIp", newJString(userIp))
  add(query_579138, "quotaUser", newJString(quotaUser))
  add(query_579138, "serviceAccountEmailAddress",
      newJString(serviceAccountEmailAddress))
  add(query_579138, "fields", newJString(fields))
  result = call_579137.call(nil, query_579138, nil, nil, nil)

var resellerResellernotifyRegister* = Call_ResellerResellernotifyRegister_579125(
    name: "resellerResellernotifyRegister", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/resellernotify/register",
    validator: validate_ResellerResellernotifyRegister_579126,
    base: "/apps/reseller/v1", url: url_ResellerResellernotifyRegister_579127,
    schemes: {Scheme.Https})
type
  Call_ResellerResellernotifyUnregister_579139 = ref object of OpenApiRestCall_578355
proc url_ResellerResellernotifyUnregister_579141(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ResellerResellernotifyUnregister_579140(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Unregisters a Reseller for receiving notifications.
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
  ##   serviceAccountEmailAddress: JString
  ##                             : The service account which owns the Cloud-PubSub topic.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579142 = query.getOrDefault("key")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "key", valid_579142
  var valid_579143 = query.getOrDefault("prettyPrint")
  valid_579143 = validateParameter(valid_579143, JBool, required = false,
                                 default = newJBool(true))
  if valid_579143 != nil:
    section.add "prettyPrint", valid_579143
  var valid_579144 = query.getOrDefault("oauth_token")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "oauth_token", valid_579144
  var valid_579145 = query.getOrDefault("alt")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = newJString("json"))
  if valid_579145 != nil:
    section.add "alt", valid_579145
  var valid_579146 = query.getOrDefault("userIp")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "userIp", valid_579146
  var valid_579147 = query.getOrDefault("quotaUser")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "quotaUser", valid_579147
  var valid_579148 = query.getOrDefault("serviceAccountEmailAddress")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "serviceAccountEmailAddress", valid_579148
  var valid_579149 = query.getOrDefault("fields")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "fields", valid_579149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579150: Call_ResellerResellernotifyUnregister_579139;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unregisters a Reseller for receiving notifications.
  ## 
  let valid = call_579150.validator(path, query, header, formData, body)
  let scheme = call_579150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579150.url(scheme.get, call_579150.host, call_579150.base,
                         call_579150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579150, url, valid)

proc call*(call_579151: Call_ResellerResellernotifyUnregister_579139;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          serviceAccountEmailAddress: string = ""; fields: string = ""): Recallable =
  ## resellerResellernotifyUnregister
  ## Unregisters a Reseller for receiving notifications.
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
  ##   serviceAccountEmailAddress: string
  ##                             : The service account which owns the Cloud-PubSub topic.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579152 = newJObject()
  add(query_579152, "key", newJString(key))
  add(query_579152, "prettyPrint", newJBool(prettyPrint))
  add(query_579152, "oauth_token", newJString(oauthToken))
  add(query_579152, "alt", newJString(alt))
  add(query_579152, "userIp", newJString(userIp))
  add(query_579152, "quotaUser", newJString(quotaUser))
  add(query_579152, "serviceAccountEmailAddress",
      newJString(serviceAccountEmailAddress))
  add(query_579152, "fields", newJString(fields))
  result = call_579151.call(nil, query_579152, nil, nil, nil)

var resellerResellernotifyUnregister* = Call_ResellerResellernotifyUnregister_579139(
    name: "resellerResellernotifyUnregister", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/resellernotify/unregister",
    validator: validate_ResellerResellernotifyUnregister_579140,
    base: "/apps/reseller/v1", url: url_ResellerResellernotifyUnregister_579141,
    schemes: {Scheme.Https})
type
  Call_ResellerSubscriptionsList_579153 = ref object of OpenApiRestCall_578355
proc url_ResellerSubscriptionsList_579155(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ResellerSubscriptionsList_579154(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List of subscriptions managed by the reseller. The list can be all subscriptions, all of a customer's subscriptions, or all of a customer's transferable subscriptions.
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
  ##   customerAuthToken: JString
  ##                    : The customerAuthToken query string is required when creating a resold account that transfers a direct customer's subscription or transfers another reseller customer's subscription to your reseller management. This is a hexadecimal authentication token needed to complete the subscription transfer. For more information, see the administrator help center.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : Token to specify next page in the list
  ##   customerNamePrefix: JString
  ##                     : When retrieving all of your subscriptions and filtering for specific customers, you can enter a prefix for a customer name. Using an example customer group that includes exam.com, example20.com and example.com:  
  ## - exa -- Returns all customer names that start with 'exa' which could include exam.com, example20.com, and example.com. A name prefix is similar to using a regular expression's asterisk, exa*. 
  ## - example -- Returns example20.com and example.com.
  ##   customerId: JString
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : When retrieving a large list, the maxResults is the maximum number of results per page. The nextPageToken value takes you to the next page. The default is 20.
  section = newJObject()
  var valid_579156 = query.getOrDefault("key")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = nil)
  if valid_579156 != nil:
    section.add "key", valid_579156
  var valid_579157 = query.getOrDefault("prettyPrint")
  valid_579157 = validateParameter(valid_579157, JBool, required = false,
                                 default = newJBool(true))
  if valid_579157 != nil:
    section.add "prettyPrint", valid_579157
  var valid_579158 = query.getOrDefault("oauth_token")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "oauth_token", valid_579158
  var valid_579159 = query.getOrDefault("customerAuthToken")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = nil)
  if valid_579159 != nil:
    section.add "customerAuthToken", valid_579159
  var valid_579160 = query.getOrDefault("alt")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = newJString("json"))
  if valid_579160 != nil:
    section.add "alt", valid_579160
  var valid_579161 = query.getOrDefault("userIp")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = nil)
  if valid_579161 != nil:
    section.add "userIp", valid_579161
  var valid_579162 = query.getOrDefault("quotaUser")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "quotaUser", valid_579162
  var valid_579163 = query.getOrDefault("pageToken")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "pageToken", valid_579163
  var valid_579164 = query.getOrDefault("customerNamePrefix")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "customerNamePrefix", valid_579164
  var valid_579165 = query.getOrDefault("customerId")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "customerId", valid_579165
  var valid_579166 = query.getOrDefault("fields")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = nil)
  if valid_579166 != nil:
    section.add "fields", valid_579166
  var valid_579167 = query.getOrDefault("maxResults")
  valid_579167 = validateParameter(valid_579167, JInt, required = false, default = nil)
  if valid_579167 != nil:
    section.add "maxResults", valid_579167
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579168: Call_ResellerSubscriptionsList_579153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List of subscriptions managed by the reseller. The list can be all subscriptions, all of a customer's subscriptions, or all of a customer's transferable subscriptions.
  ## 
  let valid = call_579168.validator(path, query, header, formData, body)
  let scheme = call_579168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579168.url(scheme.get, call_579168.host, call_579168.base,
                         call_579168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579168, url, valid)

proc call*(call_579169: Call_ResellerSubscriptionsList_579153; key: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          customerAuthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = "";
          customerNamePrefix: string = ""; customerId: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## resellerSubscriptionsList
  ## List of subscriptions managed by the reseller. The list can be all subscriptions, all of a customer's subscriptions, or all of a customer's transferable subscriptions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customerAuthToken: string
  ##                    : The customerAuthToken query string is required when creating a resold account that transfers a direct customer's subscription or transfers another reseller customer's subscription to your reseller management. This is a hexadecimal authentication token needed to complete the subscription transfer. For more information, see the administrator help center.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Token to specify next page in the list
  ##   customerNamePrefix: string
  ##                     : When retrieving all of your subscriptions and filtering for specific customers, you can enter a prefix for a customer name. Using an example customer group that includes exam.com, example20.com and example.com:  
  ## - exa -- Returns all customer names that start with 'exa' which could include exam.com, example20.com, and example.com. A name prefix is similar to using a regular expression's asterisk, exa*. 
  ## - example -- Returns example20.com and example.com.
  ##   customerId: string
  ##             : Either the customer's primary domain name or the customer's unique identifier. If using the domain name, we do not recommend using a customerId as a key for persistent data. If the domain name for a customerId is changed, the Google system automatically updates.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : When retrieving a large list, the maxResults is the maximum number of results per page. The nextPageToken value takes you to the next page. The default is 20.
  var query_579170 = newJObject()
  add(query_579170, "key", newJString(key))
  add(query_579170, "prettyPrint", newJBool(prettyPrint))
  add(query_579170, "oauth_token", newJString(oauthToken))
  add(query_579170, "customerAuthToken", newJString(customerAuthToken))
  add(query_579170, "alt", newJString(alt))
  add(query_579170, "userIp", newJString(userIp))
  add(query_579170, "quotaUser", newJString(quotaUser))
  add(query_579170, "pageToken", newJString(pageToken))
  add(query_579170, "customerNamePrefix", newJString(customerNamePrefix))
  add(query_579170, "customerId", newJString(customerId))
  add(query_579170, "fields", newJString(fields))
  add(query_579170, "maxResults", newJInt(maxResults))
  result = call_579169.call(nil, query_579170, nil, nil, nil)

var resellerSubscriptionsList* = Call_ResellerSubscriptionsList_579153(
    name: "resellerSubscriptionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/subscriptions",
    validator: validate_ResellerSubscriptionsList_579154,
    base: "/apps/reseller/v1", url: url_ResellerSubscriptionsList_579155,
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
