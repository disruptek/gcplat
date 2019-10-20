
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Content API for Shopping
## version: v2sandbox
## termsOfService: (not provided)
## license: (not provided)
## 
## Manages product items, inventory, and Merchant Center accounts for Google Shopping.
## 
## https://developers.google.com/shopping-content
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

  OpenApiRestCall_578348 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578348](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578348): Option[Scheme] {.used.} =
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
  gcpServiceName = "content"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ContentOrdersCustombatch_578618 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersCustombatch_578620(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentOrdersCustombatch_578619(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves or modifies multiple orders in a single request.
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
  var valid_578732 = query.getOrDefault("key")
  valid_578732 = validateParameter(valid_578732, JString, required = false,
                                 default = nil)
  if valid_578732 != nil:
    section.add "key", valid_578732
  var valid_578746 = query.getOrDefault("prettyPrint")
  valid_578746 = validateParameter(valid_578746, JBool, required = false,
                                 default = newJBool(true))
  if valid_578746 != nil:
    section.add "prettyPrint", valid_578746
  var valid_578747 = query.getOrDefault("oauth_token")
  valid_578747 = validateParameter(valid_578747, JString, required = false,
                                 default = nil)
  if valid_578747 != nil:
    section.add "oauth_token", valid_578747
  var valid_578748 = query.getOrDefault("alt")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = newJString("json"))
  if valid_578748 != nil:
    section.add "alt", valid_578748
  var valid_578749 = query.getOrDefault("userIp")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = nil)
  if valid_578749 != nil:
    section.add "userIp", valid_578749
  var valid_578750 = query.getOrDefault("quotaUser")
  valid_578750 = validateParameter(valid_578750, JString, required = false,
                                 default = nil)
  if valid_578750 != nil:
    section.add "quotaUser", valid_578750
  var valid_578751 = query.getOrDefault("fields")
  valid_578751 = validateParameter(valid_578751, JString, required = false,
                                 default = nil)
  if valid_578751 != nil:
    section.add "fields", valid_578751
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

proc call*(call_578775: Call_ContentOrdersCustombatch_578618; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves or modifies multiple orders in a single request.
  ## 
  let valid = call_578775.validator(path, query, header, formData, body)
  let scheme = call_578775.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578775.url(scheme.get, call_578775.host, call_578775.base,
                         call_578775.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578775, url, valid)

proc call*(call_578846: Call_ContentOrdersCustombatch_578618; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentOrdersCustombatch
  ## Retrieves or modifies multiple orders in a single request.
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
  var query_578847 = newJObject()
  var body_578849 = newJObject()
  add(query_578847, "key", newJString(key))
  add(query_578847, "prettyPrint", newJBool(prettyPrint))
  add(query_578847, "oauth_token", newJString(oauthToken))
  add(query_578847, "alt", newJString(alt))
  add(query_578847, "userIp", newJString(userIp))
  add(query_578847, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578849 = body
  add(query_578847, "fields", newJString(fields))
  result = call_578846.call(nil, query_578847, nil, nil, body_578849)

var contentOrdersCustombatch* = Call_ContentOrdersCustombatch_578618(
    name: "contentOrdersCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/orders/batch",
    validator: validate_ContentOrdersCustombatch_578619,
    base: "/content/v2sandbox", url: url_ContentOrdersCustombatch_578620,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersList_578888 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersList_578890(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersList_578889(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Lists the orders in your Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_578905 = path.getOrDefault("merchantId")
  valid_578905 = validateParameter(valid_578905, JString, required = true,
                                 default = nil)
  if valid_578905 != nil:
    section.add "merchantId", valid_578905
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
  ##   orderBy: JString
  ##          : The ordering of the returned list. The only supported value are placedDate desc and placedDate asc for now, which returns orders sorted by placement date. "placedDate desc" stands for listing orders by placement date, from oldest to most recent. "placedDate asc" stands for listing orders by placement date, from most recent to oldest. In future releases we'll support other sorting criteria.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   placedDateStart: JString
  ##                  : Obtains orders placed after this date (inclusively), in ISO 8601 format.
  ##   statuses: JArray
  ##           : Obtains orders that match any of the specified statuses. Multiple values can be specified with comma separation. Additionally, please note that active is a shortcut for pendingShipment and partiallyShipped, and completed is a shortcut for shipped , partiallyDelivered, delivered, partiallyReturned, returned, and canceled.
  ##   acknowledged: JBool
  ##               : Obtains orders that match the acknowledgement status. When set to true, obtains orders that have been acknowledged. When false, obtains orders that have not been acknowledged.
  ## We recommend using this filter set to false, in conjunction with the acknowledge call, such that only un-acknowledged orders are returned.
  ##   placedDateEnd: JString
  ##                : Obtains orders placed before this date (exclusively), in ISO 8601 format.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of orders to return in the response, used for paging. The default value is 25 orders per page, and the maximum allowed value is 250 orders per page.
  ## Known issue: All List calls will return all Orders without limit regardless of the value of this field.
  section = newJObject()
  var valid_578906 = query.getOrDefault("key")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = nil)
  if valid_578906 != nil:
    section.add "key", valid_578906
  var valid_578907 = query.getOrDefault("prettyPrint")
  valid_578907 = validateParameter(valid_578907, JBool, required = false,
                                 default = newJBool(true))
  if valid_578907 != nil:
    section.add "prettyPrint", valid_578907
  var valid_578908 = query.getOrDefault("oauth_token")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "oauth_token", valid_578908
  var valid_578909 = query.getOrDefault("alt")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = newJString("json"))
  if valid_578909 != nil:
    section.add "alt", valid_578909
  var valid_578910 = query.getOrDefault("userIp")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "userIp", valid_578910
  var valid_578911 = query.getOrDefault("quotaUser")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "quotaUser", valid_578911
  var valid_578912 = query.getOrDefault("orderBy")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = newJString("placedDate asc"))
  if valid_578912 != nil:
    section.add "orderBy", valid_578912
  var valid_578913 = query.getOrDefault("pageToken")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "pageToken", valid_578913
  var valid_578914 = query.getOrDefault("placedDateStart")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "placedDateStart", valid_578914
  var valid_578915 = query.getOrDefault("statuses")
  valid_578915 = validateParameter(valid_578915, JArray, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "statuses", valid_578915
  var valid_578916 = query.getOrDefault("acknowledged")
  valid_578916 = validateParameter(valid_578916, JBool, required = false, default = nil)
  if valid_578916 != nil:
    section.add "acknowledged", valid_578916
  var valid_578917 = query.getOrDefault("placedDateEnd")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "placedDateEnd", valid_578917
  var valid_578918 = query.getOrDefault("fields")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "fields", valid_578918
  var valid_578919 = query.getOrDefault("maxResults")
  valid_578919 = validateParameter(valid_578919, JInt, required = false, default = nil)
  if valid_578919 != nil:
    section.add "maxResults", valid_578919
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578920: Call_ContentOrdersList_578888; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the orders in your Merchant Center account.
  ## 
  let valid = call_578920.validator(path, query, header, formData, body)
  let scheme = call_578920.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578920.url(scheme.get, call_578920.host, call_578920.base,
                         call_578920.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578920, url, valid)

proc call*(call_578921: Call_ContentOrdersList_578888; merchantId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          orderBy: string = "placedDate asc"; pageToken: string = "";
          placedDateStart: string = ""; statuses: JsonNode = nil;
          acknowledged: bool = false; placedDateEnd: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## contentOrdersList
  ## Lists the orders in your Merchant Center account.
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
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderBy: string
  ##          : The ordering of the returned list. The only supported value are placedDate desc and placedDate asc for now, which returns orders sorted by placement date. "placedDate desc" stands for listing orders by placement date, from oldest to most recent. "placedDate asc" stands for listing orders by placement date, from most recent to oldest. In future releases we'll support other sorting criteria.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   placedDateStart: string
  ##                  : Obtains orders placed after this date (inclusively), in ISO 8601 format.
  ##   statuses: JArray
  ##           : Obtains orders that match any of the specified statuses. Multiple values can be specified with comma separation. Additionally, please note that active is a shortcut for pendingShipment and partiallyShipped, and completed is a shortcut for shipped , partiallyDelivered, delivered, partiallyReturned, returned, and canceled.
  ##   acknowledged: bool
  ##               : Obtains orders that match the acknowledgement status. When set to true, obtains orders that have been acknowledged. When false, obtains orders that have not been acknowledged.
  ## We recommend using this filter set to false, in conjunction with the acknowledge call, such that only un-acknowledged orders are returned.
  ##   placedDateEnd: string
  ##                : Obtains orders placed before this date (exclusively), in ISO 8601 format.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of orders to return in the response, used for paging. The default value is 25 orders per page, and the maximum allowed value is 250 orders per page.
  ## Known issue: All List calls will return all Orders without limit regardless of the value of this field.
  var path_578922 = newJObject()
  var query_578923 = newJObject()
  add(query_578923, "key", newJString(key))
  add(query_578923, "prettyPrint", newJBool(prettyPrint))
  add(query_578923, "oauth_token", newJString(oauthToken))
  add(query_578923, "alt", newJString(alt))
  add(query_578923, "userIp", newJString(userIp))
  add(query_578923, "quotaUser", newJString(quotaUser))
  add(path_578922, "merchantId", newJString(merchantId))
  add(query_578923, "orderBy", newJString(orderBy))
  add(query_578923, "pageToken", newJString(pageToken))
  add(query_578923, "placedDateStart", newJString(placedDateStart))
  if statuses != nil:
    query_578923.add "statuses", statuses
  add(query_578923, "acknowledged", newJBool(acknowledged))
  add(query_578923, "placedDateEnd", newJString(placedDateEnd))
  add(query_578923, "fields", newJString(fields))
  add(query_578923, "maxResults", newJInt(maxResults))
  result = call_578921.call(path_578922, query_578923, nil, nil, nil)

var contentOrdersList* = Call_ContentOrdersList_578888(name: "contentOrdersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/orders", validator: validate_ContentOrdersList_578889,
    base: "/content/v2sandbox", url: url_ContentOrdersList_578890,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersGet_578924 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersGet_578926(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersGet_578925(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieves an order from your Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_578927 = path.getOrDefault("merchantId")
  valid_578927 = validateParameter(valid_578927, JString, required = true,
                                 default = nil)
  if valid_578927 != nil:
    section.add "merchantId", valid_578927
  var valid_578928 = path.getOrDefault("orderId")
  valid_578928 = validateParameter(valid_578928, JString, required = true,
                                 default = nil)
  if valid_578928 != nil:
    section.add "orderId", valid_578928
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
  if body != nil:
    result.add "body", body

proc call*(call_578936: Call_ContentOrdersGet_578924; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an order from your Merchant Center account.
  ## 
  let valid = call_578936.validator(path, query, header, formData, body)
  let scheme = call_578936.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578936.url(scheme.get, call_578936.host, call_578936.base,
                         call_578936.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578936, url, valid)

proc call*(call_578937: Call_ContentOrdersGet_578924; merchantId: string;
          orderId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## contentOrdersGet
  ## Retrieves an order from your Merchant Center account.
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
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order.
  var path_578938 = newJObject()
  var query_578939 = newJObject()
  add(query_578939, "key", newJString(key))
  add(query_578939, "prettyPrint", newJBool(prettyPrint))
  add(query_578939, "oauth_token", newJString(oauthToken))
  add(query_578939, "alt", newJString(alt))
  add(query_578939, "userIp", newJString(userIp))
  add(query_578939, "quotaUser", newJString(quotaUser))
  add(path_578938, "merchantId", newJString(merchantId))
  add(query_578939, "fields", newJString(fields))
  add(path_578938, "orderId", newJString(orderId))
  result = call_578937.call(path_578938, query_578939, nil, nil, nil)

var contentOrdersGet* = Call_ContentOrdersGet_578924(name: "contentOrdersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}", validator: validate_ContentOrdersGet_578925,
    base: "/content/v2sandbox", url: url_ContentOrdersGet_578926,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersAcknowledge_578940 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersAcknowledge_578942(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/acknowledge")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersAcknowledge_578941(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Marks an order as acknowledged.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_578943 = path.getOrDefault("merchantId")
  valid_578943 = validateParameter(valid_578943, JString, required = true,
                                 default = nil)
  if valid_578943 != nil:
    section.add "merchantId", valid_578943
  var valid_578944 = path.getOrDefault("orderId")
  valid_578944 = validateParameter(valid_578944, JString, required = true,
                                 default = nil)
  if valid_578944 != nil:
    section.add "orderId", valid_578944
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
  var valid_578945 = query.getOrDefault("key")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "key", valid_578945
  var valid_578946 = query.getOrDefault("prettyPrint")
  valid_578946 = validateParameter(valid_578946, JBool, required = false,
                                 default = newJBool(true))
  if valid_578946 != nil:
    section.add "prettyPrint", valid_578946
  var valid_578947 = query.getOrDefault("oauth_token")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "oauth_token", valid_578947
  var valid_578948 = query.getOrDefault("alt")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = newJString("json"))
  if valid_578948 != nil:
    section.add "alt", valid_578948
  var valid_578949 = query.getOrDefault("userIp")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "userIp", valid_578949
  var valid_578950 = query.getOrDefault("quotaUser")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "quotaUser", valid_578950
  var valid_578951 = query.getOrDefault("fields")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "fields", valid_578951
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

proc call*(call_578953: Call_ContentOrdersAcknowledge_578940; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks an order as acknowledged.
  ## 
  let valid = call_578953.validator(path, query, header, formData, body)
  let scheme = call_578953.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578953.url(scheme.get, call_578953.host, call_578953.base,
                         call_578953.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578953, url, valid)

proc call*(call_578954: Call_ContentOrdersAcknowledge_578940; merchantId: string;
          orderId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentOrdersAcknowledge
  ## Marks an order as acknowledged.
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
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order.
  var path_578955 = newJObject()
  var query_578956 = newJObject()
  var body_578957 = newJObject()
  add(query_578956, "key", newJString(key))
  add(query_578956, "prettyPrint", newJBool(prettyPrint))
  add(query_578956, "oauth_token", newJString(oauthToken))
  add(query_578956, "alt", newJString(alt))
  add(query_578956, "userIp", newJString(userIp))
  add(query_578956, "quotaUser", newJString(quotaUser))
  add(path_578955, "merchantId", newJString(merchantId))
  if body != nil:
    body_578957 = body
  add(query_578956, "fields", newJString(fields))
  add(path_578955, "orderId", newJString(orderId))
  result = call_578954.call(path_578955, query_578956, nil, nil, body_578957)

var contentOrdersAcknowledge* = Call_ContentOrdersAcknowledge_578940(
    name: "contentOrdersAcknowledge", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/acknowledge",
    validator: validate_ContentOrdersAcknowledge_578941,
    base: "/content/v2sandbox", url: url_ContentOrdersAcknowledge_578942,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersCancel_578958 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersCancel_578960(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersCancel_578959(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Cancels all line items in an order, making a full refund.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order to cancel.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_578961 = path.getOrDefault("merchantId")
  valid_578961 = validateParameter(valid_578961, JString, required = true,
                                 default = nil)
  if valid_578961 != nil:
    section.add "merchantId", valid_578961
  var valid_578962 = path.getOrDefault("orderId")
  valid_578962 = validateParameter(valid_578962, JString, required = true,
                                 default = nil)
  if valid_578962 != nil:
    section.add "orderId", valid_578962
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
  var valid_578966 = query.getOrDefault("alt")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = newJString("json"))
  if valid_578966 != nil:
    section.add "alt", valid_578966
  var valid_578967 = query.getOrDefault("userIp")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "userIp", valid_578967
  var valid_578968 = query.getOrDefault("quotaUser")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "quotaUser", valid_578968
  var valid_578969 = query.getOrDefault("fields")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "fields", valid_578969
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

proc call*(call_578971: Call_ContentOrdersCancel_578958; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels all line items in an order, making a full refund.
  ## 
  let valid = call_578971.validator(path, query, header, formData, body)
  let scheme = call_578971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578971.url(scheme.get, call_578971.host, call_578971.base,
                         call_578971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578971, url, valid)

proc call*(call_578972: Call_ContentOrdersCancel_578958; merchantId: string;
          orderId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentOrdersCancel
  ## Cancels all line items in an order, making a full refund.
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
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order to cancel.
  var path_578973 = newJObject()
  var query_578974 = newJObject()
  var body_578975 = newJObject()
  add(query_578974, "key", newJString(key))
  add(query_578974, "prettyPrint", newJBool(prettyPrint))
  add(query_578974, "oauth_token", newJString(oauthToken))
  add(query_578974, "alt", newJString(alt))
  add(query_578974, "userIp", newJString(userIp))
  add(query_578974, "quotaUser", newJString(quotaUser))
  add(path_578973, "merchantId", newJString(merchantId))
  if body != nil:
    body_578975 = body
  add(query_578974, "fields", newJString(fields))
  add(path_578973, "orderId", newJString(orderId))
  result = call_578972.call(path_578973, query_578974, nil, nil, body_578975)

var contentOrdersCancel* = Call_ContentOrdersCancel_578958(
    name: "contentOrdersCancel", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/orders/{orderId}/cancel",
    validator: validate_ContentOrdersCancel_578959, base: "/content/v2sandbox",
    url: url_ContentOrdersCancel_578960, schemes: {Scheme.Https})
type
  Call_ContentOrdersCancellineitem_578976 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersCancellineitem_578978(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/cancelLineItem")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersCancellineitem_578977(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels a line item, making a full refund.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_578979 = path.getOrDefault("merchantId")
  valid_578979 = validateParameter(valid_578979, JString, required = true,
                                 default = nil)
  if valid_578979 != nil:
    section.add "merchantId", valid_578979
  var valid_578980 = path.getOrDefault("orderId")
  valid_578980 = validateParameter(valid_578980, JString, required = true,
                                 default = nil)
  if valid_578980 != nil:
    section.add "orderId", valid_578980
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
  var valid_578981 = query.getOrDefault("key")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "key", valid_578981
  var valid_578982 = query.getOrDefault("prettyPrint")
  valid_578982 = validateParameter(valid_578982, JBool, required = false,
                                 default = newJBool(true))
  if valid_578982 != nil:
    section.add "prettyPrint", valid_578982
  var valid_578983 = query.getOrDefault("oauth_token")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "oauth_token", valid_578983
  var valid_578984 = query.getOrDefault("alt")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = newJString("json"))
  if valid_578984 != nil:
    section.add "alt", valid_578984
  var valid_578985 = query.getOrDefault("userIp")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "userIp", valid_578985
  var valid_578986 = query.getOrDefault("quotaUser")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "quotaUser", valid_578986
  var valid_578987 = query.getOrDefault("fields")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "fields", valid_578987
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

proc call*(call_578989: Call_ContentOrdersCancellineitem_578976; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a line item, making a full refund.
  ## 
  let valid = call_578989.validator(path, query, header, formData, body)
  let scheme = call_578989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578989.url(scheme.get, call_578989.host, call_578989.base,
                         call_578989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578989, url, valid)

proc call*(call_578990: Call_ContentOrdersCancellineitem_578976;
          merchantId: string; orderId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentOrdersCancellineitem
  ## Cancels a line item, making a full refund.
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
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order.
  var path_578991 = newJObject()
  var query_578992 = newJObject()
  var body_578993 = newJObject()
  add(query_578992, "key", newJString(key))
  add(query_578992, "prettyPrint", newJBool(prettyPrint))
  add(query_578992, "oauth_token", newJString(oauthToken))
  add(query_578992, "alt", newJString(alt))
  add(query_578992, "userIp", newJString(userIp))
  add(query_578992, "quotaUser", newJString(quotaUser))
  add(path_578991, "merchantId", newJString(merchantId))
  if body != nil:
    body_578993 = body
  add(query_578992, "fields", newJString(fields))
  add(path_578991, "orderId", newJString(orderId))
  result = call_578990.call(path_578991, query_578992, nil, nil, body_578993)

var contentOrdersCancellineitem* = Call_ContentOrdersCancellineitem_578976(
    name: "contentOrdersCancellineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/cancelLineItem",
    validator: validate_ContentOrdersCancellineitem_578977,
    base: "/content/v2sandbox", url: url_ContentOrdersCancellineitem_578978,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersInstorerefundlineitem_578994 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersInstorerefundlineitem_578996(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/inStoreRefundLineItem")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersInstorerefundlineitem_578995(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Notifies that item return and refund was handled directly in store.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_578997 = path.getOrDefault("merchantId")
  valid_578997 = validateParameter(valid_578997, JString, required = true,
                                 default = nil)
  if valid_578997 != nil:
    section.add "merchantId", valid_578997
  var valid_578998 = path.getOrDefault("orderId")
  valid_578998 = validateParameter(valid_578998, JString, required = true,
                                 default = nil)
  if valid_578998 != nil:
    section.add "orderId", valid_578998
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
  var valid_578999 = query.getOrDefault("key")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "key", valid_578999
  var valid_579000 = query.getOrDefault("prettyPrint")
  valid_579000 = validateParameter(valid_579000, JBool, required = false,
                                 default = newJBool(true))
  if valid_579000 != nil:
    section.add "prettyPrint", valid_579000
  var valid_579001 = query.getOrDefault("oauth_token")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "oauth_token", valid_579001
  var valid_579002 = query.getOrDefault("alt")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = newJString("json"))
  if valid_579002 != nil:
    section.add "alt", valid_579002
  var valid_579003 = query.getOrDefault("userIp")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "userIp", valid_579003
  var valid_579004 = query.getOrDefault("quotaUser")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "quotaUser", valid_579004
  var valid_579005 = query.getOrDefault("fields")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "fields", valid_579005
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

proc call*(call_579007: Call_ContentOrdersInstorerefundlineitem_578994;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Notifies that item return and refund was handled directly in store.
  ## 
  let valid = call_579007.validator(path, query, header, formData, body)
  let scheme = call_579007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579007.url(scheme.get, call_579007.host, call_579007.base,
                         call_579007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579007, url, valid)

proc call*(call_579008: Call_ContentOrdersInstorerefundlineitem_578994;
          merchantId: string; orderId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentOrdersInstorerefundlineitem
  ## Notifies that item return and refund was handled directly in store.
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
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order.
  var path_579009 = newJObject()
  var query_579010 = newJObject()
  var body_579011 = newJObject()
  add(query_579010, "key", newJString(key))
  add(query_579010, "prettyPrint", newJBool(prettyPrint))
  add(query_579010, "oauth_token", newJString(oauthToken))
  add(query_579010, "alt", newJString(alt))
  add(query_579010, "userIp", newJString(userIp))
  add(query_579010, "quotaUser", newJString(quotaUser))
  add(path_579009, "merchantId", newJString(merchantId))
  if body != nil:
    body_579011 = body
  add(query_579010, "fields", newJString(fields))
  add(path_579009, "orderId", newJString(orderId))
  result = call_579008.call(path_579009, query_579010, nil, nil, body_579011)

var contentOrdersInstorerefundlineitem* = Call_ContentOrdersInstorerefundlineitem_578994(
    name: "contentOrdersInstorerefundlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/inStoreRefundLineItem",
    validator: validate_ContentOrdersInstorerefundlineitem_578995,
    base: "/content/v2sandbox", url: url_ContentOrdersInstorerefundlineitem_578996,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersRefund_579012 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersRefund_579014(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/refund")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersRefund_579013(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Refund a portion of the order, up to the full amount paid.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order to refund.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_579015 = path.getOrDefault("merchantId")
  valid_579015 = validateParameter(valid_579015, JString, required = true,
                                 default = nil)
  if valid_579015 != nil:
    section.add "merchantId", valid_579015
  var valid_579016 = path.getOrDefault("orderId")
  valid_579016 = validateParameter(valid_579016, JString, required = true,
                                 default = nil)
  if valid_579016 != nil:
    section.add "orderId", valid_579016
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
  var valid_579017 = query.getOrDefault("key")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "key", valid_579017
  var valid_579018 = query.getOrDefault("prettyPrint")
  valid_579018 = validateParameter(valid_579018, JBool, required = false,
                                 default = newJBool(true))
  if valid_579018 != nil:
    section.add "prettyPrint", valid_579018
  var valid_579019 = query.getOrDefault("oauth_token")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "oauth_token", valid_579019
  var valid_579020 = query.getOrDefault("alt")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = newJString("json"))
  if valid_579020 != nil:
    section.add "alt", valid_579020
  var valid_579021 = query.getOrDefault("userIp")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "userIp", valid_579021
  var valid_579022 = query.getOrDefault("quotaUser")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "quotaUser", valid_579022
  var valid_579023 = query.getOrDefault("fields")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "fields", valid_579023
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

proc call*(call_579025: Call_ContentOrdersRefund_579012; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Refund a portion of the order, up to the full amount paid.
  ## 
  let valid = call_579025.validator(path, query, header, formData, body)
  let scheme = call_579025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579025.url(scheme.get, call_579025.host, call_579025.base,
                         call_579025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579025, url, valid)

proc call*(call_579026: Call_ContentOrdersRefund_579012; merchantId: string;
          orderId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentOrdersRefund
  ## Refund a portion of the order, up to the full amount paid.
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
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order to refund.
  var path_579027 = newJObject()
  var query_579028 = newJObject()
  var body_579029 = newJObject()
  add(query_579028, "key", newJString(key))
  add(query_579028, "prettyPrint", newJBool(prettyPrint))
  add(query_579028, "oauth_token", newJString(oauthToken))
  add(query_579028, "alt", newJString(alt))
  add(query_579028, "userIp", newJString(userIp))
  add(query_579028, "quotaUser", newJString(quotaUser))
  add(path_579027, "merchantId", newJString(merchantId))
  if body != nil:
    body_579029 = body
  add(query_579028, "fields", newJString(fields))
  add(path_579027, "orderId", newJString(orderId))
  result = call_579026.call(path_579027, query_579028, nil, nil, body_579029)

var contentOrdersRefund* = Call_ContentOrdersRefund_579012(
    name: "contentOrdersRefund", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/orders/{orderId}/refund",
    validator: validate_ContentOrdersRefund_579013, base: "/content/v2sandbox",
    url: url_ContentOrdersRefund_579014, schemes: {Scheme.Https})
type
  Call_ContentOrdersRejectreturnlineitem_579030 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersRejectreturnlineitem_579032(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/rejectReturnLineItem")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersRejectreturnlineitem_579031(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rejects return on an line item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_579033 = path.getOrDefault("merchantId")
  valid_579033 = validateParameter(valid_579033, JString, required = true,
                                 default = nil)
  if valid_579033 != nil:
    section.add "merchantId", valid_579033
  var valid_579034 = path.getOrDefault("orderId")
  valid_579034 = validateParameter(valid_579034, JString, required = true,
                                 default = nil)
  if valid_579034 != nil:
    section.add "orderId", valid_579034
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
  var valid_579035 = query.getOrDefault("key")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "key", valid_579035
  var valid_579036 = query.getOrDefault("prettyPrint")
  valid_579036 = validateParameter(valid_579036, JBool, required = false,
                                 default = newJBool(true))
  if valid_579036 != nil:
    section.add "prettyPrint", valid_579036
  var valid_579037 = query.getOrDefault("oauth_token")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "oauth_token", valid_579037
  var valid_579038 = query.getOrDefault("alt")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = newJString("json"))
  if valid_579038 != nil:
    section.add "alt", valid_579038
  var valid_579039 = query.getOrDefault("userIp")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "userIp", valid_579039
  var valid_579040 = query.getOrDefault("quotaUser")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "quotaUser", valid_579040
  var valid_579041 = query.getOrDefault("fields")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "fields", valid_579041
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

proc call*(call_579043: Call_ContentOrdersRejectreturnlineitem_579030;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rejects return on an line item.
  ## 
  let valid = call_579043.validator(path, query, header, formData, body)
  let scheme = call_579043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579043.url(scheme.get, call_579043.host, call_579043.base,
                         call_579043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579043, url, valid)

proc call*(call_579044: Call_ContentOrdersRejectreturnlineitem_579030;
          merchantId: string; orderId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentOrdersRejectreturnlineitem
  ## Rejects return on an line item.
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
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order.
  var path_579045 = newJObject()
  var query_579046 = newJObject()
  var body_579047 = newJObject()
  add(query_579046, "key", newJString(key))
  add(query_579046, "prettyPrint", newJBool(prettyPrint))
  add(query_579046, "oauth_token", newJString(oauthToken))
  add(query_579046, "alt", newJString(alt))
  add(query_579046, "userIp", newJString(userIp))
  add(query_579046, "quotaUser", newJString(quotaUser))
  add(path_579045, "merchantId", newJString(merchantId))
  if body != nil:
    body_579047 = body
  add(query_579046, "fields", newJString(fields))
  add(path_579045, "orderId", newJString(orderId))
  result = call_579044.call(path_579045, query_579046, nil, nil, body_579047)

var contentOrdersRejectreturnlineitem* = Call_ContentOrdersRejectreturnlineitem_579030(
    name: "contentOrdersRejectreturnlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/rejectReturnLineItem",
    validator: validate_ContentOrdersRejectreturnlineitem_579031,
    base: "/content/v2sandbox", url: url_ContentOrdersRejectreturnlineitem_579032,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersReturnlineitem_579048 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersReturnlineitem_579050(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/returnLineItem")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersReturnlineitem_579049(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a line item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_579051 = path.getOrDefault("merchantId")
  valid_579051 = validateParameter(valid_579051, JString, required = true,
                                 default = nil)
  if valid_579051 != nil:
    section.add "merchantId", valid_579051
  var valid_579052 = path.getOrDefault("orderId")
  valid_579052 = validateParameter(valid_579052, JString, required = true,
                                 default = nil)
  if valid_579052 != nil:
    section.add "orderId", valid_579052
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
  var valid_579053 = query.getOrDefault("key")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "key", valid_579053
  var valid_579054 = query.getOrDefault("prettyPrint")
  valid_579054 = validateParameter(valid_579054, JBool, required = false,
                                 default = newJBool(true))
  if valid_579054 != nil:
    section.add "prettyPrint", valid_579054
  var valid_579055 = query.getOrDefault("oauth_token")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "oauth_token", valid_579055
  var valid_579056 = query.getOrDefault("alt")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = newJString("json"))
  if valid_579056 != nil:
    section.add "alt", valid_579056
  var valid_579057 = query.getOrDefault("userIp")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "userIp", valid_579057
  var valid_579058 = query.getOrDefault("quotaUser")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "quotaUser", valid_579058
  var valid_579059 = query.getOrDefault("fields")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "fields", valid_579059
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

proc call*(call_579061: Call_ContentOrdersReturnlineitem_579048; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a line item.
  ## 
  let valid = call_579061.validator(path, query, header, formData, body)
  let scheme = call_579061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579061.url(scheme.get, call_579061.host, call_579061.base,
                         call_579061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579061, url, valid)

proc call*(call_579062: Call_ContentOrdersReturnlineitem_579048;
          merchantId: string; orderId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentOrdersReturnlineitem
  ## Returns a line item.
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
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order.
  var path_579063 = newJObject()
  var query_579064 = newJObject()
  var body_579065 = newJObject()
  add(query_579064, "key", newJString(key))
  add(query_579064, "prettyPrint", newJBool(prettyPrint))
  add(query_579064, "oauth_token", newJString(oauthToken))
  add(query_579064, "alt", newJString(alt))
  add(query_579064, "userIp", newJString(userIp))
  add(query_579064, "quotaUser", newJString(quotaUser))
  add(path_579063, "merchantId", newJString(merchantId))
  if body != nil:
    body_579065 = body
  add(query_579064, "fields", newJString(fields))
  add(path_579063, "orderId", newJString(orderId))
  result = call_579062.call(path_579063, query_579064, nil, nil, body_579065)

var contentOrdersReturnlineitem* = Call_ContentOrdersReturnlineitem_579048(
    name: "contentOrdersReturnlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/returnLineItem",
    validator: validate_ContentOrdersReturnlineitem_579049,
    base: "/content/v2sandbox", url: url_ContentOrdersReturnlineitem_579050,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersReturnrefundlineitem_579066 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersReturnrefundlineitem_579068(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/returnRefundLineItem")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersReturnrefundlineitem_579067(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns and refunds a line item. Note that this method can only be called on fully shipped orders.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_579069 = path.getOrDefault("merchantId")
  valid_579069 = validateParameter(valid_579069, JString, required = true,
                                 default = nil)
  if valid_579069 != nil:
    section.add "merchantId", valid_579069
  var valid_579070 = path.getOrDefault("orderId")
  valid_579070 = validateParameter(valid_579070, JString, required = true,
                                 default = nil)
  if valid_579070 != nil:
    section.add "orderId", valid_579070
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
  var valid_579071 = query.getOrDefault("key")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "key", valid_579071
  var valid_579072 = query.getOrDefault("prettyPrint")
  valid_579072 = validateParameter(valid_579072, JBool, required = false,
                                 default = newJBool(true))
  if valid_579072 != nil:
    section.add "prettyPrint", valid_579072
  var valid_579073 = query.getOrDefault("oauth_token")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "oauth_token", valid_579073
  var valid_579074 = query.getOrDefault("alt")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = newJString("json"))
  if valid_579074 != nil:
    section.add "alt", valid_579074
  var valid_579075 = query.getOrDefault("userIp")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "userIp", valid_579075
  var valid_579076 = query.getOrDefault("quotaUser")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "quotaUser", valid_579076
  var valid_579077 = query.getOrDefault("fields")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "fields", valid_579077
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

proc call*(call_579079: Call_ContentOrdersReturnrefundlineitem_579066;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns and refunds a line item. Note that this method can only be called on fully shipped orders.
  ## 
  let valid = call_579079.validator(path, query, header, formData, body)
  let scheme = call_579079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579079.url(scheme.get, call_579079.host, call_579079.base,
                         call_579079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579079, url, valid)

proc call*(call_579080: Call_ContentOrdersReturnrefundlineitem_579066;
          merchantId: string; orderId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentOrdersReturnrefundlineitem
  ## Returns and refunds a line item. Note that this method can only be called on fully shipped orders.
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
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order.
  var path_579081 = newJObject()
  var query_579082 = newJObject()
  var body_579083 = newJObject()
  add(query_579082, "key", newJString(key))
  add(query_579082, "prettyPrint", newJBool(prettyPrint))
  add(query_579082, "oauth_token", newJString(oauthToken))
  add(query_579082, "alt", newJString(alt))
  add(query_579082, "userIp", newJString(userIp))
  add(query_579082, "quotaUser", newJString(quotaUser))
  add(path_579081, "merchantId", newJString(merchantId))
  if body != nil:
    body_579083 = body
  add(query_579082, "fields", newJString(fields))
  add(path_579081, "orderId", newJString(orderId))
  result = call_579080.call(path_579081, query_579082, nil, nil, body_579083)

var contentOrdersReturnrefundlineitem* = Call_ContentOrdersReturnrefundlineitem_579066(
    name: "contentOrdersReturnrefundlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/returnRefundLineItem",
    validator: validate_ContentOrdersReturnrefundlineitem_579067,
    base: "/content/v2sandbox", url: url_ContentOrdersReturnrefundlineitem_579068,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersSetlineitemmetadata_579084 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersSetlineitemmetadata_579086(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/setLineItemMetadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersSetlineitemmetadata_579085(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets (overrides) merchant provided annotations on the line item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_579087 = path.getOrDefault("merchantId")
  valid_579087 = validateParameter(valid_579087, JString, required = true,
                                 default = nil)
  if valid_579087 != nil:
    section.add "merchantId", valid_579087
  var valid_579088 = path.getOrDefault("orderId")
  valid_579088 = validateParameter(valid_579088, JString, required = true,
                                 default = nil)
  if valid_579088 != nil:
    section.add "orderId", valid_579088
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
  var valid_579089 = query.getOrDefault("key")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "key", valid_579089
  var valid_579090 = query.getOrDefault("prettyPrint")
  valid_579090 = validateParameter(valid_579090, JBool, required = false,
                                 default = newJBool(true))
  if valid_579090 != nil:
    section.add "prettyPrint", valid_579090
  var valid_579091 = query.getOrDefault("oauth_token")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "oauth_token", valid_579091
  var valid_579092 = query.getOrDefault("alt")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = newJString("json"))
  if valid_579092 != nil:
    section.add "alt", valid_579092
  var valid_579093 = query.getOrDefault("userIp")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "userIp", valid_579093
  var valid_579094 = query.getOrDefault("quotaUser")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "quotaUser", valid_579094
  var valid_579095 = query.getOrDefault("fields")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "fields", valid_579095
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

proc call*(call_579097: Call_ContentOrdersSetlineitemmetadata_579084;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets (overrides) merchant provided annotations on the line item.
  ## 
  let valid = call_579097.validator(path, query, header, formData, body)
  let scheme = call_579097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579097.url(scheme.get, call_579097.host, call_579097.base,
                         call_579097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579097, url, valid)

proc call*(call_579098: Call_ContentOrdersSetlineitemmetadata_579084;
          merchantId: string; orderId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentOrdersSetlineitemmetadata
  ## Sets (overrides) merchant provided annotations on the line item.
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
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order.
  var path_579099 = newJObject()
  var query_579100 = newJObject()
  var body_579101 = newJObject()
  add(query_579100, "key", newJString(key))
  add(query_579100, "prettyPrint", newJBool(prettyPrint))
  add(query_579100, "oauth_token", newJString(oauthToken))
  add(query_579100, "alt", newJString(alt))
  add(query_579100, "userIp", newJString(userIp))
  add(query_579100, "quotaUser", newJString(quotaUser))
  add(path_579099, "merchantId", newJString(merchantId))
  if body != nil:
    body_579101 = body
  add(query_579100, "fields", newJString(fields))
  add(path_579099, "orderId", newJString(orderId))
  result = call_579098.call(path_579099, query_579100, nil, nil, body_579101)

var contentOrdersSetlineitemmetadata* = Call_ContentOrdersSetlineitemmetadata_579084(
    name: "contentOrdersSetlineitemmetadata", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/setLineItemMetadata",
    validator: validate_ContentOrdersSetlineitemmetadata_579085,
    base: "/content/v2sandbox", url: url_ContentOrdersSetlineitemmetadata_579086,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersShiplineitems_579102 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersShiplineitems_579104(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/shipLineItems")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersShiplineitems_579103(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Marks line item(s) as shipped.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_579105 = path.getOrDefault("merchantId")
  valid_579105 = validateParameter(valid_579105, JString, required = true,
                                 default = nil)
  if valid_579105 != nil:
    section.add "merchantId", valid_579105
  var valid_579106 = path.getOrDefault("orderId")
  valid_579106 = validateParameter(valid_579106, JString, required = true,
                                 default = nil)
  if valid_579106 != nil:
    section.add "orderId", valid_579106
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
  var valid_579107 = query.getOrDefault("key")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "key", valid_579107
  var valid_579108 = query.getOrDefault("prettyPrint")
  valid_579108 = validateParameter(valid_579108, JBool, required = false,
                                 default = newJBool(true))
  if valid_579108 != nil:
    section.add "prettyPrint", valid_579108
  var valid_579109 = query.getOrDefault("oauth_token")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "oauth_token", valid_579109
  var valid_579110 = query.getOrDefault("alt")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = newJString("json"))
  if valid_579110 != nil:
    section.add "alt", valid_579110
  var valid_579111 = query.getOrDefault("userIp")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "userIp", valid_579111
  var valid_579112 = query.getOrDefault("quotaUser")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "quotaUser", valid_579112
  var valid_579113 = query.getOrDefault("fields")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "fields", valid_579113
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

proc call*(call_579115: Call_ContentOrdersShiplineitems_579102; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks line item(s) as shipped.
  ## 
  let valid = call_579115.validator(path, query, header, formData, body)
  let scheme = call_579115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579115.url(scheme.get, call_579115.host, call_579115.base,
                         call_579115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579115, url, valid)

proc call*(call_579116: Call_ContentOrdersShiplineitems_579102; merchantId: string;
          orderId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentOrdersShiplineitems
  ## Marks line item(s) as shipped.
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
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order.
  var path_579117 = newJObject()
  var query_579118 = newJObject()
  var body_579119 = newJObject()
  add(query_579118, "key", newJString(key))
  add(query_579118, "prettyPrint", newJBool(prettyPrint))
  add(query_579118, "oauth_token", newJString(oauthToken))
  add(query_579118, "alt", newJString(alt))
  add(query_579118, "userIp", newJString(userIp))
  add(query_579118, "quotaUser", newJString(quotaUser))
  add(path_579117, "merchantId", newJString(merchantId))
  if body != nil:
    body_579119 = body
  add(query_579118, "fields", newJString(fields))
  add(path_579117, "orderId", newJString(orderId))
  result = call_579116.call(path_579117, query_579118, nil, nil, body_579119)

var contentOrdersShiplineitems* = Call_ContentOrdersShiplineitems_579102(
    name: "contentOrdersShiplineitems", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/shipLineItems",
    validator: validate_ContentOrdersShiplineitems_579103,
    base: "/content/v2sandbox", url: url_ContentOrdersShiplineitems_579104,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdatelineitemshippingdetails_579120 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersUpdatelineitemshippingdetails_579122(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/updateLineItemShippingDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersUpdatelineitemshippingdetails_579121(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates ship by and delivery by dates for a line item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_579123 = path.getOrDefault("merchantId")
  valid_579123 = validateParameter(valid_579123, JString, required = true,
                                 default = nil)
  if valid_579123 != nil:
    section.add "merchantId", valid_579123
  var valid_579124 = path.getOrDefault("orderId")
  valid_579124 = validateParameter(valid_579124, JString, required = true,
                                 default = nil)
  if valid_579124 != nil:
    section.add "orderId", valid_579124
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
  var valid_579128 = query.getOrDefault("alt")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = newJString("json"))
  if valid_579128 != nil:
    section.add "alt", valid_579128
  var valid_579129 = query.getOrDefault("userIp")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "userIp", valid_579129
  var valid_579130 = query.getOrDefault("quotaUser")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "quotaUser", valid_579130
  var valid_579131 = query.getOrDefault("fields")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "fields", valid_579131
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

proc call*(call_579133: Call_ContentOrdersUpdatelineitemshippingdetails_579120;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates ship by and delivery by dates for a line item.
  ## 
  let valid = call_579133.validator(path, query, header, formData, body)
  let scheme = call_579133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579133.url(scheme.get, call_579133.host, call_579133.base,
                         call_579133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579133, url, valid)

proc call*(call_579134: Call_ContentOrdersUpdatelineitemshippingdetails_579120;
          merchantId: string; orderId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentOrdersUpdatelineitemshippingdetails
  ## Updates ship by and delivery by dates for a line item.
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
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order.
  var path_579135 = newJObject()
  var query_579136 = newJObject()
  var body_579137 = newJObject()
  add(query_579136, "key", newJString(key))
  add(query_579136, "prettyPrint", newJBool(prettyPrint))
  add(query_579136, "oauth_token", newJString(oauthToken))
  add(query_579136, "alt", newJString(alt))
  add(query_579136, "userIp", newJString(userIp))
  add(query_579136, "quotaUser", newJString(quotaUser))
  add(path_579135, "merchantId", newJString(merchantId))
  if body != nil:
    body_579137 = body
  add(query_579136, "fields", newJString(fields))
  add(path_579135, "orderId", newJString(orderId))
  result = call_579134.call(path_579135, query_579136, nil, nil, body_579137)

var contentOrdersUpdatelineitemshippingdetails* = Call_ContentOrdersUpdatelineitemshippingdetails_579120(
    name: "contentOrdersUpdatelineitemshippingdetails", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateLineItemShippingDetails",
    validator: validate_ContentOrdersUpdatelineitemshippingdetails_579121,
    base: "/content/v2sandbox",
    url: url_ContentOrdersUpdatelineitemshippingdetails_579122,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdatemerchantorderid_579138 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersUpdatemerchantorderid_579140(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/updateMerchantOrderId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersUpdatemerchantorderid_579139(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the merchant order ID for a given order.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_579141 = path.getOrDefault("merchantId")
  valid_579141 = validateParameter(valid_579141, JString, required = true,
                                 default = nil)
  if valid_579141 != nil:
    section.add "merchantId", valid_579141
  var valid_579142 = path.getOrDefault("orderId")
  valid_579142 = validateParameter(valid_579142, JString, required = true,
                                 default = nil)
  if valid_579142 != nil:
    section.add "orderId", valid_579142
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
  var valid_579143 = query.getOrDefault("key")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "key", valid_579143
  var valid_579144 = query.getOrDefault("prettyPrint")
  valid_579144 = validateParameter(valid_579144, JBool, required = false,
                                 default = newJBool(true))
  if valid_579144 != nil:
    section.add "prettyPrint", valid_579144
  var valid_579145 = query.getOrDefault("oauth_token")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "oauth_token", valid_579145
  var valid_579146 = query.getOrDefault("alt")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = newJString("json"))
  if valid_579146 != nil:
    section.add "alt", valid_579146
  var valid_579147 = query.getOrDefault("userIp")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "userIp", valid_579147
  var valid_579148 = query.getOrDefault("quotaUser")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "quotaUser", valid_579148
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579151: Call_ContentOrdersUpdatemerchantorderid_579138;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the merchant order ID for a given order.
  ## 
  let valid = call_579151.validator(path, query, header, formData, body)
  let scheme = call_579151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579151.url(scheme.get, call_579151.host, call_579151.base,
                         call_579151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579151, url, valid)

proc call*(call_579152: Call_ContentOrdersUpdatemerchantorderid_579138;
          merchantId: string; orderId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentOrdersUpdatemerchantorderid
  ## Updates the merchant order ID for a given order.
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
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order.
  var path_579153 = newJObject()
  var query_579154 = newJObject()
  var body_579155 = newJObject()
  add(query_579154, "key", newJString(key))
  add(query_579154, "prettyPrint", newJBool(prettyPrint))
  add(query_579154, "oauth_token", newJString(oauthToken))
  add(query_579154, "alt", newJString(alt))
  add(query_579154, "userIp", newJString(userIp))
  add(query_579154, "quotaUser", newJString(quotaUser))
  add(path_579153, "merchantId", newJString(merchantId))
  if body != nil:
    body_579155 = body
  add(query_579154, "fields", newJString(fields))
  add(path_579153, "orderId", newJString(orderId))
  result = call_579152.call(path_579153, query_579154, nil, nil, body_579155)

var contentOrdersUpdatemerchantorderid* = Call_ContentOrdersUpdatemerchantorderid_579138(
    name: "contentOrdersUpdatemerchantorderid", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateMerchantOrderId",
    validator: validate_ContentOrdersUpdatemerchantorderid_579139,
    base: "/content/v2sandbox", url: url_ContentOrdersUpdatemerchantorderid_579140,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdateshipment_579156 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersUpdateshipment_579158(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/updateShipment")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersUpdateshipment_579157(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a shipment's status, carrier, and/or tracking ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_579159 = path.getOrDefault("merchantId")
  valid_579159 = validateParameter(valid_579159, JString, required = true,
                                 default = nil)
  if valid_579159 != nil:
    section.add "merchantId", valid_579159
  var valid_579160 = path.getOrDefault("orderId")
  valid_579160 = validateParameter(valid_579160, JString, required = true,
                                 default = nil)
  if valid_579160 != nil:
    section.add "orderId", valid_579160
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
  var valid_579161 = query.getOrDefault("key")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = nil)
  if valid_579161 != nil:
    section.add "key", valid_579161
  var valid_579162 = query.getOrDefault("prettyPrint")
  valid_579162 = validateParameter(valid_579162, JBool, required = false,
                                 default = newJBool(true))
  if valid_579162 != nil:
    section.add "prettyPrint", valid_579162
  var valid_579163 = query.getOrDefault("oauth_token")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "oauth_token", valid_579163
  var valid_579164 = query.getOrDefault("alt")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = newJString("json"))
  if valid_579164 != nil:
    section.add "alt", valid_579164
  var valid_579165 = query.getOrDefault("userIp")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "userIp", valid_579165
  var valid_579166 = query.getOrDefault("quotaUser")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = nil)
  if valid_579166 != nil:
    section.add "quotaUser", valid_579166
  var valid_579167 = query.getOrDefault("fields")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = nil)
  if valid_579167 != nil:
    section.add "fields", valid_579167
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

proc call*(call_579169: Call_ContentOrdersUpdateshipment_579156; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a shipment's status, carrier, and/or tracking ID.
  ## 
  let valid = call_579169.validator(path, query, header, formData, body)
  let scheme = call_579169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579169.url(scheme.get, call_579169.host, call_579169.base,
                         call_579169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579169, url, valid)

proc call*(call_579170: Call_ContentOrdersUpdateshipment_579156;
          merchantId: string; orderId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentOrdersUpdateshipment
  ## Updates a shipment's status, carrier, and/or tracking ID.
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
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order.
  var path_579171 = newJObject()
  var query_579172 = newJObject()
  var body_579173 = newJObject()
  add(query_579172, "key", newJString(key))
  add(query_579172, "prettyPrint", newJBool(prettyPrint))
  add(query_579172, "oauth_token", newJString(oauthToken))
  add(query_579172, "alt", newJString(alt))
  add(query_579172, "userIp", newJString(userIp))
  add(query_579172, "quotaUser", newJString(quotaUser))
  add(path_579171, "merchantId", newJString(merchantId))
  if body != nil:
    body_579173 = body
  add(query_579172, "fields", newJString(fields))
  add(path_579171, "orderId", newJString(orderId))
  result = call_579170.call(path_579171, query_579172, nil, nil, body_579173)

var contentOrdersUpdateshipment* = Call_ContentOrdersUpdateshipment_579156(
    name: "contentOrdersUpdateshipment", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateShipment",
    validator: validate_ContentOrdersUpdateshipment_579157,
    base: "/content/v2sandbox", url: url_ContentOrdersUpdateshipment_579158,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersGetbymerchantorderid_579174 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersGetbymerchantorderid_579176(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "merchantOrderId" in path, "`merchantOrderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/ordersbymerchantid/"),
               (kind: VariableSegment, value: "merchantOrderId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersGetbymerchantorderid_579175(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves an order using merchant order id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantOrderId: JString (required)
  ##                  : The merchant order id to be looked for.
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantOrderId` field"
  var valid_579177 = path.getOrDefault("merchantOrderId")
  valid_579177 = validateParameter(valid_579177, JString, required = true,
                                 default = nil)
  if valid_579177 != nil:
    section.add "merchantOrderId", valid_579177
  var valid_579178 = path.getOrDefault("merchantId")
  valid_579178 = validateParameter(valid_579178, JString, required = true,
                                 default = nil)
  if valid_579178 != nil:
    section.add "merchantId", valid_579178
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
  var valid_579179 = query.getOrDefault("key")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "key", valid_579179
  var valid_579180 = query.getOrDefault("prettyPrint")
  valid_579180 = validateParameter(valid_579180, JBool, required = false,
                                 default = newJBool(true))
  if valid_579180 != nil:
    section.add "prettyPrint", valid_579180
  var valid_579181 = query.getOrDefault("oauth_token")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "oauth_token", valid_579181
  var valid_579182 = query.getOrDefault("alt")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = newJString("json"))
  if valid_579182 != nil:
    section.add "alt", valid_579182
  var valid_579183 = query.getOrDefault("userIp")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "userIp", valid_579183
  var valid_579184 = query.getOrDefault("quotaUser")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = nil)
  if valid_579184 != nil:
    section.add "quotaUser", valid_579184
  var valid_579185 = query.getOrDefault("fields")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "fields", valid_579185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579186: Call_ContentOrdersGetbymerchantorderid_579174;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves an order using merchant order id.
  ## 
  let valid = call_579186.validator(path, query, header, formData, body)
  let scheme = call_579186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579186.url(scheme.get, call_579186.host, call_579186.base,
                         call_579186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579186, url, valid)

proc call*(call_579187: Call_ContentOrdersGetbymerchantorderid_579174;
          merchantOrderId: string; merchantId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## contentOrdersGetbymerchantorderid
  ## Retrieves an order using merchant order id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   merchantOrderId: string (required)
  ##                  : The merchant order id to be looked for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579188 = newJObject()
  var query_579189 = newJObject()
  add(query_579189, "key", newJString(key))
  add(query_579189, "prettyPrint", newJBool(prettyPrint))
  add(query_579189, "oauth_token", newJString(oauthToken))
  add(path_579188, "merchantOrderId", newJString(merchantOrderId))
  add(query_579189, "alt", newJString(alt))
  add(query_579189, "userIp", newJString(userIp))
  add(query_579189, "quotaUser", newJString(quotaUser))
  add(path_579188, "merchantId", newJString(merchantId))
  add(query_579189, "fields", newJString(fields))
  result = call_579187.call(path_579188, query_579189, nil, nil, nil)

var contentOrdersGetbymerchantorderid* = Call_ContentOrdersGetbymerchantorderid_579174(
    name: "contentOrdersGetbymerchantorderid", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/ordersbymerchantid/{merchantOrderId}",
    validator: validate_ContentOrdersGetbymerchantorderid_579175,
    base: "/content/v2sandbox", url: url_ContentOrdersGetbymerchantorderid_579176,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersCreatetestorder_579190 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersCreatetestorder_579192(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/testorders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersCreatetestorder_579191(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sandbox only. Creates a test order.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that should manage the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_579193 = path.getOrDefault("merchantId")
  valid_579193 = validateParameter(valid_579193, JString, required = true,
                                 default = nil)
  if valid_579193 != nil:
    section.add "merchantId", valid_579193
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
  var valid_579194 = query.getOrDefault("key")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "key", valid_579194
  var valid_579195 = query.getOrDefault("prettyPrint")
  valid_579195 = validateParameter(valid_579195, JBool, required = false,
                                 default = newJBool(true))
  if valid_579195 != nil:
    section.add "prettyPrint", valid_579195
  var valid_579196 = query.getOrDefault("oauth_token")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "oauth_token", valid_579196
  var valid_579197 = query.getOrDefault("alt")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = newJString("json"))
  if valid_579197 != nil:
    section.add "alt", valid_579197
  var valid_579198 = query.getOrDefault("userIp")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "userIp", valid_579198
  var valid_579199 = query.getOrDefault("quotaUser")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "quotaUser", valid_579199
  var valid_579200 = query.getOrDefault("fields")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = nil)
  if valid_579200 != nil:
    section.add "fields", valid_579200
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

proc call*(call_579202: Call_ContentOrdersCreatetestorder_579190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Creates a test order.
  ## 
  let valid = call_579202.validator(path, query, header, formData, body)
  let scheme = call_579202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579202.url(scheme.get, call_579202.host, call_579202.base,
                         call_579202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579202, url, valid)

proc call*(call_579203: Call_ContentOrdersCreatetestorder_579190;
          merchantId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentOrdersCreatetestorder
  ## Sandbox only. Creates a test order.
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
  ##   merchantId: string (required)
  ##             : The ID of the account that should manage the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579204 = newJObject()
  var query_579205 = newJObject()
  var body_579206 = newJObject()
  add(query_579205, "key", newJString(key))
  add(query_579205, "prettyPrint", newJBool(prettyPrint))
  add(query_579205, "oauth_token", newJString(oauthToken))
  add(query_579205, "alt", newJString(alt))
  add(query_579205, "userIp", newJString(userIp))
  add(query_579205, "quotaUser", newJString(quotaUser))
  add(path_579204, "merchantId", newJString(merchantId))
  if body != nil:
    body_579206 = body
  add(query_579205, "fields", newJString(fields))
  result = call_579203.call(path_579204, query_579205, nil, nil, body_579206)

var contentOrdersCreatetestorder* = Call_ContentOrdersCreatetestorder_579190(
    name: "contentOrdersCreatetestorder", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/testorders",
    validator: validate_ContentOrdersCreatetestorder_579191,
    base: "/content/v2sandbox", url: url_ContentOrdersCreatetestorder_579192,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersAdvancetestorder_579207 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersAdvancetestorder_579209(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/testorders/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/advance")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersAdvancetestorder_579208(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sandbox only. Moves a test order from state "inProgress" to state "pendingShipment".
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the test order to modify.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_579210 = path.getOrDefault("merchantId")
  valid_579210 = validateParameter(valid_579210, JString, required = true,
                                 default = nil)
  if valid_579210 != nil:
    section.add "merchantId", valid_579210
  var valid_579211 = path.getOrDefault("orderId")
  valid_579211 = validateParameter(valid_579211, JString, required = true,
                                 default = nil)
  if valid_579211 != nil:
    section.add "orderId", valid_579211
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
  var valid_579212 = query.getOrDefault("key")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = nil)
  if valid_579212 != nil:
    section.add "key", valid_579212
  var valid_579213 = query.getOrDefault("prettyPrint")
  valid_579213 = validateParameter(valid_579213, JBool, required = false,
                                 default = newJBool(true))
  if valid_579213 != nil:
    section.add "prettyPrint", valid_579213
  var valid_579214 = query.getOrDefault("oauth_token")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = nil)
  if valid_579214 != nil:
    section.add "oauth_token", valid_579214
  var valid_579215 = query.getOrDefault("alt")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = newJString("json"))
  if valid_579215 != nil:
    section.add "alt", valid_579215
  var valid_579216 = query.getOrDefault("userIp")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = nil)
  if valid_579216 != nil:
    section.add "userIp", valid_579216
  var valid_579217 = query.getOrDefault("quotaUser")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "quotaUser", valid_579217
  var valid_579218 = query.getOrDefault("fields")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "fields", valid_579218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579219: Call_ContentOrdersAdvancetestorder_579207; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Moves a test order from state "inProgress" to state "pendingShipment".
  ## 
  let valid = call_579219.validator(path, query, header, formData, body)
  let scheme = call_579219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579219.url(scheme.get, call_579219.host, call_579219.base,
                         call_579219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579219, url, valid)

proc call*(call_579220: Call_ContentOrdersAdvancetestorder_579207;
          merchantId: string; orderId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## contentOrdersAdvancetestorder
  ## Sandbox only. Moves a test order from state "inProgress" to state "pendingShipment".
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
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the test order to modify.
  var path_579221 = newJObject()
  var query_579222 = newJObject()
  add(query_579222, "key", newJString(key))
  add(query_579222, "prettyPrint", newJBool(prettyPrint))
  add(query_579222, "oauth_token", newJString(oauthToken))
  add(query_579222, "alt", newJString(alt))
  add(query_579222, "userIp", newJString(userIp))
  add(query_579222, "quotaUser", newJString(quotaUser))
  add(path_579221, "merchantId", newJString(merchantId))
  add(query_579222, "fields", newJString(fields))
  add(path_579221, "orderId", newJString(orderId))
  result = call_579220.call(path_579221, query_579222, nil, nil, nil)

var contentOrdersAdvancetestorder* = Call_ContentOrdersAdvancetestorder_579207(
    name: "contentOrdersAdvancetestorder", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/testorders/{orderId}/advance",
    validator: validate_ContentOrdersAdvancetestorder_579208,
    base: "/content/v2sandbox", url: url_ContentOrdersAdvancetestorder_579209,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersGettestordertemplate_579223 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersGettestordertemplate_579225(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "templateName" in path, "`templateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/testordertemplates/"),
               (kind: VariableSegment, value: "templateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersGettestordertemplate_579224(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sandbox only. Retrieves an order template that can be used to quickly create a new order in sandbox.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that should manage the order. This cannot be a multi-client account.
  ##   templateName: JString (required)
  ##               : The name of the template to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_579226 = path.getOrDefault("merchantId")
  valid_579226 = validateParameter(valid_579226, JString, required = true,
                                 default = nil)
  if valid_579226 != nil:
    section.add "merchantId", valid_579226
  var valid_579227 = path.getOrDefault("templateName")
  valid_579227 = validateParameter(valid_579227, JString, required = true,
                                 default = newJString("template1"))
  if valid_579227 != nil:
    section.add "templateName", valid_579227
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
  if body != nil:
    result.add "body", body

proc call*(call_579235: Call_ContentOrdersGettestordertemplate_579223;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sandbox only. Retrieves an order template that can be used to quickly create a new order in sandbox.
  ## 
  let valid = call_579235.validator(path, query, header, formData, body)
  let scheme = call_579235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579235.url(scheme.get, call_579235.host, call_579235.base,
                         call_579235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579235, url, valid)

proc call*(call_579236: Call_ContentOrdersGettestordertemplate_579223;
          merchantId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; templateName: string = "template1";
          fields: string = ""): Recallable =
  ## contentOrdersGettestordertemplate
  ## Sandbox only. Retrieves an order template that can be used to quickly create a new order in sandbox.
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
  ##   merchantId: string (required)
  ##             : The ID of the account that should manage the order. This cannot be a multi-client account.
  ##   templateName: string (required)
  ##               : The name of the template to retrieve.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579237 = newJObject()
  var query_579238 = newJObject()
  add(query_579238, "key", newJString(key))
  add(query_579238, "prettyPrint", newJBool(prettyPrint))
  add(query_579238, "oauth_token", newJString(oauthToken))
  add(query_579238, "alt", newJString(alt))
  add(query_579238, "userIp", newJString(userIp))
  add(query_579238, "quotaUser", newJString(quotaUser))
  add(path_579237, "merchantId", newJString(merchantId))
  add(path_579237, "templateName", newJString(templateName))
  add(query_579238, "fields", newJString(fields))
  result = call_579236.call(path_579237, query_579238, nil, nil, nil)

var contentOrdersGettestordertemplate* = Call_ContentOrdersGettestordertemplate_579223(
    name: "contentOrdersGettestordertemplate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/testordertemplates/{templateName}",
    validator: validate_ContentOrdersGettestordertemplate_579224,
    base: "/content/v2sandbox", url: url_ContentOrdersGettestordertemplate_579225,
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
