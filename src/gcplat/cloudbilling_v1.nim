
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Billing
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Allows developers to manage billing for their Google Cloud Platform projects
##     programmatically.
## 
## https://cloud.google.com/billing/
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

  OpenApiRestCall_579364 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579364](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579364): Option[Scheme] {.used.} =
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
  gcpServiceName = "cloudbilling"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudbillingBillingAccountsCreate_579910 = ref object of OpenApiRestCall_579364
proc url_CloudbillingBillingAccountsCreate_579912(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CloudbillingBillingAccountsCreate_579911(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a billing account.
  ## This method can only be used to create
  ## [billing subaccounts](https://cloud.google.com/billing/docs/concepts)
  ## by GCP resellers.
  ## When creating a subaccount, the current authenticated user must have the
  ## `billing.accounts.update` IAM permission on the master account, which is
  ## typically given to billing account
  ## [administrators](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## This method will return an error if the master account has not been
  ## provisioned as a reseller account.
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
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579913 = query.getOrDefault("key")
  valid_579913 = validateParameter(valid_579913, JString, required = false,
                                 default = nil)
  if valid_579913 != nil:
    section.add "key", valid_579913
  var valid_579914 = query.getOrDefault("prettyPrint")
  valid_579914 = validateParameter(valid_579914, JBool, required = false,
                                 default = newJBool(true))
  if valid_579914 != nil:
    section.add "prettyPrint", valid_579914
  var valid_579915 = query.getOrDefault("oauth_token")
  valid_579915 = validateParameter(valid_579915, JString, required = false,
                                 default = nil)
  if valid_579915 != nil:
    section.add "oauth_token", valid_579915
  var valid_579916 = query.getOrDefault("$.xgafv")
  valid_579916 = validateParameter(valid_579916, JString, required = false,
                                 default = newJString("1"))
  if valid_579916 != nil:
    section.add "$.xgafv", valid_579916
  var valid_579917 = query.getOrDefault("alt")
  valid_579917 = validateParameter(valid_579917, JString, required = false,
                                 default = newJString("json"))
  if valid_579917 != nil:
    section.add "alt", valid_579917
  var valid_579918 = query.getOrDefault("uploadType")
  valid_579918 = validateParameter(valid_579918, JString, required = false,
                                 default = nil)
  if valid_579918 != nil:
    section.add "uploadType", valid_579918
  var valid_579919 = query.getOrDefault("quotaUser")
  valid_579919 = validateParameter(valid_579919, JString, required = false,
                                 default = nil)
  if valid_579919 != nil:
    section.add "quotaUser", valid_579919
  var valid_579920 = query.getOrDefault("callback")
  valid_579920 = validateParameter(valid_579920, JString, required = false,
                                 default = nil)
  if valid_579920 != nil:
    section.add "callback", valid_579920
  var valid_579921 = query.getOrDefault("fields")
  valid_579921 = validateParameter(valid_579921, JString, required = false,
                                 default = nil)
  if valid_579921 != nil:
    section.add "fields", valid_579921
  var valid_579922 = query.getOrDefault("access_token")
  valid_579922 = validateParameter(valid_579922, JString, required = false,
                                 default = nil)
  if valid_579922 != nil:
    section.add "access_token", valid_579922
  var valid_579923 = query.getOrDefault("upload_protocol")
  valid_579923 = validateParameter(valid_579923, JString, required = false,
                                 default = nil)
  if valid_579923 != nil:
    section.add "upload_protocol", valid_579923
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

proc call*(call_579925: Call_CloudbillingBillingAccountsCreate_579910;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a billing account.
  ## This method can only be used to create
  ## [billing subaccounts](https://cloud.google.com/billing/docs/concepts)
  ## by GCP resellers.
  ## When creating a subaccount, the current authenticated user must have the
  ## `billing.accounts.update` IAM permission on the master account, which is
  ## typically given to billing account
  ## [administrators](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## This method will return an error if the master account has not been
  ## provisioned as a reseller account.
  ## 
  let valid = call_579925.validator(path, query, header, formData, body)
  let scheme = call_579925.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579925.url(scheme.get, call_579925.host, call_579925.base,
                         call_579925.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579925, url, valid)

proc call*(call_579926: Call_CloudbillingBillingAccountsCreate_579910;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudbillingBillingAccountsCreate
  ## Creates a billing account.
  ## This method can only be used to create
  ## [billing subaccounts](https://cloud.google.com/billing/docs/concepts)
  ## by GCP resellers.
  ## When creating a subaccount, the current authenticated user must have the
  ## `billing.accounts.update` IAM permission on the master account, which is
  ## typically given to billing account
  ## [administrators](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## This method will return an error if the master account has not been
  ## provisioned as a reseller account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579927 = newJObject()
  var body_579928 = newJObject()
  add(query_579927, "key", newJString(key))
  add(query_579927, "prettyPrint", newJBool(prettyPrint))
  add(query_579927, "oauth_token", newJString(oauthToken))
  add(query_579927, "$.xgafv", newJString(Xgafv))
  add(query_579927, "alt", newJString(alt))
  add(query_579927, "uploadType", newJString(uploadType))
  add(query_579927, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579928 = body
  add(query_579927, "callback", newJString(callback))
  add(query_579927, "fields", newJString(fields))
  add(query_579927, "access_token", newJString(accessToken))
  add(query_579927, "upload_protocol", newJString(uploadProtocol))
  result = call_579926.call(nil, query_579927, nil, nil, body_579928)

var cloudbillingBillingAccountsCreate* = Call_CloudbillingBillingAccountsCreate_579910(
    name: "cloudbillingBillingAccountsCreate", meth: HttpMethod.HttpPost,
    host: "cloudbilling.googleapis.com", route: "/v1/billingAccounts",
    validator: validate_CloudbillingBillingAccountsCreate_579911, base: "/",
    url: url_CloudbillingBillingAccountsCreate_579912, schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsList_579635 = ref object of OpenApiRestCall_579364
proc url_CloudbillingBillingAccountsList_579637(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CloudbillingBillingAccountsList_579636(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the billing accounts that the current authenticated user has
  ## permission to
  ## [view](https://cloud.google.com/billing/docs/how-to/billing-access).
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
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Requested page size. The maximum page size is 100; this is also the
  ## default.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : Options for how to filter the returned billing accounts.
  ## Currently this only supports filtering for
  ## [subaccounts](https://cloud.google.com/billing/docs/concepts) under a
  ## single provided reseller billing account.
  ## (e.g. "master_billing_account=billingAccounts/012345-678901-ABCDEF").
  ## Boolean algebra and other fields are not currently supported.
  ##   pageToken: JString
  ##            : A token identifying a page of results to return. This should be a
  ## `next_page_token` value returned from a previous `ListBillingAccounts`
  ## call. If unspecified, the first page of results is returned.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579749 = query.getOrDefault("key")
  valid_579749 = validateParameter(valid_579749, JString, required = false,
                                 default = nil)
  if valid_579749 != nil:
    section.add "key", valid_579749
  var valid_579763 = query.getOrDefault("prettyPrint")
  valid_579763 = validateParameter(valid_579763, JBool, required = false,
                                 default = newJBool(true))
  if valid_579763 != nil:
    section.add "prettyPrint", valid_579763
  var valid_579764 = query.getOrDefault("oauth_token")
  valid_579764 = validateParameter(valid_579764, JString, required = false,
                                 default = nil)
  if valid_579764 != nil:
    section.add "oauth_token", valid_579764
  var valid_579765 = query.getOrDefault("$.xgafv")
  valid_579765 = validateParameter(valid_579765, JString, required = false,
                                 default = newJString("1"))
  if valid_579765 != nil:
    section.add "$.xgafv", valid_579765
  var valid_579766 = query.getOrDefault("pageSize")
  valid_579766 = validateParameter(valid_579766, JInt, required = false, default = nil)
  if valid_579766 != nil:
    section.add "pageSize", valid_579766
  var valid_579767 = query.getOrDefault("alt")
  valid_579767 = validateParameter(valid_579767, JString, required = false,
                                 default = newJString("json"))
  if valid_579767 != nil:
    section.add "alt", valid_579767
  var valid_579768 = query.getOrDefault("uploadType")
  valid_579768 = validateParameter(valid_579768, JString, required = false,
                                 default = nil)
  if valid_579768 != nil:
    section.add "uploadType", valid_579768
  var valid_579769 = query.getOrDefault("quotaUser")
  valid_579769 = validateParameter(valid_579769, JString, required = false,
                                 default = nil)
  if valid_579769 != nil:
    section.add "quotaUser", valid_579769
  var valid_579770 = query.getOrDefault("filter")
  valid_579770 = validateParameter(valid_579770, JString, required = false,
                                 default = nil)
  if valid_579770 != nil:
    section.add "filter", valid_579770
  var valid_579771 = query.getOrDefault("pageToken")
  valid_579771 = validateParameter(valid_579771, JString, required = false,
                                 default = nil)
  if valid_579771 != nil:
    section.add "pageToken", valid_579771
  var valid_579772 = query.getOrDefault("callback")
  valid_579772 = validateParameter(valid_579772, JString, required = false,
                                 default = nil)
  if valid_579772 != nil:
    section.add "callback", valid_579772
  var valid_579773 = query.getOrDefault("fields")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "fields", valid_579773
  var valid_579774 = query.getOrDefault("access_token")
  valid_579774 = validateParameter(valid_579774, JString, required = false,
                                 default = nil)
  if valid_579774 != nil:
    section.add "access_token", valid_579774
  var valid_579775 = query.getOrDefault("upload_protocol")
  valid_579775 = validateParameter(valid_579775, JString, required = false,
                                 default = nil)
  if valid_579775 != nil:
    section.add "upload_protocol", valid_579775
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579798: Call_CloudbillingBillingAccountsList_579635;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the billing accounts that the current authenticated user has
  ## permission to
  ## [view](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  let valid = call_579798.validator(path, query, header, formData, body)
  let scheme = call_579798.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579798.url(scheme.get, call_579798.host, call_579798.base,
                         call_579798.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579798, url, valid)

proc call*(call_579869: Call_CloudbillingBillingAccountsList_579635;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; filter: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudbillingBillingAccountsList
  ## Lists the billing accounts that the current authenticated user has
  ## permission to
  ## [view](https://cloud.google.com/billing/docs/how-to/billing-access).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested page size. The maximum page size is 100; this is also the
  ## default.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : Options for how to filter the returned billing accounts.
  ## Currently this only supports filtering for
  ## [subaccounts](https://cloud.google.com/billing/docs/concepts) under a
  ## single provided reseller billing account.
  ## (e.g. "master_billing_account=billingAccounts/012345-678901-ABCDEF").
  ## Boolean algebra and other fields are not currently supported.
  ##   pageToken: string
  ##            : A token identifying a page of results to return. This should be a
  ## `next_page_token` value returned from a previous `ListBillingAccounts`
  ## call. If unspecified, the first page of results is returned.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579870 = newJObject()
  add(query_579870, "key", newJString(key))
  add(query_579870, "prettyPrint", newJBool(prettyPrint))
  add(query_579870, "oauth_token", newJString(oauthToken))
  add(query_579870, "$.xgafv", newJString(Xgafv))
  add(query_579870, "pageSize", newJInt(pageSize))
  add(query_579870, "alt", newJString(alt))
  add(query_579870, "uploadType", newJString(uploadType))
  add(query_579870, "quotaUser", newJString(quotaUser))
  add(query_579870, "filter", newJString(filter))
  add(query_579870, "pageToken", newJString(pageToken))
  add(query_579870, "callback", newJString(callback))
  add(query_579870, "fields", newJString(fields))
  add(query_579870, "access_token", newJString(accessToken))
  add(query_579870, "upload_protocol", newJString(uploadProtocol))
  result = call_579869.call(nil, query_579870, nil, nil, nil)

var cloudbillingBillingAccountsList* = Call_CloudbillingBillingAccountsList_579635(
    name: "cloudbillingBillingAccountsList", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/billingAccounts",
    validator: validate_CloudbillingBillingAccountsList_579636, base: "/",
    url: url_CloudbillingBillingAccountsList_579637, schemes: {Scheme.Https})
type
  Call_CloudbillingServicesList_579929 = ref object of OpenApiRestCall_579364
proc url_CloudbillingServicesList_579931(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CloudbillingServicesList_579930(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all public cloud services.
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
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Requested page size. Defaults to 5000.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A token identifying a page of results to return. This should be a
  ## `next_page_token` value returned from a previous `ListServices`
  ## call. If unspecified, the first page of results is returned.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579932 = query.getOrDefault("key")
  valid_579932 = validateParameter(valid_579932, JString, required = false,
                                 default = nil)
  if valid_579932 != nil:
    section.add "key", valid_579932
  var valid_579933 = query.getOrDefault("prettyPrint")
  valid_579933 = validateParameter(valid_579933, JBool, required = false,
                                 default = newJBool(true))
  if valid_579933 != nil:
    section.add "prettyPrint", valid_579933
  var valid_579934 = query.getOrDefault("oauth_token")
  valid_579934 = validateParameter(valid_579934, JString, required = false,
                                 default = nil)
  if valid_579934 != nil:
    section.add "oauth_token", valid_579934
  var valid_579935 = query.getOrDefault("$.xgafv")
  valid_579935 = validateParameter(valid_579935, JString, required = false,
                                 default = newJString("1"))
  if valid_579935 != nil:
    section.add "$.xgafv", valid_579935
  var valid_579936 = query.getOrDefault("pageSize")
  valid_579936 = validateParameter(valid_579936, JInt, required = false, default = nil)
  if valid_579936 != nil:
    section.add "pageSize", valid_579936
  var valid_579937 = query.getOrDefault("alt")
  valid_579937 = validateParameter(valid_579937, JString, required = false,
                                 default = newJString("json"))
  if valid_579937 != nil:
    section.add "alt", valid_579937
  var valid_579938 = query.getOrDefault("uploadType")
  valid_579938 = validateParameter(valid_579938, JString, required = false,
                                 default = nil)
  if valid_579938 != nil:
    section.add "uploadType", valid_579938
  var valid_579939 = query.getOrDefault("quotaUser")
  valid_579939 = validateParameter(valid_579939, JString, required = false,
                                 default = nil)
  if valid_579939 != nil:
    section.add "quotaUser", valid_579939
  var valid_579940 = query.getOrDefault("pageToken")
  valid_579940 = validateParameter(valid_579940, JString, required = false,
                                 default = nil)
  if valid_579940 != nil:
    section.add "pageToken", valid_579940
  var valid_579941 = query.getOrDefault("callback")
  valid_579941 = validateParameter(valid_579941, JString, required = false,
                                 default = nil)
  if valid_579941 != nil:
    section.add "callback", valid_579941
  var valid_579942 = query.getOrDefault("fields")
  valid_579942 = validateParameter(valid_579942, JString, required = false,
                                 default = nil)
  if valid_579942 != nil:
    section.add "fields", valid_579942
  var valid_579943 = query.getOrDefault("access_token")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = nil)
  if valid_579943 != nil:
    section.add "access_token", valid_579943
  var valid_579944 = query.getOrDefault("upload_protocol")
  valid_579944 = validateParameter(valid_579944, JString, required = false,
                                 default = nil)
  if valid_579944 != nil:
    section.add "upload_protocol", valid_579944
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579945: Call_CloudbillingServicesList_579929; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all public cloud services.
  ## 
  let valid = call_579945.validator(path, query, header, formData, body)
  let scheme = call_579945.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579945.url(scheme.get, call_579945.host, call_579945.base,
                         call_579945.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579945, url, valid)

proc call*(call_579946: Call_CloudbillingServicesList_579929; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudbillingServicesList
  ## Lists all public cloud services.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested page size. Defaults to 5000.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : A token identifying a page of results to return. This should be a
  ## `next_page_token` value returned from a previous `ListServices`
  ## call. If unspecified, the first page of results is returned.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579947 = newJObject()
  add(query_579947, "key", newJString(key))
  add(query_579947, "prettyPrint", newJBool(prettyPrint))
  add(query_579947, "oauth_token", newJString(oauthToken))
  add(query_579947, "$.xgafv", newJString(Xgafv))
  add(query_579947, "pageSize", newJInt(pageSize))
  add(query_579947, "alt", newJString(alt))
  add(query_579947, "uploadType", newJString(uploadType))
  add(query_579947, "quotaUser", newJString(quotaUser))
  add(query_579947, "pageToken", newJString(pageToken))
  add(query_579947, "callback", newJString(callback))
  add(query_579947, "fields", newJString(fields))
  add(query_579947, "access_token", newJString(accessToken))
  add(query_579947, "upload_protocol", newJString(uploadProtocol))
  result = call_579946.call(nil, query_579947, nil, nil, nil)

var cloudbillingServicesList* = Call_CloudbillingServicesList_579929(
    name: "cloudbillingServicesList", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/services",
    validator: validate_CloudbillingServicesList_579930, base: "/",
    url: url_CloudbillingServicesList_579931, schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsGet_579948 = ref object of OpenApiRestCall_579364
proc url_CloudbillingBillingAccountsGet_579950(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudbillingBillingAccountsGet_579949(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a billing account. The current authenticated user
  ## must be a [viewer of the billing
  ## account](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the billing account to retrieve. For example,
  ## `billingAccounts/012345-567890-ABCDEF`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579965 = path.getOrDefault("name")
  valid_579965 = validateParameter(valid_579965, JString, required = true,
                                 default = nil)
  if valid_579965 != nil:
    section.add "name", valid_579965
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579966 = query.getOrDefault("key")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "key", valid_579966
  var valid_579967 = query.getOrDefault("prettyPrint")
  valid_579967 = validateParameter(valid_579967, JBool, required = false,
                                 default = newJBool(true))
  if valid_579967 != nil:
    section.add "prettyPrint", valid_579967
  var valid_579968 = query.getOrDefault("oauth_token")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "oauth_token", valid_579968
  var valid_579969 = query.getOrDefault("$.xgafv")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = newJString("1"))
  if valid_579969 != nil:
    section.add "$.xgafv", valid_579969
  var valid_579970 = query.getOrDefault("alt")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = newJString("json"))
  if valid_579970 != nil:
    section.add "alt", valid_579970
  var valid_579971 = query.getOrDefault("uploadType")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "uploadType", valid_579971
  var valid_579972 = query.getOrDefault("quotaUser")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "quotaUser", valid_579972
  var valid_579973 = query.getOrDefault("callback")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "callback", valid_579973
  var valid_579974 = query.getOrDefault("fields")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "fields", valid_579974
  var valid_579975 = query.getOrDefault("access_token")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "access_token", valid_579975
  var valid_579976 = query.getOrDefault("upload_protocol")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "upload_protocol", valid_579976
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579977: Call_CloudbillingBillingAccountsGet_579948; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a billing account. The current authenticated user
  ## must be a [viewer of the billing
  ## account](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  let valid = call_579977.validator(path, query, header, formData, body)
  let scheme = call_579977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579977.url(scheme.get, call_579977.host, call_579977.base,
                         call_579977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579977, url, valid)

proc call*(call_579978: Call_CloudbillingBillingAccountsGet_579948; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudbillingBillingAccountsGet
  ## Gets information about a billing account. The current authenticated user
  ## must be a [viewer of the billing
  ## account](https://cloud.google.com/billing/docs/how-to/billing-access).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the billing account to retrieve. For example,
  ## `billingAccounts/012345-567890-ABCDEF`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579979 = newJObject()
  var query_579980 = newJObject()
  add(query_579980, "key", newJString(key))
  add(query_579980, "prettyPrint", newJBool(prettyPrint))
  add(query_579980, "oauth_token", newJString(oauthToken))
  add(query_579980, "$.xgafv", newJString(Xgafv))
  add(query_579980, "alt", newJString(alt))
  add(query_579980, "uploadType", newJString(uploadType))
  add(query_579980, "quotaUser", newJString(quotaUser))
  add(path_579979, "name", newJString(name))
  add(query_579980, "callback", newJString(callback))
  add(query_579980, "fields", newJString(fields))
  add(query_579980, "access_token", newJString(accessToken))
  add(query_579980, "upload_protocol", newJString(uploadProtocol))
  result = call_579978.call(path_579979, query_579980, nil, nil, nil)

var cloudbillingBillingAccountsGet* = Call_CloudbillingBillingAccountsGet_579948(
    name: "cloudbillingBillingAccountsGet", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudbillingBillingAccountsGet_579949, base: "/",
    url: url_CloudbillingBillingAccountsGet_579950, schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsPatch_579981 = ref object of OpenApiRestCall_579364
proc url_CloudbillingBillingAccountsPatch_579983(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudbillingBillingAccountsPatch_579982(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a billing account's fields.
  ## Currently the only field that can be edited is `display_name`.
  ## The current authenticated user must have the `billing.accounts.update`
  ## IAM permission, which is typically given to the
  ## [administrator](https://cloud.google.com/billing/docs/how-to/billing-access)
  ## of the billing account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the billing account resource to be updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579984 = path.getOrDefault("name")
  valid_579984 = validateParameter(valid_579984, JString, required = true,
                                 default = nil)
  if valid_579984 != nil:
    section.add "name", valid_579984
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: JString
  ##             : The update mask applied to the resource.
  ## Only "display_name" is currently supported.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
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
  var valid_579987 = query.getOrDefault("oauth_token")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "oauth_token", valid_579987
  var valid_579988 = query.getOrDefault("$.xgafv")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = newJString("1"))
  if valid_579988 != nil:
    section.add "$.xgafv", valid_579988
  var valid_579989 = query.getOrDefault("alt")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = newJString("json"))
  if valid_579989 != nil:
    section.add "alt", valid_579989
  var valid_579990 = query.getOrDefault("uploadType")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "uploadType", valid_579990
  var valid_579991 = query.getOrDefault("quotaUser")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "quotaUser", valid_579991
  var valid_579992 = query.getOrDefault("updateMask")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "updateMask", valid_579992
  var valid_579993 = query.getOrDefault("callback")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "callback", valid_579993
  var valid_579994 = query.getOrDefault("fields")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "fields", valid_579994
  var valid_579995 = query.getOrDefault("access_token")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "access_token", valid_579995
  var valid_579996 = query.getOrDefault("upload_protocol")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "upload_protocol", valid_579996
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

proc call*(call_579998: Call_CloudbillingBillingAccountsPatch_579981;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a billing account's fields.
  ## Currently the only field that can be edited is `display_name`.
  ## The current authenticated user must have the `billing.accounts.update`
  ## IAM permission, which is typically given to the
  ## [administrator](https://cloud.google.com/billing/docs/how-to/billing-access)
  ## of the billing account.
  ## 
  let valid = call_579998.validator(path, query, header, formData, body)
  let scheme = call_579998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579998.url(scheme.get, call_579998.host, call_579998.base,
                         call_579998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579998, url, valid)

proc call*(call_579999: Call_CloudbillingBillingAccountsPatch_579981; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; updateMask: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudbillingBillingAccountsPatch
  ## Updates a billing account's fields.
  ## Currently the only field that can be edited is `display_name`.
  ## The current authenticated user must have the `billing.accounts.update`
  ## IAM permission, which is typically given to the
  ## [administrator](https://cloud.google.com/billing/docs/how-to/billing-access)
  ## of the billing account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the billing account resource to be updated.
  ##   updateMask: string
  ##             : The update mask applied to the resource.
  ## Only "display_name" is currently supported.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580000 = newJObject()
  var query_580001 = newJObject()
  var body_580002 = newJObject()
  add(query_580001, "key", newJString(key))
  add(query_580001, "prettyPrint", newJBool(prettyPrint))
  add(query_580001, "oauth_token", newJString(oauthToken))
  add(query_580001, "$.xgafv", newJString(Xgafv))
  add(query_580001, "alt", newJString(alt))
  add(query_580001, "uploadType", newJString(uploadType))
  add(query_580001, "quotaUser", newJString(quotaUser))
  add(path_580000, "name", newJString(name))
  add(query_580001, "updateMask", newJString(updateMask))
  if body != nil:
    body_580002 = body
  add(query_580001, "callback", newJString(callback))
  add(query_580001, "fields", newJString(fields))
  add(query_580001, "access_token", newJString(accessToken))
  add(query_580001, "upload_protocol", newJString(uploadProtocol))
  result = call_579999.call(path_580000, query_580001, nil, nil, body_580002)

var cloudbillingBillingAccountsPatch* = Call_CloudbillingBillingAccountsPatch_579981(
    name: "cloudbillingBillingAccountsPatch", meth: HttpMethod.HttpPatch,
    host: "cloudbilling.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudbillingBillingAccountsPatch_579982, base: "/",
    url: url_CloudbillingBillingAccountsPatch_579983, schemes: {Scheme.Https})
type
  Call_CloudbillingProjectsUpdateBillingInfo_580022 = ref object of OpenApiRestCall_579364
proc url_CloudbillingProjectsUpdateBillingInfo_580024(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/billingInfo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudbillingProjectsUpdateBillingInfo_580023(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets or updates the billing account associated with a project. You specify
  ## the new billing account by setting the `billing_account_name` in the
  ## `ProjectBillingInfo` resource to the resource name of a billing account.
  ## Associating a project with an open billing account enables billing on the
  ## project and allows charges for resource usage. If the project already had a
  ## billing account, this method changes the billing account used for resource
  ## usage charges.
  ## 
  ## *Note:* Incurred charges that have not yet been reported in the transaction
  ## history of the GCP Console might be billed to the new billing
  ## account, even if the charge occurred before the new billing account was
  ## assigned to the project.
  ## 
  ## The current authenticated user must have ownership privileges for both the
  ## [project](https://cloud.google.com/docs/permissions-overview#h.bgs0oxofvnoo
  ## ) and the [billing
  ## account](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  ## You can disable billing on the project by setting the
  ## `billing_account_name` field to empty. This action disassociates the
  ## current billing account from the project. Any billable activity of your
  ## in-use services will stop, and your application could stop functioning as
  ## expected. Any unbilled charges to date will be billed to the previously
  ## associated account. The current authenticated user must be either an owner
  ## of the project or an owner of the billing account for the project.
  ## 
  ## Note that associating a project with a *closed* billing account will have
  ## much the same effect as disabling billing on the project: any paid
  ## resources used by the project will be shut down. Thus, unless you wish to
  ## disable billing, you should always call this method with the name of an
  ## *open* billing account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the project associated with the billing information
  ## that you want to update. For example, `projects/tokyo-rain-123`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580025 = path.getOrDefault("name")
  valid_580025 = validateParameter(valid_580025, JString, required = true,
                                 default = nil)
  if valid_580025 != nil:
    section.add "name", valid_580025
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580026 = query.getOrDefault("key")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "key", valid_580026
  var valid_580027 = query.getOrDefault("prettyPrint")
  valid_580027 = validateParameter(valid_580027, JBool, required = false,
                                 default = newJBool(true))
  if valid_580027 != nil:
    section.add "prettyPrint", valid_580027
  var valid_580028 = query.getOrDefault("oauth_token")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "oauth_token", valid_580028
  var valid_580029 = query.getOrDefault("$.xgafv")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = newJString("1"))
  if valid_580029 != nil:
    section.add "$.xgafv", valid_580029
  var valid_580030 = query.getOrDefault("alt")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = newJString("json"))
  if valid_580030 != nil:
    section.add "alt", valid_580030
  var valid_580031 = query.getOrDefault("uploadType")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "uploadType", valid_580031
  var valid_580032 = query.getOrDefault("quotaUser")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "quotaUser", valid_580032
  var valid_580033 = query.getOrDefault("callback")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "callback", valid_580033
  var valid_580034 = query.getOrDefault("fields")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "fields", valid_580034
  var valid_580035 = query.getOrDefault("access_token")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "access_token", valid_580035
  var valid_580036 = query.getOrDefault("upload_protocol")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "upload_protocol", valid_580036
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

proc call*(call_580038: Call_CloudbillingProjectsUpdateBillingInfo_580022;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets or updates the billing account associated with a project. You specify
  ## the new billing account by setting the `billing_account_name` in the
  ## `ProjectBillingInfo` resource to the resource name of a billing account.
  ## Associating a project with an open billing account enables billing on the
  ## project and allows charges for resource usage. If the project already had a
  ## billing account, this method changes the billing account used for resource
  ## usage charges.
  ## 
  ## *Note:* Incurred charges that have not yet been reported in the transaction
  ## history of the GCP Console might be billed to the new billing
  ## account, even if the charge occurred before the new billing account was
  ## assigned to the project.
  ## 
  ## The current authenticated user must have ownership privileges for both the
  ## [project](https://cloud.google.com/docs/permissions-overview#h.bgs0oxofvnoo
  ## ) and the [billing
  ## account](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  ## You can disable billing on the project by setting the
  ## `billing_account_name` field to empty. This action disassociates the
  ## current billing account from the project. Any billable activity of your
  ## in-use services will stop, and your application could stop functioning as
  ## expected. Any unbilled charges to date will be billed to the previously
  ## associated account. The current authenticated user must be either an owner
  ## of the project or an owner of the billing account for the project.
  ## 
  ## Note that associating a project with a *closed* billing account will have
  ## much the same effect as disabling billing on the project: any paid
  ## resources used by the project will be shut down. Thus, unless you wish to
  ## disable billing, you should always call this method with the name of an
  ## *open* billing account.
  ## 
  let valid = call_580038.validator(path, query, header, formData, body)
  let scheme = call_580038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580038.url(scheme.get, call_580038.host, call_580038.base,
                         call_580038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580038, url, valid)

proc call*(call_580039: Call_CloudbillingProjectsUpdateBillingInfo_580022;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudbillingProjectsUpdateBillingInfo
  ## Sets or updates the billing account associated with a project. You specify
  ## the new billing account by setting the `billing_account_name` in the
  ## `ProjectBillingInfo` resource to the resource name of a billing account.
  ## Associating a project with an open billing account enables billing on the
  ## project and allows charges for resource usage. If the project already had a
  ## billing account, this method changes the billing account used for resource
  ## usage charges.
  ## 
  ## *Note:* Incurred charges that have not yet been reported in the transaction
  ## history of the GCP Console might be billed to the new billing
  ## account, even if the charge occurred before the new billing account was
  ## assigned to the project.
  ## 
  ## The current authenticated user must have ownership privileges for both the
  ## [project](https://cloud.google.com/docs/permissions-overview#h.bgs0oxofvnoo
  ## ) and the [billing
  ## account](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  ## You can disable billing on the project by setting the
  ## `billing_account_name` field to empty. This action disassociates the
  ## current billing account from the project. Any billable activity of your
  ## in-use services will stop, and your application could stop functioning as
  ## expected. Any unbilled charges to date will be billed to the previously
  ## associated account. The current authenticated user must be either an owner
  ## of the project or an owner of the billing account for the project.
  ## 
  ## Note that associating a project with a *closed* billing account will have
  ## much the same effect as disabling billing on the project: any paid
  ## resources used by the project will be shut down. Thus, unless you wish to
  ## disable billing, you should always call this method with the name of an
  ## *open* billing account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the project associated with the billing information
  ## that you want to update. For example, `projects/tokyo-rain-123`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580040 = newJObject()
  var query_580041 = newJObject()
  var body_580042 = newJObject()
  add(query_580041, "key", newJString(key))
  add(query_580041, "prettyPrint", newJBool(prettyPrint))
  add(query_580041, "oauth_token", newJString(oauthToken))
  add(query_580041, "$.xgafv", newJString(Xgafv))
  add(query_580041, "alt", newJString(alt))
  add(query_580041, "uploadType", newJString(uploadType))
  add(query_580041, "quotaUser", newJString(quotaUser))
  add(path_580040, "name", newJString(name))
  if body != nil:
    body_580042 = body
  add(query_580041, "callback", newJString(callback))
  add(query_580041, "fields", newJString(fields))
  add(query_580041, "access_token", newJString(accessToken))
  add(query_580041, "upload_protocol", newJString(uploadProtocol))
  result = call_580039.call(path_580040, query_580041, nil, nil, body_580042)

var cloudbillingProjectsUpdateBillingInfo* = Call_CloudbillingProjectsUpdateBillingInfo_580022(
    name: "cloudbillingProjectsUpdateBillingInfo", meth: HttpMethod.HttpPut,
    host: "cloudbilling.googleapis.com", route: "/v1/{name}/billingInfo",
    validator: validate_CloudbillingProjectsUpdateBillingInfo_580023, base: "/",
    url: url_CloudbillingProjectsUpdateBillingInfo_580024, schemes: {Scheme.Https})
type
  Call_CloudbillingProjectsGetBillingInfo_580003 = ref object of OpenApiRestCall_579364
proc url_CloudbillingProjectsGetBillingInfo_580005(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/billingInfo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudbillingProjectsGetBillingInfo_580004(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the billing information for a project. The current authenticated user
  ## must have [permission to view the
  ## project](https://cloud.google.com/docs/permissions-overview#h.bgs0oxofvnoo
  ## ).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the project for which billing information is
  ## retrieved. For example, `projects/tokyo-rain-123`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580006 = path.getOrDefault("name")
  valid_580006 = validateParameter(valid_580006, JString, required = true,
                                 default = nil)
  if valid_580006 != nil:
    section.add "name", valid_580006
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580007 = query.getOrDefault("key")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "key", valid_580007
  var valid_580008 = query.getOrDefault("prettyPrint")
  valid_580008 = validateParameter(valid_580008, JBool, required = false,
                                 default = newJBool(true))
  if valid_580008 != nil:
    section.add "prettyPrint", valid_580008
  var valid_580009 = query.getOrDefault("oauth_token")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "oauth_token", valid_580009
  var valid_580010 = query.getOrDefault("$.xgafv")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = newJString("1"))
  if valid_580010 != nil:
    section.add "$.xgafv", valid_580010
  var valid_580011 = query.getOrDefault("alt")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = newJString("json"))
  if valid_580011 != nil:
    section.add "alt", valid_580011
  var valid_580012 = query.getOrDefault("uploadType")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "uploadType", valid_580012
  var valid_580013 = query.getOrDefault("quotaUser")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "quotaUser", valid_580013
  var valid_580014 = query.getOrDefault("callback")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "callback", valid_580014
  var valid_580015 = query.getOrDefault("fields")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "fields", valid_580015
  var valid_580016 = query.getOrDefault("access_token")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "access_token", valid_580016
  var valid_580017 = query.getOrDefault("upload_protocol")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "upload_protocol", valid_580017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580018: Call_CloudbillingProjectsGetBillingInfo_580003;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the billing information for a project. The current authenticated user
  ## must have [permission to view the
  ## project](https://cloud.google.com/docs/permissions-overview#h.bgs0oxofvnoo
  ## ).
  ## 
  let valid = call_580018.validator(path, query, header, formData, body)
  let scheme = call_580018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580018.url(scheme.get, call_580018.host, call_580018.base,
                         call_580018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580018, url, valid)

proc call*(call_580019: Call_CloudbillingProjectsGetBillingInfo_580003;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudbillingProjectsGetBillingInfo
  ## Gets the billing information for a project. The current authenticated user
  ## must have [permission to view the
  ## project](https://cloud.google.com/docs/permissions-overview#h.bgs0oxofvnoo
  ## ).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the project for which billing information is
  ## retrieved. For example, `projects/tokyo-rain-123`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580020 = newJObject()
  var query_580021 = newJObject()
  add(query_580021, "key", newJString(key))
  add(query_580021, "prettyPrint", newJBool(prettyPrint))
  add(query_580021, "oauth_token", newJString(oauthToken))
  add(query_580021, "$.xgafv", newJString(Xgafv))
  add(query_580021, "alt", newJString(alt))
  add(query_580021, "uploadType", newJString(uploadType))
  add(query_580021, "quotaUser", newJString(quotaUser))
  add(path_580020, "name", newJString(name))
  add(query_580021, "callback", newJString(callback))
  add(query_580021, "fields", newJString(fields))
  add(query_580021, "access_token", newJString(accessToken))
  add(query_580021, "upload_protocol", newJString(uploadProtocol))
  result = call_580019.call(path_580020, query_580021, nil, nil, nil)

var cloudbillingProjectsGetBillingInfo* = Call_CloudbillingProjectsGetBillingInfo_580003(
    name: "cloudbillingProjectsGetBillingInfo", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/{name}/billingInfo",
    validator: validate_CloudbillingProjectsGetBillingInfo_580004, base: "/",
    url: url_CloudbillingProjectsGetBillingInfo_580005, schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsProjectsList_580043 = ref object of OpenApiRestCall_579364
proc url_CloudbillingBillingAccountsProjectsList_580045(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/projects")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudbillingBillingAccountsProjectsList_580044(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the projects associated with a billing account. The current
  ## authenticated user must have the `billing.resourceAssociations.list` IAM
  ## permission, which is often given to billing account
  ## [viewers](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the billing account associated with the projects that
  ## you want to list. For example, `billingAccounts/012345-567890-ABCDEF`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580046 = path.getOrDefault("name")
  valid_580046 = validateParameter(valid_580046, JString, required = true,
                                 default = nil)
  if valid_580046 != nil:
    section.add "name", valid_580046
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Requested page size. The maximum page size is 100; this is also the
  ## default.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A token identifying a page of results to be returned. This should be a
  ## `next_page_token` value returned from a previous `ListProjectBillingInfo`
  ## call. If unspecified, the first page of results is returned.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580047 = query.getOrDefault("key")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "key", valid_580047
  var valid_580048 = query.getOrDefault("prettyPrint")
  valid_580048 = validateParameter(valid_580048, JBool, required = false,
                                 default = newJBool(true))
  if valid_580048 != nil:
    section.add "prettyPrint", valid_580048
  var valid_580049 = query.getOrDefault("oauth_token")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "oauth_token", valid_580049
  var valid_580050 = query.getOrDefault("$.xgafv")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = newJString("1"))
  if valid_580050 != nil:
    section.add "$.xgafv", valid_580050
  var valid_580051 = query.getOrDefault("pageSize")
  valid_580051 = validateParameter(valid_580051, JInt, required = false, default = nil)
  if valid_580051 != nil:
    section.add "pageSize", valid_580051
  var valid_580052 = query.getOrDefault("alt")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = newJString("json"))
  if valid_580052 != nil:
    section.add "alt", valid_580052
  var valid_580053 = query.getOrDefault("uploadType")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "uploadType", valid_580053
  var valid_580054 = query.getOrDefault("quotaUser")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "quotaUser", valid_580054
  var valid_580055 = query.getOrDefault("pageToken")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "pageToken", valid_580055
  var valid_580056 = query.getOrDefault("callback")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "callback", valid_580056
  var valid_580057 = query.getOrDefault("fields")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "fields", valid_580057
  var valid_580058 = query.getOrDefault("access_token")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "access_token", valid_580058
  var valid_580059 = query.getOrDefault("upload_protocol")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "upload_protocol", valid_580059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580060: Call_CloudbillingBillingAccountsProjectsList_580043;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the projects associated with a billing account. The current
  ## authenticated user must have the `billing.resourceAssociations.list` IAM
  ## permission, which is often given to billing account
  ## [viewers](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  let valid = call_580060.validator(path, query, header, formData, body)
  let scheme = call_580060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580060.url(scheme.get, call_580060.host, call_580060.base,
                         call_580060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580060, url, valid)

proc call*(call_580061: Call_CloudbillingBillingAccountsProjectsList_580043;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudbillingBillingAccountsProjectsList
  ## Lists the projects associated with a billing account. The current
  ## authenticated user must have the `billing.resourceAssociations.list` IAM
  ## permission, which is often given to billing account
  ## [viewers](https://cloud.google.com/billing/docs/how-to/billing-access).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested page size. The maximum page size is 100; this is also the
  ## default.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the billing account associated with the projects that
  ## you want to list. For example, `billingAccounts/012345-567890-ABCDEF`.
  ##   pageToken: string
  ##            : A token identifying a page of results to be returned. This should be a
  ## `next_page_token` value returned from a previous `ListProjectBillingInfo`
  ## call. If unspecified, the first page of results is returned.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580062 = newJObject()
  var query_580063 = newJObject()
  add(query_580063, "key", newJString(key))
  add(query_580063, "prettyPrint", newJBool(prettyPrint))
  add(query_580063, "oauth_token", newJString(oauthToken))
  add(query_580063, "$.xgafv", newJString(Xgafv))
  add(query_580063, "pageSize", newJInt(pageSize))
  add(query_580063, "alt", newJString(alt))
  add(query_580063, "uploadType", newJString(uploadType))
  add(query_580063, "quotaUser", newJString(quotaUser))
  add(path_580062, "name", newJString(name))
  add(query_580063, "pageToken", newJString(pageToken))
  add(query_580063, "callback", newJString(callback))
  add(query_580063, "fields", newJString(fields))
  add(query_580063, "access_token", newJString(accessToken))
  add(query_580063, "upload_protocol", newJString(uploadProtocol))
  result = call_580061.call(path_580062, query_580063, nil, nil, nil)

var cloudbillingBillingAccountsProjectsList* = Call_CloudbillingBillingAccountsProjectsList_580043(
    name: "cloudbillingBillingAccountsProjectsList", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/{name}/projects",
    validator: validate_CloudbillingBillingAccountsProjectsList_580044, base: "/",
    url: url_CloudbillingBillingAccountsProjectsList_580045,
    schemes: {Scheme.Https})
type
  Call_CloudbillingServicesSkusList_580064 = ref object of OpenApiRestCall_579364
proc url_CloudbillingServicesSkusList_580066(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudbillingServicesSkusList_580065(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all publicly available SKUs for a given cloud service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the service.
  ## Example: "services/DA34-426B-A397"
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580067 = path.getOrDefault("parent")
  valid_580067 = validateParameter(valid_580067, JString, required = true,
                                 default = nil)
  if valid_580067 != nil:
    section.add "parent", valid_580067
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Requested page size. Defaults to 5000.
  ##   startTime: JString
  ##            : Optional inclusive start time of the time range for which the pricing
  ## versions will be returned. Timestamps in the future are not allowed.
  ## The time range has to be within a single calendar month in
  ## America/Los_Angeles timezone. Time range as a whole is optional. If not
  ## specified, the latest pricing will be returned (up to 12 hours old at
  ## most).
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A token identifying a page of results to return. This should be a
  ## `next_page_token` value returned from a previous `ListSkus`
  ## call. If unspecified, the first page of results is returned.
  ##   currencyCode: JString
  ##               : The ISO 4217 currency code for the pricing info in the response proto.
  ## Will use the conversion rate as of start_time.
  ## Optional. If not specified USD will be used.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   endTime: JString
  ##          : Optional exclusive end time of the time range for which the pricing
  ## versions will be returned. Timestamps in the future are not allowed.
  ## The time range has to be within a single calendar month in
  ## America/Los_Angeles timezone. Time range as a whole is optional. If not
  ## specified, the latest pricing will be returned (up to 12 hours old at
  ## most).
  section = newJObject()
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
  var valid_580070 = query.getOrDefault("oauth_token")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "oauth_token", valid_580070
  var valid_580071 = query.getOrDefault("$.xgafv")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = newJString("1"))
  if valid_580071 != nil:
    section.add "$.xgafv", valid_580071
  var valid_580072 = query.getOrDefault("pageSize")
  valid_580072 = validateParameter(valid_580072, JInt, required = false, default = nil)
  if valid_580072 != nil:
    section.add "pageSize", valid_580072
  var valid_580073 = query.getOrDefault("startTime")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "startTime", valid_580073
  var valid_580074 = query.getOrDefault("alt")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = newJString("json"))
  if valid_580074 != nil:
    section.add "alt", valid_580074
  var valid_580075 = query.getOrDefault("uploadType")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "uploadType", valid_580075
  var valid_580076 = query.getOrDefault("quotaUser")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "quotaUser", valid_580076
  var valid_580077 = query.getOrDefault("pageToken")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "pageToken", valid_580077
  var valid_580078 = query.getOrDefault("currencyCode")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "currencyCode", valid_580078
  var valid_580079 = query.getOrDefault("callback")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "callback", valid_580079
  var valid_580080 = query.getOrDefault("fields")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "fields", valid_580080
  var valid_580081 = query.getOrDefault("access_token")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "access_token", valid_580081
  var valid_580082 = query.getOrDefault("upload_protocol")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "upload_protocol", valid_580082
  var valid_580083 = query.getOrDefault("endTime")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "endTime", valid_580083
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580084: Call_CloudbillingServicesSkusList_580064; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all publicly available SKUs for a given cloud service.
  ## 
  let valid = call_580084.validator(path, query, header, formData, body)
  let scheme = call_580084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580084.url(scheme.get, call_580084.host, call_580084.base,
                         call_580084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580084, url, valid)

proc call*(call_580085: Call_CloudbillingServicesSkusList_580064; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; startTime: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; currencyCode: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          endTime: string = ""): Recallable =
  ## cloudbillingServicesSkusList
  ## Lists all publicly available SKUs for a given cloud service.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested page size. Defaults to 5000.
  ##   startTime: string
  ##            : Optional inclusive start time of the time range for which the pricing
  ## versions will be returned. Timestamps in the future are not allowed.
  ## The time range has to be within a single calendar month in
  ## America/Los_Angeles timezone. Time range as a whole is optional. If not
  ## specified, the latest pricing will be returned (up to 12 hours old at
  ## most).
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : A token identifying a page of results to return. This should be a
  ## `next_page_token` value returned from a previous `ListSkus`
  ## call. If unspecified, the first page of results is returned.
  ##   currencyCode: string
  ##               : The ISO 4217 currency code for the pricing info in the response proto.
  ## Will use the conversion rate as of start_time.
  ## Optional. If not specified USD will be used.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The name of the service.
  ## Example: "services/DA34-426B-A397"
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   endTime: string
  ##          : Optional exclusive end time of the time range for which the pricing
  ## versions will be returned. Timestamps in the future are not allowed.
  ## The time range has to be within a single calendar month in
  ## America/Los_Angeles timezone. Time range as a whole is optional. If not
  ## specified, the latest pricing will be returned (up to 12 hours old at
  ## most).
  var path_580086 = newJObject()
  var query_580087 = newJObject()
  add(query_580087, "key", newJString(key))
  add(query_580087, "prettyPrint", newJBool(prettyPrint))
  add(query_580087, "oauth_token", newJString(oauthToken))
  add(query_580087, "$.xgafv", newJString(Xgafv))
  add(query_580087, "pageSize", newJInt(pageSize))
  add(query_580087, "startTime", newJString(startTime))
  add(query_580087, "alt", newJString(alt))
  add(query_580087, "uploadType", newJString(uploadType))
  add(query_580087, "quotaUser", newJString(quotaUser))
  add(query_580087, "pageToken", newJString(pageToken))
  add(query_580087, "currencyCode", newJString(currencyCode))
  add(query_580087, "callback", newJString(callback))
  add(path_580086, "parent", newJString(parent))
  add(query_580087, "fields", newJString(fields))
  add(query_580087, "access_token", newJString(accessToken))
  add(query_580087, "upload_protocol", newJString(uploadProtocol))
  add(query_580087, "endTime", newJString(endTime))
  result = call_580085.call(path_580086, query_580087, nil, nil, nil)

var cloudbillingServicesSkusList* = Call_CloudbillingServicesSkusList_580064(
    name: "cloudbillingServicesSkusList", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/{parent}/skus",
    validator: validate_CloudbillingServicesSkusList_580065, base: "/",
    url: url_CloudbillingServicesSkusList_580066, schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsGetIamPolicy_580088 = ref object of OpenApiRestCall_579364
proc url_CloudbillingBillingAccountsGetIamPolicy_580090(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudbillingBillingAccountsGetIamPolicy_580089(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the access control policy for a billing account.
  ## The caller must have the `billing.accounts.getIamPolicy` permission on the
  ## account, which is often given to billing account
  ## [viewers](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580091 = path.getOrDefault("resource")
  valid_580091 = validateParameter(valid_580091, JString, required = true,
                                 default = nil)
  if valid_580091 != nil:
    section.add "resource", valid_580091
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   options.requestedPolicyVersion: JInt
  ##                                 : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580092 = query.getOrDefault("key")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "key", valid_580092
  var valid_580093 = query.getOrDefault("prettyPrint")
  valid_580093 = validateParameter(valid_580093, JBool, required = false,
                                 default = newJBool(true))
  if valid_580093 != nil:
    section.add "prettyPrint", valid_580093
  var valid_580094 = query.getOrDefault("oauth_token")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "oauth_token", valid_580094
  var valid_580095 = query.getOrDefault("$.xgafv")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = newJString("1"))
  if valid_580095 != nil:
    section.add "$.xgafv", valid_580095
  var valid_580096 = query.getOrDefault("options.requestedPolicyVersion")
  valid_580096 = validateParameter(valid_580096, JInt, required = false, default = nil)
  if valid_580096 != nil:
    section.add "options.requestedPolicyVersion", valid_580096
  var valid_580097 = query.getOrDefault("alt")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = newJString("json"))
  if valid_580097 != nil:
    section.add "alt", valid_580097
  var valid_580098 = query.getOrDefault("uploadType")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "uploadType", valid_580098
  var valid_580099 = query.getOrDefault("quotaUser")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "quotaUser", valid_580099
  var valid_580100 = query.getOrDefault("callback")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "callback", valid_580100
  var valid_580101 = query.getOrDefault("fields")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "fields", valid_580101
  var valid_580102 = query.getOrDefault("access_token")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "access_token", valid_580102
  var valid_580103 = query.getOrDefault("upload_protocol")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "upload_protocol", valid_580103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580104: Call_CloudbillingBillingAccountsGetIamPolicy_580088;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a billing account.
  ## The caller must have the `billing.accounts.getIamPolicy` permission on the
  ## account, which is often given to billing account
  ## [viewers](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  let valid = call_580104.validator(path, query, header, formData, body)
  let scheme = call_580104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580104.url(scheme.get, call_580104.host, call_580104.base,
                         call_580104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580104, url, valid)

proc call*(call_580105: Call_CloudbillingBillingAccountsGetIamPolicy_580088;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1";
          optionsRequestedPolicyVersion: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudbillingBillingAccountsGetIamPolicy
  ## Gets the access control policy for a billing account.
  ## The caller must have the `billing.accounts.getIamPolicy` permission on the
  ## account, which is often given to billing account
  ## [viewers](https://cloud.google.com/billing/docs/how-to/billing-access).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   optionsRequestedPolicyVersion: int
  ##                                : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580106 = newJObject()
  var query_580107 = newJObject()
  add(query_580107, "key", newJString(key))
  add(query_580107, "prettyPrint", newJBool(prettyPrint))
  add(query_580107, "oauth_token", newJString(oauthToken))
  add(query_580107, "$.xgafv", newJString(Xgafv))
  add(query_580107, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_580107, "alt", newJString(alt))
  add(query_580107, "uploadType", newJString(uploadType))
  add(query_580107, "quotaUser", newJString(quotaUser))
  add(path_580106, "resource", newJString(resource))
  add(query_580107, "callback", newJString(callback))
  add(query_580107, "fields", newJString(fields))
  add(query_580107, "access_token", newJString(accessToken))
  add(query_580107, "upload_protocol", newJString(uploadProtocol))
  result = call_580105.call(path_580106, query_580107, nil, nil, nil)

var cloudbillingBillingAccountsGetIamPolicy* = Call_CloudbillingBillingAccountsGetIamPolicy_580088(
    name: "cloudbillingBillingAccountsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/{resource}:getIamPolicy",
    validator: validate_CloudbillingBillingAccountsGetIamPolicy_580089, base: "/",
    url: url_CloudbillingBillingAccountsGetIamPolicy_580090,
    schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsSetIamPolicy_580108 = ref object of OpenApiRestCall_579364
proc url_CloudbillingBillingAccountsSetIamPolicy_580110(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudbillingBillingAccountsSetIamPolicy_580109(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the access control policy for a billing account. Replaces any existing
  ## policy.
  ## The caller must have the `billing.accounts.setIamPolicy` permission on the
  ## account, which is often given to billing account
  ## [administrators](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580111 = path.getOrDefault("resource")
  valid_580111 = validateParameter(valid_580111, JString, required = true,
                                 default = nil)
  if valid_580111 != nil:
    section.add "resource", valid_580111
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580112 = query.getOrDefault("key")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "key", valid_580112
  var valid_580113 = query.getOrDefault("prettyPrint")
  valid_580113 = validateParameter(valid_580113, JBool, required = false,
                                 default = newJBool(true))
  if valid_580113 != nil:
    section.add "prettyPrint", valid_580113
  var valid_580114 = query.getOrDefault("oauth_token")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "oauth_token", valid_580114
  var valid_580115 = query.getOrDefault("$.xgafv")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = newJString("1"))
  if valid_580115 != nil:
    section.add "$.xgafv", valid_580115
  var valid_580116 = query.getOrDefault("alt")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = newJString("json"))
  if valid_580116 != nil:
    section.add "alt", valid_580116
  var valid_580117 = query.getOrDefault("uploadType")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "uploadType", valid_580117
  var valid_580118 = query.getOrDefault("quotaUser")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "quotaUser", valid_580118
  var valid_580119 = query.getOrDefault("callback")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "callback", valid_580119
  var valid_580120 = query.getOrDefault("fields")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "fields", valid_580120
  var valid_580121 = query.getOrDefault("access_token")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "access_token", valid_580121
  var valid_580122 = query.getOrDefault("upload_protocol")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "upload_protocol", valid_580122
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

proc call*(call_580124: Call_CloudbillingBillingAccountsSetIamPolicy_580108;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy for a billing account. Replaces any existing
  ## policy.
  ## The caller must have the `billing.accounts.setIamPolicy` permission on the
  ## account, which is often given to billing account
  ## [administrators](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  let valid = call_580124.validator(path, query, header, formData, body)
  let scheme = call_580124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580124.url(scheme.get, call_580124.host, call_580124.base,
                         call_580124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580124, url, valid)

proc call*(call_580125: Call_CloudbillingBillingAccountsSetIamPolicy_580108;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudbillingBillingAccountsSetIamPolicy
  ## Sets the access control policy for a billing account. Replaces any existing
  ## policy.
  ## The caller must have the `billing.accounts.setIamPolicy` permission on the
  ## account, which is often given to billing account
  ## [administrators](https://cloud.google.com/billing/docs/how-to/billing-access).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580126 = newJObject()
  var query_580127 = newJObject()
  var body_580128 = newJObject()
  add(query_580127, "key", newJString(key))
  add(query_580127, "prettyPrint", newJBool(prettyPrint))
  add(query_580127, "oauth_token", newJString(oauthToken))
  add(query_580127, "$.xgafv", newJString(Xgafv))
  add(query_580127, "alt", newJString(alt))
  add(query_580127, "uploadType", newJString(uploadType))
  add(query_580127, "quotaUser", newJString(quotaUser))
  add(path_580126, "resource", newJString(resource))
  if body != nil:
    body_580128 = body
  add(query_580127, "callback", newJString(callback))
  add(query_580127, "fields", newJString(fields))
  add(query_580127, "access_token", newJString(accessToken))
  add(query_580127, "upload_protocol", newJString(uploadProtocol))
  result = call_580125.call(path_580126, query_580127, nil, nil, body_580128)

var cloudbillingBillingAccountsSetIamPolicy* = Call_CloudbillingBillingAccountsSetIamPolicy_580108(
    name: "cloudbillingBillingAccountsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "cloudbilling.googleapis.com", route: "/v1/{resource}:setIamPolicy",
    validator: validate_CloudbillingBillingAccountsSetIamPolicy_580109, base: "/",
    url: url_CloudbillingBillingAccountsSetIamPolicy_580110,
    schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsTestIamPermissions_580129 = ref object of OpenApiRestCall_579364
proc url_CloudbillingBillingAccountsTestIamPermissions_580131(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudbillingBillingAccountsTestIamPermissions_580130(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Tests the access control policy for a billing account. This method takes
  ## the resource and a set of permissions as input and returns the subset of
  ## the input permissions that the caller is allowed for that resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580132 = path.getOrDefault("resource")
  valid_580132 = validateParameter(valid_580132, JString, required = true,
                                 default = nil)
  if valid_580132 != nil:
    section.add "resource", valid_580132
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580133 = query.getOrDefault("key")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "key", valid_580133
  var valid_580134 = query.getOrDefault("prettyPrint")
  valid_580134 = validateParameter(valid_580134, JBool, required = false,
                                 default = newJBool(true))
  if valid_580134 != nil:
    section.add "prettyPrint", valid_580134
  var valid_580135 = query.getOrDefault("oauth_token")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "oauth_token", valid_580135
  var valid_580136 = query.getOrDefault("$.xgafv")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = newJString("1"))
  if valid_580136 != nil:
    section.add "$.xgafv", valid_580136
  var valid_580137 = query.getOrDefault("alt")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = newJString("json"))
  if valid_580137 != nil:
    section.add "alt", valid_580137
  var valid_580138 = query.getOrDefault("uploadType")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "uploadType", valid_580138
  var valid_580139 = query.getOrDefault("quotaUser")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "quotaUser", valid_580139
  var valid_580140 = query.getOrDefault("callback")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "callback", valid_580140
  var valid_580141 = query.getOrDefault("fields")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "fields", valid_580141
  var valid_580142 = query.getOrDefault("access_token")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "access_token", valid_580142
  var valid_580143 = query.getOrDefault("upload_protocol")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "upload_protocol", valid_580143
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

proc call*(call_580145: Call_CloudbillingBillingAccountsTestIamPermissions_580129;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Tests the access control policy for a billing account. This method takes
  ## the resource and a set of permissions as input and returns the subset of
  ## the input permissions that the caller is allowed for that resource.
  ## 
  let valid = call_580145.validator(path, query, header, formData, body)
  let scheme = call_580145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580145.url(scheme.get, call_580145.host, call_580145.base,
                         call_580145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580145, url, valid)

proc call*(call_580146: Call_CloudbillingBillingAccountsTestIamPermissions_580129;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudbillingBillingAccountsTestIamPermissions
  ## Tests the access control policy for a billing account. This method takes
  ## the resource and a set of permissions as input and returns the subset of
  ## the input permissions that the caller is allowed for that resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580147 = newJObject()
  var query_580148 = newJObject()
  var body_580149 = newJObject()
  add(query_580148, "key", newJString(key))
  add(query_580148, "prettyPrint", newJBool(prettyPrint))
  add(query_580148, "oauth_token", newJString(oauthToken))
  add(query_580148, "$.xgafv", newJString(Xgafv))
  add(query_580148, "alt", newJString(alt))
  add(query_580148, "uploadType", newJString(uploadType))
  add(query_580148, "quotaUser", newJString(quotaUser))
  add(path_580147, "resource", newJString(resource))
  if body != nil:
    body_580149 = body
  add(query_580148, "callback", newJString(callback))
  add(query_580148, "fields", newJString(fields))
  add(query_580148, "access_token", newJString(accessToken))
  add(query_580148, "upload_protocol", newJString(uploadProtocol))
  result = call_580146.call(path_580147, query_580148, nil, nil, body_580149)

var cloudbillingBillingAccountsTestIamPermissions* = Call_CloudbillingBillingAccountsTestIamPermissions_580129(
    name: "cloudbillingBillingAccountsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudbilling.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_CloudbillingBillingAccountsTestIamPermissions_580130,
    base: "/", url: url_CloudbillingBillingAccountsTestIamPermissions_580131,
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
